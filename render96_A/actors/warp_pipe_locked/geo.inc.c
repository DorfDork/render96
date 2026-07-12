const GeoLayout warp_pipe_locked_switch_opt1[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, warp_pipe_locked_001_displaylist_mesh_layer_1_mat_override_warp_pipe_mario_0),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout warp_pipe_locked_switch_opt2[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, warp_pipe_locked_001_displaylist_mesh_layer_1_mat_override_warp_pipe_luigi_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout warp_pipe_locked_switch_opt3[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, warp_pipe_locked_001_displaylist_mesh_layer_1_mat_override_warp_pipe_wario_2),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout warp_pipe_locked_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_CULLING_RADIUS(74434),
		GEO_OPEN_NODE(),
			GEO_SWITCH_CASE(3, geo_switch_state_1),
			GEO_OPEN_NODE(),
				GEO_NODE_START(),
				GEO_OPEN_NODE(),
					GEO_DISPLAY_LIST(LAYER_OPAQUE, warp_pipe_locked_001_displaylist_mesh_layer_1),
				GEO_CLOSE_NODE(),
				GEO_BRANCH(1, warp_pipe_locked_switch_opt1),
				GEO_BRANCH(1, warp_pipe_locked_switch_opt2),
				GEO_BRANCH(1, warp_pipe_locked_switch_opt3),
			GEO_CLOSE_NODE(),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
