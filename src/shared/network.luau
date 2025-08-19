local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

if not RunService:IsRunning() then
	return {} :: Remotes -- hacky workaround to test ui stories that rely on remotes
end

local TypedRemote = require(ReplicatedStorage.packages.typed_remote)

local remotes = {
	PlayerSessionData = {
		SyncAtom = TypedRemote.event("SyncAtom") :: TypedRemote.Event<any>,

		RequestAtomData = TypedRemote.event("RequestAtomData") :: TypedRemote.Event<>,
	},
}

type Remotes = typeof(remotes)

return remotes
