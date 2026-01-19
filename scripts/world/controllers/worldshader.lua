local WorldShader, super = Class(Event)

function WorldShader:init(data,...)
    super.init(self,data,...)
    self.shader = Assets.newShader(data.properties.shader)
    ---@type table<string, Class[]>
    local class_lists = {
        map_objects = {TileLayer, Event, NPC},
        vapor_land = {
            TileLayer,
            TileObject,
            NPC,
            DarkMenu,
            Textbox,
            HealthBar,
        },
        everything = {World},
    }
    class_lists.default = class_lists.everything
    self.classes = class_lists[data.properties.class_set or "default"]
    self.shaded = {}
	self.noisefx = nil
end

function WorldShader:onMapDone()
    ---@type Object[]
    self:setLayer(-10000)
    -- sanity check
    for keya, class_a in ipairs(self.classes) do
        for keyb, class_b in ipairs(self.classes) do
            assert(keya == keyb or not class_a:includes(class_b), string.format(
                "%s is listed even though it includes %s", Utils.dump(class_a), Utils.dump(class_b)
            ))
        end
    end
    for _, class in ipairs(self.classes) do
        for index, value in ipairs(Game.world.stage:getObjects(class)) do
            value:addFX(ShaderFX(self.shader), "worldshader_added")
            table.insert(self.shaded, value)
        end
    end
	self.noisefx = NoiseFX()
	Game.world:addChild(self.noisefx)
    self.done = true
end

-- called by hook
function WorldShader:onAddSibling(obj)
    if not self.done then return end
    for _, class in ipairs(self.classes) do
        if obj:includes(class) and not obj:getFX("worldshader_added") then
            obj:addFX(ShaderFX(self.shader), "worldshader_added")
            table.insert(self.shaded, obj)
            break
        end
    end
end

function WorldShader:onRemove(parent)
    for index, value in ipairs(self.shaded) do
        value:removeFX("worldshader_added")
    end
	if self.noisefx then
		self.noisefx:remove()
	end
end
local function sin01(x)
    return (math.sin(x) + 1)/2
end

-- veeeeeery minor optimization compared to overriding draw
function WorldShader:fullDraw()
	local party_hp_status = 0
	if not Kristal.Config["simplifyVFX"] then
		for _,party in ipairs(Game.party) do
			local current_health = party:getHealth()
			local max_health = party:getStat("health")
			party_hp_status = party_hp_status + (current_health/max_health)
		end
		party_hp_status = Utils.clamp(1 - party_hp_status / #Game.party, 0, 1)
	end
    for key, value in pairs({
		time = Kristal.getTime(),
		degradation = party_hp_status,
		random = Utils.random(0.0, 1.0),
		grain_tex = Assets.getTexture("shaders/ntsc_grain"),
		lines_tex = Assets.getTexture("shaders/ntsc_lines")
    }) do
        self.shader:send(key, value)
    end
end

function WorldShader:onAdd(parent)
    super.onAdd(self,parent)
    Game.world.timer:after(0, function ()
        self:onMapDone()
    end)
end

return WorldShader