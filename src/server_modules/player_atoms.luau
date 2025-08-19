local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)

type Atom<T> = Charm.Atom<T>
type ServerAtom<T> = Atom<{ [Player]: T }>

export type PlayersDataAtom = {}

return {
	playersData = Charm.atom {} :: ServerAtom<PlayersDataAtom>,
}
