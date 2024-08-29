local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Dungeon RNG",
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

local Options = Fluent.Options
-- <----------------------------------- Auto Farm ----------------------------------->

local MainSection = Tabs.Main:AddSection("Auto Farm")   

local AutoAttackToggle = MainSection:AddToggle("AutoAttack", {Title = "Auto Attack", Default = false })

AutoAttackToggle:OnChanged(function()
    if Options.AutoAttack.Value then
        spawn(function()
            while Options.AutoAttack.Value do
                game:GetService("ReplicatedStorage").Knit.Services.PlayerAttackService.RF.PlayerAttack:InvokeServer()
                wait(0.0001)
            end
        end)
    end
end)

Options.AutoAttack:SetValue(false)

local AutoRollToggle = MainSection:AddToggle("AutoRoll", {Title = "Auto Roll", Default = false })

AutoRollToggle:OnChanged(function()
    if Options.AutoRoll.Value then
        spawn(function()
            while Options.AutoRoll.Value do
                game:GetService("ReplicatedStorage").Knit.Services.RollService.RF.PlayerRoll:InvokeServer()
                wait(0.0001)
            end
        end)
    end
end)

Options.AutoRoll:SetValue(false)

-- <----------------------------------- Auto Quest ----------------------------------->

local AutoQuestSection = Tabs.Main:AddSection("Auto Claim Quest")

local AutoQuestToggle = AutoQuestSection:AddToggle("AutoQuest", {Title = "Auto Claim All Quest", Default = false })

AutoQuestToggle:OnChanged(function()
    if Options.AutoQuest.Value then
        spawn(function()
            while Options.AutoQuest.Value do
                local questTypes = {"Luck", "Roll Speed", "Shiny Luck", "Void Roll", "Sacrifice", "Daily Claim", "Relic Crafted", "King Pulls"}
                for _, questType in ipairs(questTypes) do
                    local args = {
                        [1] = questType
                    }
                    game:GetService("ReplicatedStorage").Knit.Services.QuestService.RF.Redeem:InvokeServer(unpack(args))
                end
                wait(5) -- Wait 5 seconds before trying to claim quests again
            end
        end)
    end
end)

Options.AutoQuest:SetValue(false)

-- <----------------------------------- Auto Potion ----------------------------------->

local AutoPotionSection = Tabs.Main:AddSection("Auto Potion")

local AutoLuckPotionToggle = AutoPotionSection:AddToggle("AutoLuckPotion", {Title = "Auto Luck Potion", Default = false })

AutoLuckPotionToggle:OnChanged(function()
    if Options.AutoLuckPotion.Value then
        spawn(function()
            while Options.AutoLuckPotion.Value do
                local args = {
                    [1] = "Luck",
                    [2] = 1
                }
                game:GetService("ReplicatedStorage").Knit.Services.PotionInventoryService.RF.ConsumePotion:InvokeServer(unpack(args))
                wait(1) -- Adjust this delay as needed
            end
        end)
    end
end)

Options.AutoLuckPotion:SetValue(false)

local AutoRollSpeedPotionToggle = AutoPotionSection:AddToggle("AutoRollSpeedPotion", {Title = "Auto RollSpeed Potion", Default = false })

AutoRollSpeedPotionToggle:OnChanged(function()
    if Options.AutoRollSpeedPotion.Value then
        spawn(function()
            while Options.AutoRollSpeedPotion.Value do
                local args = {
                    [1] = "RollSpeed",
                    [2] = 1
                }
                game:GetService("ReplicatedStorage").Knit.Services.PotionInventoryService.RF.ConsumePotion:InvokeServer(unpack(args))
                wait(1) -- Adjust this delay as needed
            end
        end)
    end
end)

Options.AutoRollSpeedPotion:SetValue(false)

-- <----------------------------------- End Auto Farm ----------------------------------->

-- <----------------------------------- Auto Dungeon ----------------------------------->

local AutoDungeonSection = Tabs.Main:AddSection("Auto Dungeon")

local dungeonValues = {}
for i = 1, 36 do
    table.insert(dungeonValues, "Dungeon" .. i)
end

local DungeonDropdown = AutoDungeonSection:AddDropdown("DungeonSelect", {
    Title = "Select Dungeon",
    Values = dungeonValues,
    Multi = false,
    Default = 1,
})

DungeonDropdown:SetValue("Dungeon1")

DungeonDropdown:OnChanged(function(Value)
    print("Selected Dungeon:", Value)
    selectedDungeon = Value
end)

local AutoDungeonToggle = AutoDungeonSection:AddToggle("AutoDungeon", {Title = "Auto Dungeon", Default = false })

AutoDungeonToggle:OnChanged(function()
    if Options.AutoDungeon.Value then
        spawn(function()
            while Options.AutoDungeon.Value do
                -- Teleport to Entrance floor of selected dungeon
                local dungeon = workspace.Dungeons:FindFirstChild(selectedDungeon)
                if dungeon then
                    local entranceFloor = dungeon.Entrance.Entrancefloor
                    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(entranceFloor.CFrame + Vector3.new(0, 3, 0))
                    
                    wait(3) -- Wait for teleport to complete
                    
                    -- Enter dungeon and defeat enemies
                    local function enterAndClearRoom()
                        local roomFolder
                        for i = 1, 10 do
                            roomFolder = game.Workspace.Runtime.Rooms:FindFirstChild(game.Players.LocalPlayer.Name .. ":Room" .. i)
                            if roomFolder then break end
                        end
                        
                        if roomFolder then
                            local enemiesFolder = game.Workspace.Runtime.Enemies
                            
                            while #enemiesFolder:GetChildren() > 0 do
                                local nearestEnemy = enemiesFolder:GetChildren()[1]
                                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(nearestEnemy.PrimaryPart.CFrame + Vector3.new(0, 10, 0))
                                wait(0.0001)
                                -- Attack logic here (you may need to adjust this based on your game's attack mechanism)
                                game:GetService("ReplicatedStorage").Knit.Services.PlayerAttackService.RF.PlayerAttack:InvokeServer()
                                wait(0.5)
                            end
                            
                            return true -- Room cleared
                        end
                        return false -- Room not found
                    end
                    
                    local roomCleared = enterAndClearRoom()
                    
                    if roomCleared then
                        print("Room cleared, returning to lobby")
                        -- Add logic to return to lobby if needed
                        wait(2) -- Wait before starting the next run
                    else
                        print("Failed to enter room or clear enemies")
                        wait(5) -- Wait before retrying
                    end
                else
                    print("Selected dungeon not found")
                    wait(5) -- Wait before retrying
                end
            end
        end)
    end
end)

Options.AutoDungeon:SetValue(false)

-- <----------------------------------- End Auto Dungeon ----------------------------------->

-- <----------------------------------- Credit ----------------------------------->

local CreditsSection = Tabs.Credits:AddParagraph({
    Title = "Script by Lomu",
    Content = "Credits to the original author of the script"
})

local PlayerSection = Tabs.Player:AddSection("Player")

-- <----------------------------------- End Credit ----------------------------------->


-- <----------------------------------- Player ----------------------------------->

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

-- }<----------------------------------- End Player ----------------------------------->


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

