local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

local CHAIN_CHOMP_BITE_FRAMES = { 0, 1, 2, 4, 6, 8, 6, 4, 2, 0, 2, 4, 6, 8, 6, 4, 2, 1, 0 }

---@param o Object
local function bhv_chain_chomp_render96_loop(o)
    local frame = o.header.gfx.animInfo.animFrame
    o.oSwitchState2 = CHAIN_CHOMP_BITE_FRAMES[frame] or 0
end

id_bhvRender96ChainChomp = r96lib.hook_behavior(id_bhvChainChomp, false, nil, bhv_chain_chomp_render96_loop)
