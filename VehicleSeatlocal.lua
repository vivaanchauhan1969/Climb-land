local inputS=game:getService("UserInputService")
local player=game.Players.LocalPlayer
local firing = script.Parent.VehicleSeat.firing
local engine=script.Parent.Engine
local rotor1=script.Parent.Motor
local rotor2=script.Parent.Rotor
local seat = script.Parent.VehicleSeat
local ControlModule = require(game:GetService("Players").LocalPlayer.PlayerScripts.PlayerModule.ControlModule)
local Player = game.Players.LocalPlayer
local mouse = Player:GetMouse()
local gyro
local spd
local max_speed=50

if not engine:FindFirstChild("BodyGyro") then
	gyro=Instance.new("BodyGyro",engine)
	gyro.maxTorque=Vector3.new(1e4,1e4,1e4)
	gyro.D=1250
	gyro.cframe=engine.CFrame
else
	gyro=engine:WaitForChild("BodyGyro")
end

if not engine:FindFirstChild("BodyVelocity") then
	spd=Instance.new("BodyVelocity",engine)
	spd.maxForce=Vector3.new(1e9,1e9,1e9)
else
	spd=engine:WaitForChild("BodyVelocity")	
end

local w,a,s,d,up,dn

inputS.InputBegan:connect(function(input)
	local code=input.KeyCode
	if code==Enum.KeyCode.LeftShift then
		up=true
	elseif input.KeyCode==Enum.KeyCode.LeftControl then
		dn=true
	end
end)
 
 inputS.TouchStarted:Connect(function(object)
 	if object == Enum.KeyCode.DPadUp or seat.Throttle == 1 then
 		w=true
 	elseif object == Enum.KeyCode.DPadLeft or seat.Steer == -1 then
 		a=true	
 	elseif object == Enum.KeyCode.DPadDown or seat.Throttle == -1 then
 		s=true	
 	elseif object == Enum.KeyCode.DPadRight or seat.Steer == 1 then
 		d=true			
 	end
 end)

inputS.InputEnded:connect(function(input)
	local code=input.KeyCode
	if code==Enum.KeyCode.LeftShift then
		up=false
	elseif input.KeyCode==Enum.KeyCode.LeftControl then
		dn=false
	end
end)

inputS.TouchEnded:Connect(function(object)
	if object == Enum.KeyCode.DPadUp or seat.Throttle == 0 or seat.Throttle == -1 then
		w=false
	elseif object == Enum.KeyCode.DPadLeft or seat.Steer == 0 or seat.Steer == 1 then
		a=false
	elseif object == Enum.KeyCode.DPadDown or seat.Throttle == 0 or seat.Throttle == 1 then
		s=false	
	elseif object == Enum.KeyCode.DPadRight or seat.Steer == 0 or seat.Steer == -1 then
		d=false		
	end
end)

mouse.Move:connect(function() 
	if not engine:FindFirstChild("BodyGyro") then
		local gyro=engine.BodyGyro
		gyro.cframe = mouse.Hit
	end
end)

mouse.Button1Down:Connect(function()
	firing:FireServer(true,mouse.Hit,mouse.Target)
end)

mouse.Button1Up:Connect(function()
	firing:FireServer(false,mouse.Hit,mouse.Target)
end)

function rotorSpd(spd)
	rotor1.TopParamA=-spd
	rotor1.TopParamB=spd
	rotor2.BottomParamA=-spd
	rotor2.BottomParamB=spd
end

local chg=Vector3.new(0,0,0)
local rot=0
local inc=0
while wait(.1) do
	local lv=engine.CFrame.lookVector
	local Vector = ControlModule:GetMoveVector()
	print(Vector)
	if Vector == Vector3.new(0, 0, 0) then
		print("Idle")
	end
