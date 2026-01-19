local NoiseFX, super = Class(Object)

function NoiseFX:init()
    super.init(self, 0, 0)
    self.noise_overlay = Assets.newVideo("vhsnoise", false)
end

function NoiseFX:onAdd(parent)
    super.onAdd(self,parent)
    self:setLayer(WORLD_LAYERS["below_ui"])
    self:setParallax(0)
    self.noise_overlay:play()
end

function NoiseFX:onRemoveFromStage(stage)
    super.onRemoveFromStage(self, stage)

    if self.noise_overlay:isPlaying() then
        self.noise_overlay:pause()
    end
end

function NoiseFX:update()
    if not self.noise_overlay:isPlaying() then
        self.noise_overlay:rewind()
        self.noise_overlay:play()
    end
end

function NoiseFX:draw()
	love.graphics.setBlendMode("add")
    Draw.draw(self.noise_overlay, 0, 0, 0, 1, 1)
	love.graphics.setBlendMode("alpha")
	
	super.draw(self)
end

return NoiseFX