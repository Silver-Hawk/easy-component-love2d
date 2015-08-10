local Entity = class('Entity')

function Entity:initialize()
	self.components = {}
	self.attr = {}
	--a type can be used to label an entity
	self.type = "general"
	--this id will be set by the entity controller
	self.uniqueid = 0
	self.componentUniqueId = 0
end

function Entity:setType(type)
	self.type = type
end

function Entity:addComponent(component)
	table.insert(self.components, component)
	component.uniqueid = self.componentUniqueId
	self.componentUniqueId = self.componentUniqueId + 1
end

function Entity:removeComponent(component)
	self:removeComponentById(component.uniqueid)
end

function Entity:removeComponentById(id)
	for k,v in ipairs(self.components) do
		if v.uniqueid == id then
			table.remove(self.components, k)
		end
	end
end

function Entity:getComponent(name)
	for _,v in pairs(self.components) do
		if v.name == name then
			return v
		end
	end

	return nil
end

function Entity:update(dt)
	for _,v in pairs(self.components) do
		v:update(dt)
	end
end

function Entity:draw()
	for _,v in pairs(self.components) do
		v:draw()
	end
end

function Entity:printComponents()
	for _,v in pairs(self.components) do
		v:print()
	end
end

function Entity:sortComponents(func)
	table.sort(self.components, func)
end

function Entity:mousepressed(x,y,key)

end

return Entity