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
    if game.PlaceId == 18481040458 then -- Factory RNG
        loadstring(game:HttpGet("https://raw.githubusercontent.com/jkancc111/Games/main/FactoryRNG.lua",true))()
    elseif game.PlaceId == 17534163435 then -- Dungeon RNG
        loadstring(game:HttpGet("https://raw.githubusercontent.com/jkancc111/Games/main/DungeonRNG.lua",true))()
    end
else
    print("Player closed the GUI.")
end