-- First, create the UI Library module properly
local UILibrary = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Theme
local Theme = {
    Background = Color3.fromRGB(20, 20, 40),
    Primary = Color3.fromRGB(255, 51, 187),      -- Hot Pink
    Secondary = Color3.fromRGB(0, 255, 255),     -- Cyan
    Tertiary = Color3.fromRGB(138, 43, 226),     -- Purple
    Text = Color3.fromRGB(255, 255, 255),
    DarkContrast = Color3.fromRGB(15, 15, 30),
    LightContrast = Color3.fromRGB(40, 40, 60)
}

-- Initialize new UI
function UILibrary.new(title)
    local UI = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.Parent = game.CoreGui
    
    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Store references
    UI.ScreenGui = ScreenGui
    UI.MainFrame = MainFrame
    UI.Tabs = {}
    
    -- Create tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = Theme.DarkContrast
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    UI.TabContainer = TabContainer
    
    -- Create tab content container
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -120, 1, -30)
    TabContent.Position = UDim2.new(0, 120, 0, 30)
    TabContent.BackgroundColor3 = Theme.Background
    TabContent.BorderSizePixel = 0
    TabContent.Parent = MainFrame
    
    UI.TabContent = TabContent
    
    -- Create Tab function
    function UI:CreateTab(name)
        local Tab = {}
        
        -- Create tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name.."Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Theme.DarkContrast
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Theme.Text
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Parent = self.TabContainer
        
        -- Create tab content frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = name.."Content"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 2
        TabFrame.Visible = false
        TabFrame.Parent = self.TabContent
        
        -- Add padding and layout
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 5)
        UIListLayout.Parent = TabFrame
        
        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 10)
        UIPadding.PaddingTop = UDim.new(0, 10)
        UIPadding.Parent = TabFrame
        
        -- Tab Functions
        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text.."Button"
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundColor3 = Theme.LightContrast
            Button.BorderSizePixel = 0
            Button.Text = text
            Button.TextColor3 = Theme.Text
            Button.TextSize = 14
            Button.Font = Enum.Font.GothamSemibold
            Button.Parent = TabFrame
            
            Button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            return Button
        end
        
        function Tab:CreateToggle(text, default, callback)
            local Toggle = {}
            local Enabled = default or false
            
            -- Create toggle here (using the code from previous messages)
            -- ...
            
            return Toggle
        end
        
        -- Add other component functions (Slider, Dropdown, etc.)
        -- ...
        
        -- Tab button click handler
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(self.TabContent:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabFrame.Visible = true
        end)
        
        return Tab
    end
    
    return UI
end

-- Example usage:
local UI = UILibrary.new("My UI")
local MainTab = UI:CreateTab("Main")

MainTab:CreateButton("Click Me", function()
    print("Button clicked!")
end)
-- Configuration
local Config = {
    MainColor = Color3.fromRGB(36, 36, 36),
    AccentColor = Color3.fromRGB(0, 170, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    FontFamily = Enum.Font.Gotham,
    TweenSpeed = 0.3
}

-- Utility Functions
local function CreateTween(instance, properties, duration)
    duration = duration or Config.TweenSpeed
    local tween = TweenService:Create(instance, TweenInfo.new(duration), properties)
    return tween
end

function UILibrary.new(title)
    local GUI = {}
    
    -- Create main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.Parent = game.CoreGui
    
    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Config.MainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Add corner rounding
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame
    
    -- Create title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Config.AccentColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -60, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title or "UI Library"
    TitleText.TextColor3 = Config.TextColor
    TitleText.TextSize = 14
    TitleText.Font = Config.FontFamily
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Create close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Config.TextColor
    CloseButton.TextSize = 20
    CloseButton.Font = Config.FontFamily
    CloseButton.Parent = TitleBar
    
    -- Make frame draggable
    local Dragging = false
    local DragStart = nil
    local StartPosition = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPosition = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Create container for tabs
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -120, 1, -30)
    TabContent.Position = UDim2.new(0, 120, 0, 30)
    TabContent.BackgroundColor3 = Config.MainColor
    TabContent.BorderSizePixel = 0
    TabContent.Parent = MainFrame
    
    GUI.ScreenGui = ScreenGui
    GUI.MainFrame = MainFrame
    GUI.TabContainer = TabContainer
    GUI.TabContent = TabContent
    
    return GUI
end
-- Synthwave Color Theme
local Theme = {
    Background = Color3.fromRGB(20, 20, 40),
    Primary = Color3.fromRGB(255, 51, 187),      -- Hot Pink
    Secondary = Color3.fromRGB(0, 255, 255),     -- Cyan
    Tertiary = Color3.fromRGB(138, 43, 226),     -- Purple
    Text = Color3.fromRGB(255, 255, 255),
    DarkContrast = Color3.fromRGB(15, 15, 30),
    LightContrast = Color3.fromRGB(40, 40, 60)
}

-- Tab System
function UILibrary:CreateTab(name, icon)
    local Tab = {}
    
    -- Create tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Theme.DarkContrast
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.TextColor3 = Theme.Text
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Parent = self.TabContainer
    
    -- Add hover effect
    local TabGlow = Instance.new("UIGradient")
    TabGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(1, Theme.Secondary)
    })
    TabGlow.Transparency = NumberSequence.new(1)
    TabGlow.Parent = TabButton
    
    -- Create tab content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name.."Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 2
    TabContent.Visible = false
    TabContent.Parent = self.TabContent
    
    -- Add padding and layout
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabContent
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.Parent = TabContent
    
    -- Tab button hover effect
    TabButton.MouseEnter:Connect(function()
        TweenService:Create(TabGlow, TweenInfo.new(0.3), {
            Transparency = NumberSequence.new(0.8)
        }):Play()
    end)
    
    TabButton.MouseLeave:Connect(function()
        TweenService:Create(TabGlow, TweenInfo.new(0.3), {
            Transparency = NumberSequence.new(1)
        }):Play()
    end)
    
    -- Tab button click
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(self.TabContent:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                v.Visible = false
            end
        end
        TabContent.Visible = true
        
        -- Animate selection
        for _, v in pairs(self.TabContainer:GetChildren()) do
            if v:IsA("TextButton") then
                TweenService:Create(v, TweenInfo.new(0.3), {
                    BackgroundColor3 = Theme.DarkContrast
                }):Play()
            end
        end
        TweenService:Create(TabButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Theme.Primary
        }):Play()
    end)
    
    -- Auto-size content
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    function Tab:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = text.."Button"
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Theme.LightContrast
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.TextColor3 = Theme.Text
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamSemibold
        Button.Parent = TabContent
        
        -- Add neon effect
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = Theme.Secondary
        ButtonStroke.Transparency = 0.8
        ButtonStroke.Parent = Button
        
        -- Button corner rounding
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        -- Click animation
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {
                Size = UDim2.new(1, 0, 0, 32)
            }):Play()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {
                Size = UDim2.new(1, 0, 0, 35)
            }):Play()
            
            if callback then
                callback()
            end
        end)
        
        return Button
    end
    
    return Tab
end
-- Toggle Component
function Tab:CreateToggle(text, default, callback)
    local Toggle = {}
    local Enabled = default or false
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text.."Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Theme.LightContrast
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = TabContent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleTitle = Instance.new("TextLabel")
    ToggleTitle.Name = "Title"
    ToggleTitle.Text = text
    ToggleTitle.BackgroundTransparency = 1
    ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
    ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
    ToggleTitle.Font = Enum.Font.GothamSemibold
    ToggleTitle.TextColor3 = Theme.Text
    ToggleTitle.TextSize = 14
    ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToggleTitle.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 45, 0, 20)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -10)
    ToggleButton.BackgroundColor3 = Theme.DarkContrast
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "Indicator"
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleIndicator.BackgroundColor3 = Theme.Text
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    local ToggleIndicatorCorner = Instance.new("UICorner")
    ToggleIndicatorCorner.CornerRadius = UDim.new(1, 0)
    ToggleIndicatorCorner.Parent = ToggleIndicator
    
    -- Neon effect
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Theme.Secondary
    ToggleStroke.Transparency = 0.8
    ToggleStroke.Parent = ToggleFrame
    
    local function UpdateToggle()
        local pos = Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local color = Enabled and Theme.Primary or Theme.Text
        
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {
            Position = pos,
            BackgroundColor3 = color
        }):Play()
        
        if callback then
            callback(Enabled)
        end
    end
    
    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Enabled = not Enabled
            UpdateToggle()
        end
    end)
    
    -- Initialize toggle state
    if Enabled then
        UpdateToggle()
    end
    
    -- Slider Component
    function Tab:CreateSlider(text, min, max, default, callback)
        local Slider = {}
        min = min or 0
        max = max or 100
        default = default or min
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = text.."Slider"
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundColor3 = Theme.LightContrast
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = TabContent
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 6)
        SliderCorner.Parent = SliderFrame
        
        local SliderTitle = Instance.new("TextLabel")
        SliderTitle.Name = "Title"
        SliderTitle.Text = text
        SliderTitle.BackgroundTransparency = 1
        SliderTitle.Position = UDim2.new(0, 10, 0, 0)
        SliderTitle.Size = UDim2.new(1, -20, 0, 25)
        SliderTitle.Font = Enum.Font.GothamSemibold
        SliderTitle.TextColor3 = Theme.Text
        SliderTitle.TextSize = 14
        SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
        SliderTitle.Parent = SliderFrame
        
        local SliderValue = Instance.new("TextLabel")
        SliderValue.Name = "Value"
        SliderValue.Text = tostring(default)
        SliderValue.BackgroundTransparency = 1
        SliderValue.Position = UDim2.new(1, -60, 0, 0)
        SliderValue.Size = UDim2.new(0, 50, 0, 25)
        SliderValue.Font = Enum.Font.GothamSemibold
        SliderValue.TextColor3 = Theme.Primary
        SliderValue.TextSize = 14
        SliderValue.Parent = SliderFrame
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Name = "SliderBar"
        SliderBar.Position = UDim2.new(0, 10, 0, 35)
        SliderBar.Size = UDim2.new(1, -20, 0, 4)
        SliderBar.BackgroundColor3 = Theme.DarkContrast
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = SliderFrame
        
        local SliderBarCorner = Instance.new("UICorner")
        SliderBarCorner.CornerRadius = UDim.new(1, 0)
        SliderBarCorner.Parent = SliderBar
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Theme.Primary
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBar
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(1, 0)
        SliderFillCorner.Parent = SliderFill
        
        -- Neon effect
        local SliderStroke = Instance.new("UIStroke")
        SliderStroke.Color = Theme.Secondary
        SliderStroke.Transparency = 0.8
        SliderStroke.Parent = SliderFrame
        
        -- Slider functionality
        local dragging = false
        
        local function UpdateSlider(value)
            value = math.clamp(value, min, max)
            value = math.floor(value + 0.5)
            SliderValue.Text = tostring(value)
            
            local percent = (value - min)/(max - min)
            TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                Size = UDim2.new(percent, 0, 1, 0)
            }):Play()
            
            if callback then
                callback(value)
            end
        end
        
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = min + ((max - min) * percent)
                UpdateSlider(value)
            end
        end)
        
        -- Set default value
        UpdateSlider(default)
        
        return Slider
    end
end
-- Dropdown Component
function Tab:CreateDropdown(text, options, callback)
    local Dropdown = {}
    options = options or {}
    local Selected = options[1] or "None"
    local Open = false
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = text.."Dropdown"
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundColor3 = Theme.LightContrast
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = TabContent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownTitle = Instance.new("TextLabel")
    DropdownTitle.Name = "Title"
    DropdownTitle.Text = text
    DropdownTitle.BackgroundTransparency = 1
    DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
    DropdownTitle.Size = UDim2.new(1, -40, 0, 35)
    DropdownTitle.Font = Enum.Font.GothamSemibold
    DropdownTitle.TextColor3 = Theme.Text
    DropdownTitle.TextSize = 14
    DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
    DropdownTitle.Parent = DropdownFrame
    
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Name = "Selected"
    SelectedLabel.Text = Selected
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Position = UDim2.new(1, -150, 0, 0)
    SelectedLabel.Size = UDim2.new(0, 140, 0, 35)
    SelectedLabel.Font = Enum.Font.Gotham
    SelectedLabel.TextColor3 = Theme.Primary
    SelectedLabel.TextSize = 14
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    SelectedLabel.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = "Options"
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.BackgroundColor3 = Theme.DarkContrast
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.ClipsDescendants = true
    OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
    OptionsFrame.Parent = DropdownFrame
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 6)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsList = Instance.new("UIListLayout")
    OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsList.Padding = UDim.new(0, 5)
    OptionsList.Parent = OptionsFrame
    
    -- Neon effect
    local DropdownStroke = Instance.new("UIStroke")
    DropdownStroke.Color = Theme.Secondary
    DropdownStroke.Transparency = 0.8
    DropdownStroke.Parent = DropdownFrame
    
    -- Create option buttons
    local function CreateOptions()
        for _, option in pairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = Theme.LightContrast
            OptionButton.BackgroundTransparency = 0.5
            OptionButton.Text = option
            OptionButton.TextColor3 = Theme.Text
            OptionButton.TextSize = 14
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Parent = OptionsFrame
            
            OptionButton.MouseButton1Click:Connect(function()
                Selected = option
                SelectedLabel.Text = option
                
                if callback then
                    callback(option)
                end
                
                TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                Open = false
            end)
        end
    end
    
    -- Toggle dropdown
    DropdownButton.MouseButton1Click:Connect(function()
        Open = not Open
        local size = Open and UDim2.new(1, 0, 0, (#options * 35)) or UDim2.new(1, 0, 0, 0)
        TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {
            Size = size
        }):Play()
    end)
    
    CreateOptions()
    
    -- Notification System
    function UILibrary:CreateNotification(title, text, duration)
        duration = duration or 3
        
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Name = "Notification"
        NotifFrame.Size = UDim2.new(0, 250, 0, 80)
        NotifFrame.Position = UDim2.new(1, -270, 1, -100)
        NotifFrame.BackgroundColor3 = Theme.DarkContrast
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = self.ScreenGui
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 6)
        NotifCorner.Parent = NotifFrame
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Name = "Title"
        NotifTitle.Text = title
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.Size = UDim2.new(1, -20, 0, 25)
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextColor3 = Theme.Primary
        NotifTitle.TextSize = 16
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = NotifFrame
        
        local NotifText = Instance.new("TextLabel")
        NotifText.Name = "Text"
        NotifText.Text = text
        NotifText.BackgroundTransparency = 1
        NotifText.Position = UDim2.new(0, 10, 0, 30)
        NotifText.Size = UDim2.new(1, -20, 1, -35)
        NotifText.Font = Enum.Font.Gotham
        NotifText.TextColor3 = Theme.Text
        NotifText.TextSize = 14
        NotifText.TextXAlignment = Enum.TextXAlignment.Left
        NotifText.TextWrapped = true
        NotifText.Parent = NotifFrame
        
        -- Neon effect
        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = Theme.Secondary
        NotifStroke.Transparency = 0.8
        NotifStroke.Parent = NotifFrame
        
        -- Animation
        NotifFrame.Position = UDim2.new(1, 0, 1, -100)
        TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Position = UDim2.new(1, -270, 1, -100)
        }):Play()
        
        -- Auto remove
        task.delay(duration, function()
            TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Position = UDim2.new(1, 0, 1, -100)
            }):Play()
            task.wait(0.3)
            NotifFrame:Destroy()
        end)
    end
    
    -- Input Field Component
    function Tab:CreateInput(text, placeholder, callback)
        local InputFrame = Instance.new("Frame")
        InputFrame.Name = text.."Input"
        InputFrame.Size = UDim2.new(1, 0, 0, 35)
        InputFrame.BackgroundColor3 = Theme.LightContrast
        InputFrame.BorderSizePixel = 0
        InputFrame.Parent = TabContent
        
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 6)
        InputCorner.Parent = InputFrame
        
        local InputTitle = Instance.new("TextLabel")
        InputTitle.Name = "Title"
        InputTitle.Text = text
        InputTitle.BackgroundTransparency = 1
        InputTitle.Position = UDim2.new(0, 10, 0, 0)
        InputTitle.Size = UDim2.new(0, 100, 1, 0)
        InputTitle.Font = Enum.Font.GothamSemibold
        InputTitle.TextColor3 = Theme.Text
        InputTitle.TextSize = 14
        InputTitle.TextXAlignment = Enum.TextXAlignment.Left
        InputTitle.Parent = InputFrame
        
        local InputBox = Instance.new("TextBox")
        InputBox.Name = "Input"
        InputBox.PlaceholderText = placeholder
        InputBox.Text = ""
        InputBox.BackgroundTransparency = 1
        InputBox.Position = UDim2.new(0, 120, 0, 0)
        InputBox.Size = UDim2.new(1, -130, 1, 0)
        InputBox.Font = Enum.Font.Gotham
        InputBox.TextColor3 = Theme.Primary
        InputBox.PlaceholderColor3 = Theme.Primary
        InputBox.TextSize = 14
        InputBox.TextXAlignment = Enum.TextXAlignment.Left
        InputBox.Parent = InputFrame
        
        -- Neon effect
        local InputStroke = Instance.new("UIStroke")
        InputStroke.Color = Theme.Secondary
        InputStroke.Transparency = 0.8
        InputStroke.Parent = InputFrame
        
        InputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(InputBox.Text)
            end
        end)
    end
end
-- Homepage/Player Info Component
function UILibrary:CreateHomepage()
    local HomePage = {}
    
    local HomeFrame = Instance.new("Frame")
    HomeFrame.Name = "Homepage"
    HomeFrame.Size = UDim2.new(1, -120, 1, -30)
    HomeFrame.Position = UDim2.new(0, 120, 0, 30)
    HomeFrame.BackgroundColor3 = Theme.Background
    HomeFrame.BorderSizePixel = 0
    HomeFrame.Parent = self.MainFrame
    
    -- Player Info Section
    local PlayerSection = Instance.new("Frame")
    PlayerSection.Name = "PlayerInfo"
    PlayerSection.Size = UDim2.new(1, -20, 0, 100)
    PlayerSection.Position = UDim2.new(0, 10, 0, 10)
    PlayerSection.BackgroundColor3 = Theme.LightContrast
    PlayerSection.BorderSizePixel = 0
    PlayerSection.Parent = HomeFrame
    
    local PlayerCorner = Instance.new("UICorner")
    PlayerCorner.CornerRadius = UDim.new(0, 6)
    PlayerCorner.Parent = PlayerSection
    
    -- Player Avatar
    local PlayerImage = Instance.new("ImageLabel")
    PlayerImage.Name = "Avatar"
    PlayerImage.Size = UDim2.new(0, 80, 0, 80)
    PlayerImage.Position = UDim2.new(0, 10, 0, 10)
    PlayerImage.BackgroundColor3 = Theme.DarkContrast
    PlayerImage.Image = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
    PlayerImage.Parent = PlayerSection
    
    local PlayerImageCorner = Instance.new("UICorner")
    PlayerImageCorner.CornerRadius = UDim.new(0, 6)
    PlayerImageCorner.Parent = PlayerImage
    
    -- Player Info
    local PlayerName = Instance.new("TextLabel")
    PlayerName.Name = "PlayerName"
    PlayerName.Text = LocalPlayer.Name
    PlayerName.Size = UDim2.new(1, -110, 0, 25)
    PlayerName.Position = UDim2.new(0, 100, 0, 10)
    PlayerName.BackgroundTransparency = 1
    PlayerName.Font = Enum.Font.GothamBold
    PlayerName.TextColor3 = Theme.Text
    PlayerName.TextSize = 16
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    PlayerName.Parent = PlayerSection
    
    -- Game Info Section
    local GameSection = Instance.new("Frame")
    GameSection.Name = "GameInfo"
    GameSection.Size = UDim2.new(1, -20, 0, 100)
    GameSection.Position = UDim2.new(0, 10, 0, 120)
    GameSection.BackgroundColor3 = Theme.LightContrast
    GameSection.BorderSizePixel = 0
    GameSection.Parent = HomeFrame
    
    local GameCorner = Instance.new("UICorner")
    GameCorner.CornerRadius = UDim.new(0, 6)
    GameCorner.Parent = GameSection
    
    -- Game Info
    local GameName = Instance.new("TextLabel")
    GameName.Name = "GameName"
    GameName.Text = "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    GameName.Size = UDim2.new(1, -20, 0, 25)
    GameName.Position = UDim2.new(0, 10, 0, 10)
    GameName.BackgroundTransparency = 1
    GameName.Font = Enum.Font.GothamSemibold
    GameName.TextColor3 = Theme.Text
    GameName.TextSize = 14
    GameName.TextXAlignment = Enum.TextXAlignment.Left
    GameName.Parent = GameSection
    
    -- Server Info
    local ServerInfo = Instance.new("TextLabel")
    ServerInfo.Name = "ServerInfo"
    ServerInfo.Text = string.format("Players: %d/%d", #Players:GetPlayers(), Players.MaxPlayers)
    ServerInfo.Size = UDim2.new(1, -20, 0, 25)
    ServerInfo.Position = UDim2.new(0, 10, 0, 40)
    ServerInfo.BackgroundTransparency = 1
    ServerInfo.Font = Enum.Font.Gotham
    ServerInfo.TextColor3 = Theme.Text
    ServerInfo.TextSize = 14
    ServerInfo.TextXAlignment = Enum.TextXAlignment.Left
    ServerInfo.Parent = GameSection
    
    -- Update server info
    Players.PlayerAdded:Connect(function()
        ServerInfo.Text = string.format("Players: %d/%d", #Players:GetPlayers(), Players.MaxPlayers)
    end)
    
    Players.PlayerRemoving:Connect(function()
        ServerInfo.Text = string.format("Players: %d/%d", #Players:GetPlayers() - 1, Players.MaxPlayers)
    end)
    
    -- Neon effects
    local PlayerStroke = Instance.new("UIStroke")
    PlayerStroke.Color = Theme.Secondary
    PlayerStroke.Transparency = 0.8
    PlayerStroke.Parent = PlayerSection
    
    local GameStroke = Instance.new("UIStroke")
    GameStroke.Color = Theme.Secondary
    GameStroke.Transparency = 0.8
    GameStroke.Parent = GameSection
    
    return HomePage
end

return UILibrary
