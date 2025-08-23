--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local PlayerAtoms = require(ServerStorage.server_modules.player_atoms)
local Profiles = require(ServerStorage.server_modules.profiles)
local Charm = require(ReplicatedStorage.packages.charm)
local CharmSync = require(ReplicatedStorage.packages.charm_sync)
local AtomTypes = require(ReplicatedStorage.shared.atom_types)
local Network = require(ReplicatedStorage.shared.network)

local module = {}

function module.init()
	local syncer = CharmSync.server {
		atoms = {
			PlayerData = PlayerAtoms.playersData,
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
		local data: AtomTypes.PlayersDataAtom = {}

		for _, atom in PlayerAtoms :: { Charm.Atom<any> } do
			if not Charm.isAtom(atom) then
				continue
			end

			atom(function(state)
				state = table.clone(state)
				state[player] = data
				return state
			end)
		end
	end)

	Profiles.Removed:Connect(function(player)
		if not Charm.isAtom(atom) then
			continue
		end

		for _, atom in PlayerAtoms :: { Charm.Atom<any> } do
			atom(function(state)
				state = table.clone(state)
				state[player] = nil
				return state
			end)
		end
	end)
end

return module
