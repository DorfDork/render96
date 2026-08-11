local charSelect = require("/lib/char-select")

TEX_BOWSER_CAKE = get_texture_info("cake_bowser")
TEX_MARIO_CAKE  = get_texture_info("cake")
TEX_LUIGI_CAKE  = get_texture_info("cake_luigi")
TEX_WARIO_CAKE  = get_texture_info("cake_wario")

local CAKE_SCREEN_TEXTURES = {
    [CT_MARIO] = TEX_MARIO_CAKE,
    [CT_LUIGI] = TEX_LUIGI_CAKE,
    [CT_WARIO] = TEX_WARIO_CAKE
}

local function get_current_character_cake_texture()
    if gMarioStates[0].numStars < 70 then
        return TEX_BOWSER_CAKE
    end

    local charNum = charSelect.character_get_current_number()
    return CAKE_SCREEN_TEXTURES[charNum]
end

local function render_character_end_screen()
    if gNetworkPlayers[0].currLevelNum ~= LEVEL_ENDING then return end

    local cakeTexture = get_current_character_cake_texture()
    if not cakeTexture then return end

    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_font(FONT_HUD)
    djui_hud_set_color(0, 0, 0, 255)
    djui_hud_render_rect(0, 0, djui_hud_get_screen_width(), djui_hud_get_screen_height())

    local x = djui_hud_get_screen_width() / 2 - cakeTexture.width / 2
    local y = djui_hud_get_screen_height() / 2 - cakeTexture.height / 2

    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_filter(FILTER_LINEAR)
    djui_hud_render_texture(cakeTexture, x, y, 1, 1)
end

hook_event(HOOK_ON_HUD_RENDER_BEHIND, render_character_end_screen)
