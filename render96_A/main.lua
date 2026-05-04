-- name: Render96 A Mod Pack
-- description: A Mod Pack That Adds All Render96 Features To The Game
-- author: \#ff3030\Render96DX Team

o2oint = require("lib/o2oint")
bloWarps = require("/lib/warps")
UvScroll = require("/lib/uv-scroll")
require("/lib/r96lib")

-- Constants
require('lua/constants')

-- Players
require('lua/mario')
require('lua/character_moveset')

-- Non players
require('lua/behaviors')
require('lua/extra_char_unlock')

require('lua/got_milk')
require('lua/mario_milk_run')

local charSelect = _G.charSelect

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

local function boo_pipe_green_model()
    return gNumLuigiKeys == 8 and E_MODEL_WARP_PIPE_BOO_GREEN_UNLOCKED or  E_MODEL_WARP_PIPE_BOO_GREEN_LOCKED
end

local function boo_pipe_yellow_model()
    return gNumWarioCoins == 6 and E_MODEL_WARP_PIPE_BOO_YELLOW_UNLOCKED or  E_MODEL_WARP_PIPE_BOO_YELLOW_LOCKED
end

local function obj_beh_params2(o, val)
    o.oBehParams2ndByte = val
end

-- Warps
bloWarps.newWarpNode(LEVEL_CASTLE, 1, 0xE0, LEVEL_FOURTH_FLOOR, 1, 0xE1, pipe_entry, pipe_exit, true)
bloWarps.createWarpObj(id_bhvWarpPipe, E_MODEL_WARP_PIPE_BOO_BLUE, 0xE0, nil, LEVEL_CASTLE, 1, {1635, 614, -2483}, {0, -0x2000, 0})

bloWarps.newWarpNode(LEVEL_FOURTH_FLOOR, 1, 0xE1, LEVEL_CASTLE, 1, 0xE0, pipe_entry, pipe_exit, true)
bloWarps.createWarpObj(id_bhvWarpPipe, E_MODEL_WARP_PIPE_BOO_BLUE, 0xE1, nil, LEVEL_FOURTH_FLOOR, 1, {376, -110, -533}, {0, 0, 0})

bloWarps.newWarpNode(LEVEL_FOURTH_FLOOR, 1, 0x00, LEVEL_FOURTH_FLOOR, 1, 0x00, pipe_entry, boo_pipe_red_exit, true)
bloWarps.createWarpObj(id_bhvRender96WarpPipeRed, E_MODEL_WARP_PIPE_BOO_RED, 0x00, nil, LEVEL_FOURTH_FLOOR, 1, {311, -110, 2341}, {0, 0x8000, 0})

bloWarps.newWarpNode(LEVEL_FOURTH_FLOOR, 1, 0x01, LEVEL_FOURTH_FLOOR, 1, 0x01, pipe_entry, boo_pipe_green_exit, true)
bloWarps.createWarpObj(id_bhvRender96WarpPipeGreen, boo_pipe_green_model(), 0x01, nil, LEVEL_FOURTH_FLOOR, 1, {1895, -110, 2302}, {0, 0x8000, 0})

bloWarps.newWarpNode(LEVEL_FOURTH_FLOOR, 1, 0x02, LEVEL_FOURTH_FLOOR, 1, 0x02, pipe_entry, boo_pipe_yellow_exit, true)
bloWarps.createWarpObj(id_bhvRender96WarpPipeYellow, boo_pipe_yellow_model(), 0x02, nil, LEVEL_FOURTH_FLOOR, 1, {-1281, -110, 2270}, {0, 0x8000, 0})

-- Models
r96lib.addModelOverride(id_bhvBalconyBigBoo,        E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvMerryGoRoundBigBoo,   E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvBooWithCage,          E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvGhostHuntBigBoo,      E_MODEL_BOO_KING)
r96lib.addModelOverride(id_bhvBooInCastle,          E_MODEL_BOO_KING)
r96lib.addModelOverride(id_bhvBigBullyWithMinions,  E_MODEL_BULLY_BIG)
r96lib.addModelOverride(id_bhvGrindel,              E_MODEL_GRINDLE)
r96lib.addModelOverride(id_bhvHorizontalGrindel,    E_MODEL_GRINDLE)
r96lib.addModelOverride(id_bhvSpindel,              E_MODEL_SPINDLE)

-- Enemies
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG, id_bhvRender96Blargg, -6766, 0,  3033, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG, id_bhvRender96Blargg, -6018, 0, -5512, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG, id_bhvRender96Blargg, -2151, 0, -5254, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG, id_bhvRender96Blargg,  2012, 0, -3440, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG, id_bhvRender96Blargg,  7408, 0, -4223, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG, id_bhvRender96Blargg,  6318, 0,   752, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG, id_bhvRender96Blargg,  5647, 0,  3426, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG, id_bhvRender96Blargg, -5315, 0,  7493, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_BLARGG_FRIENDLY, id_bhvRender96BlarggFriendly, -2070, 0, 6177, 0, 0, 0, {5, 6})
r96lib.addSpawn(LEVEL_BBH, 1, E_MODEL_MR_I, id_bhvRender96MrI, -2369, -204,  5184, 0, 0, 0)
r96lib.addSpawn(LEVEL_BBH, 1, E_MODEL_MR_I, id_bhvRender96MrI,   480,   10,  -653, 0, 0, 0)
r96lib.addSpawn(LEVEL_BBH, 1, E_MODEL_MR_I, id_bhvRender96MrI,  1640,  840,  -733, 0, 0, 0)
r96lib.addSpawn(LEVEL_BBH, 1, E_MODEL_MR_I, id_bhvRender96MrI,   923, 1741,  -332, 0, 0, 0, nil, function(o) obj_beh_params2(o, 0x05010000) end)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_MR_I, id_bhvRender96MrI, -3199,  307,  3456, 0, 0, 0)
r96lib.addSpawn(LEVEL_LLL, 1, E_MODEL_MR_I, id_bhvRender96MrI,  6673,  154, -3060, 0, 0, 0)
r96lib.addSpawn(LEVEL_HMC, 1, E_MODEL_MR_I, id_bhvRender96MrI,  4740, 1060,  4680, 0, 0, 0)
r96lib.addSpawn(LEVEL_HMC, 1, E_MODEL_MR_I, id_bhvRender96MrI,  6700, 1020,  6820, 0, 0, 0)

-- Extra
r96lib.addSpawn(LEVEL_BOB, 1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys,    7141,  2030, -6711, 0, 0, 0, nil, function(o) obj_beh_params2(o, 0) end)
r96lib.addSpawn(LEVEL_WF, 1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys,     -356,  3584,   -21, 0, 0, 0, {2, 3, 4, 5, 6}, function(o) obj_beh_params2(o, 1) end)
r96lib.addSpawn(LEVEL_JRB, 1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys,    7134, -3322,  2169, 0, 0, 0, {2}, function(o) obj_beh_params2(o, 2) end)
r96lib.addSpawn(LEVEL_CCM, 2, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys,   -5539, -4812, -6637, 0, 0, 0, nil, function(o) obj_beh_params2(o, 3) end)
r96lib.addSpawn(LEVEL_BBH, 1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys,   -1595,  2560,  1657, 0, 0, 0, nil, function(o) obj_beh_params2(o, 4) end)
r96lib.addSpawn(LEVEL_SA, 1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys,     -318,  -160,   -38, 0, 0, 0, nil, function(o) obj_beh_params2(o, 5) end)
r96lib.addSpawn(LEVEL_PSS, 1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys,    6094,  6144, -4145, 0, 0, 0, nil, function(o) obj_beh_params2(o, 6) end)
r96lib.addSpawn(LEVEL_BITDW, 1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, -4560,  1126,  -179, 0, 0, 0, nil, function(o) obj_beh_params2(o, 7) end)


-- Scroll the uvs to the right
local function uv_scroll_right(input_vtx, original_uv, current_uv)
    -- adjustable constants
    local speed = 10

    -- move the UVs to the right
    current_uv[1] = current_uv[1] + speed
end

UvScroll.hook_scrolling_function('star_particle_001_displaylist_mesh_layer_5_tri_1', uv_scroll_right)


function wario_head_spawner()
    local levelNum = gNetworkPlayers[0].currLevelNum
    local areaNum = gNetworkPlayers[0].currAreaIndex
    local actNum = gNetworkPlayers[0].currActNum
    local m = gMarioStates[0]
    --5235, -1074,  1995
    --604, -1074, 1995
    --if levelNum == LEVEL_CASTLE and m.pos.y == -1074 then
    --r96lib.spawn_object(E_MODEL_WARIO_HEAD, id_bhvWarioHead, 5935, -1074,  2084, 0, 0, 0, nil)
--
    ----print("spawned head")
    --end
    --print(levelNum)
end

 --REPLACE WITH C CODE?
function check_model_cheat()
    --if gNumLuigiKeys ~= 8 and gMarioStates[0].character.type == CT_LUIGI then _G.charSelect.character_set_current_number(CT_MARIO, 1) end
    --if gNumWarioCoins ~= 6 and gMarioStates[0].character.type == CT_WARIO then _G.charSelect.character_set_current_number(CT_MARIO, 1) end
end
hook_event(HOOK_MARIO_UPDATE, check_model_cheat)
hook_event(HOOK_ON_WARP, wario_head_spawner)
function squishtest()
    --vec3f_set(gMarioStates[0].marioObj.header.gfx.scale, 3, 1, 1);
    --vec3f_set(gMarioStates[0].marioObj.header.gfx.scale, .1, 1, 1)
    --gMarioStates[0].marioObj.header.gfx.node.flags = gMarioStates[0].marioObj.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
end

hook_event(HOOK_MARIO_UPDATE, squishtest)


local function mario_update(m)
   --if m.playerIndex ~= 0 then return end
   --if m.controller.buttonPressed & X_BUTTON ~= 0 then
   -- spawn_non_sync_object(id_bhvRender96Star, E_MODEL_STAR, m.pos.x + 200, m.pos.y, m.pos.z, nil)
   --   
   --end
   if m.action == ACT_BACKFLIP then
       warp_to_level(LEVEL_FOURTH_FLOOR, 1, 1)
   end
    local mrI = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvMrI)
    if mrI ~= nil then
        --print(mrI.oPosX, mrI.oPosY, mrI.oPosZ)
        obj_mark_for_deletion(mrI)
        return
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update)