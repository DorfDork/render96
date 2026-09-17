local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_unagi_render96_init(o)
    o.header.gfx.skipInViewCheck = true
end

id_bhvRender96Unagi = r96lib.hook_behavior(id_bhvUnagi, false, bhv_unagi_render96_init, nil)
