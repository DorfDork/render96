-- name: Render96 Goomba Grab
-- description: Allows wario to stun and grab goombas
local m = gMarioStates[0]

local sThrownInteractions = o2oint.Interactions({
    objectLists = {
        OBJ_LIST_GENACTOR, -- Common enemies
        OBJ_LIST_PUSHABLE, -- Goombas, Koopas, Lakitus
        OBJ_LIST_DESTRUCTIVE, -- Bob-ombs, breakable boxes
        OBJ_LIST_SURFACE, -- Boxes
    },
    interactions = {

        -- Default behavior for most of the enemies -> attack enemy
        {
            targets = {
                id_bhvBobomb,
                obj_is_attackable,
                obj_is_exclamation_box,
            },
            interact = function (interactor, interactee, context)
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_PUNCH | INT_STATUS_WAS_ATTACKED | INT_STATUS_INTERACTED | INT_STATUS_TOUCHED_BOB_OMB
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
            end,
            ignoreIntangible = false
        },

        -- Behavior for breakable boxes -> break the box
        {
            targets = {
                obj_is_breakable_object
            },
            interact = function (interactor, interactee, context)
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_KICK_OR_TRIP | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED | INT_STATUS_STOP_RIDING -- "broken" status, specific to breakable boxes
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
            end,
            ignoreIntangible = false
        },

        -- Behavior for bullies -> repel the bully
        {
            targets = {
                obj_is_bully,
            },
            interact = function (interactor, interactee, context)
                interactee.oMoveAngleYaw = obj_angle_to_object(interactor, interactee)
                interactee.oForwardVel = 3392.0 / interactee.hitboxRadius
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_PUNCH | INT_STATUS_WAS_ATTACKED | INT_STATUS_INTERACTED
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
            end,
            ignoreIntangible = false
        }
    }
})

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
    oMusicFade          = 'f32',
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

---@param o Object
local function bhv_blargg_render96_init(o)
    -- Hitbox
    local sBlaargHitbox = get_temp_object_hitbox()
    sBlaargHitbox.interactType      = INTERACT_FLAME
    sBlaargHitbox.downOffset        = 0
    sBlaargHitbox.damageOrCoinValue = 1
    sBlaargHitbox.health            = 0
    sBlaargHitbox.numLootCoins      = 0
    sBlaargHitbox.radius            = 300
    sBlaargHitbox.height            = 235
    sBlaargHitbox.hurtboxRadius     = 300
    sBlaargHitbox.hurtboxHeight     = 110

    o.oHomeX = o.oPosX
    o.oHomeZ = o.oPosZ
    o.oGravity = 4.0
    o.oFriction = 0.91
    o.oBuoyancy = 1.3
    o.oAnimations = gObjectAnimations.blargg_seg5_anims_0500616C
    -- drop to floor
    o.oPosY, o.oFloor = find_floor(o.oPosX, o.oPosY, o.oPosZ)
    o.oMoveFlags = (o.oMoveFlags | OBJ_MOVE_ON_GROUND)

    obj_set_hitbox(o, sBlaargHitbox)
    o.oAction = BLARGG_MODE_CHASE
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
end

---@param o Object
local function bhv_blargg_render96_check_mario_collision(o)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
        cur_obj_play_sound_2(SOUND_MOVING_LAVA_BURN)
        o.oInteractStatus = o.oInteractStatus & (~INT_STATUS_INTERACTED)
        o.oAction = BLARGG_MODE_KNOCKBACK
        o.oFlags = o.oFlags & (~0x8) -- bit 3
        cur_obj_init_animation(BLARGG_ANIM_ATK)
        o.oBullyMarioCollisionAngle = o.oMoveAngleYaw
    end
end

---@param o Object
local function bhv_blargg_render96_swim(o)
    o.oForwardVel = 5.0
    if obj_return_home_if_safe(o, o.oHomeX, o.oHomeY, o.oHomeZ, 1000) == 1 then
        if m.floor.type == SURFACE_BURNING then
            o.oAction = BLARGG_MODE_CHASE
        else
            o.oAction = BLARGG_MODE_SWIM
       end
            cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_chase(o)
    local homeX = o.oHomeX
    local posY  = o.oPosY
    local homeZ = o.oHomeZ

    o.oFlags = o.oFlags | 0x8
    o.oMoveAngleYaw = o.oFaceAngleYaw

    obj_turn_toward_object(o, m.marioObj, 16, 0x2000)

    if m.riddenObj == nil then o.oForwardVel = 10 else o.oForwardVel = 20 end

    if not is_point_within_radius_of_mario(homeX, posY, homeZ, 5000) or 
    m.floor.type == 0 or 
    posY < o.oPosY then
        o.oAction = BLARGG_MODE_SWIM
        cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_knockback(o)
    if o.oForwardVel < 10.0 and math.floor(o.oVelY) == 0 then
        o.oForwardVel = 1.0
        o.oBullyKBTimerAndMinionKOCounter = o.oBullyKBTimerAndMinionKOCounter + 1
        o.oFlags = o.oFlags | 0x8
        o.oMoveAngleYaw = o.oFaceAngleYaw
        obj_turn_toward_object(o, m.marioObj, 16, 0x2000)
    end
    if cur_obj_check_anim_frame(26) ~= 0 then
        cur_obj_play_sound_1(SOUND_OBJ2_PIRANHA_PLANT_BITE)
    end
    if cur_obj_check_if_near_animation_end() ~= 0 then
        o.oAction = BLARGG_MODE_SWIM
        cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_backup(o)
    if o.oTimer == 0 then
        o.oFlags = o.oFlags & (~0x8)
        o.oMoveAngleYaw = o.oMoveAngleYaw + 0x8000
    end

    o.oForwardVel = 5.0

    if o.oTimer == 15 then
        o.oMoveAngleYaw = o.oFaceAngleYaw
        o.oFlags = o.oFlags | 0x8
        o.oAction = BLARGG_MODE_SWIM
    end
end

---@param o Object
local function bhv_blargg_render96_backup_check(o, collisionFlags)
    if (collisionFlags & 0x8) == 0 and o.oAction ~= BLARGG_MODE_KNOCKBACK then
        o.oPosX = o.oBullyPrevX
        o.oPosZ = o.oBullyPrevZ
        o.oAction = BLARGG_MODE_BACKUP
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

    bhv_blargg_render96_check_mario_collision(o)
    spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
    if o.oAction == BLARGG_MODE_SWIM then
        bhv_blargg_render96_swim(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_CHASE then
        bhv_blargg_render96_chase(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_KNOCKBACK then
        bhv_blargg_render96_knockback(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_BACKUP then
        o.oForwardVel = 10.0
        bhv_blargg_render96_backup(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BULLY_ACT_DEATH_PLANE_DEATH then
        o.activeFlags = 0
    end

    set_object_visibility(o, 3000)
end

id_bhvRender96Blargg = hook_behavior(nil, OBJ_LIST_LEVEL, false, bhv_blargg_render96_init, bhv_blargg_render96_loop)

---@param o Object
local function bhv_blargg_friendly_render96_init(o)
    local sBlarggFriendlyHitbox = get_temp_object_hitbox()
    sBlarggFriendlyHitbox.interactType = INTERACT_KOOPA_SHELL
    sBlarggFriendlyHitbox.downOffset = 0
    sBlarggFriendlyHitbox.damageOrCoinValue = 4
    sBlarggFriendlyHitbox.health = 1
    sBlarggFriendlyHitbox.numLootCoins = 1
    sBlarggFriendlyHitbox.radius = 100
    sBlarggFriendlyHitbox.height = 100
    sBlarggFriendlyHitbox.hurtboxRadius = 50
    sBlarggFriendlyHitbox.hurtboxHeight = 50

    obj_set_hitbox(o, sBlarggFriendlyHitbox)
    o.oAnimations = gObjectAnimations.blargg_seg5_anims_0500616C
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
    o.oAction = 0
    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ
    o.activeFlags = ACTIVE_FLAG_ACTIVE
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
end

---@param o Object
local function bhv_blargg_friendly_render96_explode(o)
    m.action = ACT_WALKING
    mario_stop_riding_object(m)
    o.activeFlags = ACTIVE_FLAG_DEACTIVATED
    obj_mark_for_deletion(o)
    local explosion = spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, nil)
    explosion.oGraphYOffset = explosion.oGraphYOffset + 100.0
end

---@param o Object
local function bhv_blargg_friendly_render96_loop(o)
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
    if o.oAction == 0 then
        cur_obj_update_floor_and_walls()
        cur_obj_if_hit_wall_bounce_away()

        if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
            o.oAction = 1
            if m ~= nil then o.heldByPlayerIndex = m.playerIndex end
        end
        cur_obj_move_standard(-20)

    elseif o.oAction == 1 then
        o.activeFlags = ACTIVE_FLAG_ACTIVE
        cur_obj_enable_rendering()
        obj_copy_pos(o, m.marioObj)
        o.oFaceAngleYaw = m.marioObj.oMoveAngleYaw
        local floor = cur_obj_update_floor_height_and_get_floor()
        if math.abs(o.oPosY - o.oFloorHeight) < 5.0 then
            if floor ~= nil and floor.type == SURFACE_BURNING then
                 spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
            else
                --bhv_blargg_friendly_render96_explode(o)
            end
        end
        if (o.oInteractStatus & INT_STATUS_STOP_RIDING) ~= 0 then
            bhv_blargg_friendly_render96_explode(o)
        end
    end
    o.oInteractStatus = 0
end

id_bhvRender96BlarggFriendly = hook_behavior(nil, OBJ_LIST_LEVEL, false, bhv_blargg_friendly_render96_init, bhv_blargg_friendly_render96_loop)

local function bhv_breakable_box_render96_loop(o)
    if (m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 200) then
        obj_explode_and_spawn_coins(46, 1)
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX)
    end
end

id_bhvRender96BreakableBox = hook_behavior(id_bhvBreakableBox, OBJ_LIST_SURFACE, false, nil, bhv_breakable_box_render96_loop)

---@param o Object
local function bhv_goomba_render96_init(o)
    o.oSwitchState2 = GOOMBA_FACE_CLOSE
    o.oSwitchState1 = GOOMBA_EYE_OPEN
    o.oSwitchTimer1 = 0
    o.oSwitchTimer2 = 0
    o.oMusicFade = 0
end

---@param o Object
local function bhv_goomba_render96_death(o)
    spawn_mist_particles()
    obj_spawn_yellow_coins(o, o.oNumLootCoins)
    create_sound_spawner(SOUND_OBJ_STOMPED)
    o.activeFlags = ACTIVE_FLAG_DEACTIVATED
    obj_mark_for_deletion(o)
end

---@param o Object
local function bhv_goomba_render96_throw_physics(o)
    cur_obj_update_floor_and_walls()
    cur_obj_move_standard(-78)
    sThrownInteractions:process_interactions(o)
    o.oSwitchState2 = GOOMBA_FACE_OPEN
    o.oSwitchState1 = GOOMBA_EYE_DAZED
    o.oGravity = -2.5
    o.oFriction = 0.99
    o.oBuoyancy = 1.4
    o.oForwardVel = 40.0
    local audioStream = audio_stream_load(GOOMBA_SCREAM)
    local distanceToPlayer = dist_between_objects(m.marioObj, o)
    --if distanceToPlayer < 50 then
        
    --end
    if distanceToPlayer > 50 then
    end
    if (o.oMoveFlags & OBJ_MOVE_LANDED) ~= 0 or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0 or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0 then 
        audio_stream_stop(audioStream)
        bhv_goomba_render96_death(o) return end

    if (o.oMoveFlags & OBJ_MOVE_ABOVE_LAVA) ~= 0 then
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        obj_mark_for_deletion(o)
        return
    end
end

---@param o Object
local function bhv_goomba_render96_held(o)
    if o.oHeldState == HELD_HELD then
        o.oSwitchState2 = GOOMBA_FACE_OPEN
        o.oSwitchState1 = GOOMBA_EYE_DAZED
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
    elseif o.oHeldState == HELD_THROWN then
        cur_obj_become_tangible()
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        o.oVelY = 20.0
        local audioStream = audio_stream_load(GOOMBA_SCREAM)
        audio_stream_play(audioStream, false, 1)
        o.oHeldState = HELD_FREE
    end
end

---@param o Object
local function bhv_goomba_render96_loop(o)
    o.oSwitchTimer1 = o.oSwitchTimer1 - 1
    if o.oSwitchTimer1 <= 0 then
        if o.oSwitchState1 == GOOMBA_EYE_OPEN then
            o.oSwitchState1 = GOOMBA_EYE_CLOSE
            o.oSwitchTimer1 = math.random(3, 8)
        else
            o.oSwitchState1 = GOOMBA_EYE_OPEN
            o.oSwitchTimer1 = math.random(30, 100)
        end
    end

    o.oSwitchTimer2 = o.oSwitchTimer2 - 1
    if o.oSwitchTimer2 <= 0 then
        if o.oSwitchState2 == GOOMBA_FACE_CLOSE then
            o.oSwitchState2 = GOOMBA_FACE_OPEN
            o.oSwitchTimer2 = math.random(10, 15)
        else
            o.oSwitchState2 = GOOMBA_FACE_CLOSE
            o.oSwitchTimer2 = math.random(30, 100)
        end
    end

    if o.oAction == GOOMBA_ACT_JUMP then
        o.oSwitchState1 = GOOMBA_EYE_OPEN
        o.oSwitchTimer1 = 0
        o.oSwitchState2 = GOOMBA_FACE_CLOSE
        o.oSwitchTimer2 = 0
    end

    if get_character(m).type == CT_WARIO then
        if o.oAction == OBJ_ACT_SQUISHED then
            if m.action ~= ACT_GROUND_POUND and m.action ~= ACT_GROUND_POUND_LAND then
                set_mario_particle_flags(m, PARTICLE_HORIZONTAL_STAR, 0)
                o.oInteractType = INTERACT_GRABBABLE
                o.oAction = GOOMBA_ACT_STUN
                o.oSwitchState2 = GOOMBA_FACE_OPEN
                o.oSwitchState1 = GOOMBA_EYE_DAZED
                o.oTimer = 0
                cur_obj_init_animation_with_accel_and_sound(0, 0) 
            end
            if m.action == ACT_GROUND_POUND or m.action == ACT_GROUND_POUND_LAND then
                bhv_goomba_render96_death(o)
            end
        end
    
        --Stunned from wario's jump, checks if going to be grabbed
        if (o.oHeldState == HELD_FREE and o.oAction == GOOMBA_ACT_STUN and o.oTimer <= 150) then
            o.oGoombaTargetYaw = o.oGoombaTargetYaw + 0x1000
            cur_obj_rotate_yaw_toward(o.oGoombaTargetYaw, 0x1000)
            o.oSwitchState2 = GOOMBA_FACE_OPEN
            o.oSwitchState1 = GOOMBA_EYE_DAZED
            if mario_check_object_grab(m) ~= 0 and (m.heldObj == nil) then
                m.usedObj = o
                mario_grab_used_object(m)
                o.oAction = GOOMBA_ACT_GRAB
            end
        end
    
        --If not picked up after some time, go back to walking
        if (o.oHeldState == HELD_FREE and o.oAction == GOOMBA_ACT_STUN and o.oTimer > 150) then
            o.oInteractType = INTERACT_BOUNCE_TOP;
            o.oAction = GOOMBA_ACT_WALK;
            o.oSwitchState2 = GOOMBA_FACE_CLOSE
            o.oSwitchState1 = GOOMBA_EYE_OPEN
            cur_obj_init_animation_with_accel_and_sound(0, 1) 
            return
        end
    
        bhv_goomba_render96_held(o)
    
        if m.heldObj ~= o and o.oAction == GOOMBA_ACT_GRAB and o.oHeldState == HELD_FREE then bhv_goomba_render96_throw_physics(o) end
        if m.heldObj ~= o and o.oAction == GOOMBA_ACT_GRAB and o.oHeldState == HELD_HELD then o.oHeldState = HELD_THROWN end
        if m.heldObj == o then o.oHeldState = HELD_HELD end
        if (m.action == ACT_HOLD_WATER_IDLE or m.action == ACT_HOLD_WATER_ACTION_END) and m.heldObj == o then mario_drop_held_object(m) end
    end
    if get_character(m).type ~= CT_WARIO then
        if o.oAction == OBJ_ACT_SQUISHED then 
            o.oSwitchState2 = GOOMBA_FACE_CLOSE
            o.oSwitchState1 = GOOMBA_EYE_CLOSE
            cur_obj_init_animation_with_accel_and_sound(0, 0) end
    end
end

id_bhvRender96Goomba = hook_behavior(id_bhvGoomba, OBJ_LIST_PUSHABLE, false, bhv_goomba_render96_init, bhv_goomba_render96_loop)

---@param o Object
local function bhv_koopa_shell_render96_throw_physics(o)
    cur_obj_update_floor_and_walls()
    cur_obj_move_standard(-78)
    sThrownInteractions:process_interactions(o)

    spawn_non_sync_object(id_bhvSparkleSpawn, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ, nil)

    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1000
    o.oGravity = -2.5
    o.oFriction = 0.99
    o.oBuoyancy = 1.4

    if o.oTimer < 150 then o.oForwardVel = 50.0
    elseif o.oTimer < 300 and o.oTimer > 150 then o.oForwardVel = 35.0
    elseif o.oTimer < 450 and o.oTimer > 300 then o.oForwardVel = 20.0
    elseif o.oTimer >= 550 then o.oForwardVel = 0.0 end

    if (o.oMoveFlags & OBJ_MOVE_HIT_EDGE) ~= 0 or o.oMoveFlags & OBJ_MOVE_HIT_WALL ~= 0 then
        o.oMoveAngleYaw = obj_angle_to_object(o, nearest_player_to_object(o))
        return
    end
    
    if (o.oMoveFlags & OBJ_MOVE_ABOVE_LAVA) ~= 0 then
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        obj_mark_for_deletion(o)
        return
    end
end

---@param o Object
local function bhv_koopa_shell_render96_held(o)
    if o.oHeldState == HELD_HELD then
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
        o.oTimer = 0
        if gMarioStates[0].heldObj ~= nil then
            spawn_non_sync_object(id_bhvSparkleSpawn, E_MODEL_NONE, gMarioStates[0].marioObj.oPosX, gMarioStates[0].marioObj.oPosY + 100, gMarioStates[0].marioObj.oPosZ, nil)
        end
    elseif o.oHeldState == HELD_THROWN then
        cur_obj_become_tangible()
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        o.oVelY = 20.0
        o.oHeldState = HELD_FREE
    end
end

---@param o Object
local function bhv_koopa_shell_render96_loop(o)
    if get_character(m).type == CT_WARIO then
        o.oInteractType = INTERACT_GRABBABLE
        if mario_check_object_grab(m) ~= 0 and (m.heldObj == nil) then
            --mario_grab_used_object(m)
            o.oAction = KOOPA_SHELL_ACT_GRAB
        end
    
        koopa = obj_get_nearest_object_with_behavior_id(o, id_bhvKoopa)
        if koopa ~= nil then
            spawn_mist_particles()
            spawn_sync_object(id_bhvBlueCoinJumping, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
            create_sound_spawner(SOUND_OBJ_STOMPED)
            koopa.activeFlags = ACTIVE_FLAG_DEACTIVATED
            obj_mark_for_deletion(koopa)
        end
    
        bhv_koopa_shell_render96_held(o)

        if m.heldObj ~= o and o.oAction == KOOPA_SHELL_ACT_GRAB and o.oHeldState == HELD_FREE then bhv_koopa_shell_render96_throw_physics(o) end
        if m.heldObj ~= o and o.oAction == KOOPA_SHELL_ACT_GRAB and o.oHeldState == HELD_HELD then o.oHeldState = HELD_THROWN end
        if m.heldObj == o then o.oHeldState = HELD_HELD end
        if o.oHeldState == HELD_FREE and (m.action == ACT_WARIO_CHARGE or m.action == ACT_JUMP_KICK) and dist_between_objects(o, m.marioObj) <= 200 then
            o.oMoveAngleYaw = m.faceAngle.y
            o.oForwardVel = 50.0
            o.oVelY = 20.0
            o.oTimer = 0
        end

        if (m.action == ACT_HOLD_WATER_IDLE or m.action == ACT_HOLD_WATER_ACTION_END) and m.heldObj == o 
        then mario_drop_held_object(m) 
            o.activeFlags = ACTIVE_FLAG_DEACTIVATED
            obj_mark_for_deletion(o)
        end
        o.oInteractStatus = 0
    end
end

id_bhvRender96KoopaShell = hook_behavior(id_bhvKoopaShell, OBJ_LIST_PUSHABLE, false, nil, bhv_koopa_shell_render96_loop)

---@param o Object
local function bhv_thwomp_render96_init(o)
    o.oSwitchState2 = TWHOMP_FACE_BASE
    o.oThwompShakeTicks = 18
    o.oThwompPosMag = 10.0
    o.oThwompAngleMag = 0x120

    o.oThwompPrevAction = o.oAction or 0
    o.oThwompSquishTimer = 0
    o.oThwompSquishDur = 0
    o.oThwompBaseScale = o.header.gfx.scale.x
end

---@param o Object
local function bhv_thwomp_render96_shake(o)
    if o == nil then return end

    -- Thwomp action state machine:
    -- 0 = rising, 1 = waiting (pre-fall), 2 = falling, 3 = landed, 4 = cooldown
    if o.oAction ~= 1 then
        return
    end

    if o.oThwompRandomTimer == nil or o.oTimer == nil then
        return
    end

    local remaining = o.oThwompRandomTimer - o.oTimer
    if remaining > (o.oThwompShakeTicks + 0.5) or remaining < 0 then
        return
    end

    local t = o.oTimer

    -- Visual-only shake (does not affect collision)
    local ox = (math.sin(t * 6.9) + math.sin(t * 15.3)) * 0.5 * o.oThwompPosMag
    local oz = (math.cos(t * 8.1) + math.cos(t * 14.1)) * 0.5 * o.oThwompPosMag

    o.oPosX = o.oHomeX + ox
    o.oPosZ = o.oHomeZ + oz

    local yawJitter = math.floor(math.sin(t * 18.0) * o.oThwompAngleMag)
    local rollJitter = math.floor(math.cos(t * 21.0) * (o.oThwompAngleMag / 2))

    o.oFaceAngleYaw = o.oMoveAngleYaw + yawJitter
    o.oFaceAngleRoll = rollJitter
end

---@param o Object
local function bhv_thwomp_render96_loop(o)
    bhv_thwomp_render96_shake(o)
    if o.oAction == 0 then o.oSwitchState2 = TWHOMP_FACE_BASE end
    if o.oAction == 2 then o.oSwitchState2 = TWHOMP_FACE_URGH end
    if o.oAction == 3 then o.oSwitchState2 = TWHOMP_FACE_ANGRY end

   local remaining = o.oThwompRandomTimer - o.oTimer
    if remaining > (o.oThwompShakeTicks + 0.5) or remaining < 0 then
         if o.oAction == 1 then o.oSwitchState2 = TWHOMP_FACE_BASE end
    else
        if o.oAction == 1 then o.oSwitchState2 = TWHOMP_FACE_ANGRY end
    end
    
    local prevAction = o.oThwompPrevAction or o.oAction
    if prevAction ~= 3 and o.oAction == 3 then
        o.oThwompSquishTimer = 0
        o.oThwompSquishDur = 5
        o.oThwompBaseScale = o.header.gfx.scale.x
    end

    if (o.oThwompSquishDur or 0) > 0 and (o.oThwompSquishTimer or 0) <= o.oThwompSquishDur then
        r96lib.squish_apply(o, o.oThwompSquishTimer, o.oThwompSquishDur, 0.15, -0.20, 0.15, o.oThwompBaseScale, nil)
        o.oThwompSquishTimer = o.oThwompSquishTimer + 1
    end

    o.oThwompPrevAction = o.oAction

    if m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 350 then
        cur_obj_play_sound_2(SOUND_OBJ_THWOMP)
        spawn_mist_particles_variable(0, 0, 100.0)
        spawn_triangle_break_particles(20, 138, 3.0, 4)
		set_camera_shake_from_point(SHAKE_POS_MEDIUM, m.pos.x, m.pos.y, m.pos.z)
        spawn_sync_object(id_bhvBlueCoinJumping, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
        create_sound_spawner(SOUND_OBJ_STOMPED)
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96Thwomp = hook_behavior(id_bhvThwomp, OBJ_LIST_SURFACE, false, bhv_thwomp_render96_init, bhv_thwomp_render96_loop)
id_bhvRender96Thwomp2 = hook_behavior(id_bhvThwomp2, OBJ_LIST_SURFACE, false, bhv_thwomp_render96_init, bhv_thwomp_render96_loop)

---@param o Object
local function bhv_tower_door_render96_loop(o)
    if (m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 200) then
        obj_explode_and_spawn_coins(80.0, 0)
        create_sound_spawner(SOUND_GENERAL_WALL_EXPLOSION)
    end
end

id_bhvRender96TowerDoor = hook_behavior(id_bhvTowerDoor, OBJ_LIST_SURFACE, false, nil, bhv_tower_door_render96_loop)

---@param o Object
local function bhv_whomp_render96_loop(o)
    if m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 200 then
        cur_obj_play_sound_2(SOUND_OBJ_THWOMP)
        spawn_mist_particles_variable(0, 0, 100.0)
        spawn_triangle_break_particles(20, 138, 3.0, 4)
		set_camera_shake_from_point(SHAKE_POS_MEDIUM, m.pos.x, m.pos.y, m.pos.z)
        o.oNumLootCoins = 5
        obj_spawn_loot_yellow_coins(o, 5, 20.0)
        create_sound_spawner(SOUND_OBJ_STOMPED)
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96SmallWhomp = hook_behavior(id_bhvSmallWhomp, OBJ_LIST_SURFACE, false, nil, bhv_whomp_render96_loop)

local function bhv_wario_head_init(o)
    -- set flags
    o.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)

    -- drop to floor
    local x = o.oPosX
    local y = o.oPosY
    local z = o.oPosZ

    --local floor = find_floor_height(x, y + 200.0, z)
    --o.oPosY = floor
    o.oMoveFlags = o.oMoveFlags | OBJ_MOVE_ON_GROUND

    -- home
    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ

    -- physics
    o.oGravity          = -4.0
    o.oBounciness       = -0.5
    o.oDragStrength     = 10.0
    o.oFriction         = 10.0
    o.oBuoyancy         =  0.0

-- hitbox
    o.oInteractType = INTERACT_SHOCK
    o.oHealth = 0
    o.oNumLootCoins = 1
    o.oIntangibleTimer = 0
    o.hitboxRadius = 0
    o.hitboxHeight = 0
    o.hurtboxRadius = 50
    o.hurtboxHeight = 60
    o.oDamageOrCoinValue = 4
    --o.hitboxDownOffset = o.header.gfx.scale.y * 0
    o.oWarioHeadBool = 0
    o.oAction = -1
end

    --5235, -1074,  1995
    --604, -1074, 1995
WARIO_HEAD_FUN = audio_stream_load('event_wario_head_fun.mp3')
WARIO_HEAD_BITE = audio_stream_load('event_wario_head_yell.mp3')
WARIO_HEAD_LAUGH = audio_stream_load('event_wario_head_yell.mp3')
WARIO_HEAD_YELL = audio_stream_load('event_wario_head_yell.mp3')

WARIO_GREETING = 0
WARIO_BITE = 1
WARIO_LOL = 2
WARIO_DEATH = 3
local audioStream = nil


        --audio_stream_set_loop_points(audioStream, 0, 333353)
        --audio_stream_set_looping(audioStream, true)
        
    
local function bhv_wario_head_loop(o)
    local player = nearest_player_to_object(o)
    local distanceToPlayer = dist_between_objects(o, player)
    local angleToPlayer = obj_angle_to_object(o, player)

    if o.oWarioHeadBool == 0 then
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
        
    end
    if o.oAction == -1 and o.oWarioHeadBool == 1 then
        o.oPosY = -800
        audio_stream_play(WARIO_HEAD_FUN, false, 2)
        o.oAction = WARIO_BITE
    end
    if m.pos.x >= 2000 then
        cur_obj_become_tangible()
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        o.oWarioHeadBool = 1
    end
    if m.pos.x >= 604 then
        local dx = player.header.gfx.pos.x - o.oPosX
        local dy = (player.header.gfx.pos.y + 50.0) - o.oPosY
        local dz = player.header.gfx.pos.z - o.oPosZ

        local targetPitch = atan2s(math.sqrt((dx * dx) + (dz * dz)), dy)

        obj_turn_toward_object(o, player, 16, 0x1000)
        o.oMoveAnglePitch = approach_s16_symmetric(o.oMoveAnglePitch, targetPitch, 0x1000)
        o.oVelY = sins(o.oMoveAnglePitch) * 2.0
        o.oForwardVel = coss(o.oMoveAnglePitch) * 30.0
        o.oFaceAngleYaw =  angleToPlayer + 0x8000
        cur_obj_move_standard(-78)
        cur_obj_update_floor_and_walls()
    end

    if  o.oWarioHeadBool == 1 and m.pos.x < 604 then
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        audio_stream_play(WARIO_HEAD_YELL, false, 2)
        obj_mark_for_deletion(o)
    end
   o.oInteractStatus = 0
end

id_bhvWarioHead = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_wario_head_init, bhv_wario_head_loop)

---@param o Object
local function bhv_warp_pipe_render96_init(o)
    o.oFlags = OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_WARP
    o.oDrawingDistance = 16000
    o.oIntangibleTimer = 0
    o.hitboxRadius = 70
    o.hitboxHeight = 50
    o.oInteractStatus = 0
    o.collisionData = smlua_collision_util_get("warp_pipe_seg3_collision_03009AC8")
    o.oMusicFade = FADE_OUT
end

---@param o Object
local function bhv_warp_pipe_render96_red_loop(o)
    load_object_collision_model()
    bhv_warp_loop()
    local audioStream = audio_stream_load(BOO_PIPE_RED)
    local distanceToPlayer = dist_between_objects(m.marioObj, o)
    if distanceToPlayer < 1000 and o.oMusicFade == 0 then
        --audio_stream_set_loop_points(audioStream, 0, 333353)
        audio_stream_set_looping(audioStream, true)
        audio_stream_play(audioStream, true, 0)
        o.oMusicFade = FADE_IN
    end
    if distanceToPlayer > 1000 then
        o.oMusicFade = FADE_OUT
    end
    r96lib.audio_fade(o, audioStream)
end

id_bhvRender96WarpPipeRed = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_red_loop)

---@param o Object
local function bhv_warp_pipe_render96_green_loop(o)
    load_object_collision_model()
    bhv_warp_loop()
    local audioStream = audio_stream_load(BOO_PIPE_GREEN)
    local distanceToPlayer = dist_between_objects(m.marioObj, o)
    if distanceToPlayer < 1000 and o.oMusicFade == 0 then
        --audio_stream_set_loop_points(audioStream, 0, 333353)
        audio_stream_set_looping(audioStream, true)
        audio_stream_play(audioStream, true, 0)
        o.oMusicFade = FADE_IN
    end
    if distanceToPlayer > 1000 then
        o.oMusicFade = FADE_OUT
    end
    r96lib.audio_fade(o, audioStream)
end

id_bhvRender96WarpPipeGreen = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_green_loop)

---@param o Object
local function bhv_warp_pipe_render96_yellow_loop(o)
    load_object_collision_model()
    bhv_warp_loop()
    local audioStream = audio_stream_load(BOO_PIPE_YELLOW)
    local distanceToPlayer = dist_between_objects(m.marioObj, o)
    if distanceToPlayer < 1000 and o.oMusicFade == 0 then
        --audio_stream_set_loop_points(audioStream, 0, 333353)
        audio_stream_set_looping(audioStream, true)
        audio_stream_play(audioStream, true, 0)
        o.oMusicFade = FADE_IN
    end
    if distanceToPlayer > 1000 then
        o.oMusicFade = FADE_OUT
    end
    r96lib.audio_fade(o, audioStream)
end

id_bhvRender96WarpPipeYellow = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_warp_pipe_render96_init, bhv_warp_pipe_render96_yellow_loop)

---@param o Object
local function bhv_luigi_key_init(o)
    o.activeFlags = ACTIVE_FLAG_ACTIVE
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oWallHitboxRadius = 30
    o.oGravity = -400
    o.oBounciness = -70
    o.oDragStrength = 1000
    o.oFriction = 1000
    o.oBuoyancy = 200
    o.hitboxHeight = 64
    o.hitboxRadius = 32
    o.oPosY = o.oPosY + 80
end

---@param o Object
local function bhv_luigi_key_loop(o)
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x700
    o.oPosY = o.oPosY + sins(o.oFaceAngleYaw / (20 * 1000)) * 2
    if dist_between_objects(o, m.marioObj) <= 150 then
        r96lib.save_render96_data("luigi_key", o.oBehParams2ndByte)
        obj_mark_for_deletion(o)
        --spawn_object(o, MODEL_SPARKLES, bhvGoldenCoinSparkles)
        --r96_play_collect_jingle(R96_EVENT_COLLECTIBLE_GRAB)
        --if gMarioState.numKeys >= 10 then
        --    triggerLuigiNotification()
        --end
    end
    if r96lib.check_render96_data("luigi_key", o.oBehParams2ndByte) == true then
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
end

id_bhvLuigiKeys = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_luigi_key_init, bhv_luigi_key_loop)

---@param o Object
local function bhv_six_golden_coin_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oWallHitboxRadius = 30
    o.oGravity = -400
    o.oBounciness = -70
    o.oDragStrength = 1000
    o.oFriction = 1000
    o.oBuoyancy = 200
    o.hitboxHeight = 64
    o.hitboxRadius = 32
    cur_obj_scale(2.0)
    if r96lib.check_render96_data("wario_coin", o.oBehParams2ndByte) == 1 then
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
end

---@param o Object
local function bhv_six_golden_coin_loop(o)
    if dist_between_objects(o, m.marioObj) <= 50 then
        r96lib.save_render96_data("wario_coin", o.oBehParams2ndByte)
        gNumWarioCoins = gNumWarioCoins + 1
        set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)
        create_sound_spawner(SOUND_GENERAL_COIN)
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
    if obj_check_if_collided_with_object(o, m.marioObj) ~= 0  then

        obj_mark_for_deletion(o)
        --if gMarioState.numWarioCoins >= 6 then
        --    triggerLuigiNotification()
        --end
    end
end

id_bhvSixGoldenCoin = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_six_golden_coin_init, bhv_six_golden_coin_loop)

---@param o Object
local function bhv_wario_coin_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    --o.oInteractType = INTERACT_COIN
    o.oDamageOrCoinValue = 0
    o.hitboxHeight = 72
    o.hitboxRadius = 50
    cur_obj_scale(0.8)
    create_sound_spawner(SOUND_GENERAL_COIN_DROP)
end


---@param o Object
function bhv_wario_coin_loop(o)
    cur_obj_update_floor_and_walls()
    cur_obj_move_standard(-78)
    o.oGravity = -2.5
    o.oFriction = 0.99
    o.oBuoyancy = 1.4
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1000
    o.oForwardVel = 30
    if (o.oMoveFlags & OBJ_MOVE_MASK_ON_GROUND) ~= 0 or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0 or (o.oMoveFlags & OBJ_MOVE_HIT_EDGE) ~= 0 or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0 then obj_turn_toward_object(o, m.marioObj, 16, 0x2000) end

    if dist_between_objects(o, m.marioObj) <= 50 then
        set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)
        create_sound_spawner(SOUND_GENERAL_COIN)
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
    if (o.oMoveFlags & OBJ_MOVE_ABOVE_LAVA) ~= 0 then
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        obj_mark_for_deletion(o)
        return
    end
end

id_bhvWarioCoins = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_wario_coin_init, bhv_wario_coin_loop)

---@param o Object
local function bhv_mr_i_render96_particle_init(o)
    local sParticleHitbox = get_temp_object_hitbox()
    sParticleHitbox.interactType        = INTERACT_DAMAGE
    sParticleHitbox.downOffset          = 0
    sParticleHitbox.damageOrCoinValue   = 2
    sParticleHitbox.health              = 1
    sParticleHitbox.numLootCoins        = 0
    sParticleHitbox.radius              = 100
    sParticleHitbox.height              = 100
    sParticleHitbox.hurtboxRadius       = 50
    sParticleHitbox.hurtboxHeight       = 50
    obj_set_hitbox(o, sParticleHitbox)

    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
    o.oDrawingDistance   = 4000

    cur_obj_scale(3)
end

---@param o Object
local function bhv_mr_i_render96_particle_loop(o)
    cur_obj_move_using_fvel_and_gravity()
    cur_obj_update_floor_and_walls()

    if (o.oInteractStatus & 0x8000) ~= 0
        or o.oTimer >= 101
        or (o.oMoveFlags & OBJ_MOVE_LANDED) ~= 0 
        or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0 
        or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0
        or (o.activeFlags & ACTIVE_FLAG_IN_DIFFERENT_ROOM) ~= 0 then
        spawn_mist_particles()
        obj_mark_for_deletion(o)
    end
    o.oInteractStatus = 0
end

id_bhvRender96MrIParticle = hook_behavior(nil, OBJ_LIST_GENACTOR, false, bhv_mr_i_render96_particle_init, bhv_mr_i_render96_particle_loop)

---@param o Object
local function bhv_mr_i_render96_fire_particle_init(o)
    local sParticleHitbox = get_temp_object_hitbox()
    sParticleHitbox.interactType        = INTERACT_FLAME
    sParticleHitbox.downOffset          = 0
    sParticleHitbox.damageOrCoinValue   = 2
    sParticleHitbox.health              = 1
    sParticleHitbox.numLootCoins        = 0
    sParticleHitbox.radius              = 100
    sParticleHitbox.height              = 100
    sParticleHitbox.hurtboxRadius       = 50
    sParticleHitbox.hurtboxHeight       = 50
    obj_set_hitbox(o, sParticleHitbox)

    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
    o.oDrawingDistance   = 4000

    cur_obj_scale(6)
end

---@param o Object
local function bhv_mr_i_render96_fire_particle_loop(o)
    cur_obj_move_using_fvel_and_gravity()
    cur_obj_update_floor_and_walls()
    o.oAnimState = math.floor(math.random() * 10)
    if (o.oInteractStatus & 0x8000) ~= 0
        or o.oTimer >= 101
        or (o.oMoveFlags & OBJ_MOVE_LANDED) ~= 0 
        or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0 
        or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0
        or (o.activeFlags & ACTIVE_FLAG_IN_DIFFERENT_ROOM) ~= 0 then
        spawn_mist_particles()
        obj_mark_for_deletion(o)
    end
    o.oInteractStatus = 0
end

id_bhvRender96MrIFireParticle = hook_behavior(nil, OBJ_LIST_GENACTOR, false, bhv_mr_i_render96_fire_particle_init, bhv_mr_i_render96_fire_particle_loop)

local DEATH_THRESHOLD = 4 * math.pi
local FOV_THRESHOLD = degrees_to_sm64(30)
local CIRCLE_MIN_DELTA  = 200

---@param o Object
local function  bhv_mr_i_render96_init(o)
    o.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)
    o.oPosY = o.oPosY + 60

    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ

    local sMrIHitbox = get_temp_object_hitbox()
    sMrIHitbox.interactType         = INTERACT_DAMAGE
    sMrIHitbox.health               = 2
    sMrIHitbox.numLootCoins         = 5
    sMrIHitbox.damageOrCoinValue    = 2
    sMrIHitbox.radius               = 80
    sMrIHitbox.height               = 150
    sMrIHitbox.hurtboxRadius        = 50
    sMrIHitbox.hurtboxHeight        = 100
    sMrIHitbox.downOffset           = 0
    obj_set_hitbox(o, sMrIHitbox)

    o.oIntangibleTimer  = 0
    o.oDrawingDistance  = 4000
    o.oDeathSound       = SOUND_OBJ_ENEMY_DEATH_HIGH

    o.oAction           = MR_I_IDLE

    o.oMrISize          = 2
    o.oSwitchState2     = MR_I_OPEN
    o.oSwitchTimer1         = 0
    o.oMrIBlinkIndex    = 1
    o.oMrIDetectRadius  = 500
    o.oMrIDizzyTimer    = 0
    o.oMrIDizzyDuration = 120
    o.oMrITracking      = 0
    o.oMrILastAngle     = obj_angle_to_object(o, nearest_player_to_object(o))
    o.oMrIFireTimer     = 0

    if o.oBehParams2ndByte == 0x05010000 then o.oMrISize = 4 o.oPosY = o.oPosY + 120 o.oHomeY = o.oPosY end
    cur_obj_scale(o.oMrISize)
end

---@param o Object
---@param player Object
local function bhv_mr_i_render96_fire(o, player)
    local yaw   = o.oFaceAngleYaw
    local pitch = o.oFaceAnglePitch
    local speed = 25.0
    local spawnY = o.oPosY - 40
    local particle = nil

    if o.oBehParams2ndByte == 0x05010000 then 
        spawnY = spawnY - 40 
        particle = spawn_non_sync_object(id_bhvRender96MrIFireParticle, E_MODEL_BLUE_FLAME, o.oPosX, spawnY, o.oPosZ, nil)
    else
        particle = spawn_non_sync_object(id_bhvRender96MrIParticle, E_MODEL_PURPLE_MARBLE, o.oPosX, spawnY, o.oPosZ, nil)
    end
    if particle == nil then return end

    particle.oMoveAngleYaw   = yaw
    particle.oMoveAnglePitch = pitch
    particle.oForwardVel     = speed
    particle.oVelX           = speed * coss(pitch) * sins(yaw)
    particle.oVelY           = speed * sins(-pitch)
    particle.oVelZ           = speed * coss(pitch) * coss(yaw)

    cur_obj_play_sound_2(SOUND_OBJ_MRI_SHOOT)
end

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_track(o, player, dist, angleToPlayer, angleDiff)

    if dist > o.oMrIDetectRadius or angleDiff > FOV_THRESHOLD then
        o.oMrITracking = 0
        o.oMrILastAngle = angleToPlayer
        return
    end

    local delta = angleToPlayer - o.oMrILastAngle
    if delta > 32767  then delta = delta - 65536 end
    if delta < -32767 then delta = delta + 65536 end

    o.oMrILastAngle = angleToPlayer

    if math.abs(delta) >= CIRCLE_MIN_DELTA then
        o.oMrITracking = o.oMrITracking + math.abs(delta) * (math.pi / 32768.0)
    else
        o.oMrITracking = 0
    end
end

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_attack(o, player, dist, angleToPlayer, angleDiff)
    o.oFaceAngleYaw = angleToPlayer
    o.oFaceAnglePitch = math.min(obj_pitch_to_object(o, player), 0)

    o.oMrIFireTimer = o.oMrIFireTimer + 1
    if o.oMrIFireTimer >= 120 then
        o.oSwitchTimer1 = o.oSwitchTimer1 - 1
        if o.oSwitchTimer1 <= 0 then
            o.oMrIBlinkIndex = o.oMrIBlinkIndex + 1
            if o.oMrIBlinkIndex > #sMrIBlinkStates then
                o.oMrIBlinkIndex = 1
                o.oMrIFireTimer = 0
            else
                o.oSwitchState2 = sMrIBlinkStates[o.oMrIBlinkIndex]
            end
            if o.oSwitchState2 == MR_I_CLOSED then
                bhv_mr_i_render96_fire(o, player)
            end
            o.oSwitchTimer1 = 2
        end
    end

    bhv_mr_i_render96_track(o, player, dist, angleToPlayer, angleDiff)
    if o.oMrITracking >= DEATH_THRESHOLD then
        o.oAction = MR_I_DIZZY
        o.oMrIDizzyTimer = 0
        o.oMrITracking = 0
    end     
    if dist > o.oMrIDetectRadius * 1.5 then
        o.oAction = MR_I_IDLE
        o.oMrITracking = 0
    end
end

---@param o Object
local function bhv_mr_i_render96_dizzy(o)
    local frames = o.oMrIDizzyDuration - o.oMrIDizzyTimer

    o.oMrIDizzyTimer = o.oMrIDizzyTimer + 1
    o.oFaceAngleYaw = (o.oFaceAngleYaw + 0x1500) & 0xFFFF
    o.oFaceAnglePitch = math.floor(-0x4000 * math.min(o.oMrIDizzyTimer / o.oMrIDizzyDuration, 1.0))

    if frames % 15 == 0 and frames > 20 then cur_obj_play_sound_2(SOUND_OBJ2_MRI_SPINNING) end
    if frames == 15 then cur_obj_play_sound_2(SOUND_OBJ_MRI_DEATH) end
    if frames <= 10 then cur_obj_scale(o.oMrISize + (0.5 - o.oMrISize) * (1.0 - (frames / 10.0))) end
    if frames > 10 then cur_obj_scale(o.oMrISize + math.sin(o.oMrIDizzyTimer * 0.3) * 0.15) end

    if o.oMrIDizzyTimer >= o.oMrIDizzyDuration then o.oAction = MR_I_DEAD end
end

---@param o Object
local function bhv_mr_i_render96_dead(o)
    spawn_mist_particles()
    if o.oBehParams2ndByte == 0x05010000 then
        spawn_default_star(1370, 2000.0, -320.0)
    else
        cur_obj_spawn_loot_blue_coin()
    end    
    obj_mark_for_deletion(o)
end

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_idle(o, player, dist, angleToPlayer, angleDiff)
    o.oFaceAngleYaw = (o.oFaceAngleYaw - 0x100) & 0xFFFF
    o.oFaceAnglePitch = 0

    o.oSwitchTimer1 = o.oSwitchTimer1 - 1
    if o.oSwitchTimer1 <= 0 then
        o.oMrIBlinkIndex = o.oMrIBlinkIndex + 1
        if o.oMrIBlinkIndex > #sMrIBlinkStates then
            o.oMrIBlinkIndex = 1
            o.oSwitchTimer1 = math.random(30, 100)
        else
            o.oSwitchState2 = sMrIBlinkStates[o.oMrIBlinkIndex]
            o.oSwitchTimer1 = 2
        end
    end

    if dist < o.oMrIDetectRadius and angleDiff < FOV_THRESHOLD then
        o.oSwitchState2 = MR_I_OPEN 
        o.oAction = MR_I_ATTACK
        o.oMrIFireTimer = 0
    end
end

sMrIActionStates = { bhv_mr_i_render96_idle, bhv_mr_i_render96_attack, bhv_mr_i_render96_dizzy, bhv_mr_i_render96_dead }
sMrIBlinkStates = { MR_I_OPEN, MR_I_ALMOST_OPEN, MR_I_HALF_OPEN, MR_I_ALMOST_CLOSED, MR_I_CLOSED, MR_I_ALMOST_CLOSED, MR_I_HALF_OPEN, MR_I_ALMOST_OPEN, MR_I_OPEN }

---@param o Object
local function bhv_mr_i_render96_loop(o)
    smlua_anim_util_set_animation(o, "mr_i_idle")
    local player = nearest_player_to_object(o)
    local dist   = dist_between_objects(o, player)
    local angleToPlayer = obj_angle_to_object(o, player)
    local angleDiff = abs_angle_diff(o.oFaceAngleYaw, angleToPlayer)
    sMrIActionStates[o.oAction + 1](o, player, dist, angleToPlayer, angleDiff)
    o.oInteractStatus = 0
end

id_bhvRender96MrI = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_mr_i_render96_init, bhv_mr_i_render96_loop)

---@param o Object
local function bhv_bully_render96_loop(o)
    o.oSwitchTimer1 = o.oSwitchTimer1 - 1
    if o.oSwitchTimer1 <= 0 then
        if o.oSwitchState1 == GOOMBA_EYE_OPEN then
            o.oSwitchState1 = GOOMBA_EYE_CLOSE
            o.oSwitchTimer1 = math.random(4, 10)
        else
            o.oSwitchState1 = GOOMBA_EYE_OPEN
            o.oSwitchTimer1 = math.random(30, 100)
        end
    end
end

id_bhvRender96Bully = hook_behavior(id_bhvSmallBully, OBJ_LIST_GENACTOR, false, nil, bhv_bully_render96_loop)
id_bhvRender96SmallChillBully = hook_behavior(id_bhvSmallChillBully, OBJ_LIST_GENACTOR, false, nil, bhv_bully_render96_loop)

---@param o Object
local function bhv_big_bully_render96_init(o)
    cur_obj_scale(2)
end

id_bhvRender96BigBully = hook_behavior(id_bhvBigBully, OBJ_LIST_GENACTOR, false, bhv_big_bully_render96_init, bhv_bully_render96_loop)
id_bhvRender96BigChillBully = hook_behavior(id_bhvBigChillBully, OBJ_LIST_GENACTOR, false, bhv_big_bully_render96_init, bhv_bully_render96_loop)
id_bhvRender96BigBullyWithMinions = hook_behavior(id_bhvBigBullyWithMinions, OBJ_LIST_GENACTOR, false, bhv_big_bully_render96_init, bhv_bully_render96_loop)

sPiranhaPlantStates = { MR_I_OPEN, MR_I_ALMOST_OPEN, MR_I_HALF_OPEN, MR_I_ALMOST_CLOSED, MR_I_CLOSED, MR_I_ALMOST_CLOSED, MR_I_HALF_OPEN, MR_I_ALMOST_OPEN, MR_I_OPEN }

---@param o Object
local function bhv_piranha_plant_render96_init(o)
    o.oSwitchState2 = 10
end

---@param o Object
local function bhv_piranha_plant_render96_loop(o)
    local sBiteFrames = { 12, 28, 50, 64 }
    local frame = o.header.gfx.animInfo.animFrame
    if o.oAction == PIRANHA_PLANT_ACT_BITING then
        local faceState = 0
        for _, biteFrame in ipairs(sBiteFrames) do
            local delta = frame - biteFrame
            if delta >= -9 and delta <= 9 then
                if delta < 0 then
                    faceState = 10 + delta
                elseif delta == 0 then
                    faceState = 10
                else
                    faceState = 10 - delta
                end
                break
            end
        end
        o.oSwitchState2 = faceState
    end

    if o.oAction == PIRANHA_PLANT_ACT_STOPPED_BITING and frame >= 0 and frame <= 10 then
        o.oSwitchState2 = math.min(frame, 10)
    end
    if o.oAction == PIRANHA_PLANT_ACT_SLEEPING then
        o.oSwitchState2 = 10
    end
end

id_bhvRender96PiranhaPlant = hook_behavior(id_bhvPiranhaPlant, OBJ_LIST_GENACTOR, false, bhv_piranha_plant_render96_init, bhv_piranha_plant_render96_loop)

---@param o Object
local function bhv_fire_piranha_plant_render96_loop(o)
    local frame = o.header.gfx.animInfo.animFrame
    if o.oAction == FIRE_PIRANHA_PLANT_ACT_GROW then
        if frame < 46 then
            o.oSwitchState2 = 10
        elseif frame >= 46 and frame <= 66 then
            o.oSwitchState2 = frame - 56
        else
            o.oSwitchState2 = 10
        end
    end

    if o.oAction == FIRE_PIRANHA_PLANT_ACT_HIDE then
        if frame < 10 then
            o.oSwitchState2 = 10
        elseif frame >= 10 and frame <= 30 then
            o.oSwitchState2 = frame - 20
        else
            o.oSwitchState2 = 10
        end
    end
end

id_bhvRender96FirePiranhaPlant = hook_behavior(id_bhvFirePiranhaPlant, OBJ_LIST_GENACTOR, false, bhv_piranha_plant_render96_init, bhv_fire_piranha_plant_render96_loop)

---@param o Object
local function bhv_chain_chomp_render96_loop(o)
    local frame = o.header.gfx.animInfo.animFrame

    local sBiteFrames = { 0, 1, 2, 4, 6, 8, 6, 4, 2, 0, 2, 4, 6, 8, 6, 4, 2, 1, 0}
    if frame > 0 then
        o.oSwitchState2 = sBiteFrames[frame]
    end
    if frame == -1 then
        o.oSwitchState2 = 0
    end
end

id_bhvRender96ChainChomp = hook_behavior(id_bhvChainChomp, OBJ_LIST_GENACTOR, false, nil, bhv_chain_chomp_render96_loop)

---@param o Object
local function bhv_toad_render96_loop(o)
    -- Castle inside first toad
    if o.oBehParams == -2063597568 then
      o.oSwitchState2 = 0 --vest
      o.oSwitchState1 = 0 --hat
    end
    -- WF room
    if o.oBehParams == -2030043136 then
      o.oSwitchState2 = 3
      o.oSwitchState1 = 0
    end
    -- JRB room
    if o.oBehParams == -2046820352 then
      o.oSwitchState2 = 2
      o.oSwitchState1 = 3
    end
    -- Castle inside second floor next to bobomb painting
    if o.oBehParams == -1996488704 then
      o.oSwitchState2 = 0
      o.oSwitchState1 = 1
    end
    -- Castle inside third floor star
    if o.oBehParams == 1392508928 then
      o.oSwitchState2 = 4
      o.oSwitchState1 = 4
    end
    -- Castle inside second floor star
    if o.oBehParams == 1275068416 then
      o.oSwitchState2 = 4
      o.oSwitchState1 = 4
    end
    -- Basement green wall toad
    if o.oBehParams == -2013265920 then
      o.oSwitchState2 = 1
      o.oSwitchState1 = 2
    end
    -- Basement star
    if o.oBehParams == 1375731712 then
      o.oSwitchState2 = 4
      o.oSwitchState1 = 4
    end
end

id_bhvRender96ToadMessage = hook_behavior(id_bhvToadMessage, OBJ_LIST_GENACTOR, false, nil, bhv_toad_render96_loop)

---@param o Object
local function bhv_boo_render96_init(o)
    o.oOpacity = 255
    o.oSwitchState2 = 0
    o.oSwitchTimer2 = 1
end

---@param o Object
local function bhv_boo_render96_loop(o)

    local sBooScared = { 0, 1, 2, 3, 4, 4, 4}
    local sBooHunt = { 4, 4, 4, 3, 2, 1, 0}
    if o.oOpacity < 255 and o.oSwitchTimer2 < 7 then
        o.oOpacity = 254 - (o.oSwitchTimer2 * 15) 
        o.oSwitchState2 = sBooScared[o.oSwitchTimer2]
        o.oSwitchTimer2 = o.oSwitchTimer2 + 1
    elseif o.oOpacity >= 150 and o.oSwitchTimer2 >= 7 and o.oSwitchTimer2 < 14 then
        o.oSwitchState2 = sBooHunt[o.oSwitchTimer2 - 6]
        o.oSwitchTimer2 = o.oSwitchTimer2 + 1
    elseif o.oOpacity == 255 and o.oSwitchTimer2 == 14 then
        o.oSwitchState2 = 0
        o.oSwitchTimer2 = 1
    elseif o.oOpacity == 40 and o.oSwitchTimer2 == 14 then
        o.oSwitchState2 = 4
        o.oSwitchTimer2 = 7
    elseif o.oOpacity == 40 and o.oSwitchTimer2 == 7 then
        o.oSwitchState2 = 4
    end
end

id_bhvRender96GhostHuntBoo = hook_behavior(id_bhvGhostHuntBoo, OBJ_LIST_GENACTOR, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96GhostHuntBigBoo = hook_behavior(id_bhvGhostHuntBigBoo, OBJ_LIST_GENACTOR, false, bhv_boo_render96_init, bhv_boo_render96_loop)
--id_bhvRender96BooInCastle = hook_behavior(id_bhvBooInCastle, OBJ_LIST_GENACTOR, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96BooWithCage = hook_behavior(id_bhvBooWithCage, OBJ_LIST_GENACTOR, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96BalconyBigBoo = hook_behavior(id_bhvBalconyBigBoo, OBJ_LIST_GENACTOR, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96MerryGoRoundBigBoo = hook_behavior(id_bhvMerryGoRoundBigBoo, OBJ_LIST_GENACTOR, false, bhv_boo_render96_init, bhv_boo_render96_loop)

local function bhv_amp_render96_loop(o)
    if o.oAction == AMP_ACT_ATTACK_COOLDOWN and o.oTimer < 31 then
        if o.oTimer % 2 == 0 then
            o.oSwitchState2 = math.random(1, 2)
            if o.oSwitchState2 == 2 then o.oSwitchState1 = 0 else o.oSwitchState1 = 0 end
        end
    elseif o.oAction == AMP_ACT_ATTACK_COOLDOWN and o.oTimer < 90 then
        o.oSwitchState2 = 1
        o.oSwitchState1 = 1
    else
        o.oSwitchState1 = 0
        o.oSwitchState2 = 0
    end
end

id_bhvRender96CirclingAmp = hook_behavior(id_bhvCirclingAmp, OBJ_LIST_GENACTOR, false, nil, bhv_amp_render96_loop)
id_bhvRender96HomingAmp = hook_behavior(id_bhvHomingAmp, OBJ_LIST_GENACTOR, false, nil, bhv_amp_render96_loop)

local function bhv_bubba_render96_loop(o)

    if o.oAnimState == 0 then
        local cycle = {1, 2, 0, 3, 4, 3, 0}
        --o.oSwitchState2 = cycle[(math.floor(o.oTimer / 4) % 3) + 1]
        o.oSwitchState2 = 0
    elseif o.oAnimState == 1 then
        o.oSwitchState2 = 3
    end
end

id_bhvRender96Bubba = hook_behavior(id_bhvBubba, OBJ_LIST_GENACTOR, false, nil, bhv_bubba_render96_loop)

local function bhv_1up_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

local function bhv_1up_render96_loop(o)
    o.oFaceAngleYaw = o.oMoveAngleYaw
end

id_bhvRender961Up = hook_behavior(id_bhv1Up, OBJ_LIST_LEVEL, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upWalking = hook_behavior(id_bhv1upWalking, OBJ_LIST_LEVEL, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upRunningAway = hook_behavior(id_bhv1upRunningAway, OBJ_LIST_LEVEL, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upSliding = hook_behavior(id_bhv1upSliding, OBJ_LIST_LEVEL, false, bhv_1up_render96_init, bhv_1up_render96_loop) -- MOVE MESH TO HITBOX
id_bhvRender961upJumpOnApproach = hook_behavior(id_bhv1upJumpOnApproach, OBJ_LIST_LEVEL, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender96Hidden1up = hook_behavior(id_bhvHidden1up, OBJ_LIST_LEVEL, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender96Hidden1upInPole = hook_behavior(id_bhvHidden1upInPole, OBJ_LIST_LEVEL, false, bhv_1up_render96_init, bhv_1up_render96_loop)

local function bhv_star_particle_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
    o.activeFlags = ACTIVE_FLAG_ACTIVE | ACTIVE_FLAG_INITIATED_TIME_STOP
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE

        local sStarParticleHitbox = get_temp_object_hitbox()
    sStarParticleHitbox.interactType      = INTERACT_STAR_OR_KEY
    sStarParticleHitbox.downOffset        = 0
    sStarParticleHitbox.damageOrCoinValue = 0
    sStarParticleHitbox.health            = 0
    sStarParticleHitbox.numLootCoins      = 0
    sStarParticleHitbox.radius            = 80
    sStarParticleHitbox.height            = 50
    sStarParticleHitbox.hurtboxRadius     = 0
    sStarParticleHitbox.hurtboxHeight     = 0
    obj_set_hitbox(o, sStarParticleHitbox)
    o.oCelebrationStar = 0
    cur_obj_scale(3)
end

local function find_nearest_star(o)
    local star = o.parentObj
    if star == nil then return nil end
    if obj_has_behavior_id(star, id_bhvCelebrationStar) == 1 then o.oCelebrationStar = 1 else o.oCelebrationStar = 0 end
    return star
end

local function get_star_scale(timer)
    if timer < 10 then return 0 end
    if timer >= 60 then return 3 end
    return (timer - 10) / 50 * 3
end

local function bhv_star_particle_loop(o)
    smlua_anim_util_set_animation(o, "star_glow")
    local star = find_nearest_star(o)
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
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
    end
    if o.parentObj.oTimer > 0 and o.parentObj.activeFlags == ACTIVE_FLAG_DEACTIVATED then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96StarParticle = hook_behavior(nil, OBJ_LIST_LEVEL, false, bhv_star_particle_render96_init, bhv_star_particle_loop)

local is_star_collected = function(o)
    if o == nil then return nil end
    if gNetworkPlayers[0].currCourseNum == nil then return false end
    local starId = o.oBehParams >> 24
    local currentLevelStarFlags = save_file_get_star_flags(get_current_save_file_num() - 1,
    (gLevelValues.useGlobalStarIds ~= 0 and (starId / 7) - 1 or gNetworkPlayers[0].currCourseNum - 1))
    local starBit = gLevelValues.useGlobalStarIds and (starId % 7) or starId
    if currentLevelStarFlags & (1 << starBit) ~= 0 then
        return true
    end
    return false
end

---@param o Object
local function bhv_star_render96_init(o)
    --if o.oInteractType ~= INTERACT_STAR_OR_KEY then return end
    if is_star_collected(o) == false or obj_has_behavior_id(o, id_bhvCelebrationStar) == 1 then
        spawn_non_sync_object(id_bhvRender96StarParticle, E_MODEL_STAR_PARTICLE, o.oPosX, o.oPosY, o.oPosZ, function(o2)
            o2.parentObj = o
        end)
    elseif is_star_collected(o) == true then
        spawn_non_sync_object(id_bhvRender96StarParticle, E_MODEL_STAR_TRANSPARENT_PARTICLE, o.oPosX, o.oPosY, o.oPosZ, function(o2)
            o2.parentObj = o
        end)
    end
end

id_bhvRender96Star = hook_behavior(id_bhvStar, OBJ_LIST_LEVEL, false, bhv_star_render96_init, nil)
id_bhvRender96SpawnedStar = hook_behavior(id_bhvSpawnedStar, OBJ_LIST_LEVEL, false, bhv_star_render96_init, nil)
id_bhvRender96SpawnedStarNoLevelExit = hook_behavior(id_bhvSpawnedStarNoLevelExit, OBJ_LIST_LEVEL, false, bhv_star_render96_init, nil)
id_bhvRender96HiddenStar = hook_behavior(id_bhvHiddenStar, OBJ_LIST_LEVEL, false, bhv_star_render96_init, nil)
id_bhvRender96SpawnCoordStar = hook_behavior(id_bhvStarSpawnCoordinates, OBJ_LIST_LEVEL, false, bhv_star_render96_init, nil)
id_bhvRender96CelebrationStar = hook_behavior(id_bhvCelebrationStar, OBJ_LIST_LEVEL, false, bhv_star_render96_init, nil)

---@param o Object
local function bhv_whomp_render96_init(o)
    o.oThwompPrevAction = o.oAction or 0
    o.oThwompSquishTimer = 0
    o.oThwompSquishDur = 0
    o.oThwompBaseScale = o.header.gfx.scale.x
end

local function bhv_whomp_render96_loop(o)
    local prevAction = o.oThwompPrevAction or o.oAction
    if prevAction ~= 5 and o.oAction == 5 then
        o.oThwompSquishTimer = 0
        o.oThwompSquishDur = 5
        o.oThwompBaseScale = o.header.gfx.scale.x
    end

    if (o.oThwompSquishDur or 0) > 0 and (o.oThwompSquishTimer or 0) <= o.oThwompSquishDur then
        r96lib.squish_apply(o, o.oThwompSquishTimer, o.oThwompSquishDur, -0.10, 0.15, 0.15, o.oThwompBaseScale, nil)
        o.oThwompSquishTimer = o.oThwompSquishTimer + 1
    end

    o.oThwompPrevAction = o.oAction
end

id_bhvRender96SmallWhomp = hook_behavior(id_bhvSmallWhomp, OBJ_LIST_SURFACE, false, bhv_whomp_render96_init, bhv_whomp_render96_loop)
id_bhvRender96WhompKingBoss = hook_behavior(id_bhvWhompKingBoss, OBJ_LIST_SURFACE, false, bhv_whomp_render96_init, bhv_whomp_render96_loop)


---@param o Object
local function bhv_pokey_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

local function bhv_pokey_render96_loop(o)
    local player = nearest_player_to_object(o)
    local angleToPlayer = obj_angle_to_object(o, player)
    o.oFaceAngleYaw =  angleToPlayer
end


id_bhvRender96Pokey = hook_behavior(id_bhvPokey, OBJ_LIST_SURFACE, false, bhv_pokey_render96_init, bhv_pokey_render96_loop)
id_bhvRender96PokeyBodyPart = hook_behavior(id_bhvPokeyBodyPart, OBJ_LIST_SURFACE, false, bhv_pokey_render96_init, bhv_pokey_render96_loop)