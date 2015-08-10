local Component = class('Component')

function Component:initialize(owner)
	self.owner = owner
	self.uniqueid = 0
end

function Component:update(dt)

end

function Component:draw()

end

function Component:print()
	
end

return Component