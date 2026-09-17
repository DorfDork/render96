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
#include "levels/bowser_1/header.h"

/* Fast64 begin persistent block [scripts] */
/* Fast64 end persistent block [scripts] */

const LevelScript level_bowser_1_entry[] = {
	INIT_LEVEL(),
	LOAD_MIO0(0x7, _bowser_1_segment_7SegmentRomStart, _bowser_1_segment_7SegmentRomEnd), 
	LOAD_MIO0(0xa, _bidw_skybox_mio0SegmentRomStart, _bidw_skybox_mio0SegmentRomEnd), 
	ALLOC_LEVEL_POOL(),
	MARIO(MODEL_MARIO, 0x00000001, bhvMario), 
	/* Fast64 begin persistent block [level commands] */
	/* Fast64 end persistent block [level commands] */

	AREA(1, bowser_1_area_1),
		WARP_NODE(0x0A, LEVEL_BOWSER_1, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF0, LEVEL_CASTLE, 0x01, 0x24, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF1, LEVEL_BITDW, 0x01, 0x0C, WARP_NO_CHECKPOINT),
		MARIO_POS(0x01, -180, 0, 1307, 0),
		OBJECT(MODEL_NONE, 0, 1307, 0, 0, -180, 0, (0x0A << 16), bhvSpinAirborneCircleWarp),
		OBJECT(E_MODEL_BOWSER, 0, 300, -1000, 0, 0, 0, 0x00000000, bhvBowser),
		OBJECT(E_MODEL_BOWSER_BOMB, 2791, 589, 0, 0, 0, 0, 0x00000000, bhvBowserBomb),
		OBJECT(E_MODEL_BOWSER_BOMB, -2791, 589, 0, 0, 0, 0, 0x00000000, bhvBowserBomb),
		OBJECT(E_MODEL_BOWSER_BOMB, 0, 589, 2791, 0, 0, 0, 0x00000000, bhvBowserBomb),
		OBJECT(E_MODEL_BOWSER_BOMB, 0, 589, -2791, 0, 0, 0, 0x00000000, bhvBowserBomb),
		TERRAIN(bowser_1_area_1_collision),
		MACRO_OBJECTS(bowser_1_area_1_macro_objs),
		SET_BACKGROUND_MUSIC(0x00, SEQ_LEVEL_BOSS_KOOPA),
		TERRAIN_TYPE(TERRAIN_STONE),
		/* Fast64 begin persistent block [area commands] */
		/* Fast64 end persistent block [area commands] */
	END_AREA(),
	FREE_LEVEL_POOL(),
	MARIO_POS(0x01, -180, 0, 1307, 0),
	CALL(0, lvl_init_or_update),
	CALL_LOOP(1, lvl_init_or_update),
	CLEAR_LEVEL(),
	SLEEP_BEFORE_EXIT(1),
	EXIT(),
};