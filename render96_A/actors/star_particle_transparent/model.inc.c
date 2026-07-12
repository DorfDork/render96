Lights1 star_particle_transparent_star_glow_lights = gdSPDefLights1(
	0x9, 0x14, 0x72,
	0x1E, 0x32, 0xE6, 0x28, 0x28, 0x28);

Lights1 star_particle_transparent_star_rays_lights = gdSPDefLights1(
	0x9, 0x14, 0x72,
	0x1E, 0x32, 0xE6, 0x28, 0x28, 0x28);

Texture star_particle_transparent_star_transparent_rgba32[] = {
	#include "COMPLETED/star_particle_transparent/star_transparent.rgba32.inc.c"
};

Vtx star_particle_transparent_001_displaylist_mesh_layer_5_vtx_0[4] = {
	{{{118, -119, 0}, 0, {1008, 1008}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-118, 119, 0}, 0, {-16, -16}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-118, -119, 0}, 0, {-16, 1008}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{118, 119, 0}, 0, {1008, -16}, {0x00, 0x00, 0x7F, 0xFF}}},
};

Gfx star_particle_transparent_001_displaylist_mesh_layer_5_tri_0[] = {
	gsSPVertex(star_particle_transparent_001_displaylist_mesh_layer_5_vtx_0 + 0, 4, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSPEndDisplayList(),
};

Vtx star_particle_transparent_001_displaylist_mesh_layer_5_vtx_1[42] = {
	{{{90, -133, 0}, 0, {1098, 990}, {0x00, 0x00, 0x7F, 0xFA}}},
	{{{42, -113, 0}, 0, {916, 1003}, {0x00, 0x00, 0x7F, 0x94}}},
	{{{55, -148, 0}, 0, {988, 1100}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{68, -100, 0}, 0, {994, 915}, {0x00, 0x00, 0x7F, 0x94}}},
	{{{28, -42, 0}, 0, {815, 784}, {0x00, 0x00, 0x7F, 0x53}}},
	{{{18, -48, 0}, 0, {781, 821}, {0x00, 0x00, 0x7F, 0x54}}},
	{{{0, 0, 0}, 0, {684, 689}, {0x00, 0x00, 0x7F, 0x00}}},
	{{{115, 193, 0}, 0, {1060, 950}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{99, 102, 0}, 0, {837, 907}, {0x00, 0x00, 0x7F, 0x94}}},
	{{{157, 162, 0}, 0, {950, 1060}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{74, 124, 0}, 0, {912, 842}, {0x00, 0x00, 0x7F, 0xA3}}},
	{{{38, 64, 0}, 0, {782, 748}, {0x00, 0x00, 0x7F, 0x53}}},
	{{{50, 52, 0}, 0, {744, 781}, {0x00, 0x00, 0x7F, 0x53}}},
	{{{0, 0, 0}, 0, {646, 649}, {0x00, 0x00, 0x7F, 0x00}}},
	{{{-17, 127, -1}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0x94}}},
	{{{10, 166, 0}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0xFF}}},
	{{{-21, 163, -2}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0xFF}}},
	{{{8, 129, 0}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0x94}}},
	{{{-8, 58, -1}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0x53}}},
	{{{4, 59, 0}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0x53}}},
	{{{0, 0, 0}, 0, {46, 1078}, {0xFA, 0x00, 0x7F, 0x00}}},
	{{{-112, -118, 0}, 0, {27, 123}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-111, -72, 0}, 0, {195, 90}, {0x00, 0x00, 0x7F, 0xAF}}},
	{{{-137, -89, 0}, 0, {137, 13}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-88, -92, 0}, 0, {118, 189}, {0x00, 0x00, 0x7F, 0x95}}},
	{{{-40, -42, 0}, 0, {294, 317}, {0x00, 0x00, 0x7F, 0x53}}},
	{{{-50, -33, 0}, 0, {329, 272}, {0x00, 0x00, 0x7F, 0x53}}},
	{{{0, 0, 0}, 0, {441, 424}, {0x00, 0x00, 0x7F, 0x00}}},
	{{{-153, 94, 0}, 0, {26, 118}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-90, 90, 0}, 0, {223, 127}, {0x00, 0x00, 0x7F, 0x94}}},
	{{{-127, 127, 0}, 0, {136, 8}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{-111, 68, 0}, 0, {140, 201}, {0x00, 0x00, 0x7F, 0x94}}},
	{{{-51, 31, 0}, 0, {302, 319}, {0x00, 0x00, 0x7F, 0x53}}},
	{{{-41, 41, 0}, 0, {341, 285}, {0x00, 0x00, 0x7F, 0x5B}}},
	{{{0, 0, 0}, 0, {440, 419}, {0x00, 0x00, 0x7F, 0x00}}},
	{{{180, -5, 0}, 0, {26, 121}, {0x00, 0x00, 0x7F, 0xFF}}},
	{{{126, -33, 0}, 0, {219, 141}, {0x00, 0x00, 0x7F, 0x94}}},
	{{{174, -46, 0}, 0, {145, 21}, {0x00, 0x00, 0x7F, 0xF9}}},
	{{{132, -4, 0}, 0, {130, 211}, {0x00, 0x00, 0x7F, 0x94}}},
	{{{62, -2, 0}, 0, {280, 342}, {0x00, 0x00, 0x7F, 0x53}}},
	{{{59, -16, 0}, 0, {322, 309}, {0x00, 0x00, 0x7F, 0x53}}},
	{{{0, 0, 0}, 0, {412, 457}, {0x00, 0x00, 0x7F, 0x00}}},
};

Gfx star_particle_transparent_001_displaylist_mesh_layer_5_tri_1[] = {
	gsSPVertex(star_particle_transparent_001_displaylist_mesh_layer_5_vtx_1 + 0, 42, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(4, 1, 3, 0, 4, 5, 1, 0),
	gsSP2Triangles(5, 4, 6, 0, 7, 8, 9, 0),
	gsSP2Triangles(7, 10, 8, 0, 11, 8, 10, 0),
	gsSP2Triangles(11, 12, 8, 0, 12, 11, 13, 0),
	gsSP2Triangles(14, 15, 16, 0, 14, 17, 15, 0),
	gsSP2Triangles(18, 17, 14, 0, 18, 19, 17, 0),
	gsSP2Triangles(20, 19, 18, 0, 21, 22, 23, 0),
	gsSP2Triangles(21, 24, 22, 0, 22, 24, 25, 0),
	gsSP2Triangles(22, 25, 26, 0, 26, 25, 27, 0),
	gsSP2Triangles(28, 29, 30, 0, 28, 31, 29, 0),
	gsSP2Triangles(29, 31, 32, 0, 29, 32, 33, 0),
	gsSP2Triangles(33, 32, 34, 0, 35, 36, 37, 0),
	gsSP2Triangles(35, 38, 36, 0, 39, 36, 38, 0),
	gsSP2Triangles(39, 40, 36, 0, 40, 39, 41, 0),
	gsSPEndDisplayList(),
};


Gfx mat_star_particle_transparent_star_glow[] = {
	gsSPSetLights1(star_particle_transparent_star_glow_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, TEXEL0, SHADE, TEXEL0, 0, PRIMITIVE, 0, 0, 0, TEXEL0, SHADE, TEXEL0, 0, PRIMITIVE, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetPrimColor(0, 0, 255, 255, 255, 255),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, star_particle_transparent_star_transparent_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 255, 256),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 4, 0, 0, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_star_particle_transparent_star_glow[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_star_particle_transparent_star_rays[] = {
	gsSPSetLights1(star_particle_transparent_star_rays_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, TEXEL0, SHADE, TEXEL0, 0, SHADE, 0, 0, 0, TEXEL0, SHADE, TEXEL0, 0, SHADE, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, star_particle_transparent_star_transparent_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 255, 256),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 4, 0, 0, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0, G_TX_WRAP | G_TX_MIRROR, 4, 0),
	gsDPSetTileSize(0, 0, 0, 60, 60),
	gsSPEndDisplayList(),
};

Gfx mat_revert_star_particle_transparent_star_rays[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx star_particle_transparent_001_displaylist_mesh_layer_5[] = {
	gsSPDisplayList(mat_star_particle_transparent_star_glow),
	gsSPDisplayList(star_particle_transparent_001_displaylist_mesh_layer_5_tri_0),
	gsSPDisplayList(mat_revert_star_particle_transparent_star_glow),
	gsSPDisplayList(mat_star_particle_transparent_star_rays),
	gsSPDisplayList(star_particle_transparent_001_displaylist_mesh_layer_5_tri_1),
	gsSPDisplayList(mat_revert_star_particle_transparent_star_rays),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

