local r96lib = require("/lib/r96lib")
require("/constants")

local _clamp = math.clamp

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_whomp_render96_init(o)
    o.oThwompPrevAction = o.oAction or 0
    o.oThwompSquishTimer = 0
    o.oThwompSquishDur = 0
    o.oThwompBaseScale = o.header.gfx.scale.x
end

---@param o Object
local function bhv_whomp_render96_loop(o)
    obj_squish_on_action_enter(o, 5, 0.10, 0.10, -0.2)
    if obj_hit_by_wario_charge(o, 200) then
        cur_obj_play_sound_and_rumble_if_visible(SOUND_OBJ_THWOMP)
        o.oNumLootCoins = 5
        obj_spawn_loot_yellow_coins(o, 5, 20.0)
        create_sound_spawner(SOUND_OBJ_STOMPED)
        obj_kill_common(o)
    end
end

---@param o Object
local function bhv_whomp_king_render96_loop(o)
    obj_squish_on_action_enter(o, 5, 0.15, 0.15, -0.3)  -- bugfix: now correctly resets on re-entry

    o.oSwitchState1 = _clamp(3 - o.oHealth, 0, 2)
    o.oThwompPrevAction = o.oAction
end

id_bhvRender96SmallWhomp = r96lib.hook_behavior(id_bhvSmallWhomp, false, bhv_whomp_render96_init, bhv_whomp_render96_loop)
id_bhvRender96WhompKingBoss = r96lib.hook_behavior(id_bhvWhompKingBoss, false, bhv_whomp_render96_init, bhv_whomp_king_render96_loop)
