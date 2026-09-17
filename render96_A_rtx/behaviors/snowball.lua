local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_snowball_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

id_bhvRender96MrBlizzardSnowball = r96lib.hook_behavior(id_bhvMrBlizzardSnowball, false, bhv_snowball_render96_init, nil)
