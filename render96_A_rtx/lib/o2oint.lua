--[[

    Object to object interactions

    filename: o2oint.lua
    version: v1.2
    author: PeachyPeach
    required: sm64coopdx v1.4 or later

    A small library to handle object to object interactions with ease.

--]]

--- @alias list<T> table<integer, T>

--- @class BehaviorInteraction
--- @field interact fun(interactor: Object, interactee: Object, context: table|nil): (boolean|nil)
--- @field ignoreIntangible boolean

--- @class FunctionInteraction
--- @field objectLists list<ObjectList|integer>
--- @field func fun(obj:Object):boolean
--- @field interact fun(interactor: Object, interactee: Object, context: table|nil): (boolean|nil)
--- @field ignoreIntangible boolean

--- @class Interactions
--- @field behaviorIds table<BehaviorId|integer, BehaviorInteraction>
--- @field functions list<FunctionInteraction>
--- @field process_interactions fun(self, interactor: Object|table, context: table|nil): table<Object> Processes interactions for the interactor object and returns a table of interacted objects

local type = type
local pairs = pairs
local ipairs = ipairs
local unpack = table.unpack
local obj_get_first = obj_get_first
local obj_get_next = obj_get_next
local obj_is_valid_for_interaction = obj_is_valid_for_interaction
local obj_check_hitbox_overlap = obj_check_hitbox_overlap
local obj_check_overlap_with_hitbox_params = obj_check_overlap_with_hitbox_params

local DEFAULT_OBJ_LISTS = {
    OBJ_LIST_PLAYER,
    OBJ_LIST_EXT,
    OBJ_LIST_DESTRUCTIVE,
    OBJ_LIST_GENACTOR,
    OBJ_LIST_PUSHABLE,
    OBJ_LIST_LEVEL,
    OBJ_LIST_DEFAULT,
    OBJ_LIST_SURFACE,
    OBJ_LIST_POLELIKE,
}

--- @param t table
--- @param value any
--- @param equals (fun(any, any): boolean)|nil
--- @return any
local function tfind(t, value, equals)
    for k, v in pairs(t) do
        if (equals and equals(v, value)) or (not equals and v == value) then
            return k
        end
    end
    return nil
end

--- @param interactions Interactions
--- @param interactor Object|table
--- @param context table|nil
--- @return table<Object>
local function process_interactions(interactions, interactor, context)
    local check_hitbox_overlap, args
    if type(interactor) == "table" then
        check_hitbox_overlap = obj_check_overlap_with_hitbox_params
        args = {
            interactor.oPosX,
            interactor.oPosY,
            interactor.oPosZ,
            interactor.hitboxRadius,
            interactor.hitboxHeight,
            interactor.hitboxDownOffset
        }
    else
        check_hitbox_overlap = obj_check_hitbox_overlap
        args = { interactor }
    end

    --- @type table<Object>
    local interacted = {}
    local processed = {}

    -- Process behaviors
    local behaviorIds = interactions.behaviorIds
    for behaviorId, interaction in pairs(behaviorIds) do
        local ignoreIntangible = interaction.ignoreIntangible
        local interact = interaction.interact
        local obj = obj_get_first_with_behavior_id(behaviorId)
        while obj do
            processed[obj._pointer] = true

            -- Don't interact with itself
            if obj == interactor then
                goto next_obj
            end

            -- Check hitbox overlap
            if not check_hitbox_overlap(obj, unpack(args)) then
                goto next_obj
            end

            -- Check if the object is valid for interaction
            if ignoreIntangible or obj_is_valid_for_interaction(obj) then

                -- Process interaction, stop if it returns true
                interacted[#interacted+1] = obj
                if interact(interactor, obj, context) then
                    return interacted
                end
            end

            ::next_obj::

            obj = obj_get_next_with_same_behavior_id(obj)
        end
    end

    -- Process functions
    local functions = interactions.functions
    for _, interaction in ipairs(functions) do
        local func = interaction.func
        local interact = interaction.interact
        local ignoreIntangible = interaction.ignoreIntangible

        local objectLists = interaction.objectLists
        for _, objList in ipairs(objectLists) do
            local obj = obj_get_first(objList)
            while obj do
                if processed[obj._pointer] then
                    goto next_obj
                end

                -- Don't interact with itself
                if obj == interactor then
                    goto next_obj
                end

                -- Check function
                if not func(obj) then
                    goto next_obj
                end

                -- Check hitbox overlap
                if not check_hitbox_overlap(obj, unpack(args)) then
                    goto next_obj
                end

                -- Check if the object is valid for interaction
                if ignoreIntangible or obj_is_valid_for_interaction(obj) then

                    -- Process interaction, stop if it returns true
                    interacted[#interacted+1] = obj
                    if interact(interactor, obj, context) then
                        return interacted
                    end
                end

                ::next_obj::

                obj = obj_get_next(obj)
            end
        end
    end

    return interacted
end

--- @param interactions table
--- @return Interactions
--- Creates a new Interactions object
local function new_interactions(interactions)
    ---@type Interactions
    local t = {
        behaviorIds = {},
        functions = {},
        process_interactions = process_interactions,
    }

    -- Object lists
    --- @type list<ObjectList|integer>
    local defaultObjectLists = type(interactions.objectLists) == "table" and interactions.objectLists or DEFAULT_OBJ_LISTS

    -- Interactions
    if type(interactions.interactions) == "table" then
        for _, interaction in pairs(interactions.interactions) do

            -- Mandatory keys: 'targets' and 'interact'
            if interaction.targets and type(interaction.interact) == "function" then
                local targets = type(interaction.targets) == "table" and interaction.targets or {interaction.targets}
                local objectLists = type(interaction.objectLists) == "table" and interaction.objectLists or defaultObjectLists
                for _, target in pairs(targets) do

                    -- Allowed types for target: number (behavior id), function
                    if type(target) == "number" then
                        if t.behaviorIds[target] then
                            error("An interaction is already defined for behavior: " .. get_behavior_name_from_id(target))
                        end
                        t.behaviorIds[target] = {
                            interact = interaction.interact,
                            ignoreIntangible = interaction.ignoreIntangible
                        }
                    elseif type(target) == "function" then
                        if tfind(t.functions, target, function (l, r) return l.func == r end) then
                            error("An interaction is already defined for function: " .. tostring(tfind(_G, target)))
                        end
                        table.insert(t.functions, {
                            objectLists = objectLists,
                            func = target,
                            interact = interaction.interact,
                            ignoreIntangible = interaction.ignoreIntangible
                        })
                    end
                end
            end
        end
    end

    return setmetatable({}, {
        __index = t,
        __newindex = function () end,
        __metatable = false
    })
end

local _o2oint = {
    Interactions = new_interactions
}

--- @class o2oint
--- @field Interactions fun(interactions: table): Interactions Creates a new Interactions object
local o2oint = setmetatable({}, {
    __index = _o2oint,
    __newindex = function () end,
    __metatable = false
})

return o2oint
