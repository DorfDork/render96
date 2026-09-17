local TEX_BOO_KEY    = get_texture_info("texture_hud_boo_key")
local TEX_WARIO_COIN = get_texture_info("texture_hud_wario_coin")

local function in_cutscene()
    local act = gMarioStates[0].action
    return act == ACT_END_PEACH_CUTSCENE
        or act == ACT_CREDITS_CUTSCENE
        or act == ACT_END_WAVING_CUTSCENE
        or act == ACT_INTRO_CUTSCENE
end

---@param y number
local function render_hud_keys(y)
    if in_cutscene() then return y end
    if obj_get_first_with_behavior_id(id_bhvActSelector) then return y end
    if hud_is_hidden() then return y end
    if count_luigi_keys() <= 0 or is_luigi_unlocked() then return y end
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_render_texture(TEX_BOO_KEY, 22, y, 16 / TEX_BOO_KEY.width, 16 / TEX_BOO_KEY.height)
    djui_hud_set_font(FONT_HUD)
    djui_hud_print_text("@", 38, y, 1)
    djui_hud_print_text(tostring(count_luigi_keys()), 54, y, 1)
    return y + 20
end

---@param y number
local function render_hud_wario_coins(y)
    if in_cutscene() then return y end
    if obj_get_first_with_behavior_id(id_bhvActSelector) then return y end
    if hud_is_hidden() then return y end
    if count_wario_coins() <= 0 or is_wario_unlocked() then return y end
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_render_texture(TEX_WARIO_COIN, 22, y, 16 / TEX_WARIO_COIN.width, 16 / TEX_WARIO_COIN.height)
    djui_hud_set_font(FONT_HUD)
    djui_hud_print_text("@", 38, y, 1)
    djui_hud_print_text(tostring(count_wario_coins()), 54, y, 1)
    return y + 20
end

local function render_hud()
    local y = 35
    y = render_hud_keys(y)
    y = render_hud_wario_coins(y)
end

---@param msg string
local function toggle_hud(msg)
    if msg == "0" then
        hud_hide()
        return true
    elseif string.sub(msg, 1, 1) == "1" then
        hud_show()
        return true
    end
    return false
end

hook_event(HOOK_ON_HUD_RENDER_BEHIND, render_hud)
hook_chat_command("r96-hud", "[0|1]", toggle_hud)

-- Fix Character Select displaying the HUD on the title screen/Goddard/file select
-- Explanation: OG SM64 always sets HUD_DISPLAY_FLAG_UNKNOWN_0020, unless when it completely hides the HUD
hook_event(HOOK_UPDATE, function ()
    if hud_get_value(HUD_DISPLAY_FLAGS) & HUD_DISPLAY_FLAG_UNKNOWN_0020 == 0 then
        hud_hide()
    else
        hud_show()
    end
end)
