require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_bubba_render96_init(o)
    smlua_anim_util_set_animation(o, ANIM_R96_BUBBA_SWIM)
end

---@param o Object
local function bhv_bubba_render96_loop(o)
    o.oSwitchState1 = o.oAnimState
end

id_bhvRender96Bubba = hook_render96_behavior(id_bhvBubba, false, bhv_bubba_render96_init, bhv_bubba_render96_loop)
