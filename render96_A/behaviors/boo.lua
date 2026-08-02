local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

local BOO_SCARED_STATES = { 0, 1, 2, 3, 4, 4, 4 }
local BOO_HUNT_STATES   = { 4, 4, 4, 3, 2, 1, 0 }

---@param o Object
local function bhv_boo_render96_init(o)
    o.oOpacity = 255
    o.oSwitchState2 = 0
    o.oSwitchTimer2 = 1
end

---@param o Object
local function bhv_boo_render96_loop(o)
    obj_squish_on_action_enter(o, 2, 0.15, 0.15, -0.3)

    if o.oOpacity < 255 and o.oSwitchTimer2 < 7 then
        o.oOpacity = 254 - (o.oSwitchTimer2 * 15)
        o.oSwitchState2 = BOO_SCARED_STATES[o.oSwitchTimer2]
        o.oSwitchTimer2 = o.oSwitchTimer2 + 1
    elseif o.oOpacity >= 150 and o.oSwitchTimer2 >= 7 and o.oSwitchTimer2 < 14 then
        o.oSwitchState2 = BOO_HUNT_STATES[o.oSwitchTimer2 - 6]
        o.oSwitchTimer2 = o.oSwitchTimer2 + 1
    elseif o.oOpacity == 255 and o.oSwitchTimer2 == 14 then
        o.oSwitchState2 = 0
        o.oSwitchTimer2 = 1
    elseif o.oOpacity == 40 and o.oSwitchTimer2 == 14 then
        o.oSwitchState2 = 4
        o.oSwitchTimer2 = 7
    elseif o.oOpacity == 40 and o.oSwitchTimer2 == 7 then
        o.oSwitchState2 = 4
    end
end

id_bhvRender96GhostHuntBoo = r96lib.hook_behavior(id_bhvGhostHuntBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96GhostHuntBigBoo = r96lib.hook_behavior(id_bhvGhostHuntBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96BooWithCage = r96lib.hook_behavior(id_bhvBooWithCage, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96BalconyBigBoo = r96lib.hook_behavior(id_bhvBalconyBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96MerryGoRoundBigBoo = r96lib.hook_behavior(id_bhvMerryGoRoundBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
