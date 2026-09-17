local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

local BOBOMB_COLORS = {
    {r =   4, g = 4, b = 4},
    {r = 200, g = 0, b = 0},
}

---@param o Object
local function bhv_bobomb_render96_init(o)
    o.oColorR = 4
    o.oColorG = 4
    o.oColorB = 4
end

---@param o Object
local function bhv_bobomb_render96_loop(o)
    if o.oBobombFuseTimer == 0 then
        o.oSwitchState1 = 0
    else
        o.oSwitchState1 = 1
        r96lib.pulse_ramp(o, BOBOMB_COLORS, o.oBobombFuseTimer, 150)
    end
    if obj_hit_by_wario_charge(o, 200) then
        set_camera_shake_from_point(SHAKE_POS_MEDIUM, o.oPosX, o.oPosY, o.oPosZ)
        o.oBobombFuseTimer = 152
    end
end

id_bhvRender96Bobomb = r96lib.hook_behavior(id_bhvBobomb, false, bhv_bobomb_render96_init, bhv_bobomb_render96_loop)

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bobomb_angry(node, matStackIndex)
    r96lib.gfx_color_patch(node, {
        prefix    = "bobomb_angry",
        origDl    = "black_bobomb_body_mesh_layer_1_mat_override_bobomb_blue2_0",
        origMat   = "mat_black_bobomb_bobomb_blue2",
        primIndex = 8,
    })
end
