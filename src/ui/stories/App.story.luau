local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage.packages.vide)

local App = require(ReplicatedStorage.ui.App)
local usePx = require(ReplicatedStorage.ui.utils.px)

local story = {
	vide = Vide,
	story = function(props)
		usePx.mount()

		return App()
	end,
}

return story
