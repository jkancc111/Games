local KeySystemUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MaGiXxScripter0/keysystemv2api/master/ui/xrer_mstudio45.lua"))()
KeySystemUI.New({
    ApplicationName = "LomuHub", -- Your Key System Application Name
    Name = "LomuHub", -- Your Script name
    Info = "Get Key For LomuHub", -- Info text in the GUI, keep empty for default text.
    DiscordInvite = "", -- Optional.
    AuthType = "clientid" -- Can select verifycation with ClientId or IP ("clientid" or "ip")
})
repeat task.wait() until KeySystemUI.Finished() or KeySystemUI.Closed
if KeySystemUI.Finished() and KeySystemUI.Closed == false then

    repeat task.wait(0.25) until game:IsLoaded();
    getgenv().Image = "rbxassetid://131242153792023";
    getgenv().ToggleUI = Enum.KeyCode.E 
    
    local Fluent = nil
    
    task.spawn(function()
        if not getgenv().LoadedMobileUI then 
            getgenv().LoadedMobileUI = true
            local OpenUI = Instance.new("ScreenGui")
            local ImageButton = Instance.new("ImageButton")
            local UICorner = Instance.new("UICorner")
            OpenUI.Name = "OpenUI"
            OpenUI.Parent = game:GetService("CoreGui")
            OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ImageButton.Parent = OpenUI
            ImageButton.BackgroundColor3 = Color3.fromRGB(105,105,105)
            ImageButton.BackgroundTransparency = 0.8
            ImageButton.Position = UDim2.new(0.9,0,0.1,0)
            ImageButton.Size = UDim2.new(0,50,0,50)
            ImageButton.Image = getgenv().Image
            ImageButton.Draggable = true
            ImageButton.Transparency = 0.5
            UICorner.CornerRadius = UDim.new(0,200)
            UICorner.Parent = ImageButton
            local function ToggleUI()
                if Fluent and Fluent.Window then
                    Fluent.Window:Minimize()
                end
            end
            ImageButton.MouseButton1Click:Connect(ToggleUI)
            
            game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == getgenv().ToggleUI then
                    ToggleUI()
                end
            end)
        end
    end)
    
    Fluent = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Nevcit/UI-Library/main/Loadstring/FluentLib')))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    
    local Window = Fluent:CreateWindow({
        Title = "Lomu Hub | Anime Shadow",
        SubTitle = "by Lomu",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = getgenv().ToggleUI -- Use the same key for consistency
    })
    
    local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "command" }),
        Egg = Window:AddTab({ Title = "Egg", Icon = "egg" }),
        Credits = Window:AddTab({ Title = "Credits", Icon = "contact" })
    }
    
    local Options = Fluent.Options
    
    -- Main Tab
    local MainSection = Tabs.Main:AddSection("Auto Farm Section")

    local SelectedLocation = nil
    local SelectedEnemy = nil
    local AutoFarmEnabled = false
    local AutoFarmConnection = nil

    -- Function to get all player's pet IDs
    local function GetAllPlayerPetIDs()
        local playerName = game.Players.LocalPlayer.Name
        local petPrefix = playerName .. "---"
        local petIDs = {}
        
        for _, pet in pairs(workspace.Server.Pets:GetChildren()) do
            local petName = pet.Name
            if petName:match("^" .. petPrefix) then
                -- Ambil ID dari setiap pet milik player
                table.insert(petIDs, petName:sub(#petPrefix + 1))
            end
        end
        return petIDs
    end

    -- Location Dropdown
    local LocationDropdown = Tabs.Main:AddDropdown("LocationDropdown", {
        Title = "Select Location",
        Values = (function()
            local locations = {}
            for _, location in pairs(workspace.Server.Enemies:GetChildren()) do
                table.insert(locations, location.Name)
            end
            return locations
        end)(),
        Multi = false,
        Default = nil,
        Callback = function(Value)
            SelectedLocation = Value
            SelectedEnemy = nil
            UpdateEnemyList()
        end
    })

    -- Enemy Dropdown
    local EnemyDropdown = Tabs.Main:AddDropdown("EnemyDropdown", {
        Title = "Select Enemy",
        Values = {},
        Multi = false,
        Default = nil,
        Callback = function(Value)
            SelectedEnemy = Value
        end
    })

    -- Update enemy list function
    function UpdateEnemyList()
        if SelectedLocation then
            local uniqueEnemies = {} -- Table untuk menyimpan nama unik
            local enemyList = {} -- List untuk dropdown
            
            -- Kumpulkan semua nama musuh yang unik
            for _, enemy in pairs(workspace.Server.Enemies[SelectedLocation]:GetChildren()) do
                if enemy:IsA("BasePart") then
                    local enemyName = enemy.Name
                    if not uniqueEnemies[enemyName] then
                        uniqueEnemies[enemyName] = true
                        table.insert(enemyList, enemyName)
                    end
                end
            end
            
            -- Update dropdown dengan list yang sudah tidak ada duplikat
            table.sort(enemyList) -- Optional: mengurutkan nama musuh
            EnemyDropdown:SetValues(enemyList)
        end
    end

    -- Function to check if our pets are still attacking the enemy
    local function ArePetsAttackingEnemy(enemy)
        local petsFolder = enemy:FindFirstChild("Info") 
            and enemy.Info:FindFirstChild("Pets")
        
        if petsFolder then
            -- Cek apakah ada NumberValue dengan nama yang mengandung username player
            local playerName = game.Players.LocalPlayer.Name
            for _, value in pairs(petsFolder:GetChildren()) do
                if value:IsA("NumberValue") and value.Name:find(playerName) then
                    print("[Debug] Found pet still attacking:", value.Name)
                    return true
                end
            end
        end
        print("[Debug] No pets found attacking enemy")
        return false
    end

    -- Auto Farm Toggle
    local AutoFarm = Tabs.Main:AddToggle("AutoFarm", {
        Title = "Auto Farm",
        Default = false,
        Callback = function(Value)
            AutoFarmEnabled = Value
            print("[Debug] Auto Farm Toggled:", AutoFarmEnabled)
            
            if AutoFarmEnabled then
                print("[Debug] Starting Auto Farm Connection")
                -- Simpan referensi musuh terakhir yang dilawan
                local lastEnemy = nil
                
                AutoFarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if SelectedLocation and SelectedEnemy then
                        -- Cari musuh baru jika lastEnemy masih ada
                        local enemy
                        if lastEnemy then
                            -- Cari musuh dengan nama yang sama tapi bukan yang terakhir dilawan
                            for _, potentialEnemy in pairs(workspace.Server.Enemies[SelectedLocation]:GetChildren()) do
                                if potentialEnemy.Name == SelectedEnemy and potentialEnemy ~= lastEnemy then
                                    enemy = potentialEnemy
                                    break
                                end
                            end
                            -- Jika tidak menemukan musuh baru, reset lastEnemy
                            if not enemy then
                                lastEnemy = nil
                            end
                        end
                        
                        -- Jika tidak ada lastEnemy atau tidak menemukan musuh baru, ambil musuh dari pilihan awal
                        if not enemy then
                            enemy = workspace.Server.Enemies[SelectedLocation][SelectedEnemy]
                        end
                        
                        if enemy then
                            print("[Debug] Current Enemy:", enemy.Name)
                            
                            -- Teleport ke musuh yang dipilih
                            local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart then
                                humanoidRootPart.CFrame = enemy.CFrame * CFrame.new(0, 0, 5)
                            end

                            -- Get pet IDs dan attack
                            local petIDs = GetAllPlayerPetIDs()
                            if #petIDs > 0 then
                                -- Click remote
                                game:GetService("ReplicatedStorage").Remotes.Bridge:FireServer(
                                    "Enemies",
                                    "World",
                                    "Click"
                                )
                                
                                -- Attack dengan semua pet
                                for _, petID in ipairs(petIDs) do
                                    game:GetService("ReplicatedStorage").Remotes.Bridge:FireServer(
                                        "General",
                                        "Pets",
                                        "Attack",
                                        petID,
                                        enemy
                                    )
                                    task.wait(0.05)
                                end
                                
                                -- Tunggu sebentar untuk pets muncul di Info.Pets
                                task.wait(0.2)
                                
                                -- Cek apakah pets sudah mulai menyerang
                                local petsFolder = enemy:FindFirstChild("Info") 
                                    and enemy.Info:FindFirstChild("Pets")
                                
                                if petsFolder then
                                    -- Tunggu sampai pets hilang (musuh mati)
                                    local playerName = game.Players.LocalPlayer.Name
                                    while true do
                                        local petFound = false
                                        for _, value in pairs(petsFolder:GetChildren()) do
                                            if value:IsA("NumberValue") and value.Name:find(playerName) then
                                                petFound = true
                                                break
                                            end
                                        end
                                        
                                        if not petFound then
                                            print("[Debug] Pets no longer attacking, enemy defeated")
                                            -- Set lastEnemy ke musuh yang baru saja dikalahkan
                                            lastEnemy = enemy
                                            break
                                        end
                                        task.wait(0.1)
                                    end
                                end
                            end
                            task.wait(0.1)
                        end
                    end
                end)
            else
                if AutoFarmConnection then
                    AutoFarmConnection:Disconnect()
                    AutoFarmConnection = nil
                end
            end
        end
    })

    -- Add Auto Collect Toggle
    local AutoCollectEnabled = false
    local AutoCollectConnection = nil

    local AutoCollect = Tabs.Main:AddToggle("Auto Collect", {
        Title = "Auto Collect",
        Default = false,
        Callback = function(Value)
            AutoCollectEnabled = Value
            
            if AutoCollectEnabled then
                AutoCollectConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    local ohString1 = "General"
                    local ohString2 = "Drops"
                    local ohString3 = "Collect"
                    
                    -- Find all drops in workspace
                    for _, drop in pairs(workspace.Client.Drops:GetChildren()) do
                        local ohString4 = drop.Name
                        game:GetService("ReplicatedStorage").Remotes.Bridge:FireServer(
                            ohString1, 
                            ohString2, 
                            ohString3, 
                            ohString4
                        )
                    end
                end)
            else
                if AutoCollectConnection then
                    AutoCollectConnection:Disconnect()
                    AutoCollectConnection = nil
                end
            end
        end
    })

    -- Add Egg Tab
    local EggSection = Tabs.Egg:AddSection("Auto Egg Section")

    -- Variables for egg settings
    local SelectedLocations = {}
    local SelectedCurrency = "Coins"
    local SelectedOpenType = "Open"
    local AutoEggEnabled = false
    local AutoEggConnection = nil

    -- Location Dropdown (Multi-select)
    local LocationDropdown = Tabs.Egg:AddDropdown("StarLocations", {
        Title = "Select Star Locations",
        Values = (function()
            local locations = {}
            for _, location in pairs(workspace.Server.Stars:GetChildren()) do
                table.insert(locations, location.Name)
            end
            return locations
        end)(),
        Multi = true,
        Default = {},
        Callback = function(Value)
            SelectedLocations = Value
        end
    })

    -- Currency Dropdown
    local CurrencyDropdown = Tabs.Egg:AddDropdown("Currency", {
        Title = "Select Currency",
        Values = {"Coins", "Tickets"},
        Multi = false,
        Default = "Coins",
        Callback = function(Value)
            SelectedCurrency = Value
        end
    })

    -- Open Type Dropdown
    local OpenTypeDropdown = Tabs.Egg:AddDropdown("OpenType", {
        Title = "Select Open Type",
        Values = {"Open", "Multi"},
        Multi = false,
        Default = "Open",
        Callback = function(Value)
            SelectedOpenType = Value
        end
    })

    -- Auto Egg Toggle
    local AutoEgg = Tabs.Egg:AddToggle("AutoEgg", {
        Title = "Auto Open Egg",
        Default = false,
        Callback = function(Value)
            AutoEggEnabled = Value
            
            if AutoEggEnabled then
                AutoEggConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if SelectedLocations and SelectedOpenType then
                        for location, _ in pairs(SelectedLocations) do
                            -- Teleport to location's Coins
                            local starLocation = workspace.Server.Stars[location]
                            if starLocation and starLocation:FindFirstChild("Coins") then
                                local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if humanoidRootPart then
                                    local coinsPrimaryPart = starLocation.Coins.PrimaryPart
                                    if coinsPrimaryPart then
                                        humanoidRootPart.CFrame = coinsPrimaryPart.CFrame * CFrame.new(0, 0, 5)
                                    end
                                end
                            end
                            
                            -- Fire remote with string value
                            game:GetService("ReplicatedStorage").Remotes.Bridge:FireServer(
                                "General",
                                "Stars",
                                SelectedOpenType, -- Langsung kirim "Open" atau "Multi"
                                location,
                                SelectedCurrency
                            )
                            task.wait(0.1)
                        end
                        task.wait(0.2)
                    end
                end)
            else
                if AutoEggConnection then
                    AutoEggConnection:Disconnect()
                    AutoEggConnection = nil
                end
            end
        end
    })

    Tabs.Credits:AddParagraph({
        Title = "Script by Lomu",
        Content = "Credits to the original author of the script"
    })
    InterfaceManager:SetFolder("LomuHub")
    SaveManager:SetFolder("LomuHub/configs")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
    SaveManager:LoadAutoloadConfig()
else
    print("Player closed the GUI.")
end