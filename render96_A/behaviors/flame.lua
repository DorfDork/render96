require("/constants")

local _sqrt = math.sqrt

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_flame_render96_init(o)
    o.oWallAngle = 0
    o.oWallX = 0
    o.oWallZ = 0
    for i = 0, 3 do
        local ray = collision_find_surface_on_ray(o.oPosX, o.oPosY, o.oPosZ, sins(i*0x4000)*500, 0, coss(i*0x4000)*500, 128)
        local dist = _sqrt((ray.hitPos.x - o.oPosX)^2 + (ray.hitPos.z - o.oPosZ)^2)
        local nDist = _sqrt((o.oWallX - o.oPosX)^2 + (o.oWallZ - o.oPosZ)^2)
        if dist < nDist and ray.surface then
            o.oWallX = ray.hitPos.x
            o.oWallZ = ray.hitPos.z
            o.oWallAngle = atan2s(ray.surface.normal.z, ray.surface.normal.x)
        end
    end
end

---@param o Object
local function bhv_flame_render96_loop(o)
    if o.oTimer < 2 and (obj_has_model_extended(o, E_MODEL_R96_RED_FLAME_TORCH) == 1 or obj_has_model_extended(o, E_MODEL_R96_BLUE_FLAME_TORCH) == 1) then
        o.oPosX = o.oWallX
        o.oPosZ = o.oWallZ
        o.oFaceAngleYaw = o.oWallAngle
        o.oMoveAngleYaw = o.oWallAngle
    end
end

id_bhvRender96Flame = hook_render96_behavior(id_bhvFlame, false, bhv_flame_render96_init, bhv_flame_render96_loop)
