local charSelect = require("/lib/char-select")
require("/constants")

-------------
-- Actions --
-------------

---@param m MarioState
local function act_bananaman_jump(m)
    if (m.marioObj.header.gfx.animInfo.animFrame == 0) then
        play_sound(SOUND_ACTION_SWIM_FAST, m.marioObj.header.gfx.cameraToObject)
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)
    update_air_with_turn(m)
    if m.actionState == 0 then
        m.actionState = m.actionState + 1
        m.vel.y = 45
    end
    common_air_action_step(m, ACT_DIVE_SLIDE, CHAR_ANIM_SWIM_PART1, 0)
    m.forwardVel = math.max(m.forwardVel -1, 0)
end

-----------
-- Hooks --
-----------

---@param m MarioState
local function bananaman_update(m)
    if (m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_TRIPLE_JUMP) and m.actionTimer > 1 and m.controller.buttonPressed & A_BUTTON ~= 0 then
        m.faceAngle.y = m.intendedYaw
        set_mario_action(m, ACT_R96_BANANAMAN_JUMP, 0)
        m.vel.y = 35
    end

    if m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_TRIPLE_JUMP then
        m.actionTimer = m.actionTimer + 1
    end
end

hook_event(HOOK_ON_MODS_LOADED, function ()
    charSelect.character_hook_moveset(CT_TOAD, HOOK_MARIO_UPDATE, bananaman_update)
end)

hook_mario_action(ACT_R96_BANANAMAN_JUMP, act_bananaman_jump)
