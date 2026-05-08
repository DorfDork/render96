r96lib = {}

local m = gMarioStates[0]
define_custom_obj_fields({
    oAudioPrevDistToMario = 'f32',
})

function r96lib.spawn_object(modelId, bhvId, x, y, z, rx, ry, rz, func)
    local childObj = spawn_non_sync_object(bhvId, modelId, 0, 0, 0, func)
    if childObj == nil then return nil end
    obj_set_pos(childObj, x, y, z)
    obj_set_angle(childObj, rx, ry, rz)
    return childObj
end

function r96lib.squish_apply(o, timer, duration, intensityX, intensityY, intensityZ, baseScale, sound)
    if o == nil then return 0 end
    if duration == nil or duration <= 0 then
        return 0
    end

    timer = timer or 0
    baseScale = baseScale or 1

    intensityX = intensityX or 0
    intensityY = intensityY or 0
    intensityZ = intensityZ or 0

    -- Normalize time into [0, 1]
    local t = timer / duration
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end

    -- Smooth peak-at-middle curve:
    -- I googled this and it works xD
    local peak = math.sin(math.pi * t)

    -- Play the sound once at the peak frame.
    if sound ~= nil then
        local mid = math.floor(duration * 0.5)
        if timer == mid then
            local audioStream = audio_stream_load(sound)
            if audioStream ~= nil then
                audio_stream_play(audioStream, false, 1)
            end
        end
    end

    -- Apply the scale intensity
    local sx = baseScale * (1.0 + (intensityX * peak))
    local sy = baseScale * (1.0 + (intensityY * peak))
    local sz = baseScale * (1.0 + (intensityZ * peak))

    vec3f_set(o.header.gfx.scale, sx, sy, sz)

    return peak
end

function r96lib.spawn_object_param(cond, modelId, bhvId, bhvParam, x, y, z, rx, ry, rz, func)
    if cond == true then
    local childObj = spawn_non_sync_object(bhvId, modelId, 0, 0, 0, func)
        if childObj == nil then return nil end
        obj_set_pos(childObj, x, y, z)
        obj_set_angle(childObj, rx, ry, rz)
        childObj.oBehParams2ndByte = bhvParam
        return childObj
    end
end

-- Emulates a ModAudio Stream being attached to an object, including doppler effects for non-music
---@param o Object The object the audio is from
---@param audioStream ModAudio An ModAudio Stream
---@param rangeMin number? The range in units at which audio is loudest (1)
---@param rangeMax number? The range in units at which audio is quietest (0)
---@param isMusic boolean? Wheather the audio is forced looped and the Doppler Effect is deactivated
function r96lib.audio_fade(o, audioStream, rangeMin, rangeMax, isMusic, loopingStart, loopingEnd)
    if o == nil then return end
    if audioStream == nil or not audioStream.isStream then return end
    if not audio_stream_get_looping(audioStream) and isMusic then
        audio_stream_set_looping(audioStream, true)
        if loopingEnd ~= nil then
            audio_stream_set_loop_points(audioStream, loopingStart, loopingEnd)
        end
    end
    if o.activeFlags == ACTIVE_FLAG_DEACTIVATED then
        audio_stream_set_position(audioStream, 0)
        audio_stream_stop(audioStream)
    end
    local distanceToPlayer = dist_between_objects(m.marioObj, o)
    local wallInterupt = collision_find_surface_on_ray(m.pos.x, m.pos.y + 70, m.pos.z, o.oPosX - m.pos.x, (o.oPosY + o.hitboxHeight*0.5) - (m.pos.y + 70), o.oPosZ - m.pos.z, 128).surface ~= nil

    local hitbox = math.max(math.sqrt(o.hitboxRadius^2 + o.hitboxHeight^2), math.sqrt(o.hurtboxRadius^2 + o.hurtboxHeight^2))
    rangeMin = rangeMin or hitbox*5
    rangeMax = rangeMax or hitbox*25

    local volume = 1 - math.clamp((distanceToPlayer - rangeMin)/(rangeMax*(wallInterupt and 0.5 or 1)), 0, 1)
    --djui_chat_message_create(tostring(volume))
    if volume > 0 then
        audio_stream_play(audioStream, false, 0)
    end

    audio_stream_set_volume(audioStream, volume)
    -- Update Doppler effect
    if not isMusic then
        audio_stream_set_frequency(audioStream, 1 - (distanceToPlayer - o.oAudioPrevDistToMario)/math.lerp(rangeMin, rangeMax, 0.1))
        o.oAudioPrevDistToMario = distanceToPlayer
    end
end

function r96lib.save_render96_data(name, index)
    local bits = r96lib.load_render96_data(name)
    -- Set the character at the index position to '1'
    bits = bits:sub(1, 7 - index) .. "1" .. bits:sub(9 - index)
    mod_storage_save(name, bits)
end

function r96lib.check_render96_data(name, index)
    local bits = r96lib.load_render96_data(name)
    return bits:sub(8 - index, 8 - index) == "1"
end

function r96lib.load_render96_data(name)
    local bits = mod_storage_load(name)
    if bits == nil then
        bits = "00000000"
        mod_storage_save(name, bits)
    end
    return bits
end

local networkPlayers = gNetworkPlayers

local sSpawnTable = {}
local sSpawnedObjects = {}

-- Acts bitmask helpers
local ACT_ALL = 0x3F -- acts 1-6
local function act_bit(n) return 1 << (n - 1) end
local function act_matches(actMask, actNum)
    if actMask == nil or actMask == ACT_ALL then return true end
    return (actMask & act_bit(actNum)) ~= 0
end

-- Register a spawn entry for a level/area
-- acts can be nil (all acts), a single number, or a table like {1, 2, 5}
-- spawnFunc is optional: called with the object after spawn
function r96lib.addSpawn(level, area, model, bhv, x, y, z, rx, ry, rz, acts, spawnFunc)
    sSpawnTable[level] = sSpawnTable[level] or {}
    sSpawnTable[level][area] = sSpawnTable[level][area] or {}

    local actMask = ACT_ALL
    if type(acts) == "number" then
        actMask = act_bit(acts)
    elseif type(acts) == "table" then
        actMask = 0
        for _, a in ipairs(acts) do
            actMask = actMask | act_bit(a)
        end
    end

    table.insert(sSpawnTable[level][area], {
        model     = model,
        bhv       = bhv,
        x = x, y = y, z = z,
        rx = rx or 0, ry = ry or 0, rz = rz or 0,
        actMask   = actMask,
        spawnFunc = spawnFunc,
    })
end

-- Remove all registered spawns for a level/area
function r96lib.clearSpawns(level, area)
    if sSpawnTable[level] then
        sSpawnTable[level][area] = nil
    end
end

local function make_key(level, area, actNum, index)
    return level .. "_" .. area .. "_" .. actNum .. "_" .. index
end

local function on_level_init()
    -- Clear spawn tracking on every level load so objects respawn fresh
    sSpawnedObjects = {}
    
end

local sModelOverrides = {}

function r96lib.addModelOverride(bhv, model)
    table.insert(sModelOverrides, {
        bhv   = bhv,
        model = model,
    })
end

function r96lib.addModelParamOverride(bhv, param, model)
    table.insert(sModelOverrides, {
        bhv   = bhv,
        model = model,
        param = param,
    })
end

local function update()
    local level  = networkPlayers[0].currLevelNum
    local area   = networkPlayers[0].currAreaIndex
    local actNum = networkPlayers[0].currActNum

    for _, entry in ipairs(sModelOverrides) do
        local o = obj_get_first_with_behavior_id(entry.bhv)
        if o then
            while o ~= nil do
            obj_set_model_extended(o, entry.model)
            o = obj_get_next_with_same_behavior_id(o)
            end
        end
    end

    for _, entry in ipairs(sModelOverrides) do
        local o = obj_get_first_with_behavior_id(entry.bhv)
        if o then
            while o ~= nil and entry.param == o.oBehParams do
            obj_set_model_extended(o, entry.model)
            o = obj_get_next_with_same_behavior_id(o)
            end
        end
    end

    local entries = sSpawnTable[level] and sSpawnTable[level][area]
    if not entries then return end

    for i, entry in ipairs(entries) do
        if act_matches(entry.actMask, actNum) then
            local key = make_key(level, area, actNum, i)
            if not sSpawnedObjects[key] then
                sSpawnedObjects[key] = true
                spawn_non_sync_object(entry.bhv, entry.model,
                    entry.x, entry.y, entry.z,
                    function(o)
                        obj_set_angle(o, entry.rx, entry.ry, entry.rz)
                        if entry.spawnFunc then entry.spawnFunc(o) end
                    end)
            end
        end
    end

end



hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
hook_event(HOOK_UPDATE, update)

return r96lib