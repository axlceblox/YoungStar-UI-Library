--// YoungStar UI Library

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- =========================
-- CREATE WINDOW
-- =========================
function Library:CreateWindow(titleText)
	local player = Players.LocalPlayer

	local gui = Instance.new("ScreenGui")
	gui.Name = "YoungStarUI"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	-- Main frame
	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 260, 0, 40)
	main.Position = UDim2.new(0.5, -130, 0.25, 0)
	main.BackgroundColor3 = Color3.fromRGB(20,20,20)
	main.Parent = gui
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -40, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = titleText or "YoungStar's Lib"
	title.TextColor3 = Color3.new(1,1,1)
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = main

	-- Arrow
	local arrow = Instance.new("TextButton")
	arrow.Size = UDim2.new(0, 30, 0, 30)
	arrow.Position = UDim2.new(1, -35, 0.5, -15)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = Color3.new(1,1,1)
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 18
	arrow.Parent = main

	-- Content
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 0, 0)
	content.Position = UDim2.new(0, 0, 1, 0)
	content.BackgroundColor3 = Color3.fromRGB(25,25,25)
	content.Visible = false
	content.Parent = main
	Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

	local layout = Instance.new("UIListLayout")
	layout.Parent = content

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	content.ChildAdded:Connect(function()
		task.wait()
		content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	-- Dragging
	local dragging, dragStart, startPos
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UIS.InputEnded:Connect(function()
		dragging = false
	end)

	-- Toggle open
	arrow.MouseButton1Click:Connect(function()
		content.Visible = not content.Visible
		arrow.Text = content.Visible and "▲" or "▼"
	end)

	-- Info label (always last)
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(1, 0, 0, 26)
	infoLabel.BackgroundTransparency = 1
	infoLabel.TextWrapped = true
	infoLabel.TextColor3 = Color3.fromRGB(170,170,170)
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextSize = 12
	infoLabel.Visible = false
	infoLabel.Parent = content

	-- Window object
	local Window = {}

	-- =========================
	-- CONTROLS
	-- =========================
	function Window:AddButton(text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 35)
		btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		btn.Text = text
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.Parent = content
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		btn.MouseButton1Click:Connect(function()
			if callback then callback() end
		end)
	end

	function Window:AddToggle(text, callback)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 40)
		frame.BackgroundTransparency = 1
		frame.Parent = content

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.7, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame

		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.new(0, 28, 0, 28)
		toggle.Position = UDim2.new(1, -35, 0.5, -14)
		toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
		toggle.Text = ""
		toggle.Parent = frame
		Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

		local state = false
		toggle.MouseButton1Click:Connect(function()
			state = not state
			toggle.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(60,60,60)
			if callback then callback(state) end
		end)
	end

	function Window:AddSlider(text, min, max, callback)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 50)
		frame.BackgroundTransparency = 1
		frame.Parent = content

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 20)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame

		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(1, 0, 0, 8)
		bar.Position = UDim2.new(0, 0, 0, 30)
		bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
		bar.Parent = frame
		Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(200,200,200)
		fill.Parent = bar
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

		local dragging = false
		local value = min

		local function update(input)
			local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			value = math.floor(min + (max - min) * percent)
			fill.Size = UDim2.new(percent, 0, 1, 0)
			label.Text = text .. " " .. value
			if callback then callback(value) end
		end

		bar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				update(i)
			end
		end)

		UIS.InputChanged:Connect(function(i)
			if dragging then update(i) end
		end)

		UIS.InputEnded:Connect(function()
			dragging = false
		end)
	end

	function Window:AddDropdown(text, options, callback)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 35)
		holder.BackgroundTransparency = 1
		holder.Parent = content

		local selected = options[1]
		local open = false

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 35)
		btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		btn.Text = text .. ": " .. selected
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.Parent = holder
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		local list = Instance.new("Frame")
		list.Size = UDim2.new(1, 0, 0, #options * 30)
		list.Position = UDim2.new(0, 0, 1, 5)
		list.BackgroundColor3 = Color3.fromRGB(35,35,35)
		list.Visible = false
		list.Parent = holder
		Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)

		local lay = Instance.new("UIListLayout", list)

		for _, opt in ipairs(options) do
			local o = Instance.new("TextButton")
			o.Size = UDim2.new(1, 0, 0, 30)
			o.BackgroundColor3 = Color3.fromRGB(45,45,45)
			o.Text = tostring(opt)
			o.TextColor3 = Color3.new(1,1,1)
			o.Font = Enum.Font.Gotham
			o.TextSize = 14
			o.Parent = list

			o.MouseButton1Click:Connect(function()
				selected = opt
				btn.Text = text .. ": " .. opt
				list.Visible = false
				open = false
				if callback then callback(opt) end
			end)
		end

		btn.MouseButton1Click:Connect(function()
			open = not open
			list.Visible = open
		end)
	end

	function Window:SetInfo(enabled, text)
		infoLabel.Visible = enabled
		if enabled then
			infoLabel.Text = tostring(text)
		end
	end

	return Window
end

return Library
