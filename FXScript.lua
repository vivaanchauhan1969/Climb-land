
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local safePlayerAdded = require(ReplicatedStorage.Utility.safePlayerAdded)
local FXController = require(script.Parent.FXController)

local function onCharacterAdded(character: Model)
	local fxController = FXController.new(character)
	local ancestryChangedConnection
	ancestryChangedConnection = character.AncestryChanged:Connect(function()
		if not character:IsDescendantOf(game) then
			ancestryChangedConnection:Disconnect()
			fxController:destroy()
		end
	end)
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(onCharacterAdded)

	if player.Character then
		onCharacterAdded(player.Character)
	end
end

safePlayerAdded(onPlayerAdded)
