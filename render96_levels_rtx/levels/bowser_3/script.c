#include <ultra64.h>
#include "sm64.h"
#include "behavior_data.h"
#include "model_ids.h"
#include "seq_ids.h"
#include "dialog_ids.h"
#include "segment_symbols.h"
#include "level_commands.h"

#include "game/level_update.h"

#include "levels/scripts.h"

#include "make_const_nonconst.h"
#include "levels/bowser_3/header.h"

/* Fast64 begin persistent block [scripts] */
/* Fast64 end persistent block [scripts] */

const LevelScript level_bowser_3_entry[] = {
	INIT_LEVEL(),
	LOAD_MIO0(0x7, _bowser_3_segment_7SegmentRomStart, _bowser_3_segment_7SegmentRomEnd), 
	LOAD_MIO0(0xb, _effect_mio0SegmentRomStart, _effect_mio0SegmentRomEnd), 
	LOAD_MIO0(0xa, _bits_skybox_mio0SegmentRomStart, _bits_skybox_mio0SegmentRomEnd), 
	LOAD_MIO0(0x6, _group12_mio0SegmentRomStart, _group12_mio0SegmentRomEnd), 
	LOAD_RAW(0xd, _group12_geoSegmentRomStart, _group12_geoSegmentRomEnd), 
	ALLOC_LEVEL_POOL(),
	MARIO(MODEL_MARIO, 0x00000001, bhvMario), 
    JUMP_LINK(script_func_global_13),
	/* Fast64 begin persistent block [level commands] */
	/* Fast64 end persistent block [level commands] */

	AREA(1, bowser_3_area_1),
		WARP_NODE(0x0A, LEVEL_BOWSER_3, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF1, LEVEL_BITS, 0x01, 0x0C, WARP_NO_CHECKPOINT),
		MARIO_POS(0x01, 180, 0, 1307, 0),
		OBJECT(MODEL_NONE, 0, 1307, 0, 0, 0, 0, (0x0A << 16), bhvSpinAirborneCircleWarp),
		OBJECT(E_MODEL_BOWSER, 13, 307, 1024, 0, -180, 0, (1 << 16), bhvBowser),
		OBJECT(E_MODEL_BOWSER_BOMB, 2123, 512, -2912, 0, 0, 0, 0x00000000, bhvBowserBomb),
		OBJECT(E_MODEL_BOWSER_BOMB, -2122, 512, -2912, 0, 0, 0, 0x00000000, bhvBowserBomb),
		OBJECT(E_MODEL_BOWSER_BOMB, -3362, 512, 1121, 0, 0, 0, 0x00000000, bhvBowserBomb),
		OBJECT(E_MODEL_BOWSER_BOMB, 0, 512, 3584, 0, 0, 0, 0x00000000, bhvBowserBomb),
		OBJECT(E_MODEL_BOWSER_BOMB, 3362, 512, 1126, 0, 0, 0, 0x00000000, bhvBowserBomb),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_1, 0, 0, 0, 0, 0, 0, (1 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_10, 0, 0, 0, 0, 0, 0, (10 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_2, 0, 0, 0, 0, 0, 0, (2 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_3, 0, 0, 0, 0, 0, 0, (3 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_4, 0, 0, 0, 0, 0, 0, (4 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_5, 0, 0, 0, 0, 0, 0, (5 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_6, 0, 0, 0, 0, 0, 0, (6 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_7, 0, 0, 0, 0, 0, 0, (7 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_8, 0, 0, 0, 0, 0, 0, (8 << 16), bhvFallingBowserPlatform),
		OBJECT(E_MODEL_BOWSER_3_FALLING_PLATFORM_9, 0, 0, 0, 0, 0, 0, (9 << 16), bhvFallingBowserPlatform),
		TERRAIN(bowser_3_area_1_collision),
		MACRO_OBJECTS(bowser_3_area_1_macro_objs),
		SET_BACKGROUND_MUSIC(0x00, SEQ_LEVEL_BOSS_KOOPA_FINAL),
		TERRAIN_TYPE(TERRAIN_STONE),
		/* Fast64 begin persistent block [area commands] */
		/* Fast64 end persistent block [area commands] */
	END_AREA(),
	FREE_LEVEL_POOL(),
	MARIO_POS(0x01, 180, 0, 1307, 0),
	CALL(0, lvl_init_or_update),
	CALL_LOOP(1, lvl_init_or_update),
	CLEAR_LEVEL(),
	SLEEP_BEFORE_EXIT(1),
	EXIT(),
};