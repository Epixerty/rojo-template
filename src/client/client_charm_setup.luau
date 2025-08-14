local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)
local CharmSync = require(ReplicatedStorage.packages.charm_sync)
local Network = require(ReplicatedStorage.shared.network)

local module = {}

function module.init()
	local playerDataAtom = Charm.atom {
		ObjectsFavorited = {},
		ObjectsOwned = {},
		SpawnedObjects = 1,
	}

	local syncer = CharmSync.client {
		atoms = {
			PlayerData = playerDataAtom,
		},
		ignoreUnhydrated = true,
	}

	Network.PlayerSessionData.SyncAtom.OnClientEvent:Connect(function(...)
		syncer:sync(...)
	end)

	Charm.subscribe(playerDataAtom, function(state)
		print("state changed", state)
	end)

	Network.PlayerSessionData.RequestAtomData:FireServer()
end

return module
