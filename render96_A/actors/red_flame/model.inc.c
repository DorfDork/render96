Lights1 red_flame_flame_red_1_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 red_flame_flame_red_2_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 red_flame_flame_red_3_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 red_flame_flame_red_4_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 red_flame_flame_red_5_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 red_flame_flame_red_6_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 red_flame_flame_red_7_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 red_flame_flame_red_8_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Texture red_flame_flame_red_1_rgba32[] = {
	#include "completed blends/red_flame/flame_red_1.rgba32.inc.c"
};

Texture red_flame_flame_red_2_rgba32[] = {
	#include "completed blends/red_flame/flame_red_2.rgba32.inc.c"
};

Texture red_flame_flame_red_3_rgba32[] = {
	#include "completed blends/red_flame/flame_red_3.rgba32.inc.c"
};

Texture red_flame_flame_red_4_rgba32[] = {
	#include "completed blends/red_flame/flame_red_4.rgba32.inc.c"
};

Texture red_flame_flame_red_5_rgba32[] = {
	#include "completed blends/red_flame/flame_red_5.rgba32.inc.c"
};

Texture red_flame_flame_red_6_rgba32[] = {
	#include "completed blends/red_flame/flame_red_6.rgba32.inc.c"
};

Texture red_flame_flame_red_7_rgba32[] = {
	#include "completed blends/red_flame/flame_red_7.rgba32.inc.c"
};

Texture red_flame_flame_red_8_rgba32[] = {
	#include "completed blends/red_flame/flame_red_8.rgba32.inc.c"
};

Vtx red_flame_000_displaylist_mesh_layer_4_vtx_0[4] = {
	{{{-21, -21, 0}, 0, {-16, 7920}, {0xFF, 0x70, 0x4C, 0xFF}}},
	{{{21, -21, 0}, 0, {7920, 7920}, {0xFF, 0x70, 0x4C, 0xFF}}},
	{{{21, 21, 0}, 0, {7920, -16}, {0xFF, 0x70, 0x4C, 0xFF}}},
	{{{-21, 21, 0}, 0, {-16, -16}, {0xFF, 0x6F, 0x4C, 0xFF}}},
};

Gfx red_flame_000_displaylist_mesh_layer_4_tri_0[] = {
	gsSPVertex(red_flame_000_displaylist_mesh_layer_4_vtx_0 + 0, 4, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSPEndDisplayList(),
};


Gfx mat_red_flame_flame_red_1[] = {
	gsSPGeometryMode(G_CULL_BACK, G_PACKED_NORMALS_EXT),
	gsSPSetLights1(red_flame_flame_red_1_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_flame_flame_red_1_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 65535, 16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 64, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0),
	gsDPSetTileSize(0, 0, 0, 1020, 1020),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_flame_flame_red_1[] = {
	gsSPGeometryMode(G_PACKED_NORMALS_EXT, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_red_flame_flame_red_2[] = {
	gsSPGeometryMode(G_CULL_BACK, G_PACKED_NORMALS_EXT),
	gsSPSetLights1(red_flame_flame_red_2_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_flame_flame_red_2_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 65535, 16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 64, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0),
	gsDPSetTileSize(0, 0, 0, 1020, 1020),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_flame_flame_red_2[] = {
	gsSPGeometryMode(G_PACKED_NORMALS_EXT, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_red_flame_flame_red_3[] = {
	gsSPGeometryMode(G_CULL_BACK, G_PACKED_NORMALS_EXT),
	gsSPSetLights1(red_flame_flame_red_3_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_flame_flame_red_3_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 65535, 16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 64, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0),
	gsDPSetTileSize(0, 0, 0, 1020, 1020),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_flame_flame_red_3[] = {
	gsSPGeometryMode(G_PACKED_NORMALS_EXT, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_red_flame_flame_red_4[] = {
	gsSPGeometryMode(G_CULL_BACK, G_PACKED_NORMALS_EXT),
	gsSPSetLights1(red_flame_flame_red_4_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_flame_flame_red_4_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 65535, 16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 64, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0),
	gsDPSetTileSize(0, 0, 0, 1020, 1020),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_flame_flame_red_4[] = {
	gsSPGeometryMode(G_PACKED_NORMALS_EXT, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_red_flame_flame_red_5[] = {
	gsSPGeometryMode(G_CULL_BACK, G_PACKED_NORMALS_EXT),
	gsSPSetLights1(red_flame_flame_red_5_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_flame_flame_red_5_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 65535, 16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 64, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0),
	gsDPSetTileSize(0, 0, 0, 1020, 1020),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_flame_flame_red_5[] = {
	gsSPGeometryMode(G_PACKED_NORMALS_EXT, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_red_flame_flame_red_6[] = {
	gsSPGeometryMode(G_CULL_BACK, G_PACKED_NORMALS_EXT),
	gsSPSetLights1(red_flame_flame_red_6_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_flame_flame_red_6_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 65535, 16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 64, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0),
	gsDPSetTileSize(0, 0, 0, 1020, 1020),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_flame_flame_red_6[] = {
	gsSPGeometryMode(G_PACKED_NORMALS_EXT, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_red_flame_flame_red_7[] = {
	gsSPGeometryMode(G_CULL_BACK, G_PACKED_NORMALS_EXT),
	gsSPSetLights1(red_flame_flame_red_7_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_flame_flame_red_7_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 65535, 16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 64, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0),
	gsDPSetTileSize(0, 0, 0, 1020, 1020),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_flame_flame_red_7[] = {
	gsSPGeometryMode(G_PACKED_NORMALS_EXT, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_red_flame_flame_red_8[] = {
	gsSPGeometryMode(G_CULL_BACK, G_PACKED_NORMALS_EXT),
	gsSPSetLights1(red_flame_flame_red_8_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, red_flame_flame_red_8_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 65535, 16),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 64, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0, G_TX_WRAP | G_TX_NOMIRROR, 8, 0),
	gsDPSetTileSize(0, 0, 0, 1020, 1020),
	gsSPEndDisplayList(),
};

Gfx mat_revert_red_flame_flame_red_8[] = {
	gsSPGeometryMode(G_PACKED_NORMALS_EXT, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx red_flame_000_displaylist_mesh_layer_4[] = {
	gsSPDisplayList(mat_red_flame_flame_red_1),
	gsSPDisplayList(red_flame_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_flame_flame_red_1),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx red_flame_000_displaylist_mesh_layer_4_mat_override_flame_red_2_0[] = {
	gsSPDisplayList(mat_red_flame_flame_red_2),
	gsSPDisplayList(red_flame_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_flame_flame_red_2),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx red_flame_000_displaylist_mesh_layer_4_mat_override_flame_red_3_1[] = {
	gsSPDisplayList(mat_red_flame_flame_red_3),
	gsSPDisplayList(red_flame_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_flame_flame_red_3),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx red_flame_000_displaylist_mesh_layer_4_mat_override_flame_red_4_2[] = {
	gsSPDisplayList(mat_red_flame_flame_red_4),
	gsSPDisplayList(red_flame_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_flame_flame_red_4),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx red_flame_000_displaylist_mesh_layer_4_mat_override_flame_red_5_3[] = {
	gsSPDisplayList(mat_red_flame_flame_red_5),
	gsSPDisplayList(red_flame_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_flame_flame_red_5),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx red_flame_000_displaylist_mesh_layer_4_mat_override_flame_red_6_4[] = {
	gsSPDisplayList(mat_red_flame_flame_red_6),
	gsSPDisplayList(red_flame_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_flame_flame_red_6),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx red_flame_000_displaylist_mesh_layer_4_mat_override_flame_red_7_5[] = {
	gsSPDisplayList(mat_red_flame_flame_red_7),
	gsSPDisplayList(red_flame_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_flame_flame_red_7),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx red_flame_000_displaylist_mesh_layer_4_mat_override_flame_red_8_6[] = {
	gsSPDisplayList(mat_red_flame_flame_red_8),
	gsSPDisplayList(red_flame_000_displaylist_mesh_layer_4_tri_0),
	gsSPDisplayList(mat_revert_red_flame_flame_red_8),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

