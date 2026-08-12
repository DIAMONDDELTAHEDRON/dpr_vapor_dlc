local WaterSurface, super = Class(Event)

function WaterSurface:init(data)
    super.init(self, data)
	local properties = data.properties or {}
    self.shader = Assets.getShader("waterreflect")
	self.watercol = TiledUtils.parseColorProperty(properties["color"])
	self.auto_fade_disruption = properties["autofadedisrupt"] or false
	self.disruption_fade_spd = properties["disruptfadespd"] or 0.1
	self.disruption = 1
	self.time = 0
	self.spd = 1
end

function WaterSurface:update()
    super.update(self)
	self.time = self.time + (self.spd * self.disruption * 1.5) * DTMULT
	if self.auto_fade_disruption then
		self.disruption = MathUtils.approach(self.disruption, 1, self.disruption_fade_spd * DTMULT)
	end
end

function WaterSurface:drawReflection()
    local to_draw = {}
    local to_draw_events = {}
	love.graphics.push()
	love.graphics.translate(-self.x/2, -self.y/2)
    for _, obj in ipairs(Game.world.children) do
        if obj:includes(Event) then
            table.insert(to_draw_events, obj)
        end
        if obj:includes(Character) then
            table.insert(to_draw, obj)
        end
    end
    for _, obj in ipairs(to_draw_events) do
        if self.reflect then
            self:drawEvent(obj)
        end
    end
    for _, obj in ipairs(to_draw) do
        self:drawCharacter(obj)
    end
	love.graphics.pop()
end

function WaterSurface:drawCharacter(chara)
    love.graphics.push()
    chara:preDraw()
	local refl_off = 0
	if chara.reflection_offset then
		refl_off = chara.reflection_offset
	end
    love.graphics.translate(-chara.x/4 + chara.width/4, -chara.y/4 + chara.height*1.5 + refl_off/2)
	love.graphics.scale(0.5, -0.5)
    chara:draw()
    chara:postDraw()
    love.graphics.pop()
end

function WaterSurface:drawEvent(event)
    if event.sprite and event.reflection then
        love.graphics.push()
        event:preDraw()
		local refl_off = 0
		if event.reflection_offset then
			refl_off = event.reflection_offset
		end
		love.graphics.translate(-event.x/4 + event.width/4, -event.y/4 + event.height*1.5 + refl_off/2)
		love.graphics.scale(0.5, -0.5)
        event:draw()
        event:postDraw()
        love.graphics.pop()
    end
end

function WaterSurface:draw()
    super.draw(self)
	Draw.setColor(1,1,1,1)
	local water_canvas = Draw.pushCanvas(self.width / 2, self.height / 2)
	Draw.pushShader(self.shader)
	local tw, th = 1 / (self.width / 2), 1 / (self.height / 2)
	self.shader:send("timer", self.time)
	self.shader:send("texel", {tw, th})
	self.shader:send("frequency", math.max(0.3, 0.8 - (self.disruption * 5)))
	self.shader:send("amp", 2 * self.disruption)
	self.shader:sendColor("watercol", {self.watercol[1], self.watercol[2], self.watercol[3]})
	self:drawReflection()
	Draw.popShader()
	Draw.popCanvas()
	
    love.graphics.stencil(function()
		Draw.pushShader("Mask")
		if self.collider then
			self.collider:drawFill()
		else
			love.graphics.rectangle("fill", 0,0,self:getSize())
		end
		Draw.popShader()
	end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
	Draw.drawCanvas(water_canvas, 0, 0, 0, 2, 2)
    love.graphics.setStencilTest()
end

return WaterSurface