--// YoungStar UI Library
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Library = {}
Library.__index = Library

--// UI THEME
local THEME = {
	Background = Color3.fromRGB(28, 28, 30),
	Container  = Color3.fromRGB(36, 36, 40),
	Stroke     = Color3.fromRGB(58, 58, 62),
	Accent     = Color3.fromRGB(96, 165, 250),
	TextMain   = Color3.fromRGB(235, 235, 235),
	TextDim    = Color3.fromRGB(180, 180, 180)
}

local FONT_MAIN = Enum.Font.Gotham
local FONT_BOLD = Enum.Font.GothamBold

--// DRAG FUNCTION
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

-- =========================
-- CREATE WINDOW
-- =========================
function Library:CreateWindow(titleText)
	local player = Players.LocalPlayer

	-- Check for existing UI and destroy it to prevent duplicates
	if player:WaitForChild("PlayerGui"):FindFirstChild("YoungStarUI") then
		player.PlayerGui.YoungStarUI:Destroy()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "YoungStarUI"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Important for dropdowns
	gui.Parent = player:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Name = "MainFrame"
	main.Size = UDim2.new(0, 260, 0, 40) -- Initial size (header only)
	main.Position = UDim2.new(0.5, -130, 0.3, 0)
	main.BackgroundColor3 = THEME.Background
	main.BorderSizePixel = 0
	main.AutomaticSize = Enum.AutomaticSize.Y -- [FIX] This makes the background grow!
	main.ClipsDescendants = false -- Allow dropdowns to go outside if needed
	main.Parent = gui
	
	-- Apply Drag
	MakeDraggable(main, main)

	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

	-- Header Elements
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -40, 0, 40)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = titleText or "YoungStar UI"
	title.TextColor3 = THEME.TextMain
	title.Font = FONT_BOLD
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = main

	local arrow = Instance.new("TextButton")
	arrow.Name = "ToggleArrow"
	arrow.Size = UDim2.new(0, 30, 0, 30)
	arrow.Position = UDim2.new(1, -35, 0, 5)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = THEME.TextMain
	arrow.Font = FONT_BOLD
	arrow.TextSize = 18
	arrow.Parent = main

	local content = Instance.new("Frame")
	content.Name = "ContentFrame"
	content.Size = UDim2.new(1, 0, 0, 0) -- Start at 0 size
	content.Position = UDim2.new(0, 0, 0, 40) -- Start below header
	content.BackgroundColor3 = THEME.Container
	content.BackgroundTransparency = 1
	content.Visible = false
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = content

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingTop = UDim.new(0, 0)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.Parent = content

	arrow.MouseButton1Click:Connect(function()
		content.Visible = not content.Visible
		arrow.Text = content.Visible and "▲" or "▼"
	end)

	-- =========================
	-- HELPERS
	-- =========================
	local function hover(btn, base)
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {
				BackgroundColor3 = THEME.Stroke
			}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {
				BackgroundColor3 = base
			}):Play()
		end)
	end

	-- =========================
	-- CONTROLS
	-- =========================
	local Window = {}

	-- BUTTON
	function Window:AddButton(text, callback)
		local btn = Instance.new("TextButton")
		btn.Name = "Button"
		btn.Size = UDim2.new(1, 0, 0, 36)
		btn.BackgroundColor3 = THEME.Container
		btn.Text = text
		btn.TextColor3 = THEME.TextMain
		btn.Font = FONT_MAIN
		btn.TextSize = 14
		btn.Parent = content
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		hover(btn, THEME.Container)

		btn.MouseButton1Click:Connect(function()
			if callback then callback() end
		end)
	end

	-- TOGGLE
	function Window:AddToggle(text, callback)
		local frame = Instance.new("Frame")
		frame.Name = "ToggleFrame"
		frame.Size = UDim2.new(1, 0, 0, 36)
		frame.BackgroundTransparency = 1
		frame.Parent = content

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -50, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = THEME.TextMain
		label.Font = FONT_MAIN
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame

		local toggle = Instance.new("Frame")
		toggle.Size = UDim2.new(0, 40, 0, 20)
		toggle.Position = UDim2.new(1, -40, 0.5, -10)
		toggle.BackgroundColor3 = THEME.Stroke
		toggle.Parent = frame
		Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 16, 0, 16)
		knob.Position = UDim2.new(0, 2, 0.5, -8)
		knob.BackgroundColor3 = THEME.TextMain
		knob.Parent = toggle
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

		local state = false
		local function toggleLogic()
			state = not state
			TweenService:Create(toggle, TweenInfo.new(0.15), {
				BackgroundColor3 = state and THEME.Accent or THEME.Stroke
			}):Play()
			TweenService:Create(knob, TweenInfo.new(0.15), {
				Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			}):Play()
			if callback then callback(state) end
		end

		-- Make clicking the text also toggle
		local trigger = Instance.new("TextButton")
		trigger.Size = UDim2.new(1, 0, 1, 0)
		trigger.BackgroundTransparency = 1
		trigger.Text = ""
		trigger.Parent = frame
		trigger.MouseButton1Click:Connect(toggleLogic)
	end

	-- SLIDER
	function Window:AddSlider(text, min, max, callback)
		local frame = Instance.new("Frame")
		frame.Name = "SliderFrame"
		frame.Size = UDim2.new(1, 0, 0, 48)
		frame.BackgroundTransparency = 1
		frame.Parent = content

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 18)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = THEME.TextMain
		label.Font = FONT_MAIN
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = frame

		local valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(0, 40, 0, 18)
		valueLabel.Position = UDim2.new(1, -40, 0, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.TextColor3 = THEME.TextDim
		valueLabel.Font = FONT_MAIN
		valueLabel.TextSize = 13
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Parent = frame

		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(1, 0, 0, 8)
		bar.Position = UDim2.new(0, 0, 0, 30)
		bar.BackgroundColor3 = THEME.Stroke
		bar.Parent = frame
		Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = THEME.Accent
		fill.Parent = bar
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

		local trigger = Instance.new("TextButton")
		trigger.Size = UDim2.new(1, 0, 1, 0)
		trigger.BackgroundTransparency = 1
		trigger.Text = ""
		trigger.Parent = bar

		local dragging = false

		local function update(input)
			local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * percent)
			fill.Size = UDim2.new(percent, 0, 1, 0)
			valueLabel.Text = tostring(value)
			if callback then callback(value) end
		end

		trigger.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				update(i)
			end
		end)

		UIS.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				update(i)
			end
		end)

		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	-- DROPDOWN
	function Window:AddDropdown(text, options, callback)
		local holder = Instance.new("Frame")
		holder.Name = "DropdownHolder"
		holder.Size = UDim2.new(1, 0, 0, 35)
		holder.BackgroundTransparency = 1
		holder.Parent = content
		holder.ZIndex = 5 -- High ZIndex to sit on top of things below

		local selected = options[1]
		local open = false

		local btn = Instance.new("TextButton")
		btn.Name = "DropdownBtn"
		btn.Size = UDim2.new(1, 0, 0, 35)
		btn.BackgroundColor3 = THEME.Container
		btn.Text = text .. ": " .. selected
		btn.TextColor3 = THEME.TextMain
		btn.Font = FONT_MAIN
		btn.TextSize = 14
		btn.Parent = holder
		btn.ZIndex = 6
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		local list = Instance.new("Frame")
		list.Name = "List"
		list.Size = UDim2.new(1, 0, 0, #options * 30)
		list.Position = UDim2.new(0, 0, 1, 6)
		list.BackgroundColor3 = THEME.Container
		list.Visible = false
		list.Parent = holder
		list.ZIndex = 10 -- Highest ZIndex
		Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)

		local lay = Instance.new("UIListLayout")
		lay.Parent = list

		for _, opt in ipairs(options) do
			local o = Instance.new("TextButton")
			o.Size = UDim2.new(1, 0, 0, 30)
			o.BackgroundColor3 = THEME.Container
			o.Text = tostring(opt)
			o.TextColor3 = THEME.TextMain
			o.Font = FONT_MAIN
			o.TextSize = 14
			o.Parent = list
			o.ZIndex = 11

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

	return Window
end

return Library

