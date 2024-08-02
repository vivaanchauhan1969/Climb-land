local One = script.One.Value
local Two = script.Two.Value
local Three = script.Three.Value
local Speed = 200

script.Parent.Parent.Flap.Changed:Connect(function()
	if script.Parent.Parent.Flap.Value == 0 then
		Speed = 200
	elseif script.Parent.Parent.Flap.Value == 1 then
		Speed = 180
	elseif script.Parent.Parent.Flap.Value == 2 then
		Speed = 170
	elseif script.Parent.Parent.Flap.Value == 3 then
		Speed = 160
	elseif script.Parent.Parent.Flap.Value == 4 then
		Speed = 150
	end
end)

function SmokeOne()
	if One.Velocity.Magnitude > Speed then
		One.Smoke:Emit(100)
		One.Touchdown:Play()
	end
end

function SmokeTwo()
	if Two.Velocity.Magnitude > Speed then
		Two.Smoke:Emit(100)
		Two.Touchdown:Play()
	end
end

function SmokeThree()
	if Three.Velocity.Magnitude > Speed then
		Three.Smoke:Emit(100)
		Three.Touchdown:Play()
	end
end

One.Touched:Connect(SmokeOne)
Two.Touched:Connect(SmokeTwo)
Three.Touched:Connect(SmokeThree)

