Lights1 star_particle_star_glow_lights = gdSPDefLights1(
	0x7F, 0x68, 0x12,
	0xFF, 0xD3, 0x2E, 0x28, 0x28, 0x28);

Lights1 star_particle_star_rays_lights = gdSPDefLights1(
	0x7F, 0x68, 0x12,
	0xFF, 0xD3, 0x2E, 0x28, 0x28, 0x28);

Texture star_particle_star_glow_rgba32[] = {
	#include "COMPLETED/star_particle/star_glow.rgba32.inc.c"
};

Vtx star_particle_001_displaylist_mesh_layer_5_vtx_0[4] = {
	{{{118, -119, 0}, 0, {1008, 1008}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-118, 119, 0}, 0, {-16, -16}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-118, -119, 0}, 0, {-16, 1008}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{118, 119, 0}, 0, {1008, -16}, {0x00, 0x00, 0x7F, 0xFF}}},
};

Gfx star_particle_001_displaylist_mesh_layer_5_tri_0[] = {
	gsSPVertex(star_particle_001_displaylist_mesh_layer_5_vtx_0 + 0, 4, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSPEndDisplayList(),
};

Vtx star_particle_001_displaylist_mesh_layer_5_vtx_1[18] = {
	{{{90, -133, 0}, 0, {1098, 990}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{0, 0, 0}, 0, {684, 689}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{55, -148, 0}, 0, {988, 1100}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{115, 193, 0}, 0, {1060, 950}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{0, 0, 0}, 0, {646, 649}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{157, 162, 0}, 0, {950, 1060}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{0, 0, 0}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0xFF}}},
	{{{10, 166, 0}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0xFF}}},
	{{{-21, 163, -2}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0xFF}}},
	{{{-112, -118, 0}, 0, {27, 123}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{0, 0, 0}, 0, {441, 424}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-137, -89, 0}, 0, {137, 13}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-153, 94, 0}, 0, {26, 118}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{0, 0, 0}, 0, {440, 419}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-127, 127, 0}, 0, {136, 8}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{180, -5, 0}, 0, {26, 121}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{0, 0, 0}, 0, {412, 457}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{174, -46, 0}, 0, {145, 21}, {0x00, 0x00, 0x7F, 0xFF}}},
};

Gfx star_particle_001_displaylist_mesh_layer_5_tri_1[] = {
	gsSPVertex(star_particle_001_displaylist_mesh_layer_5_vtx_1 + 0, 18, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 4, 5, 0),
	gsSP2Triangles(6, 7, 8, 0, 9, 10, 11, 0),
	gsSP2Triangles(12, 13, 14, 0, 15, 16, 17, 0),
	gsSPEndDisplayList(),
};


Gfx mat_star_particle_star_glow[] = {
	gsSPSetLights1(star_particle_star_glow_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, TEXEL0, SHADE, TEXEL0, 0, PRIMITIVE, 0, 0, 0, TEXEL0, SHADE, TEXEL0, 0, PRIMITIVE, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetPrimColor(0, 0, 255, 255, 255, 255),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, star_particle_star_glow_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 255, 256),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 4, 0, 0, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_star_particle_star_glow[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_star_particle_star_rays[] = {
	gsSPSetLights1(star_particle_star_rays_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, TEXEL0, SHADE, TEXEL0, 0, PRIMITIVE, 0, 0, 0, TEXEL0, SHADE, TEXEL0, 0, PRIMITIVE, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetPrimColor(0, 0, 255, 255, 255, 255),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, star_particle_star_glow_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 255, 256),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 4, 0, 0, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_star_particle_star_rays[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx star_particle_001_displaylist_mesh_layer_5[] = {
	gsSPDisplayList(mat_star_particle_star_glow),
	gsSPDisplayList(star_particle_001_displaylist_mesh_layer_5_tri_0),
	gsSPDisplayList(mat_revert_star_particle_star_glow),
	gsSPDisplayList(mat_star_particle_star_rays),
	gsSPDisplayList(star_particle_001_displaylist_mesh_layer_5_tri_1),
	gsSPDisplayList(mat_revert_star_particle_star_rays),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

