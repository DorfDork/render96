require("/constants")

-------------------
-- Geo functions --
-------------------

---@param o Object
local function wing_rotate(o) return (coss((o.oTimer & 0xF) << 12) + 1.0) * 4096.0 end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_wing1_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    rotN.rotation.x = wing_rotate(o)
end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_wing2_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    rotN.rotation.x = -wing_rotate(o)
end
