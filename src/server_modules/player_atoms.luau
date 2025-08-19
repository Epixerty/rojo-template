local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)

export type PlayersDataAtom = {}

return {
	playersData = Charm.atom {} :: Charm.Atom<{ [Player]: PlayersDataAtom }>,
}
