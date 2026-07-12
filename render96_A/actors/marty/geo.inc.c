const GeoLayout marty_Thwomp_Angry[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, marty_ANGRY_thwompAngry_mesh_layer_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout marty_Thwomp_URGH[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_DISPLAY_LIST(LAYER_OPAQUE, marty_URGH_thwompURGH_mesh_layer_1),
	GEO_CLOSE_NODE(),
	GEO_RETURN(),
};
const GeoLayout marty_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_SHADOW(11, 180, 300),
		GEO_OPEN_NODE(),
			GEO_SWITCH_CASE(0, geo_switch_state_2),
			GEO_OPEN_NODE(),
				GEO_NODE_START(),
				GEO_OPEN_NODE(),
					GEO_DISPLAY_LIST(LAYER_OPAQUE, marty_000_displaylist_mesh_layer_1),
				GEO_CLOSE_NODE(),
				GEO_BRANCH(1, marty_Thwomp_Angry),
				GEO_BRANCH(1, marty_Thwomp_URGH),
			GEO_CLOSE_NODE(),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
