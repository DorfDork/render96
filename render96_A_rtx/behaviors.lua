local version = require("/lib/version")
local r96lib = require("/lib/r96lib")
require("/constants")

local _floor  = math.floor
local _abs    = math.abs
local _max    = math.max
local _min    = math.min
local _sqrt   = math.sqrt
local _random = math.random
local _sin    = math.sin
local _cos    = math.cos
local _lerp   = math.lerp
local _pi     = math.pi

-------------------
-- Object fields --
-------------------

local BEHAVIORS_CUSTOM_OBJECT_FIELDS = {

    -- Geo switches
    oSwitchState1 = 's32',
    oSwitchTimer1 = 's32',
    oSwitchState2 = 's32',
    oSwitchTimer2 = 's32',

    -- Mario
    oMarioLongJumpTimer = 's32',

    -- Yoshi
    oTongueU               = 'f32',
    oTongueTimer           = 's32',
    oTongueTarget          = 'f32',
    oTongueLockX           = 'f32',
    oTongueLockY           = 'f32',
    oTongueLockZ           = 'f32',
    oYoshiIdleTimer        = 's32',
    oYoshiCustomBlinkTimer = 's32',

    -- Mr I
    oMrIBlinkIndex    = 's32',
    oMrITracking      = 'f32',
    oMrILastAngle     = 's32',
    oMrIFireTimer     = 's32',
    oMrIDizzyTimer    = 's32',
    oMrIDizzyDuration = 's32',
    oMrIDetectRadius  = 'f32',

    -- Thwomp
    oThwompShakeTimer  = 's32',
    oThwompShakeTicks  = 's32',
    oThwompPosMag      = 'f32',
    oThwompAngleMag    = 's32',
    oThwompPrevAction  = 's32',
    oThwompSquishTimer = 's32',
    oThwompSquishDur   = 's32',
    oThwompBaseScale   = 'f32',

    -- Wario head
    oWarioHeadBool = 's32',

    -- Misc
    oWallX           = 'f32',
    oWallY           = 'f32',
    oWallZ           = 'f32',
    oCelebrationStar = 's32',
}

if not version.GLOBAL_OBJECT_FIELDS then
    -- Need to fill custom object fields with as much dummy fields as defined in r96lib to preserve indexing
    -- Since object fields are sorted alphabetically, we must make sure they are defined first
    local i = 0
    for _ in pairs(r96lib.CUSTOM_OBJECT_FIELDS) do
        BEHAVIORS_CUSTOM_OBJECT_FIELDS[string.format("o%u", i)] = "u32"
        i = i + 1
    end
end

define_custom_obj_fields(BEHAVIORS_CUSTOM_OBJECT_FIELDS)

--- For VSCode autocompletion
--- @class Object
--- @field oSwitchState1 integer
--- @field oSwitchTimer1 integer
--- @field oSwitchState2 integer
--- @field oSwitchTimer2 integer
--- @field oMarioLongJumpTimer integer
--- @field oTongueU number
--- @field oTongueTimer integer
--- @field oTongueTarget number
--- @field oTongueLockX number
--- @field oTongueLockY number
--- @field oTongueLockZ number
--- @field oYoshiIdleTimer integer
--- @field oYoshiCustomBlinkTimer integer
--- @field oMrIBlinkIndex integer
--- @field oMrITracking number
--- @field oMrILastAngle integer
--- @field oMrIFireTimer integer
--- @field oMrIDizzyTimer integer
--- @field oMrIDizzyDuration integer
--- @field oMrIDetectRadius number
--- @field oThwompShakeTimer integer
--- @field oThwompShakeTicks integer
--- @field oThwompPosMag number
--- @field oThwompAngleMag integer
--- @field oThwompPrevAction integer
--- @field oThwompSquishTimer integer
--- @field oThwompSquishDur integer
--- @field oThwompBaseScale number
--- @field oWarioHeadBool integer
--- @field oWallX number
--- @field oWallY number
--- @field oWallZ number
--- @field oCelebrationStar integer

------------------------
-- Behavior functions --
------------------------

local SURFACE_TYPE_DEADLY = T{
    SURFACE_BURNING,
    SURFACE_DEATH_PLANE,
    SURFACE_INSTANT_QUICKSAND,
    SURFACE_INSTANT_MOVING_QUICKSAND,
    SURFACE_VERTICAL_WIND,
}

---@param o Object
function obj_is_on_deadly_floor(o)
    return o.oFloor ~= nil and
           o.oFloorHeight >= o.oPosY and
           SURFACE_TYPE_DEADLY[o.oFloor.type]
end

---@param o Object
---@param x number
---@param y number
---@param z number
function obj_set_home(o, x, y, z)
    o.oHomeX = x
    o.oHomeY = y
    o.oHomeZ = z
end

local _obj_set_hitbox = obj_set_hitbox
---@param o Object
---@param hitbox table|ObjectHitbox
function obj_set_hitbox(o, hitbox)
    if type(hitbox) == "table" then
        local objHitbox = get_temp_object_hitbox()
        objHitbox.interactType = hitbox.interactType or 0
        objHitbox.downOffset = hitbox.downOffset or 0
        objHitbox.damageOrCoinValue = hitbox.damageOrCoinValue or 0
        objHitbox.health = hitbox.health or 0
        objHitbox.numLootCoins = hitbox.numLootCoins or 0
        objHitbox.radius = hitbox.radius or 0
        objHitbox.height = hitbox.height or 0
        objHitbox.hurtboxRadius = hitbox.hurtboxRadius or 0
        objHitbox.hurtboxHeight = hitbox.hurtboxHeight or 0
        _obj_set_hitbox(o, objHitbox)
    else
        _obj_set_hitbox(o, hitbox)
    end
end

---@param o Object
function obj_drop_to_floor(o)
    o.oPosY, o.oFloor = find_floor(o.oPosX, o.oPosY, o.oPosZ)
    o.oMoveFlags = o.oMoveFlags | OBJ_MOVE_ON_GROUND
end

---@param o Object
---@param triggerAction integer
---@param intensityX number
---@param intensityY number
---@param intensityZ number
function obj_squish_on_action_enter(o, triggerAction, intensityX, intensityY, intensityZ)
    local prev = o.oThwompPrevAction or o.oAction
    if prev ~= triggerAction and o.oAction == triggerAction then
        o.oThwompSquishTimer = 0
        o.oThwompSquishDur   = 5
        o.oThwompBaseScale   = o.header.gfx.scale.x
    end
    if (o.oThwompSquishDur or 0) > 0 and (o.oThwompSquishTimer or 0) <= o.oThwompSquishDur then
        r96lib.squish_apply(o, o.oThwompSquishTimer, o.oThwompSquishDur, intensityX, intensityY, intensityZ, o.oThwompBaseScale, nil)
        o.oThwompSquishTimer = o.oThwompSquishTimer + 1
    end
    o.oThwompPrevAction = o.oAction
end

---@param o Object
function obj_kill_common(o)
    spawn_mist_particles_variable(0, 0, 100.0)
    spawn_triangle_break_particles(20, 138, 3.0, 4)
    set_camera_shake_from_point(SHAKE_POS_MEDIUM, o.oPosX, o.oPosY, o.oPosZ)
    obj_mark_for_deletion(o)
end

---@param o Object
---@param numCoins integer
function obj_spawn_blue_coins(o, numCoins)
    o.oNumLootCoins = numCoins
    obj_spawn_loot_coins(o, numCoins, 20, get_behavior_from_id(id_bhvMrIBlueCoin), 150, 0x76)
end

---@param x number
---@param y number
---@param z number
---@param count integer
---@param modelId ModelExtendedId | integer
---@param size number
---@param animState integer
---@param vel number
---@param duration integer
function obj_spawn_particles(x, y, z, count, modelId, size, animState, vel, duration)
    for _ = 1, count do
        spawn_non_sync_object(id_bhvRender96Particle, modelId, x, y, z, function (obj)
            obj.oAnimState = animState
            obj.oMoveAngleYaw = random_u16()
            obj.oAngleVelYaw = 0x500
            obj.oFaceAnglePitch = random_u16()
            obj.oAngleVelPitch = 0xF00
            obj.oForwardVel = random_f32_around_zero(2 * vel)
            obj.oVelY = random_f32_around_zero(2 * vel)
            obj.oAction = duration
            obj_scale(obj, size)
        end)
    end
end

---@param o Object
---@param closeMin integer
---@param closeMax integer
---@param openMin integer
---@param openMax integer
function obj_update_eye_blink(o, closeMin, closeMax, openMin, openMax)
    o.oSwitchTimer1 = o.oSwitchTimer1 - 1
    if o.oSwitchTimer1 <= 0 then
        if o.oSwitchState1 == 0 then
            o.oSwitchState1 = 1
            o.oSwitchTimer1 = _random(closeMin, closeMax)
        else
            o.oSwitchState1 = 0
            o.oSwitchTimer1 = _random(openMin, openMax)
        end
    end
end

---@param o Object
---@param center Vec3f
---@param rot Vec3s
function obj_rotate_gfx_around_center(o, center, rot)
    o.oFlags = o.oFlags & ~OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj_update_gfx_pos_and_angle(o)
    local gfx = o.header.gfx
    gfx.angle.x = rot.x
    gfx.angle.y = rot.y
    gfx.angle.z = rot.z
    local v = {
        x = -gfx.scale.x * center.x,
        y = -gfx.scale.y * center.y,
        z = -gfx.scale.z * center.z,
    }
    vec3f_rotate_zxy(v, rot)
    gfx.pos.x = gfx.pos.x + v.x + gfx.scale.x * center.x
    gfx.pos.y = gfx.pos.y + v.y + gfx.scale.y * center.y
    gfx.pos.z = gfx.pos.z + v.z + gfx.scale.z * center.z
    gfx.disableAutomaticShadowPos = true
    gfx.shadowPos.x = o.oPosX
    gfx.shadowPos.y = o.oPosY
    gfx.shadowPos.z = o.oPosZ
end

---@param m MarioState
---@param o Object
---@param padding number?
function push_mario_out_of_object(m, o, padding)
    local minDistance = o.hitboxRadius + m.marioObj.hitboxRadius + (padding or 0)

    local offsetX = m.pos.x - o.oPosX
    local offsetZ = m.pos.z - o.oPosZ
    local distance = _sqrt(offsetX * offsetX + offsetZ * offsetZ)

    if (distance < minDistance) then
        local floor = m.floor
        local pushAngle = 0
        local newMarioX = 0
        local newMarioZ = 0

        if (distance == 0) then
            pushAngle = m.faceAngle.y
        else
            pushAngle = atan2s(offsetZ, offsetX)
        end

        newMarioX = o.oPosX + minDistance * sins(pushAngle)
        newMarioZ = o.oPosZ + minDistance * coss(pushAngle)

        if (floor ~= nil) then
            m.pos.x = newMarioX
            m.pos.z = newMarioZ
            if gLevelValues.fixCollisionBugs ~= 0 then
                m.floorHeight, m.floor = find_floor(m.pos.x, m.pos.y, m.pos.z)
            end
        end
    end
end

---@param m MarioState
---@param o Object
---@param velY number
function mario_bounce_off_object(m, o, velY)
    m.pos.y = o.oPosY + o.hitboxHeight
    m.vel.y = velY
    m.flags = m.flags & ~MARIO_UNKNOWN_08
    play_sound(SOUND_ACTION_BOUNCE_OFF_OBJECT, m.marioObj.header.gfx.cameraToObject)
end

---@param o Object
function nearest_tangible_mario_state_to_object(o)
    local nearestDist = 0
    local nearestMario = nil
    for i = 0, MAX_PLAYERS - 1 do
        local m = gMarioStates[i]
        if m.marioObj ~= o and m.visibleToObjects and m.action & (ACT_FLAG_INTANGIBLE | ACT_FLAG_INVULNERABLE) == 0 and is_player_active(m) == 1 then
            local dist = dist_between_objects(o, m.marioObj)
            if not nearestMario or dist < nearestDist then
                nearestMario = m
                nearestDist = dist
            end
        end
    end
    return nearestMario
end

---@param o Object
function get_mario_state_from_ridden_object(o)
    for i = 0, MAX_PLAYERS - 1 do
        local m = gMarioStates[i]
        if is_player_active(m) == 1 and m.riddenObj == o then
            return m
        end
    end
    return nil
end

---@param func function
function call_func(func, ...)
    return func and func(...) or nil
end

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_state_1(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = o.oSwitchState1
end

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_state_2(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = o.oSwitchState2
end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_disable_billboard(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

---@param node GraphNode
---@param matStackIndex integer
---@param m MarioState
---@param actionStates table
function geo_switch_end_peach_cutscene(node, matStackIndex, m, actionStates)
    if m and actionStates and m.action == ACT_END_PEACH_CUTSCENE then
        local states = actionStates[m.actionArg]
        if states then
            local state = states[m.actionTimer]
            if state then
                cast_graph_node(node).selectedCase = state
            end
            return true
        end
    end
    return false
end

---------------
-- UV scroll --
---------------

-- function uv_scroll_right(input_vtx, original_uv, current_uv)
--    local speed = 10
--    current_uv[1] = current_uv[1] + speed
-- end

-- -- Scroll the uvs in a circular motion
-- function uv_scroll_spin(input_vtx, original_uv, current_uv)
--    local speed    = 0.5
--    local center_u = 500 -- center of rotation in UV space
--    local center_v = 500
--    local offset_u = 0   -- post-rotation translation (right/left)
--    local offset_v = 0   -- post-rotation translation (up/down)

--    -- offset from chosen center
--    local rel_u = original_uv[1] - center_u
--    local rel_v = original_uv[2] - center_v

--    -- equation for circular motion
--    local t          = get_global_timer() * speed
--    local orig_theta = _atan2(rel_v, rel_u)
--    local orig_dist  = _sqrt(rel_u * rel_u + rel_v * rel_v)

--    current_uv[1] = center_u + orig_dist * _cos(orig_theta + t) + offset_u
--    current_uv[2] = center_v + orig_dist * _sin(orig_theta + t) + offset_v
-- end

-- -- Scroll the uvs in a circular motion
-- function uv_scroll_spin_slow(input_vtx, original_uv, current_uv)
--    -- adjustable constants
--    local speed = 0.01

--    -- equation for circular motion
--    local t = get_global_timer() * speed
--    local orig_theta = _atan2(original_uv[2], original_uv[1])
--    local orig_dist = _sqrt((original_uv[1])*(original_uv[1]) + (original_uv[2])*(original_uv[2]))
--    current_uv[1] = orig_dist * _cos(orig_theta + t)
--    current_uv[2] = orig_dist * _sin(orig_theta + t)
-- end

---------------
-- Behaviors --
---------------

require("/behaviors/amp")
require("/behaviors/blargg")
require("/behaviors/bobomb")
require("/behaviors/boo")
require("/behaviors/bowling-ball")
require("/behaviors/bowser")
require("/behaviors/breakable-box")
require("/behaviors/bubba")
require("/behaviors/bully")
require("/behaviors/chain-chomp")
require("/behaviors/chuckya")
require("/behaviors/cloud")
require("/behaviors/door")
require("/behaviors/eyerok")
require("/behaviors/fire-spitter")
require("/behaviors/flame")
require("/behaviors/friendly-blargg")
require("/behaviors/golden-coin")
require("/behaviors/goomba")
require("/behaviors/heave-ho")
require("/behaviors/king-bobomb")
require("/behaviors/koopa")
require("/behaviors/koopa-shell")
require("/behaviors/koopa-the-quick")
require("/behaviors/luigi-key")
require("/behaviors/mr-i")
require("/behaviors/mushroom-1up")
require("/behaviors/particles")
require("/behaviors/peach")
require("/behaviors/piranha-plant")
require("/behaviors/pokey")
require("/behaviors/scuttlebug")
require("/behaviors/snowball")
require("/behaviors/snowmans-head")
require("/behaviors/spindle")
require("/behaviors/star")
require("/behaviors/thwomp")
require("/behaviors/toad-npc")
require("/behaviors/tree")
require("/behaviors/tuxies-mother")
require("/behaviors/unagi")
require("/behaviors/wario-coin")
require("/behaviors/wario-head")
require("/behaviors/warp-pipe")
require("/behaviors/wf-tower-door")
require("/behaviors/whomp")
require("/behaviors/wiggler")
require("/behaviors/wooden-post")
require("/behaviors/yoshi-rideable")
require("/behaviors/yoshi-tongue")
