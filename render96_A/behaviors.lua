local o2oint = require("lib/o2oint")
local r96lib = require("/lib/r96lib")
--local UvScroll = require("/lib/uv-scroll")
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

local sThrownInteractions = o2oint.Interactions({
    objectLists = {
        OBJ_LIST_GENACTOR, -- Common enemies
        OBJ_LIST_PUSHABLE, -- Goombas, Koopas, Lakitus
        OBJ_LIST_DESTRUCTIVE, -- Bob-ombs, breakable boxes
        OBJ_LIST_SURFACE, -- Boxes
    },
    interactions = {

        -- Default behavior for most of the enemies -> attack enemy
        {
            targets = {
                id_bhvBobomb,
                obj_is_attackable,
                obj_is_exclamation_box,
            },
            interact = function (interactor, interactee, context)
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_PUNCH | INT_STATUS_WAS_ATTACKED | INT_STATUS_INTERACTED | INT_STATUS_TOUCHED_BOB_OMB
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
            end,
            ignoreIntangible = false
        },

        -- Behavior for breakable boxes -> break the box
        {
            targets = {
                obj_is_breakable_object
            },
            interact = function (interactor, interactee, context)
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_KICK_OR_TRIP | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED | INT_STATUS_STOP_RIDING -- "broken" status, specific to breakable boxes
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
            end,
            ignoreIntangible = false
        },

        -- Behavior for bullies -> repel the bully
        {
            targets = {
                obj_is_bully,
            },
            interact = function (interactor, interactee, context)
                interactee.oMoveAngleYaw = obj_angle_to_object(interactor, interactee)
                interactee.oForwardVel = 3392.0 / interactee.hitboxRadius
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_PUNCH | INT_STATUS_WAS_ATTACKED | INT_STATUS_INTERACTED
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
            end,
            ignoreIntangible = false
        }
    }
})

define_custom_obj_fields({
    oSwitchState1          = 'f32',
    oSwitchTimer1          = 's32',
    oSwitchState2          = 'f32',
    oSwitchTimer2          = 's32',
    oMrIBlinkIndex         = 's32',
    oMrITracking           = 'f32',
    oMrILastAngle          = 'f32',
    oMrIFireTimer          = 'f32',
    oMrIDizzyTimer         = 'f32',
    oMrIDizzyDuration      = 'f32',
    oMrIDetectRadius       = 'f32',
    oThwompShakeTicks      = 'f32',
    oThwompPosMag          = 'f32',
    oThwompAngleMag        = 'f32',
    oThwompPrevAction      = 'f32',
    oThwompSquishTimer     = 'f32',
    oThwompSquishDur       = 'f32',
    oThwompBaseScale       = 'f32',
    oWarioHeadBool         = 'f32',
    oCelebrationStar       = 'f32',
    oYoshiIdleTimer        = "f32",
    oYoshiCustomBlinkTimer = "s32",
    oWallX                 = "f32",
    oWallY                 = "f32",
    oWallZ                 = "f32",
    oTongueU               = "f32",
    oTongueTimer           = "f32",
    oTongueTarget          = "f32",
    oTongueLockX           = "f32",
    oTongueLockY           = "f32",
    oTongueLockZ           = "f32",
})

local R96_EYES_OPEN = 0
local R96_EYES_HALF_CLOSED = 1
local R96_EYES_CLOSED = 2
local R96_EYES_HALF_OPEN = 3
local R96_EYES_ANGRY = 4
local R96_EYES_HAPPY = 5
local R96_EYES_EXHAUSTED = 6
local R96_EYES_DEAD = 7
local R96_EYES_HURT = 8

local R96_FACE_DEFAULT = 0
local R96_FACE_HAPPY = 3
local R96_FACE_ANGRY = 4
local R96_FACE_OPEN = 5

local blinkFrame = 1
local blinkTimer = 0

local sleepFrame = 1
local sleepTimer = 1

local longJumpTimer = 0
local sMarioBlinkAnimation = { 0, 1, 2, 1, 0, 1, 2, 1, 0}

-- blink twice then have half-shut eyes (see end_peach_cutscene_kiss_from_peach)
local sMarioBlinkEnding = {
    [90]  = R96_EYES_HALF_CLOSED,
    [92]  = R96_EYES_CLOSED,
    [94]  = R96_EYES_HALF_CLOSED,
    [96]  = R96_EYES_OPEN,
    [98]  = R96_EYES_HALF_CLOSED,
    [100] = R96_EYES_CLOSED,
    [102] = R96_EYES_HALF_CLOSED,
    [104] = R96_EYES_OPEN,
    [106] = R96_EYES_HALF_CLOSED,
    [108] = R96_EYES_CLOSED,
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

local function bowser_eye_common(node, yawMin, yawMax, pitchMin, pitchMax)
    local o = geo_get_current_object()
    if o == nil then return end
    local player = nearest_player_to_object(o)
    if player == nil then return end
    local rotN  = cast_graph_node(node.next) ---@type GraphNodeRotation
    local yaw   = obj_angle_to_object(o, player) - o.oFaceAngleYaw
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

local function bowser_hand_switch(node)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = (o.oAction == 15) and 1 or 0
end

local function wing_rotate(o) return (coss((o.oTimer & 0xF) << 12) + 1.0) * 4096.0 end

function geo_function_bobomb_angry(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    r96lib.gfx_color_patch(node, {
        prefix    = "bobomb_angry",
        origDl    = "black_bobomb_body_mesh_layer_1_mat_override_bobomb_blue2_0",
        origMat   = "mat_black_bobomb_bobomb_blue2",
        primIndex = 8,
    })
end

local sBowserColorMeshes = {
    "bowser_spine_mesh_layer_1",
    "bowser_head_mesh_layer_1",
    "bowser_left_foot_mesh_layer_1",
    "bowser_jaw_mesh_layer_1",
    "bowser_right_eye_mesh_layer_1",
    "bowser_shell_mesh_layer_1",
}

function geo_function_bowser_color(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end

    local levelNum = gNetworkPlayers[0].currLevelNum
    if levelNum == LEVEL_BOWSER_3 then
        local t = o.oMrIDizzyTimer
        o.oColorR = _floor((_sin(t * 0.05)         * 0.5 + 0.5) * 100)
        o.oColorG = _floor((_sin(t * 0.05 + 2.094) * 0.5 + 0.5) * 100)
        o.oColorB = _floor((_sin(t * 0.05 + 4.189) * 0.5 + 0.5) * 100)

        o.oMrIDizzyTimer = o.oMrIDizzyTimer + 1
        if (o.oMrIDizzyTimer > 0xFFFF) then
            o.oMrIDizzyTimer = 0
        end
    else
        o.oColorR = 0
        o.oColorG = 0
        o.oColorB = 0
    end

    for i = 1, #sBowserColorMeshes do
        r96lib.gfx_color_patch_by_name(node, {
            origDl = sBowserColorMeshes[i]
        })
    end
end

function geo_function_bowser_hair(node, matStackIndex) end
function geo_function_bowser_left_eye(node, matStackIndex) bowser_eye_common(node, 0x2000, 0x0500, 0x0500, 0x1500) end
function geo_function_bowser_left_eyelid(node, matStackIndex) bowser_eyelid_common(node) end
function geo_function_bowser_left_hand(node, matStackIndex)  bowser_hand_switch(node) end
function geo_function_bowser_right_eye(node, matStackIndex) bowser_eye_common(node, 0x0500, 0x2000, 0x0500, 0x1500) end
function geo_function_bowser_right_eyelid(node, matStackIndex) bowser_eyelid_common(node) end
function geo_function_bowser_right_hand(node, matStackIndex) bowser_hand_switch(node) end

function geo_function_chuckya_spin(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local rot = (o.oTimer * 0x2000) & 0xFFFF
    rotN.rotation.x = rot
end

function geo_function_disable_billboard(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

function geo_function_eyerok(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end

    local model = obj_get_model_id_extended(o)

    local player = nearest_player_to_object(o)
    if player == nil then return end

    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation

    local angleToPlayerYaw   = obj_angle_to_object(o, player)
    local angleToPlayerPitch = obj_pitch_to_object(o, player)

    local limitYaw   = 0x2000 -- 45 degrees
    local limitPitch = 0x2000 -- ~22 degrees

    local yaw = angleToPlayerYaw - o.oFaceAngleYaw
    if yaw >  32767 then yaw = yaw - 65536 end
    if yaw < -32768 then yaw = yaw + 65536 end

    local pitch = angleToPlayerPitch
    if pitch >  32767 then pitch = pitch - 65536 end
    if pitch < -32768 then pitch = pitch + 65536 end

    yaw = _max(-limitYaw, _min(limitYaw, yaw))
    pitch = _max(-limitPitch, _min(limitPitch, pitch))

    if model == E_MODEL_EYEROK_LEFT_HAND then
        yaw = -yaw
    end

    rotN.rotation.x = yaw   & 0xFFFF
    rotN.rotation.y = 0
    rotN.rotation.z = pitch & 0xFFFF
end

function geo_function_kingbob_pulse(node, matStackIndex)
   local o = geo_get_current_object()
   if o == nil then return end
    r96lib.gfx_color_patch_by_name(node, {
        origDl = "king_bobomb_004_offset_mesh_layer_1"
    })
end

function geo_function_scuttle_body(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local rot = (o.oTimer * 0x200) & 0xFFFF
    rotN.rotation.x = rot
    rotN.rotation.y = rot
    rotN.rotation.z = rot
end

function geo_function_scuttle_body_color(node, matStackIndex)
    r96lib.gfx_color_patch(node, {
        prefix    = "scuttle",
        origDl    = "scuttlebug_scuttle_body_dl_mesh_layer_1",
        origMat   = "mat_scuttlebug_scuttlebug_body",
        primIndex = 7,
    })
end

function geo_function_wiggler_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local id = o._pointer
    cast_graph_node(node.next).rotation.x = (((id >> 11) % 4) + 1) * 0x1500
    cast_graph_node(node.next).rotation.y = (((id >> 11) % 4) + 1) * 0x1500
    cast_graph_node(node.next).rotation.z = (((id >> 11) % 4) + 1) * 0x1500
end

function geo_function_wing1_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    rotN.rotation.x = wing_rotate(o)
end
 
function geo_function_wing2_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    rotN.rotation.x = -(wing_rotate(o))
end
 
function geo_switch_held_obj(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1
    if gWarioGrabLightAnims[m.marioObj.header.gfx.animInfo.animID] then
        smlua_anim_util_set_animation(m.marioObj, gWarioGrabLightAnims[m.marioObj.header.gfx.animInfo.animID])
        m.marioObj.oSwitchState1 = 1
    else
        m.marioObj.oSwitchState1 = 0
    end
end
 
function geo_switch_kug(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = (geo_get_current_object().oTimer // 4) % 4
end
 
function geo_switch_mario_eye_custom(node, matStackIndex)
    local switchCase = cast_graph_node(node) ---@type GraphNodeSwitchCase
    local marioAction = m.action
    local marioHurtCounter = m.hurtCounter
    local marioHealth = m.health
 
    if m.actionArg == 8 then -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        local eye_sync = sMarioBlinkEnding[m.actionTimer]
        if eye_sync then switchCase.selectedCase = eye_sync end
        if m.actionTimer == 75  then switchCase.selectedCase = R96_EYES_HALF_CLOSED end
        if m.actionTimer == 76  then switchCase.selectedCase = R96_EYES_CLOSED end
        if m.actionTimer == 110 then switchCase.selectedCase = R96_EYES_HALF_CLOSED end
    end
    if m.actionArg == 9 then
        if m.actionTimer == 0  then switchCase.selectedCase = R96_EYES_HALF_CLOSED end
        if m.actionTimer == 58 then switchCase.selectedCase = R96_EYES_OPEN end
    end
    if m.actionArg ~= 8 and m.actionArg ~= 9 then
        blinkTimer = blinkTimer + 1
 
        if blinkFrame == 5 then
            if blinkTimer % 20 == 0 then
                blinkFrame = blinkFrame + 1
                blinkTimer = 0
            end
        elseif blinkFrame == 9 then
            if blinkTimer % 50 == 0 then
                blinkFrame = 1
                blinkTimer = 0
            end
        elseif (blinkFrame < 5 and blinkFrame >= 1) or (blinkFrame < 9 and blinkFrame > 5) then
            if blinkTimer % 2 == 0 then
                blinkFrame = blinkFrame + 1
            end
        end
 
        if gMarioEyeBlinkable[marioAction] then
            switchCase.selectedCase = sMarioBlinkAnimation[blinkFrame]
        else
            blinkFrame = 1
            blinkTimer = 0
            switchCase.selectedCase = R96_EYES_OPEN
        end
 
        if (marioAction & ACT_FLAG_ATTACKING) ~= 0 or
           (marioAction & ACT_FLAG_SWIMMING)  ~= 0 then
            switchCase.selectedCase = R96_EYES_ANGRY
        end
 
        if gMarioEyeOpenWalking[marioAction] then
            switchCase.selectedCase = R96_EYES_OPEN
        end
 
        if marioAction == ACT_START_SLEEPING then
            switchCase.selectedCase = R96_EYES_HALF_CLOSED
        end
 
        if marioAction == ACT_SLEEPING then
            switchCase.selectedCase = R96_EYES_CLOSED
        end
 
        if marioAction == ACT_CRAWLING then
            switchCase.selectedCase = R96_EYES_HALF_OPEN
        end
 
        if gMarioEyeHappy[marioAction] then
            switchCase.selectedCase = R96_EYES_HAPPY
        end
 
        if gMarioEyeDead[marioAction] then
            switchCase.selectedCase = R96_EYES_DEAD
        end
 
        if marioHurtCounter ~= nil and marioHurtCounter > 0 then
            switchCase.selectedCase = R96_EYES_HURT
        end
 
        if marioHealth ~= nil and marioHealth <= 0xFF then
            switchCase.selectedCase = R96_EYES_HURT
        end
 
        if marioAction == ACT_PANTING then
            switchCase.selectedCase = R96_EYES_EXHAUSTED
        end
    end
end
 
function geo_switch_mario_face(node, matStackIndex)
    local switchCase = cast_graph_node(node) ---@type GraphNodeSwitchCase
    local marioAction = m.action
    local marioHurtCounter = m.hurtCounter
    local marioHealth = m.health
 
    if m.actionArg == 8 then -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        local lip_sync = gMarioLipSwitchEndingKiss[m.actionTimer]
        if lip_sync then switchCase.selectedCase = lip_sync end
    end
    if m.actionArg == 9 then
        local lip_sync = gMarioLipSwitchEndingHereWeGo[m.actionTimer]
        if lip_sync then switchCase.selectedCase = lip_sync end
    end
    if m.actionArg ~= 8 and m.actionArg ~= 9 then
        switchCase.selectedCase = R96_FACE_DEFAULT
        if gMarioFaceDefaultIdle[marioAction] then
            longJumpTimer = 0
            switchCase.selectedCase = R96_FACE_DEFAULT
        end
 
        if (marioAction & ACT_FLAG_ATTACKING) ~= 0 then
            switchCase.selectedCase = R96_FACE_ANGRY
        end
 
        if (marioAction & ACT_FLAG_SWIMMING) ~= 0 then
            switchCase.selectedCase = R96_FACE_DEFAULT
        end
 
        if marioAction == ACT_LONG_JUMP then
            longJumpTimer = longJumpTimer + 1
            switchCase.selectedCase = (longJumpTimer < 15)
                and R96_FACE_HAPPY
                or R96_FACE_OPEN
        end
 
        if gMarioFaceDefaultOther[marioAction] then
            switchCase.selectedCase = R96_FACE_DEFAULT
        end
 
        if gMarioFaceHappy[marioAction] then
            switchCase.selectedCase = R96_FACE_HAPPY
        end
 
        if gMarioFaceOpen[marioAction] then
            switchCase.selectedCase = R96_FACE_OPEN
        end
 
        if marioAction == ACT_SLEEPING then
            switchCase.selectedCase = (sleepTimer % 3 == 0)
                and R96_FACE_OPEN
                or R96_FACE_DEFAULT
        end
 
        if marioAction ~= ACT_SLEEPING then
            sleepTimer = 0
        end
 
        if marioHurtCounter ~= nil and marioHurtCounter > 0 then
            switchCase.selectedCase = R96_FACE_ANGRY
        end
 
        if marioHealth ~= nil and marioHealth <= 0xFF then
            switchCase.selectedCase = R96_FACE_ANGRY
        end
 
        if marioAction == ACT_PANTING then
            switchCase.selectedCase = R96_FACE_OPEN
        end
    end
end
 
function geo_switch_peach_left_hand(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    if m.actionArg == 3 or m.actionArg == 4 or m.actionArg == 5 then -- END_PEACH_CUTSCENE_SPAWN_PEACH END_PEACH_CUTSCENE_DESCEND_PEACH END_PEACH_CUTSCENE_RUN_TO_PEACH
        cast_graph_node(node).selectedCase = 1
    end
    if m.actionArg == 6 then -- END_PEACH_CUTSCENE_DIALOG_1
        if m.actionTimer == 120 then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 320 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 7 then -- END_PEACH_CUTSCENE_DIALOG_2
        if m.actionTimer == 0  then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 42 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 8 then -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        if m.actionTimer == 0   then cast_graph_node(node).selectedCase = 1 end
        if m.actionTimer == 35  then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 130 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 10 then -- END_PEACH_CUTSCENE_DIALOG_3
        if m.actionTimer == 0  then cast_graph_node(node).selectedCase = 1 end
        if m.actionTimer == 22 then cast_graph_node(node).selectedCase = 0 end
    end
end
 
function geo_switch_peach_lip(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    if m.actionArg == 6 then -- END_PEACH_CUTSCENE_DIALOG_1
        local lip_sync = gPeachCutsceneDialog1[m.actionTimer]
        if lip_sync then cast_graph_node(node).selectedCase = lip_sync end
    end
    if m.actionArg == 7 then -- END_PEACH_CUTSCENE_DIALOG_2
        local lip_sync = gPeachCutsceneDialog2[m.actionTimer]
        if lip_sync then cast_graph_node(node).selectedCase = lip_sync end
    end
    if m.actionArg == 10 then -- END_PEACH_CUTSCENE_DIALOG_3
        local lip_sync = gPeachCutsceneDialog3[m.actionTimer]
        if lip_sync then cast_graph_node(node).selectedCase = lip_sync end
    end
end
 
function geo_switch_peach_right_hand(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    if m.actionArg == 3 or m.actionArg == 4 or m.actionArg == 5 then -- END_PEACH_CUTSCENE_SPAWN_PEACH END_PEACH_CUTSCENE_DESCEND_PEACH END_PEACH_CUTSCENE_RUN_TO_PEACH
        cast_graph_node(node).selectedCase = 1
    end
    if m.actionArg == 6 then -- END_PEACH_CUTSCENE_DIALOG_1
        if m.actionTimer == 120 then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 320 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 7 then -- END_PEACH_CUTSCENE_DIALOG_2
        if m.actionTimer == 0  then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 42 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 8 then -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        if m.actionTimer == 0   then cast_graph_node(node).selectedCase = 1 end
        if m.actionTimer == 35  then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 130 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 10 then -- END_PEACH_CUTSCENE_DIALOG_3
        if m.actionTimer == 0  then cast_graph_node(node).selectedCase = 1 end
        if m.actionTimer == 22 then cast_graph_node(node).selectedCase = 0 end
    end
end
 
function geo_switch_spindle(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local switchCase = 0
    if (_abs(o.oMoveAnglePitch & 0x7fff) < 8000.0 and o.oAngleVelPitch ~= 0) then
        switchCase = 0
    else
        switchCase = 1
    end
    cast_graph_node(node).selectedCase = switchCase
end

function geo_switch_wiggler_color(node, matStackIndex)
    local o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvWigglerHead)
    if o == nil then return end
    local switch = cast_graph_node(node)
    if o.oHealth == 4 then switch.selectedCase = 0 end
    if o.oHealth == 4 and o.oAction == WIGGLER_ACT_JUMPED_ON then switch.selectedCase = 1 end
    if o.oHealth == 3 and o.oAction == WIGGLER_ACT_JUMPED_ON then switch.selectedCase = 1 end
    if o.oHealth == 2 and o.oAction == WIGGLER_ACT_JUMPED_ON then switch.selectedCase = 0 end
    if o.oHealth == 1 then switch.selectedCase = 0 end
end

function geo_switch_state_1(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end
function geo_switch_state_2(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end

--local function uv_scroll_right(input_vtx, original_uv, current_uv)
--    local speed = 10
--    current_uv[1] = current_uv[1] + speed
--end
--
---- Scroll the uvs in a circular motion
--local function uv_scroll_spin(input_vtx, original_uv, current_uv)
--    local speed    = 0.5
--    local center_u = 500 -- center of rotation in UV space
--    local center_v = 500
--    local offset_u = 0   -- post-rotation translation (right/left)
--    local offset_v = 0   -- post-rotation translation (up/down)
--
--    -- offset from chosen center
--    local rel_u = original_uv[1] - center_u
--    local rel_v = original_uv[2] - center_v
--
--    -- equation for circular motion
--    local t          = get_global_timer() * speed
--    local orig_theta = _atan2(rel_v, rel_u)
--    local orig_dist  = _sqrt(rel_u * rel_u + rel_v * rel_v)
--
--    current_uv[1] = center_u + orig_dist * _cos(orig_theta + t) + offset_u
--    current_uv[2] = center_v + orig_dist * _sin(orig_theta + t) + offset_v
--end
--
---- Scroll the uvs in a circular motion
--local function uv_scroll_spin_slow(input_vtx, original_uv, current_uv)
--    -- adjustable constants
--    local speed = 0.01
--
--    -- equation for circular motion
--    local t = get_global_timer() * speed
--    local orig_theta = _atan2(original_uv[2], original_uv[1])
--    local orig_dist = _sqrt((original_uv[1])*(original_uv[1]) + (original_uv[2])*(original_uv[2]))
--    current_uv[1] = orig_dist * _cos(orig_theta + t)
--    current_uv[2] = orig_dist * _sin(orig_theta + t)
--end
--
--UvScroll.hook_scrolling_function('star_particle_001_displaylist_mesh_layer_5_tri_1', uv_scroll_right)
--
--UvScroll.hook_scrolling_function('kug_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--
--UvScroll.hook_scrolling_function('kug_switchopt1_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt1_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt1_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--
--UvScroll.hook_scrolling_function('kug_switchopt2_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt2_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt2_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--
--UvScroll.hook_scrolling_function('kug_switchopt3_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt3_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt3_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)
--
--UvScroll.hook_scrolling_function('kug_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt1_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt2_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
--UvScroll.hook_scrolling_function('kug_switchopt3_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
--
--UvScroll.hook_scrolling_function('goomba_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_1', uv_scroll_spin)
--UvScroll.hook_scrolling_function('goomba_underground_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_1', uv_scroll_spin)
--UvScroll.hook_scrolling_function('goomba_boxart_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_2', uv_scroll_spin)
--UvScroll.hook_scrolling_function('kug_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_2', uv_scroll_spin)
--UvScroll.hook_scrolling_function('wiggler_head_switch_opt1_000_displaylist5_mesh_layer_1_tri_3', uv_scroll_spin)

local function squish_on_action_enter(o, triggerAction, x, y, z)
    local prev = o.oThwompPrevAction or o.oAction
    if prev ~= triggerAction and o.oAction == triggerAction then
        o.oThwompSquishTimer = 0
        o.oThwompSquishDur   = 5
        o.oThwompBaseScale   = o.header.gfx.scale.x
    end
    if (o.oThwompSquishDur or 0) > 0 and (o.oThwompSquishTimer or 0) <= o.oThwompSquishDur then
        r96lib.squish_apply(o, o.oThwompSquishTimer, o.oThwompSquishDur, x, y, z, o.oThwompBaseScale, nil)
        o.oThwompSquishTimer = o.oThwompSquishTimer + 1
    end
    o.oThwompPrevAction = o.oAction
end

local function wario_charge_hit(o, dist)
    return m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= dist
end

local function wario_charge_kill_common(o)
    spawn_mist_particles_variable(0, 0, 100.0)
    spawn_triangle_break_particles(20, 138, 3.0, 4)
    set_camera_shake_from_point(SHAKE_POS_MEDIUM, m.pos.x, m.pos.y, m.pos.z)
    o.activeFlags = ACTIVE_FLAG_DEACTIVATED
    obj_mark_for_deletion(o)
end

local function update_eye_blink(o, closeMin, closeMax, openMin, openMax)
    o.oSwitchTimer1 = o.oSwitchTimer1 - 1
    if o.oSwitchTimer1 <= 0 then
        if o.oSwitchState1 == 0 then
            o.oSwitchState1 = 1
            o.oSwitchTimer1 = _random(closeMin, closeMax)
        else
            o.oSwitchState1 = 0
            o.oSwitchTimer1 = _random(openMin, openMax)
        end
    end
end

local function bhv_chuckya_heaveho_render96_loop(o)
    if wario_charge_hit(o, 200) then
        spawn_sync_object(id_bhvBlueCoinJumping, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
        create_sound_spawner(SOUND_OBJ_CHUCKYA_DEATH)
        wario_charge_kill_common(o)
    end
end

---@param o Object
local function bhv_1up_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

---@param o Object
local function bhv_1up_render96_loop(o)
    o.oFaceAngleYaw = o.oMoveAngleYaw
end

id_bhvRender961Up = hook_render96_behavior(id_bhv1Up, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upWalking = hook_render96_behavior(id_bhv1upWalking, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upRunningAway = hook_render96_behavior(id_bhv1upRunningAway, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upSliding = hook_render96_behavior(id_bhv1upSliding, false, bhv_1up_render96_init, bhv_1up_render96_loop) -- MOVE MESH TO HITBOX
id_bhvRender961upJumpOnApproach = hook_render96_behavior(id_bhv1upJumpOnApproach, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender96Hidden1up = hook_render96_behavior(id_bhvHidden1up, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender96Hidden1upInPole = hook_render96_behavior(id_bhvHidden1upInPole, false, bhv_1up_render96_init, bhv_1up_render96_loop)

---@param o Object
local function bhv_amp_render96_loop(o)
    if o.oAction == AMP_ACT_ATTACK_COOLDOWN and o.oTimer < 31 then
        if o.oTimer % 2 == 0 then
            o.oSwitchState2 = _random(1, 2)
            if o.oSwitchState2 == 2 then o.oSwitchState1 = 0 else o.oSwitchState1 = 0 end
        end
    elseif o.oAction == AMP_ACT_ATTACK_COOLDOWN and o.oTimer < 90 then
        o.oSwitchState2 = 1
        o.oSwitchState1 = 1
    else
        o.oSwitchState1 = 0
        o.oSwitchState2 = 0
    end
end

id_bhvRender96CirclingAmp = hook_render96_behavior(id_bhvCirclingAmp, false, nil, bhv_amp_render96_loop)
id_bhvRender96HomingAmp = hook_render96_behavior(id_bhvHomingAmp, false, nil, bhv_amp_render96_loop)

---@param o Object
local function bhv_blargg_render96_init(o)
    -- Hitbox
    local sBlaargHitbox = get_temp_object_hitbox()
    sBlaargHitbox.interactType      = INTERACT_FLAME
    sBlaargHitbox.downOffset        = 0
    sBlaargHitbox.damageOrCoinValue = 1
    sBlaargHitbox.health            = 0
    sBlaargHitbox.numLootCoins      = 0
    sBlaargHitbox.radius            = 300
    sBlaargHitbox.height            = 235
    sBlaargHitbox.hurtboxRadius     = 300
    sBlaargHitbox.hurtboxHeight     = 110

    o.oHomeX = o.oPosX
    o.oHomeZ = o.oPosZ
    o.oGravity = 4.0
    o.oFriction = 0.91
    o.oBuoyancy = 1.3
    o.oAnimations = gObjectAnimations.blargg_seg5_anims_0500616C
    -- drop to floor
    o.oPosY, o.oFloor = find_floor(o.oPosX, o.oPosY, o.oPosZ)
    o.oMoveFlags = (o.oMoveFlags | OBJ_MOVE_ON_GROUND)

    obj_set_hitbox(o, sBlaargHitbox)
    o.oAction = BLARGG_MODE_CHASE
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
end

---@param o Object
local function bhv_blargg_render96_check_mario_collision(o)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
        cur_obj_play_sound_2(SOUND_MOVING_LAVA_BURN)
        o.oInteractStatus = o.oInteractStatus & (~INT_STATUS_INTERACTED)
        o.oAction = BLARGG_MODE_KNOCKBACK
        o.oFlags = o.oFlags & (~0x8) -- bit 3
        cur_obj_init_animation(BLARGG_ANIM_ATK)
        o.oBullyMarioCollisionAngle = o.oMoveAngleYaw
    end
end

---@param o Object
local function bhv_blargg_render96_swim(o)
    o.oForwardVel = 5.0
    if obj_return_home_if_safe(o, o.oHomeX, o.oHomeY, o.oHomeZ, 1000) == 1 then
        if m.floor.type == SURFACE_BURNING then
            o.oAction = BLARGG_MODE_CHASE
        else
            o.oAction = BLARGG_MODE_SWIM
       end
            cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_chase(o)
    local homeX = o.oHomeX
    local posY  = o.oPosY
    local homeZ = o.oHomeZ

    o.oFlags = o.oFlags | 0x8
    o.oMoveAngleYaw = o.oFaceAngleYaw

    obj_turn_toward_object(o, m.marioObj, 16, 0x2000)

    if m.riddenObj == nil then o.oForwardVel = 10 else o.oForwardVel = 20 end

    if not is_point_within_radius_of_mario(homeX, posY, homeZ, 5000) or 
    m.floor.type == 0 or 
    posY < o.oPosY then
        o.oAction = BLARGG_MODE_SWIM
        cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_knockback(o)
    if o.oForwardVel < 10.0 and _floor(o.oVelY) == 0 then
        o.oForwardVel = 1.0
        o.oBullyKBTimerAndMinionKOCounter = o.oBullyKBTimerAndMinionKOCounter + 1
        o.oFlags = o.oFlags | 0x8
        o.oMoveAngleYaw = o.oFaceAngleYaw
        obj_turn_toward_object(o, m.marioObj, 16, 0x2000)
    end
    if cur_obj_check_anim_frame(26) ~= 0 then
        cur_obj_play_sound_1(SOUND_OBJ2_PIRANHA_PLANT_BITE)
    end
    if cur_obj_check_if_near_animation_end() ~= 0 then
        o.oAction = BLARGG_MODE_SWIM
        cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_backup(o)
    if o.oTimer == 0 then
        o.oFlags = o.oFlags & (~0x8)
        o.oMoveAngleYaw = o.oMoveAngleYaw + 0x8000
    end

    o.oForwardVel = 5.0

    if o.oTimer == 15 then
        o.oMoveAngleYaw = o.oFaceAngleYaw
        o.oFlags = o.oFlags | 0x8
        o.oAction = BLARGG_MODE_SWIM
    end
end

---@param o Object
local function bhv_blargg_render96_backup_check(o, collisionFlags)
    if (collisionFlags & 0x8) == 0 and o.oAction ~= BLARGG_MODE_KNOCKBACK then
        o.oPosX = o.oBullyPrevX
        o.oPosZ = o.oBullyPrevZ
        o.oAction = BLARGG_MODE_BACKUP
    end
end

---@param o Object
local function bhv_blargg_render96_step(o)
    local collisionFlags = object_step()
    bhv_blargg_render96_backup_check(o, collisionFlags)
end

---@param o Object
local function bhv_blargg_render96_loop(o)
    o.oBullyPrevX = o.oPosX
    o.oBullyPrevY = o.oPosY
    o.oBullyPrevZ = o.oPosZ

    bhv_blargg_render96_check_mario_collision(o)
    spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
    if o.oAction == BLARGG_MODE_SWIM then
        bhv_blargg_render96_swim(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_CHASE then
        bhv_blargg_render96_chase(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_KNOCKBACK then
        bhv_blargg_render96_knockback(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_BACKUP then
        o.oForwardVel = 10.0
        bhv_blargg_render96_backup(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BULLY_ACT_DEATH_PLANE_DEATH then
        o.activeFlags = 0
    end

    set_object_visibility(o, 3000)
end

id_bhvRender96Blargg = hook_render96_behavior(nil, true, bhv_blargg_render96_init, bhv_blargg_render96_loop, OBJ_LIST_LEVEL, "Blargg")

---@param o Object
local function bhv_blargg_friendly_render96_init(o)
    local sBlarggFriendlyHitbox = get_temp_object_hitbox()
    sBlarggFriendlyHitbox.interactType = INTERACT_KOOPA_SHELL
    sBlarggFriendlyHitbox.downOffset = 0
    sBlarggFriendlyHitbox.damageOrCoinValue = 4
    sBlarggFriendlyHitbox.health = 1
    sBlarggFriendlyHitbox.numLootCoins = 1
    sBlarggFriendlyHitbox.radius = 100
    sBlarggFriendlyHitbox.height = 100
    sBlarggFriendlyHitbox.hurtboxRadius = 50
    sBlarggFriendlyHitbox.hurtboxHeight = 50

    obj_set_hitbox(o, sBlarggFriendlyHitbox)
    o.oAnimations = gObjectAnimations.blargg_seg5_anims_0500616C
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
    o.oAction = 0
    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ
    o.activeFlags = ACTIVE_FLAG_ACTIVE
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    cur_obj_scale(1)
end

---@param o Object
local function bhv_blargg_friendly_render96_explode(o)
    m.action = ACT_WALKING
    mario_stop_riding_object(m)
    o.activeFlags = ACTIVE_FLAG_DEACTIVATED
    obj_mark_for_deletion(o)
    local explosion = spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, nil)
    explosion.oGraphYOffset = explosion.oGraphYOffset + 100.0
end

---@param o Object
local function bhv_blargg_friendly_render96_loop(o)
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
    if o.oAction == 0 then
        cur_obj_update_floor_and_walls()
        cur_obj_if_hit_wall_bounce_away()

        if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
            o.oAction = 1
            if m ~= nil then o.heldByPlayerIndex = m.playerIndex end
        end
        cur_obj_move_standard(-20)

    elseif o.oAction == 1 then
        o.activeFlags = ACTIVE_FLAG_ACTIVE
        cur_obj_enable_rendering()
        obj_copy_pos(o, m.marioObj)
        o.oFaceAngleYaw = m.marioObj.oMoveAngleYaw
        local floor = cur_obj_update_floor_height_and_get_floor()
        if _abs(o.oPosY - o.oFloorHeight) < 5.0 then
            if floor ~= nil and floor.type == SURFACE_BURNING then
                 spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
                 o.oTimer = 0
                 o.oMrISize = 1
                 cur_obj_scale(o.oMrISize)
            else
                if o.oTimer % 10 == 0 then
                    o.oMrISize = o.oMrISize - .1
                    cur_obj_scale(o.oMrISize)
                    if o.oMrISize <= 0.4 then
                        bhv_blargg_friendly_render96_explode(o)
                    end
                end
            end
        end
        if (o.oInteractStatus & INT_STATUS_STOP_RIDING) ~= 0 then
            bhv_blargg_friendly_render96_explode(o)
        end
    end
    o.oInteractStatus = 0
end

id_bhvRender96BlarggFriendly = hook_render96_behavior(nil, false, bhv_blargg_friendly_render96_init, bhv_blargg_friendly_render96_loop, OBJ_LIST_LEVEL, "BlarggFriendly")

local COLORS_BOBOMB = {
    {r = 4, g = 4, b = 4},
    {r = 200, g = 0, b = 0}, 
}

---@param o Object
local function bhv_bobomb_render96_init(o)
    o.oColorR = 4
    o.oColorG = 4
    o.oColorB = 4
end

---@param o Object
local function bhv_bobomb_render96_loop(o)
    if o.oBobombFuseTimer == 0 then 
        o.oSwitchState1 = 0
    else 
        o.oSwitchState1 = 1
        r96lib.pulse_ramp(o, COLORS_BOBOMB, o.oBobombFuseTimer, 150)
    end
    if m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 200 then
		set_camera_shake_from_point(SHAKE_POS_MEDIUM, m.pos.x, m.pos.y, m.pos.z)
        o.oBobombFuseTimer = 152
    end
end

id_bhvRender96Bobomb = hook_render96_behavior(id_bhvBobomb, false, bhv_bobomb_render96_init, bhv_bobomb_render96_loop, OBJ_LIST_DESTRUCTIVE)

---@param o Object
local function bhv_boo_render96_init(o)
    o.oOpacity = 255
    o.oSwitchState2 = 0
    o.oSwitchTimer2 = 1
end

---@param o Object
local function bhv_boo_render96_loop(o)

    squish_on_action_enter(o, 2, 0.15, 0.15, -0.3)

    local sBooScared = { 0, 1, 2, 3, 4, 4, 4}
    local sBooHunt = { 4, 4, 4, 3, 2, 1, 0}
    if o.oOpacity < 255 and o.oSwitchTimer2 < 7 then
        o.oOpacity = 254 - (o.oSwitchTimer2 * 15) 
        o.oSwitchState2 = sBooScared[o.oSwitchTimer2]
        o.oSwitchTimer2 = o.oSwitchTimer2 + 1
    elseif o.oOpacity >= 150 and o.oSwitchTimer2 >= 7 and o.oSwitchTimer2 < 14 then
        o.oSwitchState2 = sBooHunt[o.oSwitchTimer2 - 6]
        o.oSwitchTimer2 = o.oSwitchTimer2 + 1
    elseif o.oOpacity == 255 and o.oSwitchTimer2 == 14 then
        o.oSwitchState2 = 0
        o.oSwitchTimer2 = 1
    elseif o.oOpacity == 40 and o.oSwitchTimer2 == 14 then
        o.oSwitchState2 = 4
        o.oSwitchTimer2 = 7
    elseif o.oOpacity == 40 and o.oSwitchTimer2 == 7 then
        o.oSwitchState2 = 4
    end
end

id_bhvRender96GhostHuntBoo = hook_render96_behavior(id_bhvGhostHuntBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96GhostHuntBigBoo = hook_render96_behavior(id_bhvGhostHuntBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96BooWithCage = hook_render96_behavior(id_bhvBooWithCage, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96BalconyBigBoo = hook_render96_behavior(id_bhvBalconyBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96MerryGoRoundBigBoo = hook_render96_behavior(id_bhvMerryGoRoundBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)

---@param o Object
local function bhv_bowling_ball(o)
    if wario_charge_hit(o, 200) then
        create_sound_spawner(SOUND_GENERAL2_BOBOMB_EXPLOSION)
        wario_charge_kill_common(o)
    end
end

id_bhvRender96BowlingBall = hook_render96_behavior(id_bhvBowlingBall, false, nil, bhv_bowling_ball)

---@param o Object
local function bhv_bowser_render96_init(o)
    cur_obj_scale(1.1)
end

---@param o Object
local function bhv_bowser_render96_loop(o)
    obj_set_model_extended(o, E_MODEL_BOWSER)
    o.oSwitchTimer1 = o.oSwitchTimer1 + 1
end

id_bhvRender96Bowser = hook_render96_behavior(id_bhvBowser, false, nil, bhv_bowser_render96_loop, OBJ_LIST_GENACTOR)

local function bhv_breakable_box_render96_loop(o)
    if (m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 240) then
        obj_explode_and_spawn_coins(46, 1)
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX)
    end
end

id_bhvRender96BreakableBox = hook_render96_behavior(id_bhvBreakableBox, false, nil, bhv_breakable_box_render96_loop)

---@param o Object
local function bhv_bubba_render96_init(o)
    smlua_anim_util_set_animation(o, "bubba_swim")
end

local function bhv_bubba_render96_loop(o)
    o.oSwitchState1 = o.oAnimState
end

id_bhvRender96Bubba = hook_render96_behavior(id_bhvBubba, false, bhv_bubba_render96_init, bhv_bubba_render96_loop)

---@param o Object
local function bhv_bully_render96_loop(o)
    update_eye_blink(o, 4, 10, 30, 100)
end

---@param o Object
local function bhv_big_bully_render96_init(o)
    cur_obj_scale(2)
end

id_bhvRender96Bully = hook_render96_behavior(id_bhvSmallBully, false, nil, bhv_bully_render96_loop)
id_bhvRender96SmallChillBully = hook_render96_behavior(id_bhvSmallChillBully, false, nil, bhv_bully_render96_loop)

id_bhvRender96BigBully = hook_render96_behavior(id_bhvBigBully, false, bhv_big_bully_render96_init, bhv_bully_render96_loop)
id_bhvRender96BigChillBully = hook_render96_behavior(id_bhvBigChillBully, false, bhv_big_bully_render96_init, bhv_bully_render96_loop)
id_bhvRender96BigBullyWithMinions = hook_render96_behavior(id_bhvBigBullyWithMinions, false, bhv_big_bully_render96_init, bhv_bully_render96_loop)

---@param o Object
local function bhv_chain_chomp_render96_loop(o)
    local frame = o.header.gfx.animInfo.animFrame

    local sBiteFrames = { 0, 1, 2, 4, 6, 8, 6, 4, 2, 0, 2, 4, 6, 8, 6, 4, 2, 1, 0}
    if frame > 0 then
        o.oSwitchState2 = sBiteFrames[frame]
    end
    if frame == -1 then
        o.oSwitchState2 = 0
    end
end

id_bhvRender96ChainChomp = hook_render96_behavior(id_bhvChainChomp, false, nil, bhv_chain_chomp_render96_loop)

local function bhv_chuckya_render96_loop(o) bhv_chuckya_heaveho_render96_loop(o) end

id_bhvRender96Chuckya = hook_render96_behavior(id_bhvChuckya, false, nil, bhv_chuckya_render96_loop, OBJ_LIST_GENACTOR)

---@param o Object
local function bhv_cloud_render96_init(o)
    if (o.oBehParams2ndByte ~= CLOUD_BP_FWOOSH) then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96Cloud = hook_render96_behavior(id_bhvCloud, false, bhv_cloud_render96_init, nil, OBJ_LIST_DEFAULT)

---@param o Object
local function bhv_cloudpart_render96_init(o)
    if obj_has_model_extended(o, E_MODEL_MIST) ~= 0 then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96CloudPart = hook_render96_behavior(id_bhvCloudPart, false, bhv_cloudpart_render96_init, nil, OBJ_LIST_DEFAULT)

---@param o Object
local function bhv_fire_piranha_plant_render96_loop(o)
    local frame = o.header.gfx.animInfo.animFrame
    if o.oAction == FIRE_PIRANHA_PLANT_ACT_GROW then
        if frame < 46 then
            o.oSwitchState2 = 10
        elseif frame >= 46 and frame <= 66 then
            o.oSwitchState2 = frame - 56
        else
            o.oSwitchState2 = 10
        end
    end

    if o.oAction == FIRE_PIRANHA_PLANT_ACT_HIDE then
        if frame < 10 then
            o.oSwitchState2 = 10
        elseif frame >= 10 and frame <= 30 then
            o.oSwitchState2 = frame - 20
        else
            o.oSwitchState2 = 10
        end
    end
end

id_bhvRender96FirePiranhaPlant = hook_render96_behavior(id_bhvFirePiranhaPlant, false, bhv_piranha_plant_render96_init, bhv_fire_piranha_plant_render96_loop)

---@param o Object
local function bhv_fire_spitter_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
    o.header.gfx.scale.x = 0.2
    o.oThwompBaseScale = o.header.gfx.scale.x
end

---@param o Object
local function bhv_fire_spitter_render96_loop(o)
    local player = nearest_player_to_object(o)
    local angleToPlayer = obj_angle_to_object(o, player)
    o.oFaceAngleYaw = angleToPlayer
    if o.oAction == FIRE_SPITTER_ACT_IDLE then
        if o.oTimer < 20 then o.oSwitchState1 = 2 o.header.gfx.scale.x = 0.15 end
        if o.oTimer > 20 and o.oTimer < 50 then
            o.oSwitchState1 = 3
            if o.oTimer % 5 == 0 then
                o.oThwompSquishTimer = 0
                o.oThwompSquishDur = 5
                o.header.gfx.scale.x = 0.10
            else
                o.header.gfx.scale.x = 0.2
            end
            if (o.oThwompSquishDur or 0) > 0 and (o.oThwompSquishTimer or 0) <= o.oThwompSquishDur then
                r96lib.squish_apply(o, o.oThwompSquishTimer, o.oThwompSquishDur, 0.15, -0.3, -0.3, o.oThwompBaseScale, nil)
                o.oThwompSquishTimer = o.oThwompSquishTimer + 1
            end
        elseif o.oTimer == 51 then
            o.oSwitchState1 = 0
        end
    end
    if o.oAction == FIRE_SPITTER_ACT_SPIT_FIRE then
        if o.oTimer < 10 then
            o.oSwitchState1 = 1
        elseif o.oTimer == 10 then
            o.oSwitchState1 = 2
        end
    end
end

id_bhvRender96FireSpitter = hook_render96_behavior(id_bhvFireSpitter, false, bhv_fire_spitter_render96_init, bhv_fire_spitter_render96_loop, OBJ_LIST_GENACTOR)

---@param o Object
local function bhv_flame_render96_init(o)
    o.oWallAngle = 0
    o.oWallX = 0
    o.oWallZ = 0
    for i = 0, 3 do
        local ray = collision_find_surface_on_ray(o.oPosX, o.oPosY, o.oPosZ, sins(i*0x4000)*500, 0, coss(i*0x4000)*500, 128)
        local dist = _sqrt((ray.hitPos.x - o.oPosX)^2 + (ray.hitPos.z - o.oPosZ)^2)
        local nDist = _sqrt((o.oWallX - o.oPosX)^2 + (o.oWallZ - o.oPosZ)^2)
        if (dist < nDist or not o.oWallAngle) and ray.surface then
            o.oWallX = ray.hitPos.x
            o.oWallZ = ray.hitPos.z
            o.oWallAngle = atan2s(ray.surface.normal.z, ray.surface.normal.x)
        end
    end
end

---@param o Object
local function bhv_flame_render96_loop(o)
    local model = obj_get_model_id_extended(o)
    if o.oTimer < 2 then
        if model == E_MODEL_RED_FLAME_TORCH or model == E_MODEL_BLUE_FLAME_TORCH then
            o.oPosX = o.oWallX
            o.oPosZ = o.oWallZ
            o.oFaceAngleYaw = o.oWallAngle
            o.oMoveAngleYaw = o.oWallAngle
        end
    end
end

id_bhvRender96Flame = hook_render96_behavior(id_bhvFlame, false, bhv_flame_render96_init, bhv_flame_render96_loop, OBJ_LIST_LEVEL)

---@param o Object
local function bhv_goomba_render96_init(o)
    o.oSwitchState2 = 0
    o.oSwitchState1 = 0
    o.oSwitchTimer1 = 0
    o.oSwitchTimer2 = 0
end

---@param o Object
local function bhv_goomba_render96_death(o)
    spawn_mist_particles()
    obj_spawn_yellow_coins(o, o.oNumLootCoins)
    create_sound_spawner(SOUND_OBJ_STOMPED)
    o.activeFlags = ACTIVE_FLAG_DEACTIVATED
    obj_mark_for_deletion(o)
end

local GOOMBA_OPTS = {
    audio = EVENT_THROWN,
    interactions = sThrownInteractions,
    enemy = true
}

local sGoombaWarioDeath = {
    [ACT_WARIO_GROUND_POUND] = true,
    [ACT_GROUND_POUND_LAND] = true,
    [ACT_WARIO_PILE_DRIVER] = true,
    [ACT_WARIO_PILE_DRIVER_LAND] = true,
    [ACT_WARIO_CHARGE] = true,
}

---@param o Object
local function bhv_goomba_render96_loop(o)
    update_eye_blink(o, 3, 8, 30, 100)

    o.oSwitchState2 = 0
    
    if o.oAction == GOOMBA_ACT_JUMP then
        o.oSwitchState1 = 0
        o.oSwitchTimer1 = 0
        o.oSwitchState2 = 1
    end

    if get_character(m).type == CT_WARIO then
        if o.oAction == OBJ_ACT_SQUISHED then
            if not sGoombaWarioDeath[m.action] then
                set_mario_particle_flags(m, PARTICLE_HORIZONTAL_STAR, 0)
                o.oInteractType = INTERACT_GRABBABLE
                o.oAction = GOOMBA_ACT_STUN
                o.oSwitchState2 = 1
                o.oSwitchState1 = 2
                o.oTimer = 0
                cur_obj_init_animation_with_accel_and_sound(0, 0)
            elseif sGoombaWarioDeath[m.action] then
                bhv_goomba_render96_death(o)
            end
        end
    
        --Stunned from wario's jump, checks if going to be grabbed
        if (o.oHeldState == HELD_FREE and o.oAction == GOOMBA_ACT_STUN and o.oTimer <= 150) then
            if sGoombaWarioDeath[m.action] and dist_between_objects(o, m.marioObj) <= 150 then
                bhv_goomba_render96_death(o)
            end
            o.oGoombaTargetYaw = o.oGoombaTargetYaw + 0x1000
            cur_obj_rotate_yaw_toward(o.oGoombaTargetYaw, 0x1000)
            o.oSwitchState2 = 1
            o.oSwitchState1 = 2
            if mario_check_object_grab(m) ~= 0 and (m.heldObj == nil) then
                m.usedObj = o
                mario_grab_used_object(m)
                o.oAction = GOOMBA_ACT_GRAB
            end
        end
        
        r96lib.npcGrabHandler(o, GOOMBA_OPTS)

        if o.oHeldState == HELD_HELD then
            o.oSwitchState2 = 1
            o.oSwitchState1 = 2
        end

        --If not picked up after some time, go back to walking
        if (o.oHeldState == HELD_FREE and o.oAction == GOOMBA_ACT_STUN and o.oTimer > 150) then
            o.oInteractType = INTERACT_BOUNCE_TOP;
            o.oAction = GOOMBA_ACT_WALK;
            o.oSwitchState2 = 0
            o.oSwitchState1 = 0
            cur_obj_init_animation_with_accel_and_sound(0, 1) 
            return
        end
    end
end

id_bhvRender96Goomba = hook_render96_behavior(id_bhvGoomba, false, bhv_goomba_render96_init, bhv_goomba_render96_loop)

---@param o Object
local function bhv_heaveho_render96_loop(o) bhv_chuckya_heaveho_render96_loop(o) end

id_bhvRender96HeaveHo = hook_render96_behavior(id_bhvHeaveHo, false, nil, bhv_heaveho_render96_loop, OBJ_LIST_GENACTOR)

local COLORS_KINGBOBOMB = {
    {r = 4, g = 4, b = 4},
    {r = 150, g = 0,  b = 0},
}

---@param o Object
local function bhv_king_bobomb_render96_init(o)
    o.oColorR = 4
    o.oColorG = 4
    o.oColorB = 4
end

---@param o Object
local function bhv_king_bobomb_render96_loop(o)
    if o.oHealth == 3 then   
        o.oColorR = 4
        o.oColorG = 4
        o.oColorB = 4
    end
    if o.oHealth == 2 then r96lib.pulse_rapid(o, COLORS_KINGBOBOMB, o.oTimer, 0.1) end
    if o.oHealth == 1 then r96lib.pulse_rapid(o, COLORS_KINGBOBOMB, o.oTimer, 0.3) end
end

id_bhvRender96KingBobomb = hook_render96_behavior(id_bhvKingBobomb, false, bhv_king_bobomb_render96_init, bhv_king_bobomb_render96_loop, OBJ_LIST_GENACTOR)

local SHELL_OPTS = {
    audio = EVENT_SHELL_THROWN,
    interactions = sThrownInteractions,
}

---@param o Object
local function bhv_koopa_shell_render96_loop(o)
    if get_character(m).type == CT_WARIO then
        o.oInteractType = INTERACT_GRABBABLE
        if mario_check_object_grab(m) ~= 0 and (m.heldObj == nil) then
            o.oAction = 50
        end
    
        local koopa = obj_get_nearest_object_with_behavior_id(o, id_bhvKoopa)
        if koopa ~= nil then
            spawn_mist_particles()
            spawn_sync_object(id_bhvBlueCoinJumping, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
            create_sound_spawner(SOUND_OBJ_STOMPED)
            koopa.activeFlags = ACTIVE_FLAG_DEACTIVATED
            obj_mark_for_deletion(koopa)
        end

        r96lib.npcGrabHandler(o, SHELL_OPTS)

        if o.oHeldState == HELD_HELD then
            if gMarioStates[0].heldObj ~= nil then
                spawn_non_sync_object(id_bhvSparkleSpawn, E_MODEL_NONE, gMarioStates[0].marioObj.oPosX, gMarioStates[0].marioObj.oPosY + 100, gMarioStates[0].marioObj.oPosZ, nil)
            end
        end
    
        if o.oHeldState == HELD_FREE and (m.action == ACT_WARIO_CHARGE or m.action == ACT_JUMP_KICK) and dist_between_objects(o, m.marioObj) <= 200 then
            o.oAction = 50
            o.oMoveAngleYaw = m.faceAngle.y
            o.oForwardVel = 50.0
            o.oVelY = 20.0
            o.oTimer = 0
        end

        if (m.action == ACT_HOLD_WATER_IDLE or m.action == ACT_HOLD_WATER_ACTION_END) and m.heldObj == o 
        then mario_drop_held_object(m) 
            o.activeFlags = ACTIVE_FLAG_DEACTIVATED
            obj_mark_for_deletion(o)
        end
        o.oInteractStatus = 0
    end
end

id_bhvRender96KoopaShell = hook_render96_behavior(id_bhvKoopaShell, false, nil, bhv_koopa_shell_render96_loop)

---@param o Object
local function bhv_luigi_key_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oWallHitboxRadius = 30
    o.oGravity = -400
    o.oBounciness = -70
    o.oDragStrength = 1000
    o.oFriction = 1000
    o.oBuoyancy = 200
    o.hitboxHeight = 64
    o.hitboxRadius = 32
    o.oHomeY = o.oPosY
end

---@param o Object
local function bhv_luigi_key_loop(o)
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x700
    o.oPosY = o.oHomeY + sins(o.oTimer * 0x600) * 8
    if dist_between_objects(o, m.marioObj) <= 150 then
        r96lib.save_render96_data("luigi_key", o.oBehParams2ndByte)
        gNumLuigiKeys = select(2, r96lib.load_render96_data("luigi_key"):gsub("1", ""))
        spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_SPARKLES, o.oPosX, o.oPosY, o.oPosZ, nil)
        audio_stream_play(COLLECTABLE, false, 1)
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
    if r96lib.check_render96_data("luigi_key", o.oBehParams2ndByte) == true then
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
end

id_bhvLuigiKeys = hook_render96_behavior(nil, false, bhv_luigi_key_init, bhv_luigi_key_loop, OBJ_LIST_SURFACE, "LuigiKeys")

---@param o Object
local function bhv_snowball_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

id_bhvRender96MrBlizzardSnowball = hook_render96_behavior(id_bhvMrBlizzardSnowball, false, bhv_snowball_render96_init, nil, OBJ_LIST_GENACTOR)

local DEATH_THRESHOLD = 4 * _pi
local FOV_THRESHOLD = degrees_to_sm64(30)
local CIRCLE_MIN_DELTA  = 200

---@param o Object
local function  bhv_mr_i_render96_init(o)
    o.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)
    o.oPosY = o.oPosY + 60

    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ

    local sMrIHitbox = get_temp_object_hitbox()
    sMrIHitbox.interactType         = INTERACT_DAMAGE
    sMrIHitbox.health               = 2
    sMrIHitbox.numLootCoins         = 5
    sMrIHitbox.damageOrCoinValue    = 2
    sMrIHitbox.radius               = 80
    sMrIHitbox.height               = 150
    sMrIHitbox.hurtboxRadius        = 50
    sMrIHitbox.hurtboxHeight        = 100
    sMrIHitbox.downOffset           = 0
    obj_set_hitbox(o, sMrIHitbox)

    o.oIntangibleTimer  = 0
    o.oDrawingDistance  = 4000
    o.oDeathSound       = SOUND_OBJ_ENEMY_DEATH_HIGH

    o.oAction           = MR_I_IDLE

    o.oMrISize          = 2
    o.oSwitchState2     = 0
    o.oSwitchTimer1         = 0
    o.oMrIBlinkIndex    = 1
    o.oMrIDetectRadius  = 500
    o.oMrIDizzyTimer    = 0
    o.oMrIDizzyDuration = 120
    o.oMrITracking      = 0
    o.oMrILastAngle     = obj_angle_to_object(o, nearest_player_to_object(o))
    o.oMrIFireTimer     = 0

    if o.oBehParams2ndByte == 0x05010000 then o.oMrISize = 4 o.oPosY = o.oPosY + 120 o.oHomeY = o.oPosY end
    cur_obj_scale(o.oMrISize)
end

---@param o Object
---@param player Object
local function bhv_mr_i_render96_fire(o, player)
    local yaw   = o.oFaceAngleYaw
    local pitch = o.oFaceAnglePitch
    local speed = 25.0
    local spawnY = o.oPosY - 40
    local particle = nil

    if o.oBehParams2ndByte == 0x05010000 then 
        spawnY = spawnY - 40 
        particle = spawn_non_sync_object(id_bhvRender96MrIFireParticle, E_MODEL_BLUE_FLAME, o.oPosX, spawnY, o.oPosZ, nil)
    else
        particle = spawn_non_sync_object(id_bhvRender96MrIParticle, E_MODEL_PURPLE_MARBLE, o.oPosX, spawnY, o.oPosZ, nil)
    end
    if particle == nil then return end

    particle.oMoveAngleYaw   = yaw
    particle.oMoveAnglePitch = pitch
    particle.oForwardVel     = speed
    particle.oVelX           = speed * coss(pitch) * sins(yaw)
    particle.oVelY           = speed * sins(-pitch)
    particle.oVelZ           = speed * coss(pitch) * coss(yaw)

    cur_obj_play_sound_2(SOUND_OBJ_MRI_SHOOT)
end

local sMrIBlinkStates = { 0, 1, 2, 3, 4, 3, 2, 1, 0 }

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_track(o, player, dist, angleToPlayer, angleDiff)

    if dist > o.oMrIDetectRadius or angleDiff > FOV_THRESHOLD then
        o.oMrITracking = 0
        o.oMrILastAngle = angleToPlayer
        return
    end

    local delta = angleToPlayer - o.oMrILastAngle
    if delta > 32767  then delta = delta - 65536 end
    if delta < -32767 then delta = delta + 65536 end

    o.oMrILastAngle = angleToPlayer

    if _abs(delta) >= CIRCLE_MIN_DELTA then
        o.oMrITracking = o.oMrITracking + _abs(delta) * ( _pi / 32768.0)
    else
        o.oMrITracking = 0
    end
end

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_attack(o, player, dist, angleToPlayer, angleDiff)
    o.oFaceAngleYaw = angleToPlayer
    o.oFaceAnglePitch = _min(obj_pitch_to_object(o, player), 0)
    o.oMrIFireTimer = o.oMrIFireTimer + 1
    if o.oMrIFireTimer >= 100 then
        o.oSwitchTimer1 = o.oSwitchTimer1 - 1
        if o.oSwitchTimer1 <= 0 then
            o.oMrIBlinkIndex = o.oMrIBlinkIndex + 1
            if o.oMrIBlinkIndex > #sMrIBlinkStates then
                o.oMrIBlinkIndex = 1
                o.oMrIFireTimer = 0
            else
                o.oSwitchState2 = sMrIBlinkStates[o.oMrIBlinkIndex]
            end
            if o.oSwitchState2 == 4 then
                bhv_mr_i_render96_fire(o, player)
            end
            o.oSwitchTimer1 = 2
        end
    end

    bhv_mr_i_render96_track(o, player, dist, angleToPlayer, angleDiff)
    if o.oMrITracking >= DEATH_THRESHOLD then
        o.oAction = MR_I_DIZZY
        o.oMrIDizzyTimer = 0
        o.oMrITracking = 0
        o.oSwitchState2 = 0 
    end     
    if dist > o.oMrIDetectRadius * 1.5 then
        o.oAction = MR_I_IDLE
        o.oMrITracking = 0
    end
end

---@param o Object
local function bhv_mr_i_render96_dizzy(o)
    local frames = o.oMrIDizzyDuration - o.oMrIDizzyTimer

    o.oMrIDizzyTimer = o.oMrIDizzyTimer + 1
    o.oFaceAngleYaw = (o.oFaceAngleYaw + 0x1500) & 0xFFFF
    o.oFaceAnglePitch = _floor(-0x4000 * _min(o.oMrIDizzyTimer / o.oMrIDizzyDuration, 1.0))

    if frames % 15 == 0 and frames > 20 then cur_obj_play_sound_2(SOUND_OBJ2_MRI_SPINNING) end
    if frames == 15 then cur_obj_play_sound_2(SOUND_OBJ_MRI_DEATH) end
    if frames <= 10 then cur_obj_scale(o.oMrISize + (0.5 - o.oMrISize) * (1.0 - (frames / 10.0))) end
    if frames > 10 then cur_obj_scale(o.oMrISize + _sin(o.oMrIDizzyTimer * 0.3) * 0.15) end

    if o.oMrIDizzyTimer >= o.oMrIDizzyDuration then o.oAction = MR_I_DEAD end
end

---@param o Object
local function bhv_mr_i_render96_dead(o)
    spawn_mist_particles()
    if o.oBehParams2ndByte == 0x05010000 then
        spawn_default_star(1370, 2000.0, -320.0)
    else
        cur_obj_spawn_loot_blue_coin()
    end    
    obj_mark_for_deletion(o)
end

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_idle(o, player, dist, angleToPlayer, angleDiff)
    o.oFaceAngleYaw = (o.oFaceAngleYaw - 0x100) & 0xFFFF
    o.oFaceAnglePitch = 0

    o.oSwitchTimer1 = o.oSwitchTimer1 - 1
    if o.oSwitchTimer1 <= 0 then
        o.oMrIBlinkIndex = o.oMrIBlinkIndex + 1
        if o.oMrIBlinkIndex > #sMrIBlinkStates then
            o.oMrIBlinkIndex = 1
            o.oSwitchTimer1 = _random(30, 100)
        else
            o.oSwitchState2 = sMrIBlinkStates[o.oMrIBlinkIndex]
            o.oSwitchTimer1 = 2
        end
    end

    if dist < o.oMrIDetectRadius and angleDiff < FOV_THRESHOLD then
        o.oSwitchState2 = 0 
        o.oAction = MR_I_ATTACK
        o.oMrIFireTimer = 0
    end
end

local sMrIActionStates = { bhv_mr_i_render96_idle, bhv_mr_i_render96_attack, bhv_mr_i_render96_dizzy, bhv_mr_i_render96_dead }

---@param o Object
local function bhv_mr_i_render96_loop(o)
    local player = nearest_player_to_object(o)
    local dist   = dist_between_objects(o, player)
    local angleToPlayer = obj_angle_to_object(o, player)
    local angleDiff = abs_angle_diff(o.oFaceAngleYaw, angleToPlayer)
    sMrIActionStates[o.oAction + 1](o, player, dist, angleToPlayer, angleDiff)

    squish_on_action_enter(o, 1, 0.15, -0.20, 0.15)

    o.oInteractStatus = 0
end

id_bhvRender96MrI = hook_render96_behavior(nil, true, bhv_mr_i_render96_init, bhv_mr_i_render96_loop, OBJ_LIST_GENACTOR, "MrI")

---@param o Object
local function bhv_mr_i_render96_fire_particle_init(o)
    local sParticleHitbox = get_temp_object_hitbox()
    sParticleHitbox.interactType        = INTERACT_FLAME
    sParticleHitbox.downOffset          = 0
    sParticleHitbox.damageOrCoinValue   = 2
    sParticleHitbox.health              = 1
    sParticleHitbox.numLootCoins        = 0
    sParticleHitbox.radius              = 100
    sParticleHitbox.height              = 100
    sParticleHitbox.hurtboxRadius       = 50
    sParticleHitbox.hurtboxHeight       = 50
    obj_set_hitbox(o, sParticleHitbox)

    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
    o.oDrawingDistance   = 4000

    cur_obj_scale(6)
end

---@param o Object
local function bhv_mr_i_render96_fire_particle_loop(o)
    cur_obj_move_using_fvel_and_gravity()
    cur_obj_update_floor_and_walls()
    o.oAnimState = _floor(_random() * 10)
    if (o.oInteractStatus & 0x8000) ~= 0
        or o.oTimer >= 101
        or (o.oMoveFlags & OBJ_MOVE_LANDED) ~= 0 
        or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0 
        or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0
        or (o.activeFlags & ACTIVE_FLAG_IN_DIFFERENT_ROOM) ~= 0 then
        spawn_mist_particles()
        obj_mark_for_deletion(o)
    end
    o.oInteractStatus = 0
end

id_bhvRender96MrIFireParticle = hook_render96_behavior(nil, false, bhv_mr_i_render96_fire_particle_init, bhv_mr_i_render96_fire_particle_loop, OBJ_LIST_GENACTOR, "MrIFireParticle")

---@param o Object
local function bhv_mr_i_render96_particle_init(o)
    local sParticleHitbox = get_temp_object_hitbox()
    sParticleHitbox.interactType        = INTERACT_DAMAGE
    sParticleHitbox.downOffset          = 0
    sParticleHitbox.damageOrCoinValue   = 2
    sParticleHitbox.health              = 1
    sParticleHitbox.numLootCoins        = 0
    sParticleHitbox.radius              = 100
    sParticleHitbox.height              = 100
    sParticleHitbox.hurtboxRadius       = 50
    sParticleHitbox.hurtboxHeight       = 50
    obj_set_hitbox(o, sParticleHitbox)

    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
    o.oDrawingDistance   = 4000

    cur_obj_scale(3)
end

---@param o Object
local function bhv_mr_i_render96_particle_loop(o)
    cur_obj_move_using_fvel_and_gravity()
    cur_obj_update_floor_and_walls()

    if (o.oInteractStatus & 0x8000) ~= 0
        or o.oTimer >= 101
        or (o.oMoveFlags & OBJ_MOVE_LANDED) ~= 0 
        or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0 
        or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0
        or (o.activeFlags & ACTIVE_FLAG_IN_DIFFERENT_ROOM) ~= 0 then
        spawn_mist_particles()
        obj_mark_for_deletion(o)
    end
    o.oInteractStatus = 0
end

id_bhvRender96MrIParticle = hook_render96_behavior(nil, false, bhv_mr_i_render96_particle_init, bhv_mr_i_render96_particle_loop, OBJ_LIST_GENACTOR, "MrIParticle")

---@param o Object
local function bhv_piranha_plant_render96_init(o)
    o.oSwitchState2 = 10
end

---@param o Object
local function bhv_piranha_plant_render96_loop(o)
    local sBiteFrames = { 12, 28, 50, 64 }
    local frame = o.header.gfx.animInfo.animFrame
    if o.oAction == PIRANHA_PLANT_ACT_BITING then
        local faceState = 0
        for _, biteFrame in ipairs(sBiteFrames) do
            local delta = frame - biteFrame
            if delta >= -9 and delta <= 9 then
                if delta < 0 then
                    faceState = 10 + delta
                elseif delta == 0 then
                    faceState = 10
                else
                    faceState = 10 - delta
                end
                break
            end
        end
        o.oSwitchState2 = faceState
    end

    if o.oAction == PIRANHA_PLANT_ACT_STOPPED_BITING and frame >= 0 and frame <= 10 then
        o.oSwitchState2 = _min(frame, 10)
    end
    if o.oAction == PIRANHA_PLANT_ACT_SLEEPING then
        o.oSwitchState2 = 10
    end
end

id_bhvRender96PiranhaPlant = hook_render96_behavior(id_bhvPiranhaPlant, false, bhv_piranha_plant_render96_init, bhv_piranha_plant_render96_loop)

---@param o Object
local function bhv_pit_bowling_ball(o)
    if wario_charge_hit(o, 200) then
        spawn_sync_object(id_bhvBlueCoinJumping, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
        create_sound_spawner(SOUND_GENERAL2_BOBOMB_EXPLOSION)
        wario_charge_kill_common(o)
    end
end

id_bhvRender96PitBowlingBall = hook_render96_behavior(id_bhvPitBowlingBall, false, nil, bhv_pit_bowling_ball)

---@param o Object
local function bhv_pokey_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

---@param o Object
local function bhv_pokey_render96_loop(o)
    local player = nearest_player_to_object(o)
    local angleToPlayer = obj_angle_to_object(o, player)
    o.oFaceAngleYaw =  angleToPlayer
    if o.oBehParams2ndByte == 0 and o.oPosX < -2000 then obj_set_model_extended(o, E_MODEL_POKEY_HEAD_BOXART) end
    if o.oBehParams2ndByte ~= 0 and o.oPosX < -2000 then obj_set_model_extended(o, E_MODEL_POKEY_BODY_PART_BOXART) end
end

id_bhvRender96PokeyBodyPart = hook_render96_behavior(id_bhvPokeyBodyPart, false, bhv_pokey_render96_init, bhv_pokey_render96_loop, OBJ_LIST_SURFACE)

local COLORS_SCUTTLE = {
    {r = 0x40, g = 0x21, b = 0x3B},
    {r = 0x44, g = 0x35, b = 0x00},
    {r = 0x00, g = 0x00, b = 0x00},
}

---@param o Object
local function bhv_scuttlebug_render96_loop(o)
    r96lib.pulse_cycle(o, COLORS_SCUTTLE, 50)
end

id_bhvRender96Scuttlebug = hook_render96_behavior(id_bhvScuttlebug, false, nil, bhv_scuttlebug_render96_loop, OBJ_LIST_SURFACE)

---@param o Object
local function bhv_six_golden_coin_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oWallHitboxRadius = 30
    o.oGravity = -400
    o.oBounciness = -70
    o.oDragStrength = 1000
    o.oFriction = 1000
    o.oBuoyancy = 200
    o.hitboxHeight = 64
    o.hitboxRadius = 32
    o.oHomeY = o.oPosY
end

---@param o Object
local function bhv_six_golden_coin_loop(o)
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x700
    o.oPosY = o.oHomeY + sins(o.oTimer * 0x600) * 8
    if dist_between_objects(o, m.marioObj) <= 150 then
        r96lib.save_render96_data("wario_coin", o.oBehParams2ndByte)
        gNumWarioCoins = select(2, r96lib.load_render96_data("wario_coin"):gsub("1", ""))
        spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_SPARKLES, o.oPosX, o.oPosY, o.oPosZ, nil)
        audio_stream_play(COLLECTABLE, false, 1)
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
    if r96lib.check_render96_data("wario_coin", o.oBehParams2ndByte) == true then
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
end

id_bhvSixGoldenCoin = hook_render96_behavior(nil, false, bhv_six_golden_coin_init, bhv_six_golden_coin_loop, OBJ_LIST_SURFACE, "SixGoldenCoin")

---@param o Object
local function bhv_snowmans_head_render96_loop(o)
    local model = obj_get_model_id_extended(o)
    if o.oTimer < 2 then
        if model == E_MODEL_SNOWMAN_HEAD then
            o.oFaceAngleYaw = 0x1000
            --o.oMoveAngleYaw = 0x4000
            --o.oFaceAnglePitch = 0x1000
            o.oFaceAngleRoll = 0x4000
        end
    end
end

id_bhvRender96SnowmansHead = hook_render96_behavior(id_bhvSnowmansHead, false, nil, bhv_snowmans_head_render96_loop, OBJ_LIST_DEFAULT)

---@param o Object
local is_star_collected = function(o)
    if o == nil then return nil end
    if gNetworkPlayers[0].currCourseNum == nil then return false end
    local starId = o.oBehParams >> 24
    local currentLevelStarFlags = save_file_get_star_flags(get_current_save_file_num() - 1,
    (gLevelValues.useGlobalStarIds ~= 0 and (starId / 7) - 1 or gNetworkPlayers[0].currCourseNum - 1))
    local starBit = gLevelValues.useGlobalStarIds and (starId % 7) or starId
    if currentLevelStarFlags & (1 << starBit) ~= 0 then
        return true
    end
    return false
end

---@param o Object
local function bhv_star_render96_init(o)
    --if o.oInteractType ~= INTERACT_STAR_OR_KEY then return end
    if is_star_collected(o) == false or obj_has_behavior_id(o, id_bhvCelebrationStar) == 1 then
        spawn_non_sync_object(id_bhvRender96StarParticle, E_MODEL_STAR_PARTICLE, o.oPosX, o.oPosY, o.oPosZ, function(o2)
            o2.parentObj = o
        end)
    elseif is_star_collected(o) == true then
        spawn_non_sync_object(id_bhvRender96StarParticle, E_MODEL_STAR_TRANSPARENT_PARTICLE, o.oPosX, o.oPosY, o.oPosZ, function(o2)
            o2.parentObj = o
        end)
    end
end

---@param o Object
local function bhv_star_render96_loop(o)
    if m.action ~= ACT_CREDITS_CUTSCENE then
        r96lib.audio_fade(o, STAR_AMBIENT, nil, nil, true, 2258, 86840)
    end
end

id_bhvRender96Star = hook_render96_behavior(id_bhvStar, false, bhv_star_render96_init, bhv_star_render96_loop)
id_bhvRender96SpawnedStar = hook_render96_behavior(id_bhvSpawnedStar, false, bhv_star_render96_init, bhv_star_render96_loop)
id_bhvRender96SpawnedStarNoLevelExit = hook_render96_behavior(id_bhvSpawnedStarNoLevelExit, false, bhv_star_render96_init, bhv_star_render96_loop)
--id_bhvRender96HiddenStar = hook_render96_behavior(id_bhvHiddenStar, false, bhv_star_render96_init, bhv_star_render96_loop)
id_bhvRender96SpawnCoordStar = hook_render96_behavior(id_bhvStarSpawnCoordinates, false, bhv_star_render96_init, bhv_star_render96_loop)
id_bhvRender96CelebrationStar = hook_render96_behavior(id_bhvCelebrationStar, false, bhv_star_render96_init)

---@param o Object
local function bhv_star_door_render96_init(o)
    local frame = spawn_non_sync_object(id_bhvRender96StarDoorFrame, E_MODEL_STAR_DOOR_FRAME, o.oPosX, o.oPosY, o.oPosZ, nil)
    obj_set_angle(frame, o.oFaceAnglePitch, o.oFaceAngleYaw, o.oFaceAngleRoll)
end

id_bhvRender96StarDoor = hook_render96_behavior(id_bhvStarDoor, false, bhv_star_door_render96_init, nil, OBJ_LIST_SURFACE)


---@param o Object
local function bhv_star_door_frame_render96_init(o)
    o.activeFlags = o.activeFlags | ACTIVE_FLAG_ACTIVE
end

id_bhvRender96StarDoorFrame = hook_render96_behavior(nil, true, bhv_star_door_frame_render96_init, nil, OBJ_LIST_SURFACE)

---@param o Object
local function bhv_star_particle_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
    o.activeFlags = ACTIVE_FLAG_ACTIVE | ACTIVE_FLAG_INITIATED_TIME_STOP
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oCelebrationStar = 0
    cur_obj_scale(3)
end

---@param o Object
local function find_nearest_star(o)
    local star = o.parentObj
    if star == nil then return nil end
    if obj_has_behavior_id(star, id_bhvCelebrationStar) == 1 then o.oCelebrationStar = 1 else o.oCelebrationStar = 0 end
    return star
end

local function get_star_scale(timer)
    if timer < 10 then return 0 end
    if timer >= 60 then return 3 end
    return (timer - 10) / 50 * 3
end

---@param o Object
local function bhv_star_particle_loop(o)
    smlua_anim_util_set_animation(o, "star_glow")
    local star = find_nearest_star(o)
    if star ~= nil then
        obj_set_pos(o, star.oPosX, star.oPosY, star.oPosZ)
    end
    if obj_is_hidden(o.parentObj) ~= 0 or (obj_has_behavior_id(o.parentObj, id_bhvHiddenStar) ~= 0 and o.oAction == 0) then
        cur_obj_hide()
    else
        cur_obj_unhide()
    end
    if o.oCelebrationStar == 1 then 
        local scale = get_star_scale(o.oTimer)
        cur_obj_scale(scale) 
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
    end
    if o.parentObj.oTimer > 0 and o.parentObj.activeFlags == ACTIVE_FLAG_DEACTIVATED then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96StarParticle = hook_render96_behavior(nil, false, bhv_star_particle_render96_init, bhv_star_particle_loop, OBJ_LIST_LEVEL, "StarParticle")

---@param o Object
local function bhv_thwomp_render96_init(o)
    o.oSwitchState2 = 0
    o.oThwompShakeTicks = 18
    o.oThwompPosMag = 25.0
    o.oThwompAngleMag = 0x120

    o.oThwompPrevAction = o.oAction or 0
    o.oThwompSquishTimer = 0
    o.oThwompSquishDur = 0
    if o.oBehParams == 1 then
        obj_scale(o, 1.75)
    end
    o.oThwompBaseScale = o.header.gfx.scale.x
    o.collisionData = smlua_collision_util_get("thwomp_collision")
    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ
end

---@param o Object
local function bhv_thwomp_render96_shake(o)
    if o == nil then return end

    -- 0 = rising, 1 = waiting (pre-fall), 2 = falling, 3 = landed, 4 = cooldown
    if o.oAction ~= 1 then return end
    if o.oThwompRandomTimer == nil or o.oTimer == nil then return end

    local remaining = o.oThwompRandomTimer - o.oTimer
    if remaining > (o.oThwompShakeTicks + 0.5) or remaining < 0 then
        o.oThwompShakeTimer = 0
        return
    end

    r96lib.shake_apply(o, o.oThwompShakeTimer, o.oThwompShakeTicks, o.oThwompPosMag, o.oThwompPosMag, o.oThwompPosMag)

    o.oThwompShakeTimer = o.oThwompShakeTimer + 1
end

---@param o Object
local function bhv_thwomp_render96_loop(o)
    bhv_thwomp_render96_shake(o)
    if o.oAction == 0 then o.oSwitchState2 = 0 end
    if o.oAction == 2 then o.oSwitchState2 = 2 end
    if o.oAction == 3 then o.oSwitchState2 = 1 
        o.oPosX = o.oHomeX
        o.oPosY = o.oHomeY
        o.oPosZ = o.oHomeZ
    end

   local remaining = o.oThwompRandomTimer - o.oTimer
    if remaining > (o.oThwompShakeTicks + 0.5) or remaining < 0 then
         if o.oAction == 1 then o.oSwitchState2 = 0 end
    else
        if o.oAction == 1 then o.oSwitchState2 = 1 end
    end
    
    squish_on_action_enter(o, 3, 0.15, -0.20, 0.15)

    if wario_charge_hit(o, 350) then
        cur_obj_play_sound_2(SOUND_OBJ_THWOMP)
        spawn_sync_object(id_bhvBlueCoinJumping, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
        create_sound_spawner(SOUND_OBJ_STOMPED)
        wario_charge_kill_common(o)
    end
end

id_bhvRender96Thwomp = hook_render96_behavior(id_bhvThwomp, false, bhv_thwomp_render96_init, bhv_thwomp_render96_loop)
id_bhvRender96Thwomp2 = hook_render96_behavior(id_bhvThwomp2, false, bhv_thwomp_render96_init, bhv_thwomp_render96_loop)

---@param o Object
local function bhv_toad_render96_loop(o)
    local dialogId = (o.oBehParams >> 24) & 0xFF

    if dialogId == 133 then     -- castle inside first toad
        o.oSwitchState2 = 0     -- vest
        o.oSwitchState1 = 0     -- hat
    elseif dialogId == 135 then -- WF room
        o.oSwitchState2 = 3
        o.oSwitchState1 = 0
    elseif dialogId == 134 then -- JRB room
        o.oSwitchState2 = 2
        o.oSwitchState1 = 3
    elseif dialogId == 137 then -- castle inside second floor next to bobomb painting
        o.oSwitchState2 = 0
        o.oSwitchState1 = 1
    elseif dialogId == 83 then -- castle inside third floor star
        o.oSwitchState2 = 4
        o.oSwitchState1 = 4
    elseif dialogId == 76 then -- castle inside second floor star
        o.oSwitchState2 = 4
        o.oSwitchState1 = 4
    elseif dialogId == 136 then -- basement green wall toad
        o.oSwitchState2 = 1
        o.oSwitchState1 = 2
    elseif dialogId == 82 then -- basement star
        o.oSwitchState2 = 4
        o.oSwitchState1 = 4
    end
end

id_bhvRender96ToadMessage = hook_render96_behavior(id_bhvToadMessage, false, nil, bhv_toad_render96_loop)

---@param o Object
local function bhv_tower_door_render96_loop(o)
    if (m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 200) then
        obj_explode_and_spawn_coins(80.0, 0)
        create_sound_spawner(SOUND_GENERAL_WALL_EXPLOSION)
    end
end

id_bhvRender96TowerDoor = hook_render96_behavior(id_bhvTowerDoor, false, nil, bhv_tower_door_render96_loop)

---@param o Object
local function bhv_tree_render96_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.hitboxHeight = 500
    o.hitboxRadius = 80
    o.oInteractType = INTERACT_POLE
    o.oIntangibleTimer = 0
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_CYLBOARD
end

---@param o Object
local function bhv_tree_render96_loop(o)
    bhv_pole_base_loop()
    local model = obj_get_model_id_extended(o)
    if o.oTimer < 2 then
        if model ~= E_MODEL_COURTYARD_SPIKY_TREE or E_MODEL_PALM_TREE then
            o.oFaceAngleYaw = _random(0, 10) * 0x10000/10
        end
    end
end

id_bhvRender96Tree = hook_render96_behavior(id_bhvTree, true, bhv_tree_render96_init, bhv_tree_render96_loop, OBJ_LIST_POLELIKE)

---@param o Object
local function bhv_tuxie_mother_render96_loop(o)
    local player = nearest_player_to_object(o)
    local distanceToPlayer = dist_between_objects(o, player)
    local smallPenguin = obj_get_nearest_object_with_behavior_id(o, id_bhvUnused20E0)
    if smallPenguin ~= nil and smallPenguin.oPosY < -4850 then 
        o.oAction = 4 
        obj_mark_for_deletion(smallPenguin)
        end
    if o.oAction == 4 then
        o.oForwardVel = 30.0
        cur_obj_rotate_yaw_toward(o.oAngleToMario, 0x1000)
        cur_obj_init_animation_with_accel_and_sound(0, 3)
        if distanceToPlayer < 300 then
            hurt_and_set_mario_action(m, ACT_QUICKSAND_DEATH, 0, 16)
            o.oAction = 2 
        end
        --if m.health == 255 then 
        --    o.oAction = 2 
        --end
    end
    if o.oPosY < -4850 then
        o.oPosX = 3450
        o.oPosY = -4700
        o.oPosZ = 4550
    end

    o.oSwitchTimer1 = o.oSwitchTimer1 + 1
    local timer = o.oSwitchTimer1 % 50
    o.oSwitchState1 = 0

    if timer < 43 then
        o.oSwitchState1 = 0
    elseif timer < 45 then
        o.oSwitchState1 = 1
    elseif timer < 47 then
        o.oSwitchState1 = 2
    else
        o.oSwitchState1 = 1
    end
    -- Angry eyes if chasing Mario
    if o.oForwardVel > 5.0 then
        o.oSwitchState1 = 3
    end

end

id_bhvRender96TuxiesMother = hook_render96_behavior(id_bhvTuxiesMother, false, nil, bhv_tuxie_mother_render96_loop, OBJ_LIST_SURFACE)

local function magnetize_to_mario(o)
    local targetX = m.pos.x + m.vel.x
    local targetY = m.pos.y + 10
    local targetZ = m.pos.z + m.vel.z
    o.oPosX = _lerp(o.oPosX, targetX, 0.2)
    o.oPosY = _lerp(o.oPosY, targetY, 0.2)
    o.oPosZ = _lerp(o.oPosZ, targetZ, 0.2)
    obj_turn_toward_object(o, m.marioObj, 16, 0x2000)
    o.oForwardVel = 60
end

---@param o Object
local function bhv_wario_coin_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    --o.oInteractType = INTERACT_COIN
    o.oDamageOrCoinValue = 0
    o.hitboxHeight = 72
    o.hitboxRadius = 50
    o.oVelY = 30
    cur_obj_scale(0.8)
    create_sound_spawner(SOUND_GENERAL_COIN_DROP)
end

---@param o Object
local function bhv_wario_coin_loop(o)
    cur_obj_update_floor_and_walls()
    cur_obj_move_standard(-78)
    o.oGravity = -2.5
    o.oFriction = 0.99
    o.oBuoyancy = 1.4
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1000
    o.oForwardVel = 30
    if o.oVelY < 0 or (o.oMoveFlags & OBJ_MOVE_MASK_ON_GROUND) ~= 0 or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0 or (o.oMoveFlags & OBJ_MOVE_HIT_EDGE) ~= 0 or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0 then magnetize_to_mario(o) end

    if dist_between_objects(o, m.marioObj) <= 50 then
        set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)
        create_sound_spawner(SOUND_GENERAL_COIN)
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
    if (o.oMoveFlags & OBJ_MOVE_ABOVE_LAVA) ~= 0 then
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        obj_mark_for_deletion(o)
        return
    end
end

id_bhvWarioCoins = hook_render96_behavior(nil, false, bhv_wario_coin_init, bhv_wario_coin_loop, OBJ_LIST_SURFACE, "WarioCoins")

---@param o Object
local function bhv_wario_head_init(o)
    -- set flags
    o.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)

    -- drop to floor
    local x = o.oPosX
    local y = o.oPosY
    local z = o.oPosZ

    --local floor = find_floor_height(x, y + 200.0, z)
    --o.oPosY = floor
    o.oMoveFlags = o.oMoveFlags | OBJ_MOVE_ON_GROUND

    -- home
    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ

    -- physics
    o.oGravity          = -4.0
    o.oBounciness       = -0.5
    o.oDragStrength     = 10.0
    o.oFriction         = 10.0
    o.oBuoyancy         =  0.0

-- hitbox
    o.oInteractType = INTERACT_SHOCK
    o.oHealth = 0
    o.oNumLootCoins = 1
    o.oIntangibleTimer = 0
    o.hitboxRadius = 0
    o.hitboxHeight = 0
    o.hurtboxRadius = 50
    o.hurtboxHeight = 60
    o.oDamageOrCoinValue = 4
    --o.hitboxDownOffset = o.header.gfx.scale.y * 0
    o.oWarioHeadBool = 0
    o.oAction = -1
end

    --5235, -1074,  1995
    --604, -1074, 1995
local WARIO_HEAD_FUN = audio_stream_load('event_wario_head_fun.mp3')
local WARIO_HEAD_BITE = audio_stream_load('event_wario_head_yell.mp3')
local WARIO_HEAD_LAUGH = audio_stream_load('event_wario_head_yell.mp3')
local WARIO_HEAD_YELL = audio_stream_load('event_wario_head_yell.mp3')
local WARIO_GREETING = 0
local WARIO_BITE = 1
local WARIO_LOL = 2
local WARIO_DEATH = 3
local sAudioStream = nil
--audio_stream_set_loop_points(sAudioStream, 0, 333353)
--audio_stream_set_looping(sAudioStream, true)
        
---@param o Object
local function bhv_wario_head_loop(o)
    local player = nearest_player_to_object(o)
    local distanceToPlayer = dist_between_objects(o, player)
    local angleToPlayer = obj_angle_to_object(o, player)

    if o.oWarioHeadBool == 0 then
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
        
    end
    if o.oAction == -1 and o.oWarioHeadBool == 1 then
        o.oPosY = -800
        audio_stream_play(WARIO_HEAD_FUN, false, 2)
        o.oAction = WARIO_BITE
    end
    if m.pos.x >= 2000 then
        cur_obj_become_tangible()
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        o.oWarioHeadBool = 1
    end
    if m.pos.x >= 604 then
        local dx = player.header.gfx.pos.x - o.oPosX
        local dy = (player.header.gfx.pos.y + 50.0) - o.oPosY
        local dz = player.header.gfx.pos.z - o.oPosZ

        local targetPitch = atan2s(_sqrt((dx * dx) + (dz * dz)), dy)

        obj_turn_toward_object(o, player, 16, 0x1000)
        o.oMoveAnglePitch = approach_s16_symmetric(o.oMoveAnglePitch, targetPitch, 0x1000)
        o.oVelY = sins(o.oMoveAnglePitch) * 2.0
        o.oForwardVel = coss(o.oMoveAnglePitch) * 30.0
        o.oFaceAngleYaw =  angleToPlayer + 0x8000
        cur_obj_move_standard(-78)
        cur_obj_update_floor_and_walls()
    end

    if  o.oWarioHeadBool == 1 and m.pos.x < 604 then
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        audio_stream_play(WARIO_HEAD_YELL, false, 2)
        obj_mark_for_deletion(o)
    end
   o.oInteractStatus = 0
end

id_bhvWarioHead = hook_render96_behavior(nil, false, bhv_wario_head_init, bhv_wario_head_loop, OBJ_LIST_SURFACE, "WarioHead")

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
    r96lib.audio_fade(o, BOO_PIPE_RED, 650, 1800, true)
end

id_bhvRender96WarpPipeRed = hook_render96_behavior(nil, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_red_loop, OBJ_LIST_SURFACE, "WarpPipeRed")

---@param o Object
local function bhv_warp_pipe_render96_green_loop(o)
    load_object_collision_model()
    bhv_warp_loop()
    o.oSwitchState1 = 2
    r96lib.audio_fade(o, BOO_PIPE_GREEN, 650, 1800, true)
end

id_bhvRender96WarpPipeGreenUnlock = hook_render96_behavior(nil, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_green_loop, OBJ_LIST_SURFACE, "WarpPipeGreenUnlock")
id_bhvRender96WarpPipeGreenLock = hook_render96_behavior(nil, false, bhv_warp_pipe_locked_render96_init, bhv_warp_pipe_render96_green_loop, OBJ_LIST_SURFACE, "WarpPipeGreenLock")

---@param o Object
local function bhv_warp_pipe_render96_yellow_loop(o)
    load_object_collision_model()
    bhv_warp_loop()
    o.oSwitchState1 = 3
    r96lib.audio_fade(o, BOO_PIPE_YELLOW, 650, 1800, true)
end

id_bhvRender96WarpPipeYellowUnlock = hook_render96_behavior(nil, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_yellow_loop, OBJ_LIST_SURFACE, "WarpPipeYellowUnlock")
id_bhvRender96WarpPipeYellowLock = hook_render96_behavior(nil, false, bhv_warp_pipe_locked_render96_init, bhv_warp_pipe_render96_yellow_loop, OBJ_LIST_SURFACE, "WarpPipeYellowLock")

---@param o Object
local function bhv_whomp_render96_loop(o)
    squish_on_action_enter(o, 5, 0.10, 0.10, -0.2)
    if wario_charge_hit(o, 200) then
        cur_obj_play_sound_2(SOUND_OBJ_THWOMP)
        o.oNumLootCoins = 5
        obj_spawn_loot_yellow_coins(o, 5, 20.0)
        create_sound_spawner(SOUND_OBJ_STOMPED)
        wario_charge_kill_common(o)
    end
end

---@param o Object
local function bhv_whomp_render96_init(o)
    o.oThwompPrevAction = o.oAction or 0
    o.oThwompSquishTimer = 0
    o.oThwompSquishDur = 0
    o.oThwompBaseScale = o.header.gfx.scale.x
end

---@param o Object
local function bhv_whomp_king_render96_loop(o)
    squish_on_action_enter(o, 5, 0.15, 0.15, -0.3)  -- bugfix: now correctly resets on re-entry

    if o.oHealth == 3 then o.oSwitchState1 = 0 end
    if o.oHealth == 2 then o.oSwitchState1 = 1 end
    if o.oHealth == 1 then o.oSwitchState1 = 2 end
    o.oThwompPrevAction = o.oAction
end

id_bhvRender96SmallWhomp = hook_render96_behavior(id_bhvSmallWhomp, false, bhv_whomp_render96_init, bhv_whomp_render96_loop)
id_bhvRender96WhompKingBoss = hook_render96_behavior(id_bhvWhompKingBoss, false, bhv_whomp_render96_init, bhv_whomp_king_render96_loop)

---@param o Object
local function bhv_wiggler_head_render96_loop(o)
    if o.oHealth == 4 then o.oSwitchState1 = 0 end
    if m.pos.y >= 1650 and o.oHealth == 4 then o.oSwitchState1 = 1 end
    if o.oHealth == 4 and o.oAction == WIGGLER_ACT_JUMPED_ON then o.oSwitchState1 = 2 end
    if o.oHealth == 3 and o.oAction == WIGGLER_ACT_JUMPED_ON then o.oSwitchState1 = 3 end
    if o.oHealth == 2 and o.oAction == WIGGLER_ACT_JUMPED_ON then o.oSwitchState1 = 4 end
    if o.oHealth == 1 then o.oSwitchState1 = 4 end
end

id_bhvRender96WigglerHead = hook_render96_behavior(id_bhvWigglerHead, false, nil, bhv_wiggler_head_render96_loop, OBJ_LIST_GENACTOR)

---@param o Object
local function bhv_wooden_post_render96_loop(o)
    if get_character(m).type == CT_WARIO then
        o.oWoodenPostSpeedY = -210
    end
end

id_bhvRender96WoodenPost = hook_render96_behavior(id_bhvWoodenPost, false, nil, bhv_wooden_post_render96_loop, OBJ_LIST_SURFACE)

---@param o Object
local function bhv_unagi_render96_init(o)
    o.header.gfx.skipInViewCheck = true
end

id_bhvRender96Unagi = hook_render96_behavior(id_bhvUnagi, false, bhv_unagi_render96_init, nil, OBJ_LIST_GENACTOR)

local YOSHI_RIDING_ACTIONS = {
    [ACT_YOSHI_RIDE_IDLE]    = true,
    [ACT_YOSHI_RIDE_WALK]    = true,
    [ACT_YOSHI_RIDE_JUMP]    = true,
    [ACT_YOSHI_RIDE_FLUTTER] = true,
    [ACT_YOSHI_RIDE_FALL]    = true,
}

---@param o Object
local function bhv_yoshi_rideable_render96_init(o)
    cur_obj_init_animation(0)
    o.oFlags = OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oGravity = -3
    o.oFriction = 1
    o.activeFlags = o.activeFlags | ACTIVE_FLAG_UNK9
    o.oAnimations = gObjectAnimations.yoshi_seg5_anims_05024100
    o.oHealth = 1
    o.oIntangibleTimer = 0
    o.oYoshiBlinkTimer = 0
    o.oYoshiIdleTimer = 0
    o.hitboxRadius = 50
    o.hitboxHeight = 40
end

---@param o Object
local function yoshi_update_blink(o)
    if o.oYoshiBlinkTimer ~= 0 then
        o.oYoshiBlinkTimer = o.oYoshiBlinkTimer - 1
    else
        o.oYoshiBlinkTimer = random_linear_offset(30, 60)
    end
    o.oAnimState = (o.oYoshiBlinkTimer <= 4) and 1 or 0
end

---@param o Object
local function bhv_yoshi_unridden(o)
    local player = nearest_mario_state_to_object(o)
    local dist = dist_between_objects(o, player.marioObj)

    o.oYoshiIdleTimer = o.oYoshiIdleTimer + 1
    r96lib.yoshiRun(o)
    if dist < 100 then r96lib.push_mario_out_of_object(player, o, 2) end

    if o.oYoshiIdleTimer >= 600 then
        spawn_mist_particles_with_sound(SOUND_OBJ_DYING_ENEMY1)
        obj_mark_for_deletion(o)
    end

    o.oInteractStatus = 0
    -- Mount check
    if not YOSHI_RIDING_ACTIONS[player.action] then
        local airborne = (player.action & ACT_FLAG_AIR) ~= 0
            and (player.action & ACT_FLAG_SWIMMING_OR_FLYING) == 0
            and player.vel.y <= 0
            and dist < 85
        if airborne then
            player.pos.x = o.oPosX
            player.pos.z = o.oPosZ
            player.faceAngle.y = o.oMoveAngleYaw
            cur_obj_play_sound_2(SOUND_GENERAL_YOSHI_TALK)
            player.interactObj = o
            player.usedObj = o
            player.riddenObj = o
            o.oAction = 1
            o.heldByPlayerIndex = player.playerIndex
            set_mario_action(player, ACT_YOSHI_RIDE_FALL, 0)
        end
    end
end

---@param o Object
local function bhv_yoshi_rideable_render96_loop(o)
    yoshi_update_blink(o)

    if o.oAction == 0 then
        cur_obj_init_animation(0)
        o.oForwardVel = 0
        return bhv_yoshi_unridden(o)
    elseif o.oAction == 2 then
        cur_obj_init_animation_with_accel_and_sound(1, 3)
        cur_obj_play_sound_at_anim_range(0, 15, SOUND_GENERAL_YOSHI_WALK)
        o.oForwardVel = 30
        return bhv_yoshi_unridden(o)
    elseif o.oAction == 1 then
        -- Ridden
        local rider = gMarioStates[o.heldByPlayerIndex]
        local animInfo = o.header.gfx.animInfo
        o.oYoshiIdleTimer = 0
        obj_copy_pos(o, rider.marioObj)
        --rider.marioObj.header.gfx.pos.y = rider.marioObj.header.gfx.pos.y - 30
        o.oMoveAngleYaw = rider.faceAngle.y
        o.oFaceAnglePitch = 0
        o.oFaceAngleRoll = 0

        local action = rider.action
        if action == ACT_YOSHI_RIDE_IDLE then
            smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_IDLE)
        elseif action == ACT_YOSHI_RIDE_WALK then
            --cur_obj_init_animation_with_accel_and_sound(1, _abs(rider.forwardVel) / 14)
            --if cur_obj_check_anim_frame(3) then
            --    play_sound(SOUND_GENERAL_YOSHI_WALK, m.marioObj.header.gfx.cameraToObject)
            --end
            --play_step_sound(m, 1, 2);
            smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_RUN)
            cur_obj_play_sound_at_anim_range(3, 9, SOUND_GENERAL_YOSHI_WALK)
        elseif action == ACT_YOSHI_RIDE_JUMP then
            if rider.vel.y >= -21 then
                smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_JUMP)
                if o.header.gfx.animInfo.animFrame >= 4 then
                    o.header.gfx.animInfo.animFrame = 4
                end
            else
                smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_JUMP_FALL)
            end
        elseif action == ACT_YOSHI_RIDE_FALL then
            smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_JUMP_FALL)
        elseif action == ACT_YOSHI_RIDE_FLUTTER then
            smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_FLUTTER)
        else
            mario_stop_riding_object(rider)
        end

        if (o.oInteractStatus & INT_STATUS_STOP_RIDING) ~= 0 then
            o.heldByPlayerIndex = 0
            if rider.hurtCounter ~= 0 then
                cur_obj_play_sound_2(SOUND_GENERAL_YOSHI_TALK)
                o.oAction = 2
            else
                o.oAction = 0
            end
            o.oInteractStatus = 0
        end
        return
    end
end

id_bhvRender96YoshiRideable = hook_render96_behavior(nil, true, bhv_yoshi_rideable_render96_init, bhv_yoshi_rideable_render96_loop, OBJ_LIST_PUSHABLE)

---@param o Object
local function bhv_yoshi_tongue(o)
    if m == nil or m.marioObj == nil then
        obj_mark_for_deletion(o)
        return
    end

    -- Target died mid-flight: freeze the lock point where the tip currently is, retract from there.
    if o.parentObj ~= nil and (o.parentObj.activeFlags & ACTIVE_FLAG_DEACTIVATED) ~= 0 then
        o.oTongueLockX, o.oTongueLockY, o.oTongueLockZ = o.parentObj.oPosX, o.parentObj.oPosY, o.parentObj.oPosZ
        o.parentObj = nil
        o.oAction = TONGUE_STATE_RETRACTING
    end

    -- Base tracks the mouth every frame so the tongue follows Mario/Yoshi's head while out.
    local baseX = m.marioObj.oPosX + 20.0 * sins(m.faceAngle.y)
    local baseY = m.marioObj.oPosY + 60.0
    local baseZ = m.marioObj.oPosZ + 20.0 * coss(m.faceAngle.y)

    local targetX, targetY, targetZ
    if o.parentObj ~= nil then
        targetX, targetY, targetZ = o.parentObj.oPosX, o.parentObj.oPosY, o.parentObj.oPosZ
    else
        targetX, targetY, targetZ = o.oTongueLockX, o.oTongueLockY, o.oTongueLockZ
    end

    local dx, dy, dz = targetX-baseX, targetY-baseY, targetZ-baseZ
    local distance = _max(_sqrt(dx*dx + dy*dy + dz*dz), 0.001)

    if o.oAction == TONGUE_STATE_EXTENDING then
        o.oTongueU = _min(o.oTongueU + (1.0 / TONGUE_EXTEND_FRAMES), 1.0)

        if o.oTongueU >= 1.0 then
            if o.parentObj ~= nil then
                o.oAction = TONGUE_STATE_LATCHED
                o.oTongueTimer = 0
                queue_rumble_data_mario(m, 4, 40)
                play_sound(SOUND_GENERAL_BOING1, m.marioObj.header.gfx.cameraToObject)
                -- hook your grab/damage effect on o.parentObj here
            else
                o.oAction = TONGUE_STATE_RETRACTING -- missed
            end
        end

    elseif o.oAction == TONGUE_STATE_LATCHED then
        o.oTongueTimer = o.oTongueTimer + 1
        if o.oTongueTimer >= TONGUE_LATCH_HOLD then
            o.oAction = TONGUE_STATE_RETRACTING
        end

    else -- RETRACTING
        o.oTongueU = o.oTongueU - (1.0 / TONGUE_RETRACT_FRAMES)
        if o.oTongueU <= 0.0 then
            obj_mark_for_deletion(o)
            return
        end
    end

    local currentLength = o.oTongueU * distance

    o.oPosX, o.oPosY, o.oPosZ = baseX, baseY, baseZ
    o.oFaceAngleYaw = atan2s(dz, dx)
    o.oFaceAnglePitch = atan2s(_sqrt(dx*dx + dz*dz), dy) -- flip sign if it looks inverted

    o.header.gfx.scale.x = 1.0
    o.header.gfx.scale.y = 1.0
    o.header.gfx.scale.z = _max(currentLength, 0.001) / TONGUE_MODEL_LENGTH
end

id_bhvRender96YoshiTongue = hook_render96_behavior(nil, false, nil, bhv_yoshi_tongue, OBJ_LIST_SURFACE)

