require("/constants")

-- TODO: same problem as Wario held animations?

-------------------
-- Geo functions --
-------------------

-- Hands --

local R96_PEACH_HANDS_ENDING_STATES = {
    [3] = { -- END_PEACH_CUTSCENE_SPAWN_PEACH
        [0] = 1,
    },
    [4] = { -- END_PEACH_CUTSCENE_DESCEND_PEACH
        [0] = 1,
    },
    [5] = { -- END_PEACH_CUTSCENE_RUN_TO_PEACH
        [0] = 1,
    },
    [6] = { -- END_PEACH_CUTSCENE_DIALOG_1
        [120] = 0,
        [320] = 1,
    },
    [7] = { -- END_PEACH_CUTSCENE_DIALOG_2
        [0]  = 0,
        [42] = 1,
    },
    [8] = { -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        [0]   = 1,
        [35]  = 0,
        [130] = 1,
    },
    [10] = { -- END_PEACH_CUTSCENE_DIALOG_3
        [0]  = 1,
        [22] = 0,
    },
}

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_peach_left_hand(node, matStackIndex)
    geo_switch_end_peach_cutscene(node, matStackIndex, gMarioStates[0], R96_PEACH_HANDS_ENDING_STATES)
end

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_peach_right_hand(node, matStackIndex)
    geo_switch_end_peach_cutscene(node, matStackIndex, gMarioStates[0], R96_PEACH_HANDS_ENDING_STATES)
end

-- Lip sync --

local R96_PEACH_LIP_CLOSED = 0
local R96_PEACH_LIP_A      = 1
local R96_PEACH_LIP_E      = 2
local R96_PEACH_LIP_O      = 3

local R96_PEACH_LIP_ENDING_STATES = {
    [6] = { -- END_PEACH_CUTSCENE_DIALOG_1
        [181] = R96_PEACH_LIP_O,
        [231] = R96_PEACH_LIP_CLOSED,
        [234] = R96_PEACH_LIP_A,
        [238] = R96_PEACH_LIP_O,
        [239] = R96_PEACH_LIP_E,
        [242] = R96_PEACH_LIP_A,
        [243] = R96_PEACH_LIP_O,
        [264] = R96_PEACH_LIP_CLOSED,
        [291] = R96_PEACH_LIP_A,
        [294] = R96_PEACH_LIP_CLOSED,
        [297] = R96_PEACH_LIP_A,
        [299] = R96_PEACH_LIP_O,
        [303] = R96_PEACH_LIP_A,
        [305] = R96_PEACH_LIP_CLOSED,
        [307] = R96_PEACH_LIP_A,
        [309] = R96_PEACH_LIP_E,
        [315] = R96_PEACH_LIP_A,
        [324] = R96_PEACH_LIP_E,
        [326] = R96_PEACH_LIP_A,
        [328] = R96_PEACH_LIP_E,
        [330] = R96_PEACH_LIP_A,
        [333] = R96_PEACH_LIP_E,
        [337] = R96_PEACH_LIP_O,
        [342] = R96_PEACH_LIP_A,
        [343] = R96_PEACH_LIP_CLOSED,
        [344] = R96_PEACH_LIP_O,
        [346] = R96_PEACH_LIP_A,
        [348] = R96_PEACH_LIP_CLOSED,
        [350] = R96_PEACH_LIP_A,
        [355] = R96_PEACH_LIP_E,
        [358] = R96_PEACH_LIP_A,
        [360] = R96_PEACH_LIP_E,
        [365] = R96_PEACH_LIP_CLOSED,
    },
    [7] = { -- END_PEACH_CUTSCENE_DIALOG_2
        [27]  = R96_PEACH_LIP_A,
        [30]  = R96_PEACH_LIP_CLOSED,
        [31]  = R96_PEACH_LIP_A,
        [34]  = R96_PEACH_LIP_E,
        [36]  = R96_PEACH_LIP_A,
        [39]  = R96_PEACH_LIP_E,
        [44]  = R96_PEACH_LIP_A,
        [48]  = R96_PEACH_LIP_E,
        [51]  = R96_PEACH_LIP_O,
        [55]  = R96_PEACH_LIP_E,
        [57]  = R96_PEACH_LIP_O,
        [66]  = R96_PEACH_LIP_CLOSED,
        [77]  = R96_PEACH_LIP_A,
        [83]  = R96_PEACH_LIP_E,
        [85]  = R96_PEACH_LIP_O,
        [87]  = R96_PEACH_LIP_CLOSED,
        [89]  = R96_PEACH_LIP_A,
        [92]  = R96_PEACH_LIP_O,
        [93]  = R96_PEACH_LIP_E,
        [97]  = R96_PEACH_LIP_A,
        [98]  = R96_PEACH_LIP_O,
        [105] = R96_PEACH_LIP_CLOSED,
        [129] = R96_PEACH_LIP_O,
        [131] = R96_PEACH_LIP_E,
        [136] = R96_PEACH_LIP_A,
        [140] = R96_PEACH_LIP_CLOSED,
        [142] = R96_PEACH_LIP_O,
        [144] = R96_PEACH_LIP_CLOSED,
        [145] = R96_PEACH_LIP_O,
        [147] = R96_PEACH_LIP_E,
        [149] = R96_PEACH_LIP_O,
        [152] = R96_PEACH_LIP_CLOSED,
        [154] = R96_PEACH_LIP_E,
        [156] = R96_PEACH_LIP_CLOSED,
        [158] = R96_PEACH_LIP_E,
        [162] = R96_PEACH_LIP_CLOSED,
        [163] = R96_PEACH_LIP_E,
        [168] = R96_PEACH_LIP_O,
        [170] = R96_PEACH_LIP_A,
        [172] = R96_PEACH_LIP_E,
        [174] = R96_PEACH_LIP_CLOSED,
        [175] = R96_PEACH_LIP_O,
        [177] = R96_PEACH_LIP_A,
        [179] = R96_PEACH_LIP_E,
        [181] = R96_PEACH_LIP_O,
        [191] = R96_PEACH_LIP_CLOSED,
    },
    [10] = { -- END_PEACH_CUTSCENE_DIALOG_3
        [0]   = R96_PEACH_LIP_A,
        [3]   = R96_PEACH_LIP_E,
        [5]   = R96_PEACH_LIP_A,
        [7]   = R96_PEACH_LIP_E,
        [9]   = R96_PEACH_LIP_A,
        [12]  = R96_PEACH_LIP_CLOSED,
        [14]  = R96_PEACH_LIP_E,
        [16]  = R96_PEACH_LIP_CLOSED,
        [18]  = R96_PEACH_LIP_O,
        [21]  = R96_PEACH_LIP_A,
        [22]  = R96_PEACH_LIP_E,
        [28]  = R96_PEACH_LIP_CLOSED,
        [46]  = R96_PEACH_LIP_E,
        [48]  = R96_PEACH_LIP_A,
        [51]  = R96_PEACH_LIP_E,
        [54]  = R96_PEACH_LIP_CLOSED,
        [55]  = R96_PEACH_LIP_A,
        [58]  = R96_PEACH_LIP_E,
        [60]  = R96_PEACH_LIP_CLOSED,
        [61]  = R96_PEACH_LIP_A,
        [63]  = R96_PEACH_LIP_CLOSED,
        [64]  = R96_PEACH_LIP_A,
        [65]  = R96_PEACH_LIP_O,
        [68]  = R96_PEACH_LIP_A,
        [72]  = R96_PEACH_LIP_O,
        [74]  = R96_PEACH_LIP_A,
        [76]  = R96_PEACH_LIP_E,
        [80]  = R96_PEACH_LIP_A,
        [83]  = R96_PEACH_LIP_E,
        [90]  = R96_PEACH_LIP_CLOSED,
        [130] = R96_PEACH_LIP_A,
        [132] = R96_PEACH_LIP_O,
        [135] = R96_PEACH_LIP_CLOSED,
        [138] = R96_PEACH_LIP_A,
        [142] = R96_PEACH_LIP_O,
        [143] = R96_PEACH_LIP_E,
        [147] = R96_PEACH_LIP_A,
        [148] = R96_PEACH_LIP_O,
        [169] = R96_PEACH_LIP_CLOSED,
    },
}

---@param node GraphNode
---@param matStackIndex integer
function geo_switch_peach_lip(node, matStackIndex)
    geo_switch_end_peach_cutscene(node, matStackIndex, gMarioStates[0], R96_PEACH_LIP_ENDING_STATES)
end
