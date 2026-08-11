local r96lib = require("/lib/r96lib")
require("/constants")

local _clamp = math.clamp

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function check_wiggler_boss_fight_started(o)
    for i = 0, MAX_PLAYERS - 1 do
        local m = gMarioStates[i]
        if m.pos.y >= o.oHomeY and m.visibleToObjects and is_player_active(m) == 1 then
            return true
        end
    end
    return false
end

---@param o Object
local function bhv_wiggler_head_render96_loop(o)

    -- Use this unused field to indicate that someone is fighting Wiggler
    if check_wiggler_boss_fight_started(o) then
        o.oWigglerUnused = 1
    end

    if o.oWigglerUnused == 1 then
        o.oSwitchState1 = _clamp(5 - o.oHealth + (o.oAction == WIGGLER_ACT_JUMPED_ON and 1 or 0), 1, 4)
    else
        o.oSwitchState1 = 0
    end
end

id_bhvRender96WigglerHead = r96lib.hook_behavior(id_bhvWigglerHead, false, nil, bhv_wiggler_head_render96_loop)

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_function_wiggler_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local id = o._pointer
    local rot = cast_graph_node(node.next).rotation
    rot.x = (((id >> 11) % 4) + 1) * 0x1500
    rot.y = (((id >> 11) % 4) + 1) * 0x1500
    rot.z = (((id >> 11) % 4) + 1) * 0x1500
end

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_wiggler_color(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local wigglerHead = obj_has_behavior_id(o, id_bhvWigglerHead) == 1 and o or o.parentObj
    if wigglerHead == nil then -- fallback (should not happen)
        wigglerHead = obj_get_nearest_object_with_behavior_id(o, id_bhvWigglerHead)
    end

    -- the head state gives the body color
    local switch = cast_graph_node(node)
    if wigglerHead.oSwitchState1 == 2 or wigglerHead.oSwitchState1 == 3 then -- red
        switch.selectedCase = 1
    else -- yellow
        switch.selectedCase = 0
    end
end

---------------
-- UV scroll --
---------------

--UvScroll.hook_scrolling_function("wiggler_head_switch_opt1_000_displaylist5_mesh_layer_1_tri_3", uv_scroll_spin)
