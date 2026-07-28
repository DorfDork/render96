local charSelect = require("/lib/char-select")
require("/constants")

--[[
local E_MODEL_R96_WARIO = smlua_model_util_get_id("r96_wario_geo")
_G.charSelect.character_add_costume(CT_WARIO, "Vanilla Wario", nil, nil, nil, E_MODEL_WARIO)
_G.charSelect.character_edit(CT_WARIO, nil, nil, "Render96", nil, E_MODEL_R96_WARIO)
]]

local _floor = math.floor
local _max   = math.max
local _min   = math.min

local BEHAVIORS_NO_GREEN_COIN = {
    id_bhvMips,
    id_bhvUkiki,
    id_bhvBreakableBoxSmall,
    id_bhvSmallPenguin,
    id_bhvUnused20E0,
}

---@param m MarioState
local function wario_should_begin_sliding(m)
    if m == nil then return false end

    if m.input & INPUT_ABOVE_SLIDE ~= 0 then
        local slideLevel = (m.area.terrainType & TERRAIN_MASK) == TERRAIN_SLIDE
        local movingBackward = m.forwardVel <= -1.0

        if slideLevel or movingBackward or mario_facing_downhill(m, 0) then
            return true
        end
    end

    return false
end

---@param m MarioState
local function wario_update_decelerating_speed(m)
    if m == nil then return false end

    local stopped = false

    m.forwardVel = approach_f32(m.forwardVel, 0.0, 1.0, 1.0)
    if m.forwardVel == 0.0 then
        stopped = true
    end

    mario_set_forward_vel(m, m.forwardVel)
    mario_update_moving_sand(m)
    mario_update_windy_ground(m)

    return stopped
end

---@param m MarioState
local function wario_check_common_hold_idle_cancels(m)
    if m == nil then return false end

    if m.floor ~= nil and m.floor.normal.y < 0.29237169 then
        return mario_push_off_steep_floor(m, ACT_HOLD_FREEFALL, 0)
    end

    if m.heldObj ~= nil and m.heldObj.oInteractionSubtype & INT_SUBTYPE_DROP_IMMEDIATELY ~= 0 then
        m.heldObj.oInteractionSubtype = m.heldObj.oInteractionSubtype & ~INT_SUBTYPE_DROP_IMMEDIATELY
        return set_mario_action(m, ACT_PLACING_DOWN, 0)
    end

    if m.input & INPUT_UNKNOWN_10 ~= 0 then
        return drop_and_set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
    end

    if m.input & INPUT_A_PRESSED ~= 0 then
        return set_jumping_action(m, ACT_HOLD_JUMP, 0)
    end

    if m.input & INPUT_OFF_FLOOR ~= 0 then
        return set_mario_action(m, ACT_HOLD_FREEFALL, 0)
    end

    if m.input & INPUT_ABOVE_SLIDE ~= 0 then
        return set_mario_action(m, ACT_HOLD_BEGIN_SLIDING, 0)
    end

    if m.input & INPUT_NONZERO_ANALOG ~= 0 then
        m.faceAngle.y = m.intendedYaw
        return set_mario_action(m, ACT_HOLD_WALKING, 0)
    end

    if m.input & INPUT_B_PRESSED ~= 0 then
        return set_mario_action(m, ACT_THROWING, 0)
    end

    if m.input & INPUT_Z_DOWN ~= 0 then
        return set_mario_action(m, ACT_WARIO_SWING_FLING_START, 0)
    end

    return false
end

---@param m MarioState
local function wario_swing_fling_spin_speed(m)
    local faceAngleYaw = m.faceAngle.y

    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        local intendedDYaw = m.intendedYaw - m.faceAngle.y
        local intendedMag = m.intendedMag / 32.0

        m.forwardVel = m.forwardVel + coss(intendedDYaw) * intendedMag * 100.0
        faceAngleYaw = m.faceAngle.y + (sins(intendedDYaw) * intendedMag * 1024.0)

        if m.forwardVel < 0.0 then
            faceAngleYaw = faceAngleYaw + intendedDYaw
            m.forwardVel = -m.forwardVel
        end

        if m.forwardVel > 32.0 then
            m.forwardVel = 32.0
        end
    end

    m.vel.x = m.forwardVel * sins(faceAngleYaw)
    m.slideVelX = m.vel.x

    m.vel.z = m.forwardVel * coss(faceAngleYaw)
    m.slideVelZ = m.vel.z
end

---@param m MarioState
local function wario_swing_fling_spin(m)
    wario_swing_fling_spin_speed(m)

    local step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
        set_character_animation(m, CHAR_ANIM_GENERAL_FALL)
        return true
    end
    return false
end

---@param o Object
local function wario_swing_fling_spin_should_spawn_coins(o)
    for _, bhv in ipairs(BEHAVIORS_NO_GREEN_COIN) do
        if obj_has_behavior_id(o, bhv) == 1 then return false end
    end
    return true
end

-------------
-- Actions --
-------------

---@param m MarioState
local function act_wario_charge(m)
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WARIO_TRIPLE_JUMP, 0)
    end

    if m.actionTimer == 0 then
        if (m.flags & MARIO_MARIO_SOUND_PLAYED) == 0 then
            play_character_sound_offset(m, CHAR_SOUND_YAHOO_WAHA_YIPPEE, ((random_u16() % 3) << 16))
            m.flags = m.flags | MARIO_MARIO_SOUND_PLAYED
        end
    end

    m.actionTimer = m.actionTimer + 1

    if m.actionTimer < 60 then
        local sYaw = math.s16(m.intendedYaw - m.faceAngle.y)
        sYaw = _max(-0x300, _min(0x300, sYaw))
        m.intendedYaw = m.faceAngle.y + sYaw

        update_shell_speed(m)
        queue_rumble_data_mario(m, 5, 80)

        if m.forwardVel < 29.0 then m.forwardVel = m.forwardVel + 1.5 end

        set_character_anim_with_accel(m, CHAR_ANIM_RUNNING_UNUSED, 0x90000)
        play_step_sound(m, 9, 45)

        local step = perform_ground_step(m)

        if step == GROUND_STEP_LEFT_GROUND then
            set_mario_action(m, ACT_FREEFALL, 0)
            set_character_animation(m, CHAR_ANIM_GENERAL_FALL)

        elseif step == GROUND_STEP_HIT_WALL then
            play_sound(
                ((m.flags & MARIO_METAL_CAP) ~= 0) and SOUND_ACTION_METAL_BONK or SOUND_ACTION_BONK,
                m.marioObj.header.gfx.cameraToObject)

            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
            set_mario_action(m, ACT_SOFT_BACKWARD_GROUND_KB, 0)

        elseif step == GROUND_STEP_NONE then
            set_mario_particle_flags(m, PARTICLE_DUST, 0)
        end

        adjust_sound_for_speed(m)
        reset_rumble_timers(m)
    else
        m.forwardVel = m.forwardVel / 2
        set_mario_action(m, ACT_WALKING, 0)
    end
end

---@param m MarioState
local function act_wario_triple_jump(m)
    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_DIVE, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)
    update_air_without_turn(m)
    if m.actionState == 0 then
        m.actionState = m.actionState + 1
        m.vel.y = 72
    end
    common_air_action_step(m, ACT_TRIPLE_JUMP_LAND, CHAR_ANIM_FORWARD_SPINNING, 0)
    if (m.marioObj.header.gfx.animInfo.animFrame == 1) then
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
    end
end

---@param m MarioState
local function act_wario_pile_driver(m)
    local stepResult
    m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ
    if m.actionTimer < 20 then
        m.twirlYaw = m.intendedYaw
        m.angleVel.y = 0x1500 + (m.actionTimer * 0x64)
        m.faceAngle.y = m.faceAngle.y + m.angleVel.y
        m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.angleVel.y
        queue_rumble_data_mario(m, 4, 20)
        play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.header.gfx.cameraToObject)
    end

    if m.actionState == 0 then
        if m.actionTimer == 0 then
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        end

        m.actionTimer = m.actionTimer + 1

        local yVel = 0.0
        if m.actionTimer < 15 then
            yVel = m.actionTimer
        end

        if m.pos.y + yVel + 160.0 < m.ceilHeight then
            m.pos.y = m.pos.y + yVel
            m.peakHeight = m.pos.y
            vec3f_copy(m.marioObj.header.gfx.pos, m.pos)
        end

        mario_set_forward_vel(m, 0.0)
        set_character_animation(m, CHAR_ANIM_GRAB_BOWSER)

        if m.actionTimer >= 20 then
            m.vel.y = -20.0
            m.actionState = 1
        end
    else
        stepResult = perform_air_step(m, 0)

        if stepResult == AIR_STEP_LANDED then
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR
            set_mario_action(m, ACT_WARIO_PILE_DRIVER_LAND, 0)
            if m.playerIndex == 0 then
                set_camera_shake_from_hit(SHAKE_LARGE_DAMAGE)
            end

        elseif stepResult == AIR_STEP_HIT_WALL then
            mario_set_forward_vel(m, -16.0)
            if m.vel.y > 0.0 then
                m.vel.y = 0.0
            end
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
        end
    end
end

---@param m MarioState
local function act_wario_pile_driver_land(m)
    local o = m.heldObj
    m.actionState = 1
    queue_rumble_data_mario(m, 4, 50)
    mario_drop_held_object(m)

    if obj_has_behavior_id(o, id_bhvGoomba) == 1 then
        bhv_goomba_render96_death(o)
    elseif obj_has_behavior_id(o, id_bhvBobomb) == 1 then
        o.oBobombFuseTimer = 152
    end

    if (m.input & INPUT_UNKNOWN_10) ~= 0 then
        return drop_and_set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
    end

    if (m.input & INPUT_OFF_FLOOR) ~= 0 then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
        return set_mario_action(m, ACT_BUTT_SLIDE, 0)
    end

    stationary_ground_step(m)
    set_character_animation(m, CHAR_ANIM_GROUND_POUND_LANDING)

    if is_anim_at_end(m) == 1 then
        return set_mario_action(m, ACT_BUTT_SLIDE_STOP, 0)
    end
end

---@param m MarioState
local function act_wario_hold_idle(m)
    if m.heldObj ~= nil and obj_has_behavior_id(m.heldObj, id_bhvJumpingBox) == 1 then
        return set_mario_action(m, ACT_CRAZY_BOX_BOUNCE, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WARIO_SWING_FLING_START, 0)
    end

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) ~= 0 then
        return drop_and_set_mario_action(m, ACT_IDLE, 0)
    end

    if m.quicksandDepth > 30.0 then
        return drop_and_set_mario_action(m, ACT_IN_QUICKSAND, 0)
    end

    if wario_check_common_hold_idle_cancels(m) then
        return true
    end

    stationary_ground_step(m)
    set_character_animation(m, CHAR_ANIM_IDLE_WITH_LIGHT_OBJ)

    return false
end

---@param m MarioState
local function act_wario_hold_heavy_idle(m)
    if (m.input & INPUT_UNKNOWN_10) ~= 0 then
        return drop_and_set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_WARIO_HOLD_HEAVY_JUMP, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WARIO_SWING_FLING_START, 0)
    end

    if (m.input & INPUT_OFF_FLOOR) ~= 0 then
        return drop_and_set_mario_action(m, ACT_FREEFALL, 0)
    end

    if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
        return drop_and_set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        return set_mario_action(m, ACT_WARIO_HOLD_HEAVY_WALKING, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_HEAVY_THROW, 0)
    end

    stationary_ground_step(m)
    set_character_animation(m, CHAR_ANIM_IDLE_HEAVY_OBJ)

    return false
end

---@param m MarioState
local function wario_anim_and_audio_for_hold_walk(m)
    if not m then return end

    local val04 = m.intendedMag > m.forwardVel and m.intendedMag or m.forwardVel
    if val04 < 2.0 then val04 = 2.0 end

    local running = true
    while running do
        if m.actionTimer == 0 then
            if val04 > 6.0 then
                m.actionTimer = 1
            else
                set_character_anim_with_accel(m, CHAR_ANIM_WALK_WITH_LIGHT_OBJ, 0x60000)
                play_step_sound(m, 12, 62)
                running = false
            end
        elseif m.actionTimer == 1 then
            if val04 < 3.0 then
                m.actionTimer = 0
            elseif val04 > 11.0 then
                m.actionTimer = 2
            else
                set_character_anim_with_accel(m, CHAR_ANIM_WALK_WITH_LIGHT_OBJ, 0x60000)
                play_step_sound(m, 12, 62)
                running = false
            end
        elseif m.actionTimer == 2 then
            if val04 < 8.0 then
                m.actionTimer = 1
            else
                set_character_anim_with_accel(m, CHAR_ANIM_WALK_WITH_LIGHT_OBJ, 0x40000)
                play_step_sound(m, 10, 49)
                running = false
            end
        else
            running = false
        end
    end
end

---@param m MarioState
local function act_wario_hold_walking(m)

    if m.heldObj ~= nil and obj_has_behavior_id(m.heldObj, id_bhvJumpingBox) == 1 then
        return set_mario_action(m, ACT_CRAZY_BOX_BOUNCE, 0)
    end

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) ~= 0 then
        return drop_and_set_mario_action(m, ACT_WALKING, 0)
    end

    if wario_should_begin_sliding(m) then
        return set_mario_action(m, ACT_HOLD_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_THROWING, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_WARIO_HOLD_JUMP, 0)
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return set_mario_action(m, ACT_WARIO_HOLD_DECELERATING, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WARIO_SWING_FLING_START, 0)
    end

    update_walking_speed(m)

    local step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_HOLD_FREEFALL, 0)
    elseif step == GROUND_STEP_NONE then
       if (m.intendedMag - m.forwardVel > 16.0) then
            set_mario_particle_flags(m, PARTICLE_DUST, 0)
       end
    elseif step == GROUND_STEP_HIT_WALL then
        if m.forwardVel > 16.0 then
            mario_set_forward_vel(m, 16.0)
        end
    end

    wario_anim_and_audio_for_hold_walk(m)

    if (0.4 * m.intendedMag - m.forwardVel) > 10.0 then
        set_mario_particle_flags(m, PARTICLE_DUST, 0)
    end

    return 0
end

---@param m MarioState
local function act_wario_hold_decelerating(m)
    if m == nil then return false end

    local slopeClass = mario_get_floor_class(m)

    if m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT ~= 0 then
        return drop_and_set_mario_action(m, ACT_WALKING, 0)
    end

    if wario_should_begin_sliding(m) then
        return drop_and_set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if m.input & INPUT_B_PRESSED ~= 0 then
        return set_mario_action(m, ACT_THROWING, 0)
    end

    if m.input & INPUT_A_PRESSED ~= 0 then
        return set_jumping_action(m, ACT_HOLD_JUMP, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WARIO_SWING_FLING_START, 0)
    end

    if m.input & INPUT_NONZERO_ANALOG ~= 0 then
        return set_mario_action(m, ACT_HOLD_WALKING, 0)
    end

    if wario_update_decelerating_speed(m) then
        return set_mario_action(m, ACT_WARIO_HOLD_IDLE, 0)
    end

    m.intendedMag = m.intendedMag * 0.4

    local groundStep = perform_ground_step(m)

    if groundStep == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_HOLD_FREEFALL, 0)
    elseif groundStep == GROUND_STEP_HIT_WALL then
        if slopeClass == SURFACE_CLASS_VERY_SLIPPERY then
            mario_bonk_reflection(m, 1)
        else
            mario_set_forward_vel(m, 0.0)
        end
    end

    if slopeClass == SURFACE_CLASS_VERY_SLIPPERY then
        set_character_animation(m, CHAR_ANIM_IDLE_WITH_LIGHT_OBJ)
        play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
        adjust_sound_for_speed(m)
        set_mario_particle_flags(m, PARTICLE_DUST, 0)
    else
        local animAccel = _floor(m.forwardVel * 0x10000)
        if animAccel < 0x1000 then
            animAccel = 0x1000
        end

        set_character_anim_with_accel(m, CHAR_ANIM_WALK_WITH_LIGHT_OBJ, animAccel)
        play_step_sound(m, 12, 62)
    end

    return false
end

---@param m MarioState
local function act_wario_hold_heavy_walking(m)

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_HEAVY_THROW, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_WARIO_HOLD_HEAVY_JUMP, 0)
    end

    if wario_should_begin_sliding(m) then
        return drop_and_set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return set_mario_action(m, ACT_HOLD_HEAVY_IDLE, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WARIO_SWING_FLING_START, 0)
    end

    m.intendedMag = m.intendedMag * 0.4

    update_walking_speed(m)

    local step = perform_ground_step(m)
    if step == GROUND_STEP_LEFT_GROUND then
        drop_and_set_mario_action(m, ACT_FREEFALL, 0)
    elseif step == GROUND_STEP_HIT_WALL then
        if m.forwardVel > 10.0 then mario_set_forward_vel(m, 10.0) end
    end

    set_character_anim_with_accel(m, CHAR_ANIM_WALK_WITH_HEAVY_OBJ, 0x40000)
    play_step_sound(m, 26, 79)

    return false
end

---@param m MarioState
local function act_wario_hold_jump(m)

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) ~= 0 then
        return drop_and_set_mario_action(m, ACT_FREEFALL, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 and not (m.heldObj ~= nil and (m.heldObj.oInteractionSubtype & INT_SUBTYPE_HOLDABLE_NPC) ~= 0) then
        return set_mario_action(m, ACT_AIR_THROW, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WARIO_PILE_DRIVER, 0)
    end
    if m.actionState == 0 then
        m.actionState = m.actionState + 1
        m.vel.y = 42
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)
    common_air_action_step(m, ACT_HOLD_JUMP_LAND, CHAR_ANIM_JUMP_WITH_LIGHT_OBJ, AIR_STEP_CHECK_LEDGE_GRAB)
    return false
end

---@param m MarioState
local function act_wario_hold_heavy_jump(m)

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) ~= 0 then
        return drop_and_set_mario_action(m, ACT_FREEFALL, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WARIO_PILE_DRIVER, 0)
    end
    if m.actionState == 0 then
        m.actionState = m.actionState + 1
        m.vel.y = 42
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)
    common_air_action_step(m, ACT_WARIO_HOLD_HEAVY_IDLE, CHAR_ANIM_IDLE_HEAVY_OBJ, AIR_STEP_CHECK_LEDGE_GRAB)
    return false
end

---@param m MarioState
local function act_wario_hold_freefall(m)
    local animation
    if (m.actionArg == 0) then
        animation = CHAR_ANIM_FALL_WITH_LIGHT_OBJ
    else
        animation = CHAR_ANIM_FALL_FROM_SLIDING_WITH_LIGHT_OBJ
    end

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) then
        return drop_and_set_mario_action(m, ACT_FREEFALL, 0)
    end

    if ((m.input & INPUT_B_PRESSED) and not(m.heldObj ~= nil and m.heldObj.oInteractionSubtype & INT_SUBTYPE_HOLDABLE_NPC)) then
        return set_mario_action(m, ACT_AIR_THROW, 0)
    end

    if (m.input & INPUT_Z_PRESSED) then
        return set_mario_action(m, ACT_WARIO_PILE_DRIVER, 0)
    end

    common_air_action_step(m, ACT_HOLD_FREEFALL_LAND, animation, AIR_STEP_CHECK_LEDGE_GRAB)
    return false
end

---@param m MarioState
local function act_wario_swing_fling_start(m)
  if m.actionState == 0 then
        m.actionState = 1
        m.angleVel.y = 0
        if m.heldObj ~= nil then
            queue_rumble_data_mario(m, 5, 80)
            play_character_sound_if_no_flag(m, CHAR_SOUND_HRMM, MARIO_MARIO_SOUND_PLAYED)
        end
    end
    set_character_animation(m, CHAR_ANIM_GRAB_BOWSER)
    m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ

    if is_anim_at_end(m) == 1 then
        set_mario_action(m, ACT_WARIO_SWING_FLING_HELD, 0)
    end

    stationary_ground_step(m)
end

---@param m MarioState
local function act_wario_swing_fling_throw(m)
    m.actionTimer = m.actionTimer + 1

    if m.actionTimer == 1 then
        queue_rumble_data_mario(m, 4, 50)

        if m.actionArg == 0 then
            mario_throw_held_object(m)
        else
            mario_drop_held_object(m)
        end
    end

    m.angleVel.y = 0
    animated_stationary_ground_step(m, CHAR_ANIM_RELEASE_BOWSER, ACT_IDLE)
end

---@param m MarioState
local function act_wario_swing_fling_held(m)
    local spin
    local o = m.heldObj
    if (m.input & INPUT_B_PRESSED) ~= 0 then
        play_character_sound_if_no_flag(m, CHAR_SOUND_HERE_WE_GO, MARIO_MARIO_SOUND_PLAYED)
        return set_mario_action(m, ACT_WARIO_SWING_FLING_THROW, 0)
    end

    if m.angleVel.y == 0 then
        m.actionTimer = m.actionTimer + 1
        if m.actionTimer > 120 then
            return set_mario_action(m, ACT_WARIO_SWING_FLING_THROW, 1)
        end
        set_character_animation(m, CHAR_ANIM_HOLDING_BOWSER)
    else
        m.actionTimer = 0
        set_character_animation(m, CHAR_ANIM_SWINGING_BOWSER)
    end

    if m.intendedMag > 20.0 then
        spin = (m.intendedYaw - m.twirlYaw) / 0x10

        if spin < -0x100 then spin = -0x100 end
        if spin > 0x100 then spin = 0x100 end

        m.twirlYaw = m.intendedYaw
        m.angleVel.y = m.angleVel.y + spin

        if m.angleVel.y > 0x2000 then m.angleVel.y = 0x2000 end
        if m.angleVel.y < -0x2000 then m.angleVel.y = -0x2000 end
    else
        m.actionArg = 0
        m.angleVel.y = approach_s32(m.angleVel.y, 0, 64, 64)
    end

    if m.actionState == 0 then
        if m.angleVel.y <= -0xE00 or m.angleVel.y >= 0xE00 then
            m.actionState = 1
        else
            stationary_ground_step(m)
        end
    end

    if m.actionState > 0 then
        if obj_has_behavior_id(o, id_bhvBobomb) == 1 then
            if o.oBobombFuseTimer >= 150 then
                o.oBobombFuseTimer = 125
            end
        end
        if m.angleVel.y <= -0xE00 then m.angleVel.y = -0x1800 end
        if m.angleVel.y >= 0xE00 then m.angleVel.y = 0x1800 end

        if wario_swing_fling_spin(m) then
            return 1
        end

        m.actionState = m.actionState + 1
        if m.actionState % 5 == 0 and wario_swing_fling_spin_should_spawn_coins(o) then
            spawn_non_sync_object(
                id_bhvWarioCoins, E_MODEL_GREEN_COIN,
                m.marioObj.oPosX +(random_float() * 20),
                m.marioObj.oPosY + 100,
                m.marioObj.oPosZ + (random_float() * 20),
                function (coin)
                    coin.globalPlayerIndex = network_global_index_from_local(m.playerIndex)
                end)
        end
        set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)
        if m.actionState >= 135 then
            play_character_sound_if_no_flag(m, CHAR_SOUND_SO_LONGA_BOWSER, MARIO_MARIO_SOUND_PLAYED)
            return set_mario_action(m, ACT_WARIO_SWING_FLING_THROW, 0)
        end
    end

    spin = m.faceAngle.y
    m.faceAngle.y = m.faceAngle.y + m.angleVel.y

    if m.angleVel.y <= -0x100 and spin < m.faceAngle.y then
        queue_rumble_data_mario(m, 4, 20)
        play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.header.gfx.cameraToObject)
    end

    if m.angleVel.y >= 0x100 and spin > m.faceAngle.y then
        queue_rumble_data_mario(m, 4, 20)
        play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.header.gfx.cameraToObject)
    end
end

---@param m MarioState
local function act_wario_ground_pound(m)
    local stepResult
    local yOffset

    if m.actionState == 0 then
        if m.vel.y > 0.0 then
            m.vel.y = 0.0
        end

        if m.actionTimer < 10 then
            yOffset = 20 - 2 * m.actionTimer
            if m.pos.y + yOffset + 160.0 < m.ceilHeight then
                m.pos.y = m.pos.y + yOffset
                m.peakHeight = m.pos.y
                vec3f_copy(m.marioObj.header.gfx.pos, m.pos)
            end
        end

        stepResult = perform_air_step(m, 0)
        mario_set_forward_vel(m, 0.0)

        if m.actionArg == 0 then
            set_mario_animation(m, MARIO_ANIM_START_GROUND_POUND)
        else
            set_mario_animation(m, MARIO_ANIM_TRIPLE_JUMP_GROUND_POUND)
        end

        if m.actionTimer == 0 then
            play_sound(SOUND_ACTION_THROW, m.marioObj.header.gfx.cameraToObject)
            play_character_sound(m, CHAR_SOUND_GROUND_POUND_WAH)
        end

        m.actionTimer = m.actionTimer + 1

        local anim = m.marioObj.header.gfx.animInfo.curAnim
        if m.actionTimer >= anim.loopEnd + 4 or stepResult == AIR_STEP_LANDED then
            m.actionState = 1
        end

    else
        set_mario_animation(m, MARIO_ANIM_GROUND_POUND)

        stepResult = perform_air_step(m, 0)

        if stepResult == AIR_STEP_HIT_WALL then
            mario_set_forward_vel(m, -16.0)
            if m.vel.y > 0.0 then
                m.vel.y = 0.0
            end

            m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
        end
    end

    if stepResult == AIR_STEP_LANDED then
        play_sound(SOUND_ACTION_UNK3C, m.marioObj.header.gfx.cameraToObject)

        if should_get_stuck_in_ground(m) == 1 then
            play_character_sound(m, CHAR_SOUND_ATTACKED)
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            set_mario_action(m, ACT_BUTT_STUCK_IN_GROUND, 0)

        elseif check_fall_damage(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR
            set_mario_action(m, ACT_GROUND_POUND_LAND, 0)
            if m.playerIndex == 0 then
                set_camera_shake_from_hit(SHAKE_LARGE_DAMAGE)
            end
        end
    end

    return false
end

-----------
-- Hooks --
-----------

---@param m MarioState
---@param incomingAct integer
local function wario_before_actions(m, incomingAct)
    if (incomingAct == ACT_DIVE and m.vel.y == 20) then return ACT_WARIO_CHARGE end -- check_ground_dive_or_punch
    if (incomingAct == ACT_TRIPLE_JUMP) then return ACT_WARIO_TRIPLE_JUMP end
    if (incomingAct == ACT_HOLD_JUMP) then return ACT_WARIO_HOLD_JUMP end
    if (incomingAct == ACT_HOLD_FREEFALL) then return ACT_WARIO_HOLD_FREEFALL end
    if (incomingAct == ACT_GROUND_POUND) then return ACT_WARIO_GROUND_POUND end
    if (incomingAct == ACT_HOLD_IDLE) then return ACT_WARIO_HOLD_IDLE end
    if (incomingAct == ACT_HOLD_WALKING) then return ACT_WARIO_HOLD_WALKING end
    if (incomingAct == ACT_HOLD_HEAVY_IDLE) then return ACT_WARIO_HOLD_HEAVY_IDLE end
    if (incomingAct == ACT_HOLD_HEAVY_WALKING) then return ACT_WARIO_HOLD_HEAVY_WALKING end
end

---@param m MarioState
local function wario_update(m)
    if (m.action == ACT_WALKING) and m.forwardVel >= 29 and m.floor ~= nil then
        set_mario_particle_flags(m, PARTICLE_DUST, 0)
    end

    -- Grab animation
    local o = m.marioObj
    local lightGrabAnim = gWarioGrabLightAnims[o.header.gfx.animInfo.animID]
    if lightGrabAnim then
        smlua_anim_util_set_animation(o, lightGrabAnim)
        o.oSwitchState1 = 1
    else
        o.oSwitchState1 = 0
    end
end

hook_event(HOOK_ON_MODS_LOADED, function ()
    charSelect.character_set_locked(CT_WARIO, is_wario_unlocked, true, "\\#dd0\\Wario\\#\\")
    charSelect.character_hook_moveset(CT_WARIO, HOOK_BEFORE_SET_MARIO_ACTION, wario_before_actions)
    charSelect.character_hook_moveset(CT_WARIO, HOOK_MARIO_UPDATE, wario_update)
end)

hook_mario_action(ACT_WARIO_CHARGE,             act_wario_charge, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_WARIO_TRIPLE_JUMP,        act_wario_triple_jump)
hook_mario_action(ACT_WARIO_HOLD_IDLE,          act_wario_hold_idle)
hook_mario_action(ACT_WARIO_HOLD_HEAVY_IDLE,    act_wario_hold_heavy_idle)
hook_mario_action(ACT_WARIO_HOLD_WALKING,       act_wario_hold_walking)
hook_mario_action(ACT_WARIO_HOLD_HEAVY_WALKING, act_wario_hold_heavy_walking)
hook_mario_action(ACT_WARIO_HOLD_JUMP,          act_wario_hold_jump)
hook_mario_action(ACT_WARIO_HOLD_HEAVY_JUMP,    act_wario_hold_heavy_jump)
hook_mario_action(ACT_WARIO_HOLD_FREEFALL,      act_wario_hold_freefall)
hook_mario_action(ACT_WARIO_HOLD_DECELERATING,  act_wario_hold_decelerating)
hook_mario_action(ACT_WARIO_PILE_DRIVER,        act_wario_pile_driver, INT_GROUND_POUND)
hook_mario_action(ACT_WARIO_PILE_DRIVER_LAND,   act_wario_pile_driver_land, INT_GROUND_POUND)
hook_mario_action(ACT_WARIO_SWING_FLING_START,  act_wario_swing_fling_start)
hook_mario_action(ACT_WARIO_SWING_FLING_HELD,   act_wario_swing_fling_held)
hook_mario_action(ACT_WARIO_SWING_FLING_THROW,  act_wario_swing_fling_throw)
hook_mario_action(ACT_WARIO_GROUND_POUND,       act_wario_ground_pound, INT_GROUND_POUND)

------------------------
-- Behavior functions --
------------------------

---@param o Object
---@param dist number
---@param actions table
function obj_hit_by_wario_action(o, dist, actions)
    for i = 0, MAX_PLAYERS - 1 do
        local m = gMarioStates[i]
        if actions[m.action] and m.marioObj and charSelect.character_get_current_number(i) == CT_WARIO and is_player_active(m) == 1 and dist_between_objects(o, m.marioObj) <= dist then
            return true, m
        end
    end
    return false, nil
end

---@param o Object
---@param dist number
function obj_hit_by_wario_charge(o, dist)
    return obj_hit_by_wario_action(o, dist, { [ACT_WARIO_CHARGE] = true })
end

---@param o Object
function obj_ground_pounded_by_wario(o)
    for i = 0, MAX_PLAYERS - 1 do
        local m = gMarioStates[i]
        if charSelect.character_get_current_number(i) == CT_WARIO and is_player_active(m) == 1 and obj_is_mario_ground_pounding_platform(m, o) == 1 then
            return true, m
        end
    end
    return false, nil
end

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_held_obj(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = o.oSwitchState1
end
