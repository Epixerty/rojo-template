local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Vide = require(ReplicatedStorage.packages.vide)

local action = Vide.action
local apply = Vide.apply

return function(childName: string)
	return function(props: {})
		return action(function(parent)
			local child = parent:FindFirstChild(childName)
			if child then
				apply(child)(props)
			else
				warn("Child not found: " .. childName)
			end
		end)
	end
end