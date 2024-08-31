local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create a ScreenGui to hold the toggle button
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FluentToggleGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the toggle button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.AnchorPoint = Vector2.new(0.5, 0)
ToggleButton.Position = UDim2.new(0.5, 0, 0, 20)
ToggleButton.Text = "-"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
ToggleButton.BorderSizePixel = 0
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 30
ToggleButton.ZIndex = 1000
ToggleButton.Parent = ScreenGui

local Window = Fluent:CreateWindow({
    Title = "Block Eaters",
    SubTitle = "by Lomu",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-- Add toggle functionality
local isVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    if isVisible then
        Window:Restore()
    else
        Window:Minimize()
    end
    ToggleButton.Text = isVisible and "-" or "+"
end)


-- This script was generated by Hydroxide's RemoteSpy: https://github.com/Upbolt/Hydroxide


--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "command" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "contact" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })

-- ... existing code ...

do
    -- ... existing code ...

    local AutoFarmSection = Tabs.Main:AddSection("Auto Farm")

    local SizeInput = AutoFarmSection:AddInput("SizeInput", {
        Title = "Size Amount",
        Default = "",
        Placeholder = "Enter amount of size",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when Enter is pressed
        Callback = function(Value)
            print("Size amount changed:", Value)
        end
    })

    AutoFarmSection:AddButton({
        Title = "Add Size",
        Description = "Add size based on input",
        Callback = function()
            local ohNumber1 = tonumber(SizeInput.Value) 
            game:GetService("ReplicatedStorage").Honeypot.Internal.RemoteStorage["AwardSpinSize - RemoteEvent"]:FireServer(ohNumber1)
            Fluent:Notify({
                Title = "Size Added",
                Content = "Amount: " .. tostring(ohNumber1),
                Duration = 3
            })
        end
    })

    -- Add auto claim reward toggle
    local autoClaimEnabled = false
    local autoClaimConnection

    local AutoClaimToggle = AutoFarmSection:AddToggle("AutoClaimToggle", {
        Title = "Auto Claim Reward",
        Default = false,
        Callback = function(Value)
            autoClaimEnabled = Value
            if autoClaimEnabled then
                autoClaimConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    for i = 1, 12 do
                        game:GetService("ReplicatedStorage").Honeypot.Internal.RemoteStorage["ClaimPlaytimeReward - RemoteEvent"]:FireServer(i)
                    end
                end)
            else
                if autoClaimConnection then
                    autoClaimConnection:Disconnect()
                end
            end
        end
    })

    local AwardXpToggle = AutoFarmSection:AddToggle("AwardXpToggle", {
        Title = "Auto Award XP",
        Default = false,
        Callback = function(Value)
            if Value then
                _G.awardXpLoop = true
                spawn(function()
                    while _G.awardXpLoop do
                        game:GetService("ReplicatedStorage").Honeypot.Internal.RemoteStorage["AwardXp - RemoteEvent"]:FireServer(math.huge)
                        wait(0.1) -- Menambahkan sedikit delay untuk mengurangi beban server
                    end
                end)
            else
                _G.awardXpLoop = false
            end
        end
    })

    -- Add Auto Kill Player toggle
    local autoKillEnabled = false
    local autoKillConnection

    local AutoKillToggle = AutoFarmSection:AddToggle("AutoKillToggle", {
        Title = "Auto Kill Player",
        Default = false,
        Callback = function(Value)
            autoKillEnabled = Value
            if autoKillEnabled then
                autoKillConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    local players = game:GetService("Workspace").PlayerBlobs:GetChildren()
                    local localPlayer = game.Players.LocalPlayer
                    local randomPlayer = players[math.random(1, #players)]
                    
                    if randomPlayer.Name ~= localPlayer.Name and randomPlayer:FindFirstChild("Humanoid") then
                        local targetHumanoid = randomPlayer.Humanoid
                        local localHumanoid = game:GetService("Workspace").PlayerBlobs[localPlayer.Name].Humanoid
                        
                        if localHumanoid and targetHumanoid then
                            localHumanoid.RootPart.CFrame = targetHumanoid.RootPart.CFrame
                        end
                    end
                end)
            else
                if autoKillConnection then
                    autoKillConnection:Disconnect()
                end
            end
        end
    })

    local skinValues = {}
    for i = 1, 46 do
        table.insert(skinValues, i)
    end


    local SkinSection = Tabs.Main:AddSection("Skin")

    local selectedSkin = 1
    local SkinDropdown = SkinSection:AddDropdown("SkinDropdown", {
        Title = "Select Skin",
        Values = skinValues,
        Multi = false,
        Default = 1,
        Callback = function(Value)
            selectedSkin = Value
        end
    })

    SkinSection:AddButton({
        Title = "Equip Selected Skin",
        Description = "Equip the skin selected in the dropdown",
        Callback = function()
            game:GetService("ReplicatedStorage").Honeypot.Internal.RemoteStorage["EquipSkin - RemoteEvent"]:FireServer(selectedSkin)
            Fluent:Notify({
                Title = "Skin Equipped",
                Content = "Equipped skin number: " .. tostring(selectedSkin),
                Duration = 3
            })
        end
    })

    local CreditsSection = Tabs.Credits:AddParagraph({
        Title = "Script by Lomu",
        Content = "Credits to the original author of the script"
    })
    
    local PlayerSection = Tabs.Player:AddSection("Player")
    
    local WalkSpeedSlider = PlayerSection:AddSlider("WalkSpeed", {
        Title = "Walk Speed",
        Description = "Adjust your character's walk speed",
        Default = 16,
        Min = 16,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    })
    
    local JumpPowerSlider = PlayerSection:AddSlider("JumpPower", {
        Title = "Jump Power",
        Description = "Adjust your character's jump power",
        Default = 50,
        Min = 50,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    })
    
    local FOVSlider = PlayerSection:AddSlider("FOV", {
        Title = "Field of View",
        Description = "Adjust your camera's field of view",
        Default = 70,
        Min = 10,
        Max = 120,
        Rounding = 0,
        Callback = function(Value)
            game.Workspace.CurrentCamera.FieldOfView = Value
        end
    })
    
    local NoclipToggle = PlayerSection:AddToggle("Noclip", {
        Title = "Noclip",
        Default = false,
        Callback = function(Value)
            local Player = game.Players.LocalPlayer
            local Character = Player.Character or Player.CharacterAdded:Wait()
            
            if Value then
                local function NoclipLoop()
                    for _, v in pairs(Character:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                        end
                    end
                end
                
                Noclipping = game:GetService('RunService').Stepped:Connect(NoclipLoop)
            else
                if Noclipping then
                    Noclipping:Disconnect()
                end
                
                for _, v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == false then
                        v.CanCollide = true
                    end
                end
            end
        end
    })
    
    local InfiniteJumpToggle = PlayerSection:AddToggle("InfiniteJump", {
        Title = "Infinite Jump",
        Default = false,
        Callback = function(Value)
            local Player = game.Players.LocalPlayer
            if Value then
                InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end)
            else
                if InfiniteJumpConnection then
                    InfiniteJumpConnection:Disconnect()
                end
            end
        end
    })
    
    local GravitySlider = PlayerSection:AddSlider("Gravity", {
        Title = "Gravity",
        Description = "Adjust the game's gravity",
        Default = 196.2,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Callback = function(Value)
            game.Workspace.Gravity = Value
        end
    })
end

-- ... rest of the existing code ...
end

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

-- Ensure the ToggleButton stays visible even when the UI is closed
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "ScreenGui" then
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end)