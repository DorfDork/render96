local charSelect = require("/lib/char-select")
local r96lib = require("/lib/r96lib")
local o2oint = require("/lib/o2oint")
require("/constants")

local _abs = math.abs

------------------------
-- Behavior functions --
------------------------

local KOOPA_SHELL_INTERACTIONS = o2oint.Interactions({
    interactions = {

        -- Default behavior for most of the enemies -> attack enemy
        {
            objectLists = {
                OBJ_LIST_GENACTOR, -- Common enemies
                OBJ_LIST_PUSHABLE, -- Goombas, Koopas, Lakitus
                OBJ_LIST_SURFACE, -- Boxes
            },
            targets = {
                id_bhvBobomb,
                obj_is_attackable,
                obj_is_exclamation_box,
            },
            interact = function (interactor, interactee, context)
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_PUNCH | INT_STATUS_WAS_ATTACKED | INT_STATUS_INTERACTED | INT_STATUS_TOUCHED_BOB_OMB
            end,
            ignoreIntangible = false
        },

        -- Behavior for breakable boxes -> break the box
        {
            objectLists = {
                OBJ_LIST_DESTRUCTIVE, -- Bob-ombs, breakable boxes
                OBJ_LIST_SURFACE, -- Boxes
            },
            targets = {
                obj_is_breakable_object
            },
            interact = function (interactor, interactee, context)
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_KICK_OR_TRIP | INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED | INT_STATUS_STOP_RIDING -- "broken" status, specific to breakable boxes
            end,
            ignoreIntangible = false
        },

        -- Behavior for bullies -> repel the bully
        {
            objectLists = {
                OBJ_LIST_GENACTOR, -- Common enemies
            },
            targets = {
                obj_is_bully,
            },
            interact = function (interactor, interactee, context)
                interactee.oMoveAngleYaw = obj_angle_to_object(interactor, interactee)
                interactee.oForwardVel = 3392.0 / interactee.hitboxRadius
                interactee.oInteractStatus = interactee.oInteractStatus | ATTACK_PUNCH | INT_STATUS_WAS_ATTACKED | INT_STATUS_INTERACTED
            end,
            ignoreIntangible = false
        },

        -- Behavior for coins -> collect coin
        {
            objectLists = {
                OBJ_LIST_LEVEL, -- Coins
            },
            targets = {
                obj_is_coin,
            },
            interact = function (interactor, interactee, context)
                if context.m.playerIndex == 0 then
                    interact_coin(context.m, INTERACT_COIN, interactee)
                end
            end,
            ignoreIntangible = false
        },

        -- Behavior for koopa shells -> bounce on the interactor
        {
            targets = {
                id_bhvKoopaShell,
            },
            interact = function (interactor, interactee, context)
                if interactor.oForwardVel >= 10 and interactee.oAction ~= 1 and interactee.oHeldState == HELD_FREE then
                    context.opts.throw(context.m, interactee, context.opts)
                    interactee.oVelY = 0
                    interactee.oMoveAngleYaw = obj_angle_to_object(interactor, interactee)
                    interactee.oAction = context.opts.action

                    local x = (interactor.oPosX + interactee.oPosX) / 2
                    local y = (interactor.oPosY + interactee.oPosY) / 2
                    local z = (interactor.oPosZ + interactee.oPosZ) / 2
                    obj_spawn_particles(x, y + 40, z, 5, E_MODEL_DIRT_ANIMATION, 1.0, 4, 25, 8)
                    play_sound(SOUND_ACTION_BONK, interactee.header.gfx.cameraToObject)
                end
            end,
            ignoreIntangible = false
        },
    }
})

local KOOPA_SHELL_HIT_WARIO_ACTIONS = T{
    ACT_R96_WARIO_CHARGE,
    ACT_JUMP_KICK,
}

---@param o Object
local function bhv_koopa_shell_render96_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oWallHitboxRadius = 50
    o.oGravity = -2.5
    o.oBounciness = -0.5
    o.oDragStrength = 10.0
    o.oFriction = 10.0
    o.oBuoyancy = 1.4

    obj_set_hitbox(o, {
        interactType = INTERACT_KOOPA_SHELL,
        downOffset = 0,
        damageOrCoinValue = 4,
        health = 1,
        numLootCoins = 1,
        radius = 60,
        height = 100,
        hurtboxRadius = 60,
        hurtboxHeight = 100,
    })
end

---@param o Object
local function bhv_koopa_shell_render96_spawn_sparkle(o)
    spawn_non_sync_object(id_bhvSparkle, E_MODEL_SPARKLES_ANIMATION, o.oPosX, o.oPosY + 10, o.oPosZ, function (obj)
        obj_translate_xyz_random(obj, 90.0)
        obj_scale_random(obj, 1.0, 0.0)
    end)
end

---@param o Object
local function bhv_koopa_shell_render96_spawn_flames(o)
    spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
    spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
end

---@param o Object
local function bhv_koopa_shell_render96_spawn_water_drop(o)
    spawn_non_sync_object(id_bhvObjectWaveTrail, E_MODEL_WAVE_TRAIL, o.oPosX, o.oPosY, o.oPosZ, nil)
    local m = gMarioStates[o.heldByPlayerIndex]
    if m ~= nil and m.forwardVel > 10.0 then
        spawn_non_sync_object(id_bhvWaterDroplet, E_MODEL_WHITE_PARTICLE_SMALL, o.oPosX, o.oPosY, o.oPosZ, function (obj)
            obj_scale(obj, 1.5)
            obj.oVelY = random_float() * 30.0
            obj_translate_xz_random(obj, 110.0)
        end)
    end
end

---@param o Object
local function bhv_koopa_shell_render96_spawn_bubbles(o)
    spawn_non_sync_object(id_bhvBubbleParticleSpawner, E_MODEL_BUBBLE, o.oPosX, o.oPosY, o.oPosZ, nil)
end

---@param m MarioState
---@param o Object
---@param opts table
local function bhv_koopa_shell_render96_throw(m, o, opts)
    o.oForwardVel = 50
    o.oVelY = 20
    o.oTimer = 0
end

---@param m MarioState
---@param o Object
---@param opts table
local function bhv_koopa_shell_render96_update_held(m, o, opts)

    -- Failsafe in case it's not Wario holding it
    if charSelect.character_get_current_number(m.playerIndex) ~= CT_WARIO then
        mario_drop_held_object(m)
        obj_mark_for_deletion(o)
        spawn_mist_particles()
    end
end

---@param m MarioState
---@param o Object
---@param opts table
local function bhv_koopa_shell_render96_update_thrown(m, o, opts)
    cur_obj_become_tangible()

    -- Update pos and vel
    o.oForwardVel = math.remap(210, 300, 50, 0, math.clamp(o.oTimer, 210, 300))
    cur_obj_update_floor_and_walls()
    cur_obj_move_standard(78)
    if o.oMoveFlags & OBJ_MOVE_HIT_WALL ~= 0 then
        o.oMoveAngleYaw = cur_obj_reflect_move_angle_off_wall()
        o.oPosX = o.oPosX + o.oWallHitboxRadius * sins(o.oMoveAngleYaw)
        o.oPosZ = o.oPosZ + o.oWallHitboxRadius * coss(o.oMoveAngleYaw)
    end

    -- Process interactions
    local interactions = opts.interactions or nil
    if interactions ~= nil then
        interactions:process_interactions(o, { m = m, opts = opts })
    end

    -- Audio
    if opts.audio and o.oForwardVel > 5 then
        r96lib.audio_fade(o, opts.audio, nil, nil, false)
    end

    -- Return to action 0 when standing still
    if o.oForwardVel <= 0 then
        o.oForwardVel = 0
        o.oAction = 0
    end
end

local KOOPA_SHELL_OPTS = {

-- Mandatory fields
    action = R96_KOOPA_SHELL_ACT_GRAB,
    throw = bhv_koopa_shell_render96_throw,
    update_held = bhv_koopa_shell_render96_update_held,
    update_thrown = bhv_koopa_shell_render96_update_thrown,

-- Extra fields to use in callbacks
    audio = AUDIO_R96_EVENT_SHELL_THROWN,
    interactions = KOOPA_SHELL_INTERACTIONS,
}

---@param o Object
local function bhv_koopa_shell_render96_loop(o)
    cur_obj_scale(1.0)

    -- Not riding
    if o.oAction ~= 1 then

        -- Waiting for Mario
        if o.oAction == 0 then
            cur_obj_become_tangible()
            cur_obj_update_floor_and_walls()
            cur_obj_if_hit_wall_bounce_away()
            cur_obj_move_standard(-20)

        -- Custom held/thrown action
        else
            cur_obj_become_intangible()
            r96lib.update_held_object(o, KOOPA_SHELL_OPTS)
        end

        o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1000
        if find_water_level(o.oPosX, o.oPosZ) > o.oPosY + 50 then
            bhv_koopa_shell_render96_spawn_bubbles(o)
        else
            bhv_koopa_shell_render96_spawn_sparkle(o)
        end

        -- Wario can kick the shell
        if o.oHeldState == HELD_FREE then
            local hit, m = obj_hit_by_wario_action(o, 150, KOOPA_SHELL_HIT_WARIO_ACTIONS)
            if hit and m then
                o.oAction = KOOPA_SHELL_OPTS.action
                o.oMoveAngleYaw = m.faceAngle.y
                bhv_koopa_shell_render96_throw(m, o, KOOPA_SHELL_OPTS)
                network_send_object(o, true)
            end
        end

        -- Mario started riding
        -- Don't check for Wario here! The player is already riding the shell!
        -- Wario failsafe is done in the second part of the code
        if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
            local m = get_mario_state_from_ridden_object(o) or nearest_mario_state_to_object(o)
            if m ~= nil then
                o.oAction = 1
                o.heldByPlayerIndex = m.playerIndex
            end
        end

    -- Mario riding
    else
        local m = gMarioStates[o.heldByPlayerIndex]
        if m ~= nil then
            cur_obj_enable_rendering()
            cur_obj_become_intangible()
            obj_copy_pos(o, m.marioObj)
            o.oFaceAngleYaw = m.marioObj.oMoveAngleYaw

            local floor = cur_obj_update_floor_height_and_get_floor()

            -- Spawn particles
            if _abs(find_water_level(o.oPosX, o.oPosZ) - o.oPosY) < 10.0 then
                bhv_koopa_shell_render96_spawn_water_drop(o)
            elseif _abs(o.oPosY - o.oFloorHeight) < 5.0 and floor ~= nil and floor.type == SURFACE_BURNING then
                bhv_koopa_shell_render96_spawn_flames(o)
            else
                bhv_koopa_shell_render96_spawn_sparkle(o)
            end

            -- Stop riding + failsafe + Wario check
            if o.oInteractStatus & INT_STATUS_STOP_RIDING ~= 0 or m.action & ACT_FLAG_RIDING_SHELL == 0 or charSelect.character_get_current_number(m.playerIndex) == CT_WARIO then
                mario_stop_riding_object(m)
                obj_mark_for_deletion(o)
                spawn_mist_particles()
            end
        else
            o.oAction = 0
        end
    end

    o.oInteractStatus = 0
end

id_bhvRender96KoopaShell = hook_render96_behavior(id_bhvKoopaShell, true, bhv_koopa_shell_render96_init, bhv_koopa_shell_render96_loop)

-----------
-- Hooks --
-----------

local function koopa_shell_render96_allow_interact(m, o, interactType)

    -- Block shell ride interaction for Wario
    if interactType == INTERACT_KOOPA_SHELL and obj_has_behavior_id(o, id_bhvKoopaShell) == 1 and o.oAction ~= 1 and charSelect.character_get_current_number(m.playerIndex) == CT_WARIO then

        -- Instead, check for grab interaction
        if m.playerIndex == 0 and not m.heldObj and not m.riddenObj then
            if interact_grabbable(m, INTERACT_GRABBABLE, o) == 1 and mario_check_object_grab(m) ~= 0 then
                r96lib.init_held_object(o, KOOPA_SHELL_OPTS)
            end

            -- Check water grab
            -- this is ass, thanks sm64 spaghetti code
            if m.action == ACT_WATER_PUNCH and m.actionState == 0 and is_anim_at_end(m) == 1 then
                local dAngleToObject = atan2s(o.oPosZ - m.pos.z, o.oPosX - m.pos.x) - m.faceAngle.y
                if _abs(dAngleToObject) <= 0x2AAA then
                    r96lib.init_held_object(o, KOOPA_SHELL_OPTS)
                    m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
                    m.actionState = 2
                end
            end
        end

        return false
    end
end

hook_event(HOOK_ALLOW_INTERACT, koopa_shell_render96_allow_interact)
