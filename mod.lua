function Mod:init()
    print("Loaded "..self.info.name.."!")
end

function Mod:postInit()
    Game.stage:addFX(VHSFilterFX(), "vhs")
end

function Mod:onFootstep(char, num)
    if Game.world.map.use_footstep_sounds and char == Game.world.player then
        if num == 1 then
            Assets.playSound("step1")
        elseif num == 2 then
            Assets.playSound("step2")
        end
    end
end