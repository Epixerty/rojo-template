local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)

type Atom<T> = Charm.Atom<T>

export type PlayersData = {}

return {
	playersData = Charm.atom {} :: Atom<PlayersData>,
}
