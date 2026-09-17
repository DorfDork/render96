local charSelect = require("/lib/char-select")
local bloWarps = require("/lib/warps")

---@param m MarioState
---@param o Object
local function pipe_entry(m, o)
    play_sound(SOUND_MENU_ENTER_PIPE, gGlobalSoundSource)
end

---@param m MarioState
---@param o Object
local function pipe_exit(m, o)
    play_sound(SOUND_MENU_EXIT_PIPE, gGlobalSoundSource)
    set_mario_action(m, ACT_EMERGE_FROM_PIPE, 0)
end

---@param m MarioState
---@param o Object
local function boo_pipe_red_exit(m, o)
    pipe_exit(m, o)
    charSelect.character_set_current_number(CT_MARIO, 1)
end

---@param m MarioState
---@param o Object
local function boo_pipe_green_exit(m, o)
    pipe_exit(m, o)
    local charNum = is_luigi_unlocked() and CT_LUIGI or charSelect.character_get_current_number(m.playerIndex)
    charSelect.character_set_current_number(charNum, 1)
end

---@param m MarioState
---@param o Object
local function boo_pipe_yellow_exit(m, o)
    pipe_exit(m, o)
    local charNum = is_wario_unlocked() and CT_WARIO or charSelect.character_get_current_number(m.playerIndex)
    charSelect.character_set_current_number(charNum, 1)
end

local function pipe_green()
    return is_luigi_unlocked() and 1 or 0
end

local function pipe_yellow()
    return is_wario_unlocked() and 1 or 0
end

local BEHAVIORS_PIPE_GREEN = {
    [0] = id_bhvRender96WarpPipeGreenLock,
    [1] = id_bhvRender96WarpPipeGreenUnlock,
}

local BEHAVIORS_PIPE_YELLOW = {
    [0] = id_bhvRender96WarpPipeYellowLock,
    [1] = id_bhvRender96WarpPipeYellowUnlock,
}

local PIPE_MODELS = {
    [0] = E_MODEL_R96_WARP_PIPE_LOCKED,
    [1] = E_MODEL_R96_WARP_PIPE_UNLOCKED,
}

bloWarps.new_warp_node(LEVEL_CASTLE_COURTYARD, 1, 0xE0, LEVEL_R96_INNER_WORKINGS, 1, 0xE1, pipe_entry, pipe_exit, true)
bloWarps.create_warp_obj(id_bhvWarpPipe, E_MODEL_R96_WARP_PIPE_UNLOCKED, 0xE0, nil, LEVEL_CASTLE_COURTYARD, 1, {2360, -200, -2712}, {0, -0x2000, 0})

bloWarps.new_warp_node(LEVEL_R96_INNER_WORKINGS, 1, 0xE1, LEVEL_CASTLE_COURTYARD, 1, 0xE0, pipe_entry, pipe_exit, true)
bloWarps.create_warp_obj(id_bhvWarpPipe, E_MODEL_R96_WARP_PIPE_UNLOCKED, 0xE1, nil, LEVEL_R96_INNER_WORKINGS, 1, {0, 0, -1100}, {0, 0, 0})

bloWarps.new_warp_node(LEVEL_R96_INNER_WORKINGS, 1, 0x00, LEVEL_R96_INNER_WORKINGS, 1, 0x00, pipe_entry, boo_pipe_red_exit, true)
bloWarps.create_warp_obj(id_bhvRender96WarpPipeRed, E_MODEL_R96_WARP_PIPE_UNLOCKED, 0x00, nil, LEVEL_R96_INNER_WORKINGS, 1, {0, 0, 3200}, {0, 0x8000, 0})

bloWarps.new_warp_node(LEVEL_R96_INNER_WORKINGS, 1, 0x01, LEVEL_R96_INNER_WORKINGS, 1, 0x01, pipe_entry, boo_pipe_green_exit, true)
bloWarps.create_warp_obj(BEHAVIORS_PIPE_GREEN[pipe_green()], PIPE_MODELS[pipe_green()], 0x01, nil, LEVEL_R96_INNER_WORKINGS, 1, {2700, 800, -200}, {0, -0x4000, 0})

bloWarps.new_warp_node(LEVEL_R96_INNER_WORKINGS, 1, 0x02, LEVEL_R96_INNER_WORKINGS, 1, 0x02, pipe_entry, boo_pipe_yellow_exit, true)
bloWarps.create_warp_obj(BEHAVIORS_PIPE_YELLOW[pipe_yellow()], PIPE_MODELS[pipe_yellow()], 0x02, nil, LEVEL_R96_INNER_WORKINGS, 1, {-2700, 0, 700}, {0, 0x4000, 0})

local sLastGreenUnlocked = pipe_green()
local sLastYellowUnlocked = pipe_yellow()

local function refresh_pipe(level, area, node, bhvTable, modelTable, unlocked, pos, angle)
    bloWarps.delete_warp_obj(level, area, node)
    bloWarps.create_warp_obj(bhvTable[unlocked], modelTable[unlocked], node, nil, level, area, pos, angle)
end

local sAudioStream = nil

local function inner_workings_update()

    -- Stop music
    if sAudioStream ~= nil and gNetworkPlayers[0].currLevelNum ~= LEVEL_R96_INNER_WORKINGS then
        audio_stream_set_looping(sAudioStream, false)
        audio_stream_stop(sAudioStream)
        sAudioStream = nil
    end

    -- Update pipe locks
    local green = pipe_green()
    if green ~= sLastGreenUnlocked then
        sLastGreenUnlocked = green
        refresh_pipe(LEVEL_R96_INNER_WORKINGS, 1, 0x01, BEHAVIORS_PIPE_GREEN, PIPE_MODELS, green, {2700, 800, -200}, {0, -0x4000, 0})
    end
    local yellow = pipe_yellow()
    if yellow ~= sLastYellowUnlocked then
        sLastYellowUnlocked = yellow
        refresh_pipe(LEVEL_R96_INNER_WORKINGS, 1, 0x02, BEHAVIORS_PIPE_YELLOW, PIPE_MODELS, yellow, {-2700, 0, 700}, {0, 0x4000, 0})
    end
end

hook_event(HOOK_UPDATE, inner_workings_update)

local function set_inner_workings_music()
    if gNetworkPlayers[0].currLevelNum == LEVEL_R96_INNER_WORKINGS then
        sAudioStream = AUDIO_R96_INNER_WORKINGS_SONG
        audio_stream_set_loop_points(sAudioStream, 15102, 1204316)
        audio_stream_set_looping(sAudioStream, true)
        audio_stream_play(sAudioStream, true, 0.7)
    end
end

hook_event(HOOK_ON_WARP, set_inner_workings_music)

local function is_mario_at_cabinet()
    return gNetworkPlayers[0].currLevelNum == LEVEL_R96_INNER_WORKINGS
end

charSelect.hook_allow_menu_open(is_mario_at_cabinet)