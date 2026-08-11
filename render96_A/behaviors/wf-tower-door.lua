local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_tower_door_render96_loop(o)
    if obj_hit_by_wario_charge(o, 200) then
        obj_explode_and_spawn_coins(80.0, 0)
        create_sound_spawner(SOUND_GENERAL_WALL_EXPLOSION)
    end
end

id_bhvRender96TowerDoor = r96lib.hook_behavior(id_bhvTowerDoor, false, nil, bhv_tower_door_render96_loop)
