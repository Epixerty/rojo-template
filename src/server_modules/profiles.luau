local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.packages.signal)

local module = {
	PROFILE_TEMPLATE = {},
	Added = Signal.new() :: Signal.Signal<Player, Profile>,
	Removed = Signal.new() :: Signal.Signal<Player>,
	profiles = {} :: { [Player]: Profile },
}

export type Profile = {
	Data: typeof(module.PROFILE_TEMPLATE),
}

return module
