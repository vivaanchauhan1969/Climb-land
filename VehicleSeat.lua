script.Parent.ChildAdded:connect(function(child)
	if child.Name=="SeatWeld" then
		local flyer=script.LocalScript:Clone()
		flyer.Disabled= false
		flyer.Parent=script.Parent.Parent
		script.Parent.Parent.Parent=child.Part1.Parent
		script.Parent.Parent.Rotor1.sound:Play()
		for i,v in ipairs(script.Parent.Parent:GetChildren()) do
			if v:IsA("Seat") then
				v.Disabled = false
			end
		end
	end
end)

script.Parent.ChildRemoved:connect(function(child)
	if child.Name=="SeatWeld" then
		script.Parent.Parent.Parent=workspace
		if script.Parent.Parent:FindFirstChild("LocalScript") then
			script.Parent.Parent:FindFirstChild("LocalScript"):Destroy()
		end
		script.Parent.Parent.Rotor1.sound:Stop()
		for i,v in ipairs(script.Parent.Parent:GetChildren()) do
			if v:IsA("Seat") then
				v.Disabled = true
			end
		end
	end
end)
