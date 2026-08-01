require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_star_door_render96_init(o)
    local frame = spawn_non_sync_object(id_bhvRender96StarDoorFrame, E_MODEL_R96_STAR_DOOR_FRAME, o.oPosX, o.oPosY, o.oPosZ, nil)
    obj_set_angle(frame, o.oFaceAnglePitch, o.oFaceAngleYaw, o.oFaceAngleRoll)
end

id_bhvRender96StarDoor = hook_render96_behavior(id_bhvStarDoor, false, bhv_star_door_render96_init, nil)

---@param o Object
local function bhv_star_door_frame_render96_init(o)
    o.activeFlags = o.activeFlags | ACTIVE_FLAG_ACTIVE
end

id_bhvRender96StarDoorFrame = hook_render96_behavior(nil, true, bhv_star_door_frame_render96_init, nil, OBJ_LIST_SURFACE)

-----------
-- Hooks --
-----------

local function update_outside_doors_model()
    if gNetworkPlayers[0].currLevelNum ~= LEVEL_CASTLE then
        local door = obj_get_first_with_behavior_id(id_bhvDoor)
        while door ~= nil and door.oSwitchState1 ~= 1 and obj_has_model_extended(door, E_MODEL_HMC_WOODEN_DOOR) ~= 0 do
            door.oSwitchState1 = 1
            door = obj_get_next_with_same_behavior_id(door)
        end
    end
end

hook_event(HOOK_ON_WARP, update_outside_doors_model)
