local r96lib = require("/lib/r96lib")
require("/constants")

local _sqrt = math.sqrt

------------------------
-- Behavior functions --
------------------------

local WARIO_GREETING = 0
local WARIO_BITE = 1
local WARIO_LOL = 2
local WARIO_DEATH = 3

---@param o Object
local function bhv_wario_head_init(o)
    -- set flags
    o.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)

    -- drop to floor
    obj_drop_to_floor(o)

    -- home
    obj_set_home(o, o.oPosX, o.oPosY, o.oPosZ)

    -- physics
    o.oGravity = -4.0
    o.oBounciness = -0.5
    o.oDragStrength = 10.0
    o.oFriction = 10.0
    o.oBuoyancy =  0.0

    -- hitbox
    o.oInteractType = INTERACT_SHOCK
    o.oHealth = 0
    o.oNumLootCoins = 1
    o.oIntangibleTimer = 0
    o.hitboxRadius = 0
    o.hitboxHeight = 0
    o.hurtboxRadius = 50
    o.hurtboxHeight = 60
    o.oDamageOrCoinValue = 4
    --o.hitboxDownOffset = o.header.gfx.scale.y * 0
    o.oWarioHeadBool = 0
    o.oAction = -1
end

---@param o Object
local function bhv_wario_head_loop(o)
    local m = nearest_mario_state_to_object(o)
    local player = m.marioObj
    local distanceToPlayer = dist_between_objects(o, player)
    local angleToPlayer = obj_angle_to_object(o, player)

    if o.oWarioHeadBool == 0 then
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
    end
    if o.oAction == -1 and o.oWarioHeadBool == 1 then
        o.oPosY = -800
        audio_stream_play(AUDIO_R96_WARIO_HEAD_FUN, false, 2)
        o.oAction = WARIO_BITE
    end
    if m.pos.x >= 2000 then
        cur_obj_become_tangible()
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        o.oWarioHeadBool = 1
    end
    if m.pos.x >= 604 then
        local dx = player.header.gfx.pos.x - o.oPosX
        local dy = (player.header.gfx.pos.y + 50.0) - o.oPosY
        local dz = player.header.gfx.pos.z - o.oPosZ

        local targetPitch = atan2s(_sqrt((dx * dx) + (dz * dz)), dy)

        obj_turn_toward_object(o, player, 16, 0x1000)
        o.oMoveAnglePitch = approach_s16_symmetric(o.oMoveAnglePitch, targetPitch, 0x1000)
        o.oVelY = sins(o.oMoveAnglePitch) * 2.0
        o.oForwardVel = coss(o.oMoveAnglePitch) * 30.0
        o.oFaceAngleYaw =  angleToPlayer + 0x8000
        cur_obj_move_standard(-78)
        cur_obj_update_floor_and_walls()
    end

    if o.oWarioHeadBool == 1 and m.pos.x < 604 then
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
        audio_stream_play(AUDIO_R96_WARIO_HEAD_YELL, false, 2)
        obj_mark_for_deletion(o)
    end
   o.oInteractStatus = 0
end

id_bhvWarioHead = r96lib.hook_behavior(nil, false, bhv_wario_head_init, bhv_wario_head_loop, OBJ_LIST_GENACTOR, "WarioHead")

-----------
-- Hooks --
-----------

local function wario_head_spawner()
    local levelNum = gNetworkPlayers[0].currLevelNum
    local areaNum = gNetworkPlayers[0].currAreaIndex
    local actNum = gNetworkPlayers[0].currActNum
    local m = gMarioStates[0]
    --5235, -1074,  1995
    --604, -1074, 1995
    --if levelNum == LEVEL_CASTLE and m.pos.y == -1074 then
    --r96lib.spawn_object(E_MODEL_WARIO_HEAD, id_bhvWarioHead, 5935, -1074,  2084, 0, 0, 0, nil)
    ----print("spawned head")
    --end
    --print(levelNum)
end

hook_event(HOOK_ON_WARP, wario_head_spawner)
