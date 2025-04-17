local Synthwave = {}
local SynthwaveSettings = {}

-- Create Assets folder programmatically instead of referencing script.Assets
local Assets = Instance.new("Folder")
Assets.Name = "Assets"

-- Direct service access
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Notification System
function Synthwave:CreateNotification(options)
    -- Try to find or create a parent for the notification
    local parentGui
    
    -- Try different methods to find a suitable parent
    local success = pcall(function()
        parentGui = game.CoreGui
    end)
    
    if not success then
        success = pcall(function()
            parentGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        end)
    end
    
    if not success or not parentGui then
        warn("SynthwaveUI: Failed to find a suitable parent for UI elements")
        return
    end
    
    local Notification = parentGui:FindFirstChild("SynthwaveNotification")
    if not Notification then
        Notification = Instance.new("ScreenGui")
        Notification.Name = "SynthwaveNotification"
        
        -- Use pcall to handle potential errors when setting parent
        success = pcall(function()
            Notification.Parent = parentGui
        end)
        
        if not success then
            warn("SynthwaveUI: Failed to parent notification GUI")
            return
        end
    end
    
    -- Default options
    options = options or {}
    options.Title = options.Title or "Notification"
    options.Description = options.Description or "This is a notification"
    options.Duration = options.Duration or 5
    options.Sound = (options.Sound == nil) and true or options.Sound
    options.Callback = options.Callback or function() end
    
    -- Create the notification frame
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotifFrame"
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(0.85, 0, 0.8, 0)
    NotifFrame.Size = UDim2.new(0, 250, 0, 0) -- Start with 0 height for animation
    NotifFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    NotifFrame.ClipsDescendants = true
    NotifFrame.Parent = Notification
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = NotifFrame
    
    -- Border glow
    local BorderGlow = Instance.new("UIStroke")
    BorderGlow.Color = Color3.fromRGB(250, 80, 200) -- Pink neon glow
    BorderGlow.Thickness = 1.5
    BorderGlow.Parent = NotifFrame
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = options.Title
    TitleLabel.TextColor3 = Color3.fromRGB(250, 80, 200) -- Pink text
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame
    
    -- Description
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "Description"
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0, 10, 0, 35)
    DescLabel.Size = UDim2.new(1, -20, 0, 40)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = options.Description
    DescLabel.TextColor3 = Color3.fromRGB(220, 220, 255) -- Light blue/purple text
    DescLabel.TextSize = 14
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.Parent = NotifFrame
    
    -- Add glow effect particles
    local GlowParticle = Instance.new("Frame")
    GlowParticle.Name = "GlowParticle"
    GlowParticle.BackgroundColor3 = Color3.fromRGB(250, 80, 200)
    GlowParticle.BackgroundTransparency = 0.8
    GlowParticle.BorderSizePixel = 0
    GlowParticle.Position = UDim2.new(1, -15, 0, 5)
    GlowParticle.Size = UDim2.new(0, 5, 0, 5)
    GlowParticle.Parent = NotifFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = GlowParticle
    
    -- Animate the notification
    local openSize = UDim2.new(0, 250, 0, 80)
    local closedSize = UDim2.new(0, 250, 0, 0)
    
    -- Animation properties
    local openInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local closeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    
    -- Create the tweens
    local openTween = TweenService:Create(NotifFrame, openInfo, {Size = openSize})
    local closeTween = TweenService:Create(NotifFrame, closeInfo, {Size = closedSize})
    
    -- Play sound if enabled
    if options.Sound then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://6518811702" -- Notification sound
        sound.Volume = 0.5
        sound.Parent = Notification
        sound:Play()
        
        game:GetService("Debris"):AddItem(sound, 2)
    end
    
    -- Add click functionality
    NotifFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pcall(options.Callback)
            closeTween:Play()
            closeTween.Completed:Wait()
            NotifFrame:Destroy()
        end
    end)
    
    -- Open the notification
    openTween:Play()
    
    -- Close after duration
    task.delay(options.Duration, function()
        if NotifFrame and NotifFrame.Parent then
            closeTween:Play()
            closeTween.Completed:Wait()
            NotifFrame:Destroy()
        end
    end)
    
    -- Add synthetic pulsing glow effect
    local function pulseGlow()
        while NotifFrame and NotifFrame.Parent do
            local pulseTween = TweenService:Create(BorderGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Thickness = 2.5})
            pulseTween:Play()
            task.wait(1.5)
            
            if not (NotifFrame and NotifFrame.Parent) then break end
            
            local pulseTween2 = TweenService:Create(BorderGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Thickness = 1.5})
            pulseTween2:Play()
            task.wait(1.5)
        end
    end
    
    task.spawn(pulseGlow)
    
    return NotifFrame
end

-- Window System
function Synthwave:CreateWindow(options)
    options = options or {}
    options.Title = options.Title or "Synthwave UI"
    options.Size = options.Size or UDim2.new(0, 500, 0, 350)
    options.Position = options.Position or UDim2.new(0.5, 0, 0.5, 0)
    
    -- Try to find or create a parent for the window
    local parentGui
    
    -- Try different methods to find a suitable parent
    local success = pcall(function()
        parentGui = game.CoreGui
    end)
    
    if not success then
        success = pcall(function()
            parentGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        end)
    end
    
    if not success or not parentGui then
        warn("SynthwaveUI: Failed to find a suitable parent for UI elements")
        return
    end
    
    -- Create the main ScreenGui
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "SynthwaveWindow"
    
    -- Use pcall to handle potential errors when setting parent
    success = pcall(function()
        MainGui.Parent = parentGui
    end)
    
    if not success then
        warn("SynthwaveUI: Failed to parent window GUI")
        return
    end
    
    -- Create the main window frame
    local Window = Instance.new("Frame")
    Window.Name = "MainWindow"
    Window.BackgroundColor3 = Color3.fromRGB(15, 15, 25) -- Dark background
    Window.BorderSizePixel = 0
    Window.Position = options.Position
    Window.Size = options.Size
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.Parent = MainGui
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Window
    
    -- Border glow
    local BorderGlow = Instance.new("UIStroke")
    BorderGlow.Color = Color3.fromRGB(100, 200, 255) -- Blue neon glow
    BorderGlow.Thickness = 1.5
    BorderGlow.Parent = Window
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35) -- Slightly lighter than window
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = Window
    
    -- Title bar corner
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    -- Fix the corner radius for the bottom
    local TitleFix = Instance.new("Frame")
    TitleFix.Name = "TitleFix"
    TitleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    TitleFix.BorderSizePixel = 0
    TitleFix.Position = UDim2.new(0, 0, 1, -8)
    TitleFix.Size = UDim2.new(1, 0, 0, 8)
    TitleFix.Parent = TitleBar
    
    -- Title text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = options.Title
    TitleText.TextColor3 = Color3.fromRGB(100, 200, 255) -- Blue text
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red text
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar
    
    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 5, 0, 35)
    ContentArea.Size = UDim2.new(1, -10, 1, -40)
    ContentArea.Parent = Window
    
    -- Add drag functionality
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        MainGui:Destroy()
    end)
    
    -- Add synthetic pulsing glow effect
    local function pulseGlow()
        while Window and Window.Parent do
            local pulseTween = TweenService:Create(BorderGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Thickness = 2.5})
            pulseTween:Play()
            task.wait(1.5)
            
            if not (Window and Window.Parent) then break end
            
            local pulseTween2 = TweenService:Create(BorderGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Thickness = 1.5})
            pulseTween2:Play()
            task.wait(1.5)
        end
    end
    
    task.spawn(pulseGlow)
    
    -- Window API
    local WindowAPI = {}
    
    -- Create a tab
    function WindowAPI:CreateTab(tabName)
        local TabAPI = {}
        
        -- Create tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName.."Tab"
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 100, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        TabButton.TextSize = 14
        TabButton.Parent = ContentArea
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- Create tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName.."Content"
        TabContent.BackgroundTransparency = 1
        TabContent.Position = UDim2.new(0, 0, 0, 40)
        TabContent.Size = UDim2.new(1, 0, 1, -40)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        -- Auto layout for tab content
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 5)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = TabContent
        
        -- Update canvas size when elements change
        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Show this tab initially if it's the first one
        if #ContentArea:GetChildren() <= 4 then -- Accounting for UIListLayout and potential other non-tab elements
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
        end
        
        -- Tab button functionality
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tab contents
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") and child.Name:find("Content") then
                    child.Visible = false
                end
                if child:IsA("TextButton") and child.Name:find("Tab") then
                    child.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                end
            end
            
            -- Show this tab
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
        end)
        
        -- Create a button element
        function TabAPI:CreateButton(buttonText, callback)
            callback = callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = buttonText.."Button"
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.Font = Enum.Font.Gotham
            Button.Text = buttonText
            Button.TextColor3 = Color3.fromRGB(220, 220, 255)
            Button.TextSize = 14
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            -- Add hover effect
            Button.MouseEnter:Connect(function()
                local hoverTween = TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 90)})
                hoverTween:Play()
            end)
            
            Button.MouseLeave:Connect(function()
                local leaveTween = TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)})
                leaveTween:Play()
            end)
            
            -- Add click effect
            Button.MouseButton1Down:Connect(function()
                local clickTween = TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 120)})
                clickTween:Play()
            end)
            
            Button.MouseButton1Up:Connect(function()
                local releaseTween = TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 90)})
                releaseTween:Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            return Button
        end
        
        -- Create a toggle element
        function TabAPI:CreateToggle(toggleText, callback)
            callback = callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = toggleText.."Toggle"
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -50, 0.5, 0)
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "Circle"
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, 0)
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
            ToggleCircle.Parent = ToggleButton
            
            local ToggleCircleCorner = Instance.new("UICorner")
            ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleCorner.Parent = ToggleCircle
            
            -- Toggle state
            local toggled = false
            
            -- Make the whole frame clickable
            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggled = not toggled
                    
                    -- Move circle
                    local targetPosition = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    local circleColorTarget = toggled and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(200, 200, 255)
                    local bgColorTarget = toggled and Color3.fromRGB(50, 80, 60) or Color3.fromRGB(30, 30, 45)
                    
                    local circleTween = TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                        Position = targetPosition,
                        BackgroundColor3 = circleColorTarget
                    })
                    
                    local bgTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = bgColorTarget
                    })
                    
                    circleTween:Play()
                    bgTween:Play()
                    
                    pcall(callback, toggled)
                end
            end)
            
            local ToggleAPI = {}
            
            function ToggleAPI:SetValue(value)
                toggled = value
                
                -- Move circle
                local targetPosition = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                local circleColorTarget = toggled and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(200, 200, 255)
                local bgColorTarget = toggled and Color3.fromRGB(50, 80, 60) or Color3.fromRGB(30, 30, 45)
                
                local circleTween = TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = targetPosition,
                    BackgroundColor3 = circleColorTarget
                })
                
                local bgTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = bgColorTarget
                })
                
                circleTween:Play()
                bgTween:Play()
                
                pcall(callback, toggled)
            end
            
            function ToggleAPI:GetValue()
                return toggled
            end
            
            return ToggleAPI
        end
        
        -- Create a slider element
        function TabAPI:CreateSlider(sliderText, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end
            
            -- Clamp default value
            default = math.clamp(default, min, max)
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = sliderText.."Slider"
            SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, -10, 0, 50)
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "Label"
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.Size = UDim2.new(1, -60, 0, 20)
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.Text = sliderText
            SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "Value"
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -50, 0, 5)
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            ValueLabel.TextSize = 14
            ValueLabel.Parent = SliderFrame
            
            local SliderBackground = Instance.new("Frame")
            SliderBackground.Name = "Background"
            SliderBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            SliderBackground.BorderSizePixel = 0
            SliderBackground.Position = UDim2.new(0, 10, 0, 30)
            SliderBackground.Size = UDim2.new(1, -20, 0, 10)
            SliderBackground.Parent = SliderFrame
            
            local SliderBackgroundCorner = Instance.new("UICorner")
            SliderBackgroundCorner.CornerRadius = UDim.new(1, 0)
            SliderBackgroundCorner.Parent = SliderBackground
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.Parent = SliderBackground
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderCircle = Instance.new("Frame")
            SliderCircle.Name = "Circle"
SliderCircle.Name = "Circle"
            SliderCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 255)
            SliderCircle.BorderSizePixel = 0
            SliderCircle.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
            SliderCircle.Size = UDim2.new(0, 16, 0, 16)
            SliderCircle.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderCircle.Parent = SliderBackground
            
            local SliderCircleCorner = Instance.new("UICorner")
            SliderCircleCorner.CornerRadius = UDim.new(1, 0)
            SliderCircleCorner.Parent = SliderCircle
            
            -- Slider functionality
            local sliding = false
            local value = default
            
            SliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    -- Update slider on click
                    local relativeX = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * relativeX
                    
                    -- Round to integers if min and max are integers
                    if math.floor(min) == min and math.floor(max) == max then
                        value = math.floor(value + 0.5)
                    end
                    
                    -- Update UI
                    SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    SliderCircle.Position = UDim2.new(relativeX, 0, 0.5, 0)
                    ValueLabel.Text = tostring(value)
                    
                    pcall(callback, value)
                end
            end)
            
            SliderBackground.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
                    -- Update slider
                    local relativeX = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * relativeX
                    
                    -- Round to integers if min and max are integers
                    if math.floor(min) == min and math.floor(max) == max then
                        value = math.floor(value + 0.5)
                    end
                    
                    -- Update UI
                    SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    SliderCircle.Position = UDim2.new(relativeX, 0, 0.5, 0)
                    ValueLabel.Text = tostring(value)
                    
                    pcall(callback, value)
                end
            end)
            
            local SliderAPI = {}
            
            function SliderAPI:SetValue(newValue)
                newValue = math.clamp(newValue, min, max)
                value = newValue
                
                -- Calculate relative position
                local relativeX = (value - min) / (max - min)
                
                -- Update UI
                SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                SliderCircle.Position = UDim2.new(relativeX, 0, 0.5, 0)
                ValueLabel.Text = tostring(value)
                
                pcall(callback, value)
            end
            
            function SliderAPI:GetValue()
                return value
            end
            
            return SliderAPI
        end
        
        -- Create a dropdown element
        function TabAPI:CreateDropdown(dropdownText, options, callback)
            options = options or {}
            callback = callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = dropdownText.."Dropdown"
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Size = UDim2.new(1, -10, 0, 35)
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "Label"
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.Size = UDim2.new(1, -60, 0, 35)
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.Text = dropdownText
            DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
            DropdownLabel.TextSize = 14
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local ArrowImage = Instance.new("ImageLabel")
            ArrowImage.Name = "Arrow"
            ArrowImage.BackgroundTransparency = 1
            ArrowImage.Position = UDim2.new(1, -25, 0, 10)
            ArrowImage.Size = UDim2.new(0, 15, 0, 15)
            ArrowImage.Rotation = 0
            ArrowImage.Image = "rbxassetid://6034818372" -- Down arrow
            ArrowImage.ImageColor3 = Color3.fromRGB(220, 220, 255)
            ArrowImage.Parent = DropdownFrame
            
            local DropdownContent = Instance.new("Frame")
            DropdownContent.Name = "Content"
            DropdownContent.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            DropdownContent.BorderSizePixel = 0
            DropdownContent.Position = UDim2.new(0, 0, 0, 35)
            DropdownContent.Size = UDim2.new(1, 0, 0, #options * 25)
            DropdownContent.Visible = true
            DropdownContent.Parent = DropdownFrame
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 0)
            ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContentLayout.Parent = DropdownContent
            
            -- Selected option
            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Name = "Selected"
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Position = UDim2.new(1, -120, 0, 0)
            SelectedLabel.Size = UDim2.new(0, 100, 0, 35)
            SelectedLabel.Font = Enum.Font.Gotham
            SelectedLabel.Text = options[1] or "Select"
            SelectedLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            SelectedLabel.TextSize = 14
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLabel.Parent = DropdownFrame
            
            -- Add options
            local optionButtons = {}
            for i, optionText in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "Option"..i
                OptionButton.BackgroundTransparency = 1
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = optionText
                OptionButton.TextColor3 = Color3.fromRGB(220, 220, 255)
                OptionButton.TextSize = 14
                OptionButton.Parent = DropdownContent
                
                table.insert(optionButtons, OptionButton)
                
                -- Option click
                OptionButton.MouseButton1Click:Connect(function()
                    SelectedLabel.Text = optionText
                    
                    -- Close dropdown
                    local closeTween = TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 35)})
                    local arrowTween = TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = 0})
                    closeTween:Play()
                    arrowTween:Play()
                    
                    pcall(callback, optionText)
                end)
                
                -- Hover effect
                OptionButton.MouseEnter:Connect(function()
                    local hoverTween = TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.9})
                    hoverTween:Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    local leaveTween = TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundTransparency = 1})
                    leaveTween:Play()
                end)
            end
            
            -- Dropdown toggle
            local dropdownOpen = false
            
            DropdownFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y <= DropdownFrame.AbsolutePosition.Y + 35 then
                    dropdownOpen = not dropdownOpen
                    
                    if dropdownOpen then
                        -- Open dropdown
                        local openTween = TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 35 + #options * 25)})
                        local arrowTween = TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = 180})
                        openTween:Play()
                        arrowTween:Play()
                    else
                        -- Close dropdown
                        local closeTween = TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 35)})
                        local arrowTween = TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = 0})
                        closeTween:Play()
                        arrowTween:Play()
                    end
                end
            end)
            
            local DropdownAPI = {}
            
            function DropdownAPI:SetValue(optionText)
                if table.find(options, optionText) then
                    SelectedLabel.Text = optionText
                    pcall(callback, optionText)
                end
            end
            
            function DropdownAPI:GetValue()
                return SelectedLabel.Text
            end
            
            -- Initialize closed
            DropdownFrame.Size = UDim2.new(1, -10, 0, 35)
            
            return DropdownAPI
        end
        
        -- Create a textbox element
        function TabAPI:CreateTextbox(textboxText, placeholder, callback)
            placeholder = placeholder or "Enter text..."
            callback = callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = textboxText.."Textbox"
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Size = UDim2.new(1, -10, 0, 60)
            TextboxFrame.Parent = TabContent
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 6)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Name = "Label"
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.Text = textboxText
            TextboxLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
            TextboxLabel.TextSize = 14
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local TextboxInput = Instance.new("TextBox")
            TextboxInput.Name = "Input"
            TextboxInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            TextboxInput.BorderSizePixel = 0
            TextboxInput.Position = UDim2.new(0, 10, 0, 30)
            TextboxInput.Size = UDim2.new(1, -20, 0, 25)
            TextboxInput.Font = Enum.Font.Gotham
            TextboxInput.PlaceholderText = placeholder
            TextboxInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
            TextboxInput.Text = ""
            TextboxInput.TextColor3 = Color3.fromRGB(220, 220, 255)
            TextboxInput.TextSize = 14
            TextboxInput.ClearTextOnFocus = false
            TextboxInput.Parent = TextboxFrame
            
            local TextboxInputCorner = Instance.new("UICorner")
            TextboxInputCorner.CornerRadius = UDim.new(0, 4)
            TextboxInputCorner.Parent = TextboxInput
            
            -- Textbox functionality
            TextboxInput.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    pcall(callback, TextboxInput.Text)
                end
            end)
            
            -- Add glow effect on focus
            TextboxInput.Focused:Connect(function()
                local focusTween = TweenService:Create(TextboxInput, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)})
                focusTween:Play()
            end)
            
            TextboxInput.FocusLost:Connect(function()
                local blurTween = TweenService:Create(TextboxInput, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 45)})
                blurTween:Play()
                
                pcall(callback, TextboxInput.Text)
            end)
            
            local TextboxAPI = {}
            
            function TextboxAPI:SetValue(text)
                TextboxInput.Text = text
                pcall(callback, text)
            end
            
            function TextboxAPI:GetValue()
                return TextboxInput.Text
            end
            
            return TextboxAPI
        end
        
        -- Create a label element
        function TabAPI:CreateLabel(labelText)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            LabelFrame.BackgroundTransparency = 0.5
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Size = UDim2.new(1, -10, 0, 30)
            LabelFrame.Parent = TabContent
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Parent = LabelFrame
            
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "Text"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Position = UDim2.new(0, 10, 0, 0)
            TextLabel.Size = UDim2.new(1, -20, 1, 0)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = labelText
            TextLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
            TextLabel.TextSize = 14
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Parent = LabelFrame
            
            local LabelAPI = {}
            
            function LabelAPI:SetText(text)
                TextLabel.Text = text
            end
            
            function LabelAPI:GetText()
                return TextLabel.Text
            end
            
            return LabelAPI
        end
        
        -- Create a separator element
        function TabAPI:CreateSeparator()
            local SeparatorFrame = Instance.new("Frame")
            SeparatorFrame.Name = "Separator"
            SeparatorFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
            SeparatorFrame.BackgroundTransparency = 0.5
            SeparatorFrame.BorderSizePixel = 0
            SeparatorFrame.Size = UDim2.new(1, -20, 0, 1)
            SeparatorFrame.Position = UDim2.new(0, 10, 0, 0)
            SeparatorFrame.Parent = TabContent
            
            return SeparatorFrame
        end
        
        return TabAPI
    end
    
    -- Create a notification inside the window
    function WindowAPI:Notify(options)
        options = options or {}
        options.Title = options.Title or "Notification"
        options.Description = options.Description or "This is a notification"
        options.Duration = options.Duration or 3
        
        -- Create notification frame
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Name = "NotifFrame"
        NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Position = UDim2.new(0.5, 0, 0, -100) -- Start above window
        NotifFrame.Size = UDim2.new(0.8, 0, 0, 60)
        NotifFrame.AnchorPoint = Vector2.new(0.5, 0)
        NotifFrame.ClipsDescendants = true
        NotifFrame.Parent = Window
        
        -- Rounded corners
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = NotifFrame
        
        -- Border glow
        local BorderGlow = Instance.new("UIStroke")
        BorderGlow.Color = Color3.fromRGB(100, 200, 255) -- Blue neon glow
        BorderGlow.Thickness = 1.5
        BorderGlow.Parent = NotifFrame
        
        -- Title
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 10, 0, 5)
        TitleLabel.Size = UDim2.new(1, -20, 0, 20)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = options.Title
        TitleLabel.TextColor3 = Color3.fromRGB(100, 200, 255) -- Blue text
        TitleLabel.TextSize = 16
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotifFrame
        
        -- Description
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Name = "Description"
        DescLabel.BackgroundTransparency = 1
        DescLabel.Position = UDim2.new(0, 10, 0, 30)
        DescLabel.Size = UDim2.new(1, -20, 0, 20)
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.Text = options.Description
        DescLabel.TextColor3 = Color3.fromRGB(220, 220, 255) -- Light blue text
        DescLabel.TextSize = 14
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = NotifFrame
        
        -- Animate in
        local targetPos = UDim2.new(0.5, 0, 0, 10)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local tween = TweenService:Create(NotifFrame, tweenInfo, {Position = targetPos})
        tween:Play()
        
        -- Animate out after duration
        task.delay(options.Duration, function()
            if NotifFrame and NotifFrame.Parent then
                local outPos = UDim2.new(0.5, 0, 0, -100)
                local outTween = TweenService:Create(NotifFrame, tweenInfo, {Position = outPos})
                outTween:Play()
                
                outTween.Completed:Wait()
                NotifFrame:Destroy()
            end
        end)
        
        return NotifFrame
    end
    
    return WindowAPI
end

return Synthwave
