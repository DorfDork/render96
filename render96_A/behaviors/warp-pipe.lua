local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_warp_pipe_render96_init(o)
    o.oFlags = OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_WARP
    o.oDrawingDistance = 16000
    o.oIntangibleTimer = 0
    o.hitboxRadius = 70
    o.hitboxHeight = 50
    o.oInteractStatus = 0
    o.collisionData = smlua_collision_util_get("warp_pipe_seg3_collision_03009AC8")
end

---@param o Object
local function bhv_warp_pipe_locked_render96_init(o)
    o.oFlags = OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_WARP
    o.oDrawingDistance = 16000
    o.oIntangibleTimer = 0
    o.hitboxRadius = 70
    o.hitboxHeight = 50
    o.oInteractStatus = 0
    o.collisionData = smlua_collision_util_get("pipe_collision")
end

---@param o Object
local function bhv_warp_pipe_render96_red_loop(o)
    load_object_collision_model()
    bhv_warp_loop()
    o.oSwitchState1 = 1
    r96lib.audio_fade(o, AUDIO_R96_BOO_PIPE_RED, 650, 1800, true)
end

id_bhvRender96WarpPipeRed = hook_render96_behavior(nil, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_red_loop, OBJ_LIST_SURFACE, "WarpPipeRed")

---@param o Object
local function bhv_warp_pipe_render96_green_loop(o)
    load_object_collision_model()
    bhv_warp_loop()
    o.oSwitchState1 = 2
    r96lib.audio_fade(o, AUDIO_R96_BOO_PIPE_GREEN, 650, 1800, true)
end

id_bhvRender96WarpPipeGreenUnlock = hook_render96_behavior(nil, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_green_loop, OBJ_LIST_SURFACE, "WarpPipeGreenUnlock")
id_bhvRender96WarpPipeGreenLock = hook_render96_behavior(nil, false, bhv_warp_pipe_locked_render96_init, bhv_warp_pipe_render96_green_loop, OBJ_LIST_SURFACE, "WarpPipeGreenLock")

---@param o Object
local function bhv_warp_pipe_render96_yellow_loop(o)
    load_object_collision_model()
    bhv_warp_loop()
    o.oSwitchState1 = 3
    r96lib.audio_fade(o, AUDIO_R96_BOO_PIPE_YELLOW, 650, 1800, true)
end

id_bhvRender96WarpPipeYellowUnlock = hook_render96_behavior(nil, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_yellow_loop, OBJ_LIST_SURFACE, "WarpPipeYellowUnlock")
id_bhvRender96WarpPipeYellowLock = hook_render96_behavior(nil, false, bhv_warp_pipe_locked_render96_init, bhv_warp_pipe_render96_yellow_loop, OBJ_LIST_SURFACE, "WarpPipeYellowLock")
