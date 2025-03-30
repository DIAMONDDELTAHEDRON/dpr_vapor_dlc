---@class NeonPalmTree : Event
---@overload fun(...) : NeonPalmTree
local NeonPalmTree, super = Class(Event)

function NeonPalmTree:init(data)
    super.init(self, data.x, data.y, data.w, data.h)
	
	local properties = data.properties or {}
	
    self:setSprite(data.properties["sprite"] or "world/maps/palm_tree")
    self:setOrigin(0.5, 1)

    self.angle = data.properties["angle"] or 0
    self.rotation = math.rad(self.angle)
	
    self.neoncolor = nil
    self.neonsiner = 0
end

function NeonPalmTree:update()
    super.update(self)
	
    self.neonsiner = self.neonsiner + DTMULT
    self.neoncolor = Utils.mergeColor(COLORS.aqua, COLORS.fuchsia , (0.25 + math.sin(self.neonsiner / 10)) * 2)
	
    self.sprite:setColor(self.neoncolor)
end

return NeonPalmTree
