local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
if script.Parent == StarterPlayer.StarterCharacterScripts then
	return
end

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local rootJoint = character:WaitForChild("LowerTorso"):WaitForChild("Root")

local ROLL_ANGLE = math.rad(15)
local PITCH_ANGLE = math.rad(5)
local LEAN_SPEED = 10

local leanCFrame = CFrame.new()

local function onStepped(_: number, deltaTime: number)
	local relativeVelocity = root.CFrame:VectorToObjectSpace(root.AssemblyLinearVelocity)
	local pitch = math.clamp(relativeVelocity.Z / humanoid.WalkSpeed, -1, 1) * PITCH_ANGLE
	local roll = -math.clamp(relativeVelocity.X / humanoid.WalkSpeed, -1, 1) * ROLL_ANGLE

	leanCFrame = leanCFrame:Lerp(CFrame.Angles(pitch, 0, roll), math.min(deltaTime * LEAN_SPEED, 1))
	rootJoint.Transform = leanCFrame * rootJoint.Transform
end

RunService.Stepped:Connect(onStepped)
