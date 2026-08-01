require("/constants")

local _abs  = math.abs
local _max  = math.max
local _min  = math.min
local _sqrt = math.sqrt

local YOSHI_FLUTTER_JUMP_ACTIONS = T{
    ACT_R96_YOSHI_RIDE_JUMP,
}

local YOSHI_RIDE_ACTIONS = T{
    ACT_R96_YOSHI_RIDE_IDLE,
    ACT_R96_YOSHI_RIDE_WALK,
    ACT_R96_YOSHI_RIDE_JUMP,
    ACT_R96_YOSHI_RIDE_FLUTTER,
    ACT_R96_YOSHI_RIDE_FALL,
}

local YOSHI_TONGUE_BEHAVIORS = T{
    id_bhvRender96Goomba,
    id_bhvBobomb,
}

---@param m MarioState
local function yoshi_ride_flutter_update_vel(m)
    m.actionTimer = m.actionTimer + 1
    if m.actionTimer == 1 then
        m.vel.y = 15
    elseif m.actionTimer <= 45 then
        m.vel.y = 15 * 0.01 * m.actionTimer
        if m.vel.y < -3 then
            m.vel.y = -3
        end
    else
        local gravity = (45 - m.actionTimer)
        m.vel.y = 15 * 0.1 * gravity
    end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        m.forwardVel = approach_f32(m.forwardVel, m.intendedMag * 0.4, 3.0, 3.0)
    else
        m.forwardVel = approach_f32(m.forwardVel, 0, 2.0, 2.0)
    end

    if m.forwardVel > 20.0 then
        mario_set_forward_vel(m, 20.0)
    elseif m.forwardVel < -20.0 then
        mario_set_forward_vel(m, -20.0)
    end

    m.vel.x = m.forwardVel * sins(m.intendedYaw)
    m.vel.z = m.forwardVel * coss(m.intendedYaw)

    m.slideVelX = m.vel.x
    m.slideVelZ = m.vel.z
end

---@param m MarioState
local function yoshi_dismount(m)
    if (m.controller.buttonPressed & Z_TRIG) ~= 0 then
        mario_stop_riding_object(m)
        m.pos.y = m.marioObj.header.gfx.pos.y
        set_mario_action(m, ACT_TRIPLE_JUMP, 0)
        return true
    end
    return false
end

---@param m MarioState
local function yoshi_walk_speed(m)
    local targetSpeed = (m.floor ~= nil and m.floor.type == SURFACE_SLOW) and 32.0 or 48.0
    if m.intendedMag < 24 then targetSpeed = m.intendedMag end
    if m.quicksandDepth > 10.0 then targetSpeed = targetSpeed * (6.25 / m.quicksandDepth) end

    if     m.forwardVel <= 0.0         then m.forwardVel = m.forwardVel + 1.1
    elseif m.forwardVel <= targetSpeed then m.forwardVel = m.forwardVel + (1.1 - m.forwardVel / targetSpeed)
    elseif m.floor ~= nil and m.floor.normal.y >= 0.95 then m.forwardVel = m.forwardVel - 1.0 end

    if m.forwardVel > 64.0 then m.forwardVel = 64.0 end

    m.faceAngle.y = m.intendedYaw - approach_s32(math.s16(m.intendedYaw - m.faceAngle.y), 0, 0x800, 0x800)
    apply_slope_accel(m)
end

---@param m MarioState
local function yoshi_tongue_find_target(m)
    local bestObj, bestDist = nil, YOSHI_TONGUE_RADIUS
    local o = obj_get_first(OBJ_LIST_GENACTOR)

    while o ~= nil do
        local isEnemy = false
        for behId in pairs(YOSHI_TONGUE_BEHAVIORS) do
           -- obj_get_nearest_object_with_behavior_id()
            if obj_has_behavior_id(o, behId) == 1 and dist_between_objects(o, m.marioObj) <= 200 then break end
        end

        if isEnemy then
            local dx, dy, dz = o.oPosX - m.marioObj.oPosX, o.oPosY - m.marioObj.oPosY, o.oPosZ - m.marioObj.oPosZ
            local dist = _sqrt(dx*dx + dy*dy + dz*dz)
            if dist <= bestDist then
                bestDist, bestObj = dist, o
                break
            end
        end
        o = obj_get_next(o)
    end

    return bestObj
end

---@param m MarioState
local function yoshi_tongue_attack(m)
    local target = yoshi_tongue_find_target(m)
    local tongue = spawn_non_sync_object(id_bhvRender96YoshiTongue, E_MODEL_R96_YOSHI_TONGUE,
        m.marioObj.oPosX, m.marioObj.oPosY + 60.0, m.marioObj.oPosZ, nil)

    tongue.oAction = R96_YOSHI_TONGUE_ACT_EXTENDING
    tongue.oTongueU = 0.0

    if target == nil then
        tongue.oTongueLockX = m.marioObj.oPosX + sins(m.faceAngle.y) * YOSHI_TONGUE_RADIUS
        tongue.oTongueLockY = m.marioObj.oPosY + 60.0
        tongue.oTongueLockZ = m.marioObj.oPosZ + coss(m.faceAngle.y) * YOSHI_TONGUE_RADIUS
    else
        tongue.parentObj = target
    end
end

-------------
-- Actions --
-------------

---@param m MarioState
local function act_yoshi_ride_idle(m)
    if yoshi_dismount(m) then
        return 1
    end

    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, CHAR_ANIM_R96_MARIO_RIDING_YOSHI_IDLE)

    if stationary_ground_step(m) == GROUND_STEP_LEFT_GROUND then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_FALL, 0)
    end
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_JUMP, 0)
    end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        m.faceAngle.y = m.intendedYaw
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_WALK, 0)
    end
    mario_set_forward_vel(m, 0)
end

---@param m MarioState
local function act_yoshi_ride_walk(m)
    if yoshi_dismount(m) then
        return 1
    end

    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, CHAR_ANIM_R96_MARIO_RIDING_YOSHI_RUN)
    yoshi_walk_speed(m)

    local step = perform_ground_step(m)
    if step == GROUND_STEP_LEFT_GROUND then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_FALL, 1)
    elseif step == GROUND_STEP_HIT_WALL then
        m.forwardVel = 6
        if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
            return set_mario_action(m, ACT_R96_YOSHI_RIDE_IDLE, 0)
        end
    elseif step == GROUND_STEP_NONE then
        if m.intendedMag - m.forwardVel > 16.0 then
            m.particleFlags = m.particleFlags | PARTICLE_DUST
        end
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then return set_mario_action(m, ACT_R96_YOSHI_RIDE_JUMP, 0) end
    if _abs(m.forwardVel) <= 1 then return set_mario_action(m, ACT_R96_YOSHI_RIDE_IDLE, 0) end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 and m.forwardVel <= 5 then mario_set_forward_vel(m, 5) end
end

---@param m MarioState
local function act_yoshi_ride_jump(m)
    if yoshi_dismount(m) then
        return 1
    end

    if m.actionTimer == 0 then
        play_character_sound(m, CHAR_SOUND_YAH_WAH_HOO)
        m.vel.y = _max(_min(80.0, 15.0 + _abs(m.vel.y)), 40.0)
    end
    update_air_without_turn(m)
    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_WALK, 0)
    end

    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, CHAR_ANIM_R96_MARIO_RIDING_YOSHI_JUMP)
    m.actionTimer = m.actionTimer + 1
end

---@param m MarioState
local function act_yoshi_ride_flutter(m)
    if yoshi_dismount(m) then
        return 1
    end

    if (m.input & INPUT_A_DOWN) == 0 or m.vel.y < -10 then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_FALL, 0)
    end

    yoshi_ride_flutter_update_vel(m)
    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, CHAR_ANIM_R96_MARIO_RIDING_YOSHI_FLUTTER)
    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_WALK, 0)
    end
end

---@param m MarioState
local function act_yoshi_ride_fall(m)
    if yoshi_dismount(m) then
        return 1
    end

    if m.actionTimer > 0 and (m.controller.buttonDown & A_BUTTON) ~= 0 and m.vel.y < 0 then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_FLUTTER, 0)
    end

    update_air_without_turn(m)
    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_WALK, 0)
    end

    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, CHAR_ANIM_R96_MARIO_RIDING_YOSHI_FALL)
    m.actionTimer = m.actionTimer + 1
end

---@param m MarioState
local function act_yoshi_ride_land(m)
    if yoshi_dismount(m) then
        return 1
    end

    common_landing_action(m, CHAR_ANIM_LAND_FROM_SINGLE_JUMP, ACT_FREEFALL);

    update_air_without_turn(m)
    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_R96_YOSHI_RIDE_WALK, 0)
    end

    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, ANIM_R96_YOSHI_RIDEABLE_FLUTTER_FALL)
    m.actionTimer = m.actionTimer + 1
end

-----------
-- Hooks --
-----------

---@param m MarioState
local function yoshi_check_flutter_jump(m)
    if (YOSHI_FLUTTER_JUMP_ACTIONS[m.action] and
        m.prevAction & ACT_FLAG_AIR == 0 and
        m.input & INPUT_A_DOWN ~= 0 and
        m.vel.y < 0) then
        set_mario_action(m, ACT_R96_YOSHI_RIDE_FLUTTER, 0)
    end
end

---@param m MarioState
local function yoshi_update(m)
    if YOSHI_RIDE_ACTIONS[m.action] and (m.input & INPUT_B_PRESSED) ~= 0 then
        yoshi_tongue_attack(m)
    end
end

hook_event(HOOK_BEFORE_MARIO_UPDATE, yoshi_check_flutter_jump)
hook_event(HOOK_MARIO_UPDATE, yoshi_update)

hook_mario_action(ACT_R96_YOSHI_RIDE_IDLE,    act_yoshi_ride_idle)
hook_mario_action(ACT_R96_YOSHI_RIDE_WALK,    act_yoshi_ride_walk)
hook_mario_action(ACT_R96_YOSHI_RIDE_JUMP,    act_yoshi_ride_jump)
hook_mario_action(ACT_R96_YOSHI_RIDE_FLUTTER, act_yoshi_ride_flutter)
hook_mario_action(ACT_R96_YOSHI_RIDE_FALL,    act_yoshi_ride_fall)
