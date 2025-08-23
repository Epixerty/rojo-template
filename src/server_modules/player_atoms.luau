local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)
local AtomTypes = require(ReplicatedStorage.shared.atom_types)

type Atom<T> = Charm.Atom<T>
type ServerAtom<T> = Atom<{ [Player]: T }>

local function getPlayerData<T>(player: Player, atom: ServerAtom<T>): T
	return atom()[player]
end

return {
	UpdatePlayerAtom = function(player: Player, atom: Charm.Atom<any>, value: any)
		atom(function(state)
			state = table.clone(state)
			state[player] = value
			return state
		end)
	end,
	SubscribeToPlayerAtom = function<T>(player: Player, atom: ServerAtom<T>, callback: (state: T, oldState: T) -> ())
		return Charm.observe(atom, function(_, name)
			local player = Players:FindFirstChild(name)
			if not player then
				return
			end

			local function playerData()
				return getPlayerData(player, atom)
			end

			return Charm.subscribe(playerData, callback)
		end)
	end,

	playersData = Charm.atom {} :: ServerAtom<AtomTypes.PlayersDataAtom>,
}
