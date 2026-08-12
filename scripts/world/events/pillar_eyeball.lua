---@class PillarEyeball : Event
---@overload fun(...) : PillarEyeball
local PillarEyeball, super = Class(Event)

function PillarEyeball:init(data)
    super.init(self, data.x, data.y, data.w, data.h)
	
	local properties = data.properties or {}
	
	self.eye_idle_angle = properties["idleangle"] or 90
	self.eye_attack_angle = properties["attackangle"] or 90
	self.eye_sweep_angle = properties["sweepangle"] or 90
	self.eye_attack_mode = properties["attackmode"] or "simple"
	self.eye_attack_count = properties["attackcount"] or 5
	self:setOrigin(0.5, 1)
	self:setSprite("world/maps/pillar_eyeball")
	self.mask_tex = Assets.getTexture("world/maps/pillar_eyeball_mask")
	self.pupil_tex = Assets.getTexture("world/maps/pillar_eyeball_pupil")
	self.eye_x = 0
	self.eye_y = 0
	self.eye_timer = MathUtils.randomInt(0, 8) - MathUtils.randomInt(0, 8)
	self.eye_target_x = 0
	self.eye_target_y = 0
    self.eye_target_set = false
	self.eye_locked = false
	self.eye_attacking = false
	self.can_attack = properties["attack"] ~= false
	self.attack_timer = 0	
    self.starting_attack_timer = properties["starttime"] or 0
    self.max_attack_timer = properties["maxtime"] or 45
    self.siner = MathUtils.random(0, 360)
	self.eye_angle = 0
	self.eye_dist = 0
	self.attack_script = nil
end

function PillarEyeball:update()
    super.update(self)
	
	local cx, cy = Game.world.camera.x, Game.world.camera.y
	
    self.siner = self.siner + DTMULT
	self.sprite.x = (math.cos(self.siner/12)*1.5)
	self.sprite.y = -10 + (math.sin(self.siner/8)*2)
	
    self.eye_timer = self.eye_timer + DTMULT
	local player = self.world and self.world.player or nil
	if self.world:inBattle() and self.can_attack and player then
		local eyeball_x, eyeball_y = self:getRelativePos(self.width/2 + self.sprite.x, self.height/2 + self.sprite.y)
		local soul_x, soul_y = player:getRelativePos(player:getSoulOffset())
		if not self.eye_locked then
			if self.eye_attack_mode == "tracking" or self.eye_attack_mode == "tracking_sweep" then
				self.eye_angle = MathUtils.angle(eyeball_x, eyeball_y, soul_x, soul_y)
				self.last_eye_angle = self.eye_angle
				self.eye_dist = MathUtils.clamp(MathUtils.dist(eyeball_x, eyeball_y, soul_x, soul_y)/40, 0, 8)
			else
				self.eye_angle = math.rad(self.eye_attack_angle)
				self.eye_dist = 8
			end
		elseif not self.eye_attacking then
			if self.eye_attack_mode == "tracking_sweep" then
				self.eye_angle = self.last_eye_angle - math.rad(self.eye_sweep_angle)
			elseif self.eye_attack_mode == "sweeping" then
				self.eye_angle = math.rad(self.eye_attack_angle - self.eye_sweep_angle)
			end
		end
		self.eye_target_x = math.cos(self.eye_angle) * self.eye_dist
		self.eye_target_y = math.sin(self.eye_angle) * self.eye_dist
		self.eye_target_set = true
		self.eye_timer = 90
		local in_view = true
		if self.x < cx - SCREEN_WIDTH/2 or self.x > cx + SCREEN_WIDTH/2 or self.y < cy - SCREEN_HEIGHT/2 or self.y > cy + SCREEN_HEIGHT/2 then
			in_view = false
		end
		self.attack_timer = self.attack_timer + DTMULT
		if self.attack_timer > self.max_attack_timer then
			self.attack_timer = 0
			if in_view then
				self.attack_script = self.world.timer:script(function(wait)					
					self:flash()
					if self.world:inBattle() then
						Assets.stopAndPlaySound("bell_bounce_short", 0.8)
					end
					self.eye_locked = true
					wait(10/30)
					local pitch = 1.25
					self.eye_attacking = true
					for i = 1, self.eye_attack_count do
						if self.world:inBattle() then
							Assets.stopAndPlaySound("hurt", 0.8, pitch)
						end
						local bullet_angle, bullet_x, bullet_y = self.eye_angle, self:getRelativePos(self.width/2 + self.eye_x + self.sprite.x, self.height/2 + self.eye_y + self.sprite.y)
						self.world:spawnBullet("eyediamondbullet", bullet_x, bullet_y, bullet_angle, 4)
						pitch = pitch + 0.05
						wait(2/30)
						if self.eye_attack_mode == "sweeping" or self.eye_attack_mode == "tracking_sweep" then
							self.eye_angle = self.eye_angle + math.rad(self.eye_sweep_angle/(self.eye_attack_count/2))
							self.eye_target_x = math.cos(self.eye_angle) * self.eye_dist
							self.eye_target_y = math.sin(self.eye_angle) * self.eye_dist
						end
						wait(3/30)
					end
					wait(1/30)
					self.eye_locked = false
					self.eye_attacking = false
				end)
			end
		end
	else
		if self.attack_script ~= nil then
			self.world.timer:cancel(self.attack_script)
		end
		self.eye_locked = false
		self.eye_attacking = false
		self.attack_timer = self.starting_attack_timer
		if self.eye_timer > 30 and not self.eye_target_set then
			local eye_angle = self.eye_idle_angle - 40 + MathUtils.randomInt(0, 80)
			self.eye_target_x = math.cos(math.rad(eye_angle)) * 6
			self.eye_target_y = math.sin(math.rad(eye_angle)) * 6
			self.eye_target_set = true
		end
		if self.eye_timer > 90 then
			self.eye_target_set = false
			self.eye_timer = MathUtils.randomInt(0, 8) - MathUtils.randomInt(0, 8)
			self.eye_target_x = 0
			self.eye_target_y = 0
		end
	end
	if self.eye_attacking then
		self.eye_x = MathUtils.lerp(self.eye_x, self.eye_target_x, 1 - (1 - 0.5) ^ DTMULT)
		self.eye_y = MathUtils.lerp(self.eye_y, self.eye_target_y, 1 - (1 - 0.5) ^ DTMULT)
	else
		self.eye_x = MathUtils.lerp(self.eye_x, self.eye_target_x, 1 - (1 - 0.2) ^ DTMULT)
		self.eye_y = MathUtils.lerp(self.eye_y, self.eye_target_y, 1 - (1 - 0.2) ^ DTMULT)
	end
end

function PillarEyeball:draw()
	love.graphics.push()
	love.graphics.origin()
	Draw.setColor(ColorUtils.hexToRGB("#6a7bc4"))
	local cx, cy = Game.world.camera.x - SCREEN_WIDTH/2, Game.world.camera.y - SCREEN_HEIGHT/2
	local shadow_width = 16+(math.sin(self.siner/8))*2
	love.graphics.ellipse("fill", self.x + self.sprite.x - cx, self.y - 3 - cy, shadow_width, 6)
	Draw.setColor(COLORS.white)
	love.graphics.pop()
    super.draw(self)
	love.graphics.stencil(function()
		Draw.pushShader("Mask")
		Draw.draw(self.mask_tex, self.sprite.x, self.sprite.y, 0, 2, 2, 0, 0)
		Draw.popShader()
	end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	Draw.draw(self.pupil_tex, self.eye_x + self.sprite.x, self.eye_y + self.sprite.y, 0, 2, 2, 10, 10)
	love.graphics.setStencilTest()
end

return PillarEyeball