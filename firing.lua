local firin = false

script.Parent.OnServerEvent:Connect(function(plr,value,mouseHit,mouseTarget)
	firin = value
	wait()
	while firin do 
	wait()
		if mouseTarget == nil then return end
		if mouseTarget.Parent ~= script.Parent.Parent.Parent and mouseTarget.Parent.Parent ~= script.Parent.Parent.Parent then
			for i = 1, math.random(4,5) do
				script.Parent.Parent.fire:Play()
				local theTar = mouseHit.p + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
				local bull = Instance.new("Part")
				bull.Parent = game.Workspace
				bull.CFrame = CFrame.new((theTar + script.Parent.Parent.Parent.Gun1.Position)/2,script.Parent.Parent.Parent.Gun1.Position) --- script.Parent.Parent is the vehicle seat
				bull.CanCollide = false
				bull.BrickColor = BrickColor.new(24)
				bull.Anchored = true
				bull.Size = Vector3.new(1,1.2,1)
				game.Debris:AddItem(bull,0.1)
				local mesher = Instance.new("BlockMesh")
				mesher.Parent = bull
				mesher.Scale = Vector3.new(0.2, 0.2, (mouseHit.p - script.Parent.Parent.Parent.Gun1.Position).magnitude)
				local ex = Instance.new("Explosion")
				ex.BlastRadius = 5
				ex.BlastPressure = 5000
				ex.Position = theTar
				ex.Parent = game.Workspace
				wait(0.06)
			end
		end
	end
end)
