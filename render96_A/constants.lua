-- Makes everything defined in this file visible to _G (xLuigiGamerx)
_ENV = _G

-- Truth table (Cooliokid)
T = function (l) local t = {} for _, v in ipairs(l) do t[v] = true end return t end

-------------
-- Actions --
-------------

-- Mario --
ACT_R96_MILK_GROW   = allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_STATIONARY | ACT_FLAG_INTANGIBLE)
ACT_R96_MILK_SHRINK = allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_STATIONARY | ACT_FLAG_INTANGIBLE)

-- Luigi --
ACT_R96_LUIGI_SCUTTLE_RUN      = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_R96_LUIGI_SCUTTLE_RUN_HOLD = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_R96_LUIGI_BACKFLIP         = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_R96_LUIGI_TWIRLING         = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_SWIMMING_OR_FLYING)
ACT_R96_LUIGI_TWIRLING_DOWN    = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_SWIMMING_OR_FLYING)

-- Wario --
ACT_R96_WARIO_CHARGE             = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_R96_WARIO_TRIPLE_JUMP        = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_R96_WARIO_HOLD_IDLE          = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_PAUSE_EXIT)
ACT_R96_WARIO_HOLD_HEAVY_IDLE    = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_PAUSE_EXIT)
ACT_R96_WARIO_HOLD_WALKING       = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_R96_WARIO_HOLD_HEAVY_WALKING = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_R96_WARIO_HOLD_JUMP          = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_R96_WARIO_HOLD_HEAVY_JUMP    = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_R96_WARIO_HOLD_FREEFALL      = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_R96_WARIO_HOLD_DECELERATING  = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_R96_WARIO_PILE_DRIVER        = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_R96_WARIO_PILE_DRIVER_LAND   = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_R96_WARIO_SWING_FLING_START  = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_R96_WARIO_SWING_FLING_HELD   = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_R96_WARIO_SWING_FLING_THROW  = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_R96_WARIO_GROUND_POUND       = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING)

-- Bananaman --
ACT_R96_BANANAMAN_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

-- Yoshi --
ACT_R96_YOSHI_RIDE_IDLE    = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_IDLE)
ACT_R96_YOSHI_RIDE_WALK    = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_R96_YOSHI_RIDE_JUMP    = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_R96_YOSHI_RIDE_FLUTTER = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_R96_YOSHI_RIDE_FALL    = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_MOVING)

------------
-- Models --
------------

E_MODEL_R96_GOOMBA_SSL                = smlua_model_util_get_id("goomba_ssl_geo")
E_MODEL_R96_GOOMBA_BOXART             = smlua_model_util_get_id("goomba_boxart_geo")
E_MODEL_R96_GOOMBA_UNDERGROUND        = smlua_model_util_get_id("goomba_underground_geo")
E_MODEL_R96_MARTY                     = smlua_model_util_get_id("marty_geo")
E_MODEL_R96_KOOPA_QUICK_BOB           = smlua_model_util_get_id("koopa_quick_bob_geo")
E_MODEL_R96_KOOPA_QUICK_THI           = smlua_model_util_get_id("koopa_quick_thi_geo")
E_MODEL_R96_WHOMP_KING                = smlua_model_util_get_id("whomp_king_geo")
E_MODEL_R96_PIRANHA_PLANT_FIRE        = smlua_model_util_get_id("piranha_plant_fire_geo")
E_MODEL_R96_BLARGG_FRIENDLY           = smlua_model_util_get_id("blargg_friendly_geo")
E_MODEL_R96_PENGUIN_BABY              = smlua_model_util_get_id("penguin_baby_geo")
E_MODEL_R96_PENGUIN_RACER             = smlua_model_util_get_id("penguin_racer_geo")
E_MODEL_R96_PENGUIN_SL                = smlua_model_util_get_id("penguin_sl_geo")
E_MODEL_R96_BOO_KING                  = smlua_model_util_get_id("boo_king_geo")
E_MODEL_R96_BOO_BIG                   = smlua_model_util_get_id("boo_big_geo")
E_MODEL_R96_BULLY_BIG                 = smlua_model_util_get_id("bully_big_geo")
E_MODEL_R96_GRINDLE                   = smlua_model_util_get_id("grindle_geo")
E_MODEL_R96_LUIGI_KEY                 = smlua_model_util_get_id("boo_key_geo")
E_MODEL_R96_SPINDLE                   = smlua_model_util_get_id("spindle_geo")
E_MODEL_R96_STAR_PARTICLE             = smlua_model_util_get_id("star_particle_geo")
E_MODEL_R96_STAR_TRANSPARENT_PARTICLE = smlua_model_util_get_id("star_particle_transparent_geo")
E_MODEL_R96_WARIO_HEAD                = smlua_model_util_get_id("wario_head_geo")
E_MODEL_R96_WARIO_PUMPKIN_COIN        = smlua_model_util_get_id("golden_coin_pumpkin_geo")
E_MODEL_R96_WARIO_HOUSE_COIN          = smlua_model_util_get_id("golden_coin_house_geo")
E_MODEL_R96_WARIO_TREE_COIN           = smlua_model_util_get_id("golden_coin_tree_geo")
E_MODEL_R96_WARIO_KOOPA_COIN          = smlua_model_util_get_id("golden_coin_koopa_geo")
E_MODEL_R96_WARIO_LUNAR_COIN          = smlua_model_util_get_id("golden_coin_lunar_geo")
E_MODEL_R96_WARIO_MARIO_COIN          = smlua_model_util_get_id("golden_coin_mario_geo")
E_MODEL_R96_WARP_PIPE_LOCKED          = smlua_model_util_get_id("warp_pipe_locked_geo")
E_MODEL_R96_WARP_PIPE_UNLOCKED        = smlua_model_util_get_id("warp_pipe_unlocked_geo")
E_MODEL_R96_SIGN_ON_WALL              = smlua_model_util_get_id("sign_on_wall_geo")
E_MODEL_R96_STAR_DOOR                 = smlua_model_util_get_id("star_door_geo")
E_MODEL_R96_TOXBOX                    = smlua_model_util_get_id("toxbox_geo")
E_MODEL_R96_CAP_SWITCH_BASE_HD        = smlua_model_util_get_id("cap_switch_base_geo")
E_MODEL_R96_FIRE_SPITTER              = smlua_model_util_get_id("fire_spitter_geo")
E_MODEL_R96_GREEN_COIN                = smlua_model_util_get_id("green_coin_geo")
E_MODEL_R96_GREEN_COIN_NO_SHADOW      = smlua_model_util_get_id("green_coin_no_shadow_geo")
E_MODEL_R96_MANTA                     = smlua_model_util_get_id("manta_geo")
E_MODEL_R96_YOSHI_RIDEABLE            = smlua_model_util_get_id("yoshi_geo")
E_MODEL_R96_STAR_DOOR_FRAME           = smlua_model_util_get_id("star_door_frame_geo")
E_MODEL_R96_RED_FLAME_TORCH           = smlua_model_util_get_id("red_flame_torch_geo")
E_MODEL_R96_BLUE_FLAME_TORCH          = smlua_model_util_get_id("blue_flame_torch_geo")
E_MODEL_R96_RED_FLAME_BBH_TORCH       = smlua_model_util_get_id("red_flame_torch_bbh_geo")
E_MODEL_R96_RED_FLAME_BOWSER          = smlua_model_util_get_id("red_flame_bowser_geo")
E_MODEL_R96_BLUE_FLAME_BOWSER         = smlua_model_util_get_id("blue_flame_bowser_geo")
E_MODEL_R96_EXCLAMATION_POINT_HD      = smlua_model_util_get_id("exclamation_box_point_hd_geo")
E_MODEL_R96_BBH_COFFIN                = smlua_model_util_get_id("bbh_coffin_geo")
E_MODEL_R96_SNOWMAN_HEAD              = smlua_model_util_get_id("ccm_snowman_head_geo")
E_MODEL_R96_SNOWMAN_BODY              = smlua_model_util_get_id("ccm_snowman_body_geo")
E_MODEL_R96_YOSHI_TONGUE              = smlua_model_util_get_id("yoshi_tongue_geo")
E_MODEL_R96_POKEY_HEAD_BOXART         = smlua_model_util_get_id("pokey_head_boxart_geo")
E_MODEL_R96_POKEY_BODY_PART_BOXART    = smlua_model_util_get_id("pokey_body_part_boxart_geo")
E_MODEL_R96_KUG                       = smlua_model_util_get_id("kug_geo")

------------
-- Levels --
------------

LEVEL_R96_INNER_WORKINGS = level_register("level_inner_workings_entry", COURSE_NONE, "Inner Workings", "inner_workings", 28000, 0x28, 0x28, 0x28)

----------------
-- Animations --
----------------

-- Mario --
CHAR_ANIM_R96_MARIO_MILK_RUNNING         = "mario_milk_run"
CHAR_ANIM_R96_MARIO_MILK_RUNNING_FUNNY   = "mario_milk_run_funny"
CHAR_ANIM_R96_MARIO_RUNNING_FAST         = "tanooki_fast"
CHAR_ANIM_R96_MARIO_RIDING_YOSHI_IDLE    = "MARIO_RIDING_YOSHI_IDLE"
CHAR_ANIM_R96_MARIO_RIDING_YOSHI_RUN     = "MARIO_RIDING_YOSHI_RUN"
CHAR_ANIM_R96_MARIO_RIDING_YOSHI_JUMP    = "MARIO_RIDING_YOSHI_JUMP"
CHAR_ANIM_R96_MARIO_RIDING_YOSHI_FLUTTER = "MARIO_RIDING_YOSHI_FLUTTER"
CHAR_ANIM_R96_MARIO_RIDING_YOSHI_FALL    = "MARIO_RIDING_YOSHI_FALL"

-- Wario --
CHAR_ANIM_R96_WARIO_WALK_WITH_LIGHT_OBJ                  = "dorf_grab_light_run_loop_16"
CHAR_ANIM_R96_WARIO_RUN_WITH_LIGHT_OBJ                   = "dorf_grab_light_run_loop_16"
CHAR_ANIM_R96_WARIO_SLOW_WALK_WITH_LIGHT_OBJ             = "dorf_grab_light_run_loop_16"
CHAR_ANIM_R96_WARIO_IDLE_WITH_LIGHT_OBJ                  = "dorf_grab_light_idle_loop_3F"
CHAR_ANIM_R96_WARIO_JUMP_LAND_WITH_LIGHT_OBJ             = "dorf_grab_light_jump_land_40"
CHAR_ANIM_R96_WARIO_JUMP_WITH_LIGHT_OBJ                  = "dorf_grab_light_jump_41"
CHAR_ANIM_R96_WARIO_FALL_LAND_WITH_LIGHT_OBJ             = "dorf_grab_light_slide_stand_46"
CHAR_ANIM_R96_WARIO_FALL_WITH_LIGHT_OBJ                  = "dorf_grab_light_slide_fall_44"
CHAR_ANIM_R96_WARIO_FALL_FROM_SLIDING_WITH_LIGHT_OBJ     = "dorf_grab_light_slide_fall_44"
CHAR_ANIM_R96_WARIO_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ     = "dorf_grab_light_slide_45"
CHAR_ANIM_R96_WARIO_STAND_UP_FROM_SLIDING_WITH_LIGHT_OBJ = "dorf_grab_light_slide_stand_46"
CHAR_ANIM_R96_WARIO_THROW_LIGHT_OBJECT                   = "dorf_grab_light_throw_52"
CHAR_ANIM_R96_WARIO_GROUND_THROW                         = "dorf_grab_light_throw_ground_65"
CHAR_ANIM_R96_WARIO_PICK_UP_LIGHT_OBJ                    = "dorf_grab_light_pickup_6B"
CHAR_ANIM_R96_WARIO_PLACE_LIGHT_OBJ                      = "dorf_grab_light_throw_ground_65"
CHAR_ANIM_R96_WARIO_STOP_SLIDE_LIGHT_OBJ                 = "dorf_grab_light_bellyflop_stand_8B"

-- Yoshi --
ANIM_R96_YOSHI_RIDEABLE_IDLE            = "yoshi_ridable_idle_4"
ANIM_R96_YOSHI_RIDEABLE_RUN             = "yoshi_ridable_run_5"
ANIM_R96_YOSHI_RIDEABLE_FLUTTER         = "yoshi_ridable_flutter_6"
ANIM_R96_YOSHI_RIDEABLE_FLUTTER_FALL    = "yoshi_ridable_flutter_fall_7"
ANIM_R96_YOSHI_RIDEABLE_FLUTTER_LAND    = "yoshi_ridable_flutter_fall_land_8"
ANIM_R96_YOSHI_RIDEABLE_JUMP            = "yoshi_ridable_jump_9"
ANIM_R96_YOSHI_RIDEABLE_JUMP_FALL       = "yoshi_ridable_jump_fall_10"
ANIM_R96_YOSHI_RIDEABLE_JUMP_LAND       = "yoshi_ridable_jump_fall_land_11"
ANIM_R96_YOSHI_RIDEABLE_EAT             = "yoshi_ridable_eat_12"
ANIM_R96_YOSHI_RIDEABLE_IDLE_TRANSITION = "yoshi_idle_to_ridable_idle_3"
ANIM_R96_YOSHI_FLUTTER                  = "YOSHI_FLUTTER"
ANIM_R96_YOSHI_FALL                     = "YOSHI_FALL"
ANIM_R96_YOSHI_FALL_STATIC              = "YOSHI_FALL_STATIC"

-- Objects --
ANIM_R96_BUBBA_SWIM    = "bubba_swim"
ANIM_R96_MR_I_IDLE     = "mr_i_idle"
ANIM_R96_STAR_GLOW     = "star_glow"
ANIM_R96_BLARGG_SWIM   = 0 -- vanilla anims: blargg_seg5_anims_0500616C
ANIM_R96_BLARGG_ATTACK = 1 -- vanilla anims: blargg_seg5_anims_0500616C

-----------
-- Audio --
-----------

AUDIO_R96_STAR_AMBIENT        = audio_stream_load("event_star_ambient.mp3")
AUDIO_R96_GOT_MILK_POWERUP    = audio_stream_load("event_got_milk_powerup.mp3")
AUDIO_R96_GOT_MILK_SONG       = audio_stream_load("event_got_milk.mp3")
AUDIO_R96_BOO_PIPE_RED        = audio_stream_load("event_mario_musicbox.mp3")
AUDIO_R96_BOO_PIPE_GREEN      = audio_stream_load("event_luigi_musicbox.mp3")
AUDIO_R96_BOO_PIPE_YELLOW     = audio_stream_load("event_wario_musicbox.mp3")
AUDIO_R96_EVENT_SHELL_THROWN  = audio_stream_load("event_shell.mp3")
AUDIO_R96_EVENT_THROWN        = audio_stream_load("event_thrown.ogg")
AUDIO_R96_COLLECTABLE         = audio_stream_load("event_collectible_grab.mp3")
AUDIO_R96_INNER_WORKINGS_SONG = audio_stream_load("level_fourth_floor.mp3")
AUDIO_R96_WARIO_HEAD_FUN      = audio_stream_load("event_wario_head_fun.mp3")
AUDIO_R96_WARIO_HEAD_BITE     = audio_stream_load("event_wario_head_yell.mp3")
AUDIO_R96_WARIO_HEAD_LAUGH    = audio_stream_load("event_wario_head_yell.mp3")
AUDIO_R96_WARIO_HEAD_YELL     = audio_stream_load("event_wario_head_yell.mp3")

-------------
-- Objects --
-------------

OBJ_ACT_INSTANT_DEATH = 999

-- Goomba --
R96_GOOMBA_ACT_STUN = 3
R96_GOOMBA_ACT_GRAB = 104 -- must be higher than 102

-- Blargg --
R96_BLARGG_ACT_SWIM      = 0
R96_BLARGG_ACT_CHASE     = 1
R96_BLARGG_ACT_KNOCKBACK = 2
R96_BLARGG_ACT_BACKUP    = 3

-- Koopa shell --
R96_KOOPA_SHELL_ACT_GRAB = 3

-- Mr. I --
R96_MR_I_ACT_IDLE   = 0
R96_MR_I_ACT_ATTACK = 1
R96_MR_I_ACT_DIZZY  = 2
R96_MR_I_ACT_DEAD   = 3

-- Yoshi tongue --
R96_YOSHI_TONGUE_ACT_EXTENDING  = 0
R96_YOSHI_TONGUE_ACT_LATCHED    = 1
R96_YOSHI_TONGUE_ACT_RETRACTING = 2
