--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)
local AtomTypes = require(ReplicatedStorage.shared.atom_types)

type Atom<T> = Charm.Atom<T>
type ServerAtom<T> = Atom<{ [Player]: T }>

local function getPlayerData<T>(player: Player, atom: ServerAtom<T>): T
	return atom()[player]
end

return {
	GetPlayerAtom = function<T>(player: Player, atom: ServerAtom<T>): T
		return (table.clone(getPlayerData(player, atom) :: any) :: any) :: T
	end,
	UpdatePlayerAtom = function<T>(player: Player, atom: ServerAtom<T>, value: T)
		atom(function(state)
			state = table.clone(state)
			state[player] = value
			return state
		end)
	end,
	SubscribeToPlayerAtom = function<T>(player: Player, atom: ServerAtom<T>, callback: (state: T, oldState: T) -> ())
		return Charm.observe(atom, function(_, player)
			local function playerData()
				return getPlayerData(player, atom)
			end

			return Charm.subscribe(playerData, callback)
		end)
	end,

	playersData = Charm.atom {} :: ServerAtom<AtomTypes.PlayersDataAtom>,
}
