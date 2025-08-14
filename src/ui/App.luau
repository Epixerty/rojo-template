--# selene: allow(mixed_table)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage.packages.vide)

local create = Vide.create

local function App()
	return create("Frame") {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}
end

return App
