_Hawk = "ohhahtuhthttouttpwuttuaunbotwo"

local Hawk = loadstring(game:HttpGet("https://raw.githubusercontent.com/incrimination/HawkHUB-fork/refs/heads/main/LibSources/HawkLib.lua", true))()

local Window = Hawk:Window({
    ScriptName = "Lomu HUB",
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
local infoTab = Window:Tab("ℹ️ Information")

-- Add information sections
local execInfo = infoTab:Section("⚠️ Executor Requirements")
execInfo:Label("• This script requires an executor with 100% UNC support")
execInfo:Label("• If you see 'hands up skid' in console, your executor")
execInfo:Label("  doesn't support obfuscated scripts")

local scriptInfo = infoTab:Section("📝 Script Information")
scriptInfo:Label("• Version: 1.0.0")
scriptInfo:Label("• Last Updated: 2024")
scriptInfo:Label("• Created by: Lomu")

local troubleInfo = infoTab:Section("🔧 Troubleshooting")
troubleInfo:Label("• If script fails to load, try running it again")
troubleInfo:Label("• Make sure you're in the correct game")
troubleInfo:Label("• Check if your executor is updated")
troubleInfo:Label("• Join our Discord for support")

local creditsInfo = infoTab:Section("👥 Credits")
creditsInfo:Label("• UI Library: HawkLib")
creditsInfo:Label("• Special thanks to all contributors")

local Recome = tab1:Section("🔥 Frequently executed scripts")

local function CreateRecomend(placeName, placeId, scriptUrl)
    Recome:Button(placeName, "Load script for " .. placeName, function()
        if game.PlaceId == placeId then
            loadstring(game:HttpGet(scriptUrl, true))()
        else
            Hawk:AddNotifications():Notification("Error", "Wrong game!", "Error", 3)
            game.Players.LocalPlayer:Kick("Wrong game! Please join the correct game to use this script.")
        end
        Window:Destroy()
    end)
end

CreateRecomend("PETS GO! ✨ [NEW]", 18901165922, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/PetsGo.txt")
CreateRecomend("[🎃] Fisch", 16732694052, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/Fisch.txt")
CreateRecomend("🔥 Blox Fruits", 2753915549, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/BloxFruit.txt")

local gamesSection = tab1:Section("Supported Games (if it doesn't load, try running it again)")

local function createGameButton(placeName, placeId, scriptUrl)
    gamesSection:Button(placeName, "Load script for " .. placeName, function()
        if game.PlaceId == placeId then
            loadstring(game:HttpGet(scriptUrl, true))()
        else
            Hawk:AddNotifications():Notification("Error", "Wrong game!", "Error", 3)
            game.Players.LocalPlayer:Kick("Wrong game! Please join the correct game to use this script.")
        end
        Window:Destroy()
    end)
end

-- Create buttons for each game
createGameButton("Supermarket Simulator", 96462622512177, "https://raw.githubusercontent.com/jkancc111/Games/main/SupermarketSimulator.txt")

createGameButton("Mewing Simulator", 15905908514, "https://raw.githubusercontent.com/jkancc111/Games/main/MewingSimulator.txt")

createGameButton("🗝️Lootify[🎄UPD]", 16498193900, "https://raw.githubusercontent.com/jkancc111/Games/main/Lootify.txt")

createGameButton("[🎄XMAS] Anime Slashing Simulator", 18956736354, "https://raw.githubusercontent.com/jkancc111/Games/main/AnimeSlashSim.lua")

createGameButton("Maze Simulator", 109644231059364, "https://raw.githubusercontent.com/jkancc111/Games/main/MazeSimulator.lua")

createGameButton("YouTube Race Simulator", 134853721259762, "https://raw.githubusercontent.com/jkancc111/Games/main/YoutubeRaceSim.lua")

createGameButton("[🎄PART 2!] Christmas Clicker", 125829047001810, "https://raw.githubusercontent.com/jkancc111/Games/main/ChristmastClicker.txt")

createGameButton("Horse Race [New Equip🚀]", 93787311916283, "https://raw.githubusercontent.com/jkancc111/Games/main/HorseRace.txt")

createGameButton("Grass Cutting Simulator 🍃", 15277359883, "https://raw.githubusercontent.com/jkancc111/Games/main/CuttingGrassSim.txt")

createGameButton("[UPD] Pixel Prisons ⛏️", 134877494536867, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/PixelPrison.txt")
createGameButton("[RELEASE] Anime Shadow", 89438510123061, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/AnimeShadow.txt")
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
createGameButton("Track Race", 18254034839, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/TrackRace.txt")
createGameButton("[RELEASE] RNG Odyssey", 16055525893, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/RNGOdsseys.txt")
createGameButton("🖐️Slap Away Simulator", 106205749987586, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/SlapAwaySim.txt")
createGameButton("Every Click +1 Jump 🚀", 18768675350, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/EveryClick%2B1Jump.txt")
createGameButton("Monster Slayer[UD1]", 16125758204, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/MonsterSlayer.txt")
createGameButton("Sword Clashers Simulator ⚔️", 17800899459, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/SwordClashSim.txt")

createGameButton("Swim League", 0, "https://raw.githubusercontent.com/jkancc111/Games/refs/heads/main/SwimLeague.txt")
