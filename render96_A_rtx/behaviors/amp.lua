local r96lib = require("/lib/r96lib")
require("/constants")

local _random = math.random

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_amp_render96_loop(o)
    if o.oAction == AMP_ACT_ATTACK_COOLDOWN and o.oTimer < 31 then
        if o.oTimer % 2 == 0 then
            o.oSwitchState2 = _random(1, 2)
            o.oSwitchState1 = 0
        end
    elseif o.oAction == AMP_ACT_ATTACK_COOLDOWN and o.oTimer < 90 then
        o.oSwitchState2 = 1
        o.oSwitchState1 = 1
    else
        o.oSwitchState1 = 0
        o.oSwitchState2 = 0
    end
end

id_bhvRender96CirclingAmp = r96lib.hook_behavior(id_bhvCirclingAmp, false, nil, bhv_amp_render96_loop)
id_bhvRender96HomingAmp = r96lib.hook_behavior(id_bhvHomingAmp, false, nil, bhv_amp_render96_loop)
