local coin = script.Parent
local GameValues = game.Workspace.GameValues
local INCREASE = GameValues.Elements.COIN_SPEED_INCREASE
local RESPAWN = GameValues.Elements.COIN_RESPAWN
local debounce = false
local SFX = GameValues.Elements.CoinSFX
local VFX = GameValues.Elements.CoinVFX

local lastChoice = nil
-------------------------------------
--[[Transparent Function:
		Toggles the coins transparency. The toggle sets the transparency value and then
		the function iterates through the coins decals and turns them on or off.
]]

local function transparent(item)
	local trans = nil
	
	
	if item.Transparency == 0 then
		trans = 1
	elseif item.Transparency == 1 then
		trans = 0
	end
	
	item.Transparency = trans
	for _, v in ipairs(item:GetChildren()) do
		if v:IsA("Decal") then
			v.Transparency = trans
		end
	end
end
---------------------------------------
--[[ Authenticate Function:
		Returns true if the object hitting the part matches the criteria of a human
]]

local function authenticate(hit)
	if hit:IsA("Part") and hit.Parent:IsA("Model") and hit.Parent:FindFirstChild("Humanoid") then
		return true
	else
		return false
	end
end

----------------------------------------
--[[Add Coins Function:
		Simple function that gathers the player from the character who hit the coin...
		and adds one to the value (assuming the player does not have 10 coins)]]


local function addCoins(hit)
	local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
	local hum = hit.Parent.Humanoid
	if plr.PlayerValues.COINS.Value <= 7 then
		plr.PlayerValues.COINS.Value += 3
		hum.WalkSpeed += (INCREASE.Value)*3
	elseif plr.PlayerValues.COINS.Value > 7 then
		local multiply = math.abs(plr.PlayerValues.COINS.Value - 10)
		plr.PlayerValues.COINS.Value = 10
		hum.WalkSpeed += (INCREASE.Value)*multiply
		print(tostring(INCREASE.Value).." * "..tostring(multiply).."= "..tostring(INCREASE.Value*multiply))
	elseif plr.PlayerValues.COINS.Value == 10 then
		return
	end
end


local function Greenify(hit)
	local plr = hit.Parent
	for _, limb in ipairs(plr:GetChildren()) do
		if limb:IsA("Part") then
			local colorVal = Instance.new("Color3Value")
			colorVal.Name = "col"
			colorVal.Value = limb.Color
			colorVal.Parent = limb
			limb.Color = Color3.fromRGB(0, 213, 0)
		end
	end
	wait(RESPAWN.Value)
	for _, limb in ipairs(plr:GetChildren()) do
		if limb:IsA("Part") then
			local oldColor = limb:FindFirstChild("col")
			limb.Color = oldColor.Value
			game.Debris:AddItem(oldColor)
		end
	end
end

local function oneHitGun(hit)
	local gun = game.ServerStorage.Weapons.OneHitKill:Clone()
	gun.Parent = game.Players:GetPlayerFromCharacter(hit.Parent).Backpack
end

local function updateGui(eventName)
	local gui = coin.GatherGui
	gui.Enabled = true
	gui.GatherText.Text = eventName
	wait(RESPAWN.Value)
	gui.Enabled = false
end

local function randEffect(hit)
	local eventTable = {"Greenify", "1S1K", "+50 HP", "+3 Coins"}
	local choice = math.random(1,4)
	
	while choice == lastChoice do
		choice = math.random(1,4)
	end
	
	local guiCoro = coroutine.wrap(updateGui)
	guiCoro(eventTable[choice])
	
	if choice == 1 then -- Greenify!
		local coro = coroutine.wrap(Greenify)
		coro(hit)
	elseif choice == 2 then -- Deadly gun!
		oneHitGun(hit)
	elseif choice == 3 then
		if not (hit.Parent.Humanoid.MaxHealth > 199) then
			hit.Parent.Humanoid.MaxHealth += 50
			hit.Parent.Humanoid.Health += 50
		else
			hit.Parent.Humanoid.Health += 50
		end
	elseif choice == 4 then
		addCoins(hit)
	end
	
	lastChoice = choice
end

-----------------------------------------

coin.Touched:Connect(function(hit)
	if debounce == false then
		if authenticate(hit) then
			debounce = true
			SFX:Play()
			local grabFX = VFX:Clone()
			grabFX.Parent = coin
			grabFX.Enabled = true
			game.Debris:AddItem(grabFX, 1)
			
			randEffect(hit)
			
			transparent(coin)
			wait(RESPAWN.Value)
			debounce = false
			transparent(coin)
		end
	end
end)
