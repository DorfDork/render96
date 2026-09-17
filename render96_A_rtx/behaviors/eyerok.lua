require("/constants")

local _clamp = math.clamp
local _s16   = math.s16

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_function_eyerok(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end

    local player = nearest_player_to_object(o)
    if player == nil then return end

    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation

    local angleToPlayerYaw   = obj_angle_to_object(o, player)
    local angleToPlayerPitch = obj_pitch_to_object(o, player)

    local limitYaw   = 0x2000 -- 45 degrees
    local limitPitch = 0x1000 -- ~22 degrees

    local yaw   = _clamp(_s16(angleToPlayerYaw - o.oFaceAngleYaw), -limitYaw,   limitYaw)
    local pitch = _clamp(_s16(angleToPlayerPitch),                 -limitPitch, limitPitch)

    if obj_has_model_extended(o, E_MODEL_EYEROK_LEFT_HAND) then
        yaw = -yaw
    end

    rotN.rotation.x = yaw   & 0xFFFF
    rotN.rotation.y = 0
    rotN.rotation.z = pitch & 0xFFFF
end
