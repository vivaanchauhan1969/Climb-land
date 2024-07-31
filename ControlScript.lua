local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Constants = require(ReplicatedStorage.Platformer.Constants)
local ActionManager = require(ReplicatedStorage.Utility.ActionManager)
local Controller = require(script.Parent.Controller)

local player = Players.LocalPlayer

local currentController = nil
local wasJumping = false

local function onCharacterAdded(character: Model)
	local controller = Controller.new(character)
	local ancestryChangedConnection
	ancestryChangedConnection = character.AncestryChanged:Connect(function()
		if not character:IsDescendantOf(game) then
			ancestryChangedConnection:Disconnect()
			controller:destroy()
			if currentController == controller then
				currentController = nil
			end
		end
	end)

	currentController = controller
end

local function onRenderStep(deltaTime: number)
	if not currentController then
		return
	end
	local moveDirection = currentController.humanoid:GetMoveVelocity() / currentController.humanoid.WalkSpeed
	local isJumping = currentController.humanoid.Jump
	local shouldJump = isJumping and not wasJumping
	currentController.humanoid.Jump = false
	wasJumping = isJumping
	currentController:setInputDirection(moveDirection)
	currentController:update(deltaTime)
	if shouldJump then
		currentController:performAction("BaseJump")
	end
end

local function onSpecialActionInput(_input: string, inputState: Enum.UserInputState, _inputObject: InputObject)
	if inputState ~= Enum.UserInputState.Begin then
		return
	end

	if not currentController then
		return
	end
	currentController:performAction("BaseSpecial")
end

local function initialize()
	player.CharacterAdded:Connect(onCharacterAdded)
	RunService:BindToRenderStep(Constants.CONTROLLER_RENDER_STEP_BIND, Enum.RenderPriority.Last.Value, onRenderStep)
	ActionManager.bindAction(
		Constants.SPECIAL_ACTION_BIND,
		onSpecialActionInput,
		Constants.KEYBOARD_SPECIAL_KEY_CODE,
		Constants.GAMEPAD_SPECIAL_KEY_CODE
	)

	if player.Character then
		onCharacterAdded(player.Character)
	end
end

initialize()
