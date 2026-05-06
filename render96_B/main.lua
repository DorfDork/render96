-- name: Render96 B Mod Pack
-- description: A Mod Pack That Adds All Render96 Features To The Game
-- author: \#ff3030\Render96DX Team

define_custom_obj_fields({
    oSwitchState1       = 'f32',
    oSwitchTimer1       = 'f32',
    oSwitchState2       = 'f32',
    oSwitchTimer2       = 'f32',
    oMrIBlinkIndex      = 'f32',
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
    oMusic              = 'f32',
    oCelebrationStar    = 'f32'
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
function geo_switch_tuxie(node, matStackIndex) cast_graph_node(node).selectedCase = geo_get_current_object().oSwitchState1 return end