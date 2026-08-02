-- name: Render96 Levels Mod Pack
-- description: A Mod Pack That Adds All Render96 Levels To The Game
-- author: \#ff3030\Render96DX Team
-- incompatible: romhack

-- 3D Skybox
local skybox3d = require("/lib/skybox-3d")
require("/constants")

skybox3d.set_level_skybox_model(LEVEL_BOWSER_1, E_MODEL_BOWSER_1_SKYBOX)
