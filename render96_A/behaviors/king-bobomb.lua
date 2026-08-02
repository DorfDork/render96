local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

local COLORS_KINGBOBOMB = {
    {r =   4, g = 4, b = 4},
    {r = 150, g = 0, b = 0},
}

---@param o Object
local function bhv_king_bobomb_render96_init(o)
    o.oColorR = 4
    o.oColorG = 4
    o.oColorB = 4
end

---@param o Object
local function bhv_king_bobomb_render96_loop(o)
    if o.oHealth == 3 then
        o.oColorR = 4
        o.oColorG = 4
        o.oColorB = 4
    end
    if o.oHealth == 2 then
        r96lib.pulse_rapid(o, COLORS_KINGBOBOMB, o.oTimer, 0.1)
    end
    if o.oHealth == 1 then
        r96lib.pulse_rapid(o, COLORS_KINGBOBOMB, o.oTimer, 0.3)
    end
end

id_bhvRender96KingBobomb = r96lib.hook_behavior(id_bhvKingBobomb, false, bhv_king_bobomb_render96_init, bhv_king_bobomb_render96_loop)

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_function_kingbob_pulse(node, matStackIndex)
    r96lib.gfx_color_patch_by_name(node, {
        origDl = "king_bobomb_004_offset_mesh_layer_1"
    })
end
