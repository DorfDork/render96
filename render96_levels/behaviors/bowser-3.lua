local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_falling_bowser_platform_init(o)
    o.header.gfx.skipInViewCheck = true
end

id_bhvRender96FallingBowserPlatform = r96lib.hook_behavior(id_bhvFallingBowserPlatform, false, bhv_falling_bowser_platform_init, nil)
