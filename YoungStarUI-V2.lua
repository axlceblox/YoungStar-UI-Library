--[[ 
    YoungStar UI Library 
    Converted & Optimized by Gemini
]]

local YoungStar = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Viewport = workspace.CurrentCamera.ViewportSize

-- Utility: Safe Parent
local function GetParent()
    return (game:GetService("RunService"):IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
end

-- Default Theme
local DefaultTheme = {
    Main = Color3.fromRGB(18,18,18),
    Top = Color3.fromRGB(25,25,25),
    TabBar = Color3.fromRGB(22,22,22),
    Accent = Color3.fromRGB(80,120,255),
    Text = Color3.fromRGB(230,230,230),
    SubText = Color3.fromRGB(170,170,170)
}

function YoungStar:CreateWindow(Config)
    Config = Config or {}
    local TitleText = Config.Name or "YoungStar UI"
    local Theme = Config.Theme or DefaultTheme
    
    local Window = {}
    
    --// 1. MAIN GUI SETUP
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "YoungStarLib_" .. TitleText
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    
    -- Anti-Dupe
    if GetParent():FindFirstChild(ScreenGui.Name) then
        GetParent()[ScreenGui.Name]:Destroy()
    end
    ScreenGui.Parent = GetParent()

    --// 2. NOTIFICATION SYSTEM
    local NotifyHolder = Instance.new("Frame")
    NotifyHolder.Size = UDim2.new(0, 320, 0, 400)
    NotifyHolder.Position = UDim2.new(1, -20, 1, -20)
    NotifyHolder.AnchorPoint = Vector2.new(1, 1)
    NotifyHolder.BackgroundTransparency = 1
    NotifyHolder.ZIndex = 100
    NotifyHolder.Parent = ScreenGui

    local NotifyLayout = Instance.new("UIListLayout")
    NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotifyLayout.Padding = UDim.new(0, 8)
    NotifyLayout.Parent = NotifyHolder

    function Window:Notify(title, message, duration)
        duration = duration or 3
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 64)
        Frame.BackgroundColor3 = Theme.TabBar
        Frame.BackgroundTransparency = 1
        Frame.Parent = NotifyHolder
        Frame.ZIndex = 101
        Frame.ClipsDescendants = true
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
        Frame.Position = UDim2.new(0, 30, 0, 0) -- Start offset

        local T = Instance.new("TextLabel")
        T.Size = UDim2.new(1, -20, 0, 22)
        T.Position = UDim2.new(0, 10, 0, 6)
        T.BackgroundTransparency = 1
        T.Text = title
        T.Font = Enum.Font.GothamSemibold
        T.TextSize = 14
        T.TextColor3 = Theme.Text
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.TextTransparency = 1
        T.ZIndex = 102
        T.Parent = Frame

        local M = Instance.new("TextLabel")
        M.Size = UDim2.new(1, -20, 0, 18)
        M.Position = UDim2.new(0, 10, 0, 32)
        M.BackgroundTransparency = 1
        M.Text = message
        M.Font = Enum.Font.Gotham
        M.TextSize = 12
        M.TextColor3 = Theme.SubText
        M.TextXAlignment = Enum.TextXAlignment.Left
        M.TextWrapped = true
        M.TextTransparency = 1
        M.ZIndex = 102
        M.Parent = Frame

        TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Position = UDim2.new(0,0,0,0)}):Play()
        TweenService:Create(T, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TweenService:Create(M, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

        task.delay(duration, function()
            TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {BackgroundTransparency = 1, Position = UDim2.new(0, 30, 0, 0)}):Play()
            TweenService:Create(T, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
            TweenService:Create(M, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
            task.wait(0.3)
            Frame:Destroy()
        end)
    end

    --// 3. MAIN FRAME & RESPONSIVENESS
    local isMobile = Viewport.X < 900
    local MainWidth = isMobile and 380 or 460
    local MainHeight = isMobile and 280 or 320

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, MainWidth, 0, MainHeight)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.Main
    Main.Parent = ScreenGui
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    -- Draggable Logic
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    --// 4. TOP BAR & MINIMIZE
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.Top
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -100, 1, 0)
    TitleLbl.Position = UDim2.new(0, 15, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = TitleText
    TitleLbl.Font = Enum.Font.GothamSemibold
    TitleLbl.TextSize = 18
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = TopBar

    -- Floating Toggle
    local FloatingMin = Instance.new("TextButton")
    FloatingMin.Name = "ToggleUI"
    FloatingMin.Size = UDim2.new(0, 120, 0, 32)
    FloatingMin.Position = UDim2.new(0.5, 0, 0, 12)
    FloatingMin.AnchorPoint = Vector2.new(0.5, 0)
    FloatingMin.BackgroundColor3 = Theme.TabBar
    FloatingMin.Text = "Open Menu"
    FloatingMin.Font = Enum.Font.GothamSemibold
    FloatingMin.TextSize = 14
    FloatingMin.TextColor3 = Theme.Text
    FloatingMin.Parent = ScreenGui
    FloatingMin.Visible = false
    Instance.new("UICorner", FloatingMin).CornerRadius = UDim.new(0, 10)

    local function ToggleUI(state)
        Main.Visible = state
        FloatingMin.Visible = not state
    end

    FloatingMin.MouseButton1Click:Connect(function() ToggleUI(true) end)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 28, 0, 28)
    MinBtn.Position = UDim2.new(1, -34, 0.5, -14)
    MinBtn.Text = "-"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.TextColor3 = Theme.Text
    MinBtn.BackgroundColor3 = Theme.TabBar
    MinBtn.Parent = TopBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
    MinBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)

    --// 5. CONTENT & TABS
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -20, 1, -100)
    Content.Position = UDim2.new(0, 10, 0, 90)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -20, 0, 36)
    TabBar.Position = UDim2.new(0, 10, 0, 48)
    TabBar.BackgroundColor3 = Theme.TabBar
    TabBar.Parent = Main
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

    local TabList = Instance.new("UIListLayout", TabBar)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)
    
    local TabPad = Instance.new("UIPadding", TabBar)
    TabPad.PaddingLeft = UDim.new(0, 6)
    TabPad.PaddingRight = UDim.new(0, 6)
    TabPad.PaddingTop = UDim.new(0, 4)

    local Tabs = {}
    local FirstTab = true

    function Window:CreateTab(Name)
        local Tab = {}
        
        -- Tab Button
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 0, 1, -8) -- Auto width later? For now fixed or dynamic
        Btn.AutomaticSize = Enum.AutomaticSize.X
        Btn.Text = "  " .. Name .. "  "
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextSize = 14
        Btn.TextColor3 = Theme.Text
        Btn.BackgroundColor3 = Theme.Main
        Btn.Parent = TabBar
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

        -- Page
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1,0,1,0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Visible = false
        Page.ScrollBarThickness = 4
        Page.Parent = Content
        
        local LayoutPage = Instance.new("UIListLayout", Page)
        LayoutPage.Padding = UDim.new(0,8)
        LayoutPage.SortOrder = Enum.SortOrder.LayoutOrder
        
        local PaddingPage = Instance.new("UIPadding", Page)
        PaddingPage.PaddingTop = UDim.new(0, 6)
        PaddingPage.PaddingLeft = UDim.new(0, 6)
        PaddingPage.PaddingRight = UDim.new(0, 6)
        PaddingPage.PaddingBottom = UDim.new(0, 6)

        LayoutPage:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,LayoutPage.AbsoluteContentSize.Y + 12)
        end)

        -- Switch Logic
        Btn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Btn.BackgroundColor3 = Theme.Main
                t.Page.Visible = false
            end
            Btn.BackgroundColor3 = Theme.Accent
            Page.Visible = true
        end)

        table.insert(Tabs, {Btn = Btn, Page = Page})

        if FirstTab then
            Btn.BackgroundColor3 = Theme.Accent
            Page.Visible = true
            FirstTab = false
        end

        --// COMPONENTS
        function Tab:CreateButton(Title, Desc, Callback)
            local Holder = Instance.new("Frame")
            Holder.Size = UDim2.new(1, 0, 0, 55)
            Holder.BackgroundColor3 = Theme.TabBar
            Holder.Parent = Page
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 10)

            local T = Instance.new("TextLabel")
            T.Size = UDim2.new(1, -20, 0, 22)
            T.Position = UDim2.new(0, 10, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = Title
            T.Font = Enum.Font.GothamSemibold
            T.TextSize = 14
            T.TextColor3 = Theme.Text
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.Parent = Holder

            local D = Instance.new("TextLabel")
            D.Size = UDim2.new(1, -20, 0, 18)
            D.Position = UDim2.new(0, 10, 0, 28)
            D.BackgroundTransparency = 1
            D.Text = Desc or ""
            D.Font = Enum.Font.Gotham
            D.TextSize = 12
            D.TextColor3 = Theme.SubText
            D.TextXAlignment = Enum.TextXAlignment.Left
            D.Parent = Holder

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(1, 0, 1, 0)
            B.BackgroundTransparency = 1
            B.Text = ""
            B.Parent = Holder
            B.MouseButton1Click:Connect(function() pcall(Callback) end)
        end

        function Tab:CreateToggle(Title, Callback)
            local state = false
            local Holder = Instance.new("Frame")
            Holder.Size = UDim2.new(1, 0, 0, 45) -- Smaller for toggle
            Holder.BackgroundColor3 = Theme.TabBar
            Holder.Parent = Page
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 10)

            local T = Instance.new("TextLabel")
            T.Size = UDim2.new(1, -80, 1, 0)
            T.Position = UDim2.new(0, 10, 0, 0)
            T.BackgroundTransparency = 1
            T.Text = Title
            T.Font = Enum.Font.GothamSemibold
            T.TextSize = 14
            T.TextColor3 = Theme.Text
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.Parent = Holder

            local ToggleBg = Instance.new("Frame")
            ToggleBg.Size = UDim2.new(0, 40, 0, 20)
            ToggleBg.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
            ToggleBg.Parent = Holder
            Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1,0)

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Circle.Parent = ToggleBg
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(1,0,1,0)
            B.BackgroundTransparency = 1
            B.Text = ""
            B.Parent = Holder
            
            B.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,60)}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
                pcall(Callback, state)
            end)
        end

        function Tab:CreateSlider(Title, Min, Max, Default, Callback)
            local value = Default or Min
            local Holder = Instance.new("Frame")
            Holder.Size = UDim2.new(1, 0, 0, 60)
            Holder.BackgroundColor3 = Theme.TabBar
            Holder.Parent = Page
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 10)

            local T = Instance.new("TextLabel")
            T.Size = UDim2.new(1, -60, 0, 22)
            T.Position = UDim2.new(0, 10, 0, 6)
            T.BackgroundTransparency = 1
            T.Text = Title
            T.Font = Enum.Font.GothamSemibold
            T.TextSize = 14
            T.TextColor3 = Theme.Text
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.Parent = Holder

            local Val = Instance.new("TextLabel")
            Val.Size = UDim2.new(0, 40, 0, 22)
            Val.Position = UDim2.new(1, -45, 0, 6)
            Val.BackgroundTransparency = 1
            Val.Text = tostring(value)
            Val.Font = Enum.Font.GothamSemibold
            Val.TextSize = 14
            Val.TextColor3 = Theme.Text
            Val.Parent = Holder

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, -20, 0, 6)
            Bar.Position = UDim2.new(0, 10, 0, 40)
            Bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Bar.Parent = Holder
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1,0)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Fill.Parent = Bar
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(1,0,1,0)
            B.BackgroundTransparency = 1
            B.Text = ""
            B.Parent = Bar -- Touch interaction on the bar

            local dragging = false
            B.InputBegan:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end 
            end)
            UserInputService.InputEnded:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end 
            end)
            
            local function UpdateSlide(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                value = math.floor(Min + (Max - Min) * pos)
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                Val.Text = value
                pcall(Callback, value)
            end
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlide(input)
                end
            end)
        end

        function Tab:CreateDropdown(Title, Options, Default, Callback)
            local selected = Default or Options[1]
            local open = false
            
            local Holder = Instance.new("Frame")
            Holder.Size = UDim2.new(1, 0, 0, 60)
            Holder.BackgroundColor3 = Theme.TabBar
            Holder.Parent = Page
            Holder.ClipsDescendants = true
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 10)

            local T = Instance.new("TextLabel")
            T.Size = UDim2.new(1, -20, 0, 22)
            T.Position = UDim2.new(0, 10, 0, 6)
            T.BackgroundTransparency = 1
            T.Text = Title
            T.Font = Enum.Font.GothamSemibold
            T.TextSize = 14
            T.TextColor3 = Theme.Text
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.Parent = Holder

            local CurrentVal = Instance.new("TextLabel")
            CurrentVal.Size = UDim2.new(1, -20, 0, 22)
            CurrentVal.Position = UDim2.new(0, 10, 0, 32)
            CurrentVal.BackgroundTransparency = 1
            CurrentVal.Text = selected
            CurrentVal.Font = Enum.Font.Gotham
            CurrentVal.TextSize = 13
            CurrentVal.TextColor3 = Theme.SubText
            CurrentVal.TextXAlignment = Enum.TextXAlignment.Left
            CurrentVal.Parent = Holder

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1,0,1,0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.Parent = Holder
            
            local List = Instance.new("Frame")
            List.Size = UDim2.new(1, -20, 0, #Options * 30)
            List.Position = UDim2.new(0, 10, 0, 60)
            List.BackgroundTransparency = 1
            List.Visible = false
            List.Parent = Holder
            
            local LL = Instance.new("UIListLayout", List)
            LL.Padding = UDim.new(0, 2)

            for _, opt in ipairs(Options) do
                local O = Instance.new("TextButton")
                O.Size = UDim2.new(1, 0, 0, 28)
                O.Text = opt
                O.Font = Enum.Font.Gotham
                O.TextSize = 13
                O.TextColor3 = Theme.Text
                O.BackgroundColor3 = Theme.Main
                O.Parent = List
                Instance.new("UICorner", O).CornerRadius = UDim.new(0, 6)
                O.MouseButton1Click:Connect(function()
                    selected = opt
                    CurrentVal.Text = opt
                    pcall(Callback, opt)
                    open = false
                    Holder:TweenSize(UDim2.new(1,0,0,60), "Out", "Quad", 0.2)
                end)
            end

            Btn.MouseButton1Click:Connect(function()
                open = not open
                List.Visible = true
                if open then
                    Holder:TweenSize(UDim2.new(1,0,0, 65 + (#Options * 30)), "Out", "Quad", 0.2)
                else
                    Holder:TweenSize(UDim2.new(1,0,0,60), "Out", "Quad", 0.2)
                end
            end)
        end

        function Tab:CreateTextbox(Title, Placeholder, Callback)
            local Holder = Instance.new("Frame")
            Holder.Size = UDim2.new(1, 0, 0, 60)
            Holder.BackgroundColor3 = Theme.TabBar
            Holder.Parent = Page
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 10)

            local T = Instance.new("TextLabel")
            T.Size = UDim2.new(1, -20, 0, 22)
            T.Position = UDim2.new(0, 10, 0, 6)
            T.BackgroundTransparency = 1
            T.Text = Title
            T.Font = Enum.Font.GothamSemibold
            T.TextSize = 14
            T.TextColor3 = Theme.Text
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.Parent = Holder

            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(1, -20, 0, 24)
            Box.Position = UDim2.new(0, 10, 0, 32)
            Box.BackgroundColor3 = Theme.Main
            Box.PlaceholderText = Placeholder or "Enter text..."
            Box.Font = Enum.Font.Gotham
            Box.TextSize = 13
            Box.TextColor3 = Theme.Text
            Box.Parent = Holder
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
            
            Box.FocusLost:Connect(function(enter)
                if enter then pcall(Callback, Box.Text) end
            end)
        end

        return Tab
    end
    
    return Window
end

return YoungStar

