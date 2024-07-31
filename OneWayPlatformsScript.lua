

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Constants = require(ReplicatedStorage.Gameplay.Constants)

local player = Players.LocalPlayer
local root = nil
local humanoid = nil

local platforms = {}
local lastUpdate = 0

local function onCharacterAdded(character: Model)
	root = character:WaitForChild("HumanoidRootPart")
	humanoid = character:WaitForChild("Humanoid")
end
local function onPlatformAdded(platform: Instance)
	assert(platform:IsA("BasePart"), `{platform} should be a BasePart`)

	platforms[platform] = true
end

local function onPlatformRemoved(platform: Instance)
	assert(platform:IsA("BasePart"), `{platform} should be a BasePart`)

	if platforms[platform] then
		platforms[platform] = nil
	end
end

local function onStepped()
	if not (root and humanoid) then
		return
	end

	local elapsed = os.clock() - lastUpdate
	if elapsed < 1 / Constants.ONE_WAY_PLATFORM_UPDATE_RATE then
		return
	end
	lastUpdate = os.clock()
	local footPosition = root.Position.Y - humanoid.HipHeight
	for platform in platforms do
		local offset = platform.Position - root.Position
		local maxOffset = math.max(math.abs(offset.X), math.abs(offset.Y), math.abs(offset.Z))
		if maxOffset > Constants.ONE_WAY_PLATFORM_UPDATE_DISTANCE then
			continue
		end
		platform.CanCollide = footPosition > platform.Position.Y
	end
end

local function initialize()
	CollectionService:GetInstanceAddedSignal(Constants.ONE_WAY_PLATFORM_TAG):Connect(onPlatformAdded)
	CollectionService:GetInstanceRemovedSignal(Constants.ONE_WAY_PLATFORM_TAG):Connect(onPlatformRemoved)
	RunService.Stepped:Connect(onStepped)
	player.CharacterAdded:Connect(onCharacterAdded)

	for _, platform in CollectionService:GetTagged(Constants.ONE_WAY_PLATFORM_TAG) do
		onPlatformAdded(platform)
	end

	if player.Character then
		onCharacterAdded(player.Character)
	end
end

initialize()
