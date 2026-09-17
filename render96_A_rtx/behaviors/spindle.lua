require("/constants")

local _abs = math.abs

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_spindle(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local switchCase
    if (_abs(o.oMoveAnglePitch & 0x7fff) < 8000 and o.oAngleVelPitch ~= 0) then
        switchCase = 0
    else
        switchCase = 1
    end
    cast_graph_node(node).selectedCase = switchCase
end
