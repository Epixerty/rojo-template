local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local ProfileStore = require(ServerStorage.packages.profile_store)
local Profiles = require(ServerStorage.server_modules.profiles)

local playerStore = ProfileStore.New("PlayerData_Test", Profiles.PROFILE_TEMPLATE)

export type Profile = typeof(playerStore:StartSessionAsync())

local function playerAdded(player: Player)
	local profile = playerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile() -- add missing variables from template

		profile.OnSessionEnd:Connect(function()
			Profiles.Removed:Fire(player)

			Profiles.profiles[player] = nil
			player:Kick("Session ended - please rejoin")
		end)

		if player.Parent == Players then
			Profiles.profiles[player] = profile
			print(`profile loaded for {player.Name}`)

			Profiles.Added:Fire(player, profile)
		else
			profile:EndSession()
		end
	else
		player:Kick(`failed to load data - please rejoin`)
	end
end

local module = {}

function module.init()
	for _, player in Players:GetPlayers() do
		playerAdded(player)
	end

	Players.PlayerAdded:Connect(playerAdded)

	Players.PlayerRemoving:Connect(function(player)
		local profile = Profiles[player]

		if profile then
			profile:EndSession()
		end
	end)
end

return module
