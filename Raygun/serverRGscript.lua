local UIS = game:GetService("UserInputService")
local debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local RepStorage = game:GetService("ReplicatedStorage")

local gun = script.Parent
local handle = script.Parent.Handle
local ammo = gun.Ammo
local ReloadBool = gun.IsReloading

local fire = gun.Fire
local reload = gun.Reload

local ShootOn = gun:WaitForChild("RayGun")
local AltShoot = gun:WaitForChild("RayGunAlt")
local Reload = gun:WaitForChild("ReloadEvent")

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

ShootOn.OnServerInvoke = function(player, Mhit, ignorelist)
	local gunlaser = Ray.new(handle.Position, (Mhit.p - handle.CFrame.Position).unit * firedist)
	local hit, position = game.Workspace:FindPartOnRayWithIgnoreList(gunlaser, ignorelist)
		if hit and hit:IsA("Part") then
			ammo.Value = ammo.Value - 1
			fire:Play()
			local dist = (handle.Position - Mhit.p).magnitude
				local part2 = Instance.new("Part")
				part2.CFrame = CFrame.new((gun.circlep.Position), Mhit.p) * CFrame.new(0,0,(-dist)/2)
				part2.Size = Vector3.new(0,0,dist)
				part2.Material = Enum.Material.Neon
				part2.CanCollide = false
				part2.BrickColor = BrickColor.new("Really red")
				part2.Parent = game.Workspace
				part2.Anchored = true
					local partFade2 = coroutine.create(function(part2)
						for i = 0,1,(firerate*.75) do
								wait()
									part2.Transparency = i
								print(part2.Transparency)
							end
						end)
				coroutine.resume(partFade2, part2)
				debris:AddItem(part2, (firerate)*(.99))
		if hit.Parent:FindFirstChild("Humanoid") then
			local hum = hit.Parent:FindFirstChild("Humanoid")
			hum:TakeDamage(dmg)
			local fire = Instance.new("Fire")
			fire.Parent = hit
			--local t = (math.random(1,#transpVal))
			hit.Material = "Neon"
			hit.BrickColor = BrickColor.new("Really red")
			debris:AddItem(fire,math.random(1,10))
		end
	end
end

AltShoot.OnServerInvoke = function(player, Mhit, ignorelist, circlep)
		local sphere = Instance.new("Part")
		local gunlaser2 = Ray.new(handle.Position, (Mhit.p - handle.CFrame.Position).unit * firedist)
		local hit, position = game.Workspace:FindPartOnRayWithIgnoreList(gunlaser2, ignorelist)
				energySphere(sphere)
			if hit and hit:IsA("Part") then
				ammo.Value = ammo.Value - 3
				fire:Play()
				local dist = (handle.Position - Mhit.p).magnitude
				local part = Instance.new("Part")
				part.CFrame = CFrame.new((gun.circlep.Position), Mhit.p) * CFrame.new(0,0,(-dist)/2)
				part.Size = Vector3.new(0,0,dist)
				part.Material = Enum.Material.Neon
				part.CanCollide = false
				part.BrickColor = BrickColor.new("Really red")
				part.Parent = game.Workspace
				part.Anchored = true
					local partFade = coroutine.create(function(part)
						for i = 0,1,(firerate*.5) do
								wait()
									part.Transparency = i
							end
						end)
				coroutine.resume(partFade, part)
				debris:AddItem(part, (firerate)*(1.5))
		if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
				local hum = hit.Parent:FindFirstChild("Humanoid")
				hum.Health = 0
			for _, v in ipairs(hit.Parent:GetDescendants()) do
				if v.ClassName == "Part" then
					local d = v:Clone()
					d.Position = v.Position
					d.Parent = game.Workspace
					d.CanCollide = true
					debris:AddItem(v, 0)
					local ss = Instance.new("BodyVelocity")
					ss.Velocity = Vector3.new(math.random(0,10),math.random(0,10),math.random(0,10))
					ss.Parent = d
					d.Material = "Neon"
					local fadePart3 = coroutine.create(function(d)
						for i = 0, 1, firerate*.09 do
							wait()
							d.Transparency = i
						end
					end)
					coroutine.resume(fadePart3, d)
					--local t = (math.random(1,#transpVal))
					--d.Transparency = transpVal[t]
					d.BrickColor = BrickColor.new("Really red")
					debris:AddItem(d, math.random(3,7))
				end
			end
			else
				return
		end
	end
end

Reload.OnServerInvoke = function(player)
		ReloadBool = true
		reload:Play()
			while reload.Playing == true do
				wait()
			end
		ammo.Value = 6
		ReloadBool = false
end

function energySphere(part)
			local chargeSound = Instance.new("Sound")
			chargeSound.Parent = handle
			chargeSound.SoundId = "rbxassetid://3637072313"
		local w = Instance.new("Weld")
		w.Parent = part
		w.Part0 = part
		w.Part1 = gun.circlep
			part.Shape = "Ball"
			part.Size = Vector3.new(0,0,0)
			part.Material = "Neon"
			part.Anchored = false
			part.Parent = game.Workspace
			part.BrickColor = BrickColor.new("Really red")
			part.CanCollide = false
			chargeSound:Play()
	for i = 0,5, .33 do
		chargeSound.PlaybackSpeed = i
		wait()
		part.Size = Vector3.new(i/4,i/4,i/4)
		part.Transparency = i/6
	end
	debris:AddItem(part,0)
	debris:AddItem(chargeSound,0)
end
