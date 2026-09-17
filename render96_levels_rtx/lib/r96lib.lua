---------------------------------------------------
--                 IMPORTANT NOTE                --
---------------------------------------------------
-- This version of `r96lib` contains only the    --
-- bare minimum for this mod to work properly.   --
-- Make sure to keep the corresponding functions --
-- up to date, but do not copy/paste the whole   --
-- `r96lib` and its dependencies.                --
---------------------------------------------------

r96lib = {}

---------------
-- Behaviors --
---------------

---@param id BehaviorId|number|nil
---@param override boolean
---@param init? function
---@param loop? function
---@param list? ObjectList
---@param name? string
function r96lib.hook_behavior(id, override, init, loop, list, name)
    if id ~= nil then
        list = list or get_object_list_from_behavior(get_behavior_from_id(id))
        name = name or (get_behavior_name_from_id(id):gsub("bhv", "", 1))
    else
        list = list or OBJ_LIST_LEVEL
        name = name or "Unnamed"
    end
    return hook_behavior(id, list, override, init, loop, "bhvRender96" .. name)
end

return r96lib