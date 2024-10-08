_Hawk = "ohhahtuhthttouttpwuttuaunbotwo"

local Hawk = loadstring(game:HttpGet("https://raw.githubusercontent.com/incrimination/HawkHUB-fork/refs/heads/main/LibSources/HawkLib.lua", true))()

local Window = Hawk:Window({
    ScriptName = "Hawk HUB",
    DestroyIfExists = true,
    Theme = "Dark"
})

Window:Close({
    visibility = true,
    Callback = function()
        Window:Destroy()
    end,
})

Window:Minimize({
    visibility = true,
    OpenButton = true,
    Callback = function()
    end,
})

local tab1 = Window:Tab("Games")

local gamesSection = tab1:Section("Supported Games")

local function createGameButton(placeName, placeId, scriptUrl)
    gamesSection:Button(placeName, "Load script for " .. placeName, function()
        if game.PlaceId == placeId then
            loadstring(game:HttpGet(scriptUrl, true))()
        else
            Hawk:AddNotifications():Notification("Error", "Wrong game!", "Error", 3)
        end
        Window:Destroy()
    end)
end

-- Create buttons for each game
createGameButton("Factory RNG", 18481040458, "https://raw.githubusercontent.com/jkancc111/Games/main/FactoryRNG.lua")
createGameButton("Dungeon RNG", 17534163435, "https://raw.githubusercontent.com/jkancc111/Games/main/DungeonRNG.lua")
createGameButton("Lick Simulator", 16466634211, "https://raw.githubusercontent.com/jkancc111/Games/main/LickSimulator.lua")
createGameButton("Block Eaters", 16178787698, "https://raw.githubusercontent.com/jkancc111/Games/main/BlockEaters.lua")
createGameButton("Legend Of Speed", 3101667897, "https://raw.githubusercontent.com/jkancc111/Games/main/LegendOfSpeed.lua")
createGameButton("Fat Race", 18130504174, "https://raw.githubusercontent.com/jkancc111/Games/main/FatRace.lua")
createGameButton("Granny Multiplayer", 4480809144, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/GrannyMultiplayer.txt")
createGameButton("Impossible Glass Bridge", 16993432698, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/ImpossibleGlassBridge.txt")
createGameButton("Reborn As Swordman", 16981421605, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/RebornAsSwordman.lua")
createGameButton("Build A Bridge Simulator", 16280073867, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/MakeABridgeSim.txt")
createGameButton("Dragon Merge Tycoon", 17415466926, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/DragonMergeTycoon.txt")
createGameButton("Duck Army", 13926416231, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/DuckArmy.txt")
createGameButton("Every Click +1 Speed", 18768679013, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/EveryClick%2B1Speed.txt")
createGameButton("Mining Tycoon", 18920893671, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/MiningTycoon.txt")
createGameButton("Meme Race", 18778623849, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/MemeRace.txt")
createGameButton("Destruction Simulator", 2248408710, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/DestructionSimulator.txt")
createGameButton("Clicking Gods", 9150032572, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/ClickingGods.txt")
createGameButton("Strongest Smacker Simulator", 18134655434, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/StrongestSmackSim.txt")

gamesSection:Button("Swim League", "Load script for Swim League", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/SwimLeague.txt", true))()
    Window:Destroy() 
end)
