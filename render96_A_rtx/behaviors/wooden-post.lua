local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_wooden_post_render96_loop(o)
    if obj_ground_pounded_by_wario(o) then
        o.oWoodenPostSpeedY = -210
        network_send_object(o, true)
    end
end

id_bhvRender96WoodenPost = r96lib.hook_behavior(id_bhvWoodenPost, false, nil, bhv_wooden_post_render96_loop)
