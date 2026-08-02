local r96lib = require("/lib/r96lib")
require("/constants")

local _abs = math.abs

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_blargg_friendly_render96_init(o)
    obj_set_hitbox(o, {
        interactType      = INTERACT_KOOPA_SHELL,
        downOffset        = 0,
        damageOrCoinValue = 4,
        health            = 1,
        numLootCoins      = 1,
        radius            = 100,
        height            = 100,
        hurtboxRadius     = 50,
        hurtboxHeight     = 50,
    })

    o.oAnimations = gObjectAnimations.blargg_seg5_anims_0500616C
    cur_obj_init_animation(ANIM_R96_BLARGG_SWIM)
    obj_set_home(o, o.oPosX, o.oPosY, o.oPosZ)
    o.oAction = 0
    o.activeFlags = ACTIVE_FLAG_ACTIVE
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oMrISize = 1
    cur_obj_scale(1)

    network_init_object(o, true, { "oMrISize" })
end

---@param o Object
local function bhv_blargg_friendly_render96_explode(o)
    local m = gMarioStates[o.heldByPlayerIndex]
    if m ~= nil then
        mario_stop_riding_object(m)
        if m.action & (ACT_FLAG_INTANGIBLE | ACT_FLAG_INVULNERABLE) == 0 then
            set_mario_action(m, ACT_JUMP, 0)
            set_mario_y_vel_based_on_fspeed(m, 42, 0.25)
            mario_set_forward_vel(m, m.forwardVel * 0.8)
            m.flags = m.flags & ~MARIO_UNKNOWN_08 -- Disable the effect of ACT_FLAG_CONTROL_JUMP_HEIGHT
        end
    end

    obj_mark_for_deletion(o)
    local explosion = spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, nil)
    explosion.oGraphYOffset = explosion.oGraphYOffset + 100.0
end

---@param o Object
local function bhv_blargg_friendly_render96_loop(o)
    cur_obj_init_animation(ANIM_R96_BLARGG_SWIM)

    -- Waiting for Mario
    if o.oAction == 0 then
        cur_obj_update_floor_and_walls()
        cur_obj_if_hit_wall_bounce_away()
        cur_obj_move_standard(-20)

        -- Mario started riding
        if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
            local m = get_mario_state_from_ridden_object(o) or nearest_mario_state_to_object(o)
            if m ~= nil then
                o.oAction = 1
                o.heldByPlayerIndex = m.playerIndex
            end
        end

    -- Mario riding
    elseif o.oAction == 1 then
        local m = gMarioStates[o.heldByPlayerIndex]
        if m ~= nil then
            cur_obj_enable_rendering()
            obj_copy_pos(o, m.marioObj)
            o.oFaceAngleYaw = m.marioObj.oMoveAngleYaw
            local floor = cur_obj_update_floor_height_and_get_floor()

            -- Spawn particles and shrink blargg if not on lava
            if _abs(o.oPosY - o.oFloorHeight) < 5.0 then
                if floor ~= nil and floor.type == SURFACE_BURNING then
                    spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
                    o.oMrISize = 1
                else
                    if o.oTimer % 2 == 0 then
                        spawn_non_sync_object(id_bhvBlackSmokeMario, E_MODEL_BURN_SMOKE, m.pos.x, m.pos.y, m.pos.z)
                    end
                    play_sound(SOUND_MOVING_LAVA_BURN, o.header.gfx.cameraToObject)
                    o.oMrISize = o.oMrISize - 0.01
                    if o.oMrISize <= 0.4 then
                        bhv_blargg_friendly_render96_explode(o)
                    end
                end
                cur_obj_scale(o.oMrISize)
            end

            -- Stop riding + failsafe
            if o.oInteractStatus & INT_STATUS_STOP_RIDING ~= 0 or m.action & ACT_FLAG_RIDING_SHELL == 0 then
                bhv_blargg_friendly_render96_explode(o)
            end
        else
            o.oAction = 0
        end
    end

    o.oInteractStatus = 0
end

id_bhvRender96BlarggFriendly = r96lib.hook_behavior(nil, false, bhv_blargg_friendly_render96_init, bhv_blargg_friendly_render96_loop, OBJ_LIST_LEVEL, "BlarggFriendly")
