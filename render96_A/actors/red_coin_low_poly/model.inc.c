Lights1 red_coin_low_poly_coin_red_side_lights = gdSPDefLights1(
	0x13, 0x0, 0x0,
	0x31, 0x0, 0x0, 0x28, 0x28, 0x28);

Lights1 red_coin_low_poly_f3dlite_material_001_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Texture red_coin_low_poly_coin_side_rgba32[] = {
	#include "completed blends/red_coin_low_poly/coin_side.rgba32.inc.c"
};

Texture red_coin_low_poly_red_coin_lod_ci8[] = {
	#include "completed blends/red_coin_low_poly/red_coin_lod.ci8.inc.c"
};

Texture red_coin_low_poly_red_coin_lod_pal_rgba16[] = {
	#include "completed blends/red_coin_low_poly/red_coin_lod.rgba16.pal"
};

Vtx red_coin_low_poly_000_displaylist_mesh_layer_4_vtx_0[16] = {
	{{{-69, 14, 16}, 0, {3967, -129}, {0xB4, 0x9A, 0x00, 0xFF}}},
	{{{-120, 99, 16}, 0, {3967, -129}, {0x82, 0xF0, 0x00, 0xFF}}},
	{{{-120, 99, -16}, 0, {3967, -129}, {0x82, 0xF0, 0x00, 0xFF}}},
	{{{-92, 193, -16}, 0, {3967, -129}, {0xA0, 0x53, 0x00, 0xFF}}},
	{{{-92, 193, 16}, 0, {3967, -129}, {0xA0, 0x53, 0x00, 0xFF}}},
	{{{-2, 235, 16}, 0, {3967, -129}, {0xFE, 0x7F, 0x00, 0xFF}}},
	{{{-2, 235, -16}, 0, {3967, -129}, {0xFE, 0x7F, 0x00, 0xFF}}},
	{{{89, 197, 16}, 0, {3967, -129}, {0x5D, 0x57, 0x00, 0xFF}}},
	{{{89, 197, -16}, 0, {3967, -129}, {0x5D, 0x57, 0x00, 0xFF}}},
	{{{121, 104, -16}, 0, {3967, -129}, {0x7F, 0xF5, 0x00, 0xFF}}},
	{{{121, 104, 16}, 0, {3967, -129}, {0x7F, 0xF5, 0x00, 0xFF}}},
	{{{73, 17, 16}, 0, {3967, -129}, {0x50, 0x9E, 0x00, 0xFF}}},
	{{{73, 17, -16}, 0, {3967, -129}, {0x50, 0x9E, 0x00, 0xFF}}},
	{{{2, -5, -16}, 0, {3967, -129}, {0x03, 0x81, 0x00, 0xFF}}},
	{{{2, -5, 16}, 0, {3967, -129}, {0x03, 0x81, 0x00, 0xFF}}},
	{{{-69, 15, -16}, 0, {3967, -129}, {0xB4, 0x9A, 0x00, 0xFF}}},
};

Gfx red_coin_low_poly_000_displaylist_mesh_layer_4_tri_0[] = {
	gsSPVertex(red_coin_low_poly_000_displaylist_mesh_layer_4_vtx_0 + 0, 16, 0),
	gsSP2Triangles(0, 1, 2, 0, 1, 3, 2, 0),
	gsSP2Triangles(1, 4, 3, 0, 5, 3, 4, 0),
	gsSP2Triangles(5, 6, 3, 0, 7, 6, 5, 0),
	gsSP2Triangles(7, 8, 6, 0, 7, 9, 8, 0),
	gsSP2Triangles(7, 10, 9, 0, 11, 9, 10, 0),
	gsSP2Triangles(11, 12, 9, 0, 11, 13, 12, 0),
	gsSP2Triangles(11, 14, 13, 0, 0, 13, 14, 0),
	gsSP2Triangles(0, 15, 13, 0, 0, 2, 15, 0),
	gsSPEndDisplayList(),
};

Vtx red_coin_low_poly_000_displaylist_mesh_layer_1_vtx_0[16] = {
	{{{-92, 193, 16}, 0, {306, 432}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-120, 99, 16}, 0, {96, 1151}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-69, 14, 16}, 0, {491, 1789}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{73, 17, 16}, 0, {1574, 1754}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{2, -5, 16}, 0, {1037, 1927}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{89, 197, 16}, 0, {1675, 389}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{121, 104, 16}, 0, {1928, 1094}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-2, 235, 16}, 0, {981, 106}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-2, 235, -16}, 0, {1573, 1755}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{89, 197, -16}, 0, {845, 1933}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{121, 104, -16}, 0, {226, 1511}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{2, -5, -16}, 0, {458, 313}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{73, 17, -16}, 0, {125, 768}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{-120, 99, -16}, 0, {1675, 389}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{-69, 15, -16}, 0, {982, 105}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{-92, 193, -16}, 0, {1928, 1095}, {0x00, 0x00, 0x81, 0xFF}}},
};

Gfx red_coin_low_poly_000_displaylist_mesh_layer_1_tri_0[] = {
	gsSPVertex(red_coin_low_poly_000_displaylist_mesh_layer_1_vtx_0 + 0, 16, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(2, 4, 3, 0, 3, 5, 0, 0),
	gsSP2Triangles(3, 6, 5, 0, 5, 7, 0, 0),
	gsSP2Triangles(8, 9, 10, 0, 8, 10, 11, 0),
	gsSP2Triangles(10, 12, 11, 0, 11, 13, 8, 0),
	gsSP2Triangles(11, 14, 13, 0, 13, 15, 8, 0),
	gsSPEndDisplayList(),
};


Gfx mat_red_coin_low_poly_coin_red_side[] = {
	gsSPSetGeometryMode(G_TEXTURE_GEN),
	gsSPSetLights1(red_coin_low_poly_coin_red_side_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(PRIMITIVE, 0, TEXEL0, SHADE, 0, 0, 0, ENVIRONMENT, PRIMITIVE, 0, TEXEL0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(8128, 8128, 0, 0, 1),
	gsDPSetPrimColor(0, 0, 255, 0, 0, 255),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_coin_low_poly_coin_side_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 16383, 32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 32, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 7, 0),
	gsDPSetTileSize(0, 0, 0, 508, 508),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_coin_low_poly_coin_red_side[] = {
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_red_coin_low_poly_f3dlite_material_001[] = {
	gsSPSetLights1(red_coin_low_poly_f3dlite_material_001_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetTextureLUT(G_TT_RGBA16),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_16b, 1, red_coin_low_poly_red_coin_lod_pal_rgba16),
	gsDPSetTile(0, 0, 0, 256, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadTLUTCmd(5, 118),
	gsDPSetTextureImage(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 1, red_coin_low_poly_red_coin_lod_ci8),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 2047, 256),
	gsDPSetTile(G_IM_FMT_CI, G_IM_SIZ_8b, 8, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 6, 0, G_TX_WRAP | G_TX_NOMIRROR, 6, 0),
	gsDPSetTileSize(0, 0, 0, 252, 252),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_coin_low_poly_f3dlite_material_001[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetTextureLUT(G_TT_NONE),
	gsSPEndDisplayList(),
};

Gfx red_coin_low_poly_000_displaylist_mesh_layer_4[] = {
	gsSPDisplayList(mat_red_coin_low_poly_coin_red_side),
	gsSPDisplayList(red_coin_low_poly_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_coin_low_poly_coin_red_side),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx red_coin_low_poly_000_displaylist_mesh_layer_1[] = {
	gsSPDisplayList(mat_red_coin_low_poly_f3dlite_material_001),
	gsSPDisplayList(red_coin_low_poly_000_displaylist_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_red_coin_low_poly_f3dlite_material_001),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

