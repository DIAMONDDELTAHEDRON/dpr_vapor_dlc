local RasterSweep, super = Class(Wave)

function RasterSweep:init()
    super.init(self)
    self.time = 11
	
	self.lines = {}
	self.amt = 0
	self.rasterwarntimer = 0
	self.rasterwarn = false
	self.rasterbeamtimer = 0
	self.rasterbeam = false
	self.raster_width = 1
	self.raster_height = 1
	self.line_shake_timer = 0
	self.line_repeat_count = 0
	self.frames = 6
	self.current_raster = 1
	self.raster_types = {
		"blue",
		"orange",
		nil,
		"orange",
		"blue",
		nil
	}
	self.raster_color = {
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	self.raster_followplayer = {
		true,
		false,
		false,
		true,
		false,
		false
	}
	self.raster_wraptex = {
		nil,
		nil,
		nil,
		{true, true},
		nil,
		nil
	}
end

function RasterSweep:onStart()
    self.timer:script(function(wait)
		wait(0.5)
		while Game.battle.wave_timer < Game.battle.wave_length - 29/30 do
			self.rasterbeam = false
			self:rasterizeTexture("battle/bullets/raster_"..(self.amt%self.frames)+1, self.amt%2)
			Assets.playSound("raster_warning")
			self.rasterwarntimer = 0
			self.rasterwarn = true
			wait(0.75)
			self.current_raster = (self.amt%self.frames)+1
			Assets.playSound("raster_beam")
			Assets.playSound("mantle_dash_slow", 0.8, 1.2)
			self.rasterbeamtimer = 0
			self.rasterbeam = true
			wait(0.75)
			self.amt = self.amt + 1
		end
    end)
end

function RasterSweep:update()
    super.update(self)
	if self.rasterwarn then
		self.rasterwarntimer = MathUtils.approach(self.rasterwarntimer, self.raster_height, 8 * DTMULT)
	end
	if self.rasterbeam then
		self.line_repeat_count = 4
		self.rasterbeamtimer = MathUtils.approach(self.rasterbeamtimer, self.raster_height + 6, 8 * DTMULT)
	end
end

function RasterSweep:draw()
    super.draw(self)
	local xx, yy = 0, 0
	if Game.battle.arena then
		xx, yy = Game.battle.arena.left, Game.battle.arena.top + 1
	end
	if self.rasterwarn then
		self.line_shake_timer = self.line_shake_timer + DTMULT
		for _, line in ipairs(self.lines) do
			if self.rasterwarntimer > line.y then
				Draw.setColor(line.col[1], line.col[2], line.col[3], math.min((line.col[4]) * line.alpha, 0.5))
				line.alpha = line.alpha - 0.05 * DTMULT
				love.graphics.setLineWidth(1)
				if self.line_shake_timer >= 2 then
					if line.shake == 1 then
						line.shake = 0
					else
						line.shake = 1
					end
				end
				love.graphics.line(xx + line.x - 1, yy + line.y * 2 + line.shake, xx + line.x + line.len + 1, yy + line.y * 2 + line.shake)
			end
		end
		if self.line_shake_timer >= 2 then
			self.line_shake_timer = self.line_shake_timer - 2
		end
	end
	if self.rasterbeam then
		local col = self.raster_color[self.current_raster] or nil
		if not col then
			col = COLORS.white
			if self.raster_types[self.current_raster] == "orange" then
				col = COLORS.orange
			end
			if self.raster_types[self.current_raster] == "blue" then
				col = ColorUtils.hexToRGB("#14A9FF")
			end
		end
		if self.rasterbeamtimer < self.raster_height + 6 then
			Draw.setColor(col[1],col[2],col[3],0.0625)
			love.graphics.setLineWidth(1)
			love.graphics.line(xx - 1, yy + (self.rasterbeamtimer - 6) * 2, xx + self.raster_width*2 + 1, yy + (self.rasterbeamtimer - 6) * 2)
		end		
		if self.rasterbeamtimer < self.raster_height + 3 then
			Draw.setColor(col[1],col[2],col[3],0.125)
			love.graphics.setLineWidth(2)
			love.graphics.line(xx - 1, yy + (self.rasterbeamtimer - 3) * 2, xx + self.raster_width*2 + 1, yy + (self.rasterbeamtimer - 3) * 2)
		end
		if self.rasterbeamtimer < self.raster_height then
			Draw.setColor(col[1],col[2],col[3],0.25)
			love.graphics.setLineWidth(3)
			love.graphics.line(xx - 1, yy + self.rasterbeamtimer * 2, xx + self.raster_width*2 + 1, yy + self.rasterbeamtimer * 2)
		end
		for i, line in ipairs(self.lines) do
			if self.rasterbeamtimer > line.y then
				if line.col[4] > 0 and not line.spent then
					local lineb = self:spawnBullet("rasterline", xx + line.x - 1, yy + line.y * 2, line.len + 1)
					lineb:setColor(line.col)
					lineb.type = self.raster_types[self.current_raster]
					for i = 0, self.line_repeat_count do
						lineb.line_w = MathUtils.lerp(lineb.line_w, 0, 0.0325 * DTMULT)
					end
					self.line_repeat_count = MathUtils.approach(self.line_repeat_count, 0, 1)
					line.spent = true
				end
			end
		end
	end
end

function RasterSweep:rasterizeTexture(texture, interlace)
    if type(texture) == "string" then
        texture = Assets.getTexture(texture) or (Assets.getFrames(texture)[1])
    end
    self.raster_width, self.raster_height = texture:getWidth(), texture:getHeight()
    local interlace = interlace or 0
	
	local canvas = Draw.pushCanvas(self.raster_width, self.raster_height)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 1, 1, 1)
	local tx, ty = 0, 0
	if self.raster_followplayer[(self.amt%self.frames)+1] then
		tx = (Game.battle.soul.x - Game.battle.arena.x) / 2
		ty = (Game.battle.soul.y - Game.battle.arena.y) / 2
	end
	if self.raster_wraptex[(self.amt%self.frames)+1] then
		Draw.drawWrapped(texture, self.raster_wraptex[(self.amt%self.frames)+1][1] or false, self.raster_wraptex[(self.amt%self.frames)+1][1] or false, tx, ty)
	else
		Draw.draw(texture, tx, ty)
	end
    Draw.popCanvas(true)
    
    local data = canvas:newImageData()
    self.lines = {}
	local lineshake = 0
	for y = 1, self.raster_height do
		if y % 2 == interlace then
			local last_x = 0
			local xx = 0
			local last_r = -1
			local last_g = -1
			local last_b = -1
			local last_a = -1
			local first = false
			if lineshake == 1 then
				lineshake = 0
			else
				lineshake = 1
			end
			for x = 1, self.raster_width do
				local r, g, b, a = data:getPixel(x-1, y-1)
				if r ~= last_r or g ~= last_g or b ~= last_b or a ~= last_a or first then
					xx = xx + (x - last_x) * 2
					last_x = x
					last_r = r
					last_g = g
					last_b = b
					last_a = a
					for xadd = x, self.raster_width do
						rr, gg, bb, aa = data:getPixel(xadd-1, y-1)
						x = xadd
						if rr ~= last_r or gg ~= last_g or bb ~= last_b or aa ~= last_a then
							break
						end
					end
					local length = x - last_x - 1
					table.insert(self.lines, {x = xx, y = y - 1, len = length * 2, col = {r, g, b, a}, shake = lineshake, alpha = 0.8, line_w = 5, spent = false})
					xx = xx + length * 2
					last_x = x - 1
					first = false
				end
			end
		end
	end
end

return RasterSweep