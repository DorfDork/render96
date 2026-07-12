const GeoLayout blue_flame_bowser_000_switch_opt1[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, blue_flame_bowser_000_displaylist_mesh_layer_4_mat_override_flame_blue_2_0),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout blue_flame_bowser_000_switch_opt2[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, blue_flame_bowser_000_displaylist_mesh_layer_4_mat_override_flame_blue_3_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout blue_flame_bowser_000_switch_opt3[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, blue_flame_bowser_000_displaylist_mesh_layer_4_mat_override_flame_blue_4_2),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout blue_flame_bowser_000_switch_opt4[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, blue_flame_bowser_000_displaylist_mesh_layer_4_mat_override_flame_blue_5_3),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout blue_flame_bowser_000_switch_opt5[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, blue_flame_bowser_000_displaylist_mesh_layer_4_mat_override_flame_blue_6_4),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout blue_flame_bowser_000_switch_opt6[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, blue_flame_bowser_000_displaylist_mesh_layer_4_mat_override_flame_blue_7_5),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout blue_flame_bowser_000_switch_opt7[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_ALPHA, blue_flame_bowser_000_displaylist_mesh_layer_4_mat_override_flame_blue_8_6),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout blue_flame_bowser_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_NODE_START(),
		GEO_OPEN_NODE(),
			GEO_SWITCH_CASE(8, geo_switch_anim_state),
			GEO_OPEN_NODE(),
				GEO_NODE_START(),
				GEO_OPEN_NODE(),
					GEO_DISPLAY_LIST(LAYER_ALPHA, blue_flame_bowser_000_displaylist_mesh_layer_4),
				GEO_CLOSE_NODE(),
				GEO_BRANCH(1, blue_flame_bowser_000_switch_opt1),
				GEO_BRANCH(1, blue_flame_bowser_000_switch_opt2),
				GEO_BRANCH(1, blue_flame_bowser_000_switch_opt3),
				GEO_BRANCH(1, blue_flame_bowser_000_switch_opt4),
				GEO_BRANCH(1, blue_flame_bowser_000_switch_opt5),
				GEO_BRANCH(1, blue_flame_bowser_000_switch_opt6),
				GEO_BRANCH(1, blue_flame_bowser_000_switch_opt7),
			GEO_CLOSE_NODE(),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
