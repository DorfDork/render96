local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_thwomp_render96_init(o)
    o.oSwitchState2 = 0
    o.oThwompShakeTicks = 18
    o.oThwompPosMag = 25.0
    o.oThwompAngleMag = 0x120

    o.oThwompPrevAction = o.oAction or 0
    o.oThwompSquishTimer = 0
    o.oThwompSquishDur = 0
    if o.oBehParams == 1 then
        obj_scale(o, 1.75)
    end
    o.oThwompBaseScale = o.header.gfx.scale.x
    o.collisionData = smlua_collision_util_get("thwomp_collision")
    o.oNumLootCoins = 5
    obj_set_home(o, o.oPosX, o.oPosY, o.oPosZ)

    network_init_object(o, false, {'oHealth'})
end

---@param o Object
local function bhv_thwomp_render96_shake(o)
    -- 0 = rising, 1 = waiting (pre-fall), 2 = falling, 3 = landed, 4 = cooldown
    if o.oAction ~= 1 then return end

    local remaining = o.oThwompRandomTimer - o.oTimer
    if remaining > (o.oThwompShakeTicks + 0.5) or remaining < 0 then
        o.oThwompShakeTimer = 0
        return
    end

    r96lib.shake_apply(o, o.oThwompShakeTimer, o.oThwompShakeTicks, o.oThwompPosMag, o.oThwompPosMag, o.oThwompPosMag)

    o.oThwompShakeTimer = o.oThwompShakeTimer + 1
end

---@param o Object
local function bhv_thwomp_render96_loop(o)
    bhv_thwomp_render96_shake(o)
    if o.oAction == 0 then
        o.oSwitchState2 = 0
    elseif o.oAction == 1 then
        local remaining = o.oThwompRandomTimer - o.oTimer
        o.oSwitchState2 = (remaining > (o.oThwompShakeTicks + 0.5) or remaining < 0) and 0 or 1
    elseif o.oAction == 2 then
        o.oSwitchState2 = 2
    elseif o.oAction == 3 then
        o.oSwitchState2 = 1
        cur_obj_set_pos_to_home()
    end

    obj_squish_on_action_enter(o, 3, 0.15, -0.20, 0.15)

    if o.oHealth == 0 then
        cur_obj_play_sound_and_rumble_if_visible(SOUND_OBJ_THWOMP)
        create_sound_spawner(SOUND_OBJ_STOMPED)
        cur_obj_spawn_loot_blue_coin()
        obj_kill_common(o)
    elseif obj_hit_by_wario_charge(o, 350) or obj_ground_pounded_by_wario(o) then
        o.oHealth = 0
        network_send_object(o, true)
    end
end

id_bhvRender96Thwomp = hook_render96_behavior(id_bhvThwomp, false, bhv_thwomp_render96_init, bhv_thwomp_render96_loop)
id_bhvRender96Thwomp2 = hook_render96_behavior(id_bhvThwomp2, false, bhv_thwomp_render96_init, bhv_thwomp_render96_loop)
