--
-- Some debug and test stuff idk
-- Don't forget to remove this file before release
--

function squishtest()
    --vec3f_set(gMarioStates[0].marioObj.header.gfx.scale, 3, 1, 1)
    --vec3f_set(gMarioStates[0].marioObj.header.gfx.scale, .1, 1, 1)
    --gMarioStates[0].marioObj.header.gfx.node.flags = gMarioStates[0].marioObj.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
end

hook_event(HOOK_MARIO_UPDATE, squishtest)

local function mario_update(m)
   --if m.playerIndex ~= 0 then return end
 --if m.controller.buttonPressed & X_BUTTON ~= 0 then
   --     --initiate_warp(LEVEL_CASTLE_GROUNDS, 1, WARP_NODE_CREDITS_START, 0)
   --     initiate_warp(LEVEL_CASTLE_GROUNDS, 1, WARP_NODE_CREDITS_END, 0)
   --     --WARP_NODE_CREDITS_END
   ----spawn_non_sync_object(id_bhvRender96YoshiRideable, E_MODEL_YOSHI_RIDEABLE, m.pos.x + 200, m.pos.y, m.pos.z, nil)
   ----spawn_non_sync_object(id_bhvGrandStar, E_MODEL_1UP, m.pos.x + 200, m.pos.y, m.pos.z, nil)
--end
   --if m.action == ACT_BACKFLIP then
   --    warp_to_level(LEVEL_BOB, 1, 1)
   --end
   --SPECIAL_WARP_CAKE
   --WARP_NODE_CREDITS_START
   --SPECIAL_WARP_TITLE
   --SPECIAL_WARP_LEVEL_SELECT
   --SPECIAL_WARP_GODDARD
   --WARP_OP_CREDITS_START
end

hook_event(HOOK_MARIO_UPDATE, mario_update)

