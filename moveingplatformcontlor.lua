local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Gameplay.Constants)
local disconnectAndClear = require(ReplicatedStorage.Utility.disconnectAndClear)
local getCheckpoints = require(script.getCheckpoints)
local getPlatform = require(script.getPlatform)
local visualizeCheckpointPath = require(script.visualizeCheckpointPath)

local MovingPlatformController = {}
MovingPlatformController.__index = MovingPlatformController

function MovingPlatformController.new(platformContainer: Instance)
	local platform = getPlatform(platformContainer)
	local checkpoints = getCheckpoints(platformContainer)

	local speed = platformContainer:GetAttribute(Constants.MOVING_PLATFORM_SPEED_ATTRIBUTE)
	local angularSpeed = platformContainer:GetAttribute(Constants.MOVING_PLATFORM_ANGULAR_SPEED_ATTRIBUTE)

	local attachment = Instance.new("Attachment")
	attachment.Name = "MovingPlatformAttachment"
	attachment.Parent = platform

	local alignPosition = Instance.new("AlignPosition")
	alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	alignPosition.Attachment0 = attachment
	alignPosition.MaxForce = math.huge
	alignPosition.MaxVelocity = speed
	alignPosition.Responsiveness = Constants.MOVING_PLATFORM_RESPONSIVENESS
	alignPosition.Parent = platform

	local alignOrientation = Instance.new("AlignOrientation")
	alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOrientation.Attachment0 = attachment
	alignOrientation.MaxTorque = math.huge
	alignOrientation.MaxAngularVelocity = angularSpeed
	alignOrientation.Responsiveness = Constants.MOVING_PLATFORM_RESPONSIVENESS
	alignOrientation.Parent = platform

	local self = {
		platformContainer = platformContainer,
		checkpointIndex = 1,
		platform = platform,
		alignPosition = alignPosition,
		alignOrientation = alignOrientation,
		checkpoints = checkpoints,
		connections = {},
	}
	setmetatable(self, MovingPlatformController)
	self:initialize()
	return self
end

function MovingPlatformController:initialize()
	table.insert(
		self.connections,
		self.platformContainer:GetAttributeChangedSignal(Constants.MOVING_PLATFORM_SPEED_ATTRIBUTE):Connect(function()
			local speed = self.platformContainer:GetAttribute(Constants.MOVING_PLATFORM_SPEED_ATTRIBUTE)
			self.alignPosition.MaxVelocity = speed
		end)
	)

	table.insert(
		self.connections,
		self.platformContainer
			:GetAttributeChangedSignal(Constants.MOVING_PLATFORM_ANGULAR_SPEED_ATTRIBUTE)
			:Connect(function()
				local angularSpeed =
					self.platformContainer:GetAttribute(Constants.MOVING_PLATFORM_ANGULAR_SPEED_ATTRIBUTE)
				self.alignOrientation.MaxAngularVelocity = angularSpeed
			end)
	)


	visualizeCheckpointPath(self.checkpoints)

	local checkpoint = self.checkpoints[self.checkpointIndex]
	self.platform.CFrame = checkpoint.CFrame
	self.alignPosition.Position = checkpoint.Position
	self.alignOrientation.CFrame = checkpoint.CFrame
end

function MovingPlatformController:move()
	local nextCheckpointIndex = self.checkpointIndex + 1
	if nextCheckpointIndex > #self.checkpoints then
		nextCheckpointIndex = 1
	end
	self.checkpointIndex = nextCheckpointIndex

	local checkpoint = self.checkpoints[nextCheckpointIndex]
	local distance = (self.platform.Position - checkpoint.Position).Magnitude
	local timeToNextCheckpoint = distance / self.alignPosition.MaxVelocity

	self.alignPosition.Position = checkpoint.Position
	self.alignOrientation.CFrame = checkpoint.CFrame
	local delayTime = self.platformContainer:GetAttribute(Constants.MOVING_PLATFORM_DELAY_ATTRIBUTE)
	self.moveTask = task.delay(timeToNextCheckpoint + delayTime, self.move, self)
end

function MovingPlatformController:stop() 
	if self.moveTask then
		task.cancel(self.moveTask)
		self.moveTask = nil
	end
end

function MovingPlatformController:destroy()
	self:stop()
	disconnectAndClear(self.connections)
end

return MovingPlatformController
