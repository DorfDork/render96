local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_particle_render96_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
end

---@param o Object
local function bhv_particle_render96_loop(o)
    if o.oTimer > o.oAction then
        obj_mark_for_deletion(o)
        return
    end

    cur_obj_rotate_face_angle_using_vel()
    cur_obj_move_using_fvel_and_gravity()
end

id_bhvRender96Particle = r96lib.hook_behavior(nil, true, bhv_particle_render96_init, bhv_particle_render96_loop, OBJ_LIST_UNIMPORTANT)
