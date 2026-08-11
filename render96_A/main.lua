-- name: Render96 A Mod Pack
-- description: A Mod Pack That Adds All Render96 Features To The Game
-- author: \#ff3030\Render96DX Team

local version = require("/lib/version")
local r96lib = require("/lib/r96lib")

gLevelValues.entryLevel = SPECIAL_WARP_TITLE
if version.SKIP_GODDARD_AND_FILE_SELECT then
    gLevelValues.skipGoddard = 0
    gLevelValues.skipFileSelect = 0
end

gBehaviorValues.ProcessLODs = 1

------------
-- Models --
------------

r96lib.add_model_override(id_bhvBalconyBigBoo,           E_MODEL_R96_BOO_BIG)
r96lib.add_model_override(id_bhvMerryGoRoundBigBoo,      E_MODEL_R96_BOO_BIG)
r96lib.add_model_override(id_bhvBooWithCage,             E_MODEL_R96_BOO_BIG)
r96lib.add_model_override(id_bhvGhostHuntBigBoo,         E_MODEL_R96_BOO_KING)
r96lib.add_model_override(id_bhvBooInCastle,             E_MODEL_R96_BOO_KING)
r96lib.add_model_override(id_bhvBigBullyWithMinions,     E_MODEL_R96_BULLY_BIG)
r96lib.add_model_override(id_bhvGrindel,                 E_MODEL_R96_GRINDLE)
r96lib.add_model_override(id_bhvHorizontalGrindel,       E_MODEL_R96_GRINDLE)
r96lib.add_model_override(id_bhvSpindel,                 E_MODEL_R96_SPINDLE)
r96lib.add_model_override(id_bhvSmallPenguin,            E_MODEL_R96_PENGUIN_BABY)
r96lib.add_model_override(id_bhvRacingPenguin,           E_MODEL_R96_PENGUIN_RACER)
r96lib.add_model_override(id_bhvSLWalkingPenguin,        E_MODEL_R96_PENGUIN_SL)
r96lib.add_model_override(id_bhvFirePiranhaPlant,        E_MODEL_R96_PIRANHA_PLANT_FIRE)
r96lib.add_model_override(id_bhvWhompKingBoss,           E_MODEL_R96_WHOMP_KING)
r96lib.add_model_override(id_bhvSignOnWall,              E_MODEL_R96_SIGN_ON_WALL)
r96lib.add_model_override(id_bhvStarDoor,                E_MODEL_R96_STAR_DOOR)
r96lib.add_model_override(id_bhvToxBox,                  E_MODEL_R96_TOXBOX)
r96lib.add_model_override(id_bhvCapSwitchBase,           E_MODEL_R96_CAP_SWITCH_BASE_HD)
r96lib.add_model_override(id_bhvFireSpitter,             E_MODEL_R96_FIRE_SPITTER)
r96lib.add_model_override(id_bhvMantaRay,                E_MODEL_R96_MANTA)
r96lib.add_model_override(id_bhvRotatingExclamationMark, E_MODEL_R96_EXCLAMATION_POINT_HD)
r96lib.add_model_override(id_bhvCoffin,                  E_MODEL_R96_BBH_COFFIN)
r96lib.add_model_override(id_bhvSnowmansHead,            E_MODEL_R96_SNOWMAN_HEAD)
r96lib.add_model_override(id_bhvSnowmansBottom,          E_MODEL_R96_SNOWMAN_BODY)
r96lib.add_model_override(id_bhvBigSnowmanWhole,         E_MODEL_R96_SNOWMAN_BODY)

r96lib.add_model_override_param(id_bhvKoopa, 0x01020000, E_MODEL_R96_KOOPA_QUICK_BOB)
r96lib.add_model_override_param(id_bhvKoopa, 0x02030000, E_MODEL_R96_KOOPA_QUICK_THI)

r96lib.add_model_override_level(id_bhvGoomba, E_MODEL_R96_GOOMBA_SSL,         E_MODEL_GOOMBA, LEVEL_SSL,   1, nil)
r96lib.add_model_override_level(id_bhvGoomba, E_MODEL_R96_GOOMBA_UNDERGROUND, E_MODEL_GOOMBA, LEVEL_SSL,   2, nil)
r96lib.add_model_override_level(id_bhvGoomba, E_MODEL_R96_GOOMBA_UNDERGROUND, E_MODEL_GOOMBA, LEVEL_JRB,   1, nil)
r96lib.add_model_override_level(id_bhvGoomba, E_MODEL_R96_GOOMBA_BOXART,      E_MODEL_GOOMBA, LEVEL_BITDW, 1, nil)
r96lib.add_model_override_level(id_bhvGoomba, E_MODEL_R96_GOOMBA_BOXART,      E_MODEL_GOOMBA, LEVEL_BITFS, 1, nil)
r96lib.add_model_override_level(id_bhvGoomba, E_MODEL_R96_GOOMBA_BOXART,      E_MODEL_GOOMBA, LEVEL_BITS,  1, nil)

r96lib.add_model_override_level(id_bhvFlame, E_MODEL_R96_RED_FLAME_TORCH,     E_MODEL_RED_FLAME,  LEVEL_CASTLE, 3, nil)
r96lib.add_model_override_level(id_bhvFlame, E_MODEL_R96_BLUE_FLAME_TORCH,    E_MODEL_BLUE_FLAME, LEVEL_CASTLE, 3, nil)
r96lib.add_model_override_level(id_bhvFlame, E_MODEL_R96_RED_FLAME_TORCH,     E_MODEL_RED_FLAME,  LEVEL_HMC,    1, nil)
r96lib.add_model_override_level(id_bhvFlame, E_MODEL_R96_RED_FLAME_BBH_TORCH, E_MODEL_RED_FLAME,  LEVEL_BBH,    1, nil)

r96lib.add_model_override_level(id_bhvFlyguyFlame,               E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlyguyFlame,               E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBowser,               E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBowser,               E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBouncing,             E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBouncing,             E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvBlueBowserFlame,           E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvBlueBowserFlame,           E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvSmallPiranhaFlame,         E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvSmallPiranhaFlame,         E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameFloatingLanding,      E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameFloatingLanding,      E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameLargeBurningOut,      E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameLargeBurningOut,      E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameMovingForwardGrowing, E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_1, 1, nil)
r96lib.add_model_override_level(id_bhvFlameMovingForwardGrowing, E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_1, 1, nil)

r96lib.add_model_override_level(id_bhvFlyguyFlame,               E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlyguyFlame,               E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBowser,               E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBowser,               E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBouncing,             E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBouncing,             E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvBlueBowserFlame,           E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvBlueBowserFlame,           E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvSmallPiranhaFlame,         E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvSmallPiranhaFlame,         E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameFloatingLanding,      E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameFloatingLanding,      E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameLargeBurningOut,      E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameLargeBurningOut,      E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameMovingForwardGrowing, E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_2, 1, nil)
r96lib.add_model_override_level(id_bhvFlameMovingForwardGrowing, E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_2, 1, nil)

r96lib.add_model_override_level(id_bhvFlyguyFlame,               E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlyguyFlame,               E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBowser,               E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBowser,               E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBouncing,             E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameBouncing,             E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvBlueBowserFlame,           E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvBlueBowserFlame,           E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvSmallPiranhaFlame,         E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvSmallPiranhaFlame,         E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameFloatingLanding,      E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameFloatingLanding,      E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameLargeBurningOut,      E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameLargeBurningOut,      E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameMovingForwardGrowing, E_MODEL_R96_RED_FLAME_BOWSER,  E_MODEL_RED_FLAME,  LEVEL_BOWSER_3, 1, nil)
r96lib.add_model_override_level(id_bhvFlameMovingForwardGrowing, E_MODEL_R96_BLUE_FLAME_BOWSER, E_MODEL_BLUE_FLAME, LEVEL_BOWSER_3, 1, nil)

-------------
-- Enemies --
-------------

r96lib.add_spawn(SPECIAL_WARP_TITLE, 1, E_MODEL_MR_I,                id_bhvRender96MrI,                0,     0,     0, 0, 0, 0, false, nil, function(o) cur_obj_scale(100) end)
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_R96_BLARGG_FRIENDLY, id_bhvRender96BlarggFriendly, -2070,     0,  6177, 0, 0, 0, true, {5, 6})
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_BLARGG,              id_bhvRender96Blargg,         -6766,     0,  3033, 0, 0, 0, true)
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_BLARGG,              id_bhvRender96Blargg,         -6018,     0, -5512, 0, 0, 0, true)
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_BLARGG,              id_bhvRender96Blargg,         -2151,     0, -5254, 0, 0, 0, true)
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_BLARGG,              id_bhvRender96Blargg,          2012,     0, -3440, 0, 0, 0, true)
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_BLARGG,              id_bhvRender96Blargg,          7408,     0, -4223, 0, 0, 0, true)
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_BLARGG,              id_bhvRender96Blargg,          6318,     0,   752, 0, 0, 0, true)
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_BLARGG,              id_bhvRender96Blargg,          5647,     0,  3426, 0, 0, 0, true)
r96lib.add_spawn(LEVEL_LLL,          1, E_MODEL_BLARGG,              id_bhvRender96Blargg,         -5315,     0,  7493, 0, 0, 0, true)
r96lib.add_spawn(LEVEL_BITS,         1, E_MODEL_R96_MARTY,           id_bhvThwomp,                 -5247, -1330,  -787, 0, 0, 0, true, nil, function(o) o.oBehParams = 1 end)

----------------
-- Luigi keys --
----------------

r96lib.add_spawn(LEVEL_BOB,   1, E_MODEL_R96_LUIGI_KEY, id_bhvLuigiKeys,  7141,  2030, -6711, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 0 end)
r96lib.add_spawn(LEVEL_WF,    1, E_MODEL_R96_LUIGI_KEY, id_bhvLuigiKeys,  -356,  3584,   -21, 0, 0, 0, false, {2, 3, 4, 5, 6}, function(o) o.oBehParams2ndByte = 1 end)
r96lib.add_spawn(LEVEL_JRB,   1, E_MODEL_R96_LUIGI_KEY, id_bhvLuigiKeys,  7134, -3322,  2169, 0, 0, 0, false, {2}, function(o) o.oBehParams2ndByte = 2 end)
r96lib.add_spawn(LEVEL_CCM,   2, E_MODEL_R96_LUIGI_KEY, id_bhvLuigiKeys, -5539, -4812, -6637, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 3 end)
r96lib.add_spawn(LEVEL_BBH,   1, E_MODEL_R96_LUIGI_KEY, id_bhvLuigiKeys, -1595,  2560,  1657, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 4 end)
r96lib.add_spawn(LEVEL_SA,    1, E_MODEL_R96_LUIGI_KEY, id_bhvLuigiKeys,  -318,  -160,   -38, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 5 end)
r96lib.add_spawn(LEVEL_PSS,   1, E_MODEL_R96_LUIGI_KEY, id_bhvLuigiKeys,  6094,  6144, -4145, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 6 end)
r96lib.add_spawn(LEVEL_BITDW, 1, E_MODEL_R96_LUIGI_KEY, id_bhvLuigiKeys, -4560,  1126,  -179, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 7 end)

-----------------
-- Wario coins --
-----------------

r96lib.add_spawn(LEVEL_VCUTM, 1, E_MODEL_R96_WARIO_LUNAR_COIN,   id_bhvSixGoldenCoin,  4287,   685, -4391, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 0 end)
r96lib.add_spawn(LEVEL_TOTWC, 1, E_MODEL_R96_WARIO_HOUSE_COIN,   id_bhvSixGoldenCoin,  4045,   490,  5154, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 1 end)
r96lib.add_spawn(LEVEL_LLL,   1, E_MODEL_R96_WARIO_PUMPKIN_COIN, id_bhvSixGoldenCoin,  6585,   142, -6909, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 2 end)
r96lib.add_spawn(LEVEL_SSL,   1, E_MODEL_R96_WARIO_KOOPA_COIN,   id_bhvSixGoldenCoin, -2052,  1830, -1021, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 3 end)
r96lib.add_spawn(LEVEL_DDD,   2, E_MODEL_R96_WARIO_MARIO_COIN,   id_bhvSixGoldenCoin,  5025, -3681, -1430, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 4 end)
r96lib.add_spawn(LEVEL_COTMC, 1, E_MODEL_R96_WARIO_TREE_COIN,    id_bhvSixGoldenCoin,     7,  -143,  2141, 0, 0, 0, false, nil, function(o) o.oBehParams2ndByte = 5 end)
