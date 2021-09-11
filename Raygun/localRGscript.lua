repeat wait() until game.Workspace

--LocalPlayer Variables
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character
local mouse = player:GetMouse()
local playerhealth = character:WaitForChild("Humanoid")
-------------------------------------------------------

--Service Variables
local UIS = game:GetService("UserInputService")
local debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local RepStorage = game:GetService("ReplicatedStorage")
-------------------------------------------------------


--Debounce Variables
local debounce = false
local finished = false
----------------------

--Gun Parts
local gun = script.Parent
local handle = script.Parent.Handle
local circlep = gun.circlep
local ammo = gun.Ammo
--Gun Sounds
local fire = gun.Fire
local reload = gun.Reload
-----------------------------------|


--RemoteEvent Variables
local ShootOn = gun:WaitForChild("RayGun")
local AltShoot = gun:WaitForChild("RayGunAlt")
local Reload = gun:WaitForChild("ReloadEvent")
-------------------------------------------------

--Crosshairs
local base = "rbxassetid://"
local idleCrosshair = 4048495248 --4048495248
local reloadingCrosshair = 43557167
---------------------------------------------

--Gun Settings
local firerate = .4
local firedist = 1000
local dmg = 25
local ignorelist = {}
local transpVal = {.35,.4,.5,.6,.75}
--------------------

local AmmoGui = player.PlayerGui:FindFirstChild("Ammo")

function FindIgnoreList()
	for k,v in pairs(ignorelist) do 
		ignorelist[k]=nil 
	end
	print(#ignorelist)
		for _, s in ipairs(gun.Parent:GetChildren()) do
			if s.ClassName == "Part" then
				table.insert(ignorelist, s)
			end
		end
	for _, v in ipairs(game.Workspace:GetDescendants()) do
		if v.ClassName == "Accessory" then
			table.insert(ignorelist,v)
				if v:FindFirstChild("Handle") then
					local hat = v.Handle
					table.insert(ignorelist, hat)
			end
		end
	end
end

---------------------------}

gun.Equipped:Connect(function(mouse)
		mouse.Icon = base..idleCrosshair
		AmmoGui.Enabled = true
	mouse.Button1Down:Connect(function()
		if debounce == false and playerhealth.Health > 0 and ammo.Value > 0 then
					debounce = true
				FindIgnoreList()
					local Mhit = mouse.hit
				ShootOn:InvokeServer(Mhit, ignorelist)
					wait(firerate)
					debounce = false
			elseif ammo.Value == 0 and debounce == false then
					debounce = true
						mouse.Icon = base..reloadingCrosshair
				Reload:InvokeServer()
						mouse.Icon = base..idleCrosshair
					debounce = false
			else
			
				
				return
		end
	end)
	mouse.Button2Down:Connect(function()
			if debounce == false and playerhealth.Health > 0 and ammo.Value >= 3 then
					debounce = true
					FindIgnoreList()
					local Mhit = mouse.hit
					AltShoot:InvokeServer(Mhit, ignorelist, circlep)
					wait(firerate)
					debounce = false
				else
					return
			end
	end)
end)

gun.Unequipped:Connect(function()
	AmmoGui.Enabled = false
end)


UIS.InputBegan:connect(function(input)
	local r = Enum.KeyCode.R
	local keysPressed = UIS:GetKeysPressed()
	for _, keys in ipairs(keysPressed) do
		if (keys.KeyCode == r) and ammo.Value < 6 and debounce == false and playerhealth.Health > 0 then
			debounce = true
			mouse.Icon = base..reloadingCrosshair
			Reload:InvokeServer()
			mouse.Icon = base..idleCrosshair
			debounce = false
		end
	end
end)


