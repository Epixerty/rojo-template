local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)
local AtomTypes = require(ReplicatedStorage.shared.atom_types)

type Atom<T> = Charm.Atom<T>
type ServerAtom<T> = Atom<{ [Player]: T }>

return {
	UpdatePlayerAtom = function(player: Player, atom: Charm.Atom<any>, value: any)
		atom(function(state)
			state = table.clone(state)
			state[player] = value
			return state
		end)
	end,

	playersData = Charm.atom {} :: ServerAtom<AtomTypes.PlayersDataAtom>,
}
