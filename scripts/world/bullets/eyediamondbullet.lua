local EyeDiamondBullet, super = Class(WorldBullet)

function EyeDiamondBullet:init(x, y, angle, speed)
    super.init(self, x, y, "world/bullets/diamond_bullet")

	self:setScale(0.5)
    self.damage = 20

	self.physics.direction = angle
	self.rotation = angle
    self.physics.speed = speed
    self.physics.friction = -0.5

	self.removing = false
    self.start_x = x
    self.start_y = y
end

function EyeDiamondBullet:update()
    if (math.abs(self.x - self.start_x) >= self.world.map.tile_width * 9 or math.abs(self.y - self.start_y) >= self.world.map.tile_height * 9 or Game.world.battle_alpha < 0.5) and not self.removing then
		self.removing = true
        self:fadeOutSpeedAndRemove(0.25)
    end

    super.update(self)
end

return EyeDiamondBullet