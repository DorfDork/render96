-- By EmeraldLockdown
--if true then return end
local sInsideWater = false

local function on_post_process_vertex_shader_create()
    return [[
in vec4 aVtxPos;
in vec2 aTexCoord;

out vec4 vVtxPos;
out vec2 vTexCoord;

void main() {
    vVtxPos = aVtxPos;
    vTexCoord = aTexCoord;
    gl_Position = aVtxPos;
}
    ]]
end


local function on_post_process_fragment_shader_create()
    return [[
#version 410 core
out vec4 fragColor;

in vec4 vVtxPos;
in vec2 vTexCoord;

uniform sampler2D uPassTex;
uniform uint uFrameCount;
uniform bool sInsideWater;

void main() {
    vec2 uv = vTexCoord;

    float time = uFrameCount / 60.0f;

    float waveX =
        sin(uv.y * 25.0 + time * 0.9) * 0.0015 +
        sin(uv.y * 60.0 - time * 1.2) * 0.0008;

    float waveY =
        sin(uv.x * 22.0 - time * 0.8) * 0.0015 +
        sin(uv.x * 55.0 + time * 1.1) * 0.0008;

    uv.x += waveX;
    uv.y += waveY;

    // Slight radial distortion.
    vec2 center = vec2(0.5);
    vec2 offset = uv - center;

    float dist = length(offset);

    uv += offset * sin(dist * 15.0) * 0.004;

    // Keep UVs inside the screen.
    uv = clamp(uv, 0.001, 0.999);

    vec4 color = texture(uPassTex, uv);

    // Underwater color absorption.
    color.r *= 0.59;
    color.g *= 0.83;
    color.b *= 1.12;

    // Add subtle underwater blue-green fog.
    vec3 waterTint = vec3(0.02, 0.16, 0.20);
    color.rgb = mix(color.rgb, color.rgb + waterTint, 0.18);

    if (!sInsideWater) {
        color = texture(uPassTex, vTexCoord);
    }

    fragColor = color;
}
    ]]
end

local function on_set_shader_program()
    gfx_shader_set_bool("sInsideWater", sInsideWater)
end

---@param m MarioState
local function mario_update(m)
    if m.playerIndex ~= 0 then return end

    if gLakituState.curPos.y <= m.waterLevel then
        sInsideWater = true
    else
        sInsideWater = false
    end
end

hook_event(HOOK_ON_POST_PROCESS_VERTEX_SHADER_CREATE, on_post_process_vertex_shader_create)
hook_event(HOOK_ON_POST_PROCESS_FRAGMENT_SHADER_CREATE, on_post_process_fragment_shader_create)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SET_SHADER_PROGRAM, on_set_shader_program)

gfx_reload_shaders()