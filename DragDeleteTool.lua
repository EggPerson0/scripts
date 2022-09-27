-- Gui to Lua
-- Version: 3.2

-- Instances:


local SelectFrame = Instance.new("Frame")
local Selecionbox = Instance.new("SelectionBox")
--Properties:

SelectFrame.Name = "SelectFrame"
SelectFrame.Parent = game.Players.LocalPlayer.PlayerGui.MainGui
SelectFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SelectFrame.BackgroundTransparency = 0.900
SelectFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
SelectFrame.Size = UDim2.new(0, 100, 0, 100)
SelectFrame.Visible = false

Selecionbox.Parent = SelectFrame
Selecionbox.Color3 = Color3.new(1,0,0)
Selecionbox.LineThickness = 0.025
Selecionbox.SurfaceTransparency = 0.75
-- Scripts:

	--[[local args = {
		[1] = workspace.Creations.Egg_Person0.Block
	}
	
	game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Events.Delete:FireServer(unpack(args))]]
local camera = workspace.CurrentCamera

local player = game.Players.LocalPlayer
local Parts = {}
local Mouse = player:GetMouse()
local selecting = false
local InitPos = Vector2.new()
local Plot = workspace.Creation[player.Name]

Mouse.Button1Down:Connect(function()
	selecting = true
	InitPos = Vector2.new(Mouse.X,Mouse.Y)
end)

Mouse.Button1Up:Connect(function()
	selecting = false
	SelectFrame.Visible = false

	for i,v in pairs(Parts) do
		if v~= nil and v.Parent ~= nil then
			local args = {
				[1] = v.Parent
			}

			game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Events.Delete:FireServer(unpack(args))
		end
	end
end)

Mouse.Move:Connect(function()
	if selecting then
		SelectFrame.Visible = true
		SelectFrame.Position = UDim2.new(0,InitPos.X,0,InitPos.Y)
		SelectFrame.Size = UDim2.new(0,Mouse.X-InitPos.X,0,Mouse.Y-InitPos.Y)
		for i,v in pairs(Parts) do
			if v:FindFirstChild("SelectionBox") then
				v:FindFirstChild("SelectionBox"):Destroy()
			end
		end
		Parts = {}
		for i,v in pairs(Plot:GetChildren()) do
			local worldPoint = v.Position
			local vector, inViewport = camera:WorldToViewportPoint(worldPoint)
			if inViewport then
				if vector.X > SelectFrame.Position.X.Offset and vector.X < SelectFrame.Position.X.Offset+SelectFrame.Size.X.Offset then
					if vector.Y > SelectFrame.Position.Y.Offset and vector.Y < SelectFrame.Position.Y.Offset+SelectFrame.Size.Y.Offset then
						table.insert(Parts,v.Parent)
						local selectionbox = Selecionbox:Clone()
						selectionbox.Parent = v
						selectionbox.Adornee = v
					end
				end
			end
		end
	end
end)



