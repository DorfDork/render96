Lights1 goomba_lowpoly_Body_lights = gdSPDefLights1(
	0x76, 0x74, 0x47,
	0xEC, 0xEA, 0x94, 0x28, 0x28, 0x28);

Lights1 goomba_lowpoly_Feet_lights = gdSPDefLights1(
	0x31, 0x13, 0x7,
	0x6A, 0x32, 0x19, 0x28, 0x28, 0x28);

Lights1 goomba_lowpoly_Eyes_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 goomba_lowpoly_Eyebrows_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 goomba_lowpoly_EyesClosed_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 goomba_lowpoly_EyesDazed_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 goomba_lowpoly_Mouth_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 goomba_lowpoly_MouthOpen_lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Texture goomba_lowpoly_EyesOpen_color_rgba32[] = {
	#include "completed blends/goomba_lowpoly/EyesOpen_color.rgba32.inc.c"
};

Texture goomba_lowpoly_Eyebrow1_rgba32[] = {
	#include "completed blends/goomba_lowpoly/Eyebrow1.rgba32.inc.c"
};

Texture goomba_lowpoly_EyesClosed_color_rgba32[] = {
	#include "completed blends/goomba_lowpoly/EyesClosed_color.rgba32.inc.c"
};

Texture goomba_lowpoly_EyesDazed_color_rgba32[] = {
	#include "completed blends/goomba_lowpoly/EyesDazed_color.rgba32.inc.c"
};

Texture goomba_lowpoly_Mouth_color1_rgba32[] = {
	#include "completed blends/goomba_lowpoly/Mouth_color1.rgba32.inc.c"
};

Texture goomba_lowpoly_MouthOpenColor_rgba32[] = {
	#include "completed blends/goomba_lowpoly/MouthOpenColor.rgba32.inc.c"
};

Vtx goomba_lowpoly_body_mesh_layer_1_vtx_0[13] = {
	{{{44, 491, -50}, 0, {-16, 1008}, {0x01, 0x7F, 0xFF, 0xFF}}},
	{{{-67, 210, -140}, 0, {-16, 1008}, {0xA9, 0x37, 0xB6, 0xFF}}},
	{{{-83, 121, 107}, 0, {-16, 1008}, {0xB5, 0x2A, 0x5D, 0xFF}}},
	{{{171, 85, -208}, 0, {-16, 1008}, {0x4E, 0x19, 0x9F, 0xFF}}},
	{{{154, 210, 39}, 0, {-16, 1008}, {0x5B, 0x37, 0x46, 0xFF}}},
	{{{218, 25, 90}, 0, {-16, 1008}, {0x64, 0x0B, 0x4E, 0xFF}}},
	{{{-100, -30, 128}, 0, {-16, 1008}, {0xB1, 0xEA, 0x61, 0xFF}}},
	{{{-131, 25, -191}, 0, {-16, 1008}, {0x9F, 0x0B, 0xAF, 0xFF}}},
	{{{162, -95, -197}, 0, {-16, 1008}, {0x42, 0xB9, 0xAE, 0xFF}}},
	{{{203, -90, 78}, 0, {-16, 1008}, {0x52, 0xB8, 0x41, 0xFF}}},
	{{{-74, -105, 95}, 0, {-16, 1008}, {0xC8, 0xA5, 0x45, 0xFF}}},
	{{{-116, -90, -179}, 0, {-16, 1008}, {0xAF, 0xB8, 0xBE, 0xFF}}},
	{{{44, -139, -50}, 0, {-16, 1008}, {0x02, 0x81, 0xFE, 0xFF}}},
};

Gfx goomba_lowpoly_body_mesh_layer_1_tri_0[] = {
	gsSPVertex(goomba_lowpoly_body_mesh_layer_1_vtx_0 + 0, 13, 0),
	gsSP2Triangles(0, 1, 2, 0, 1, 0, 3, 0),
	gsSP2Triangles(4, 3, 0, 0, 0, 2, 4, 0),
	gsSP2Triangles(2, 5, 4, 0, 2, 6, 5, 0),
	gsSP2Triangles(2, 7, 6, 0, 2, 1, 7, 0),
	gsSP2Triangles(1, 3, 7, 0, 8, 7, 3, 0),
	gsSP2Triangles(8, 3, 5, 0, 4, 5, 3, 0),
	gsSP2Triangles(8, 5, 9, 0, 10, 9, 5, 0),
	gsSP2Triangles(10, 5, 6, 0, 10, 6, 7, 0),
	gsSP2Triangles(10, 7, 11, 0, 8, 11, 7, 0),
	gsSP2Triangles(12, 11, 8, 0, 12, 8, 9, 0),
	gsSP2Triangles(12, 9, 10, 0, 12, 10, 11, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_foot_L_mesh_layer_1_vtx_0[27] = {
	{{{-35, 325, -31}, 0, {-16, 1008}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{89, 236, -29}, 0, {-16, 1008}, {0x03, 0x00, 0x81, 0xFF}}},
	{{{49, -43, -29}, 0, {-16, 1008}, {0xFE, 0xFF, 0x81, 0xFF}}},
	{{{-35, -88, -27}, 0, {-16, 1008}, {0x00, 0xFF, 0x81, 0xFF}}},
	{{{-118, -43, -29}, 0, {-16, 1008}, {0x02, 0xFF, 0x81, 0xFF}}},
	{{{-159, 236, -29}, 0, {-16, 1008}, {0xFD, 0x00, 0x81, 0xFF}}},
	{{{-35, -88, -27}, 0, {-16, 1008}, {0x00, 0x85, 0xE2, 0xFF}}},
	{{{49, -43, -29}, 0, {-16, 1008}, {0x5C, 0xC0, 0xC5, 0xFF}}},
	{{{69, -61, 22}, 0, {-16, 1008}, {0x62, 0xB2, 0xEC, 0xFF}}},
	{{{122, 236, 26}, 0, {-16, 1008}, {0x75, 0x28, 0xE3, 0xFF}}},
	{{{89, 236, -29}, 0, {-16, 1008}, {0x63, 0x30, 0xC1, 0xFF}}},
	{{{-35, 371, 31}, 0, {-16, 1008}, {0x00, 0x7D, 0xE9, 0xFF}}},
	{{{-35, 325, -31}, 0, {-16, 1008}, {0x00, 0x66, 0xB4, 0xFF}}},
	{{{-159, 236, -29}, 0, {-16, 1008}, {0x9D, 0x30, 0xC1, 0xFF}}},
	{{{-192, 236, 26}, 0, {-16, 1008}, {0x8B, 0x28, 0xE3, 0xFF}}},
	{{{-118, -43, -29}, 0, {-16, 1008}, {0xA4, 0xC0, 0xC5, 0xFF}}},
	{{{-138, -61, 22}, 0, {-16, 1008}, {0x9E, 0xB2, 0xEC, 0xFF}}},
	{{{-35, -104, 93}, 0, {-16, 1008}, {0x00, 0x84, 0x1E, 0xFF}}},
	{{{54, -51, 142}, 0, {-16, 1008}, {0x4C, 0xBD, 0x4C, 0xFF}}},
	{{{121, 236, 95}, 0, {-16, 1008}, {0x75, 0x29, 0x1A, 0xFF}}},
	{{{-35, 347, 141}, 0, {-16, 1008}, {0x00, 0x70, 0x3C, 0xFF}}},
	{{{-191, 236, 95}, 0, {-16, 1008}, {0x8B, 0x29, 0x1A, 0xFF}}},
	{{{-124, -51, 142}, 0, {-16, 1008}, {0xB4, 0xBD, 0x4C, 0xFF}}},
	{{{-35, -48, 157}, 0, {-16, 1008}, {0x00, 0xC4, 0x70, 0xFF}}},
	{{{77, 236, 187}, 0, {-16, 1008}, {0x4D, 0x22, 0x5F, 0xFF}}},
	{{{-35, 236, 209}, 0, {-16, 1008}, {0x00, 0x17, 0x7D, 0xFF}}},
	{{{-146, 236, 187}, 0, {-16, 1008}, {0xB3, 0x22, 0x5F, 0xFF}}},
};

Gfx goomba_lowpoly_foot_L_mesh_layer_1_tri_0[] = {
	gsSPVertex(goomba_lowpoly_foot_L_mesh_layer_1_vtx_0 + 0, 27, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(0, 3, 4, 0, 0, 4, 5, 0),
	gsSP2Triangles(6, 7, 8, 0, 9, 8, 7, 0),
	gsSP2Triangles(9, 7, 10, 0, 9, 10, 11, 0),
	gsSP2Triangles(10, 12, 11, 0, 13, 11, 12, 0),
	gsSP2Triangles(14, 11, 13, 0, 14, 13, 15, 0),
	gsSP2Triangles(14, 15, 16, 0, 6, 16, 15, 0),
	gsSP2Triangles(6, 17, 16, 0, 6, 8, 17, 0),
	gsSP2Triangles(18, 17, 8, 0, 18, 8, 19, 0),
	gsSP2Triangles(8, 9, 19, 0, 19, 9, 11, 0),
	gsSP2Triangles(20, 19, 11, 0, 20, 11, 21, 0),
	gsSP2Triangles(21, 11, 14, 0, 16, 21, 14, 0),
	gsSP2Triangles(22, 21, 16, 0, 22, 16, 17, 0),
	gsSP2Triangles(22, 17, 23, 0, 18, 23, 17, 0),
	gsSP2Triangles(23, 18, 24, 0, 19, 24, 18, 0),
	gsSP2Triangles(24, 19, 20, 0, 20, 25, 24, 0),
	gsSP2Triangles(20, 26, 25, 0, 26, 20, 21, 0),
	gsSP2Triangles(21, 22, 26, 0, 23, 26, 22, 0),
	gsSP2Triangles(23, 25, 26, 0, 23, 24, 25, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_foot_R_mesh_layer_1_vtx_0[27] = {
	{{{30, 325, -31}, 0, {-16, 1008}, {0x00, 0x00, 0x81, 0xFF}}},
	{{{-53, -43, -29}, 0, {-16, 1008}, {0x02, 0xFF, 0x81, 0xFF}}},
	{{{-94, 236, -29}, 0, {-16, 1008}, {0xFD, 0x00, 0x81, 0xFF}}},
	{{{30, -88, -27}, 0, {-16, 1008}, {0x00, 0xFF, 0x81, 0xFF}}},
	{{{114, -43, -29}, 0, {-16, 1008}, {0xFE, 0xFF, 0x81, 0xFF}}},
	{{{154, 236, -29}, 0, {-16, 1008}, {0x03, 0x00, 0x81, 0xFF}}},
	{{{30, -88, -27}, 0, {-16, 1008}, {0x00, 0x85, 0xE2, 0xFF}}},
	{{{-73, -61, 22}, 0, {-16, 1008}, {0x9E, 0xB2, 0xEC, 0xFF}}},
	{{{-53, -43, -29}, 0, {-16, 1008}, {0xA4, 0xC0, 0xC5, 0xFF}}},
	{{{30, -104, 93}, 0, {-16, 1008}, {0x00, 0x84, 0x1E, 0xFF}}},
	{{{134, -61, 22}, 0, {-16, 1008}, {0x62, 0xB2, 0xEC, 0xFF}}},
	{{{114, -43, -29}, 0, {-16, 1008}, {0x5C, 0xC0, 0xC5, 0xFF}}},
	{{{187, 236, 26}, 0, {-16, 1008}, {0x75, 0x28, 0xE3, 0xFF}}},
	{{{154, 236, -29}, 0, {-16, 1008}, {0x63, 0x30, 0xC1, 0xFF}}},
	{{{30, 371, 31}, 0, {-16, 1008}, {0x00, 0x7D, 0xE9, 0xFF}}},
	{{{30, 325, -31}, 0, {-16, 1008}, {0x00, 0x66, 0xB4, 0xFF}}},
	{{{-94, 236, -29}, 0, {-16, 1008}, {0x9D, 0x30, 0xC1, 0xFF}}},
	{{{-127, 236, 26}, 0, {-16, 1008}, {0x8B, 0x28, 0xE3, 0xFF}}},
	{{{-126, 236, 95}, 0, {-16, 1008}, {0x8B, 0x29, 0x1A, 0xFF}}},
	{{{-59, -51, 142}, 0, {-16, 1008}, {0xB4, 0xBD, 0x4C, 0xFF}}},
	{{{30, -48, 157}, 0, {-16, 1008}, {0x00, 0xC4, 0x70, 0xFF}}},
	{{{119, -51, 142}, 0, {-16, 1008}, {0x4C, 0xBD, 0x4C, 0xFF}}},
	{{{186, 236, 95}, 0, {-16, 1008}, {0x75, 0x29, 0x1A, 0xFF}}},
	{{{30, 347, 141}, 0, {-16, 1008}, {0x00, 0x70, 0x3C, 0xFF}}},
	{{{-81, 236, 187}, 0, {-16, 1008}, {0xB3, 0x22, 0x5F, 0xFF}}},
	{{{30, 236, 209}, 0, {-16, 1008}, {0x00, 0x17, 0x7D, 0xFF}}},
	{{{142, 236, 187}, 0, {-16, 1008}, {0x4D, 0x22, 0x5F, 0xFF}}},
};

Gfx goomba_lowpoly_foot_R_mesh_layer_1_tri_0[] = {
	gsSPVertex(goomba_lowpoly_foot_R_mesh_layer_1_vtx_0 + 0, 27, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(0, 4, 3, 0, 0, 5, 4, 0),
	gsSP2Triangles(6, 7, 8, 0, 6, 9, 7, 0),
	gsSP2Triangles(6, 10, 9, 0, 6, 11, 10, 0),
	gsSP2Triangles(12, 10, 11, 0, 12, 11, 13, 0),
	gsSP2Triangles(12, 13, 14, 0, 13, 15, 14, 0),
	gsSP2Triangles(16, 14, 15, 0, 17, 14, 16, 0),
	gsSP2Triangles(17, 16, 8, 0, 17, 8, 7, 0),
	gsSP2Triangles(7, 18, 17, 0, 19, 18, 7, 0),
	gsSP2Triangles(19, 7, 9, 0, 19, 9, 20, 0),
	gsSP2Triangles(21, 20, 9, 0, 21, 9, 10, 0),
	gsSP2Triangles(21, 10, 22, 0, 10, 12, 22, 0),
	gsSP2Triangles(22, 12, 14, 0, 23, 22, 14, 0),
	gsSP2Triangles(23, 14, 18, 0, 18, 14, 17, 0),
	gsSP2Triangles(24, 23, 18, 0, 23, 24, 25, 0),
	gsSP2Triangles(20, 25, 24, 0, 20, 24, 19, 0),
	gsSP2Triangles(18, 19, 24, 0, 20, 26, 25, 0),
	gsSP2Triangles(20, 21, 26, 0, 22, 26, 21, 0),
	gsSP2Triangles(26, 22, 23, 0, 23, 25, 26, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_eyes_mesh_layer_1_vtx_0[7] = {
	{{{-195, 637, -38}, 0, {85, -92}, {0xA9, 0x5C, 0xF6, 0xFF}}},
	{{{-188, 531, 237}, 0, {496, 137}, {0xC1, 0x4E, 0x4E, 0xFF}}},
	{{{-55, 723, 72}, 0, {496, -330}, {0xDF, 0x73, 0x29, 0xFF}}},
	{{{-436, 301, 15}, 0, {-156, 907}, {0x8E, 0x36, 0x0C, 0xFF}}},
	{{{-274, 264, 343}, 0, {496, 968}, {0xB5, 0x29, 0x5E, 0xFF}}},
	{{{81, 301, 432}, 0, {1148, 907}, {0x0D, 0x36, 0x72, 0xFF}}},
	{{{82, 637, 185}, 0, {907, -92}, {0x1D, 0x5C, 0x53, 0xFF}}},
};

Gfx goomba_lowpoly_eyes_mesh_layer_1_tri_0[] = {
	gsSPVertex(goomba_lowpoly_eyes_mesh_layer_1_vtx_0 + 0, 7, 0),
	gsSP2Triangles(0, 1, 2, 0, 1, 0, 3, 0),
	gsSP2Triangles(1, 3, 4, 0, 1, 4, 5, 0),
	gsSP2Triangles(1, 5, 6, 0, 6, 2, 1, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_eyes_mesh_layer_5_vtx_0[8] = {
	{{{-160, 483, 266}, 0, {-16, 1008}, {0xD5, 0x27, 0x71, 0xFF}}},
	{{{175, 721, 311}, 0, {1008, -16}, {0xD5, 0x27, 0x71, 0xFF}}},
	{{{-92, 759, 197}, 0, {-16, -16}, {0xD5, 0x27, 0x71, 0xFF}}},
	{{{106, 445, 380}, 0, {1008, 1008}, {0xD5, 0x27, 0x71, 0xFF}}},
	{{{-223, 483, 216}, 0, {-16, 1008}, {0x9A, 0x27, 0x41, 0xFF}}},
	{{{-170, 759, 134}, 0, {-16, -16}, {0x9A, 0x27, 0x41, 0xFF}}},
	{{{-337, 721, -103}, 0, {1008, -16}, {0x9A, 0x27, 0x41, 0xFF}}},
	{{{-390, 445, -21}, 0, {1008, 1008}, {0x9A, 0x27, 0x41, 0xFF}}},
};

Gfx goomba_lowpoly_eyes_mesh_layer_5_tri_0[] = {
	gsSPVertex(goomba_lowpoly_eyes_mesh_layer_5_vtx_0 + 0, 8, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(4, 5, 6, 0, 4, 6, 7, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_1_vtx_0[7] = {
	{{{-195, 637, -38}, 0, {85, -92}, {0xA9, 0x5C, 0xF6, 0xFF}}},
	{{{-188, 531, 237}, 0, {496, 137}, {0xC1, 0x4E, 0x4E, 0xFF}}},
	{{{-55, 723, 72}, 0, {496, -330}, {0xDF, 0x73, 0x29, 0xFF}}},
	{{{-436, 301, 15}, 0, {-156, 907}, {0x8E, 0x36, 0x0C, 0xFF}}},
	{{{-274, 264, 343}, 0, {496, 968}, {0xB5, 0x29, 0x5E, 0xFF}}},
	{{{81, 301, 432}, 0, {1148, 907}, {0x0D, 0x36, 0x72, 0xFF}}},
	{{{82, 637, 185}, 0, {907, -92}, {0x1D, 0x5C, 0x53, 0xFF}}},
};

Gfx goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_1_tri_0[] = {
	gsSPVertex(goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_1_vtx_0 + 0, 7, 0),
	gsSP2Triangles(0, 1, 2, 0, 1, 0, 3, 0),
	gsSP2Triangles(1, 3, 4, 0, 1, 4, 5, 0),
	gsSP2Triangles(1, 5, 6, 0, 6, 2, 1, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_5_vtx_0[8] = {
	{{{-160, 483, 266}, 0, {-16, 1008}, {0xD5, 0x27, 0x71, 0xFF}}},
	{{{175, 721, 311}, 0, {1008, -16}, {0xD5, 0x27, 0x71, 0xFF}}},
	{{{-92, 759, 197}, 0, {-16, -16}, {0xD5, 0x27, 0x71, 0xFF}}},
	{{{106, 445, 380}, 0, {1008, 1008}, {0xD5, 0x27, 0x71, 0xFF}}},
	{{{-223, 483, 216}, 0, {-16, 1008}, {0x9A, 0x27, 0x41, 0xFF}}},
	{{{-170, 759, 134}, 0, {-16, -16}, {0x9A, 0x27, 0x41, 0xFF}}},
	{{{-337, 721, -103}, 0, {1008, -16}, {0x9A, 0x27, 0x41, 0xFF}}},
	{{{-390, 445, -21}, 0, {1008, 1008}, {0x9A, 0x27, 0x41, 0xFF}}},
};

Gfx goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_5_tri_0[] = {
	gsSPVertex(goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_5_vtx_0 + 0, 8, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(4, 5, 6, 0, 4, 6, 7, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_1_vtx_0[7] = {
	{{{-195, 637, -38}, 0, {85, -92}, {0xA9, 0x5C, 0xF6, 0xFF}}},
	{{{-188, 531, 237}, 0, {496, 137}, {0xC1, 0x4E, 0x4E, 0xFF}}},
	{{{-55, 723, 72}, 0, {496, -330}, {0xDF, 0x73, 0x29, 0xFF}}},
	{{{-436, 301, 15}, 0, {-156, 907}, {0x8E, 0x36, 0x0C, 0xFF}}},
	{{{-274, 264, 343}, 0, {496, 968}, {0xB5, 0x29, 0x5E, 0xFF}}},
	{{{81, 301, 432}, 0, {1148, 907}, {0x0D, 0x36, 0x72, 0xFF}}},
	{{{82, 637, 185}, 0, {907, -92}, {0x1D, 0x5C, 0x53, 0xFF}}},
};

Gfx goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_0[] = {
	gsSPVertex(goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_1_vtx_0 + 0, 7, 0),
	gsSP2Triangles(0, 1, 2, 0, 1, 0, 3, 0),
	gsSP2Triangles(1, 3, 4, 0, 1, 4, 5, 0),
	gsSP2Triangles(1, 5, 6, 0, 6, 2, 1, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_5_vtx_0[8] = {
	{{{-191, 484, 254}, 0, {-16, 1008}, {0xBF, 0x2F, 0x63, 0xFF}}},
	{{{106, 847, 274}, 0, {1008, -16}, {0xC0, 0x2F, 0x63, 0xFF}}},
	{{{-185, 804, 97}, 0, {-16, -16}, {0xBE, 0x31, 0x61, 0xFF}}},
	{{{60, 588, 362}, 0, {1008, 1008}, {0xC2, 0x2D, 0x65, 0xFF}}},
	{{{-208, 484, 240}, 0, {-16, 1008}, {0xAD, 0x2F, 0x54, 0xFF}}},
	{{{-56, 804, 201}, 0, {-16, -16}, {0xAF, 0x31, 0x55, 0xFF}}},
	{{{-290, 847, -46}, 0, {1008, -16}, {0xAD, 0x2F, 0x54, 0xFF}}},
	{{{-367, 588, 17}, 0, {1008, 1008}, {0xAA, 0x2D, 0x52, 0xFF}}},
};

Gfx goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_5_tri_0[] = {
	gsSPVertex(goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_5_vtx_0 + 0, 8, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(4, 5, 6, 0, 4, 6, 7, 0),
	gsSPEndDisplayList(),
};

Vtx goomba_lowpoly_mouth_mesh_layer_1_vtx_0[47] = {
	{{{-55, 723, 72}, 0, {-2489, -1366}, {0xDF, 0x73, 0x29, 0xFF}}},
	{{{-47, 704, -101}, 0, {-2961, -1278}, {0xDD, 0x6D, 0xCA, 0xFF}}},
	{{{-195, 637, -38}, 0, {-3310, -1056}, {0xA9, 0x5C, 0xF6, 0xFF}}},
	{{{35, 747, -40}, 0, {-2489, -1430}, {0x0E, 0x7D, 0xEF, 0xFF}}},
	{{{112, 704, 27}, 0, {-2018, -1278}, {0x3C, 0x6D, 0x17, 0xFF}}},
	{{{82, 637, 185}, 0, {-1669, -1056}, {0x1D, 0x5C, 0x53, 0xFF}}},
	{{{221, 583, 120}, 0, {-1359, -845}, {0x51, 0x53, 0x34, 0xFF}}},
	{{{410, 230, 278}, 0, {-225, 421}, {0x5A, 0x31, 0x4B, 0xFF}}},
	{{{81, 301, 432}, 0, {-958, 120}, {0x0D, 0x36, 0x72, 0xFF}}},
	{{{221, 73, 465}, 0, {-359, 948}, {0x2F, 0xDD, 0x71, 0xFF}}},
	{{{431, 80, 296}, 0, {-96, 961}, {0x62, 0xDD, 0x48, 0xFF}}},
	{{{375, 1, 246}, 0, {-442, 1244}, {0x36, 0x93, 0x24, 0xFF}}},
	{{{47, -17, 404}, 0, {-1163, 1263}, {0x03, 0x8F, 0x39, 0xFF}}},
	{{{15, -60, -15}, 0, {-2489, 1457}, {0x01, 0x81, 0xFE, 0xFF}}},
	{{{-260, 6, 326}, 0, {-2489, 1161}, {0xD2, 0x98, 0x39, 0xFF}}},
	{{{-400, -17, 41}, 0, {-3816, 1263}, {0xC8, 0x8F, 0x09, 0xFF}}},
	{{{-316, 1, -312}, 0, {-4537, 1244}, {0xD2, 0x93, 0xD3, 0xFF}}},
	{{{-498, 73, -115}, 0, {-4620, 948}, {0x88, 0xDD, 0xEA, 0xFF}}},
	{{{-377, 80, -356}, 0, {-4882, 961}, {0xA4, 0xDD, 0xAF, 0xFF}}},
	{{{-354, 230, -339}, 0, {-4754, 421}, {0xA4, 0x31, 0xB7, 0xFF}}},
	{{{-436, 301, 15}, 0, {-4021, 120}, {0x8E, 0x36, 0x0C, 0xFF}}},
	{{{-160, 583, -188}, 0, {-3619, -845}, {0xBC, 0x53, 0xBC, 0xFF}}},
	{{{-40, 544, -293}, 0, {-3491, -680}, {0xF3, 0x50, 0x9E, 0xFF}}},
	{{{132, 657, -159}, 0, {-2489, -1086}, {0x34, 0x60, 0xC0, 0xFF}}},
	{{{298, 544, -20}, 0, {-1487, -680}, {0x62, 0x50, 0xF8, 0xFF}}},
	{{{517, 231, 39}, 0, {-532, 454}, {0x75, 0x32, 0x07, 0xFF}}},
	{{{544, 91, 18}, 0, {-495, 961}, {0x7A, 0xDD, 0x04, 0xFF}}},
	{{{443, -6, 0}, 0, {-908, 1303}, {0x3C, 0x90, 0xFD, 0xFF}}},
	{{{278, 13, -341}, 0, {-2489, 1254}, {0x2E, 0x98, 0xC7, 0xFF}}},
	{{{-90, -6, -430}, 0, {-4070, 1303}, {0xF7, 0x90, 0xC5, 0xFF}}},
	{{{-129, 91, -525}, 0, {-4483, 961}, {0xE2, 0xDD, 0x8A, 0xFF}}},
	{{{-143, 231, -494}, 0, {-4447, 454}, {0xE0, 0x32, 0x8F, 0xFF}}},
	{{{296, 304, -363}, 0, {-2489, 217}, {0x47, 0x3B, 0xA8, 0xFF}}},
	{{{472, 97, -233}, 0, {-1482, 961}, {0x6C, 0xE3, 0xC5, 0xFF}}},
	{{{323, 135, -396}, 0, {-2489, 830}, {0x4F, 0xF3, 0x9E, 0xFF}}},
	{{{132, 97, -508}, 0, {-3497, 961}, {0x23, 0xE3, 0x89, 0xFF}}},
	{{{-498, 73, -115}, 0, {-432, 918}, {0x88, 0xDD, 0xEA, 0xFF}}},
	{{{-400, -17, 41}, 0, {132, 1195}, {0xC8, 0x8F, 0x09, 0xFF}}},
	{{{-449, 60, 163}, 0, {360, 851}, {0x92, 0xDD, 0x34, 0xFF}}},
	{{{-260, 6, 326}, 0, {1009, 1042}, {0xD2, 0x98, 0x39, 0xFF}}},
	{{{-298, 98, 373}, 0, {1009, 727}, {0xB1, 0xF3, 0x62, 0xFF}}},
	{{{-61, 60, 476}, 0, {1658, 851}, {0xE4, 0xDD, 0x77, 0xFF}}},
	{{{47, -17, 404}, 0, {1885, 1195}, {0x03, 0x8F, 0x39, 0xFF}}},
	{{{221, 73, 465}, 0, {2449, 918}, {0x2F, 0xDD, 0x71, 0xFF}}},
	{{{81, 301, 432}, 0, {2050, 165}, {0x0D, 0x36, 0x72, 0xFF}}},
	{{{-274, 264, 343}, 0, {1009, 273}, {0xB5, 0x29, 0x5E, 0xFF}}},
	{{{-436, 301, 15}, 0, {-32, 165}, {0x8E, 0x36, 0x0C, 0xFF}}},
};

Gfx goomba_lowpoly_mouth_mesh_layer_1_tri_0[] = {
	gsSPVertex(goomba_lowpoly_mouth_mesh_layer_1_vtx_0 + 0, 47, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 3, 1, 0),
	gsSP2Triangles(0, 4, 3, 0, 0, 5, 4, 0),
	gsSP2Triangles(5, 6, 4, 0, 5, 7, 6, 0),
	gsSP2Triangles(8, 7, 5, 0, 7, 8, 9, 0),
	gsSP2Triangles(10, 7, 9, 0, 11, 10, 9, 0),
	gsSP2Triangles(11, 9, 12, 0, 12, 13, 11, 0),
	gsSP2Triangles(13, 12, 14, 0, 13, 14, 15, 0),
	gsSP2Triangles(15, 16, 13, 0, 16, 15, 17, 0),
	gsSP2Triangles(16, 17, 18, 0, 18, 17, 19, 0),
	gsSP2Triangles(19, 17, 20, 0, 20, 2, 19, 0),
	gsSP2Triangles(2, 21, 19, 0, 2, 1, 21, 0),
	gsSP2Triangles(1, 22, 21, 0, 23, 22, 1, 0),
	gsSP2Triangles(23, 1, 3, 0, 23, 3, 4, 0),
	gsSP2Triangles(23, 4, 24, 0, 4, 6, 24, 0),
	gsSP2Triangles(7, 24, 6, 0, 7, 25, 24, 0),
	gsSP2Triangles(10, 25, 7, 0, 25, 10, 26, 0),
	gsSP2Triangles(27, 26, 10, 0, 27, 10, 11, 0),
	gsSP2Triangles(11, 13, 27, 0, 28, 27, 13, 0),
	gsSP2Triangles(28, 13, 29, 0, 16, 29, 13, 0),
	gsSP2Triangles(29, 16, 18, 0, 29, 18, 30, 0),
	gsSP2Triangles(31, 30, 18, 0, 18, 19, 31, 0),
	gsSP2Triangles(19, 22, 31, 0, 19, 21, 22, 0),
	gsSP2Triangles(22, 32, 31, 0, 22, 23, 32, 0),
	gsSP2Triangles(24, 32, 23, 0, 24, 25, 32, 0),
	gsSP2Triangles(32, 25, 33, 0, 25, 26, 33, 0),
	gsSP2Triangles(33, 26, 27, 0, 27, 28, 33, 0),
	gsSP2Triangles(28, 34, 33, 0, 28, 35, 34, 0),
	gsSP2Triangles(29, 35, 28, 0, 35, 29, 30, 0),
	gsSP2Triangles(31, 35, 30, 0, 32, 35, 31, 0),
	gsSP2Triangles(34, 35, 32, 0, 34, 32, 33, 0),
	gsSP2Triangles(36, 37, 38, 0, 39, 38, 37, 0),
	gsSP2Triangles(39, 40, 38, 0, 39, 41, 40, 0),
	gsSP2Triangles(39, 42, 41, 0, 43, 41, 42, 0),
	gsSP2Triangles(44, 41, 43, 0, 40, 41, 44, 0),
	gsSP2Triangles(40, 44, 45, 0, 40, 45, 46, 0),
	gsSP2Triangles(40, 46, 38, 0, 46, 36, 38, 0),
	gsSPEndDisplayList(),
};


Gfx mat_goomba_lowpoly_Body[] = {
	gsSPSetLights1(goomba_lowpoly_Body_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_goomba_lowpoly_Body[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_goomba_lowpoly_Feet[] = {
	gsSPSetLights1(goomba_lowpoly_Feet_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_goomba_lowpoly_Feet[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_goomba_lowpoly_Eyes[] = {
	gsSPSetLights1(goomba_lowpoly_Eyes_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, goomba_lowpoly_EyesOpen_color_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 1023, 128),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 8, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_goomba_lowpoly_Eyes[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_goomba_lowpoly_Eyebrows[] = {
	gsSPClearGeometryMode(G_CULL_BACK),
	gsSPSetLights1(goomba_lowpoly_Eyebrows_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, TEXEL0, 0, PRIMITIVE, 0, TEXEL0, 0, SHADE, 0, TEXEL0, 0, PRIMITIVE, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetPrimColor(0, 0, 255, 255, 255, 255),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, goomba_lowpoly_Eyebrow1_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 1023, 128),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 8, 0, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0, G_TX_WRAP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_goomba_lowpoly_Eyebrows[] = {
	gsSPSetGeometryMode(G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_goomba_lowpoly_EyesClosed[] = {
	gsSPSetLights1(goomba_lowpoly_EyesClosed_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, goomba_lowpoly_EyesClosed_color_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 1023, 128),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 8, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_goomba_lowpoly_EyesClosed[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_goomba_lowpoly_EyesDazed[] = {
	gsSPSetLights1(goomba_lowpoly_EyesDazed_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, goomba_lowpoly_EyesDazed_color_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 1023, 128),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 8, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_goomba_lowpoly_EyesDazed[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_goomba_lowpoly_Mouth[] = {
	gsSPSetLights1(goomba_lowpoly_Mouth_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, goomba_lowpoly_Mouth_color1_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 2047, 64),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 16, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 6, 0),
	gsDPSetTileSize(0, 0, 0, 252, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_goomba_lowpoly_Mouth[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_goomba_lowpoly_MouthOpen[] = {
	gsSPSetLights1(goomba_lowpoly_MouthOpen_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT, TEXEL0, 0, SHADE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, goomba_lowpoly_MouthOpenColor_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 2047, 64),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 16, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_WRAP | G_TX_MIRROR, 6, 0),
	gsDPSetTileSize(0, 0, 0, 252, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_goomba_lowpoly_MouthOpen[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_body_mesh_layer_1[] = {
	gsSPDisplayList(mat_goomba_lowpoly_Body),
	gsSPDisplayList(goomba_lowpoly_body_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_Body),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_foot_L_mesh_layer_1[] = {
	gsSPDisplayList(mat_goomba_lowpoly_Feet),
	gsSPDisplayList(goomba_lowpoly_foot_L_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_Feet),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_foot_R_mesh_layer_1[] = {
	gsSPDisplayList(mat_goomba_lowpoly_Feet),
	gsSPDisplayList(goomba_lowpoly_foot_R_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_Feet),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_eyes_mesh_layer_1[] = {
	gsSPDisplayList(mat_goomba_lowpoly_Eyes),
	gsSPDisplayList(goomba_lowpoly_eyes_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_Eyes),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_eyes_mesh_layer_5[] = {
	gsSPDisplayList(mat_goomba_lowpoly_Eyebrows),
	gsSPDisplayList(goomba_lowpoly_eyes_mesh_layer_5_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_Eyebrows),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_1[] = {
	gsSPDisplayList(mat_goomba_lowpoly_EyesClosed),
	gsSPDisplayList(goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_EyesClosed),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_5[] = {
	gsSPDisplayList(mat_goomba_lowpoly_Eyebrows),
	gsSPDisplayList(goomba_lowpoly_eyes_closed_switch_eyes_closed_mesh_layer_5_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_Eyebrows),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_1[] = {
	gsSPDisplayList(mat_goomba_lowpoly_EyesDazed),
	gsSPDisplayList(goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_EyesDazed),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_5[] = {
	gsSPDisplayList(mat_goomba_lowpoly_Eyebrows),
	gsSPDisplayList(goomba_lowpoly_eyes_dazed_switch_eyes_dazed_mesh_layer_5_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_Eyebrows),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_mouth_mesh_layer_1[] = {
	gsSPDisplayList(mat_goomba_lowpoly_Mouth),
	gsSPDisplayList(goomba_lowpoly_mouth_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_Mouth),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx goomba_lowpoly_mouth_mesh_layer_1_mat_override_MouthOpen_0[] = {
	gsSPDisplayList(mat_goomba_lowpoly_MouthOpen),
	gsSPDisplayList(goomba_lowpoly_mouth_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_goomba_lowpoly_MouthOpen),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

