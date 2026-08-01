require("/constants")

local _floor = math.floor

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_blargg_render96_init(o)
    -- Hitbox
    obj_set_hitbox(o, {
        interactType      = INTERACT_FLAME,
        downOffset        = 0,
        damageOrCoinValue = 1,
        health            = 0,
        numLootCoins      = 0,
        radius            = 300,
        height            = 235,
        hurtboxRadius     = 300,
        hurtboxHeight     = 110,
    })

    o.oHomeX = o.oPosX
    o.oHomeZ = o.oPosZ
    o.oGravity = 4.0
    o.oFriction = 0.91
    o.oBuoyancy = 1.3
    o.oAnimations = gObjectAnimations.blargg_seg5_anims_0500616C
    obj_drop_to_floor(o)

    o.oAction = R96_BLARGG_ACT_CHASE
    cur_obj_init_animation(ANIM_R96_BLARGG_SWIM)

    network_init_object(o, true, {})
end

---@param o Object
local function bhv_blargg_render96_check_interacted(o)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
        cur_obj_play_sound_and_rumble_if_visible(SOUND_MOVING_LAVA_BURN)
        o.oInteractStatus = o.oInteractStatus & (~INT_STATUS_INTERACTED)
        o.oAction = R96_BLARGG_ACT_KNOCKBACK
        o.oFlags = o.oFlags & ~OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
        cur_obj_init_animation(ANIM_R96_BLARGG_ATTACK)
        o.oBullyMarioCollisionAngle = o.oMoveAngleYaw
    end
end

---@param o Object
local function bhv_blargg_render96_swim(o)
    o.oForwardVel = 5.0
    if obj_return_home_if_safe(o, o.oHomeX, o.oPosY, o.oHomeZ, 1000) == 1 then
        local m = nearest_mario_state_to_object(o)
        if m ~= nil and m.floor.type == SURFACE_BURNING then
            o.oAction = R96_BLARGG_ACT_CHASE
        else
            o.oAction = R96_BLARGG_ACT_SWIM
        end
        cur_obj_init_animation(ANIM_R96_BLARGG_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_chase(o)
    local m = nearest_mario_state_to_object(o)
    if m == nil then
        o.oAction = R96_BLARGG_ACT_SWIM
        cur_obj_init_animation(ANIM_R96_BLARGG_SWIM)
        return
    end

    o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
    o.oMoveAngleYaw = o.oFaceAngleYaw

    obj_turn_toward_object(o, m.marioObj, 16, 0x2000)
    o.oForwardVel = m.riddenObj ~= nil and 20 or 10

    if is_point_within_radius_of_mario(o.oHomeX, o.oPosY, o.oHomeZ, 5000) == 0 or m.floor.type ~= SURFACE_BURNING then
        o.oAction = R96_BLARGG_ACT_SWIM
        cur_obj_init_animation(ANIM_R96_BLARGG_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_knockback(o)
    local m = nearest_mario_state_to_object(o)
    if m == nil then
        o.oAction = R96_BLARGG_ACT_SWIM
        cur_obj_init_animation(ANIM_R96_BLARGG_SWIM)
        return
    end

    if o.oForwardVel < 10.0 and _floor(o.oVelY) == 0 then
        o.oForwardVel = 1.0
        o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
        o.oMoveAngleYaw = o.oFaceAngleYaw
        obj_turn_toward_object(o, m.marioObj, 16, 0x2000)
    end

    if cur_obj_check_anim_frame(26) ~= 0 then
        cur_obj_play_sound_if_visible(SOUND_OBJ2_PIRANHA_PLANT_BITE)
    end
    if cur_obj_check_if_near_animation_end() ~= 0 then
        o.oAction = R96_BLARGG_ACT_SWIM
        cur_obj_init_animation(ANIM_R96_BLARGG_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_backup(o)
    if o.oTimer == 0 then
        o.oFlags = o.oFlags & ~OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
        o.oMoveAngleYaw = o.oMoveAngleYaw + 0x8000
    end

    o.oForwardVel = 5.0

    if o.oTimer == 15 then
        o.oMoveAngleYaw = o.oFaceAngleYaw
        o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
        o.oAction = R96_BLARGG_ACT_SWIM
    end
end

---@param o Object
---@param collisionFlags integer
local function bhv_blargg_render96_backup_check(o, collisionFlags)
    if (collisionFlags & OBJ_COL_FLAG_NO_Y_VEL) == 0 and o.oAction ~= R96_BLARGG_ACT_KNOCKBACK then
        o.oPosX = o.oBullyPrevX
        o.oPosZ = o.oBullyPrevZ
        o.oAction = R96_BLARGG_ACT_BACKUP
    end
end

---@param o Object
local function bhv_blargg_render96_step(o)
    local collisionFlags = object_step()
    bhv_blargg_render96_backup_check(o, collisionFlags)
end

---@param o Object
local function bhv_blargg_render96_loop(o)
    o.oBullyPrevX = o.oPosX
    o.oBullyPrevY = o.oPosY
    o.oBullyPrevZ = o.oPosZ

    bhv_blargg_render96_check_interacted(o)
    spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)

    if o.oAction == R96_BLARGG_ACT_SWIM then
        bhv_blargg_render96_swim(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == R96_BLARGG_ACT_CHASE then
        bhv_blargg_render96_chase(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == R96_BLARGG_ACT_KNOCKBACK then
        bhv_blargg_render96_knockback(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == R96_BLARGG_ACT_BACKUP then
        bhv_blargg_render96_backup(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BULLY_ACT_DEATH_PLANE_DEATH then
        o.activeFlags = 0
    end

    set_object_visibility(o, 3000)
end

id_bhvRender96Blargg = hook_render96_behavior(nil, true, bhv_blargg_render96_init, bhv_blargg_render96_loop, OBJ_LIST_GENACTOR, "Blargg")
