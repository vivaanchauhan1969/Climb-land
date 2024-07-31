local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Constants = require(ReplicatedStorage.Platformer.Constants)
local validateString = require(ServerScriptService.Utility.TypeValidation.validateString)
local validateAction = require(script.validateAction)

local remotes = ReplicatedStorage.Platformer.Remotes
local setActionRemote = remotes.SetAction

local function onSetActionEvent(player: Player, action: string)
	if not validateString(action) then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	if not validateAction(action) then
		return
	end

	character:SetAttribute(Constants.REPLICATED_ACTION_ATTRIBUTE, action)
end

setActionRemote.OnServerEvent:Connect(onSetActionEvent)
