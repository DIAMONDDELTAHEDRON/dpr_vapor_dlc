---@class Map.hell_1 : Map
local map, super = Class(Map, "intro/slides_1")

function map:init(world, data)
    super.init(self, world, data)
end

function map:onEnter()
	self.ripple_fx = Ch5RippleEffect()
	self.ripple_fx.layer = self.layers["objects_ripple"] + 0.001
	Game.world:addChild(self.ripple_fx)
end


---@param char Player
function map:onFootstep(char, num)
	local make_steps, water_surface = false, nil
	for _,watersurf in ipairs(self:getEvents("watersurface")) do
		if char:collidesWith(watersurf.collider) then
			make_steps = true
			water_surface = watersurf
		end
	end
	if make_steps and not self.world.player:isSliding() then
		Assets.playSound("splash", 0.1, MathUtils.random(1.6, 1.8))
		local x, y = char.x, char.y
		local px, py = 0, 0
		if char.is_player then
			px = Game.world.player.moving_x * Game.world.player:getCurrentSpeed(running)
			py = Game.world.player.moving_y * Game.world.player:getCurrentSpeed(running)
			if Game.world.player.last_collided_x then px = 0 end
			if Game.world.player.last_collided_y then py = 0 end
		else
			px = char.x - char.last_x
			py = char.y - char.last_y
		end
		if water_surface then
			water_surface.disruption = 2
		end
		self.ripple_fx:makeRipple(x, y, 34, COLORS.white, 100, 10, 6, 1999000, px * 0.5, py * 0.5, 0, nil, 2, "add")
	end
end

return map
