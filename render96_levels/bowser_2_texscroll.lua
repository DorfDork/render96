local function scroll_bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3() 
	local count = 4;
	local deltaX = 33;
	local vertices = vtx_get_from_name('bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3');
	for i = 0, count - 1 do
		local v = vtx_get_vertex(vertices, i)
		v.tu = v.tu + deltaX;
	end
end

local function scroll_bowser_2()
	scroll_bowser_2_dl_bowser_2_environment_mesh_layer_1_vtx_3();
end

hook_event(HOOK_UPDATE, scroll_bowser_2)