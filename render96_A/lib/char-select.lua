if _G.charSelect then
    return _G.charSelect
end

--
-- Truth is the mod doesn't really require Character Select to work properly.
-- Most of CS features are not even used here...
-- This could be removed later, but, for now, just emulate the few functions it uses.
--

for i = 0, MAX_PLAYERS - 1 do
    gPlayerSyncTable[i].charNum = gNetworkPlayers[i].modelIndex
end

local CHARACTER_MOVESET_HOOKS_GET_CHAR_TYPE = {
    [HOOK_MARIO_UPDATE] =                           function (m) return m.character.type end,
    [HOOK_BEFORE_MARIO_UPDATE] =                    function (m) return m.character.type end,
    [HOOK_BEFORE_PHYS_STEP] =                       function (m) return m.character.type end,
    [HOOK_ALLOW_PVP_ATTACK] =                       function (m) return m.character.type end,
    [HOOK_ON_PVP_ATTACK] =                          function (m) return m.character.type end,
    [HOOK_ON_INTERACT] =                            function (m) return m.character.type end,
    [HOOK_ALLOW_INTERACT] =                         function (m) return m.character.type end,
    [HOOK_ON_SET_MARIO_ACTION] =                    function (m) return m.character.type end,
    [HOOK_BEFORE_SET_MARIO_ACTION] =                function (m) return m.character.type end,
    [HOOK_ON_DEATH] =                               function (m) return m.character.type end,
    [HOOK_ON_HUD_RENDER] =                          function () return gMarioStates[0].character.type end,
    [HOOK_ON_HUD_RENDER_BEHIND] =                   function () return gMarioStates[0].character.type end,
    [HOOK_ON_LEVEL_INIT] =                          function () return gMarioStates[0].character.type end,
    [HOOK_ON_SYNC_VALID] =                          function () return gMarioStates[0].character.type end,
    [HOOK_ON_OBJECT_RENDER] =                       function () return gMarioStates[0].character.type end,
    [HOOK_ALLOW_FORCE_WATER_ACTION] =               function (m) return m.character.type end,
    [HOOK_MARIO_OVERRIDE_FLOOR_CLASS] =             function (m) return m.character.type end,
    [HOOK_MARIO_OVERRIDE_PHYS_STEP_DEFACTO_SPEED] = function (m) return m.character.type end,
    [HOOK_ON_PLAY_SOUND] =                          function () return gMarioStates[0].character.type end,
}

---@param charNum integer
---@param hookEventType LuaHookedEventType
---@param func function
local function character_hook_moveset(charNum, hookEventType, func)
    hook_event(hookEventType, function (...)
        local get_char_type = CHARACTER_MOVESET_HOOKS_GET_CHAR_TYPE[hookEventType]
        local charType = get_char_type and get_char_type(...) or nil
        if charType == nil or charType == charNum then
            return func(...)
        end
    end)
end

local sCharacterSetLocked = {}
local function check_unlocked(unlockCondition)
    if type(unlockCondition) == "function" then return unlockCondition() end
    return unlockCondition
end

---@param charNum integer
---@param unlockCondition function|boolean
---@param notify boolean
---@param name string
local function character_set_locked(charNum, unlockCondition, notify, name)
    sCharacterSetLocked[charNum] = {
        unlockCondition = unlockCondition,
        notify = notify,
        name = name,
        unlocked = check_unlocked(unlockCondition)
    }
end

---@param localIndex? integer
local function character_get_current_number(localIndex)
    return gMarioStates[localIndex or 0].character.type
end

---@param charNum integer
---@param charAlt integer
local function character_set_current_number(charNum, charAlt)
    gNetworkPlayers[0].overrideModelIndex = charNum
    gPlayerSyncTable[0].charNum = charNum
end

---@param func function
local function hook_allow_menu_open(func)
    -- unused
end

-- This hook is responsible for assigning the right character to the player
-- accounting for the character selected in config and available (unlocked) characters
local sPrevModelIndex = {}
hook_event(HOOK_MARIO_UPDATE, function (m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex ~= 0 then
        np.overrideModelIndex = gPlayerSyncTable[m.playerIndex].charNum
    end

    -- detect change of model index
    if np.modelIndex ~= sPrevModelIndex[m.playerIndex] then
        sPrevModelIndex[m.playerIndex] = np.modelIndex
        np.overrideModelIndex = np.modelIndex
    end

    -- if the current character is locked, fall back to Mario
    local charType = np.overrideModelIndex
    local charLock = sCharacterSetLocked[charType]
    if charLock and not check_unlocked(charLock.unlockCondition) then
        np.overrideModelIndex = CT_MARIO
    end

    -- sync character
    if m.playerIndex == 0 then
        gPlayerSyncTable[m.playerIndex].charNum = np.overrideModelIndex
    end
end)

-- This hook is responsible for checking when a character is unlocked
-- and display a notification to all players
hook_event(HOOK_UPDATE, function ()
    for ct = CT_MARIO, CT_MAX - 1 do
        local charLock = sCharacterSetLocked[ct]
        if charLock and not charLock.unlocked and check_unlocked(charLock.unlockCondition) then
            if charLock.notify then
                play_puzzle_jingle()
                djui_popup_create("Render96:\nYou can now play\nas " .. charLock.name .. "!", 3)
            end
            charLock.unlocked = true
            sPrevModelIndex = {} -- refresh all selected characters
        end
    end
end)

return {
    character_set_locked = character_set_locked,
    character_hook_moveset = character_hook_moveset,
    character_get_current_number = character_get_current_number,
    character_set_current_number = character_set_current_number,
    hook_allow_menu_open = hook_allow_menu_open,
}
