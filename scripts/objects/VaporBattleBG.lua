local VaporBattleBG, super = Class(Object)

function VaporBattleBG:init()
    super.init(self)

	self.offset = 0
	self.offset_2 = 0
	self.city_offset = 0
    self.fade = 0
    self.speed = 2
	self.layer = BATTLE_LAYERS["bottom"]
	self.shader = Assets.getShader("ntsc")
	self.city_tex = Assets.getTexture("battle/background/city_outline")
    self.neonsiner = 0
end

function VaporBattleBG:update()
    super.update(self)
    self.fade = Game.battle.transition_timer / 10
	self.offset = self.offset + self.speed*DTMULT

    if self.offset >= 200 then
        self.offset = self.offset - 200
    end
    if self.offset < 0 then
        self.offset = self.offset + 200
    end
	self.offset_2 = self.offset_2 - (self.speed/2)*DTMULT

    if self.offset_2 <= -200 then
        self.offset_2 = self.offset_2 + 200
    end
    if self.offset_2 > 0 then
        self.offset_2 = self.offset_2 - 200
    end
	self.city_offset = self.city_offset + (self.speed/4)*DTMULT

    if self.city_offset > 320 then
        self.city_offset = self.city_offset - 320
    end
    self.neonsiner = self.neonsiner + DTMULT
end

function VaporBattleBG:draw()
    super.draw(self)
    local party_hp_status = 0
    if not Kristal.Config["simplifyVFX"] then
        for _,party in ipairs(Game.party) do
            local current_health = party:getHealth()
            local max_health = party:getStat("health")
            party_hp_status = party_hp_status + (current_health/max_health)
        end
        party_hp_status = MathUtils.clamp(1 - party_hp_status / #Game.party, 0, 1)
    end
    for key, value in pairs({
        time = Kristal.getTime(),
        degradation = party_hp_status,
        random = MathUtils.random(0.0, 1.0),
        grain_tex = Assets.getTexture("shaders/ntsc_grain"),
        lines_tex = Assets.getTexture("shaders/ntsc_lines")
    }) do
        self.shader:send(key, value)
    end
	local bg_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setColor(0,0,0,0)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)
	
	local xsep = 100
	local imax = 8
	for j = -18, 18 do
		local topx = 314 + (((j * xsep) + self.offset_2) * 0.5)
		local botx = 314 + ((j * xsep) + self.offset_2)
		local topx2 = 314 + ((((j + 1) * xsep) + self.offset_2) * 0.5)
		local botx2 = 314 + (((j + 1) * xsep) + self.offset_2)
		local topy = 106
		local boty = SCREEN_HEIGHT + 6
		for i = 0, imax do
			if (i % 2 == 0 and j % 2 == 1) or (i % 2 == 1 and j % 2 == 0) then
				love.graphics.setColor(0,0.5,0.5,1)
			else
				love.graphics.setColor(0.5,0,0.5,1)
			end
			local topval = Utils.ease(0, 1, i/imax, "in-quad")
			local botval = Utils.ease(0, 1, (i+1)/imax, "in-quad")
			love.graphics.line(MathUtils.lerp(topx, botx, topval), MathUtils.lerp(topy, boty, topval), MathUtils.lerp(topx, botx, botval), MathUtils.lerp(topy, boty, botval))
			love.graphics.line(MathUtils.lerp(topx, botx, topval), MathUtils.lerp(topy, boty, topval), MathUtils.lerp(topx2, botx2, topval), MathUtils.lerp(topy, boty, topval))
		end
		topx = 314 + (((j * xsep) + self.offset) * 0.5)
		botx = 314 + ((j * xsep) + self.offset)
		topx2 = 314 + ((((j + 1) * xsep) + self.offset) * 0.5)
		botx2 = 314 + (((j + 1) * xsep) + self.offset)
		topy = 100
		boty = SCREEN_HEIGHT
		for i = 0, imax do
			if (i % 2 == 0 and j % 2 == 1) or (i % 2 == 1 and j % 2 == 0) then
				love.graphics.setColor(0,1,1,1)
			else
				love.graphics.setColor(1,0,1,1)
			end
			local topval = Utils.ease(0, 1, i/imax, "in-quad")
			local botval = Utils.ease(0, 1, (i+1)/imax, "in-quad")
			love.graphics.line(MathUtils.lerp(topx, botx, topval), MathUtils.lerp(topy, boty, topval), MathUtils.lerp(topx, botx, botval), MathUtils.lerp(topy, boty, botval))
			love.graphics.line(MathUtils.lerp(topx, botx, topval), MathUtils.lerp(topy, boty, topval), MathUtils.lerp(topx2, botx2, topval), MathUtils.lerp(topy, boty, topval))
		end
    end
	Draw.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", -20, -20, SCREEN_WIDTH + 40, 105 - 50)
	Draw.setColor(ColorUtils.mergeColor(COLORS.aqua, COLORS.fuchsia, MathUtils.clamp((0.25 + math.sin(self.neonsiner / 10)) * 2, 0, 1)))
	Draw.drawWrapped(self.city_tex, true, false, self.city_offset, 105 - 50)
	Draw.setColor(0, 0, 0, Game.battle.background_fade_alpha)
    love.graphics.rectangle("fill", -20, -20, SCREEN_WIDTH + 40, SCREEN_HEIGHT + 40)
	Draw.popCanvas()
	local last_shader = love.graphics.getShader()
	love.graphics.setShader(self.shader)
    love.graphics.setColor(1,1,1,self.fade)
	Draw.draw(bg_canvas)
    love.graphics.setColor(1,1,1,1)
	love.graphics.setShader(last_shader)
end

return VaporBattleBG