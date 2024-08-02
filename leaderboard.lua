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

local Flex = script.Parent.WingFlex
local Straight = script.Parent.WingStraight
local WFL = script.Parent.WFL.A
local WFR = script.Parent.WFR.A
local WingFlexing = false

function WingFlex()
	WingFlexing = true
	script.Parent.Fly.Value = true
	script.Parent.Taxi.Value = false
	WFL.Motor.DesiredAngle = 0.04
	WFR.Motor.DesiredAngle = 0.04
end

function WingStraight()
	WingFlexing = false
	script.Parent.Fly.Value = false
	script.Parent.Taxi.Value = true
	WFL.Motor.DesiredAngle = 0
	WFR.Motor.DesiredAngle = 0
end

while (WingFlexing) do
	WFL.Motor.DesiredAngle = 0
	WFR.Motor.DesiredAngle = 0
	WFL.Motor.DesiredAngle = 0.04
	WFR.Motor.DesiredAngle = 0.04
	wait(math.random(1,5))
	WFL.Motor.DesiredAngle = 0
	WFR.Motor.DesiredAngle = 0
	WFL.Motor.DesiredAngle = 0.06
	WFR.Motor.DesiredAngle = 0.06
	wait(math.random(1,5))
end

Flex.OnServerEvent:Connect(WingFlex)
Straight.OnServerEvent:Connect(WingStraight)

open = script.Parent.Parent.OPEN
closed = script.Parent

function onClicked(part)
	closed.Transparency = 1
	open.Transparency = 0
end

script.Parent.ClickDetector.MouseClick:connect(onClicked)

local Toggle = false

script.Parent.ClickDetector.MouseClick:Connect(function()
	if Toggle == false then
		Toggle = true
		script.Parent.Hinge.Motor.DesiredAngle = 1.3
	else
		Toggle = false
		script.Parent.Hinge.Motor.DesiredAngle = 0
	end
end)
local Toggle = false

script.Parent.Click.MouseClick:Connect(function()
	local Door = script.Parent.Door.Value
	if Toggle == false then
		Toggle = true
		script.Parent.BrickColor = BrickColor.new("Institutional white")
		Door.ClickDetector.MaxActivationDistance = 0
		Door.Script.Disabled = true
		Door.A.Motor.DesiredAngle = 0
	else
		Toggle = false
		script.Parent.BrickColor = BrickColor.new("Black")
		Door.ClickDetector.MaxActivationDistance = 10
		Door.Script.Disabled = false
	end
end)