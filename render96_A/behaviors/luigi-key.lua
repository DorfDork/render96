require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_luigi_key_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oWallHitboxRadius = 30
    o.oGravity = -400
    o.oBounciness = -70
    o.oDragStrength = 1000
    o.oFriction = 1000
    o.oBuoyancy = 200
    o.hitboxHeight = 64
    o.hitboxRadius = 32
    o.oHomeY = o.oPosY
end

---@param o Object
local function bhv_luigi_key_loop(o)
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x700
    o.oPosY = o.oHomeY + sins(o.oTimer * 0x600) * 8

    -- Unload object if it's already collected
    if is_luigi_key_collected(o.oBehParams2ndByte) then
        obj_mark_for_deletion(o)
        return
    end

    -- Local Mario only can collect the object
    local m = gMarioStates[0]
    if dist_between_objects(o, m.marioObj) <= 100 then
        collect_luigi_key(o.oBehParams2ndByte)
        spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_SPARKLES, o.oPosX, o.oPosY, o.oPosZ, nil)
        audio_stream_play(AUDIO_R96_COLLECTABLE, false, 1)
        obj_mark_for_deletion(o)
        return
    end
end

id_bhvLuigiKeys = hook_render96_behavior(nil, false, bhv_luigi_key_init, bhv_luigi_key_loop, OBJ_LIST_LEVEL, "LuigiKeys")
