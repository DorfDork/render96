local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

local SCUTTLEBUG_COLORS = {
    {r = 0x40, g = 0x21, b = 0x3B},
    {r = 0x44, g = 0x35, b = 0x00},
    {r = 0x00, g = 0x00, b = 0x00},
}

---@param o Object
local function bhv_scuttlebug_render96_loop(o)
    r96lib.pulse_cycle(o, SCUTTLEBUG_COLORS, 50)
end

id_bhvRender96Scuttlebug = r96lib.hook_behavior(id_bhvScuttlebug, false, nil, bhv_scuttlebug_render96_loop)

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_function_scuttle_body(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local rot = (o.oTimer * 0x200) & 0xFFFF
    rotN.rotation.x = rot
    rotN.rotation.y = rot
    rotN.rotation.z = rot
end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_scuttle_body_color(node, matStackIndex)
    r96lib.gfx_color_patch(node, {
        prefix    = "scuttle",
        origDl    = "scuttlebug_scuttle_body_dl_mesh_layer_1",
        origMat   = "mat_scuttlebug_scuttlebug_body",
        primIndex = 7,
    })
end
