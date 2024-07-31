local function getCheckpoints(platformContainer: Instance): { BasePart }
	local checkpointsFolder = platformContainer:FindFirstChild("Checkpoints")
	assert(checkpointsFolder, `No Checkpoints in {platformContainer:GetFullName()}`)
	local checkpoints = {}
	local numCheckpoints = #checkpointsFolder:GetChildren()
	for i = 1, numCheckpoints do
		local checkpoint = checkpointsFolder:FindFirstChild(`Checkpoint{i}`)
		assert(checkpoint, `{platformContainer:GetFullName()} missing checkpoint: Checkpoint{i}`)
		table.insert(checkpoints, checkpoint)
	end

	return checkpoints
end

return getCheckpoints
