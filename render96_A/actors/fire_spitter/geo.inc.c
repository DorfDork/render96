const GeoLayout fire_spitter_fire_spitter_breathing[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, fire_spitter_switchopt_displaylist1_mesh_layer_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout fire_spitter_fire_spitter_fire[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, fire_spitter_switchopt_displaylist2_mesh_layer_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout fire_spitter_fire_spitter_laugh[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, fire_spitter_switchopt_displaylist3_mesh_layer_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout fire_spitter_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_SHADOW(1, 180, 200),
		GEO_OPEN_NODE(),
			GEO_SCALE(LAYER_OPAQUE, 16384),
			GEO_OPEN_NODE(),
				GEO_SWITCH_CASE(2, geo_switch_state_1),
				GEO_OPEN_NODE(),
					GEO_NODE_START(),
					GEO_OPEN_NODE(),
						GEO_DISPLAY_LIST(LAYER_OPAQUE, fire_spitter_displaylist_mesh_layer_1),
					GEO_CLOSE_NODE(),
					GEO_BRANCH(1, fire_spitter_fire_spitter_breathing),
					GEO_BRANCH(1, fire_spitter_fire_spitter_fire),
					GEO_BRANCH(1, fire_spitter_fire_spitter_laugh),
				GEO_CLOSE_NODE(),
			GEO_CLOSE_NODE(),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
