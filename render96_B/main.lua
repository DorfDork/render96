-- name: Render96 B Mod Pack
-- description: A Mod Pack That Adds All Render96 Features To The Game
-- author: \#ff3030\Render96DX Team

define_custom_obj_fields({
    oSwitchState1       = 'f32',
    oSwitchTimer1       = 's32',
    oSwitchState2       = 'f32',
    oSwitchTimer2       = 's32',
    oMrIBlinkIndex      = 's32',
    oMrITracking        = 'f32',
    oMrILastAngle       = 'f32',
    oMrIFireTimer       = 'f32',
    oMrIDizzyTimer      = 'f32',
    oMrIDizzyDuration   = 'f32',
    oMrIDetectRadius    = 'f32',
    oThwompShakeTicks   = 'f32',
    oThwompPosMag       = 'f32',
    oThwompAngleMag     = 'f32',
    oThwompPrevAction   = 'f32',
    oThwompSquishTimer  = 'f32',
    oThwompSquishDur    = 'f32',
    oThwompBaseScale    = 'f32',
    oWarioHeadBool      = 'f32',
    oCelebrationStar    = 'f32',
    oColorR             = 'f32',
    oColorG             = 'f32',
    oColorB             = 'f32'
})

function geo_switch_amp_glow_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end
function geo_switch_amp_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_boo_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_boo_big_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_boo_king_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_bubba_swim_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_bully_eye_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end
function geo_switch_chain_chomp_face(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_chillychief_eye_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end
function geo_switch_goomba_mouth_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_goomba_eye_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end
function geo_switch_mr_i_face_state(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_thwomp_face(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_plant_face(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_toad_hat(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end
function geo_switch_toad_vest(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState2 return end
function geo_switch_tuxie_mother(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end
function geo_switch_bubba_body(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end

function geo_function_chuckya_spin(node, matStackIndex) 
    local o = geo_get_current_object()
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local rot = (o.oTimer * 0x2000) & 0xFFFF
    rotN.rotation.x = rot

    return
end

function geo_function_scuttle_body(node, matStackIndex) 
    local o = geo_get_current_object()
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local rot = (o.oTimer * 0x200) & 0xFFFF
    rotN.rotation.x = rot
    rotN.rotation.y = rot
    rotN.rotation.z = rot

    return
end

function geo_color_update(node, matStackIndex)

end

function apply_color(mat, r, g, b)
    local function parse_dl(cmd, op)
        if op == G_SETPRIMCOLOR then
            gfx_set_command(cmd, "gsDPSetPrimColor(0, 0, %i, %i, %i, 255)", r, g, b)
        end
    end

    gfx_parse(mat, parse_dl)
end

function geo_function_bobomb_angry(node, matStackIndex)
    local o = geo_get_current_object()
    local matDisplayList = cast_graph_node(node.next) ---@type GraphNodeDisplayList

local custom = gfx_get_from_name("bobomb_angry_mat_"..tostring(o._pointer))
    if custom == nil then
        local len = gfx_get_length(matDisplayList.displayList)
custom = gfx_create("bobomb_angry_mat_"..tostring(o._pointer), len)
        gfx_copy(custom, matDisplayList.displayList, len)
    end
    local mat = gfx_get_command(custom, 0)
    apply_color(custom, o.oColorR, o.oColorG, o.oColorB)
    cast_graph_node(node.next).displayList = custom
end