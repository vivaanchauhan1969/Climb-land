local ReplicatedStorage = game:GetService("ReplicatedStorage")

local getOrCreateAttachment = require(ReplicatedStorage.Utility.getOrCreateAttachment)

local beamTemplate = ReplicatedStorage.Gameplay.Objects.PlatformPathBeam

local function visualizeCheckpointPath(checkpoints: { BasePart })
	for index, checkpoint in checkpoints do
		checkpoint.Transparency = 1

		if #checkpoints == 2 and index == 2 then
			return
		end
		local nextCheckpoint = checkpoints[index + 1] or checkpoints[1]
		local checkpointAttachment = getOrCreateAttachment(checkpoint, "PlatformPathAttachment")
		local nextCheckpointAttachment = getOrCreateAttachment(nextCheckpoint, "PlatformPathAttachment")

		local beam = beamTemplate:Clone()
		beam.Attachment0 = checkpointAttachment
		beam.Attachment1 = nextCheckpointAttachment
		beam.Parent = checkpoint
	end
end

return visualizeCheckpointPath
