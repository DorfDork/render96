-- Acts
ACT_MILK_GROW                   = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)
ACT_MILK_SHRINK                 = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)
ACT_LUIGI_SCUTTLE_RUN           = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_GROUP_AIRBORNE)
ACT_LUIGI_SCUTTLE_RUN_HOLD      = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_GROUP_AIRBORNE)
ACT_LUIGI_BACKFLIP              = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_AIR | ACT_GROUP_AIRBORNE | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_LUIGI_TWIRLING              = allocate_mario_action(ACT_FLAG_AIR | ACT_GROUP_AIRBORNE | ACT_FLAG_ATTACKING | ACT_FLAG_SWIMMING_OR_FLYING)
ACT_LUIGI_TWIRLING_DOWN         = allocate_mario_action(ACT_FLAG_AIR | ACT_GROUP_AIRBORNE | ACT_FLAG_ATTACKING | ACT_FLAG_SWIMMING_OR_FLYING)
ACT_WARIO_CHARGE                = allocate_mario_action(ACT_FLAG_MOVING | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_TRIPLE_JUMP           = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_IDLE             = allocate_mario_action(0x007 | ACT_FLAG_STATIONARY | ACT_FLAG_PAUSE_EXIT)
ACT_WARIO_HOLD_HEAVY_IDLE       = allocate_mario_action(0x008 | ACT_FLAG_STATIONARY | ACT_FLAG_PAUSE_EXIT)
ACT_WARIO_HOLD_WALKING          = allocate_mario_action(0x042 | ACT_FLAG_MOVING)
ACT_WARIO_HOLD_HEAVY_WALKING    = allocate_mario_action(0x047 | ACT_FLAG_MOVING)
ACT_WARIO_HOLD_JUMP             = allocate_mario_action(0x0A0 | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_HEAVY_JUMP       = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_FREEFALL         = allocate_mario_action(0x0A1 | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_WARIO_HOLD_DECELERATING     = allocate_mario_action(0x04B | ACT_FLAG_MOVING)
ACT_WARIO_PILE_DRIVER           = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_PILE_DRIVER_LAND      = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_START     = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_HELD      = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_THROW     = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_GROUND_POUND          = allocate_mario_action(ACT_GROUP_AIRBORNE |ACT_FLAG_AIR | ACT_FLAG_ATTACKING)

-- Rideable Yoshi: description: Run around with a Yoshi friend with this mod. Original mod by steven, edited by DorfDork
ACT_YOSHI_RIDE_IDLE     = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_IDLE)
ACT_YOSHI_RIDE_WALK     = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_YOSHI_RIDE_JUMP     = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_YOSHI_RIDE_FLUTTER  = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_YOSHI_RIDE_FALL     = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_MOVING)

-- Models
E_MODEL_GOOMBA_SSL                  = smlua_model_util_get_id("goomba_ssl_geo")
E_MODEL_GOOMBA_BOXART               = smlua_model_util_get_id("goomba_boxart_geo")
E_MODEL_MARTY                       = smlua_model_util_get_id("marty_geo")
E_MODEL_GOOMBA_UNDERGROUND          = smlua_model_util_get_id("goomba_underground_geo")
E_MODEL_KOOPA_QUICK_BOB             = smlua_model_util_get_id("koopa_quick_bob_geo")
E_MODEL_KOOPA_QUICK_THI             = smlua_model_util_get_id("koopa_quick_thi_geo")
E_MODEL_WHOMP_KING                  = smlua_model_util_get_id("whomp_king_geo")
E_MODEL_PIRANHA_PLANT_FIRE          = smlua_model_util_get_id("piranha_plant_fire_geo")
E_MODEL_BLARGG_FRIENDLY             = smlua_model_util_get_id("blargg_friendly_geo")
E_MODEL_PENGUIN_BABY                = smlua_model_util_get_id("penguin_baby_geo")
E_MODEL_PENGUIN_RACER               = smlua_model_util_get_id("penguin_racer_geo")
E_MODEL_PENGUIN_SL                  = smlua_model_util_get_id("penguin_sl_geo")
E_MODEL_BOO_KING                    = smlua_model_util_get_id("boo_king_geo")
E_MODEL_BOO_BIG                     = smlua_model_util_get_id("boo_big_geo")
E_MODEL_BULLY_BIG                   = smlua_model_util_get_id("bully_big_geo")
E_MODEL_GRINDLE                     = smlua_model_util_get_id("grindle_geo")
E_MODEL_LUIGI_KEY                   = smlua_model_util_get_id("boo_key_geo")
E_MODEL_SPINDLE                     = smlua_model_util_get_id("spindle_geo")
E_MODEL_STAR_PARTICLE               = smlua_model_util_get_id("star_particle_geo")
E_MODEL_STAR_TRANSPARENT_PARTICLE   = smlua_model_util_get_id("star_particle_transparent_geo")
E_MODEL_WARIO_HEAD                  = smlua_model_util_get_id("wario_head_geo")
E_MODEL_WARIO_PUMPKIN_COIN          = smlua_model_util_get_id("golden_coin_pumpkin_geo")
E_MODEL_WARIO_HOUSE_COIN            = smlua_model_util_get_id("golden_coin_house_geo")
E_MODEL_WARIO_TREE_COIN             = smlua_model_util_get_id("golden_coin_tree_geo")
E_MODEL_WARIO_KOOPA_COIN            = smlua_model_util_get_id("golden_coin_koopa_geo")
E_MODEL_WARIO_LUNAR_COIN            = smlua_model_util_get_id("golden_coin_lunar_geo")
E_MODEL_WARIO_MARIO_COIN            = smlua_model_util_get_id("golden_coin_mario_geo")
E_MODEL_WARP_PIPE_LOCKED            = smlua_model_util_get_id("warp_pipe_locked_geo")
E_MODEL_WARP_PIPE_UNLOCKED          = smlua_model_util_get_id("warp_pipe_unlocked_geo")
E_MODEL_SIGN_ON_WALL                = smlua_model_util_get_id("sign_on_wall_geo")
E_MODEL_STAR_DOOR                   = smlua_model_util_get_id("star_door_geo")
E_MODEL_TOXBOX                      = smlua_model_util_get_id("toxbox_geo")
E_MODEL_CAP_SWITCH_BASE_HD          = smlua_model_util_get_id("cap_switch_base_geo")
E_MODEL_FIRE_SPITTER                = smlua_model_util_get_id("fire_spitter_geo")
E_MODEL_GREEN_COIN                  = smlua_model_util_get_id("green_coin_geo")
E_MODEL_GREEN_COIN_NO_SHADOW        = smlua_model_util_get_id("green_coin_no_shadow_geo")
E_MODEL_MANTA                       = smlua_model_util_get_id("manta_geo")
E_MODEL_YOSHI_RIDEABLE              = smlua_model_util_get_id("yoshi_geo")
E_MODEL_STAR_DOOR_FRAME             = smlua_model_util_get_id("star_door_frame_geo")
E_MODEL_RED_FLAME_TORCH             = smlua_model_util_get_id("red_flame_torch_geo")
E_MODEL_BLUE_FLAME_TORCH            = smlua_model_util_get_id("blue_flame_torch_geo")
E_MODEL_RED_FLAME_BBH_TORCH         = smlua_model_util_get_id("red_flame_torch_bbh_geo")
E_MODEL_RED_FLAME_BOWSER            = smlua_model_util_get_id("red_flame_bowser_geo")
E_MODEL_BLUE_FLAME_BOWSER           = smlua_model_util_get_id("blue_flame_bowser_geo")
E_MODEL_EXCLAMATION_POINT_HD        = smlua_model_util_get_id("exclamation_box_point_hd_geo")
E_MODEL_BBH_COFFIN                  = smlua_model_util_get_id("bbh_coffin_geo")
E_MODEL_SNOWMAN_HEAD                = smlua_model_util_get_id("ccm_snowman_head_geo")
E_MODEL_SNOWMAN_BODY                = smlua_model_util_get_id("ccm_snowman_body_geo")
E_MODEL_YOSHI_TONGUE                = smlua_model_util_get_id("yoshi_tongue_geo")
E_MODEL_POKEY_HEAD_BOXART           = smlua_model_util_get_id("pokey_head_boxart_geo")
E_MODEL_POKEY_BODY_PART_BOXART      = smlua_model_util_get_id("pokey_body_part_boxart_geo")

-- Levels
LEVEL_INNER_WORKINGS = level_register("level_inner_workings_entry", COURSE_NONE, "Inner Workings", "inner_workings", 28000, 0x28, 0x28, 0x28)

-- Anims
CHAR_ANIM_MILK_RUNNING = 'mario_milk_run'
CHAR_ANIM_RUNNING_FAST = 'tanooki_fast'
sWarioGrabLightAnims = {
    [CHAR_ANIM_WALK_WITH_LIGHT_OBJ]                  = 'dorf_grab_light_run_loop_16',
    [CHAR_ANIM_RUN_WITH_LIGHT_OBJ]                   = 'dorf_grab_light_run_loop_16',
    [CHAR_ANIM_SLOW_WALK_WITH_LIGHT_OBJ]             = 'dorf_grab_light_run_loop_16',
    [CHAR_ANIM_IDLE_WITH_LIGHT_OBJ]                  = 'dorf_grab_light_idle_loop_3F',
    [CHAR_ANIM_JUMP_LAND_WITH_LIGHT_OBJ]             = 'dorf_grab_light_jump_land_40',
    [CHAR_ANIM_JUMP_WITH_LIGHT_OBJ]                  = 'dorf_grab_light_jump_41',
    [CHAR_ANIM_FALL_LAND_WITH_LIGHT_OBJ]             = 'dorf_grab_light_slide_stand_46',--
    [CHAR_ANIM_FALL_WITH_LIGHT_OBJ]                  = 'dorf_grab_light_slide_fall_44',--
    [CHAR_ANIM_FALL_FROM_SLIDING_WITH_LIGHT_OBJ]     = 'dorf_grab_light_slide_fall_44',
    [CHAR_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ]     = 'dorf_grab_light_slide_45',
    [CHAR_ANIM_STAND_UP_FROM_SLIDING_WITH_LIGHT_OBJ] = 'dorf_grab_light_slide_stand_46',
    [CHAR_ANIM_THROW_LIGHT_OBJECT]                   = 'dorf_grab_light_throw_52',
    [CHAR_ANIM_GROUND_THROW]                         = 'dorf_grab_light_throw_ground_65',
    [CHAR_ANIM_PICK_UP_LIGHT_OBJ]                    = 'dorf_grab_light_pickup_6B',
    [CHAR_ANIM_PLACE_LIGHT_OBJ]                      = 'dorf_grab_light_throw_ground_65',
    [CHAR_ANIM_STOP_SLIDE_LIGHT_OBJ]                 = 'dorf_grab_light_bellyflop_stand_8B',
}

sMarioFaceDefaultIdle = {
    [ACT_IDLE] = true,
    [ACT_HOLD_IDLE] = true,
    [ACT_HOLD_HEAVY_IDLE] = true,
    [ACT_CRAWLING] = true,
    [ACT_WALKING] = true,
    [ACT_HOLD_WALKING] = true,
    [ACT_HOLD_HEAVY_WALKING] = true,
    [ACT_LONG_JUMP_LAND] = true,
    [ACT_JUMP_LAND] = true,
    [ACT_JUMP_LAND_STOP] = true,
    [ACT_DOUBLE_JUMP_LAND] = true,
    [ACT_DOUBLE_JUMP_LAND_STOP] = true,
}

sMarioFaceDefaultOther = {
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_DEATH_EXIT] = true,
    [ACT_DEATH_EXIT_LAND] = true,
    [ACT_DEATH_ON_STOMACH] = true,
    [ACT_DEATH_ON_BACK] = true,
    [ACT_QUICKSAND_DEATH] = true,
    [ACT_ELECTROCUTION] = true,
    [ACT_SUFFOCATION] = true,
    [ACT_START_SLEEPING] = true,
}

sMarioFaceHappy = {
    [ACT_JUMP] = true,
    [ACT_TRIPLE_JUMP_LAND] = true,
    [ACT_TRIPLE_JUMP_LAND_STOP] = true,
    [ACT_BACKFLIP_LAND] = true,
    [ACT_BACKFLIP_LAND_STOP] = true,
}

sMarioFaceOpen = {
    [ACT_BURNING_GROUND] = true,
    [ACT_BURNING_JUMP] = true,
    [ACT_BURNING_FALL] = true,
    [ACT_LAVA_BOOST] = true,
    [ACT_LAVA_BOOST_LAND] = true,
}

sMarioEyeBlinkable = {
    [ACT_IDLE] = true,
    [ACT_HOLD_IDLE] = true,
    [ACT_HOLD_HEAVY_IDLE] = true,
    [ACT_JUMP_LAND] = true,
    [ACT_JUMP_LAND_STOP] = true,
    [ACT_DOUBLE_JUMP_LAND] = true,
    [ACT_DOUBLE_JUMP_LAND_STOP] = true,
    [ACT_END_PEACH_CUTSCENE] = true,
    [ACT_END_WAVING_CUTSCENE] = true,
}

sMarioEyeOpenWalking = {
    [ACT_WALKING] = true,
    [ACT_HOLD_WALKING] = true,
    [ACT_HOLD_HEAVY_WALKING] = true,
}

sMarioEyeHappy = {
    [ACT_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_TRIPLE_JUMP_LAND] = true,
    [ACT_TRIPLE_JUMP_LAND_STOP] = true,
    [ACT_BACKFLIP_LAND] = true,
    [ACT_BACKFLIP_LAND_STOP] = true,
}

sMarioEyeDead = {
    [ACT_BURNING_GROUND] = true,
    [ACT_BURNING_JUMP] = true,
    [ACT_BURNING_FALL] = true,
    [ACT_LAVA_BOOST] = true,
    [ACT_LAVA_BOOST_LAND] = true,
    [ACT_DEATH_EXIT] = true,
    [ACT_DEATH_EXIT_LAND] = true,
    [ACT_DEATH_ON_STOMACH] = true,
    [ACT_DEATH_ON_BACK] = true,
    [ACT_QUICKSAND_DEATH] = true,
    [ACT_ELECTROCUTION] = true,
    [ACT_SUFFOCATION] = true,
}

LIP_CLOSED = 0
LIP_A = 1
LIP_E = 2
LIP_O = 3

sPeachCutsceneDialog1 = {
    [181] = LIP_O,
    [231] = LIP_CLOSED,
    [234] = LIP_A,
    [238] = LIP_O,
    [239] = LIP_E,
    [242] = LIP_A,
    [243] = LIP_O,
    [264] = LIP_CLOSED,
    [291] = LIP_A, 
    [294] = LIP_CLOSED,
    [297] = LIP_A,
    [299] = LIP_O,
    [303] = LIP_A,
    [305] = LIP_CLOSED,
    [307] = LIP_A,
    [309] = LIP_E,
    [315] = LIP_A,
    [324] = LIP_E,
    [326] = LIP_A,
    [328] = LIP_E,
    [330] = LIP_A,
    [333] = LIP_E,
    [337] = LIP_O,
    [342] = LIP_A,
    [343] = LIP_CLOSED,
    [344] = LIP_O,
    [346] = LIP_A,
    [348] = LIP_CLOSED,
    [350] = LIP_A,
    [355] = LIP_E,
    [358] = LIP_A,
    [360] = LIP_E,
    [365] = LIP_CLOSED,
}

sPeachCutsceneDialog2 = {
    [27] = LIP_A,
    [30] = LIP_CLOSED,
    [31] = LIP_A,
    [34] = LIP_E,
    [36] = LIP_A,
    [39] = LIP_E,
    [44] = LIP_A,
    [48] = LIP_E,
    [51] = LIP_O,
    [55] = LIP_E,
    [57] = LIP_O,
    [66] = LIP_CLOSED,
    [77] = LIP_A,
    [83] = LIP_E,
    [85] = LIP_O,
    [87] = LIP_CLOSED,
    [89] = LIP_A,
    [92] = LIP_O,
    [93] = LIP_E,
    [97] = LIP_A,
    [98] = LIP_O,
    [105] = LIP_CLOSED,
    [129] = LIP_O,
    [131] = LIP_E,
    [136] = LIP_A,
    [140] = LIP_CLOSED,
    [142] = LIP_O,
    [144] = LIP_CLOSED,
    [145] = LIP_O,
    [147] = LIP_E,
    [149] = LIP_O,
    [152] = LIP_CLOSED,
    [154] = LIP_E,
    [156] = LIP_CLOSED,
    [158] = LIP_E,
    [162] = LIP_CLOSED,
    [163] = LIP_E,
    [168] = LIP_O,
    [170] = LIP_A,
    [172] = LIP_E,
    [174] = LIP_CLOSED,
    [175] = LIP_O,
    [177] = LIP_A,
    [179] = LIP_E,
    [181] = LIP_O,
    [191] = LIP_CLOSED,
}

sPeachCutsceneDialog3 = {
    [0] = LIP_A,
    [3] = LIP_E,
    [5] = LIP_A,
    [7] = LIP_E,
    [9] = LIP_A,
    [12] = LIP_CLOSED,
    [14] = LIP_E,
    [16] = LIP_CLOSED,
    [18] = LIP_O,
    [21] = LIP_A,
    [22] = LIP_E,
    [28] = LIP_CLOSED,
    [46] = LIP_E,
    [48] = LIP_A,
    [51] = LIP_E,
    [54] = LIP_CLOSED,
    [55] = LIP_A,
    [58] = LIP_E,
    [60] = LIP_CLOSED,
    [61] = LIP_A,
    [63] = LIP_CLOSED,
    [64] = LIP_A,
    [65] = LIP_O,
    [68] = LIP_A,
    [72] = LIP_O,
    [74] = LIP_A,
    [76] = LIP_E,
    [80] = LIP_A,
    [83] = LIP_E,
    [90] = LIP_CLOSED,
    [130] = LIP_A,
    [132] = LIP_O,
    [135] = LIP_CLOSED,
    [138] = LIP_A,
    [142] = LIP_O,
    [143] = LIP_E,
    [147] = LIP_A,
    [148] = LIP_O,
    [169] = LIP_CLOSED,
}


MARIO_LIP_CLOSED = 0
MARIO_LIP_A = 3
MARIO_LIP_E = 6
MARIO_LIP_O = 5

sMarioLipSwitchEndingKiss = {
    [76] = MARIO_LIP_O,
}

sMarioLipSwitchEndingHereWeGo = {
    [0] =   MARIO_LIP_CLOSED,
    [100] = MARIO_LIP_E,
    [104] = MARIO_LIP_A,
    [106] = MARIO_LIP_O,
    [108] = MARIO_LIP_E,
    [112] = MARIO_LIP_A,
    [115] = MARIO_LIP_O,
    [140] = MARIO_LIP_A,
}

YOSHI_ANIM_RIDABLE_IDLE         = 'yoshi_ridable_idle_4'
YOSHI_ANIM_RIDABLE_RUN          = 'yoshi_ridable_run_5'
YOSHI_ANIM_RIDABLE_FLUTTER      = 'yoshi_ridable_flutter_6'
YOSHI_ANIM_RIDABLE_FLUTTER_FALL = 'yoshi_ridable_flutter_fall_7'
YOSHI_ANIM_RIDABLE_FLUTTER_LAND = 'yoshi_ridable_flutter_fall_land_8'
YOSHI_ANIM_RIDABLE_JUMP         = 'yoshi_ridable_jump_9'
YOSHI_ANIM_RIDABLE_JUMP_FALL    = 'yoshi_ridable_jump_fall_10'
YOSHI_ANIM_RIDABLE_JUMP_LAND    = 'yoshi_ridable_jump_fall_land_11'
YOSHI_ANIM_RIDABLE_EAT          = 'yoshi_ridable_eat_12'

-- Extra content
gNumLuigiKeys = select(2, r96lib.load_render96_data("luigi_key"):gsub("1", ""))
gNumWarioCoins = select(2, r96lib.load_render96_data("wario_coin"):gsub("1", ""))

--gGlobalSyncTable
--gGlobalSyncTable.luigiKey1 = true WILL SYNC TO ALL CLIENTS
--gPlayerSyncTable[index]

-- Audio
STAR_AMBIENT        = audio_stream_load("event_star_ambient.mp3")
GOT_MILK_POWERUP    = audio_stream_load("event_got_milk_powerup.mp3")
GOT_MILK_SONG       = audio_stream_load("event_got_milk.mp3")
BOO_PIPE_RED        = audio_stream_load("event_mario_musicbox.mp3")
BOO_PIPE_GREEN      = audio_stream_load("event_luigi_musicbox.mp3")
BOO_PIPE_YELLOW     = audio_stream_load("event_wario_musicbox.mp3")
EVENT_SHELL_THROWN  = audio_stream_load("event_shell.mp3")
EVENT_THROWN        = audio_stream_load("event_thrown.ogg")
COLLECTABLE         = audio_stream_load("event_collectible_grab.mp3")
INNER_WORKINGS_SONG = audio_stream_load("level_fourth_floor.mp3")


-- oAction states
GOOMBA_ACT_STUN = 3
GOOMBA_ACT_GRAB = 4
BLARGG_MODE_SWIM = 0
BLARGG_MODE_CHASE = 1
BLARGG_MODE_KNOCKBACK = 2
BLARGG_MODE_BACKUP = 3
KOOPA_SHELL_ACT_GRAB = 3
MR_I_IDLE = 0
MR_I_ATTACK = 1
MR_I_DIZZY = 2
MR_I_DEAD = 3

-- Eye states
GOOMBA_EYE_OPEN = 0
GOOMBA_EYE_CLOSE = 1
GOOMBA_EYE_DAZED = 2
MR_I_OPEN = 0
MR_I_ALMOST_OPEN = 1
MR_I_HALF_OPEN = 2
MR_I_ALMOST_CLOSED = 3
MR_I_CLOSED = 4

-- Face states
GOOMBA_FACE_CLOSE = 0
GOOMBA_FACE_OPEN = 1
TWHOMP_FACE_BASE = 0
TWHOMP_FACE_ANGRY = 1
TWHOMP_FACE_URGH = 2

-- Anim states
BLARGG_ANIM_SWIM = 0
BLARGG_ANIM_ATK = 1

TONGUE_STATE_EXTENDING  = 0
TONGUE_STATE_LATCHED    = 1
TONGUE_STATE_RETRACTING = 2
TONGUE_EXTEND_FRAMES  = 8
TONGUE_RETRACT_FRAMES = 10
TONGUE_LATCH_HOLD     = 15
TONGUE_RADIUS         = 500.0
TONGUE_MODEL_LENGTH   = 40.0