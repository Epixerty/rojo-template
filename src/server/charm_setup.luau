--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Profiles = require(ServerStorage.server_modules.profiles)
local Charm = require(ReplicatedStorage.packages.charm)
local CharmSync = require(ReplicatedStorage.packages.charm_sync)
local Network = require(ReplicatedStorage.shared.network)

local module = {}

type AtomData = {}

function module.init()
	local playersData: Charm.Atom<{ [Player]: AtomData }> = Charm.atom {}

	local syncer = CharmSync.server {
		atoms = {
			PlayerData = playersData,
		},
		autoSerialize = false,
	}

	syncer:connect(function(player, atoms)
		local data = table.clone(atoms.data)

		for name, atom: any in data do
			data[name] = atom[player]
		end

		Network.PlayerSessionData.SyncAtom:FireClient(player, data)
	end)

	Network.PlayerSessionData.RequestAtomData.OnServerEvent:Connect(function(player)
		syncer:hydrate(player)
	end)

	Profiles.Added:Connect(function(player, profile)
		local data: AtomData = {
			-- use any data from the profile,
			-- dont directly clone the profile because
			-- we only want some of the data to be state,
			-- and we might wanna add more temporary data
		}

		playersData(function(state)
			state = table.clone(state)
			state[player] = data
			return state
		end)
	end)

	Profiles.Removed:Connect(function(player)
		playersData(function(state)
			state = table.clone(state)
			state[player] = nil
			return state
		end)
	end)
end

return module
