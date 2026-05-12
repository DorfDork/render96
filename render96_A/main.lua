-- name: Render96 A Mod Pack
-- description: A Mod Pack That Adds All Render96 Features To The Game
-- author: \#ff3030\Render96DX Team

local UvScroll = require("/lib/uv-scroll")
local r96lib = require("/lib/r96lib")

local charSelect = _G.charSelect


local function obj_beh_params2(o, val)
    o.oBehParams2ndByte = val
end

-- Warps

-- Models
r96lib.addModelOverride(id_bhvBalconyBigBoo,            E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvMerryGoRoundBigBoo,       E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvBooWithCage,             E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvGhostHuntBigBoo,      E_MODEL_BOO_KING)
r96lib.addModelOverride(id_bhvBooInCastle,          E_MODEL_BOO_KING)
r96lib.addModelOverride(id_bhvBigBullyWithMinions,  E_MODEL_BULLY_BIG)
r96lib.addModelOverride(id_bhvGrindel,              E_MODEL_GRINDLE)
r96lib.addModelOverride(id_bhvHorizontalGrindel,    E_MODEL_GRINDLE)
r96lib.addModelOverride(id_bhvSpindel,            E_MODEL_SPINDLE)
r96lib.addModelOverride(id_bhvSmallPenguin,              E_MODEL_PENGUIN_BABY)
r96lib.addModelOverride(id_bhvRacingPenguin,              E_MODEL_PENGUIN_RACER)
r96lib.addModelOverride(id_bhvSLWalkingPenguin,              E_MODEL_PENGUIN_SL)
r96lib.addModelOverride(id_bhvFirePiranhaPlant,              E_MODEL_PIRANHA_PLANT_FIRE)
r96lib.addModelOverride(id_bhvWhompKingBoss,              E_MODEL_WHOMP_KING)
r96lib.addModelParamOverride(id_bhvKoopa, 0x01020000,             E_MODEL_KOOPA_QUICK_BOB)
r96lib.addModelParamOverride(id_bhvKoopa, 0x02030000,             E_MODEL_KOOPA_QUICK_BOB)

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
   --if m.action == ACT_BACKFLIP then
   --    warp_to_level(LEVEL_HMC, 1, 1)
   --end
    local mrI = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvMrI)
    if mrI ~= nil then
        --print(mrI.oPosX, mrI.oPosY, mrI.oPosZ)
        obj_mark_for_deletion(mrI)
        return
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update)