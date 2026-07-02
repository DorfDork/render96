-- 3d-skybox.lua
-- Handles 3D Skyboxes per level
-- Made by flipflopbell

E_MODEL_SKYBOX_BOWSER_1 = smlua_model_util_get_id("skybox_bowser_1_geo")

-- Per-level skybox configuration.
-- Add entries like: [LEVEL_BOB] = smlua_model_util_get_id("skybox_bob_geo")
local SKYBOX_MODEL_BY_LEVEL = {
    [LEVEL_BOWSER_1] = E_MODEL_SKYBOX_BOWSER_1,
}

-- Behavior
local cam = gLakituState

-- We defer spawning until Mario exists (spawn_non_sync_object spawns as a child of local Mario).
local sPendingSkyboxRefresh = false

function bhv_skybox_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.skipInViewCheck = true
    obj_scale(o, 10.0)
end

-- Keep the skybox centered on the camera.
function bhv_skybox_loop(o)
    o.oPosX = cam.pos.x
    o.oPosY = cam.pos.y
    o.oPosZ = cam.pos.z
end

id_bhv3DSkybox = hook_behavior(nil, OBJ_LIST_LEVEL, false, bhv_skybox_init, bhv_skybox_loop)

function SpawnSkybox()
    if id_bhv3DSkybox == nil then return end

    local levelNum = gNetworkPlayers[0].currLevelNum
    if levelNum == nil then
        return false
    end
    local desiredModel = SKYBOX_MODEL_BY_LEVEL[levelNum]
    local skyboxObj = obj_get_first_with_behavior_id(id_bhv3DSkybox)

    if desiredModel == nil or desiredModel == 0 then
        if skyboxObj ~= nil then
            obj_mark_for_deletion(skyboxObj)
        end
        return true
    end

    if skyboxObj ~= nil then
        local existingModel = obj_get_model_id_extended(skyboxObj)
        if existingModel ~= desiredModel then
            obj_mark_for_deletion(skyboxObj)
            skyboxObj = nil
        end
    end

    if skyboxObj == nil then
        spawn_non_sync_object(id_bhv3DSkybox, desiredModel, cam.pos.x, cam.pos.y, cam.pos.z, nil)
    end

    return true
end

function SkyboxOnLevelInit()
    sPendingSkyboxRefresh = true
end

function SkyboxOnWarp()
    sPendingSkyboxRefresh = true
end

function SkyboxOnUpdate()
    if not sPendingSkyboxRefresh then return end
    if gMarioStates == nil or gMarioStates[0] == nil then return end
    if gMarioStates[0].marioObj == nil then return end

    local done = SpawnSkybox()
    if done then
        sPendingSkyboxRefresh = false
    end
end

hook_event(HOOK_ON_LEVEL_INIT, SkyboxOnLevelInit)
hook_event(HOOK_ON_WARP, SkyboxOnWarp)
hook_event(HOOK_UPDATE, SkyboxOnUpdate)
