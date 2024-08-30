local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Lick Simulator",
    SubTitle = "by Lomu",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "command" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "contact" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local AutoFarmSection = Tabs.Main:AddSection("Auto Farm")

-- Main Tab
AutoFarmSection:AddToggle("AutoLick", {
    Title = "Auto Lick",
    Default = false,
    Callback = function(Value)
        _G.AutoLick = Value
        if Value then
            spawn(function()
                while _G.AutoLick do
                    game:GetService("ReplicatedStorage").Remotes.Lick:FireServer()
                    game:GetService("RunService").Heartbeat:Wait() -- Tunggu satu frame
                end
            end)
        end
    end
})

local function getBossList()
    local bossList = {"None"}
    local npcsFolder = workspace:FindFirstChild("NPCS")
    
    if npcsFolder then
        local zones = {"Nature", "Desert", "Lava", "Haunted", "Sky", "Candy Zone", "Space", "Snow"}
        for _, zoneName in ipairs(zones) do
            local zoneFolder = npcsFolder:FindFirstChild(zoneName)
            if zoneFolder then
                local bossCount = 0
                for _, npc in ipairs(zoneFolder:GetChildren()) do
                    if npc:IsA("Model") then
                        table.insert(bossList, zoneName .. " - " .. npc.Name)
                        bossCount = bossCount + 1
                        if bossCount == 5 then break end -- Limit to 5 bosses per zone
                    end
                end
            end
        end
    end
    
    return bossList
end

local selectedBoss = "None"
AutoFarmSection:AddDropdown("BossSelector", {
    Title = "Select Boss",
    Values = getBossList(),
    Multi = false,
    Default = 1,
    Callback = function(Value)
        selectedBoss = Value
    end
})

AutoFarmSection:AddToggle("AutoBossChallenge", {
    Title = "Auto Boss",
    Default = false,
    Callback = function(Value)
        _G.AutoBossChallenge = Value
        if Value then
            spawn(function()
                while _G.AutoBossChallenge do
                    if selectedBoss ~= "None" then
                        local zoneName, bossName = selectedBoss:match("(.+) %- (.+)")
                        if zoneName and bossName then
                            local boss = workspace.NPCS[zoneName]:FindFirstChild(bossName)
                            if boss then
                                -- Mulai tantangan boss
                                game:GetService("ReplicatedStorage").Remotes.ClientBossFightStart:FireServer(boss)
                                
                                -- Serang boss sampai tidak ada lagi di FightScene
                                while _G.AutoBossChallenge do
                                    if not workspace.FightScene:FindFirstChild(bossName) then
                                        break  -- Boss sudah dikalahkan, keluar dari loop
                                    end
                                    game:GetService("ReplicatedStorage").Remotes.AttackBoss:FireServer()
                                    game:GetService("RunService").Heartbeat:Wait() -- Tunggu satu frame
                                end
                            end
                        end
                    end
                    game:GetService("RunService").Heartbeat:Wait() -- Tunggu satu frame sebelum mencoba boss berikutnya
                end
            end)
        end
    end
})

local OtherSection = Tabs.Main:AddSection("Other")

OtherSection:AddToggle("AutoSpinWheel", {
    Title = "Auto Spin Wheel",
    Default = false,
    Callback = function(Value)
        _G.AutoSpinWheel = Value
        if Value then
            spawn(function()
                while _G.AutoSpinWheel do
                    game:GetService("ReplicatedStorage").Functions.SpinWheel:InvokeServer()
                    wait(0.0001)
                end
            end)
        end
    end
})

OtherSection:AddToggle("AutoRebirth", {
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(Value)
        _G.AutoRebirth = Value
        if Value then
            spawn(function()
                while _G.AutoRebirth do
                    game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
                    wait(0.0001)
                end
            end)
        end
    end
})

OtherSection:AddToggle("AutoClaimLimitedPet", {
    Title = "Dupe Limited Pet",
    Default = false,
    Description = "Must Wait Until You Can Collect Limited Pet",
    Callback = function(Value)
        _G.AutoClaimLimitedPet = Value
        if Value then
            spawn(function()
                while _G.AutoClaimLimitedPet do
                    game:GetService("ReplicatedStorage").Remotes.ClaimLimitedPet:FireServer()
                    game:GetService("RunService").Heartbeat:Wait() -- Tunggu satu frame
                end
            end)
        end
    end
})

OtherSection:AddToggle("AutoCollectPlayTime", {
    Title = "Auto Collect Play Time",
    Default = false,
    Callback = function(Value)
        _G.AutoCollectPlayTime = Value
        if Value then
            spawn(function()
                while _G.AutoCollectPlayTime do
                    for i = 1, 9 do
                        local args = {
                            [1] = tostring(i)
                        }
                        game:GetService("ReplicatedStorage").Remotes.PlayTimeRewards:FireServer(unpack(args))
                        wait(1)
                    end
                    wait(30)
                end
            end)
        end
    end
})

local AutoPotionSection = Tabs.Main:AddSection("Auto Potion")

local function createPotionToggle(potionType)
    AutoPotionSection:AddToggle("AutoUse" .. potionType, {
        Title = "Auto Use " .. potionType .. " Potion",
        Default = false,
        Callback = function(Value)
            _G["AutoUse" .. potionType] = Value
            if Value then
                spawn(function()
                    while _G["AutoUse" .. potionType] do
                        local args = {
                            [1] = potionType
                        }
                        game:GetService("ReplicatedStorage").Remotes.UsePotion:FireServer(unpack(args))
                        wait(1)
                    end
                end)
            end
        end
    })
end

createPotionToggle("Lick Power")
createPotionToggle("Coins")
createPotionToggle("Gems")

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
        -- The callback will only be triggered when the player changes the slider
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
        -- The callback will only be triggered when the player changes the slider
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
        -- The callback will only be triggered when the player changes the slider
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
        -- The callback will only be triggered when the player changes the slider
        game.Workspace.Gravity = Value
    end
})

-- Notifications
Fluent:Notify({
    Title = "Lomu Hub",
    Content = "The script has been loaded successfully.",
    Duration = 5
})

-- Settings
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("LomuHub")
SaveManager:SetFolder("LomuHub/configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()