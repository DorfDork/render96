-- name: Render96 A Mod Pack
-- description: A Mod Pack That Adds All Render96 Features To The Game
-- author: \#ff3030\Render96DX Team

local r96lib = require("/lib/r96lib")
local charSelect = _G.charSelect

--gLevelValues.entryLevel = SPECIAL_WARP_TITLE

-- Models
r96lib.addModelOverride(id_bhvBalconyBigBoo,           E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvMerryGoRoundBigBoo,      E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvBooWithCage,             E_MODEL_BOO_BIG)
r96lib.addModelOverride(id_bhvGhostHuntBigBoo,         E_MODEL_BOO_KING)
r96lib.addModelOverride(id_bhvBooInCastle,             E_MODEL_BOO_KING)
r96lib.addModelOverride(id_bhvBigBullyWithMinions,     E_MODEL_BULLY_BIG)
r96lib.addModelOverride(id_bhvGrindel,                 E_MODEL_GRINDLE)
r96lib.addModelOverride(id_bhvHorizontalGrindel,       E_MODEL_GRINDLE)
r96lib.addModelOverride(id_bhvSpindel,                 E_MODEL_SPINDLE)
r96lib.addModelOverride(id_bhvSmallPenguin,            E_MODEL_PENGUIN_BABY)
r96lib.addModelOverride(id_bhvRacingPenguin,           E_MODEL_PENGUIN_RACER)
r96lib.addModelOverride(id_bhvSLWalkingPenguin,        E_MODEL_PENGUIN_SL)
r96lib.addModelOverride(id_bhvFirePiranhaPlant,        E_MODEL_PIRANHA_PLANT_FIRE)
r96lib.addModelOverride(id_bhvWhompKingBoss,           E_MODEL_WHOMP_KING)
r96lib.addModelOverride(id_bhvSignOnWall,              E_MODEL_SIGN_ON_WALL)
r96lib.addModelOverride(id_bhvStarDoor,                E_MODEL_STAR_DOOR)
r96lib.addModelOverride(id_bhvToxBox,                  E_MODEL_TOXBOX)
r96lib.addModelOverride(id_bhvCapSwitchBase,           E_MODEL_CAP_SWITCH_BASE_HD)
r96lib.addModelOverride(id_bhvFireSpitter,             E_MODEL_FIRE_SPITTER)
r96lib.addModelOverride(id_bhvMantaRay,                E_MODEL_MANTA)
r96lib.addModelOverride(id_bhvRotatingExclamationMark, E_MODEL_EXCLAMATION_POINT_HD)
r96lib.addModelOverride(id_bhvCoffin,                  E_MODEL_BBH_COFFIN)
r96lib.addModelOverride(id_bhvSnowmansHead,            E_MODEL_SNOWMAN_HEAD)
r96lib.addModelOverride(id_bhvSnowmansBottom,          E_MODEL_SNOWMAN_BODY)
r96lib.addModelOverride(id_bhvBigSnowmanWhole,         E_MODEL_SNOWMAN_BODY)

r96lib.addModelParamOverride(id_bhvKoopa, 0x01020000, E_MODEL_KOOPA_QUICK_BOB)
r96lib.addModelParamOverride(id_bhvKoopa, 0x02030000, E_MODEL_KOOPA_QUICK_BOB)

r96lib.addModelLevelOverride(id_bhvGoomba, E_MODEL_GOOMBA_SSL,         E_MODEL_GOOMBA,     LEVEL_SSL, 1, nil)
r96lib.addModelLevelOverride(id_bhvGoomba, E_MODEL_GOOMBA_UNDERGROUND, E_MODEL_GOOMBA,     LEVEL_SSL, 2, nil)
r96lib.addModelLevelOverride(id_bhvGoomba, E_MODEL_GOOMBA_BOXART,      E_MODEL_GOOMBA,     LEVEL_BITDW, 1, nil)
r96lib.addModelLevelOverride(id_bhvGoomba, E_MODEL_GOOMBA_BOXART,      E_MODEL_GOOMBA,     LEVEL_BITFS, 1, nil)
r96lib.addModelLevelOverride(id_bhvGoomba, E_MODEL_GOOMBA_BOXART,      E_MODEL_GOOMBA,     LEVEL_BITS, 1, nil)

r96lib.addModelLevelOverride(id_bhvFlame,  E_MODEL_RED_FLAME_TORCH,    E_MODEL_RED_FLAME,  LEVEL_CASTLE, 3, nil)
r96lib.addModelLevelOverride(id_bhvFlame,  E_MODEL_BLUE_FLAME_TORCH,   E_MODEL_BLUE_FLAME, LEVEL_CASTLE, 3, nil)
r96lib.addModelLevelOverride(id_bhvFlame,  E_MODEL_RED_FLAME_TORCH,    E_MODEL_RED_FLAME,  LEVEL_HMC, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlame,  E_MODEL_RED_FLAME_TORCH,    E_MODEL_RED_FLAME,  LEVEL_BBH, 1, nil)

r96lib.addModelLevelOverride(id_bhvFlyguyFlame,               E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlyguyFlame,               E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBowser,               E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBowser,               E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBouncing,             E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBouncing,             E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvBlueBowserFlame,           E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvBlueBowserFlame,           E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvSmallPiranhaFlame,         E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvSmallPiranhaFlame,         E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameFloatingLanding,      E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameFloatingLanding,      E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameLargeBurningOut,      E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameLargeBurningOut,      E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameMovingForwardGrowing, E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameMovingForwardGrowing, E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)

r96lib.addModelLevelOverride(id_bhvFlyguyFlame,               E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlyguyFlame,               E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBowser,               E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBowser,               E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBouncing,             E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBouncing,             E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvBlueBowserFlame,           E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvBlueBowserFlame,           E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvSmallPiranhaFlame,         E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvSmallPiranhaFlame,         E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameFloatingLanding,      E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameFloatingLanding,      E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameLargeBurningOut,      E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameLargeBurningOut,      E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameMovingForwardGrowing, E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameMovingForwardGrowing, E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)

r96lib.addModelLevelOverride(id_bhvFlyguyFlame,               E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlyguyFlame,               E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBowser,               E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBowser,               E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBouncing,             E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameBouncing,             E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvBlueBowserFlame,           E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvBlueBowserFlame,           E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvSmallPiranhaFlame,         E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvSmallPiranhaFlame,         E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameFloatingLanding,      E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameFloatingLanding,      E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameLargeBurningOut,      E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameLargeBurningOut,      E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameMovingForwardGrowing, E_MODEL_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.addModelLevelOverride(id_bhvFlameMovingForwardGrowing, E_MODEL_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)

-- Enemies
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG_FRIENDLY, id_bhvRender96BlarggFriendly, -2070, 0, 6177, 0, 0, 0, 0, {5, 6})
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG, id_bhvRender96Blargg, -6766, 0,  3033, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG, id_bhvRender96Blargg, -6018, 0, -5512, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG, id_bhvRender96Blargg, -2151, 0, -5254, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG, id_bhvRender96Blargg,  2012, 0, -3440, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG, id_bhvRender96Blargg,  7408, 0, -4223, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG, id_bhvRender96Blargg,  6318, 0,   752, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG, id_bhvRender96Blargg,  5647, 0,  3426, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_BLARGG, id_bhvRender96Blargg, -5315, 0,  7493, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_BBH,  1, E_MODEL_MR_I, id_bhvRender96MrI, -2369, -204,  5184, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_BBH,  1, E_MODEL_MR_I, id_bhvRender96MrI,   480,   10,  -653, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_BBH,  1, E_MODEL_MR_I, id_bhvRender96MrI,  1640,  840,  -733, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_BBH,  1, E_MODEL_MR_I, id_bhvRender96MrI,   923, 1741,  -332, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 0x05010000 end)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_MR_I, id_bhvRender96MrI, -3199,  307,  3456, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_LLL,  1, E_MODEL_MR_I, id_bhvRender96MrI,  6673,  154, -3060, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_HMC,  1, E_MODEL_MR_I, id_bhvRender96MrI,  4740, 1060,  4680, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_HMC,  1, E_MODEL_MR_I, id_bhvRender96MrI,  6700, 1020,  6820, 0, 0, 0, false)
r96lib.addSpawn(LEVEL_BITS, 1, E_MODEL_MARTY, id_bhvThwomp,     -5247, -1330,  -787, 0, 0, 0, true, nil, function(o) o.oBehParams = 1 end)

-- Extra
r96lib.addSpawn(LEVEL_BOB,   1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, 7141,  2030,  -6711, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 0 end)
r96lib.addSpawn(LEVEL_WF,    1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, -356,  3584,  -21,   0, 0, 0, false, {2, 3, 4, 5, 6}, function(o) o.oBehParams2ndByte = 1 end)
r96lib.addSpawn(LEVEL_JRB,   1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, 7134,  -3322, 2169,  0, 0, 0, false, {2}, function(o) o.oBehParams2ndByte = 2 end)
r96lib.addSpawn(LEVEL_CCM,   2, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, -5539, -4812, -6637, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 3 end)
r96lib.addSpawn(LEVEL_BBH,   1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, -1595, 2560,  1657,  0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 4 end)
r96lib.addSpawn(LEVEL_SA,    1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, -318,  -160,  -38,   0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 5 end)
r96lib.addSpawn(LEVEL_PSS,   1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, 6094,  6144,  -4145, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 6 end)
r96lib.addSpawn(LEVEL_BITDW, 1, E_MODEL_LUIGI_KEY, id_bhvLuigiKeys, -4560, 1126,  -179,  0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 7 end)

local function entity_cleanup()
    local mrI = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvMrI)
    if mrI ~= nil then
        --print(mrI.oPosX, mrI.oPosY, mrI.oPosZ)
        obj_mark_for_deletion(mrI)
    end
end

hook_event(HOOK_ON_OBJECT_LOAD, entity_cleanup)

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

    if levelNum ~= LEVEL_CASTLE then 
        local door = obj_get_first_with_behavior_id(id_bhvDoor)
        while door ~= nil and door.oSwitchState1 ~= 1 and obj_has_model_extended(door, E_MODEL_HMC_WOODEN_DOOR) ~= 0 do
            door.oSwitchState1 = 1
            door = obj_get_next_with_same_behavior_id(door)
        end
    end
end

 --REPLACE WITH C CODE?
function check_model_cheat()
    --print("X: " .. gMarioStates[0].marioObj.oPosX .. " Y: " .. gMarioStates[0].marioObj.oPosY .. " Z: " .. gMarioStates[0].marioObj.oPosZ)
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
   -- if m.controller.buttonPressed & X_BUTTON ~= 0 then
    --spawn_non_sync_object(id_bhvRender96YoshiRideable, E_MODEL_YOSHI_RIDEABLE, m.pos.x + 200, m.pos.y, m.pos.z, nil)
    -- spawn_non_sync_object(id_bhv1Up, E_MODEL_1UP, m.pos.x + 200, m.pos.y, m.pos.z, nil)
   --end
    if m.action == ACT_BACKFLIP then
        warp_to_level(LEVEL_BOWSER_3, 1, 1)
    end
   --SPECIAL_WARP_CAKE
   --WARP_NODE_CREDITS_START
   --SPECIAL_WARP_TITLE
   --SPECIAL_WARP_LEVEL_SELECT
   --SPECIAL_WARP_GODDARD
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
