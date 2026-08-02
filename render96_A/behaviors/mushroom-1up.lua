local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_1up_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

---@param o Object
local function bhv_1up_render96_loop(o)
    o.oFaceAngleYaw = o.oMoveAngleYaw
end

id_bhvRender961Up = r96lib.hook_behavior(id_bhv1Up, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upWalking = r96lib.hook_behavior(id_bhv1upWalking, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upRunningAway = r96lib.hook_behavior(id_bhv1upRunningAway, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upSliding = r96lib.hook_behavior(id_bhv1upSliding, false, bhv_1up_render96_init, bhv_1up_render96_loop) -- MOVE MESH TO HITBOX
id_bhvRender961upJumpOnApproach = r96lib.hook_behavior(id_bhv1upJumpOnApproach, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender96Hidden1up = r96lib.hook_behavior(id_bhvHidden1up, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender96Hidden1upInPole = r96lib.hook_behavior(id_bhvHidden1upInPole, false, bhv_1up_render96_init, bhv_1up_render96_loop)
