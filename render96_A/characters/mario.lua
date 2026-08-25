require("/constants")

-----------
-- Hooks --
-----------

---@param m MarioState
local function open_hands_during_jumbo_star_flying(m)
    if m.action == ACT_JUMBO_STAR_CUTSCENE and m.actionArg == 2 then -- JUMBO_STAR_CUTSCENE_FLYING
        m.marioBodyState.handState = MARIO_HAND_OPEN
    end
end

local function restore_vanilla_gameover()

    -- Restrict game over screen to single player
    if network_player_connected_count() <= 1 then
        if gNetworkPlayers[0].currActNum == 99 then -- in credits
            gLevelValues.entryLevel = SPECIAL_WARP_TITLE
        elseif gNetworkPlayers[0].currLevelNum == LEVEL_CASTLE_GROUNDS then
            gLevelValues.entryLevel = SPECIAL_WARP_GODDARD_GAMEOVER
        end
    else
        gLevelValues.entryLevel = LEVEL_CASTLE_GROUNDS
    end
end

hook_event(HOOK_MARIO_UPDATE, open_hands_during_jumbo_star_flying)
hook_event(HOOK_UPDATE, restore_vanilla_gameover)

-------------------
-- Geo functions --
-------------------

-- Mario face --

local R96_MARIO_FACE_DEFAULT = 0
local R96_MARIO_FACE_HAPPY   = 3
local R96_MARIO_FACE_ANGRY   = 4
local R96_MARIO_FACE_OPEN    = 5

local R96_MARIO_LIP_CLOSED = 0
local R96_MARIO_LIP_A      = 3
local R96_MARIO_LIP_E      = 6
local R96_MARIO_LIP_O      = 5

local R96_MARIO_FACE_DEFAULT_IDLE_ACTIONS = T{
    ACT_IDLE,
    ACT_HOLD_IDLE,
    ACT_HOLD_HEAVY_IDLE,
    ACT_CRAWLING,
    ACT_WALKING,
    ACT_HOLD_WALKING,
    ACT_HOLD_HEAVY_WALKING,
    ACT_LONG_JUMP_LAND,
    ACT_JUMP_LAND,
    ACT_JUMP_LAND_STOP,
    ACT_DOUBLE_JUMP_LAND,
    ACT_DOUBLE_JUMP_LAND_STOP,
}

local R96_MARIO_FACE_DEFAULT_OTHER_ACTIONS = T{
    ACT_DOUBLE_JUMP,
    ACT_TRIPLE_JUMP,
    ACT_DEATH_EXIT,
    ACT_DEATH_EXIT_LAND,
    ACT_DEATH_ON_STOMACH,
    ACT_DEATH_ON_BACK,
    ACT_QUICKSAND_DEATH,
    ACT_ELECTROCUTION,
    ACT_SUFFOCATION,
    ACT_START_SLEEPING,
}

local R96_MARIO_FACE_HAPPY_ACTIONS = T{
    ACT_JUMP,
    ACT_TRIPLE_JUMP_LAND,
    ACT_TRIPLE_JUMP_LAND_STOP,
    ACT_BACKFLIP_LAND,
    ACT_BACKFLIP_LAND_STOP,
}

local R96_MARIO_FACE_OPEN_ACTIONS = T{
    ACT_BURNING_GROUND,
    ACT_BURNING_JUMP,
    ACT_BURNING_FALL,
    ACT_LAVA_BOOST,
    ACT_LAVA_BOOST_LAND,
}

local R96_MARIO_LIP_ENDING_STATES = {
    [8] = { -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        [76] = R96_MARIO_LIP_O,
    },
    [9] = { -- END_PEACH_CUTSCENE_STAR_DANCE
        [0]   = R96_MARIO_LIP_CLOSED,
        [100] = R96_MARIO_LIP_E,
        [104] = R96_MARIO_LIP_A,
        [106] = R96_MARIO_LIP_O,
        [108] = R96_MARIO_LIP_E,
        [112] = R96_MARIO_LIP_A,
        [115] = R96_MARIO_LIP_O,
        [140] = R96_MARIO_LIP_CLOSED,
    },
}

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_mario_face(node, matStackIndex)
    local switchCase = cast_graph_node(node) ---@type GraphNodeSwitchCase
    local m = geo_get_mario_state()
    local marioObject = m.marioObj
    local marioAction = m.action

    -- Ending
    if geo_switch_end_peach_cutscene(node, matStackIndex, m, R96_MARIO_LIP_ENDING_STATES) then
        return
    end

    -- Hurt
    if m.hurtCounter > 0 then
        switchCase.selectedCase = R96_MARIO_FACE_ANGRY
        return
    end

    -- Dead
    if m.health <= 0xFF then
        switchCase.selectedCase = R96_MARIO_FACE_ANGRY
        return
    end

    -- Yawning
    if marioAction == ACT_START_SLEEPING and m.actionState >= 2 then
        switchCase.selectedCase = R96_MARIO_FACE_OPEN
        return
    end

    -- Sleeping
    if marioAction == ACT_SLEEPING then
        switchCase.selectedCase = R96_MARIO_FACE_OPEN
        return
    end

    -- Panting
    if marioAction == ACT_PANTING then
        switchCase.selectedCase = R96_MARIO_FACE_OPEN
        return
    end

    -- Long jump
    if marioAction == ACT_LONG_JUMP then
        marioObject.oMarioLongJumpTimer = marioObject.oMarioLongJumpTimer + 1
        switchCase.selectedCase = (marioObject.oMarioLongJumpTimer < 15)
            and R96_MARIO_FACE_HAPPY
            or R96_MARIO_FACE_OPEN
        return
    end

    -- Idle
    if R96_MARIO_FACE_DEFAULT_IDLE_ACTIONS[marioAction] then
        marioObject.oMarioLongJumpTimer = 0
        switchCase.selectedCase = R96_MARIO_FACE_DEFAULT
        return
    end

    -- Other actions that doesn't reset the long jump timer
    if R96_MARIO_FACE_DEFAULT_OTHER_ACTIONS[marioAction] then
        switchCase.selectedCase = R96_MARIO_FACE_DEFAULT
        return
    end

    -- Happy face
    if R96_MARIO_FACE_HAPPY_ACTIONS[marioAction] then
        switchCase.selectedCase = R96_MARIO_FACE_HAPPY
        return
    end

    -- Open mouth
    if R96_MARIO_FACE_OPEN_ACTIONS[marioAction] then
        switchCase.selectedCase = R96_MARIO_FACE_OPEN
        return
    end

    -- Attack
    if (marioAction & ACT_FLAG_ATTACKING) ~= 0 then
        switchCase.selectedCase = R96_MARIO_FACE_ANGRY
        return
    end

    -- Swim
    if (marioAction & ACT_FLAG_SWIMMING) ~= 0 then
        switchCase.selectedCase = R96_MARIO_FACE_DEFAULT
        return
    end

    -- Default
    switchCase.selectedCase = R96_MARIO_FACE_DEFAULT
end

-- Mario eyes --

local R96_MARIO_EYES_OPEN        = 0
local R96_MARIO_EYES_HALF_CLOSED = 1
local R96_MARIO_EYES_CLOSED      = 2
local R96_MARIO_EYES_HALF_OPEN   = 3
local R96_MARIO_EYES_ANGRY       = 4
local R96_MARIO_EYES_HAPPY       = 5
local R96_MARIO_EYES_EXHAUSTED   = 6
local R96_MARIO_EYES_DEAD        = 7
local R96_MARIO_EYES_HURT        = 8

local R96_MARIO_EYES_BLINK_ACTIONS = T{
    ACT_IDLE,
    ACT_HOLD_IDLE,
    ACT_HOLD_HEAVY_IDLE,
    ACT_JUMP_LAND,
    ACT_JUMP_LAND_STOP,
    ACT_DOUBLE_JUMP_LAND,
    ACT_DOUBLE_JUMP_LAND_STOP,
    ACT_END_PEACH_CUTSCENE,
    ACT_END_WAVING_CUTSCENE,
}

local R96_MARIO_EYES_OPEN_WALKING_ACTIONS = T{
    ACT_WALKING,
    ACT_HOLD_WALKING,
    ACT_HOLD_HEAVY_WALKING,
}

local R96_MARIO_EYES_HAPPY_ACTIONS = T{
    ACT_JUMP,
    ACT_DOUBLE_JUMP,
    ACT_TRIPLE_JUMP,
    ACT_TRIPLE_JUMP_LAND,
    ACT_TRIPLE_JUMP_LAND_STOP,
    ACT_BACKFLIP_LAND,
    ACT_BACKFLIP_LAND_STOP,
}

local R96_MARIO_EYES_DEAD_ACTIONS = T{
    ACT_BURNING_GROUND,
    ACT_BURNING_JUMP,
    ACT_BURNING_FALL,
    ACT_LAVA_BOOST,
    ACT_LAVA_BOOST_LAND,
    ACT_DEATH_EXIT,
    ACT_DEATH_EXIT_LAND,
    ACT_DEATH_ON_STOMACH,
    ACT_DEATH_ON_BACK,
    ACT_QUICKSAND_DEATH,
    ACT_ELECTROCUTION,
    ACT_SUFFOCATION,
}

local R96_MARIO_EYES_BLINK_STATES = { 1, 2, 1, 0, 0, 0, 1, 2, 1 }

-- blink twice then have half-shut eyes (see end_peach_cutscene_kiss_from_peach)
local R96_MARIO_EYES_BLINK_ENDING_STATES = {
    [8] = { -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        [75]  = R96_MARIO_EYES_HALF_CLOSED,
        [76]  = R96_MARIO_EYES_CLOSED,
        [90]  = R96_MARIO_EYES_HALF_CLOSED,
        [92]  = R96_MARIO_EYES_CLOSED,
        [94]  = R96_MARIO_EYES_HALF_CLOSED,
        [96]  = R96_MARIO_EYES_OPEN,
        [98]  = R96_MARIO_EYES_HALF_CLOSED,
        [100] = R96_MARIO_EYES_CLOSED,
        [102] = R96_MARIO_EYES_HALF_CLOSED,
        [104] = R96_MARIO_EYES_OPEN,
        [106] = R96_MARIO_EYES_HALF_CLOSED,
        [108] = R96_MARIO_EYES_CLOSED,
        [110] = R96_MARIO_EYES_HALF_CLOSED,
    },
    [9] = { -- END_PEACH_CUTSCENE_STAR_DANCE
        [0]  = R96_MARIO_EYES_HALF_CLOSED,
        [58] = R96_MARIO_EYES_OPEN,
    },
}

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_mario_eye_custom(node, matStackIndex)
    local switchCase = cast_graph_node(node) ---@type GraphNodeSwitchCase
    local m = geo_get_mario_state()
    local marioObject = m.marioObj
    local marioAction = m.action

    -- Ending
    if geo_switch_end_peach_cutscene(node, matStackIndex, m, R96_MARIO_EYES_BLINK_ENDING_STATES) then
        return
    end

    -- Hurt
    if m.hurtCounter > 0 then
        switchCase.selectedCase = R96_MARIO_EYES_HURT
        return
    end

    -- Dead
    if R96_MARIO_EYES_DEAD_ACTIONS[marioAction] then
        switchCase.selectedCase = R96_MARIO_EYES_DEAD
        return
    end
    if m.health <= 0xFF then
        switchCase.selectedCase = R96_MARIO_EYES_HURT
        return
    end

    -- Panting
    if marioAction == ACT_PANTING then
        switchCase.selectedCase = R96_MARIO_EYES_EXHAUSTED
        return
    end

    -- Yawning
    if marioAction == ACT_START_SLEEPING and m.actionState >= 2 then
        switchCase.selectedCase = R96_MARIO_EYES_HALF_CLOSED
        return
    end

    -- Sleeping
    if marioAction == ACT_SLEEPING then
        switchCase.selectedCase = R96_MARIO_EYES_CLOSED
        return
    end

    -- Crawling
    if marioAction == ACT_CRAWLING then
        switchCase.selectedCase = R96_MARIO_EYES_HALF_OPEN
        return
    end

    -- Walking
    if R96_MARIO_EYES_OPEN_WALKING_ACTIONS[marioAction] then
        switchCase.selectedCase = R96_MARIO_EYES_OPEN
        return
    end

    -- Happy
    if R96_MARIO_EYES_HAPPY_ACTIONS[marioAction] then
        switchCase.selectedCase = R96_MARIO_EYES_HAPPY
        return
    end

    -- Attack
    if marioAction & ACT_FLAG_ATTACKING ~= 0 then
        switchCase.selectedCase = R96_MARIO_EYES_ANGRY
        return
    end

    -- Blinking
    if R96_MARIO_EYES_BLINK_ACTIONS[marioAction] then
        local blinkFrame = (marioObject.oTimer >> 1) & 0x1F
        switchCase.selectedCase = R96_MARIO_EYES_BLINK_STATES[1 + blinkFrame] or 0
        return
    end

    -- Not blinking
    switchCase.selectedCase = R96_MARIO_EYES_OPEN
end
