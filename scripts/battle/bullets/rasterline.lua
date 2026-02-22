local RasterLine, super = Class(Bullet)

function RasterLine:init(x, y, length)
    super.init(self, x, y)
	
	self:setScale(1)

	self.length = length
	self.line_w = 4
	self.collider = LineCollider(self, 0, 0, self.length, 0)
	self.destroy_on_hit = false
    self.tp = 0.4
	self.type = nil
end

function RasterLine:update()
    super.update(self)
	self.line_w = MathUtils.lerp(self.line_w, 0, 0.1 * DTMULT)
	self.alpha = self.line_w/4
	if self.alpha < 0.5 then
		self.collider.collidable = self.can_collide
	end
	if self.alpha <= 0.01 then
		self:remove()
	end
end

function RasterLine:canGraze()
	if self.type == "orange" then
		if Game.battle.soul:isMoving() then return false end
	elseif self.type == "blue" then
		if not Game.battle.soul:isMoving() then return false end
	end
    return self.can_graze
end

function RasterLine:onCollide(soul)
	if self.type == "orange" then
		if soul:isMoving() then return end
	elseif self.type == "blue" then
		if not soul:isMoving() then return end
	end
    if soul.inv_timer == 0 then
        self:onDamage(soul)
    end
    if self.destroy_on_hit then
        self:remove()
    end
end

function RasterLine:draw()
    super.draw(self)
	Draw.setColor(self:getDrawColor())
	love.graphics.setLineWidth(math.ceil(self.line_w))
	love.graphics.line(0, 0, self.length, 0)
	love.graphics.setLineWidth(1)
    if DEBUG_RENDER then
		if self.collider.collidable then
			self.collider:draw(0, 1, 0)
		else
			self.collider:draw(0, 0.5, 0)
		end
    end
end

return RasterLine