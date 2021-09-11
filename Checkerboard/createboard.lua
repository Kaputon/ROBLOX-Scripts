local rs = game:GetService("RunService")

local sqDim = Vector3.new(8,2,8)
local origin = Vector3.new(0,0,0)

local checkerboard = { 
	{"white", "red","white", "red","white", "red","white", "red"},
	
	{"red","white", "red","white", "red","white", "red", "white"},
	
	{"white", "red","white", "red","white", "red","white", "red"},
	
	{"red","white", "red","white", "red","white", "red", "white"},
	
	{"white", "red","white", "red","white", "red","white", "red"},
	
	{"red","white", "red","white", "red","white", "red", "white"},
	
	{"white", "red","white", "red","white", "red","white", "red"},
	
	{"red","white", "red","white", "red","white", "red", "white"},
}

local z = 0

for numRow, row in ipairs(checkerboard) do
	local x = 0
	for numCol, col in ipairs(row) do
		local part = Instance.new("Part")
		part.Anchored = true
		part.Size = sqDim
		part.Transparency = 1
		part.Material = Enum.Material.Pebble
		part.Reflectance = 1
		part.Name = tostring(numCol)
		
		if col == "white" then
			part.BrickColor = BrickColor.White()
		elseif col == "red" then
			part.BrickColor = BrickColor.Red()
		end
		
		part.CFrame = CFrame.new(origin) * CFrame.new(x, 0, z)
		
		if not game.Workspace.Checkerboard:FindFirstChild("Row"..numRow) then
			local folder = Instance.new("Folder")
			folder.Name = "Row"..numRow
			folder.Parent = game.Workspace.Checkerboard
			
		else
			
			part.Parent = game.Workspace.Checkerboard:FindFirstChild("Row"..numRow)
		end
		
		x+= sqDim.X
		
		local tra = 1
		
		while part.Transparency > 0 do
			wait()
			part.Transparency = tra
			tra -= 1
		end
	end
	
	z+= sqDim.Z
	
end

local blPiece = game.ServerStorage.Checkers.BlackChecker
local redPiece = game.ServerStorage.Checkers.RedChecker

local function layPieces(row, staggered, checker)
	for sqIndex, square in ipairs(row:GetChildren()) do
		if (staggered and sqIndex%2 ==0) or ((not staggered) and sqIndex%2 ~= 0) then
			local piece = checker:Clone()
			piece:PivotTo(square.CFrame * CFrame.new(0, (square.Size.Y/2) + piece.Union.CenterOfMass.Y, 0) * CFrame.Angles(0,0,math.rad(-90)) )
			local checkFolder = game.Workspace.Checkers
			if piece.Name == "BlackChecker" then
				piece.Parent = checkFolder.Black
			else
				piece.Parent = checkFolder.Red
			end
			wait()
		else
			continue
		end
	end
end


for index, row in ipairs(game.Workspace.Checkerboard:GetChildren()) do
	if index == 1 then
		layPieces(row, false, blPiece)
	elseif index == 2 then
		layPieces(row, true, blPiece)
	elseif index == 3 then
		layPieces(row, false, blPiece)
		
	elseif index == 6 then
		layPieces(row, true, redPiece)
	elseif index == 7 then
		layPieces(row, false,redPiece)
	elseif index == 8 then
		layPieces(row, true, redPiece)
	end
end
