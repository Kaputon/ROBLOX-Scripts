wait(10)

local Workspace = game.Workspace
local Players = game.Players

local function enoughPlayers()
	return (#Players:GetChildren() >= 4)
end

local function main()
	local pList = Players:GetChildren()
	while enoughPlayers() == false do
		wait()
	end
	if #pList % 2 == 0 then
		local TeamCount = #pList/2
		local RED = {}
		local BLUE = {}
		local ALLPLAYERS = {}
		local rand_player = nil
		
	--Team selection algorithm
		for i = 1,TeamCount do
			while not rand_player or ALLPLAYERS[rand_player] do
				wait()
				local rand_num = math.random(1,#pList)
				rand_player = pList[rand_num].Name
			end
			RED[rand_player] = true
			ALLPLAYERS[rand_player] = "Bright red"
		end
		
		for i = 1,TeamCount do
			while not rand_player or ALLPLAYERS[rand_player] do
				wait()
				local rand_num = math.random(1,#pList)
				rand_player = pList[rand_num].Name
			end
			BLUE[rand_player] = true
			ALLPLAYERS[rand_player] = "Bright blue"
		end
		-------------------------
		print(ALLPLAYERS)
		print("Teams Gathered")
		
		--Color all the men!
		
		for key,value in pairs(ALLPLAYERS) do
			for _,player in ipairs(Players:GetChildren()) do
				if key == player.Name then
					local char = player.Character
					for _, object in ipairs(char:GetChildren()) do
						if object.ClassName == "Part" then
							object.BrickColor = BrickColor.new(value)
						end
					end
				end
			end
		end
		
		--------------------
		
		print("Teams colored.")
		
		local rHammer = game.ServerStorage["Game Weapons"].RedHammer
		local bHammer = game.ServerStorage["Game Weapons"].BlueHammer
		--local rGun
		--local bGun
		
		for key,_ in pairs(RED) do
			for _, player in ipairs(Players:GetChildren()) do
				if key == player.Name then
					local ham = rHammer:Clone()
					ham.Parent = player.Backpack
				end
			end
		end
		
		for key,_ in pairs(BLUE) do
			for _, player in ipairs(Players:GetChildren()) do
				if key == player.Name then
					local ham = bHammer:Clone()
					ham.Parent = player.Backpack
				end
			end
		end
		
		--Players are armed!
	end
end

main()
