local bloWarps = require("/lib/warps")

local function pipe_entry(m, o)
    play_sound(SOUND_MENU_ENTER_PIPE, gGlobalSoundSource)
end

local function pipe_exit(m, o)
    play_sound(SOUND_MENU_EXIT_PIPE, gGlobalSoundSource)
    set_mario_action(m, ACT_EMERGE_FROM_PIPE, 0)
end

local function boo_pipe_red_exit(m, o)
    pipe_exit(m)
    charSelect.character_set_current_number(CT_MARIO, 1)
end

local function boo_pipe_green_exit(m, o)
    pipe_exit(m)
    local char = gNumLuigiKeys == 8 and CT_LUIGI or m.character.type
    charSelect.character_set_current_number(char, 1)
end

local function boo_pipe_yellow_exit(m, o)
    pipe_exit(m)
    local char = gNumWarioCoins == 6 and CT_WARIO or m.character.type
    charSelect.character_set_current_number(char, 1)
end

local function pipe_green()
    return gNumLuigiKeys == 8 and 1 or 0
end

local function pipe_yellow()
    return gNumWarioCoins == 6 and 1 or 0
end

local pipeGreenBhv = {
    [0] = id_bhvRender96WarpPipeGreenLock,
    [1] = id_bhvRender96WarpPipeGreenUnlock,
}

local pipeYellowBhv = {
    [0] = id_bhvRender96WarpPipeYellowLock,
    [1] = id_bhvRender96WarpPipeYellowUnlock,
}

local pipeModel = {
    [0] = E_MODEL_WARP_PIPE_LOCKED,
    [1] = E_MODEL_WARP_PIPE_UNLOCKED,
}

bloWarps.newWarpNode(LEVEL_CASTLE_COURTYARD, 1, 0xE0, LEVEL_INNER_WORKINGS, 1, 0xE1, pipe_entry, pipe_exit, true)
bloWarps.createWarpObj(id_bhvWarpPipe, E_MODEL_WARP_PIPE_UNLOCKED, 0xE0, nil, LEVEL_CASTLE_COURTYARD, 1, {2360, -200, -2712}, {0, -0x2000, 0})

bloWarps.newWarpNode(LEVEL_INNER_WORKINGS, 1, 0xE1, LEVEL_CASTLE_COURTYARD, 1, 0xE0, pipe_entry, pipe_exit, true)
bloWarps.createWarpObj(id_bhvWarpPipe, E_MODEL_WARP_PIPE_UNLOCKED, 0xE1, nil, LEVEL_INNER_WORKINGS, 1, {0, 0, -1100}, {0, 0, 0})

bloWarps.newWarpNode(LEVEL_INNER_WORKINGS, 1, 0x00, LEVEL_INNER_WORKINGS, 1, 0x00, pipe_entry, boo_pipe_red_exit, true)
bloWarps.createWarpObj(id_bhvRender96WarpPipeRed, E_MODEL_WARP_PIPE_UNLOCKED, 0x00, nil, LEVEL_INNER_WORKINGS, 1, {0, 0, 3200}, {0, 0x8000, 0})

bloWarps.newWarpNode(LEVEL_INNER_WORKINGS, 1, 0x01, LEVEL_INNER_WORKINGS, 1, 0x01, pipe_entry, boo_pipe_green_exit, true)
bloWarps.createWarpObj(pipeGreenBhv[pipe_green()], pipeModel[pipe_green()], 0x01, nil, LEVEL_INNER_WORKINGS, 1, {2700, 800, -200}, {0, -0x4000, 0})

bloWarps.newWarpNode(LEVEL_INNER_WORKINGS, 1, 0x02, LEVEL_INNER_WORKINGS, 1, 0x02, pipe_entry, boo_pipe_yellow_exit, true)
bloWarps.createWarpObj(pipeYellowBhv[pipe_yellow()], pipeModel[pipe_yellow()], 0x02, nil, LEVEL_INNER_WORKINGS, 1, {-2700, 0, 700}, {0, 0x4000, 0})

local function is_mario_at_cabinet()
    return gNetworkPlayers[0].currLevelNum == LEVEL_INNER_WORKINGS
end

_G.charSelect.hook_allow_menu_open(is_mario_at_cabinet)