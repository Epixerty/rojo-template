local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)
local CharmSync = require(ReplicatedStorage.packages.charm_sync)
local ClientPlayerAtoms = require(ReplicatedStorage.shared.client_player_atoms)
local Network = require(ReplicatedStorage.shared.network)

local module = {}

function module.init()
	local playerDataAtom = ClientPlayerAtoms.playersData

	local syncer = CharmSync.client {
		atoms = {
			PlayerData = playerDataAtom,
		},
		ignoreUnhydrated = true,
	}

	Network.PlayerSessionData.SyncAtom.OnClientEvent:Connect(function(...)
		syncer:sync(...)
	end)

	Network.PlayerSessionData.RequestAtomData:FireServer()
end

return module
