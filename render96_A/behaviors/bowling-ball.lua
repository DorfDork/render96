local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_bowling_ball(o)
    if obj_hit_by_wario_charge(o, 200) then
        create_sound_spawner(SOUND_GENERAL2_BOBOMB_EXPLOSION)
        obj_kill_common(o)
    end
end

id_bhvRender96BowlingBall = r96lib.hook_behavior(id_bhvBowlingBall, false, nil, bhv_bowling_ball)

---@param o Object
local function bhv_pit_bowling_ball(o)
    if obj_hit_by_wario_charge(o, 200) then
        obj_spawn_blue_coins(o, 1)
        create_sound_spawner(SOUND_GENERAL2_BOBOMB_EXPLOSION)
        obj_kill_common(o)
    end
end

id_bhvRender96PitBowlingBall = r96lib.hook_behavior(id_bhvPitBowlingBall, false, nil, bhv_pit_bowling_ball)
