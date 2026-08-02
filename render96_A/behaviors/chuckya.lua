local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
function bhv_chuckya_heaveho_render96_loop(o)
    if obj_hit_by_wario_charge(o, 200) then
        obj_spawn_blue_coins(o, 1)
        create_sound_spawner(SOUND_OBJ_CHUCKYA_DEATH)
        obj_kill_common(o)
    end
end

id_bhvRender96Chuckya = r96lib.hook_behavior(id_bhvChuckya, false, nil, bhv_chuckya_heaveho_render96_loop)

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_function_chuckya_spin(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local rot = (o.oTimer * 0x2000) & 0xFFFF
    rotN.rotation.x = rot
end
