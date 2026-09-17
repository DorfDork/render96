local r96lib = require("/lib/r96lib")
require("/constants")

local _max  = math.max
local _min  = math.min
local _sqrt = math.sqrt

------------------------
-- Behavior functions --
------------------------

YOSHI_TONGUE_EXTEND_FRAMES  = 8
YOSHI_TONGUE_RETRACT_FRAMES = 10
YOSHI_TONGUE_LATCH_HOLD     = 15
YOSHI_TONGUE_RADIUS         = 500.0
YOSHI_TONGUE_MODEL_LENGTH   = 40.0

---@param o Object
local function bhv_yoshi_tongue(o)
    local m = gMarioStates[network_local_index_from_global(o.globalPlayerIndex)]

    if m == nil or m.marioObj == nil then
        obj_mark_for_deletion(o)
        return
    end

    -- Target died mid-flight: freeze the lock point where the tip currently is, retract from there.
    if o.parentObj ~= nil and (o.parentObj.activeFlags & ACTIVE_FLAG_DEACTIVATED) ~= 0 then
        o.oTongueLockX, o.oTongueLockY, o.oTongueLockZ = o.parentObj.oPosX, o.parentObj.oPosY, o.parentObj.oPosZ
        o.parentObj = nil
        o.oAction = R96_YOSHI_TONGUE_ACT_RETRACTING
    end

    -- Base tracks the mouth every frame so the tongue follows Mario/Yoshi's head while out.
    local baseX = m.marioObj.oPosX + 20.0 * sins(m.faceAngle.y)
    local baseY = m.marioObj.oPosY + 60.0
    local baseZ = m.marioObj.oPosZ + 20.0 * coss(m.faceAngle.y)

    local targetX, targetY, targetZ
    if o.parentObj ~= nil then
        targetX, targetY, targetZ = o.parentObj.oPosX, o.parentObj.oPosY, o.parentObj.oPosZ
    else
        targetX, targetY, targetZ = o.oTongueLockX, o.oTongueLockY, o.oTongueLockZ
    end

    local dx, dy, dz = targetX-baseX, targetY-baseY, targetZ-baseZ
    local distance = _max(_sqrt(dx*dx + dy*dy + dz*dz), 0.001)

    if o.oAction == R96_YOSHI_TONGUE_ACT_EXTENDING then
        o.oTongueU = _min(o.oTongueU + (1.0 / YOSHI_TONGUE_EXTEND_FRAMES), 1.0)

        if o.oTongueU >= 1.0 then
            if o.parentObj ~= nil then
                o.oAction = R96_YOSHI_TONGUE_ACT_LATCHED
                o.oTongueTimer = 0
                queue_rumble_data_mario(m, 4, 40)
                play_sound(SOUND_GENERAL_BOING1, m.marioObj.header.gfx.cameraToObject)
                -- hook your grab/damage effect on o.parentObj here
            else
                o.oAction = R96_YOSHI_TONGUE_ACT_RETRACTING -- missed
            end
        end

    elseif o.oAction == R96_YOSHI_TONGUE_ACT_LATCHED then
        o.oTongueTimer = o.oTongueTimer + 1
        if o.oTongueTimer >= YOSHI_TONGUE_LATCH_HOLD then
            o.oAction = R96_YOSHI_TONGUE_ACT_RETRACTING
        end

    else -- RETRACTING
        o.oTongueU = o.oTongueU - (1.0 / YOSHI_TONGUE_RETRACT_FRAMES)
        if o.oTongueU <= 0.0 then
            obj_mark_for_deletion(o)
            return
        end
    end

    local currentLength = o.oTongueU * distance

    o.oPosX, o.oPosY, o.oPosZ = baseX, baseY, baseZ
    o.oFaceAngleYaw = atan2s(dz, dx)
    o.oFaceAnglePitch = atan2s(_sqrt(dx*dx + dz*dz), dy) -- flip sign if it looks inverted

    o.header.gfx.scale.x = 1.0
    o.header.gfx.scale.y = 1.0
    o.header.gfx.scale.z = _max(currentLength, 0.001) / YOSHI_TONGUE_MODEL_LENGTH
end

id_bhvRender96YoshiTongue = r96lib.hook_behavior(nil, false, nil, bhv_yoshi_tongue, OBJ_LIST_DEFAULT)
