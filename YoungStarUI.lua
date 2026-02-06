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
	content.Size = UDim2.new(1, 0, 0, 0)
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
	-- CONTROLS
	-- =========================
	local Window = {}

	local function hover(btn)
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = THEME.Stroke
			}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = THEME.Container
			}):Play()
		end)
	end

	function Window:AddButton(text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 35)
		btn.BackgroundColor3 = THEME.Container
		btn.Text = text
		btn.TextColor3 = THEME.TextMain
		btn.Font = FONT_MAIN
		btn.TextSize = 14
		btn.Parent = content
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		hover(btn)

		btn.MouseButton1Click:Connect(function()
			if callback then callback() end
		end)
	end

	function Window:AddDropdown(text, options, callback)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 35)
		holder.BackgroundTransparency = 1
		holder.AutomaticSize = Enum.AutomaticSize.Y
		holder.Parent = content

		local selected = options[1]
		local open = false

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 35)
		btn.BackgroundColor3 = THEME.Container
		btn.Text = text .. ": " .. selected
		btn.TextColor3 = THEME.TextMain
		btn.Font = FONT_MAIN
		btn.TextSize = 14
		btn.Parent = holder
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		hover(btn)

		local list = Instance.new("Frame")
		list.BackgroundColor3 = THEME.Background
		list.Visible = false
		list.AutomaticSize = Enum.AutomaticSize.Y
		list.Parent = holder
		Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)

		local lpad = Instance.new("UIPadding")
		lpad.PaddingTop = UDim.new(0, 4)
		lpad.PaddingBottom = UDim.new(0, 4)
		lpad.Parent = list

		local lay = Instance.new("UIListLayout")
		lay.Parent = list

		for _, opt in ipairs(options) do
			local o = Instance.new("TextButton")
			o.Size = UDim2.new(1, 0, 0, 30)
			o.BackgroundColor3 = THEME.Container
			o.Text = tostring(opt)
			o.TextColor3 = THEME.TextDim
			o.Font = FONT_MAIN
			o.TextSize = 14
			o.Parent = list

			hover(o)

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
		if enabled then
			local info = Instance.new("TextLabel")
			info.Size = UDim2.new(1, 0, 0, 26)
			info.BackgroundTransparency = 1
			info.TextWrapped = true
			info.Text = tostring(text)
			info.TextColor3 = THEME.TextDim
			info.Font = FONT_MAIN
			info.TextSize = 12
			info.Parent = content
		end
	end

	return Window
end

return Library
