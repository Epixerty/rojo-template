local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)
local AtomTypes = require(ReplicatedStorage.shared.atom_types)

type Atom<T> = Charm.Atom<T>

return {
	playersData = Charm.atom {} :: Atom<AtomTypes.PlayersDataAtom>,
}
