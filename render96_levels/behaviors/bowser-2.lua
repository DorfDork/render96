local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_tilting_bowser_lava_platform_init(o)
    o.header.gfx.skipInViewCheck = true
    o.collisionData = smlua_collision_util_get("bitfs_tilting_arena_collision")
end

id_bhvRender96TiltingBowserLavaPlatform = r96lib.hook_behavior(id_bhvTiltingBowserLavaPlatform, false, bhv_tilting_bowser_lava_platform_init, nil)

----------------
-- Tex scroll --
----------------

local function scroll_bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3()
    local count = 4
    local deltaX = 33
    local vertices = vtx_get_from_name("bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3")
    for i = 0, count - 1 do
        local v = vtx_get_vertex(vertices, i)
        v.tu = v.tu + deltaX
    end
end

local function scroll_bowser_2()
    scroll_bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3()
end

hook_event(HOOK_UPDATE, scroll_bowser_2)

---------------
-- UV scroll --
---------------

--UvScroll.hook_scrolling_function("bowser_2_dl_bowser_2_environment_mesh_layer_1_tri_3", uv_scroll_right_slow)
