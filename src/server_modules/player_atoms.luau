--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Charm = require(ReplicatedStorage.packages.charm)
local AtomTypes = require(ReplicatedStorage.shared.atom_types)

type Atom<T> = Charm.Atom<T>
type ServerAtom<T> = Atom<{ [Player]: T }>

local function getPlayerData<T>(player: Player, atom: ServerAtom<T>): T?
	local value = if atom() then atom()[player] else nil

	if not value then
		return nil
	end

	if typeof(value) == "table" then
		return (table.clone(value) :: any) :: T
	end

	return value
end

return {
	GetPlayerAtom = getPlayerData,
	UpdatePlayerAtom = function<T>(player: Player, atom: ServerAtom<T>, value: T)
		if typeof(value) == "table" then
			value = (table.clone(value :: any) :: any) :: T
		end

		atom(function(state)
			state = table.clone(state)
			state[player] = value
			return state
		end)
	end,
	SubscribeToPlayerAtom = function<T>(player: Player, atom: ServerAtom<T>, callback: (state: T?, oldState: T?) -> ())
		return Charm.observe(atom, function(_, _player)
			if _player ~= player then
				return
			end

			local function playerData()
				return getPlayerData(_player, atom)
			end

			return Charm.subscribe(playerData, callback)
		end)
	end,

	playersData = Charm.atom {} :: ServerAtom<AtomTypes.PlayersDataAtom>,
}
