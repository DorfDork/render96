void scroll_bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3() {
	int i = 0;
	int count = 4;
	int width = 32 * 0x20;

	static int currentX = 0;
	int deltaX;
	Vtx *vertices = segmented_to_virtual(bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3);

	deltaX = (int)(1.0 * 0x20) % width;

	if (absi(currentX) > width) {
		deltaX -= (int)(absi(currentX) / width) * width * signum_positive(deltaX);
	}

	for (i = 0; i < count; i++) {
		vertices[i].n.tc[0] += deltaX;
	}
	currentX += deltaX;
}

void scroll_bowser_2() {
	scroll_bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3();
};
