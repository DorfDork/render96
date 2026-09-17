local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

-- hat, vest
local TOAD_OUTFITS = {
    [DIALOG_133] = { 0, 0 }, -- castle inside first toad
    [DIALOG_135] = { 0, 3 }, -- WF room
    [DIALOG_134] = { 3, 2 }, -- JRB room
    [DIALOG_137] = { 1, 0 }, -- castle inside second floor next to bobomb painting
    [DIALOG_083] = { 4, 4 }, -- castle inside third floor star
    [DIALOG_076] = { 4, 4 }, -- castle inside second floor star
    [DIALOG_136] = { 2, 1 }, -- basement green wall toad
    [DIALOG_082] = { 4, 4 }, -- basement star
}

---@param dialogId DialogId
local function get_toad_outfit(dialogId)
    local outfit = TOAD_OUTFITS[dialogId]
    if outfit then return outfit end

    local dialogs = gBehaviorValues.dialogs
    if dialogId == dialogs.ToadStar1Dialog      then return TOAD_OUTFITS[DIALOG_082] end
    if dialogId == dialogs.ToadStar1AfterDialog then return TOAD_OUTFITS[DIALOG_082] end
    if dialogId == dialogs.ToadStar2Dialog      then return TOAD_OUTFITS[DIALOG_076] end
    if dialogId == dialogs.ToadStar2AfterDialog then return TOAD_OUTFITS[DIALOG_076] end
    if dialogId == dialogs.ToadStar3Dialog      then return TOAD_OUTFITS[DIALOG_083] end
    if dialogId == dialogs.ToadStar3AfterDialog then return TOAD_OUTFITS[DIALOG_083] end
end

---@param o Object
local function bhv_toad_render96_loop(o)
    local dialogId = (o.oBehParams >> 24) & 0xFF

    local outfit = get_toad_outfit(dialogId)
    if outfit then
        o.oSwitchState1 = outfit[1]
        o.oSwitchState2 = outfit[2]
    end
end

id_bhvRender96ToadMessage = r96lib.hook_behavior(id_bhvToadMessage, false, nil, bhv_toad_render96_loop)
