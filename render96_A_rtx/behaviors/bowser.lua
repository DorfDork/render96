local r96lib = require("/lib/r96lib")
require("/constants")

local _floor = math.floor
local _max   = math.max
local _min   = math.min
local _sin   = math.sin

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_bowser_render96_init(o)
    cur_obj_scale(1.1)
end

---@param o Object
local function bhv_bowser_render96_loop(o)
    obj_set_model_extended(o, E_MODEL_BOWSER)
    o.oSwitchTimer1 = o.oSwitchTimer1 + 1
    o.header.gfx.animInfo.animID = o.oSoundStateID -- Fix animation interpolation bug
end

id_bhvRender96Bowser = r96lib.hook_behavior(id_bhvBowser, false, nil, bhv_bowser_render96_loop)

-------------------
-- Geo functions --
-------------------

local BOWSER_COLOR_MESHES = {
    "bowser_spine_mesh_layer_1",
    "bowser_head_mesh_layer_1",
    "bowser_left_foot_mesh_layer_1",
    "bowser_jaw_mesh_layer_1",
    "bowser_right_eye_mesh_layer_1",
    "bowser_shell_mesh_layer_1",
}

--[[local sBowserState = {
    DEFAULT                     = { action = 0,  subAction = nil },
    THROWN_BOUNCING             = { action = 1,  subAction = 0   },
    THROWN_RECOVERY             = { action = 1,  subAction = 1   },
    JUMP_STAGE_SPINNING         = { action = 2,  subAction = 0   },
    JUMP_STAGE_LAUNCH           = { action = 2,  subAction = 1   },
    JUMP_STAGE_FLYING           = { action = 2,  subAction = 2   },
    JUMP_STAGE_LANDING          = { action = 2,  subAction = 3   },
    DANCE                       = { action = 3,  subAction = nil },
    DEAD_FLYBACK                = { action = 4,  subAction = 0   },
    DEAD_BOUNCING               = { action = 4,  subAction = 1   },
    DEAD_WAITING_MARIO          = { action = 4,  subAction = 2   },
    DEAD_DIALOG                 = { action = 4,  subAction = 3   },
    DEAD_DONE                   = { action = 4,  subAction = 4   },
    DEAD_BITS_DIALOG            = { action = 4,  subAction = 10  },
    DEAD_BITS_DONE              = { action = 4,  subAction = 11  },
    TEXT_WAIT                   = { action = 5,  subAction = nil },
    INTRO_LOOK_UP               = { action = 6,  subAction = 0   },
    INTRO_SLOW_GAIT             = { action = 6,  subAction = 1   },
    INTRO_LOOK_DOWN             = { action = 6,  subAction = 2   },
    CHARGE_WINDUP               = { action = 7,  subAction = 0   },
    CHARGE_RUNNING              = { action = 7,  subAction = 1   },
    CHARGE_BRAKING              = { action = 7,  subAction = 3   },
    CHARGE_STOPPED              = { action = 7,  subAction = 2   },
    SPIT_FIRE_SKY               = { action = 8,  subAction = nil },
    SPIT_FIRE_FLOOR             = { action = 9,  subAction = nil },
    HIT_EDGE_STUNNED            = { action = 10, subAction = 0   },
    HIT_EDGE_RECOVERY           = { action = 10, subAction = 1   },
    TURN_FROM_EDGE              = { action = 11, subAction = nil },
    HIT_MINE_START              = { action = 12, subAction = 0   },
    HIT_MINE_BOUNCING           = { action = 12, subAction = 1   },
    HIT_MINE_GETUP              = { action = 12, subAction = 2   },
    JUMP_PREJUMP                = { action = 13, subAction = 0   },
    JUMP_AIRBORNE               = { action = 13, subAction = 1   },
    JUMP_LANDING                = { action = 13, subAction = 2   },
    WALK_START                  = { action = 14, subAction = 0   },
    WALK_APPROACHING            = { action = 14, subAction = 1   },
    WALK_STOPPING               = { action = 14, subAction = 2   },
    BREATH_FIRE                 = { action = 15, subAction = nil },
    TELEPORT_FADEOUT            = { action = 16, subAction = 0   },
    TELEPORT_FLYING             = { action = 16, subAction = 1   },
    TELEPORT_FADEIN             = { action = 16, subAction = 2   },
    JUMP_MARIO_PREJUMP          = { action = 17, subAction = 0   },
    JUMP_MARIO_AIRBORNE         = { action = 17, subAction = 1   },
    JUMP_MARIO_LANDING          = { action = 17, subAction = 2   },
    UNUSED_SLOW_WALK            = { action = 18, subAction = nil },
    RIDE_TILTING_PLATFORM       = { action = 19, subAction = nil },
    NOTHING                     = { action = 20, subAction = nil },
}

local function bowser_state(o, ...)
    for _, state in ipairs({...}) do
        if o.oAction ~= state.action then return false end
        if state.subAction ~= nil and o.oSubAction ~= state.subAction then return false end
        return true
    end
    return false
end]]

---@param node GraphNode
local function bowser_eyelid_common(node)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    if o.oAction == 4 then
        rotN.rotation.x = 0
    else
        local frame = o.oSwitchTimer1 % 90
        if frame < 14 then
            local t = _floor(frame * 0x10000 / 14) & 0xFFFF
            rotN.rotation.x = -(1.0 - coss(t)) * 0x4000
        else
            rotN.rotation.x = 0
        end
    end
end

---@param node GraphNode
---@param yawMin integer
---@param yawMax integer
---@param pitchMin integer
---@param pitchMax integer
local function bowser_eye_common(node, yawMin, yawMax, pitchMin, pitchMax)
    local o = geo_get_current_object()
    if o == nil then return end
    local player = nearest_player_to_object(o)
    if player == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local yaw  = obj_angle_to_object(o, player) - o.oFaceAngleYaw
    if yaw >  32767 then yaw = yaw - 65536 end
    if yaw < -32768 then yaw = yaw + 65536 end
    local pitch = obj_pitch_to_object(o, player)
    if pitch >  32767 then pitch = pitch - 65536 end
    if pitch < -32768 then pitch = pitch + 65536 end
    yaw   = _max(-yawMax,   _min(yawMin,   yaw))
    pitch = _max(-pitchMax, _min(pitchMin, pitch))
    rotN.rotation.x = (-pitch) & 0xFFFF
    rotN.rotation.y = 0
    rotN.rotation.z = yaw & 0xFFFF
end

---@param node GraphNode
local function bowser_hand_switch(node)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = (o.oAction == 15) and 1 or 0
end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bowser_color(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end

    local levelNum = gNetworkPlayers[0].currLevelNum
    if levelNum == LEVEL_BOWSER_3 then
        local t = o.oTimer
        o.oColorR = _floor((_sin(t * 0.05)         * 0.5 + 0.5) * 100)
        o.oColorG = _floor((_sin(t * 0.05 + 2.094) * 0.5 + 0.5) * 100)
        o.oColorB = _floor((_sin(t * 0.05 + 4.189) * 0.5 + 0.5) * 100)
    else
        o.oColorR = 0
        o.oColorG = 0
        o.oColorB = 0
    end

    for i = 1, #BOWSER_COLOR_MESHES do
        r96lib.gfx_color_patch_by_name(node, {
            origDl = BOWSER_COLOR_MESHES[i]
        })
    end
end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bowser_hair(node, matStackIndex) end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bowser_left_eye(node, matStackIndex) bowser_eye_common(node, 0x2000, 0x0500, 0x0500, 0x1500) end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bowser_left_eyelid(node, matStackIndex) bowser_eyelid_common(node) end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bowser_left_hand(node, matStackIndex)  bowser_hand_switch(node) end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bowser_right_eye(node, matStackIndex) bowser_eye_common(node, 0x0500, 0x2000, 0x0500, 0x1500) end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bowser_right_eyelid(node, matStackIndex) bowser_eyelid_common(node) end

---@param node GraphNode
---@param matStackIndex integer
function geo_function_bowser_right_hand(node, matStackIndex) bowser_hand_switch(node) end
