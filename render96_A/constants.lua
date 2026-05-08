-- Acts
ACT_MILK_GROW = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)
ACT_MILK_SHRINK = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)
ACT_LUIGI_SCUTTLE_RUN = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_GROUP_AIRBORNE)
ACT_LUIGI_SCUTTLE_RUN_HOLD = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_GROUP_AIRBORNE)
ACT_LUIGI_BACKFLIP = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_AIR | ACT_GROUP_AIRBORNE | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_LUIGI_TWIRLING = allocate_mario_action(ACT_FLAG_AIR | ACT_GROUP_AIRBORNE | ACT_FLAG_ATTACKING | ACT_FLAG_SWIMMING_OR_FLYING)
ACT_WARIO_CHARGE = allocate_mario_action(ACT_FLAG_MOVING | ACT_FLAG_ATTACKING)
ACT_WARIO_TRIPLE_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_IDLE = allocate_mario_action(0x007 | ACT_FLAG_STATIONARY | ACT_FLAG_PAUSE_EXIT)
ACT_WARIO_HOLD_HEAVY_IDLE = allocate_mario_action(0x008 | ACT_FLAG_STATIONARY | ACT_FLAG_PAUSE_EXIT)
ACT_WARIO_HOLD_WALKING = allocate_mario_action(0x042 | ACT_FLAG_MOVING)
ACT_WARIO_HOLD_HEAVY_WALKING = allocate_mario_action(0x047 | ACT_FLAG_MOVING)
ACT_WARIO_HOLD_JUMP = allocate_mario_action(0x0A0 | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_HEAVY_JUMP = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_FREEFALL = allocate_mario_action(0x0A1 | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_WARIO_PILE_DRIVER = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_PILE_DRIVER_LAND = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_START = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_HELD = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_THROW = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_GROUND_POUND = allocate_mario_action(ACT_GROUP_AIRBORNE |ACT_FLAG_AIR | ACT_FLAG_ATTACKING)

-- Models
E_MODEL_KOOPA_QUICK_BOB = smlua_model_util_get_id("koopa_quick_bob_geo")
E_MODEL_WHOMP_KING = smlua_model_util_get_id("whomp_king_geo")
E_MODEL_PIRANHA_PLANT_FIRE = smlua_model_util_get_id("piranha_plant_fire_geo")
E_MODEL_BLARGG_FRIENDLY = smlua_model_util_get_id("blargg_friendly_geo")
E_MODEL_PENGUIN_BABY = smlua_model_util_get_id("penguin_baby_geo")
E_MODEL_PENGUIN_RACER = smlua_model_util_get_id("penguin_racer_geo")
E_MODEL_PENGUIN_SL = smlua_model_util_get_id("penguin_sl_geo")
E_MODEL_BOO_KING = smlua_model_util_get_id("boo_king_geo")
E_MODEL_BOO_BIG = smlua_model_util_get_id("boo_big_geo")
E_MODEL_BULLY_BIG = smlua_model_util_get_id("bully_big_geo")
E_MODEL_GRINDLE = smlua_model_util_get_id("grindle_geo")
E_MODEL_LUIGI_KEY = smlua_model_util_get_id("boo_key_geo")
E_MODEL_SPINDLE = smlua_model_util_get_id("spindle_geo")
E_MODEL_STAR_PARTICLE = smlua_model_util_get_id("star_particle_geo")
E_MODEL_STAR_TRANSPARENT_PARTICLE = smlua_model_util_get_id("star_particle_transparent_geo")
E_MODEL_WARIO_HEAD = smlua_model_util_get_id("wario_head_geo")
E_MODEL_WARIO_PUMPKIN_COIN = smlua_model_util_get_id("wario_coin_pumpkin_geo")
E_MODEL_WARIO_HOUSE_COIN = smlua_model_util_get_id("wario_coin_house_geo")
E_MODEL_WARIO_TREE_COIN = smlua_model_util_get_id("wario_coin_tree_geo")
E_MODEL_WARIO_KOOPA_COIN = smlua_model_util_get_id("wario_coin_koopa_geo")
E_MODEL_WARIO_LUNAR_COIN = smlua_model_util_get_id("wario_coin_lunar_geo")
E_MODEL_WARIO_MARIO_COIN = smlua_model_util_get_id("wario_coin_mario_geo")
E_MODEL_WARP_PIPE_BOO_BLUE = smlua_model_util_get_id("warp_pipe_boo_geo")
E_MODEL_WARP_PIPE_BOO_RED = smlua_model_util_get_id("warp_pipe_boo_red_geo")
E_MODEL_WARP_PIPE_BOO_GREEN_LOCKED = smlua_model_util_get_id("warp_pipe_boo_green_locked_geo")
E_MODEL_WARP_PIPE_BOO_GREEN_UNLOCKED = smlua_model_util_get_id("warp_pipe_boo_green_unlocked_geo")
E_MODEL_WARP_PIPE_BOO_YELLOW_LOCKED = smlua_model_util_get_id("warp_pipe_boo_yellow_locked_geo")
E_MODEL_WARP_PIPE_BOO_YELLOW_UNLOCKED = smlua_model_util_get_id("warp_pipe_boo_yellow_unlocked_geo")

-- Levels
LEVEL_FOURTH_FLOOR = level_register("level_fourth_floor_entry", COURSE_NONE, "Fourth Floor", "fourth_floor", 28000, 0x28, 0x28, 0x28)

-- Anims
CHAR_ANIM_MILK_RUNNING = 'mario_milk_run'

-- Extra content
gNumLuigiKeys = select(2, r96lib.load_render96_data("luigi_key"):gsub("1", ""))
gNumWarioCoins = select(2, r96lib.load_render96_data("wario_coin"):gsub("1", ""))

--gGlobalSyncTable
--gGlobalSyncTable.luigiKey1 = true WILL SYNC TO ALL CLIENTS
--gPlayerSyncTable[index]

-- Audio
STAR_AMBIENT = audio_stream_load("event_star_ambient.mp3")
GOT_MILK_POWERUP = audio_stream_load("event_got_milk_powerup.mp3")
GOT_MILK_SONG = audio_stream_load("event_got_milk.mp3")
BOO_PIPE_RED = audio_stream_load("event_mario_musicbox.mp3")
BOO_PIPE_GREEN = audio_stream_load("event_luigi_musicbox.mp3")
BOO_PIPE_YELLOW = audio_stream_load("event_wario_musicbox.mp3")
GOOMBA_SCREAM = audio_stream_load("event_goomba_scream.mp3")

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

