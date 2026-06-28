local r96lib = require("/lib/r96lib")
require("constants")

local _floor  = math.floor
local _abs    = math.abs
local _max    = math.max
local _min    = math.min
local _sqrt   = math.sqrt
local _random = math.random
local _sin    = math.sin
local _cos    = math.cos
local _pi     = math.pi

-- Config Character Select to add Vanilla models
--local E_MODEL_R96_MARIO = smlua_model_util_get_id("r96_mario_geo")
--_G.charSelect.character_add_costume(CT_MARIO, "Vanilla Mario", nil, nil, nil, E_MODEL_MARIO)
--_G.charSelect.character_edit(CT_MARIO, nil, nil, "Render96", nil, E_MODEL_R96_MARIO)

--[[
local E_MODEL_R96_WARIO = smlua_model_util_get_id("r96_wario_geo")
_G.charSelect.character_add_costume(CT_WARIO, "Vanilla Wario", nil, nil, nil, E_MODEL_WARIO)
_G.charSelect.character_edit(CT_WARIO, nil, nil, "Render96", nil, E_MODEL_R96_WARIO)
]]

local sWarioWalkSpin = false
local sWarioSpinCount = 0
local sWarioChargeCount = 0

local function wario_should_begin_sliding(m)
    if m == nil then return false end

    if m.input & INPUT_ABOVE_SLIDE ~= 0 then
        local slideLevel = (m.area.terrainType & TERRAIN_MASK) == TERRAIN_SLIDE
        local movingBackward = m.forwardVel <= -1.0

        if slideLevel or movingBackward or mario_facing_downhill(m, false) then
            return true
        end
    end

    return false
end

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

-- WARIO MOVESET

---@param m MarioState
local function act_wario_charge(m)
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        sWarioChargeCount = 0
        return set_mario_action(m, ACT_WARIO_TRIPLE_JUMP, 0)
    end

    if sWarioChargeCount == 0 then
        if (m.flags & MARIO_MARIO_SOUND_PLAYED) == 0 then
            play_character_sound_offset(m, CHAR_SOUND_YAHOO_WAHA_YIPPEE, ((random_u16() % 3) << 16))
            m.flags = m.flags | MARIO_MARIO_SOUND_PLAYED
        end
    end

    sWarioChargeCount = sWarioChargeCount + 1

    if sWarioChargeCount < 60 then
        local sYaw = r96lib.convert_s16(m.intendedYaw - m.faceAngle.y)
        sYaw = _max(-0x300, _min(0x300, sYaw))
        m.intendedYaw = m.faceAngle.y + sYaw

        update_shell_speed(m)
        queue_rumble_data_mario(m, 5, 80)

        if m.forwardVel < 29.0 then m.forwardVel = m.forwardVel + 1.5 end

        set_character_anim_with_accel(m, CHAR_ANIM_RUNNING_UNUSED, 0x90000)
        play_step_sound(m, 9, 45)

        local step = perform_ground_step(m)

        if step == GROUND_STEP_LEFT_GROUND then
            sWarioChargeCount = 0
            set_mario_action(m, ACT_FREEFALL, 0)
            set_character_animation(m, CHAR_ANIM_GENERAL_FALL)

        elseif step == GROUND_STEP_HIT_WALL then
            sWarioChargeCount = 0
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
        sWarioChargeCount = 0
        m.forwardVel = 1
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

local sPileDriverTimer = 0

---@param m MarioState
local function act_wario_pile_driver(m)
    local stepResult
    m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ
    if sPileDriverTimer < 20 then
        m.twirlYaw = m.intendedYaw
        m.angleVel.y = 0x1500 + (sPileDriverTimer * 0x64)
        m.faceAngle.y = m.faceAngle.y + m.angleVel.y
        m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.angleVel.y
        queue_rumble_data_mario(m, 4, 20)
        play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.header.gfx.cameraToObject)
    end

    if m.actionState == 0 then
        if m.actionTimer == 0 then
            sPileDriverTimer = 0
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        end

        sPileDriverTimer = sPileDriverTimer + 1
        m.actionTimer = m.actionTimer + 1

        local yVel = 0.0
        if sPileDriverTimer < 15 then
            yVel = sPileDriverTimer
        end

        if m.pos.y + yVel + 160.0 < m.ceilHeight then
            m.pos.y = m.pos.y + yVel
            m.peakHeight = m.pos.y
            vec3f_copy(m.marioObj.header.gfx.pos, m.pos)
        end

        mario_set_forward_vel(m, 0.0)
        set_character_animation(m, CHAR_ANIM_GRAB_BOWSER)

        if sPileDriverTimer >= 20 then
            m.vel.y = -20.0
            m.actionState = 1
        end
    else
        stepResult = perform_air_step(m, 0)

        if stepResult == AIR_STEP_LANDED then
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR
            set_camera_shake_from_hit(SHAKE_LARGE_DAMAGE)
            set_mario_action(m, ACT_WARIO_PILE_DRIVER_LAND, 0)

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
    if obj_has_behavior_id(o, id_bhvRender96Goomba) == 1 then
        spawn_mist_particles()
        obj_spawn_yellow_coins(o, o.oNumLootCoins)
        create_sound_spawner(SOUND_OBJ_STOMPED)
        o.oAction = OBJ_ACT_SQUISHED
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        obj_mark_for_deletion(o)
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

    if is_anim_at_end(m) then
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
                local val0C
                if get_character(m).type == CT_WARIO then
                    val0C = 0x60000
                else
                    val0C = _floor(val04 * 0x10000)
                end
                set_character_anim_with_accel(m, CHAR_ANIM_SLOW_WALK_WITH_LIGHT_OBJ, val0C)
                play_step_sound(m, 12, 62)
                running = false
            end
        elseif m.actionTimer == 1 then
            if val04 < 3.0 then
                m.actionTimer = 0
            elseif val04 > 11.0 then
                m.actionTimer = 2
            else
                local val0C
                if get_character(m).type == CT_WARIO then
                    val0C = 0x60000
                else
                    val0C = _floor(val04 * 0x10000)
                end
                set_character_anim_with_accel(m, CHAR_ANIM_WALK_WITH_LIGHT_OBJ, val0C)
                play_step_sound(m, 12, 62)
                running = false
            end
        elseif m.actionTimer == 2 then
            if val04 < 8.0 then
                m.actionTimer = 1
            else
                local val0C
                if get_character(m).type == CT_WARIO then
                    val0C = 0x40000
                else
                    val0C = _floor(val04 / 2.0 * 0x10000)
                end
                set_character_anim_with_accel(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ, val0C)
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
            mario_bonk_reflection(m, true)
        else
            mario_set_forward_vel(m, 0.0)
        end
    end

    if slopeClass == SURFACE_CLASS_VERY_SLIPPERY then
        set_character_animation(m, CHAR_ANIM_IDLE_WITH_LIGHT_OBJ)
        play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
        adjust_sound_for_speed(m)
        set_mario_particle_flags(m, PARTICLE_DUST, false)
    else
        local val0C = _floor(m.forwardVel * 0x10000)
        if val0C < 0x1000 then
            val0C = 0x1000
        end

        set_character_anim_with_accel(m, CHAR_ANIM_WALK_WITH_LIGHT_OBJ, val0C)
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

    if is_anim_at_end(m) then
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
        sWarioWalkSpin = false
        sWarioSpinCount = 0
        set_mario_action(m, ACT_FREEFALL, 0)
        set_character_animation(m, CHAR_ANIM_GENERAL_FALL)
    end
end

local sSkipBehaviors = {
    id_bhvMips,
    id_bhvUkiki,
    id_bhvBreakableBoxSmall,
    id_bhvSmallPenguin,
    id_bhvUnused20E0,
}

local function is_skipped_behavior(o)
    for _, bhv in ipairs(sSkipBehaviors) do
        if obj_has_behavior_id(o, bhv) == 1 then return true end
    end
    return false
end

---@param m MarioState
local function act_wario_swing_fling_held(m)
    local spin
    local o = m.heldObj
    if (m.input & INPUT_B_PRESSED) ~= 0 then
        play_character_sound_if_no_flag(m, CHAR_SOUND_HERE_WE_GO, MARIO_MARIO_SOUND_PLAYED)
        sWarioWalkSpin = false
        sWarioSpinCount = 0
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

    if not sWarioWalkSpin then
        if m.angleVel.y <= -0xE00 or m.angleVel.y >= 0xE00 then
            sWarioWalkSpin = true
        else
            stationary_ground_step(m)
        end
    end

    if sWarioWalkSpin then
        if obj_has_behavior_id(o, id_bhvBobomb) == 1 then
            if o.oBobombFuseTimer >= 150 then 
                o.oBobombFuseTimer = 125
            end
        end
        if m.angleVel.y <= -0xE00 then m.angleVel.y = -0x1800 end
        if m.angleVel.y >= 0xE00 then m.angleVel.y = 0x1800 end

        wario_swing_fling_spin(m)
        sWarioSpinCount = sWarioSpinCount + 1
        if sWarioSpinCount % 5 == 0 and not is_skipped_behavior(o) then
            spawn_non_sync_object(id_bhvWarioCoins, E_MODEL_GREEN_COIN, m.marioObj.oPosX +(random_float() * 20), m.marioObj.oPosY + 100, m.marioObj.oPosZ + (random_float() * 20), nil)
        end
        set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)
        if sWarioSpinCount >= 135 then
            play_character_sound_if_no_flag(m, CHAR_SOUND_SO_LONGA_BOWSER, MARIO_MARIO_SOUND_PLAYED)
            sWarioWalkSpin = false
            sWarioSpinCount = 0
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
            set_camera_shake_from_hit(SHAKE_LARGE_DAMAGE)
            set_mario_action(m, ACT_GROUND_POUND_LAND, 0)
        end
    end

    return false
end

-- LUIGI MOVESET

local sScuttleTimer = 0

local sScuttleRun = {
    [ACT_JUMP] = true,
}

---@param m MarioState
local function act_luigi_twirling(m)
    if not m then return 0 end

    local startTwirlYaw = m.twirlYaw
    local yawVelTarget

    if (m.input & INPUT_Z_DOWN) ~= 0 then
        return set_mario_action(m, ACT_LUIGI_TWIRLING_DOWN, 0)
    else 
        if m.vel.y < -7.0 then m.vel.y = -7.0 end
    end

    yawVelTarget = 0x2000

    m.angleVel.y = approach_s32(m.angleVel.y, yawVelTarget, 0x200, 0x200)
    m.twirlYaw = m.twirlYaw + m.angleVel.y

    if m.heldObj ~= nil then
        set_character_animation(m, CHAR_ANIM_PICK_UP_LIGHT_OBJ)
    else
        local anim = (m.actionArg == 0) and CHAR_ANIM_START_TWIRL or CHAR_ANIM_TWIRL
        set_character_animation(m, anim)
    end

    if is_anim_past_end(m) then
        m.actionArg = 1
    end

    if startTwirlYaw > m.twirlYaw then
        play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject)
    end

    update_lava_boost_or_twirling(m)
    local stepResult = perform_air_step(m, 0)

    if stepResult == AIR_STEP_LANDED then set_mario_action(m, ACT_TWIRL_LAND, 0)
    elseif stepResult == AIR_STEP_HIT_WALL then mario_bonk_reflection(m, 0)
    elseif stepResult == AIR_STEP_HIT_LAVA_WALL then lava_boost_on_wall(m) end
    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.twirlYaw

    return false
end

---@param m MarioState
local function act_luigi_twirling_down(m)
    if not m then return 0 end
    local startTwirlYaw = m.twirlYaw
    m.vel.y = -40

    m.angleVel.y = 0x3000
    m.twirlYaw = m.twirlYaw + m.angleVel.y

    if m.heldObj ~= nil then
        set_character_animation(m, CHAR_ANIM_PICK_UP_LIGHT_OBJ)
    else
        local anim = (m.actionArg == 0) and CHAR_ANIM_START_TWIRL or CHAR_ANIM_TWIRL
        set_character_animation(m, anim)
    end

    if is_anim_past_end(m) then
        m.actionArg = 1
    end

    if startTwirlYaw > m.twirlYaw then
        play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject)
    end

    update_lava_boost_or_twirling(m)
    local stepResult = perform_air_step(m, 0)

    if stepResult == AIR_STEP_LANDED then set_mario_action(m, ACT_TWIRL_LAND, 0)
    elseif stepResult == AIR_STEP_HIT_WALL then mario_bonk_reflection(m, 0)
    elseif stepResult == AIR_STEP_HIT_LAVA_WALL then lava_boost_on_wall(m) end
    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.twirlYaw

    return false
end

---@param m MarioState
local function act_luigi_backflip(m)
    if m.actionTimer == 0 then
        m.vel.y = m.vel.y + 1.75
    end

    if m.marioObj.header.gfx.animInfo.animFrame > 17.5 then
        return set_mario_action(m, ACT_LUIGI_TWIRLING, 0)
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, CHAR_SOUND_YAH_WAH_HOO)
    common_air_action_step(m, ACT_BACKFLIP_LAND, CHAR_ANIM_BACKFLIP, 0)
    if m.action == ACT_BACKFLIP_LAND then queue_rumble_data_mario(m, 5, 40) end
    play_flip_sounds(m, 2, 3, 17)

    return false
end

local sMoveAngle = 0

---@param m MarioState
local function scuttle_physics(m)
    if sScuttleTimer <= 20 then
        m.vel.y = 2 - (sScuttleTimer * 0.8)
    end
    sScuttleTimer = sScuttleTimer + 1
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        if sMoveAngle == 0 then
            sMoveAngle = m.faceAngle.y
        end

        sMoveAngle = m.intendedYaw - approach_s32( r96lib.convert_s16(m.intendedYaw - sMoveAngle), 0, 0x400, 0x400)
        m.forwardVel = approach_f32(m.forwardVel, m.intendedMag * 0.8, 4.0, 4.0)
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
local function act_luigi_scuttle_run(m)
    if (m.input & INPUT_A_DOWN) == 0 or m.vel.y < -25 then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    set_character_anim_with_accel(m, CHAR_ANIM_RUNNING, 0x100000)
    scuttle_physics(m)

    local landed = perform_air_step(m, AIR_STEP_LANDED | AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG)
    if landed == AIR_STEP_LANDED then set_mario_action(m, ACT_JUMP_LAND, 0) end
    if landed == AIR_STEP_GRABBED_LEDGE then
        set_character_animation(m, CHAR_ANIM_IDLE_ON_LEDGE)
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
    end
    if landed == AIR_STEP_GRABBED_CEILING then set_mario_action(m, ACT_START_HANGING, 0) end
end

---@param m MarioState
local function act_luigi_scuttle_run_hold(m)
    if (m.input & INPUT_A_DOWN) == 0 or m.vel.y < -25 then
        return set_mario_action(m, ACT_HOLD_FREEFALL, 0)
    end

    set_character_anim_with_accel(m, CHAR_ANIM_RUN_WITH_LIGHT_OBJ, 0x100000)
    scuttle_physics(m)

    local landed = perform_air_step(m, AIR_STEP_LANDED | AIR_STEP_CHECK_LEDGE_GRAB)
    if landed == AIR_STEP_LANDED then set_mario_action(m, ACT_HOLD_JUMP_LAND, 0) end
    if landed == AIR_STEP_GRABBED_LEDGE then
        set_character_animation(m, CHAR_ANIM_IDLE_ON_LEDGE)
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
    end
end

-- YOSHI MOVESET

local sFlutterTimer = 0

local sFlutterJump = {
    [ACT_YOSHI_RIDE_JUMP] = true,
}

---@param m MarioState
local function flutter_physics(m)
    sFlutterTimer = sFlutterTimer + 1
    if sFlutterTimer == 1 then
        m.vel.y = 15
    elseif sFlutterTimer <= 45 then
        m.vel.y = 15 * 0.01 * sFlutterTimer
        if m.vel.y < -3 then
            m.vel.y = -3
        end
    else
        local gravity = (45 - sFlutterTimer )
        m.vel.y = 15 * 0.1 * gravity
    end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        if sMoveAngle == 0 then
            sMoveAngle = m.faceAngle.y
        end

        sMoveAngle = m.intendedYaw - approach_s32( r96lib.convert_s16(m.intendedYaw - sMoveAngle), 0, 0x400, 0x400)
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

local function yoshi_dismount(m)
    if (m.controller.buttonPressed & Z_TRIG) ~= 0 then
        mario_stop_riding_object(m)
        m.pos.y = m.marioObj.header.gfx.pos.y
        set_mario_action(m, ACT_TRIPLE_JUMP, 0)
    end
end

local function yoshi_walk_speed(m)
    local targetSpeed = (m.floor ~= nil and m.floor.type == SURFACE_SLOW) and 32.0 or 48.0
    if m.intendedMag < 24 then targetSpeed = m.intendedMag end
    if m.quicksandDepth > 10.0 then targetSpeed = targetSpeed * (6.25 / m.quicksandDepth) end

    if     m.forwardVel <= 0.0        then m.forwardVel = m.forwardVel + 1.1
    elseif m.forwardVel <= targetSpeed then m.forwardVel = m.forwardVel + (1.1 - m.forwardVel / targetSpeed)
    elseif m.floor ~= nil and m.floor.normal.y >= 0.95 then m.forwardVel = m.forwardVel - 1.0 end

    if m.forwardVel > 64.0 then m.forwardVel = 64.0 end

    m.faceAngle.y = m.intendedYaw - approach_s32(r96lib.convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x800, 0x800)
    apply_slope_accel(m)
end

local function act_yoshi_ride_idle(m)
    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, "MARIO_RIDING_YOSHI_IDLE")
    yoshi_dismount(m)

    if stationary_ground_step(m) == GROUND_STEP_LEFT_GROUND then
        return set_mario_action(m, ACT_YOSHI_RIDE_FALL, 0)
    end
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_YOSHI_RIDE_JUMP, 0)
    end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        m.faceAngle.y = m.intendedYaw
        return set_mario_action(m, ACT_YOSHI_RIDE_WALK, 0)
    end
    mario_set_forward_vel(m, 0)
end

local function act_yoshi_ride_walk(m)
    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, "MARIO_RIDING_YOSHI_IDLE")
    yoshi_walk_speed(m)

    local step = perform_ground_step(m)
    if step == GROUND_STEP_LEFT_GROUND then
        return set_mario_action(m, ACT_YOSHI_RIDE_FALL, 1)
    elseif step == GROUND_STEP_HIT_WALL then
        m.forwardVel = 6
        if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
            return set_mario_action(m, ACT_YOSHI_RIDE_IDLE, 0)
        end
    elseif step == GROUND_STEP_NONE then
        if m.intendedMag - m.forwardVel > 16.0 then
            m.particleFlags = m.particleFlags | PARTICLE_DUST
        end
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then return set_mario_action(m, ACT_YOSHI_RIDE_JUMP, 0) end
    if _abs(m.forwardVel) <= 1 then return set_mario_action(m, ACT_YOSHI_RIDE_IDLE, 0) end
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 and m.forwardVel <= 5 then mario_set_forward_vel(m, 5) end
    yoshi_dismount(m)
end

local function act_yoshi_ride_jump(m)
    if m.actionTimer == 0 then 
        play_character_sound(m, CHAR_SOUND_YAH_WAH_HOO) 
        m.vel.y = _max(_min(80.0, 15.0 + _abs(m.vel.y)), 40.0)
    end
    update_air_without_turn(m)
    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_YOSHI_RIDE_WALK, 0)
    end
    yoshi_dismount(m)
    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, "MARIO_RIDING_YOSHI_IDLE")
    m.actionTimer = m.actionTimer + 1
end

---@param m MarioState
local function act_yoshi_ride_flutter(m)
    if (m.input & INPUT_A_DOWN) == 0 or m.vel.y < -10 then
        return set_mario_action(m, ACT_YOSHI_RIDE_FALL, 0)
    end

    flutter_physics(m)
    yoshi_dismount(m)
    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, "MARIO_RIDING_YOSHI_IDLE")
    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_YOSHI_RIDE_WALK, 0)
    end
end

---@param m MarioState
local function act_yoshi_ride_fall(m)
    if m.actionTimer > 0 and (m.controller.buttonDown & A_BUTTON) ~= 0 and m.vel.y < 0 then
        return set_mario_action(m, ACT_YOSHI_RIDE_FLUTTER, 0)
    end

    update_air_without_turn(m)
    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_YOSHI_RIDE_WALK, 0)
    end

    yoshi_dismount(m)
    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, "MARIO_RIDING_YOSHI_IDLE")
    m.actionTimer = m.actionTimer + 1
end

---@param m MarioState
local function act_yoshi_ride_land(m)

common_landing_action(m, CHAR_ANIM_LAND_FROM_SINGLE_JUMP, ACT_FREEFALL);

    update_air_without_turn(m)
    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_YOSHI_RIDE_WALK, 0)
    end

    yoshi_dismount(m)
    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ)
    smlua_anim_util_set_animation(m.marioObj, YOSHI_ANIM_RIDABLE_FLUTTER_FALL)
    m.actionTimer = m.actionTimer + 1
end

---@param m MarioState
---@param incomingAct integer
local function wario_before_actions(m, incomingAct)
    if (incomingAct == ACT_DIVE and m.vel.y == 20) then return ACT_WARIO_CHARGE end
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
end

local sLuigiJumpActions = {
    [ACT_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
}

---@param m MarioState
local function luigi_update(m)
    if m.prevAction & ACT_FLAG_AIR == 0 and 
    m.action & ACT_FLAG_AIR ~= 0 and 
    m.input & INPUT_A_DOWN ~= 0 and 
    m.vel.y < 0 then
        if sScuttleRun[m.action] then set_mario_action(m, ACT_LUIGI_SCUTTLE_RUN, 0)
        elseif m.action == ACT_HOLD_JUMP then set_mario_action(m, ACT_LUIGI_SCUTTLE_RUN_HOLD, 0) end
        sScuttleTimer = 0
    end

    if m.prevAction & ACT_FLAG_AIR == 0 and 
    m.action & ACT_FLAG_AIR ~= 0 and 
    m.input & INPUT_A_PRESSED ~= 0 and 
    sLuigiJumpActions[m.action] then
        m.vel.y = m.vel.y + 6.0  -- small height boost
    end

    if m.action == ACT_BACKFLIP then set_mario_action(m, ACT_LUIGI_BACKFLIP, 0) end
    if m.action == ACT_TWIRLING then set_mario_action(m, ACT_LUIGI_TWIRLING, 0) end
end

---@param m MarioState
local function luigi_before_phys_step(m)

    local floorClass = mario_get_floor_class(m)

    if (m.action == ACT_WALKING) then
        if (floorClass == SURFACE_CLASS_VERY_SLIPPERY or floorClass == SURFACE_CLASS_SLIPPERY) then
            if m.forwardVel >= 29 then m.forwardVel = 37
        elseif m.forwardVel >= 29 then m.forwardVel = 34 end
        end
    end

    if (m.action == ACT_BRAKING or m.action == ACT_TURNING_AROUND) then
        if (floorClass == SURFACE_CLASS_NOT_SLIPPERY) then m.forwardVel = m.forwardVel + 5
        elseif (floorClass == SURFACE_CLASS_DEFAULT) then m.forwardVel = m.forwardVel + 3 end
        if (m.forwardVel < 0) then m.forwardVel = 0 end
    end
end

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

hook_mario_action(ACT_LUIGI_SCUTTLE_RUN,        act_luigi_scuttle_run)
hook_mario_action(ACT_LUIGI_SCUTTLE_RUN_HOLD,   act_luigi_scuttle_run_hold)
hook_mario_action(ACT_LUIGI_BACKFLIP,           act_luigi_backflip)
hook_mario_action(ACT_LUIGI_TWIRLING,           act_luigi_twirling)
hook_mario_action(ACT_LUIGI_TWIRLING_DOWN,      act_luigi_twirling_down, INT_GROUND_POUND)

hook_mario_action(ACT_YOSHI_RIDE_IDLE,          act_yoshi_ride_idle )
hook_mario_action(ACT_YOSHI_RIDE_WALK,          act_yoshi_ride_walk )
hook_mario_action(ACT_YOSHI_RIDE_JUMP,          act_yoshi_ride_jump )
hook_mario_action(ACT_YOSHI_RIDE_FLUTTER,       act_yoshi_ride_flutter )
hook_mario_action(ACT_YOSHI_RIDE_FALL,          act_yoshi_ride_fall )

hook_event(HOOK_MARIO_UPDATE, function(m)
    if m.prevAction & ACT_FLAG_AIR == 0 and 
    m.action & ACT_FLAG_AIR ~= 0 and 
    m.input & INPUT_A_DOWN ~= 0 and 
    m.vel.y < 0 then
        if sFlutterJump[m.action] then set_mario_action(m, ACT_YOSHI_RIDE_FLUTTER, 0) end
        sFlutterTimer = 0
    end
end)

local function luigi_bool()
    if gNumLuigiKeys ~= 8 then return false end
    if gNumLuigiKeys == 8 then return true end
end

local function wario_bool()
    if gNumWarioCoins ~= 6 then return false end
    if gNumWarioCoins == 6 then return true end
end

hook_event(HOOK_ON_MODS_LOADED, function ()
    if _G.charSelect ~= nil then
        -- Luigi
        _G.charSelect.character_set_locked(CT_LUIGI, luigi_bool, true)
        _G.charSelect.character_hook_moveset(CT_LUIGI, HOOK_BEFORE_PHYS_STEP, luigi_before_phys_step)
        _G.charSelect.character_hook_moveset(CT_LUIGI, HOOK_MARIO_UPDATE, luigi_update)
        -- Wario
        _G.charSelect.character_set_locked(CT_WARIO, wario_bool, true)
        _G.charSelect.character_hook_moveset(CT_WARIO, HOOK_BEFORE_SET_MARIO_ACTION, wario_before_actions)
        _G.charSelect.character_hook_moveset(CT_WARIO, HOOK_MARIO_UPDATE, wario_update)
    end
end)

local sTongueEnemyBehaviors = {
    [id_bhvRender96Goomba] = true,
    [id_bhvBobomb] = true,
}

---@param m MarioState
local function tongue_find_target(m)
    local bestObj, bestDist = nil, TONGUE_RADIUS
    local o = obj_get_first(OBJ_LIST_GENACTOR)

    while o ~= nil do
        local isEnemy = false
        for behId in pairs(sTongueEnemyBehaviors) do
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
    local target = tongue_find_target(m)
    local tongue = spawn_non_sync_object(id_bhvRender96YoshiTongue, E_MODEL_YOSHI_TONGUE,
        m.marioObj.oPosX, m.marioObj.oPosY + 60.0, m.marioObj.oPosZ, nil)

    tongue.oAction = TONGUE_STATE_EXTENDING
    tongue.oTongueU = 0.0

    if target == nil then
        tongue.oTongueLockX = m.marioObj.oPosX + sins(m.faceAngle.y) * TONGUE_RADIUS
        tongue.oTongueLockY = m.marioObj.oPosY + 60.0
        tongue.oTongueLockZ = m.marioObj.oPosZ + coss(m.faceAngle.y) * TONGUE_RADIUS
    else
        tongue.parentObj = target
    end
end

local sYoshiRideActions = {
    [ACT_YOSHI_RIDE_IDLE] = true, [ACT_YOSHI_RIDE_WALK] = true,
    [ACT_YOSHI_RIDE_JUMP] = true, [ACT_YOSHI_RIDE_FLUTTER] = true, [ACT_YOSHI_RIDE_FALL] = true,
}

---@param m MarioState
local function yoshi_update(m)
    if sYoshiRideActions[m.action] and (m.input & INPUT_B_PRESSED) ~= 0 then
        yoshi_tongue_attack(m)
    end
end

hook_event(HOOK_MARIO_UPDATE, yoshi_update)