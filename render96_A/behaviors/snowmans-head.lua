local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_snowmans_head_render96_loop(o)
    if o.oTimer < 2 and obj_has_model_extended(o, E_MODEL_R96_SNOWMAN_HEAD) == 1 then
        o.oFaceAngleYaw = 0x1000
        --o.oMoveAngleYaw = 0x4000
        --o.oFaceAnglePitch = 0x1000
        o.oFaceAngleRoll = 0x4000
    end
end

id_bhvRender96SnowmansHead = r96lib.hook_behavior(id_bhvSnowmansHead, false, nil, bhv_snowmans_head_render96_loop)
