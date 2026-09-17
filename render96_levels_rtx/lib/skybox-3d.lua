-- skybox-3d.lua
-- Handles 3D Skyboxes per level
-- Made by flipflopbell

local sSkyboxModelPerLevel = {}

---@param levelNum LevelNum
local function get_level_skybox_model(levelNum)
    return sSkyboxModelPerLevel[levelNum]
end

---@param levelNum LevelNum
---@param modelId ModelExtendedId
local function set_level_skybox_model(levelNum, modelId)
    sSkyboxModelPerLevel[levelNum] = modelId
end

local ls = gLakituState

-- We defer spawning until Mario exists (spawn_non_sync_object spawns as a child of local Mario).
local sPendingSkyboxRefresh = false

---@param o Object
local function bhv_skybox_3d_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.skipInViewCheck = true
    obj_scale(o, 10.0)
end

-- Keep the skybox centered on the camera.
---@param o Object
local function bhv_skybox_3d_loop(o)
    o.oPosX = ls.pos.x
    o.oPosY = ls.pos.y
    o.oPosZ = ls.pos.z
end

id_bhvSkybox3D = hook_behavior(nil, OBJ_LIST_LEVEL, true, bhv_skybox_3d_init, bhv_skybox_3d_loop, "bhv3DSkybox")

local function spawn_skybox_3d()
    local levelNum = gNetworkPlayers[0].currLevelNum
    local desiredModel = sSkyboxModelPerLevel[levelNum]
    local skyboxObj = obj_get_first_with_behavior_id(id_bhvSkybox3D)

    if desiredModel == nil or desiredModel == E_MODEL_NONE then
        if skyboxObj ~= nil then
            obj_mark_for_deletion(skyboxObj)
        end
        return true
    end

    if skyboxObj ~= nil and obj_has_model_extended(skyboxObj, desiredModel) == 0 then
        obj_mark_for_deletion(skyboxObj)
        skyboxObj = nil
    end

    if skyboxObj == nil then
        spawn_non_sync_object(id_bhvSkybox3D, desiredModel, ls.pos.x, ls.pos.y, ls.pos.z, nil)
    end

    return true
end

local function refresh_skybox_3d()
    sPendingSkyboxRefresh = true
end

local function update_skybox_3d()
    if sPendingSkyboxRefresh and spawn_skybox_3d() then
        sPendingSkyboxRefresh = false
    end
end

hook_event(HOOK_ON_LEVEL_INIT, refresh_skybox_3d)
hook_event(HOOK_ON_WARP, refresh_skybox_3d)
hook_event(HOOK_UPDATE, update_skybox_3d)

return {
    get_level_skybox_model = get_level_skybox_model,
    set_level_skybox_model = set_level_skybox_model,
}
