local r96lib = require("/lib/r96lib")
local UvScroll = require("/lib/uv-scroll")
require("constants")

local _floor  = math.floor
local _abs    = math.abs
local _max    = math.max
local _min    = math.min
local _sqrt   = math.sqrt
local _random = math.random
local _sin    = math.sin
local _cos    = math.cos
local _lerp   = math.lerp
local _atan2  = math.atan2
local _pi     = math.pi
local m = gMarioStates[0]

---@param id BehaviorId|number
---@param override boolean
---@param init function?
---@param loop function?
local function hook_render96_behavior(id, override, init, loop, list, name)
    if id ~= nil then
        list = list or get_object_list_from_behavior(get_behavior_from_id(id))
        name = name or (get_behavior_name_from_id(id):gsub("bhv", "", 1))
    else
        list = list or OBJ_LIST_LEVEL
        name = name or "Unnamed"
    end
    return hook_behavior(id, list, override, init, loop, "bhvRender96" .. name)
end

function geo_switch_state_1(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end
function geo_switch_state_2(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end

local function uv_scroll_right_slow(input_vtx, original_uv, current_uv)
    local speed = 0.5
    current_uv[1] = current_uv[1] + speed
end

-- Scroll the uvs in a circular motion
local function uv_scroll_spin(input_vtx, original_uv, current_uv)
    local speed    = 0.5
    local center_u = 500 -- center of rotation in UV space
    local center_v = 500
    local offset_u = 0   -- post-rotation translation (right/left)
    local offset_v = 0   -- post-rotation translation (up/down)

    -- offset from chosen center
    local rel_u = original_uv[1] - center_u
    local rel_v = original_uv[2] - center_v

    -- equation for circular motion
    local t          = get_global_timer() * speed
    local orig_theta = _atan2(rel_v, rel_u)
    local orig_dist  = _sqrt(rel_u * rel_u + rel_v * rel_v)

    current_uv[1] = center_u + orig_dist * _cos(orig_theta + t) + offset_u
    current_uv[2] = center_v + orig_dist * _sin(orig_theta + t) + offset_v
end

-- Scroll the uvs in a circular motion
local function uv_scroll_spin_slow(input_vtx, original_uv, current_uv)
    -- adjustable constants
    local speed = 0.01

    -- equation for circular motion
    local t = get_global_timer() * speed
    local orig_theta = _atan2(original_uv[2], original_uv[1])
    local orig_dist = _sqrt((original_uv[1])*(original_uv[1]) + (original_uv[2])*(original_uv[2]))
    current_uv[1] = orig_dist * _cos(orig_theta + t)
    current_uv[2] = orig_dist * _sin(orig_theta + t)
end

UvScroll.hook_scrolling_function('bowser_2_dl_bowser_2_environment_mesh_layer_1_tri_3', uv_scroll_right_slow)

---@param o Object
local function bhv_tilting_bowser_lava_platform_init(o)
        o.header.gfx.skipInViewCheck = true
    o.collisionData = smlua_collision_util_get("bitfs_tilting_arena_collision")
end

id_bhvRender96TiltingBowserLavaPlatform = hook_render96_behavior(id_bhvTiltingBowserLavaPlatform, false, bhv_tilting_bowser_lava_platform_init, nil)
