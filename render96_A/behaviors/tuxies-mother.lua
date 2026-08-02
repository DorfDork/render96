local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_tuxie_mother_render96_init(o)
    obj_set_home(o, o.oPosX, find_floor_height(o.oPosX, o.oPosY + 100, o.oPosZ), o.oPosZ)
end

---@param o Object
local function bhv_tuxie_mother_render96_loop(o)
    local smallPenguin = obj_get_nearest_object_with_behavior_id(o, id_bhvUnused20E0)

    if smallPenguin ~= nil then
        obj_set_home(smallPenguin, smallPenguin.oPosX, smallPenguin.oPosY, smallPenguin.oPosZ) -- prevent the penguin from warping back to the top of the mountain
        if obj_is_on_deadly_floor(smallPenguin) then
            o.oAction = 4
            o.oTimer = 0
            obj_mark_for_deletion(smallPenguin)
        end
    end

    -- >:(
    if o.oAction == 4 then
        local m = nearest_tangible_mario_state_to_object(o)
        if m ~= nil then
            o.oForwardVel = math.min(30 + o.oTimer / 9, 40) -- progressively accelerate

            local angleToMario = obj_angle_to_object(o, m.marioObj)
            cur_obj_rotate_yaw_toward(angleToMario, 0x1000)
            cur_obj_init_animation_with_accel_and_sound(0, 3)

            -- Mario is f*cking dead
            if dist_between_objects(o, m.marioObj) < 250 then
                local angleToObject = mario_obj_angle_to_object(m, o)
                local facingDYaw = angleToObject - m.faceAngle.y
                if -0x4000 <= facingDYaw and facingDYaw <= 0x4000 then
                    m.faceAngle.y = angleToObject
                    mario_set_forward_vel(m, -o.oForwardVel * 1.5)
                    hurt_and_set_mario_action(m, ACT_HARD_BACKWARD_AIR_KB, 8 | PVP_ATTACK_KNOCKBACK_ACTION_ARG, 64)
                else
                    m.faceAngle.y = angleToObject + 0x8000
                    mario_set_forward_vel(m, o.oForwardVel * 1.5)
                    hurt_and_set_mario_action(m, ACT_HARD_FORWARD_AIR_KB, 8 | PVP_ATTACK_KNOCKBACK_ACTION_ARG, 64)
                end
                m.vel.y = o.oForwardVel
                play_character_sound_if_no_flag(m, CHAR_SOUND_ATTACKED, MARIO_MARIO_SOUND_PLAYED)
                if m.playerIndex == 0 then
                    set_camera_shake_from_hit(SHAKE_LARGE_DAMAGE)
                end

                o.oForwardVel = 0
                o.oAction = 2
            end
        else
            o.oForwardVel = 0
            o.oTimer = 0
        end
    end

    -- Teleport to home if reaching deadly floor
    if obj_is_on_deadly_floor(o) then
        cur_obj_set_pos_to_home_and_stop()
        o.oAction = 2
    end

    o.oSwitchTimer1 = o.oSwitchTimer1 + 1
    local timer = o.oSwitchTimer1 % 50
    o.oSwitchState1 = 0

    if timer < 43 then
        o.oSwitchState1 = 0
    elseif timer < 45 then
        o.oSwitchState1 = 1
    elseif timer < 47 then
        o.oSwitchState1 = 2
    else
        o.oSwitchState1 = 1
    end
    -- Angry eyes if chasing Mario
    if o.oAction == 4 then
        o.oSwitchState1 = 3
    end
end

id_bhvRender96TuxiesMother = r96lib.hook_behavior(id_bhvTuxiesMother, false, bhv_tuxie_mother_render96_init, bhv_tuxie_mother_render96_loop)
