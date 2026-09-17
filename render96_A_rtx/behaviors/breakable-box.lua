local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_breakable_box_render96_loop(o)
    local dist = obj_has_behavior_id(o, id_bhvBreakableBox) == 1 and 240 or 120
    if obj_hit_by_wario_charge(o, dist) then
        obj_explode_and_spawn_coins(46, 1)
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX)
    end
end

---@param o Object
local function bhv_breakable_box_small_render96_loop(o)
    if obj_hit_by_wario_charge(o, 120) then
        o.oInteractStatus = (ATTACK_KICK_OR_TRIP | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED | INT_STATUS_STOP_RIDING) -- break flags
    end
end

id_bhvRender96BreakableBox = r96lib.hook_behavior(id_bhvBreakableBox, false, nil, bhv_breakable_box_render96_loop)
id_bhvRender96BreakableBoxSmall = r96lib.hook_behavior(id_bhvBreakableBoxSmall, false, nil, bhv_breakable_box_small_render96_loop)
id_bhvRender96JumpingBox = r96lib.hook_behavior(id_bhvJumpingBox, false, nil, bhv_breakable_box_render96_loop)
