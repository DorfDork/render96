local r96lib = require("/lib/r96lib")
require("/constants")

local _floor  = math.floor
local _abs    = math.abs
local _max    = math.max
local _min    = math.min
local _sqrt   = math.sqrt
local _random = math.random
local _sin    = math.sin
local _cos    = math.cos
local _lerp   = math.lerp
local _atan   = math.atan
local _pi     = math.pi

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_state_1(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = o.oSwitchState1
end

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_state_2(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = o.oSwitchState2
end

---------------
-- UV scroll --
---------------

-- function uv_scroll_right_slow(input_vtx, original_uv, current_uv)
--     local speed = 0.5
--     current_uv[1] = current_uv[1] + speed
-- end

-- -- Scroll the uvs in a circular motion
-- function uv_scroll_spin(input_vtx, original_uv, current_uv)
--     local speed    = 0.5
--     local center_u = 500 -- center of rotation in UV space
--     local center_v = 500
--     local offset_u = 0   -- post-rotation translation (right/left)
--     local offset_v = 0   -- post-rotation translation (up/down)

--     -- offset from chosen center
--     local rel_u = original_uv[1] - center_u
--     local rel_v = original_uv[2] - center_v

--     -- equation for circular motion
--     local t          = get_global_timer() * speed
--     local orig_theta = _atan(rel_v, rel_u)
--     local orig_dist  = _sqrt(rel_u * rel_u + rel_v * rel_v)

--     current_uv[1] = center_u + orig_dist * _cos(orig_theta + t) + offset_u
--     current_uv[2] = center_v + orig_dist * _sin(orig_theta + t) + offset_v
-- end

-- -- Scroll the uvs in a circular motion
-- function uv_scroll_spin_slow(input_vtx, original_uv, current_uv)
--     -- adjustable constants
--     local speed = 0.01

--     -- equation for circular motion
--     local t = get_global_timer() * speed
--     local orig_theta = _atan(original_uv[2], original_uv[1])
--     local orig_dist = _sqrt((original_uv[1])*(original_uv[1]) + (original_uv[2])*(original_uv[2]))
--     current_uv[1] = orig_dist * _cos(orig_theta + t)
--     current_uv[2] = orig_dist * _sin(orig_theta + t)
-- end

---------------
-- Behaviors --
---------------

require("/behaviors/bowser-2")
require("/behaviors/bowser-3")
