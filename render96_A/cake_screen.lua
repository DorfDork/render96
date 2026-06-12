TEX_BOWSER_CAKE = get_texture_info("cake_bowser")
TEX_MARIO_CAKE  = get_texture_info("cake")
TEX_LUIGI_CAKE  = get_texture_info("cake_luigi")
TEX_WARIO_CAKE  = get_texture_info("cake_wario")

local sCakeScreen = {
    [CT_MARIO] = TEX_MARIO_CAKE,
    [CT_LUIGI] = TEX_LUIGI_CAKE,
    [CT_WARIO] = TEX_WARIO_CAKE
}

function render_character_end_screen()
    local x = djui_hud_get_screen_width() / 2 - TEX_MARIO_CAKE.width / 2
    local y = djui_hud_get_screen_height() / 2 - TEX_MARIO_CAKE.height / 2
    local charNum = _G.charSelect.character_get_current_number()

    if gNetworkPlayers[0].currLevelNum ~= LEVEL_ENDING then return end

    djui_hud_render_rect(0, 0, djui_hud_get_screen_width(), djui_hud_get_screen_height())

    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_filter(FILTER_LINEAR)

    -- Character Specific Rendering Based on Star Count
    if gMarioStates[0].numStars >= 70 then
        djui_hud_render_texture(sCakeScreen[charNum], x, y, 1, 1)
    else
        djui_hud_render_texture(TEX_BOWSER_CAKE, x, y, 1, 1)
    end
end

hook_event(HOOK_ON_HUD_RENDER_BEHIND, function()
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_font(FONT_HUD)

    djui_hud_set_color(0, 0, 0, 255)
    render_character_end_screen()
end)