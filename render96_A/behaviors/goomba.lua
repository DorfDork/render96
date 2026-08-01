local charSelect = require("/lib/char-select")
local r96lib = require("/lib/r96lib")
local o2oint = require("/lib/o2oint")
require("/constants")

local _max = math.max

------------------------
-- Behavior functions --
------------------------

local GOOMBA_INTERACTIONS = o2oint.Interactions({
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
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
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
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
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
                interactor.oMoveFlags = OBJ_MOVE_HIT_WALL -- Kill the goomba
            end,
            ignoreIntangible = false
        },
    }
})

local GOOMBA_DEATH_SOUNDS = {
    [GOOMBA_SIZE_REGULAR] = SOUND_OBJ_ENEMY_DEATH_HIGH,
    [GOOMBA_SIZE_HUGE] = SOUND_OBJ_ENEMY_DEATH_LOW,
    [GOOMBA_SIZE_TINY] = SOUND_OBJ_ENEMY_DEATH_HIGH,
}

---@param o Object
local function bhv_goomba_render96_init(o)
    o.oSwitchState2 = 0
    o.oSwitchState1 = 0
    o.oSwitchTimer1 = 0
    o.oSwitchTimer2 = 0

    -- Disable the goomba spawner thing, it's confusing and prevent the goombas from moving freely
    if o.parentObj ~= o and obj_has_behavior_id(o.parentObj, id_bhvGoombaTripletSpawner) == 1 then
        o.parentObj.oBehParams = o.parentObj.oBehParams | (0xFF << 8)
    end
    o.parentObj = o

    network_init_object(o, true, {
        "oGoombaWalkTimer",
        "oGoombaTargetYaw",
        "oGoombaRelativeSpeed",
    })
end

---@param o Object
function bhv_goomba_render96_death(o)
    o.oAction = OBJ_ACT_INSTANT_DEATH
    network_send_object(o, true)
end

---@param m MarioState
---@param o Object
---@param opts table
local function bhv_goomba_render96_throw(m, o, opts)
    o.oGoombaRelativeSpeed = 40 + _max(0, m.forwardVel)
    o.oForwardVel = o.oGoombaRelativeSpeed
    o.oVelY = 24
    o.oTimer = 0
end

---@param m MarioState
---@param o Object
---@param opts table
local function bhv_goomba_render96_update_held(m, o, opts)

    -- Failsafe in case it's not Wario holding it
    if charSelect.character_get_current_number(m.playerIndex) ~= CT_WARIO then
        mario_drop_held_object(m)
        o.oHeldState = HELD_THROWN
    end
end

---@param m MarioState
---@param o Object
---@param opts table
local function bhv_goomba_render96_update_thrown(m, o, opts)
    cur_obj_become_tangible()
    cur_obj_init_animation_with_accel_and_sound(0, 4)

    -- Update pos and vel
    o.oForwardVel = o.oGoombaRelativeSpeed
    o.oGravity = -4
    o.oBuoyancy = 0
    cur_obj_update_floor_and_walls()
    cur_obj_move_standard(-78)

    -- Process interactions
    local interactions = opts.interactions or nil
    if interactions ~= nil then
        interactions:process_interactions(o, { m = m, opts = opts })
    end

    -- Audio
    if opts.audio then
        r96lib.audio_fade(o, opts.audio, nil, nil, false)
    end

    -- Dead on impact
    if o.oMoveFlags & (OBJ_MOVE_LANDED | OBJ_MOVE_HIT_WALL | OBJ_MOVE_MASK_IN_WATER | OBJ_MOVE_ABOVE_LAVA) ~= 0 then
        bhv_goomba_render96_death(o)
        if opts.audio then
            audio_stream_stop(opts.audio)
        end
    end

    -- Make it spin
    obj_rotate_gfx_around_center(o,
        { x = 0, y = 40, z = 0 },
        { x = 0x1800 * o.oTimer, y = o.oFaceAngleYaw, z = 0 }
    )

    -- Make it intangible for a few frames to not hurt the player that threw it
    if o.oTimer < 5 then
        cur_obj_become_intangible()
    end
end

local GOOMBA_OPTS = {

-- Mandatory fields
    action = R96_GOOMBA_ACT_GRAB,
    throw = bhv_goomba_render96_throw,
    update_held = bhv_goomba_render96_update_held,
    update_thrown = bhv_goomba_render96_update_thrown,

-- Extra fields to use in callbacks
    audio = AUDIO_R96_EVENT_THROWN,
    interactions = GOOMBA_INTERACTIONS,
}

---@param o Object
local function bhv_goomba_render96_loop(o)

    -- Update eye and mouth states
    obj_update_eye_blink(o, 3, 8, 30, 100)
    if o.oAction == GOOMBA_ACT_JUMP then
        o.oSwitchState1 = 0
        o.oSwitchTimer1 = 0
        o.oSwitchState2 = 1
    else
        o.oSwitchState2 = 0
    end

    -- Instant death
    if o.oAction == OBJ_ACT_INSTANT_DEATH then
        if o.oGoombaSize == GOOMBA_SIZE_HUGE then
            obj_spawn_blue_coins(o, 1)
        else
            obj_spawn_yellow_coins(o, o.oNumLootCoins)
        end
        spawn_mist_particles_with_sound(SOUND_OBJ_STOMPED)
        create_sound_spawner(GOOMBA_DEATH_SOUNDS[o.oGoombaSize])
        obj_mark_for_deletion(o)
        return
    end

    -- Stun action
    if o.oAction == R96_GOOMBA_ACT_STUN then
        o.oForwardVel = 0
        cur_obj_update_floor_and_walls()
        cur_obj_move_standard(-78)

        cur_obj_init_animation_with_accel_and_sound(0, 0.5)
        o.oGoombaTargetYaw = o.oGoombaTargetYaw + 0x1000
        cur_obj_rotate_yaw_toward(o.oGoombaTargetYaw, 0x1000)
        o.oSwitchState1 = 2
        o.oSwitchState2 = 1

        -- If not picked up after some time, go back to walking
        if o.oTimer > 150 then
            o.oAction = GOOMBA_ACT_WALK
            o.oSwitchState1 = 0
            o.oSwitchState2 = 0
            cur_obj_init_animation_with_accel_and_sound(0, 1)
            return
        end

    -- Grab action
    elseif o.oAction == R96_GOOMBA_ACT_GRAB then
        cur_obj_become_intangible()

        r96lib.update_held_object(o, GOOMBA_OPTS)

        if o.oHeldState == HELD_HELD then
            cur_obj_init_animation_with_accel_and_sound(0, 0.5)
            o.oSwitchState2 = 1
            o.oSwitchState1 = 2
        end

    -- Knockback actions
    elseif o.oAction == OBJ_ACT_HORIZONTAL_KNOCKBACK or o.oAction == OBJ_ACT_VERTICAL_KNOCKBACK then
        cur_obj_init_animation_with_accel_and_sound(0, 3)
        obj_rotate_gfx_around_center(o,
            { x = 0, y = 40, z = 0 },
            { x = -0x1000 * o.oTimer, y = o.oFaceAngleYaw, z = 0 }
        )
    end

    o.oInteractStatus = 0
end

id_bhvRender96Goomba = hook_render96_behavior(id_bhvGoomba, false, bhv_goomba_render96_init, bhv_goomba_render96_loop)

-----------
-- Hooks --
-----------

local function goomba_render96_allow_interact(m, o, interactType)

    -- Handle Wario interactions
    if interactType == INTERACT_BOUNCE_TOP and obj_has_behavior_id(o, id_bhvGoomba) == 1 and o.oAction < 100 and charSelect.character_get_current_number(m.playerIndex) == CT_WARIO then

        -- The following only applies to regular and big goombas
        if o.oGoombaSize == GOOMBA_SIZE_TINY then
            return
        end

        -- Wario charge
        -- You know what? Vaporizing goombas on contact was not very fun...
        -- Let's throw them with violence!
        if m.action == ACT_R96_WARIO_CHARGE then
            o.oFaceAngleYaw = obj_angle_to_object(m.marioObj, o)
            o.oMoveAngleYaw = o.oFaceAngleYaw
            o.oAction = R96_GOOMBA_ACT_GRAB
            bhv_goomba_render96_throw(m, o, GOOMBA_OPTS)
            o.oVelY = 50
            network_send_object(o, true)
            m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
            return false
        end

        local interaction = determine_interaction(m, o)

        -- Stun the goomba if Wario jumped on it
        if o.oAction < R96_GOOMBA_ACT_STUN and interaction == INT_HIT_FROM_ABOVE then
            o.oAction = R96_GOOMBA_ACT_STUN
            spawn_non_sync_object(id_bhvHorStarParticleSpawner, E_MODEL_NONE, m.pos.x, m.pos.y, m.pos.z)
            mario_bounce_off_object(m, o, 30)
            network_send_object(o, true)
            return false
        end

        -- Grab the goomba
        if o.oAction == R96_GOOMBA_ACT_STUN then

            -- Push Wario out of the goomba if trying to jump on it again
            if interaction == INT_HIT_FROM_ABOVE then
                push_mario_out_of_object(m, o)
                return false
            end

            -- Try to grab
            if interaction == INT_PUNCH then
                if m.playerIndex == 0 and not m.heldObj and not m.riddenObj and interact_grabbable(m, INTERACT_GRABBABLE, o) == 1 and mario_check_object_grab(m) ~= 0 then
                    r96lib.init_held_object(o, GOOMBA_OPTS)
                else
                    push_mario_out_of_object(m, o)
                end
                return false
            end

            if interaction == 0 then
                push_mario_out_of_object(m, o)
                return false
            end
        end
    end
end

hook_event(HOOK_ALLOW_INTERACT, goomba_render96_allow_interact)

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_kug(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = (o.oTimer // 4) % 4
end

---------------
-- UV scroll --
---------------

-- UvScroll.hook_scrolling_function('kug_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('kug_switchopt1_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt1_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt1_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('kug_switchopt2_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt2_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt2_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('kug_switchopt3_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt3_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt3_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('kug_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt1_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt2_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt3_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('goomba_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_1', uv_scroll_spin)
-- UvScroll.hook_scrolling_function('goomba_underground_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_1', uv_scroll_spin)
-- UvScroll.hook_scrolling_function('goomba_boxart_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_2', uv_scroll_spin)
-- UvScroll.hook_scrolling_function('kug_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_2', uv_scroll_spin)
