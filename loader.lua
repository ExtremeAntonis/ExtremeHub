-- local CoreGui = game:GetService("CoreGui")
-- local TweenService = game:GetService("TweenService")

-- for i,v in CoreGui:GetChildren() do
-- 	if v.Name == "KeySystem" then
-- 		v:Destroy()
-- 	end
-- end

-- -- GUI to Lua 
-- -- Version: 0.0.3

-- -- Instances:

-- local KeySystem = Instance.new("ScreenGui")
-- local Main_1 = Instance.new("ImageButton")
-- local Header_1 = Instance.new("Frame")
-- local Left_1 = Instance.new("Frame")
-- local UIListLayout_1 = Instance.new("UIListLayout")
-- local Title_1 = Instance.new("TextLabel")
-- local Frame_1 = Instance.new("Frame")
-- local Right_1 = Instance.new("Frame")
-- local Close_1 = Instance.new("ImageButton")
-- local Body_1 = Instance.new("Frame")
-- local Left_2 = Instance.new("Frame")
-- local UIListLayout_2 = Instance.new("UIListLayout")
-- local ProfilePicture_1 = Instance.new("ImageLabel")
-- local UICorner_1 = Instance.new("UICorner")
-- local Right_2 = Instance.new("Frame")
-- local KeyTextBox_1 = Instance.new("TextBox")
-- local UICorner_2 = Instance.new("UICorner")
-- local UIStroke_1 = Instance.new("UIStroke")
-- local ButtonContainer_1 = Instance.new("Frame")
-- local UIListLayout_3 = Instance.new("UIListLayout")
-- local Submit_1 = Instance.new("TextButton")
-- local UICorner_3 = Instance.new("UICorner")
-- local Getkey_1 = Instance.new("TextButton")
-- local UICorner_4 = Instance.new("UICorner")
-- local Discord_1 = Instance.new("TextButton")
-- local UICorner_5 = Instance.new("UICorner")
-- local UIListLayout_4 = Instance.new("UIListLayout")
-- local UIListLayout_5 = Instance.new("UIListLayout")
-- local UIGradient_1 = Instance.new("UIGradient")
-- local UICorner_6 = Instance.new("UICorner")

-- -- Properties:
-- KeySystem.Name = "KeySystem"
-- KeySystem.Parent = game:GetService("CoreGui")
-- KeySystem.Enabled = false

-- Main_1.Name = "Main"
-- Main_1.Parent = KeySystem
-- Main_1.Active = true
-- Main_1.AnchorPoint = Vector2.new(0.5, 0.5)
-- Main_1.AutoButtonColor = false
-- Main_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Main_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Main_1.BorderSizePixel = 0
-- Main_1.Position = UDim2.new(0.5, 0,0.5, 0)
-- Main_1.Size = UDim2.new(0, 550,0, 330)
-- Main_1.ClipsDescendants = true
-- Main_1.Image = "rbxassetid://4641149554"
-- Main_1.ImageColor3 = Color3.fromRGB(20,20,20)
-- Main_1.ImageTransparency = 1
-- Main_1.ScaleType = Enum.ScaleType.Slice
-- Main_1.SliceCenter = Rect.new(4, 4, 296, 296)

-- Header_1.Name = "Header"
-- Header_1.Parent = Main_1
-- Header_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Header_1.BackgroundTransparency = 1
-- Header_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Header_1.Position = UDim2.new(-1.10973012e-07, 0,0, 0)
-- Header_1.Size = UDim2.new(0, 550,0, 35)

-- Left_1.Name = "Left"
-- Left_1.Parent = Header_1
-- Left_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Left_1.BackgroundTransparency = 1
-- Left_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Left_1.BorderSizePixel = 0
-- Left_1.Size = UDim2.new(0, 275,0, 35)

-- UIListLayout_1.Parent = Left_1
-- UIListLayout_1.Padding = UDim.new(0,5)
-- UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
-- UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
-- UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

-- Title_1.Name = "Title"
-- Title_1.Parent = Left_1
-- Title_1.AutomaticSize = Enum.AutomaticSize.XY
-- Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Title_1.BackgroundTransparency = 1
-- Title_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Title_1.BorderSizePixel = 0
-- Title_1.LayoutOrder = 1
-- Title_1.Position = UDim2.new(0.0327272713, 0,0.25, 0)
-- Title_1.Size = UDim2.new(0, 115,0, 0)
-- Title_1.Font = Enum.Font.GothamBlack
-- Title_1.Text = "EXTREMEHUB.XYZ"
-- Title_1.TextColor3 = Color3.fromRGB(255,255,255)
-- Title_1.TextSize = 20

-- Frame_1.Parent = Left_1
-- Frame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Frame_1.BackgroundTransparency = 1
-- Frame_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Frame_1.Size = UDim2.new(0, 5,0, 1)

-- Right_1.Name = "Right"
-- Right_1.Parent = Header_1
-- Right_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Right_1.BackgroundTransparency = 2
-- Right_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Right_1.BorderSizePixel = 0
-- Right_1.Position = UDim2.new(0.500000119, 0,0, 0)
-- Right_1.Size = UDim2.new(0, 275,0, 35)

-- Close_1.Name = "Close"
-- Close_1.Parent = Right_1
-- Close_1.Active = true
-- Close_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Close_1.BackgroundTransparency = 1
-- Close_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Close_1.Position = UDim2.new(0.899999976, 0,0.271428585, 0)
-- Close_1.Size = UDim2.new(0, 15,0, 15)
-- Close_1.Image = "rbxassetid://9990517834"

-- Body_1.Name = "Body"
-- Body_1.Parent = Main_1
-- Body_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Body_1.BackgroundTransparency = 1
-- Body_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Body_1.BorderSizePixel = 0
-- Body_1.Position = UDim2.new(-0.00181818183, 0,0.121212125, 0)
-- Body_1.Size = UDim2.new(0, 550,0, 290)

-- Left_2.Name = "Left"
-- Left_2.Parent = Body_1
-- Left_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Left_2.BackgroundTransparency = 1
-- Left_2.BorderColor3 = Color3.fromRGB(27,42,53)
-- Left_2.BorderSizePixel = 0
-- Left_2.Size = UDim2.new(0, 200,0, 290)

-- UIListLayout_2.Parent = Left_2
-- UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
-- UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
-- UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

-- ProfilePicture_1.Name = "ProfilePicture"
-- ProfilePicture_1.Parent = Left_2
-- ProfilePicture_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- ProfilePicture_1.BackgroundTransparency = 1
-- ProfilePicture_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- ProfilePicture_1.Position = UDim2.new(0.100000001, 0,0.18965517, 0)
-- ProfilePicture_1.Size = UDim2.new(0, 170,0, 170)
-- ProfilePicture_1.Image = ""

-- UICorner_1.Parent = ProfilePicture_1
-- UICorner_1.CornerRadius = UDim.new(0,100)

-- Right_2.Name = "Right"
-- Right_2.Parent = Body_1
-- Right_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- Right_2.BackgroundTransparency = 1
-- Right_2.BorderColor3 = Color3.fromRGB(27,42,53)
-- Right_2.BorderSizePixel = 0
-- Right_2.Position = UDim2.new(0.431818187, 0,0, 0)
-- Right_2.Size = UDim2.new(0, 350,0, 290)

-- KeyTextBox_1.Name = "KeyTextBox"
-- KeyTextBox_1.Parent = Right_2
-- KeyTextBox_1.Active = true
-- KeyTextBox_1.BackgroundColor3 = Color3.fromRGB(30,30,30)
-- KeyTextBox_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- KeyTextBox_1.Position = UDim2.new(0.0328571424, 0,0.444827586, 0)
-- KeyTextBox_1.Size = UDim2.new(0, 325,0, 32)
-- KeyTextBox_1.ClipsDescendants = true
-- KeyTextBox_1.Font = Enum.Font.Gotham
-- KeyTextBox_1.PlaceholderColor3 = Color3.fromRGB(255,255,255)
-- KeyTextBox_1.PlaceholderText = "Insert Key Here"
-- KeyTextBox_1.Text = ""
-- KeyTextBox_1.TextColor3 = Color3.fromRGB(255,255,255)
-- KeyTextBox_1.TextSize = 14
-- KeyTextBox_1.TextStrokeColor3 = Color3.fromRGB(255,255,255)

-- UICorner_2.Parent = KeyTextBox_1
-- UICorner_2.CornerRadius = UDim.new(0,4)

-- UIStroke_1.Parent = KeyTextBox_1
-- UIStroke_1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
-- UIStroke_1.Color = Color3.fromRGB(87,242,135)
-- UIStroke_1.Transparency = 1
-- UIStroke_1.Thickness = 0.6000000238418579

-- ButtonContainer_1.Name = "ButtonContainer"
-- ButtonContainer_1.Parent = Right_2
-- ButtonContainer_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
-- ButtonContainer_1.BackgroundTransparency = 1
-- ButtonContainer_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- ButtonContainer_1.LayoutOrder = 1
-- ButtonContainer_1.Position = UDim2.new(0.357142866, 0,0.494827598, 0)
-- ButtonContainer_1.Size = UDim2.new(0, 325,0, 32)

-- UIListLayout_3.Parent = ButtonContainer_1
-- UIListLayout_3.Padding = UDim.new(0,5)
-- UIListLayout_3.FillDirection = Enum.FillDirection.Horizontal
-- UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
-- UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
-- UIListLayout_3.VerticalAlignment = Enum.VerticalAlignment.Center

-- Submit_1.Name = "Submit"
-- Submit_1.Parent = ButtonContainer_1
-- Submit_1.Active = true
-- Submit_1.AutoButtonColor = false
-- Submit_1.BackgroundColor3 = Color3.fromRGB(30,30,30)
-- Submit_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Submit_1.BorderSizePixel = 0
-- Submit_1.Position = UDim2.new(0.333846152, 0,-0.28125, 0)
-- Submit_1.Size = UDim2.new(0, 105,0, 32)
-- Submit_1.Font = Enum.Font.GothamBold
-- Submit_1.Text = "Submit"
-- Submit_1.TextColor3 = Color3.fromRGB(255,255,255)
-- Submit_1.TextSize = 14

-- UICorner_3.Parent = Submit_1
-- UICorner_3.CornerRadius = UDim.new(0,4)

-- Getkey_1.Name = "Getkey"
-- Getkey_1.Parent = ButtonContainer_1
-- Getkey_1.Active = true
-- Getkey_1.AutoButtonColor = false
-- Getkey_1.BackgroundColor3 = Color3.fromRGB(30,30,30)
-- Getkey_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Getkey_1.BorderSizePixel = 0
-- Getkey_1.LayoutOrder = 1
-- Getkey_1.Position = UDim2.new(0.333846152, 0,-0.28125, 0)
-- Getkey_1.Size = UDim2.new(0, 105,0, 32)
-- Getkey_1.Font = Enum.Font.GothamBold
-- Getkey_1.Text = "Get Key"
-- Getkey_1.TextColor3 = Color3.fromRGB(255,255,255)
-- Getkey_1.TextSize = 14

-- UICorner_4.Parent = Getkey_1
-- UICorner_4.CornerRadius = UDim.new(0,4)

-- Discord_1.Name = "Discord"
-- Discord_1.Parent = ButtonContainer_1
-- Discord_1.Active = true
-- Discord_1.AutoButtonColor = false
-- Discord_1.BackgroundColor3 = Color3.fromRGB(30,30,30)
-- Discord_1.BorderColor3 = Color3.fromRGB(27,42,53)
-- Discord_1.BorderSizePixel = 0
-- Discord_1.LayoutOrder = 2
-- Discord_1.Position = UDim2.new(0.333846152, 0,-0.28125, 0)
-- Discord_1.Size = UDim2.new(0, 105,0, 32)
-- Discord_1.Font = Enum.Font.GothamBold
-- Discord_1.Text = "Discord"
-- Discord_1.TextColor3 = Color3.fromRGB(255,255,255)
-- Discord_1.TextSize = 14

-- UICorner_5.Parent = Discord_1
-- UICorner_5.CornerRadius = UDim.new(0,4)

-- UIListLayout_4.Parent = Right_2
-- UIListLayout_4.Padding = UDim.new(0,5)
-- UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
-- UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
-- UIListLayout_4.VerticalAlignment = Enum.VerticalAlignment.Center

-- UIListLayout_5.Parent = Body_1
-- UIListLayout_5.FillDirection = Enum.FillDirection.Horizontal
-- UIListLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Center
-- UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
-- UIListLayout_5.VerticalAlignment = Enum.VerticalAlignment.Center

-- UIGradient_1.Parent = Main_1
-- UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(63, 63, 63))}
-- UIGradient_1.Offset = Vector2.new(1, 0)
-- UIGradient_1.Rotation = 300

-- UICorner_6.Parent = Main_1
-- UICorner_6.CornerRadius = UDim.new(0,10)

-- local function lclAxtDFzmWWuHOZ()
-- local script = Instance.new("LocalScript", KeySystem)

-- local Main = script.Parent.Main
------------------------------------------------------------------------------------------------------------------------------------
--Scripts
	local baseScriptURL = "https://raw.githubusercontent.com/ExtremeAntonis/Roblox-Scripts/main/"

	local scriptMappings = {
		[680750021] = "case-clicker.lua",
		[7429434108] = "anime-tappers.lua",
		[5852812686] = "candy-clicking-simulator.lua",
		[6075756195] = "clicker-havoc.lua",
		[7444263453] = "jetpack-jumpers.lua",
		[6677985923] = "millionaire-empire-tycoon.lua",
		[7277614831] = "candy-eating-simulator.lua",
		[4058282580] = "boxing-simulator.lua",
		[2619187362] = "super-power-fighting-simulator.lua",
		[7114796110] = "anime-training-simulator.lua",
		[2533391464] = "snowman-simulator.lua",
		[5264342538] = "cems_script.lua",
		[7681451450] = "anime-simulator-x.lua",
		[7586443938] = "anime_stars_simulator.lua",
		[7065731541] = "speedman-simulator.lua",
		[6875469709] = "strongest-punch-simulator.lua",
		[3823781113] = "saber-simulator.lua",
		[3956818381] = "ninja-legends.lua",
		[7244314500] = "fightman-simulator.lua",
		[3102144307] = "anime-clicker-simulator.lua",
		[7560156054] = "clicker-simulator.lua",
		[8357510970] = "anime-punching-simulator.lua",
		[8540346411] = "rebirth-champions-x.lua",
		[6284583030] = "pet-simulator-x.lua",
		[10321372166] = "pet-simulator-x.lua",
		[3101667897] = "legends-of-speed.lua",
		[9281034297] = "goal-kick-simulator.lua",
		[9551640993] = "mining-simulator-2.lua",
		[8571633166] = "pet-gods-simulator.lua",
		[10675066724] = "slime-tower-tycoon.lua",
	}

local placeId = game.PlaceId

local function scriptExists(placeId)
	return scriptMappings[placeId] ~= nil
end

local function runScript(placeId)
	if scriptExists(placeId) then
		local scriptFilename = scriptMappings[placeId]
		local scriptURL = baseScriptURL .. scriptFilename
		local script = game:HttpGet(scriptURL)
		return loadstring(script)()
	end
end

if scriptExists(placeId) then
	_G.keyFound = true
	runScript(placeId)
end

-- ------------------------------------------------------------------------------------------------------------------------------------
-- --Make UI Draggable
-- local UserInputService = game:GetService("UserInputService")
-- local frame = Main
-- local dragToggle = false
-- local dragSpeed = .3
-- local dragStart = nil
-- local startPos = nil

-- local function updateInput(input)
-- 	local delta = input.Position - dragStart
-- 	local position = UDim2.new(
-- 		startPos.X.Scale,
-- 		startPos.X.Offset + delta.X,
-- 		startPos.Y.Scale,
-- 		startPos.Y.Offset + delta.Y
-- 	)
-- 	game:GetService("TweenService"):Create(Main, TweenInfo.new(dragSpeed), { Position = position }):Play()
-- end

-- frame.Header.InputBegan:Connect(function(input)
-- 	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
-- 		dragToggle = true
-- 		dragStart = input.Position
-- 		startPos = Main.Position

-- 		input.Changed:Connect(function()
-- 			if input.UserInputState == Enum.UserInputState.End then
-- 				dragToggle = false
-- 			end
-- 		end)
-- 	end
-- end)

-- UserInputService.InputChanged:Connect(function(input)
-- 	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
-- 		if dragToggle then
-- 			updateInput(input)
-- 		end
-- 	end
-- end)
-- ------------------------------------------------------------------------------------------------------------------------------------
-- --Profile Picture
-- local Players = game:GetService("Players")
-- local player = Players.LocalPlayer

-- local userId = player.UserId
-- local thumbType = Enum.ThumbnailType.HeadShot
-- local thumbSize = Enum.ThumbnailSize.Size420x420
-- local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
-- local imageLabel = Main.Body.Left.ProfilePicture
-- imageLabel.Image = content
-- ------------------------------------------------------------------------------------------------------------------------------------
-- --Close Button
-- Main.Header.Right.Close.MouseButton1Down:Connect(function()
-- 	local endSize = UDim2.new(0, 0, 0, 0)
-- 	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
-- 	local tween = TweenService:Create(Main, tweenInfo, {Size = endSize})

-- 	tween.Completed:Connect(function()
-- 		CoreGui.KeySystem:Destroy()
-- 	end)

-- 	tween:Play()
-- end)
-- ------------------------------------------------------------------------------------------------------------------------------------
-- --Discord Button
-- Main.Body.Right.ButtonContainer.Discord.MouseButton1Down:Connect(function()
-- 	setclipboard("discord.gg/yWDJrpTjRP")
-- 	Main.Body.Right.KeyTextBox.Text = "Set to clipboard (discord.gg/yWDJrpTjRP)"
-- end)
-- ------------------------------------------------------------------------------------------------------------------------------------
-- --Get Key Button
-- Main.Body.Right.ButtonContainer.Getkey.MouseButton1Down:Connect(function()
-- 	setclipboard("extremehub.xyz/getkey")
-- 	Main.Body.Right.KeyTextBox.Text = "Set to clipboard (extremehub.xyz/getkey)"
-- end)
-- ------------------------------------------------------------------------------------------------------------------------------------
-- local APIURL = "https://extremehub.xyz/api/check/"

-- local function validateKey(key)
--     -- Check for spaces in the key
--     if key:match("%s") then
--         return false, "Key should not contain spaces"
--     end

--     -- Check the key format
--     if not key:match("^[A-Z0-9]+$") or #key ~= 32 then
--         return false, "Invalid key format"
--     end

--     local url = APIURL .. key
--     local success, response = pcall(game.HttpGet, game, url)

--     if success and response == "true" then
--         return true
--     else
--         return false, "Key validation failed"
--     end
-- end

-- -- Is Existing Key Active
-- local keyTextBox = Main.Body.Right.KeyTextBox

-- function isExistingKeyActive()
-- 	if isfolder("ExtremeHUB") and isfile("ExtremeHUB\Key.txt") then
-- 		local key = readfile("ExtremeHUB\Key.txt")
-- 		if validateKey(key) then
-- 			return true
-- 		else
-- 			return false
-- 		end
-- 	end
-- end

-- if isExistingKeyActive() then
-- 	if scriptExists(placeId) then
-- 		keyTextBox.UIStroke.Color = Color3.fromRGB(100, 255, 150)
-- 		keyTextBox.UIStroke.Transparency = 0
-- 		_G.keyFound = true
-- 		keyTextBox.Text = "Access Granted"
-- 		task.wait(3)
-- 		runScript(placeId)
-- 		local endSize = UDim2.new(0, 0, 0, 0)
-- 		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
-- 		local tween = TweenService:Create(Main, tweenInfo, {Size = endSize})
-- 		tween.Completed:Connect(function()
-- 			script.Parent:Destroy()
-- 		end)
-- 		tween:Play()
-- 	else
-- 		keyTextBox.UIStroke.Color = Color3.fromRGB(255, 50, 60)
-- 		keyTextBox.UIStroke.Transparency = 0
-- 		keyTextBox.Text = "Game Not Supported"
-- 		task.wait(3)
-- 		keyTextBox.UIStroke.Transparency = 1
-- 	end
-- end
-- ------------------------------------------------------------------------------------------------------------------------------------
-- -- Submit Button
-- Main.Body.Right.ButtonContainer.Submit.MouseButton1Down:Connect(function()
-- 	local isValid, errorReason = validateKey(keyTextBox.Text)
-- 	if isValid then
-- 		if scriptExists(placeId) then
-- 			keyTextBox.UIStroke.Color = Color3.fromRGB(100, 255, 150)
-- 			keyTextBox.UIStroke.Transparency = 0
-- 			_G.keyFound = true
-- 			keyTextBox.Text = "Access Granted"
-- 			writefile("ExtremeHUB\\Key.txt", keyTextBox.Text)
-- 			task.wait(2)
-- 			local endSize = UDim2.new(0, 0, 0, 0)
-- 			local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
-- 			local tween = TweenService:Create(Main, tweenInfo, {Size = endSize})
-- 			tween.Completed:Connect(function()
-- 				script.Parent:Destroy()
--                 runScript(placeId)
-- 			end)
-- 			tween:Play()
-- 		else
-- 			keyTextBox.UIStroke.Color = Color3.fromRGB(255, 50, 60)
-- 			keyTextBox.UIStroke.Transparency = 0
-- 			keyTextBox.Text = "Game Not Supported"
-- 			task.wait(2)
--             keyTextBox.Text = ""
-- 			keyTextBox.UIStroke.Transparency = 1
--         end
--     else
--     	print("Key is invalid: " .. errorReason)
--         keyTextBox.UIStroke.Color = Color3.fromRGB(255, 50, 60)
--         keyTextBox.UIStroke.Transparency = 0
--         keyTextBox.Text = "Access Denied"
--         task.wait(2)
--         keyTextBox.Text = ""
--         keyTextBox.UIStroke.Transparency = 1
-- 	end
-- end)
-- end
-- coroutine.wrap(lclAxtDFzmWWuHOZ)()

-- KeySystem.Enabled = true