local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TypedRemote = require(ReplicatedStorage.packages.typed_remote)

type Test = {
	data: string,
	response: number,
}

return {
	PlayerSessionData = {
		SyncAtom = TypedRemote.event("SyncAtom") :: TypedRemote.Event<any>,
		RequestAtomData = TypedRemote.event("RequestAtomData") :: TypedRemote.Event<>,
	},
}
