
-- TODO: milk

local MILK_DURATION = 30 * 30 -- 30 seconds

local sMilkAudioStream = nil

local function mario_milk_grow_or_shrink(mo, grow, shrink)
    mo.oMilkTimer = mo.oMilkTimer + 1
    if mo.oMilkTimer % 10 == 0 and mo.oMilkTimer / 10 < 9 then
        if math.floor(mo.oMilkTimer / 10) % 2 == 0 then
            mo.oMilkSize = mo.oMilkSize + grow
        else
            mo.oMilkSize = mo.oMilkSize - shrink
        end
    end
end

--- @param m MarioState
local function act_milk_grow(m)
    local mo = m.marioObj
    mario_milk_grow_or_shrink(mo, 1.5, 0.5)
    if mo.oMilkTimer > 90 then
        print("GOT MILK")
        mo.oMilkSize = 5
        if m.playerIndex == 0 then
            audio_stream_stop(audio_stream_load(AUDIO_R96_GOT_MILK_POWERUP))
            sMilkAudioStream = audio_stream_load(AUDIO_R96_GOT_MILK_SONG)
            audio_stream_set_loop_points(sMilkAudioStream, 0, 333353)
            audio_stream_set_looping(sMilkAudioStream, true)
            audio_stream_play(sMilkAudioStream, true, 2)
        end
        return set_mario_action(m, ACT_IDLE, 0)
    end
end

--- @param m MarioState
local function act_milk_shrink(m)
    local mo = m.marioObj
    mario_milk_grow_or_shrink(mo, 0.5, 1.5)
    if mo.oMilkTimer > 90 then
        print("GOT MILK DONE")
        mo.oMilkSize = 1
        mo.oMilkTimer = 0
        if m.playerIndex == 0 and sMilkAudioStream then
            audio_stream_set_looping(sMilkAudioStream, false)
            audio_stream_stop(sMilkAudioStream)
            sMilkAudioStream = nil
        end
        m.marioObj.hitboxRadius = 37
        m.marioObj.hitboxHeight = 160
        return set_mario_action(m, ACT_IDLE, 0)
    end
end

--- @param m MarioState
local function mario_update(m)
    local mo = m.marioObj

    if mo.oMilkTimer > 0 then
        local size = m.marioObj.header.gfx.scale
        size.x = mo.oMilkSize
        size.y = mo.oMilkSize
        size.z = mo.oMilkSize
        m.marioObj.hitboxRadius = 37 * mo.oMilkSize
        m.marioObj.hitboxHeight = 160 * mo.oMilkSize
    end

    if mo.oMilkSize == 5 then
         --if swimming - lower offset
        if m.action & ACT_FLAG_SWIMMING ~= 0 then m.marioObj.header.gfx.pos.y = m.marioObj.header.gfx.pos.y - 260 end
        if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_RUNNING then smlua_anim_util_set_animation(m.marioObj, CHAR_ANIM_R96_MARIO_MILK_RUNNING) end
    end

    -- if (m.controller.buttonPressed & U_JPAD) ~= 0 then --Getting Milk
    --     print("START GETTING MILK")
    --     set_mario_action(m, ACT_R96_MILK_GROW, 0)
    --     mo.oMilkTimer = 1
    --     audio_stream_play(audio_stream_load(AUDIO_R96_GOT_MILK_POWERUP), true, 2)
    -- end

    if m.action ~= ACT_R96_MILK_GROW and m.action ~= ACT_R96_MILK_SHRINK then
        mo.oMilkTimer = mo.oMilkTimer + 1
        if mo.oMilkTimer > MILK_DURATION then
            set_mario_action(m, ACT_R96_MILK_SHRINK, 0)
            mo.oMilkTimer = 1
        end
    end

    --print(m.pos.x ,m.pos.y, m.pos.z )

   -- if m.action == ACT_BACKFLIP_LAND then
   --     warp_to_level(LEVEL_FOURTH_FLOOR, 1, 0)
   -- end
end



hook_mario_action(ACT_R96_MILK_GROW, act_milk_grow)
hook_mario_action(ACT_R96_MILK_SHRINK, act_milk_shrink)

--hook_event(HOOK_MARIO_UPDATE, mario_update)