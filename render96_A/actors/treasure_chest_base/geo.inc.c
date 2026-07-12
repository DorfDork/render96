const GeoLayout treasure_chest_base_geo[] = {
	GEO_NODE_START(),
	GEO_OPEN_NODE(),
		GEO_NODE_START(),
		GEO_OPEN_NODE(),
			GEO_SCALE(LAYER_OPAQUE, 16384),
			GEO_OPEN_NODE(),
				GEO_DISPLAY_LIST(LAYER_OPAQUE, treasure_chest_base_000_displaylist_mesh_layer_1),
				GEO_DISPLAY_LIST(LAYER_TRANSPARENT, treasure_chest_base_000_displaylist_mesh_layer_5),
			GEO_CLOSE_NODE(),
		GEO_CLOSE_NODE(),
	GEO_CLOSE_NODE(),
	GEO_END(),
};
