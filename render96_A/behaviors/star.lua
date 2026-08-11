local r96lib = require("/lib/r96lib")
require("/constants")

local _floor = math.floor

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function is_star_collected(o)
    local starId = o.oBehParams >> 24
    local currentLevelStarFlags = save_file_get_star_flags(get_current_save_file_num() - 1,
    (gLevelValues.useGlobalStarIds ~= 0 and (_floor(starId / 7) - 1) or (gNetworkPlayers[0].currCourseNum - 1)))
    local starBit = gLevelValues.useGlobalStarIds and (starId % 7) or starId
    return currentLevelStarFlags & (1 << starBit) ~= 0
end

---@param o Object
local function bhv_star_render96_init(o)
    if not is_star_collected(o) or obj_has_behavior_id(o, id_bhvCelebrationStar) == 1 then
        spawn_non_sync_object(id_bhvRender96StarParticle, E_MODEL_R96_STAR_PARTICLE, o.oPosX, o.oPosY, o.oPosZ, function(o2)
            o2.parentObj = o
        end)
    else
        spawn_non_sync_object(id_bhvRender96StarParticle, E_MODEL_R96_STAR_TRANSPARENT_PARTICLE, o.oPosX, o.oPosY, o.oPosZ, function(o2)
            o2.parentObj = o
        end)
    end
end

---@param o Object
local function bhv_star_render96_loop(o)
    local m = gMarioStates[0]
    if m.action ~= ACT_CREDITS_CUTSCENE then
        r96lib.audio_fade(o, AUDIO_R96_STAR_AMBIENT, nil, nil, true, 2258, 86840)
    end
end

id_bhvRender96Star = r96lib.hook_behavior(id_bhvStar, false, bhv_star_render96_init, bhv_star_render96_loop)
id_bhvRender96SpawnedStar = r96lib.hook_behavior(id_bhvSpawnedStar, false, bhv_star_render96_init, bhv_star_render96_loop)
id_bhvRender96SpawnedStarNoLevelExit = r96lib.hook_behavior(id_bhvSpawnedStarNoLevelExit, false, bhv_star_render96_init, bhv_star_render96_loop)
--id_bhvRender96HiddenStar = r96lib.hook_behavior(id_bhvHiddenStar, false, bhv_star_render96_init, bhv_star_render96_loop)
id_bhvRender96SpawnCoordStar = r96lib.hook_behavior(id_bhvStarSpawnCoordinates, false, bhv_star_render96_init, bhv_star_render96_loop)
id_bhvRender96CelebrationStar = r96lib.hook_behavior(id_bhvCelebrationStar, false, bhv_star_render96_init)

---@param o Object
local function bhv_star_particle_render96_init(o)
    o.header.gfx.node.flags = (o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD) & ~GRAPH_RENDER_INVISIBLE
    o.activeFlags = ACTIVE_FLAG_ACTIVE | ACTIVE_FLAG_INITIATED_TIME_STOP
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oCelebrationStar = 0
    cur_obj_scale(3)
end

---@param o Object
local function get_star_object(o)
    local star = o.parentObj
    if star == nil then return nil end
    if obj_has_behavior_id(star, id_bhvCelebrationStar) == 1 then
        o.oCelebrationStar = 1
    else
        o.oCelebrationStar = 0
    end
    return star
end

---@param timer integer
local function get_star_scale(timer)
    if timer < 10 then return 0 end
    if timer >= 60 then return 3 end
    return (timer - 10) / 50 * 3
end

---@param o Object
local function bhv_star_particle_loop(o)
    smlua_anim_util_set_animation(o, ANIM_R96_STAR_GLOW)
    local star = get_star_object(o)
    if star ~= nil then
        obj_set_pos(o, star.oPosX, star.oPosY, star.oPosZ)
    end
    if obj_is_hidden(o.parentObj) ~= 0 or (obj_has_behavior_id(o.parentObj, id_bhvHiddenStar) ~= 0 and o.oAction == 0) then
        cur_obj_hide()
    else
        cur_obj_unhide()
    end
    if o.oCelebrationStar == 1 then
        local scale = get_star_scale(o.oTimer)
        cur_obj_scale(scale)
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~(GRAPH_RENDER_INVISIBLE | GRAPH_RENDER_BILLBOARD)
    end
    if not o.parentObj or (o.parentObj.oTimer > 0 and o.parentObj.activeFlags == ACTIVE_FLAG_DEACTIVATED) then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96StarParticle = r96lib.hook_behavior(nil, false, bhv_star_particle_render96_init, bhv_star_particle_loop, OBJ_LIST_UNIMPORTANT, "StarParticle")

---------------
-- UV scroll --
---------------

--UvScroll.hook_scrolling_function("star_particle_001_displaylist_mesh_layer_5_tri_1", uv_scroll_right)
