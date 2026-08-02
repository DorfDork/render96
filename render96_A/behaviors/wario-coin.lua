local r96lib = require("/lib/r96lib")
require("/constants")

local _lerp = math.lerp

------------------------
-- Behavior functions --
------------------------

---@param m MarioState
---@param o Object
local function mario_attract_object(m, o)
    local targetX = m.pos.x + m.vel.x
    local targetY = m.pos.y + 10
    local targetZ = m.pos.z + m.vel.z
    o.oPosX = _lerp(o.oPosX, targetX, 0.2)
    o.oPosY = _lerp(o.oPosY, targetY, 0.2)
    o.oPosZ = _lerp(o.oPosZ, targetZ, 0.2)
    obj_turn_toward_object(o, m.marioObj, 16, 0x2000)
    o.oForwardVel = 60
end

---@param o Object
local function bhv_wario_coin_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    --o.oInteractType = INTERACT_COIN
    o.oDamageOrCoinValue = 0
    o.hitboxHeight = 72
    o.hitboxRadius = 50
    o.oVelY = 30
    cur_obj_scale(0.8)
    create_sound_spawner(SOUND_GENERAL_COIN_DROP)
end

---@param o Object
local function bhv_wario_coin_loop(o)
    cur_obj_update_floor_and_walls()
    cur_obj_move_standard(-78)
    o.oGravity = -2.5
    o.oFriction = 0.99
    o.oBuoyancy = 1.4
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1000
    o.oForwardVel = 30

    local playerIndex = network_local_index_from_global(o.globalPlayerIndex)
    local m = gMarioStates[playerIndex]

    if o.oVelY < 0 or (o.oMoveFlags & (OBJ_MOVE_MASK_ON_GROUND | OBJ_MOVE_HIT_WALL | OBJ_MOVE_HIT_EDGE | OBJ_MOVE_MASK_IN_WATER)) ~= 0 then
        mario_attract_object(m, o)
    end

    if dist_between_objects(o, m.marioObj) <= 50 then
        set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)
        create_sound_spawner(SOUND_GENERAL_COIN)
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end

    if (o.oMoveFlags & OBJ_MOVE_ABOVE_LAVA) ~= 0 then
        obj_mark_for_deletion(o)
        return
    end
end

id_bhvWarioCoins = r96lib.hook_behavior(nil, false, bhv_wario_coin_init, bhv_wario_coin_loop, OBJ_LIST_LEVEL, "WarioCoins")
