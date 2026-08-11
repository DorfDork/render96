--[[

    Reliable spawn sync objects

    filename: osync.lua
    version: v1.0
    author: PeachyPeach
    required: sm64coopdx v1.5.1 or later

    A small library to handle reliable sync objects spawning
    without duplication in code run by all clients.
    Packets used by this lib have the field "osync" and should
    be ignored by mods `HOOK_ON_PACKET_RECEIVE` hooks.

--]]

local _spawn_sync_object = spawn_sync_object
local tconcat = table.concat
local tsort = table.sort
local tinsert = table.insert
local tremove = table.remove
local ipairs = ipairs
local get_global_timer = get_global_timer
local get_network_area_timer = get_network_area_timer
local is_player_in_local_area = is_player_in_local_area
local network_global_index_from_local = network_global_index_from_local
local network_send_to = network_send_to

local SYNC_QUEUE_TIMEOUT = 30
local SYNC_PACKET_TIMEOUT = 30

local sSyncObjectsQueueId = nil
local sSyncObjectsQueue = {}
local sSyncObjectsPackets = {}

local function get_sync_object_queue_id(...)
    return tconcat({...}, "_")
end

--- @param context string
--- @param func function
local function spawn_sync_objects(context, func)
    if sSyncObjectsQueueId then return end

    -- Assign id
    local np = gNetworkPlayers[0]
    sSyncObjectsQueueId = get_sync_object_queue_id(np.currLevelNum, np.currAreaIndex, np.currActNum, context)

    -- Create queue if it's already allocated
    if not sSyncObjectsQueue[sSyncObjectsQueueId] then
        sSyncObjectsQueue[sSyncObjectsQueueId] = { objects = {} }
    end

    -- Run the callback
    -- This is the only place where mods are allowed
    -- to call osync.spawn_sync_object()
    func()

    sSyncObjectsQueueId = nil
end

--- @param behaviorId BehaviorId
--- @param modelId ModelExtendedId
--- @param x number
--- @param y number
--- @param z number
--- @param objSetupFunction? function
local function spawn_sync_object(behaviorId, modelId, x, y, z, objSetupFunction)
    if not sSyncObjectsQueueId then
        return
    end

    -- Add sync object to queue
    local objects = sSyncObjectsQueue[sSyncObjectsQueueId].objects
    objects[#objects+1] = {
        behaviorId = behaviorId,
        modelId = modelId,
        x = x,
        y = y,
        z = z,
        objSetupFunction = objSetupFunction,
    }
end

local function osync_clear_on_area_init()
    if get_network_area_timer() == 0 then
        sSyncObjectsQueue = {}
        sSyncObjectsPackets = {}
    end
end

--- @return table playersInArea
local function osync_get_players_in_area()

    -- Create a list of all available players
    local playersInArea = {}
    for i = 0, MAX_PLAYERS - 1 do
        local m = gMarioStates[i]
        if i == 0 or is_player_in_local_area(m) == 1 then
            playersInArea[#playersInArea+1] = {
                playerIndex = i,
                globalIndex = network_global_index_from_local(i),
                timer = m.marioObj.oTimer,
            }
        end
    end

    -- Sort them by age and playerIndex (not globalIndex!)
    tsort(playersInArea, function (a, b)
        if a.timer == b.timer then
            return a.playerIndex < b.playerIndex
        end
        return a.timer > b.timer
    end)

    return playersInArea
end

--- @param queueId string
--- @param playersInArea table
--- @return table status
local function osync_get_status(queueId, playersInArea)
    local myGlobalIndex = network_global_index_from_local(0)
    local eligible = playersInArea[1].playerIndex == 0
    local eligibleTimer = playersInArea[1].timer
    local status = {}

    -- Send a packet to all eligible players,
    -- telling if I am eligible or not
    for _, player in ipairs(playersInArea) do
        if player.timer < eligibleTimer then
            break
        end
        if player.playerIndex ~= 0 then
            network_send_to(player.playerIndex, true, {
                osync = true,
                globalIndex = myGlobalIndex,
                queueId = queueId,
                eligible = eligible,
            })
            status[player.globalIndex] = false
        end
    end

    return status
end

local function osync_init_queues()
    local t = get_global_timer()
    local playersInArea = nil
    local queuesToDelete = {}

    -- Area is now sync valid, initialize queues
    for id, queue in pairs(sSyncObjectsQueue) do
        if not queue.status then

            -- Retrieve players, status and send packets
            playersInArea = playersInArea or osync_get_players_in_area()
            local status = osync_get_status(id, playersInArea)

            -- Init queue if eligible, delete otherwise
            if playersInArea[1].playerIndex == 0 then
                queue.timestamp = t
                queue.status = status
            else
                queuesToDelete[#queuesToDelete+1] = id
            end
        end
    end

    -- Cleanup
    for _, id in ipairs(queuesToDelete) do
        sSyncObjectsQueue[id] = nil
    end
end

local function osync_update_packets()
    local t = get_global_timer()
    local packetsToDelete = {}

    -- Update queues status with received packets
    for i, p in ipairs(sSyncObjectsPackets) do
        local deletePacket = (t > p.timestamp + SYNC_PACKET_TIMEOUT)

        -- If not eligible, remove player from status
        local queue = sSyncObjectsQueue[p.queueId]
        if queue and queue.status then
            if p.eligible then
                queue.status[p.globalIndex] = true
            else
                queue.status[p.globalIndex] = nil
            end
            deletePacket = true
        end

        if deletePacket then
            tinsert(packetsToDelete, 1, i)
        end
    end

    -- Cleanup
    for _, i in ipairs(packetsToDelete) do
        tremove(sSyncObjectsPackets, i)
    end
end

local function osync_spawn_objects()
    local t = get_global_timer()
    local myGlobalIndex = network_global_index_from_local(0)
    local queuesToDelete = {}

    -- Check queues and spawn sync objects if eligible
    for id, queue in pairs(sSyncObjectsQueue) do
        local deleteQueue = (t > queue.timestamp + SYNC_QUEUE_TIMEOUT)

        -- Determine lowest global index among eligible players
        local lowestGlobalIndex = myGlobalIndex
        for globalIndex, response in pairs(queue.status) do

            -- If packet timed out, treat all missing responses as non eligible
            if not response and not deleteQueue then
                lowestGlobalIndex = nil
                break
            end
            lowestGlobalIndex = math.min(lowestGlobalIndex, globalIndex)
        end

        -- Eligible player has been chosen
        -- If it's me, spawn sync objects now
        if lowestGlobalIndex ~= nil then
            if lowestGlobalIndex == myGlobalIndex then
                for _, obj in ipairs(queue.objects) do
                    _spawn_sync_object(obj.behaviorId, obj.modelId, obj.x, obj.y, obj.z, obj.objSetupFunction)
                end
            end
            deleteQueue = true
        end

        if deleteQueue then
            queuesToDelete[#queuesToDelete+1] = id
        end
    end

    -- Cleanup
    for _, id in ipairs(queuesToDelete) do
        sSyncObjectsQueue[id] = nil
    end
end

local function osync_update()
    osync_clear_on_area_init()
    if gNetworkPlayers[0].currAreaSyncValid then
        osync_init_queues()
        osync_update_packets()
        osync_spawn_objects()
    end
end

--- @param p table
local function osync_receive_packet(p)
    if p.osync then
        sSyncObjectsPackets[#sSyncObjectsPackets+1] = {
            timestamp = get_global_timer(),
            globalIndex = p.globalIndex,
            queueId = p.queueId,
            eligible = p.eligible,
        }
    end
end

hook_event(HOOK_BEFORE_PLAY_MODE_UPDATE, osync_update) -- runs before object update, but after network update
hook_event(HOOK_ON_PACKET_RECEIVE, osync_receive_packet)

local _osync = {
    spawn_sync_objects = spawn_sync_objects,
    spawn_sync_object = spawn_sync_object,
}

---@class osync
---@field spawn_sync_objects fun(context: string, func: fun())
---@field spawn_sync_object fun(behaviorId: BehaviorId, modelId: ModelExtendedId, x: number, y: number, z: number, objSetupFunction?: function)
local osync = setmetatable({}, {
    __index = _osync,
    __newindex = function () end,
    __metatable = false
})

return osync
