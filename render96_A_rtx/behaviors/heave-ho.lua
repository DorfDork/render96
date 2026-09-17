local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

id_bhvRender96HeaveHo = r96lib.hook_behavior(id_bhvHeaveHo, false, nil, bhv_chuckya_heaveho_render96_loop)
