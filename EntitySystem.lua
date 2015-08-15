local EntitySystem = class('EntitySystem')

function EntitySystem:initialize()
	self.entities= {}
	self.entitiesClassCount = {}
	self.entityUniqueId = 1
end

function EntitySystem:update(dt)
	for _,v in ipairs(self.entities) do
		v:update(dt)
	end
end

function EntitySystem:draw(type)
	type = type or "all"
	for _,v in ipairs(self.entities) do
		if 	type == "all" or v.type == type then
			v:draw()
		end
	end
end

function EntitySystem:print()
	for _,v in ipairs(self.entities) do	
		v:print()
	end
end

--get first class with the given classtype
function EntitySystem:get(classname)
	for _,v in ipairs(self.entities) do
		if v.class.name == classname then
			return v
		end
	end
	return nil
end

function EntitySystem:getLatestEntity()
	return self.entities[#self.entities]
end

function EntitySystem:add(entity)
	table.insert(self.entities, entity)
	entity.uniqueid = self.entityUniqueId
	self.entityUniqueId = self.entityUniqueId + 1
	self.entitiesClassCount[entity.class.name] = (self.entitiesClassCount[entity.class.name] or 0) + 1
end

--return all entities with the given classname, which makes it easy to iterate through all instances of a given entity class
function EntitySystem:iter(classname)
  local i = 1
  return function()
    while self.entities[i] do
      if self.entities[i].class.name == classname then 
        break
      else
        i = i+1
      end
    end
    
    if self.entities[i] then
      i = i+1
      return self.entities[i-1],i-1
    end
  end
end

--iterates all entityties
function EntitySystem:iterAll()
  local i = 1
  return function()
    if self.entities[i] then
      i = i+1
      return self.entities[i-1],i-1
    end
  end
end

function EntitySystem:remove(entity)
	self:removeEntityById(entity.uniqueid)
end

function EntitySystem:removeEntityById(id)
	for k,v in ipairs(self.entities) do
		if v.uniqueid == id then
			table.remove(self.entities, k)
			self.entitiesClassCount[v.class.name] = self.entitiesClassCount[v.class.name] - 1
		end
	end
end

function EntitySystem:getClassCount(classname)
	return self.entitiesClassCount[classname]
end

function EntitySystem:getNumEntities()
	return #self.entities
end

--sort entities based on the function supplied
function EntitySystem:sort(func)
	table.sort(self.entities, 
    	func
    )
end

function EntitySystem:mousepressed(x,y,k,type)
	type = type or "all"
	for i=#self.entities,1,-1 do
		local v = self.entities[i]
		if type == "all" or v.type == type then
			if not v.alpha or v.alpha and v.alpha > 0 then
				if v:mousepressed(x,y,k) then
					return v
				end
			end
		end
	end
end

--takes a love2d random number generator and then shuffles entities using it
function EntitySystem:shuffleEntities(RG)
	local function shuffle(array)
	    local n = #array
	    local j
	    for i=n+1, 1, -1 do
	        j = RG:random(i)

	        array[j],array[i] = array[i],array[j]
	    end
	    return array
	end

	shuffle(self.entities)
	shuffle(self.entities)
end


return EntitySystem