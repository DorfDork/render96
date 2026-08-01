local charSelect = require("/lib/char-select")
require("/constants")

local LUIGI_JUMP_ACTIONS = T{
    ACT_JUMP,
    ACT_DOUBLE_JUMP,
    ACT_TRIPLE_JUMP,
}

local LUIGI_SCUTTLE_RUN_ACTIONS = T{
    ACT_JUMP,
}

local LUIGI_SCUTTLE_RUN_HOLD_ACTIONS = T{
    ACT_HOLD_JUMP,
}

---@param m MarioState
local function luigi_scuttle_run_update_vel(m)
    if m.actionTimer <= 20 then
        m.vel.y = 2 - (m.actionTimer * 0.8)
    end
    m.actionTimer = m.actionTimer + 1
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
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

-------------
-- Actions --
-------------

---@param m MarioState
local function act_luigi_twirling(m)
    if not m then return 0 end

    local startTwirlYaw = m.twirlYaw
    local yawVelTarget

    if (m.input & INPUT_Z_DOWN) ~= 0 then
        return set_mario_action(m, ACT_R96_LUIGI_TWIRLING_DOWN, 0)
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

    if is_anim_past_end(m) == 1 then
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

    m.peakHeight = m.pos.y
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

    if is_anim_past_end(m) == 1 then
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

    m.peakHeight = m.pos.y
    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.twirlYaw

    return false
end

---@param m MarioState
local function act_luigi_backflip(m)
    if m.actionTimer == 0 then
        m.vel.y = m.vel.y + 1.75
    end

    if m.marioObj.header.gfx.animInfo.animFrame > 17 then
        return set_mario_action(m, ACT_R96_LUIGI_TWIRLING, 0)
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, CHAR_SOUND_YAH_WAH_HOO)
    common_air_action_step(m, ACT_BACKFLIP_LAND, CHAR_ANIM_BACKFLIP, 0)
    if m.action == ACT_BACKFLIP_LAND then queue_rumble_data_mario(m, 5, 40) end
    play_flip_sounds(m, 2, 3, 17)

    return false
end

---@param m MarioState
local function act_luigi_scuttle_run(m)
    if (m.input & INPUT_A_DOWN) == 0 or m.vel.y < -25 then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    set_character_anim_with_accel(m, CHAR_ANIM_RUNNING, 0x100000)
    luigi_scuttle_run_update_vel(m)

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
    luigi_scuttle_run_update_vel(m)

    local landed = perform_air_step(m, AIR_STEP_LANDED | AIR_STEP_CHECK_LEDGE_GRAB)
    if landed == AIR_STEP_LANDED then set_mario_action(m, ACT_HOLD_JUMP_LAND, 0) end
    if landed == AIR_STEP_GRABBED_LEDGE then
        set_character_animation(m, CHAR_ANIM_IDLE_ON_LEDGE)
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
    end
end

-----------
-- Hooks --
-----------

---@param m MarioState
local function luigi_update(m)
    if (m.prevAction & ACT_FLAG_AIR == 0 and
        m.input & INPUT_A_DOWN ~= 0 and
        m.vel.y < 0) then
        if LUIGI_SCUTTLE_RUN_ACTIONS[m.action] then
            set_mario_action(m, ACT_R96_LUIGI_SCUTTLE_RUN, 0)
        elseif LUIGI_SCUTTLE_RUN_HOLD_ACTIONS[m.action] then
            set_mario_action(m, ACT_R96_LUIGI_SCUTTLE_RUN_HOLD, 0)
        end
    end

    if (LUIGI_JUMP_ACTIONS[m.action] and
        m.prevAction & ACT_FLAG_AIR == 0 and
        m.input & INPUT_A_PRESSED ~= 0) then
        m.vel.y = m.vel.y + 6.0  -- small height boost
    end

    if m.action == ACT_BACKFLIP then set_mario_action(m, ACT_R96_LUIGI_BACKFLIP, 0) end
    if m.action == ACT_TWIRLING then set_mario_action(m, ACT_R96_LUIGI_TWIRLING, 0) end
end

---@param m MarioState
local function luigi_before_phys_step(m)
    local floorClass = mario_get_floor_class(m)

    if (m.action == ACT_WALKING) then
        if (floorClass == SURFACE_CLASS_VERY_SLIPPERY or floorClass == SURFACE_CLASS_SLIPPERY) then
            if m.forwardVel >= 29 then
                m.forwardVel = 37
            end
        elseif m.forwardVel >= 29 then
            m.forwardVel = 34
        end
    end

    if (m.action == ACT_BRAKING or m.action == ACT_TURNING_AROUND) then
        if (floorClass == SURFACE_CLASS_NOT_SLIPPERY) then m.forwardVel = m.forwardVel + 5
        elseif (floorClass == SURFACE_CLASS_DEFAULT) then m.forwardVel = m.forwardVel + 3 end
        if (m.forwardVel < 0) then m.forwardVel = 0 end
    end
end

hook_event(HOOK_ON_MODS_LOADED, function ()
    charSelect.character_set_locked(CT_LUIGI, is_luigi_unlocked, true, "\\#0c0\\Luigi\\#\\")
    charSelect.character_hook_moveset(CT_LUIGI, HOOK_BEFORE_PHYS_STEP, luigi_before_phys_step)
    charSelect.character_hook_moveset(CT_LUIGI, HOOK_MARIO_UPDATE, luigi_update)
end)

hook_mario_action(ACT_R96_LUIGI_SCUTTLE_RUN,      act_luigi_scuttle_run)
hook_mario_action(ACT_R96_LUIGI_SCUTTLE_RUN_HOLD, act_luigi_scuttle_run_hold)
hook_mario_action(ACT_R96_LUIGI_BACKFLIP,         act_luigi_backflip)
hook_mario_action(ACT_R96_LUIGI_TWIRLING,         act_luigi_twirling)
hook_mario_action(ACT_R96_LUIGI_TWIRLING_DOWN,    act_luigi_twirling_down, INT_GROUND_POUND)
