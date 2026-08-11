-- name: Got Milk? Powerup
-- description: Adds a Milk Powerup

mSize = 1
mHitboxRadius = 37
mHitboxHeight = 160

local audioStream = nil
growStateCustom = {
    SHRINK = 0,
    GROW = 1
}

local milkFrame = 1
local milkTimer = 0
local walkTimer = 0
local milkGrowShrink = { 1, 0, 1, 0, 1, 0, 1, 0}

local function mario_growth(grow, shrink)
    milkTimer = milkTimer + 1
    if milkTimer % 10 == 0 and milkFrame ~= 9 then
        if milkGrowShrink[milkFrame] == 0 then mSize = mSize - shrink end
        if milkGrowShrink[milkFrame] == 1 then mSize = mSize + grow end
        milkFrame = milkFrame + 1
    end
end

--- @param m MarioState
local function act_milk_grow(m)
    mario_growth(1.5, 0.5)
   if milkFrame == 9 then
        audio_stream_stop(audio_stream_load(AUDIO_R96_GOT_MILK_POWERUP))
        print("GOT MILK")
        walkTimer = 0
        milkTimer = 0
        milkFrame = 1
        mSize = 5
        audioStream = audio_stream_load(AUDIO_R96_GOT_MILK_SONG)
        audio_stream_set_loop_points(audioStream, 0, 333353)
        audio_stream_set_looping(audioStream, true)
        audio_stream_play(audioStream, true, 2)
        mHitboxRadius = 185
        mHitboxHeight = 800
        m.marioObj.hitboxRadius = mHitboxRadius
        m.marioObj.hitboxHeight = mHitboxHeight
        return set_mario_action(m, ACT_IDLE, 0)
   end
end

--- @param m MarioState
local function act_milk_shrink(m)
    mario_growth(0.5, 1.5)
   if milkFrame == 9 then
        print("GOT MILK DONE")
        walkTimer = 0
        milkTimer = 0
        milkFrame = 1
        mSize = 1
        mHitboxRadius = 37
        mHitboxHeight = 160
        audio_stream_set_looping(audioStream, false)
        audio_stream_stop(audioStream)
        audioStream = nil
        m.marioObj.hitboxRadius = mHitboxRadius
        m.marioObj.hitboxHeight = mHitboxHeight
        return set_mario_action(m, ACT_IDLE, 0)
   end
end

--- @param m MarioState
local function mario_update(m)
    size = m.marioObj.header.gfx.scale

    if (mSize == 5) then 
        --if swimming - lower offset
       if m.action & ACT_FLAG_SWIMMING ~= 0 then m.marioObj.header.gfx.pos.y = m.marioObj.header.gfx.pos.y - 260 end
       if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_RUNNING then smlua_anim_util_set_animation(m.marioObj, CHAR_ANIM_R96_MARIO_MILK_RUNNING) end
    end

   -- if (m.controller.buttonPressed & U_JPAD) ~= 0 then --Getting Milk
   --     print("START GETTING MILK")
   --     set_mario_action(m, ACT_R96_MILK_GROW, 0)
   --     audio_stream_play(audio_stream_load(AUDIO_R96_GOT_MILK_POWERUP), true, 2)
   -- end

    if(audioStream ~= nil) then
        walkTimer = walkTimer + 1
        if (walkTimer > 0x1500) then
            set_mario_action(m, ACT_R96_MILK_SHRINK, 0)
        end
    end

    size.x = mSize
    size.y = mSize
    size.z = mSize
    m.marioObj.hitboxRadius = mHitboxRadius
    m.marioObj.hitboxHeight = mHitboxHeight
    --print(m.pos.x ,m.pos.y, m.pos.z )

   -- if m.action == ACT_BACKFLIP_LAND then
   --     warp_to_level(LEVEL_FOURTH_FLOOR, 1, 0)
   -- end
end



hook_mario_action(ACT_R96_MILK_GROW, act_milk_grow)
hook_mario_action(ACT_R96_MILK_SHRINK, act_milk_shrink)

--hook_event(HOOK_MARIO_UPDATE, mario_update)