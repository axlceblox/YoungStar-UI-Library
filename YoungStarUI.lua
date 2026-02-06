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

-- =========================
-- CREATE WINDOW
-- =========================
function Library:CreateWindow(titleText)
	local player = Players.LocalPlayer

	local gui = Instance.new("ScreenGui")
	gui.Name = "YoungStarUI"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 260, 0, 40)
	main.Position = UDim2.new(0.5, -130, 0.25, 0)
	main.BackgroundColor3 = THEME.Background
	main.Parent = gui
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -40, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = titleText or "YoungStar UI"
	title.TextColor3 = THEME.TextMain
	title.Font = FONT_BOLD
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = main

	local arrow = Instance.new("TextButton")
	arrow.Size = UDim2.new(0, 30, 0, 30)
	arrow.Position = UDim2.new(1, -35, 0.5, -15)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = THEME.TextMain
	arrow.Font = FONT_BOLD
	arrow.TextSize = 18
	arrow.Parent = main

	local content = Instance.new("Frame")
	content.Position = UDim2.new(0, 0, 1, 0)
	content.BackgroundColor3 = THEME.Container
	content.Visible = false
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Parent = main
	Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = content

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
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

	-- TOGGLE (UPGRADED)
	function Window:AddToggle(text, callback)
		local frame = Instance.new("Frame")
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
		toggle.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				state = not state
				TweenService:Create(toggle, TweenInfo.new(0.15), {
					BackgroundColor3 = state and THEME.Accent or THEME.Stroke
				}):Play()
				TweenService:Create(knob, TweenInfo.new(0.15), {
					Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
				}):Play()
				if callback then callback(state) end
			end
		end)
	end

	-- SLIDER (UPGRADED)
	function Window:AddSlider(text, min, max, callback)
		local frame = Instance.new("Frame")
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

		local dragging = false

		local function update(input)
			local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * percent)
			fill.Size = UDim2.new(percent, 0, 1, 0)
			valueLabel.Text = tostring(value)
			if callback then callback(value) end
		end

		bar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
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

	-- DROPDOWN (UPDATED)
	function Window:AddDropdown(text, options, callback)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 35)
		holder.BackgroundTransparency = 1
		holder.Parent = content
		holder.ZIndex = 1

		local selected = options[1]
		local open = false
		local selectedButton

		-- Main button
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 35)
		btn.BackgroundColor3 = THEME.Container
		btn.Text = text .. ": " .. selected
		btn.TextColor3 = THEME.TextMain
		btn.Font = FONT_MAIN
		btn.TextSize = 14
		btn.Parent = holder
		btn.ZIndex = 2
		btn.Active = true
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		-- Dropdown list
		local list = Instance.new("Frame")
		list.Size = UDim2.new(1, 0, 0, #options * 30)
		list.Position = UDim2.new(0, 0, 1, 6)
		list.BackgroundColor3 = THEME.Container
		list.Visible = false
		list.Parent = holder
		list.ZIndex = 3
		list.Active = true
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
			o.ZIndex = 4
			o.Active = true

			-- Hover effect
			o.MouseEnter:Connect(function()
				if selectedButton ~= o then
					o.BackgroundColor3 = THEME.Stroke
				end
			end)

			o.MouseLeave:Connect(function()
				if selectedButton ~= o then
					o.BackgroundColor3 = THEME.Container
				end
			end)

			-- Selection logic
			o.MouseButton1Click:Connect(function()
				if selectedButton then
					selectedButton.BackgroundColor3 = THEME.Container
				end

				selectedButton = o
				selected = opt

				o.BackgroundColor3 = THEME.Accent
				btn.Text = text .. ": " .. opt

				list.Visible = false
				open = false

				if callback then
					callback(opt)
				end
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

