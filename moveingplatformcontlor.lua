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
