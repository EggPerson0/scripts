
local SelectFrame = Instance.new("Frame")
local Selecionbox = Instance.new("SelectionBox")


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


local camera = workspace.CurrentCamera
print("Executed")
local player = game.Players.LocalPlayer
local Parts = {}
local Mouse = player:GetMouse()
local selecting = false
local InitPos = Vector2.new()
local Plot = workspace.Creations[player.Name]

Mouse.Button1Down:Connect(function()
	print("Selecting")
	selecting = true
	local position =  camera:WorldToViewportPoint(Mouse.Hit.Position)
	InitPos = Vector2.new(position.X,position.Y)
end)

Mouse.Button1Up:Connect(function()
	selecting = false
	SelectFrame.Visible = false
	print("DoneSelecting")
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
		print("Moving and Selecting")
		local position =  camera:WorldToViewportPoint(Mouse.Hit.Position)
		SelectFrame.Visible = true
		SelectFrame.Position = UDim2.new(0,InitPos.X,0,InitPos.Y)
		SelectFrame.Size = UDim2.new(0,position.X-InitPos.X,0,position.Y-InitPos.Y)
		for i,v in pairs(Parts) do
			if v:FindFirstChild("SelectionBox") then
				v:FindFirstChild("SelectionBox"):Destroy()
			end
		end
		Parts = {}
		for i,v in pairs(Plot:GetChildren()) do
			local worldPoint = v.Part.Position
			local vector, inViewport = camera:WorldToViewportPoint(worldPoint)
			if inViewport then
				if vector.X > SelectFrame.Position.X.Offset and vector.X < SelectFrame.Position.X.Offset+SelectFrame.Size.X.Offset then
					if vector.Y > SelectFrame.Position.Y.Offset and vector.Y < SelectFrame.Position.Y.Offset+SelectFrame.Size.Y.Offset then
						table.insert(Parts,v.Part)
						local selectionbox = Selecionbox:Clone()
						selectionbox.Parent = v.Part
						selectionbox.Adornee = v.Part
					end
				end
			end
		end
	end
end)



