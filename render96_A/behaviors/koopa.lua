local charSelect = require("/lib/char-select")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_koopa_render96_loop(o)

    -- Poof, he's gone!
    if o.oAction == OBJ_ACT_INSTANT_DEATH then
        spawn_mist_particles_with_sound(SOUND_OBJ_STOMPED)
        spawn_mist_particles_with_sound(SOUND_OBJ_KOOPA_FLYGUY_DEATH)
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96Koopa = hook_render96_behavior(id_bhvKoopa, false, nil, bhv_koopa_render96_loop)

-----------
-- Hooks --
-----------

local function koopa_on_attack(m, o)
    if (o.oInteractStatus & INT_STATUS_WAS_ATTACKED ~= 0 and      -- Attacked
        obj_has_behavior_id(o, id_bhvKoopa) == 1 and              -- Koopa
        o.oBehParams2ndByte < KOOPA_BP_KOOPA_THE_QUICK_BASE and   -- Not quick, not tiny
        m.playerIndex == 0 and                                    -- Local
        charSelect.character_get_current_number() == CT_WARIO)    -- Wario
    then

        -- Breaking news: local Wario vaporizes koopa
        o.oAction = OBJ_ACT_INSTANT_DEATH
        spawn_sync_object(id_bhvKoopaShell, E_MODEL_KOOPA_SHELL, o.oPosX, o.oPosY, o.oPosZ, nil)
        spawn_sync_object(id_bhvMrIBlueCoin, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
        network_send_object(o, true)
    end
end

hook_event(HOOK_ON_ATTACK_OBJECT, koopa_on_attack)
