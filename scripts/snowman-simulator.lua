--!strict

local HttpService = game:GetService("HttpService")

local function fireproximityprompt(ProximityPrompt: ProximityPrompt?)
    if ProximityPrompt then
        local oldHoldDuration = ProximityPrompt.HoldDuration
        ProximityPrompt.HoldDuration = 0
        ProximityPrompt:InputHoldBegin()
        ProximityPrompt:InputHoldEnd()
        ProximityPrompt.HoldDuration = oldHoldDuration
        return true
    end
    return false
end

local success: boolean, result: string = pcall(function()
    local response: string? = game:HttpGet("https://raw.githubusercontent.com/ExtremeAntonis/Venyx-UI-Library/main/source2.lua")
    if response then
        local loadstring: any = loadstring(response)
        if loadstring then
            return loadstring()
        end
    end
end)

if not success then
    error("Failed to get UI library: " .. result)
end

local config = {
    ["auto_collect_snow"] = false,
    ["auto_add_snow_to_snowman"] = false,
    ["auto_rebirth"] = false,
    ["claim_gift_before_rebirth"] = false,
    ["hide_popups"] = false,
    ["infinite_double_jumps"] = false,
    ["selected_boss"] = false,
    ["auto_fire"] = false,
    ["fire_rate"] = 25,
    ["fire_only_in_zone"] = false,
    ["target_all_bosses"] = false,
    ["target_priority"] = "Closest",
    ["killing_mode"] = "Normal",
    ["enemy_auto_fire"] = false,
    ["enemy_fire_rate"] = 25,
    ["enemy_target_priority"] = "Closest",
    ["enemy_killing_mode"] = "Normal",
    ["selected_teleport_boss"] = false,
    ["selected_present"] = false,
    ["auto_open_present"] = false,
}

local function SaveConfig(): ()
    if not isfolder("extremehub") then makefolder("extremehub") end

    if isfolder("extremehub") then
        local encodedConfig: string = HttpService:JSONEncode(config)
        writefile("extremehub/snowman-simulator.txt", encodedConfig)
    end
end

local function LoadConfig(): ()
    local path: string = "extremehub/snowman-simulator.txt"
    if isfolder("extremehub") then
        if isfile(path) then
            local encodedConfig: string = readfile(path)
            if encodedConfig then
                local decodedConfig = HttpService:JSONDecode(encodedConfig)
                for name, value in pairs(decodedConfig) do
                    if config[name] ~= nil then
                        config[name] = value
                    end
                end
            end
        end
    end
end

LoadConfig()

local function SetConfig(name: string, value: any): ()
    if name == nil or value == nil then error("Invalid parameters passed to SetConfig.") end
    if config[name] == nil then error("The specified toggle name does not exist in the configuration.") end
    config[name] = value
    SaveConfig()
end

local function GetConfig(name: string): any
    if name == nil then error("Invalid parameter passed to GetConfig.") end
    if config[name] == nil then error("The specified toggle name does not exist in the configuration.") end
    return config[name]
end

local function TeleportPlayer(player: Player, cframe: CFrame): ()
    if typeof(player) ~= "Instance" or not player:IsA("Player") or typeof(cframe) ~= "CFrame" then return end
    local character = player.Character
    if character and character:IsA("Model") then
        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart.CFrame = cframe
        end
    end
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui: Folder = LocalPlayer.PlayerGui
local CoreGui = game:GetService("CoreGui")

for _, ScreenGui: Instance in CoreGui:GetChildren() do
    if ScreenGui.Name == "extremehub" and ScreenGui:IsA("ScreenGui") then
        ScreenGui:Destroy()
    end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GiftSpawns = game:GetService("Workspace").giftSpawns
local _, SnowballProjectileClient = pcall(require, game:GetService("ReplicatedStorage").ModulesClient.SnowballProjectileClient)
-- local RollSnowballClient = getsenv(ReplicatedStorage.ModulesClient.RollSnowballClient)
-- local GameSnowFolder = workspace.gameSnow

local Venyx: any = result
local UI = Venyx.new({
    title = "extremehub"
})

local page1 = UI:addPage({
    title = "Main",
    icon = 14906312807
})

local section1 = page1:addSection({
    title = "Farming"
})

local section2 = page1:addSection({
    title = "Current Session Stats"
})

local getMaxSnowballSize

local successRollSnowballShared, errorRollSnowballShared = pcall(function()
    local RollSnowballShared = require(game:GetService("ReplicatedStorage").ModulesShared.RollSnowballShared)
    if RollSnowballShared and RollSnowballShared.getMaxSizeFromLevel then
        getMaxSnowballSize = RollSnowballShared.getMaxSizeFromLevel
    end
end)

if not successRollSnowballShared then
    warn("RollSnowballShared:", errorRollSnowballShared)
end

-- FOR EXECUTORS THAT DONT SUPPORT REQUIRING SCRIPTS LIKE FUCKINGGG SOLARA!!!!!!!!!!

if not getMaxSnowballSize then
    getMaxSnowballSize = function(player: Player)
        local localData = player:FindFirstChild("localData") :: Folder?
        if localData then
            local collecting = localData:FindFirstChild("collecting") :: IntValue?
            if collecting then
                return math.min(22, 6 + (collecting.Value * 0.032))
            end
        end
        return 6
    end
end

section1:addToggle({
    title = "Auto Collect Snow",
    toggled = GetConfig("auto_collect_snow"),
    callback = function(value: boolean)
        SetConfig("auto_collect_snow", value)
        while GetConfig("auto_collect_snow") do task.wait()
            pcall(function()
                local sackStorage = LocalPlayer.localData.sackStorage.Value
                local snowballs = LocalPlayer.localData.snowballs.Value
                if snowballs < sackStorage then
                    game:GetService("ReplicatedStorage").Signals.collectSnow:FireServer()
                    if LocalPlayer.info.snowmanBallSize.Value >= getMaxSnowballSize(LocalPlayer) then
                        game:GetService("ReplicatedStorage").Signals.snowballControllerFunc:InvokeServer("stopRoll")
                    end
                end
            end)
        end
    end
})

local function GetSnowmanBase()
    local snowbases = game:GetService("Workspace").snowmanBases
    for _, snowbase in ipairs(snowbases:GetChildren()) do
        if snowbase.player.Value == LocalPlayer then
            return snowbase
        end
    end
    return nil
end

--When you Respawn while you are adding snow to the snowman sometimes the game glitches and the value addingToSnowman is stuck as true so to fix this i just check if it has been over 15 seconds since snow has been added to the snowman
local lastTimeAddedToSnowman = os.time()
local TIMEOUT = 15

section1:addToggle({
    title = "Auto Add Snow To Snowman",
    toggled = GetConfig("auto_add_snow_to_snowman"),
    callback = function(value: boolean)
        SetConfig("auto_add_snow_to_snowman", value)
        while GetConfig("auto_add_snow_to_snowman") do task.wait(.5)
            local success, error = pcall(function()
                local snowmanBase = GetSnowmanBase()
                local snowballs = LocalPlayer.localData.snowballs.Value
                if (snowmanBase and not snowmanBase.rebirthActive.Value and snowballs > 0 and not snowmanBase.addingToSnowman.Value) or lastTimeAddedToSnowman + TIMEOUT < os.time() then
                    lastTimeAddedToSnowman = os.time()
                    game:GetService("ReplicatedStorage").Signals.addToSnowman:FireServer("addToSnowman")
                end
            end)
            if not success then
                error("Auto Add Snow To Snowman:", error)
            end
        end
    end
})

local function GetSnowmanGift()
    for _, gift in ipairs(GiftSpawns:GetChildren()) do
        if gift and gift.Name == "snowmanGift" then
            local ownerName = gift:FindFirstChild("ownerName") :: StringValue?
            if ownerName then
                if ownerName.Value == LocalPlayer.Name then
                    return gift
                end
            end
        end
    end
    return nil
end

local giftPromptFired = false

local function ClaimSnowmanGift()
    local snowmanGift = GetSnowmanGift()
    if snowmanGift then
        local hitbox = snowmanGift:FindFirstChild("hitbox") :: BasePart?
        local explodePart = snowmanGift:FindFirstChild("explodePart") :: BasePart?
        if hitbox then
            local unwrapProgressBar = hitbox:FindFirstChild("unwrapProgressBar") :: BillboardGui?
            local proxGui = hitbox:FindFirstChild("proxGui") :: Attachment?
            if proxGui and not unwrapProgressBar and not explodePart then
                local ProximityPrompt = proxGui:FindFirstChild("ProximityPrompt") :: ProximityPrompt?
                local cframe: CFrame = hitbox.CFrame * CFrame.new(0, hitbox.Size.Y / 2, 0)
                TeleportPlayer(LocalPlayer, cframe)
                if ProximityPrompt then
                    local success = fireproximityprompt(ProximityPrompt)
                    giftPromptFired = success
                end
            end
        end
    end
    if giftPromptFired and not snowmanGift then
        giftPromptFired = false
        return true
    end
    return false
end

section1:addToggle({
    title = "Auto Rebirth",
    toggled = GetConfig("auto_rebirth"),
    callback = function(value: boolean)
        SetConfig("auto_rebirth", value)
        while GetConfig("auto_rebirth") do task.wait(.25)
            local snowmanBase = GetSnowmanBase()
            if snowmanBase.rebirthActive.Value then
                if GetConfig("claim_gift_before_rebirth") and not ClaimSnowmanGift() then continue end
                game:GetService("ReplicatedStorage").Signals.snowmanEvent:FireServer("acceptRebirth", snowmanBase, true)
            end
        end
    end
})

section1:addToggle({
    title = "Claim Gift Before Rebirth",
    toggled = GetConfig("claim_gift_before_rebirth"),
    callback = function(value: boolean)
        SetConfig("claim_gift_before_rebirth", value)
    end
})

local successGuiEffects, errorGuiEffects = pcall(function()
    local GuiEffects = require(ReplicatedStorage.ModulesClient.Gui.GuiEffects)
    local oldItemObtain = GuiEffects.itemObtain
    GuiEffects.itemObtain = function(...)
        if not GetConfig("hide_popups") then
            return oldItemObtain(...)
        end
    end
end)

if not successGuiEffects then
    print("GuiEffects: ", errorGuiEffects)
end

section1:addToggle({
    title = "Hide PopUps",
    toggled = GetConfig("hide_popups"),
    callback = function(value: boolean): ()
        SetConfig("hide_popups", value)
    end
})

local function calculateHourlyRate(getValueFunction: () -> number, updateText: (hourlyRate: number) -> ())
    -- Create the session table to store the state
    local self = {}
    
    -- Initialize session variables
    self.initialValue = getValueFunction()  -- Start value
    self.startTime = os.time()  -- Start time

    -- Define the Reset method for the session
    function self:Reset()
        self.initialValue = getValueFunction()  -- Reset the value
        self.startTime = os.time()  -- Reset the start time
    end

    -- Calculate hourly rate continuously
    spawn(function()
        while true do
            task.wait(1)

            local currentValue = getValueFunction()
            local currentTime = os.time()
            local elapsedTime = currentTime - self.startTime

            if elapsedTime > 0 then
                local difference = currentValue - self.initialValue
                local hourlyRate = (difference / elapsedTime) * 3600
                hourlyRate = math.round(hourlyRate * 10) / 10  -- Round to 1 decimal
                updateText(hourlyRate)
            end
        end
    end)

    return self  -- Return the session with the Reset method
end

local rebirths_per_hour
rebirths_per_hour = section2:addButton({
    title = "",
    callback = function(): () end
})

local reset_rebirth_session

reset_rebirth_session = calculateHourlyRate(
    function()
        return LocalPlayer.leaderstats.Rebirths.Value
    end, 
    function(hourlyRate: number)
        pcall(function()
            rebirths_per_hour.Options:Update({title = `Rebirths/Hour: {hourlyRate}`})
        end)
    end
)

section2:addButton({
    title = "Reset Session",
    callback = function()
        if reset_rebirth_session then
            reset_rebirth_session:Reset()
        end
    end
})

local page2 = UI:addPage({
    title = "Bosses",
    icon = 15197783428
})

local section1 = page2:addSection({
    title = SnowballProjectileClient and `Farming` or `Farming Disabled (Failed to Require SnowballProjectileClient)`
})

local section2 = page2:addSection({
    title = "Teleport"
})

local section3 = page2:addSection({
    title = "Current Session Stats"
})

local Bosses = {}
local BossTeleportSpots = {}

local steps = game:GetService("Workspace").steps

for _, instance in steps:GetChildren() do
    if instance.Name == "bossLedge" then
        local portal = instance:FindFirstChild("portal") :: Model?
        local bossName = instance:FindFirstChild("bossName") :: StringValue?
        local zoneLevel = instance:FindFirstChild("zoneLevel") :: IntValue?
        if portal and bossName and zoneLevel then
            local teleportSpot = portal:FindFirstChild("teleportSpot") :: BasePart?
            if teleportSpot then
                Bosses[zoneLevel.Value] = bossName.Value
                BossTeleportSpots[bossName.Value] = teleportSpot.CFrame
            end
        end
    end
end

local function ThrowSnowball(from: CFrame, to: CFrame): ()
    if from ~= to then
        from = from * CFrame.new(0, 5, 0)
    end
    local RelativePosition: Vector3 = (to.Position - from.Position) * 10
    SnowballProjectileClient.playerSnowball(LocalPlayer, RelativePosition, 125, from)
end

local function GetLocalPlayerCFrame(): CFrame?
    if LocalPlayer then
        local Character = LocalPlayer.Character
        if Character then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") :: BasePart?
            if HumanoidRootPart then
                return HumanoidRootPart.CFrame
            end
        end
    end
    return nil
end

local function IsPlayerInBossZone(name: string?): boolean
    if name then
        for _, instance in pairs(steps:GetChildren()) do
            if instance.Name == "bossLedge" then
                local bossName = instance:FindFirstChild("bossName") :: StringValue?
                local arena = instance:FindFirstChild("arena") :: Model?
                if bossName and bossName.Value == name and arena then
                    local largeForceField = arena:FindFirstChild("largeForceField")
                    if not largeForceField then
                        return true
                    end
                end
            end
        end
    end
    return not GetConfig("fire_only_in_zone")
end

export type BossInfo = {
    currentHealth: number,
    currentCFrame: CFrame,
    level: number,
    spawnPosition: Vector3,
    bossName: string,
    maxHealth: number,
    state: string, 
}

export type BossesInfo = {
    [string]: BossInfo,
}

local function GetBossInfo(): BossesInfo    
    local Info = {}
    for _, instance in pairs(steps:GetChildren()) do
        if instance.Name == "bossLedge" then
            local BossFolder: Folder? = instance:FindFirstChild("Boss")
            if BossFolder then
                local Boss = BossFolder:FindFirstChild("Boss") :: Model?
                if Boss then
                    local Humanoid = Boss:FindFirstChild("Humanoid") :: Humanoid?
                    local HumanoidRootPart = Boss:FindFirstChild("HumanoidRootPart") :: BasePart?
                    local Configuration = Boss:FindFirstChild("Configuration") :: Folder?
                    if Humanoid and HumanoidRootPart and Configuration then
                        local currentHealth = Humanoid.Health :: number?
                        local currentCFrame = HumanoidRootPart.CFrame
                        local level = Configuration:FindFirstChild("level") :: IntValue?
                        local spawnPosition = Configuration:FindFirstChild("spawnPosition") :: Vector3Value?
                        local bossName = Configuration:FindFirstChild("bossName") :: StringValue?
                        local maxHealth = Configuration:FindFirstChild("maxHealth") :: NumberValue?
                        local state = Configuration:FindFirstChild("state") :: StringValue?
                        if currentHealth and currentCFrame and level and spawnPosition and bossName and maxHealth and state then
                            Info[bossName.Value] = {
                                ["currentHealth"] = currentHealth,
                                ["currentCFrame"] = currentCFrame,
                                ["level"] = level.Value,
                                ["spawnPosition"] = spawnPosition.Value,
                                ["bossName"] = bossName.Value,
                                ["maxHealth"] = maxHealth.Value,
                                ["state"] = state.Value,
                            }
                        end
                    end
                end
            end
        end
    end
    return Info
end



local function GetBoss(): BossInfo?
    local TargetPriority = GetConfig("target_priority")
    local TargetAllBosses = GetConfig("target_all_bosses")
    local BossInfo: BossesInfo = GetBossInfo()
    if TargetAllBosses then
        local BossName = nil
        if TargetPriority == "Lowest Health" then
            local lowestHealth = math.huge
            for name, boss in pairs(BossInfo) do
                if boss.currentHealth < lowestHealth and boss.currentHealth > 0 then
                    lowestHealth = boss.currentHealth
                    BossName = name
                end
            end
        elseif TargetPriority == "Highest Health" then
            local highestHealth = -math.huge
            for name, boss in pairs(BossInfo) do
                if boss.currentHealth > highestHealth and boss.currentHealth > 0 then
                    highestHealth = boss.currentHealth
                    BossName = name
                end
            end
        elseif TargetPriority == "Furthest" then
            local furthestDistance = -math.huge
            for name, boss in pairs(BossInfo) do
                if boss.currentHealth > 0 then
                    local PlayerCFrame = GetLocalPlayerCFrame()
                    if PlayerCFrame then
                        local distance = (PlayerCFrame.Position - boss.currentCFrame.Position).Magnitude
                        if distance > furthestDistance then
                            furthestDistance = distance
                            BossName = name
                        end
                    end
                end
            end
        elseif TargetPriority == "Closest" then
            local nearestDistance = math.huge
            for name, boss in pairs(BossInfo) do
                if boss.currentHealth > 0 then
                    local PlayerCFrame = GetLocalPlayerCFrame()
                    if PlayerCFrame then
                        local distance = (PlayerCFrame.Position - boss.currentCFrame.Position).Magnitude
                        if distance < nearestDistance then
                            nearestDistance = distance
                            BossName = name
                        end
                    end
                end
            end
        elseif TargetPriority == "Lowest MaxHealth" then
            local lowestMaxHealth = math.huge
            for name, boss in pairs(BossInfo) do
                if boss.maxHealth < lowestMaxHealth and boss.currentHealth > 0 then
                    lowestMaxHealth = boss.maxHealth
                    BossName = name
                end
            end
        elseif TargetPriority == "Highest MaxHealth" then
            local highestMaxHealth = -math.huge
            for name, boss in pairs(BossInfo) do
                if boss.maxHealth > highestMaxHealth and boss.currentHealth > 0 then
                    highestMaxHealth = boss.maxHealth
                    BossName = name
                end
            end
        elseif TargetPriority == "Lowest Level" then
            local lowestLevel = math.huge
            for name, boss in pairs(BossInfo) do
                if boss.level < lowestLevel and boss.currentHealth > 0 then
                    lowestLevel = boss.level
                    BossName = name
                end
            end
        elseif TargetPriority == "Highest Level" then
            local highestLevel = -math.huge
            for name, boss in pairs(BossInfo) do
                if boss.level > highestLevel and boss.currentHealth > 0 then
                    highestLevel = boss.level
                    BossName = name
                end
            end
        end
        return BossInfo[BossName]
    end
    return BossInfo[GetConfig("selected_boss")]
end

section1:addDropdown({
    title = "Select Boss",
    default = GetConfig("selected_boss"),
    list = Bosses,
    callback = function(value: string)
        SetConfig("selected_boss", value)
    end
})

section1:addToggle({
    title = "Auto Fire",
    toggled = GetConfig("auto_fire"),
    callback = function(value: boolean) : ()
        SetConfig("auto_fire", value)
        while GetConfig("auto_fire") do task.wait(1/GetConfig("fire_rate"))
            local Boss: BossInfo? = GetBoss()
            local LocalPlayerCFrame: CFrame? = GetLocalPlayerCFrame()
            if Boss and Boss.currentCFrame and LocalPlayerCFrame and IsPlayerInBossZone(Boss.bossName) then
                if GetConfig("killing_mode") == "Normal" then
                    ThrowSnowball(LocalPlayerCFrame, Boss.currentCFrame)
                elseif GetConfig("killing_mode") == "Unstoppable" then
                    ThrowSnowball(Boss.currentCFrame, Boss.currentCFrame)
                end
            end
        end
    end
})

section1:addToggle({
    title = "Fire Only In Zone",
    toggled = GetConfig("fire_only_in_zone"),
    callback = function(value: boolean): ()
        SetConfig("fire_only_in_zone", value)
    end
})

section1:addToggle({
    title = "Target All Bosses",
    toggled = GetConfig("target_all_bosses"),
    callback = function(value: boolean): ()
        SetConfig("target_all_bosses", value)
    end
})

section1:addDropdown({
    title = "Target Priority",
    default = GetConfig("target_priority"),
    list = {"Lowest Health", "Highest Health", "Closest", "Furthest", "Lowest MaxHealth", "Highest MaxHealth", "Highest Level", "Lowest Level"},
    callback = function(value: string)
        SetConfig("target_priority", value)
    end
})

section1:addDropdown({
    title = "Killing Mode",
    default = GetConfig("killing_mode"),
    list = {"Normal", "Unstoppable"},
    callback = function(value: string): ()
        SetConfig("killing_mode", value)
    end
})

local fire_rate_slider
fire_rate_slider = section1:addSlider({
    title = `Fire Rate {GetConfig("fire_rate")}.0 (Shots Per Second)`,
    default = GetConfig("fire_rate"),
    min = 1,
    max = 100,
    callback = function(value: boolean): ()
        SetConfig("fire_rate", value)
        fire_rate_slider.Options:Update({title= `Fire Rate: {value}.0 (Shots Per Second)`})
    end
})

section2:addDropdown({
    title = "Select Boss",
    default = GetConfig("selected_teleport_boss"),
    list = Bosses,
    callback = function(value: string): ()
        SetConfig("selected_teleport_boss", value)
    end
})

section2:addButton({
    title = "Teleport",
    callback = function()
        local selected_teleport_boss = GetConfig("selected_teleport_boss")
        if selected_teleport_boss then
            local CFrame = BossTeleportSpots[selected_teleport_boss]
            if CFrame then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame
            end
        end
    end
})

local BossKillsSessions = {}

local BossKills = LocalPlayer.localData.bossKills
for _, kills in pairs(BossKills:GetChildren()) do
    local button = section3:addButton({title = "", callback = function(): () end})
    local session = calculateHourlyRate(function() return kills.Value end, 
        function(hourlyRate: number)
            pcall(function()
                button.Options:Update({title = `{kills.Name} Kills/Hour: {hourlyRate}`})
            end)
        end
    )
    table.insert(BossKillsSessions, session)
end

section3:addButton({
    title = "Reset Session",
    callback = function()
        for _, session in pairs(BossKillsSessions) do
            session:Reset()
        end
    end
})

local page3 = UI:addPage({
    title = "Enemies",
    icon = 15197783428
})

local section1 = page3:addSection({
    title = SnowballProjectileClient and `Farming` or `Farming Disabled (Failed to Require SnowballProjectileClient)`
})

export type EnemyInfo = {
    currentHealth: number,
    maxHealth: number,
    currentCFrame: CFrame,
    spawnPosition: CFrame,
}

export type EnemiesInfo = {
    [number]: EnemyInfo,
}

local minionHolderFolders = {}

for _, instance in pairs(workspace:GetDescendants()) do
    if instance:IsA("Folder") and instance.Name == "minionHolder" then
        table.insert(minionHolderFolders, instance)
    end
end

local function GetEnemyInfo(): EnemiesInfo    
    local Info = {}
    for _, minionHolder: Folder in pairs(minionHolderFolders) do
        for _, minion in minionHolder:GetChildren() do
            local hitBox = minion:FindFirstChild("hitBox") :: BasePart?
            local currentHealth = minion:FindFirstChild("hitCount") :: IntValue?
            local maxHealth = minion:FindFirstChild("hitLife") :: IntValue?
            local currentCFrame = (hitBox and hitBox.CFrame or nil) :: CFrame?
            local spawnPosition = minion:FindFirstChild("origCFrame") :: CFrameValue?
            if hitBox and currentHealth and maxHealth and currentCFrame and spawnPosition then
                Info[#Info+1] = {
                    ["currentHealth"] = currentHealth.Value,
                    ["maxHealth"] = maxHealth.Value,
                    ["currentCFrame"] = currentCFrame,
                    ["spawnPosition"] = spawnPosition.Value,
                }
            end
        end 
    end
    return Info
end

local function GetEnemy(): EnemyInfo?
    local TargetPriority = GetConfig("enemy_target_priority")
    local EnemyInfo: EnemiesInfo = GetEnemyInfo()
    local Enemy = nil
    if TargetPriority == "Lowest Health" then
        local lowestHealth = math.huge
        for name, boss in pairs(EnemyInfo) do
            if boss.currentHealth < lowestHealth and boss.currentHealth > 0 then
                lowestHealth = boss.currentHealth
                Enemy = name
            end
        end
    elseif TargetPriority == "Highest Health" then
        local highestHealth = -math.huge
        for name, boss in pairs(EnemyInfo) do
            if boss.currentHealth > highestHealth and boss.currentHealth > 0 then
                highestHealth = boss.currentHealth
                Enemy = name
            end
        end
    elseif TargetPriority == "Furthest" then
        local furthestDistance = -math.huge
        for name, boss in pairs(EnemyInfo) do
            if boss.currentHealth > 0 then
                local PlayerCFrame = GetLocalPlayerCFrame()
                if PlayerCFrame then
                    local distance = (PlayerCFrame.Position - boss.currentCFrame.Position).Magnitude
                    if distance > furthestDistance then
                        furthestDistance = distance
                        Enemy = name
                    end
                end
            end
        end
    elseif TargetPriority == "Closest" then
        local nearestDistance = math.huge
        for name, boss in pairs(EnemyInfo) do
            if boss.currentHealth > 0 then
                local PlayerCFrame = GetLocalPlayerCFrame()
                if PlayerCFrame then
                    local distance = (PlayerCFrame.Position - boss.currentCFrame.Position).Magnitude
                    if distance < nearestDistance then
                        nearestDistance = distance
                        Enemy = name
                    end
                end
            end
        end
    elseif TargetPriority == "Lowest MaxHealth" then
        local lowestMaxHealth = math.huge
        for name, boss in pairs(EnemyInfo) do
            if boss.maxHealth < lowestMaxHealth and boss.currentHealth > 0 then
                lowestMaxHealth = boss.maxHealth
                Enemy = name
            end
        end
    elseif TargetPriority == "Highest MaxHealth" then
        local highestMaxHealth = -math.huge
        for name, boss in pairs(EnemyInfo) do
            if boss.maxHealth > highestMaxHealth and boss.currentHealth > 0 then
                highestMaxHealth = boss.maxHealth
                Enemy = name
            end
        end
    end
    return EnemyInfo[Enemy]
end

section1:addToggle({
    title = "Auto Fire",
    toggled = GetConfig("enemy_auto_fire"),
    callback = function(value: boolean) : ()
        SetConfig("enemy_auto_fire", value)
        while GetConfig("enemy_auto_fire") do task.wait(1/GetConfig("enemy_fire_rate"))
            local Enemy: EnemyInfo? = GetEnemy()
            local LocalPlayerCFrame: CFrame? = GetLocalPlayerCFrame()
            if Enemy and Enemy.currentCFrame and LocalPlayerCFrame then
                if GetConfig("enemy_killing_mode") == "Normal" then
                    ThrowSnowball(LocalPlayerCFrame, Enemy.currentCFrame)
                elseif GetConfig("enemy_killing_mode") == "Unstoppable" then
                    ThrowSnowball(Enemy.currentCFrame, Enemy.currentCFrame)
                end
            end
        end
    end
})


section1:addDropdown({
    title = "Target Priority",
    default = GetConfig("enemy_target_priority"),
    list = {"Lowest Health", "Highest Health", "Closest", "Furthest", "Lowest MaxHealth", "Highest MaxHealth"},
    callback = function(value: string)
        SetConfig("enemy_target_priority", value)
    end
})

section1:addDropdown({
    title = "Killing Mode",
    default = GetConfig("enemy_killing_mode"),
    list = {"Normal", "Unstoppable"},
    callback = function(value: string): ()
        SetConfig("enemy_killing_mode", value)
    end
})

local enemy_fire_rate_slider
enemy_fire_rate_slider = section1:addSlider({
    title = `Fire Rate {GetConfig("enemy_fire_rate")}.0 (Shots Per Second)`,
    default = GetConfig("enemy_fire_rate"),
    min = 1,
    max = 100,
    callback = function(value: boolean): ()
        SetConfig("enemy_fire_rate", value)
        enemy_fire_rate_slider.Options:Update({title= `Fire Rate: {value}.0 (Shots Per Second)`})
    end
})


local page4 = UI:addPage({
    title = "Presents",
    icon = 13848210004
})

local section1 = page4:addSection({
    title = "Presents"
})

local PresentPedestals = game:GetService("Workspace").PresentPedestals
local PresentNames = {}
local PresentTiers = {}

for _, instance in pairs(PresentPedestals:GetChildren()) do
    local sign = instance:FindFirstChild("sign") :: BasePart?
    if sign then
        local SurfaceGui = sign:FindFirstChild("SurfaceGui") :: SurfaceGui?
        if SurfaceGui then
            local TextLabel = SurfaceGui:FindFirstChild("TextLabel") :: TextLabel?
            if TextLabel then
                local name = TextLabel.Text
                local tier = tonumber(instance.Name)
                if name and tier then
                    PresentNames[tier] = name
                    PresentTiers[name] = tier
                end
            end
        end
    end
end

section1:addDropdown({
    title = "Select Present",
    default = GetConfig("selected_present"),
    list = PresentNames,
    callback = function(value: string): ()
        SetConfig("selected_present", value)
    end
})

section1:addToggle({
    title = "Auto Open",
    toggled = GetConfig("auto_open_present"),
    callback = function(value: boolean): ()
        SetConfig("auto_open_present", value)
        while GetConfig("auto_open_present") do task.wait(.25)
            local tier = PresentTiers[GetConfig("selected_present")]
            if tier then
                ReplicatedStorage.Signals.presentEvent:FireServer("openPresent", tier)
            end
        end
    end
})

local page5 = UI:addPage({
    title = "Misc",
    icon = 15196113798
})

local section1 = page5:addSection({
    title = "Misc"
})

local infinite_double_jumps_connection: RBXScriptConnection?

section1:addToggle({
    title = "Infinite Double Jumps",
    toggled = GetConfig("infinite_double_jumps"),
    callback = function(value: boolean): ()
        SetConfig("infinite_double_jumps", value)
        while GetConfig("infinite_double_jumps") do task.wait(1)
            if not infinite_double_jumps_connection or not infinite_double_jumps_connection.Connected then
                local character = LocalPlayer.character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid?
                    if humanoid then
                        infinite_double_jumps_connection = humanoid.StateChanged:Connect(function(oldState, newState)
                            if newState == Enum.HumanoidStateType.Jumping then
                                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                            end
                        end)
                    end
                end
            end
        end
        if not GetConfig("infinite_double_jumps") then
            if infinite_double_jumps_connection then
                infinite_double_jumps_connection:Disconnect()
            end
        end
    end
})

local page6 = UI:addPage({
    title = "Info",
    icon = 15084116748
})

local section1 = page6:addSection({
    title = "Join My Discord Server"
})

local section2 = page6:addSection({
    title = "Last Updated"
})

local section3 = page6:addSection({
    title = "Contributors"
})

local section4 = page6:addSection({
    title = "Open Source Script"
})

local section5 = page6:addSection({
    title = ""
})


section1:addButton({
    title = "discord.gg/6ZDtkxqJS4",
    callback = function(): ()
        setclipboard("discord.gg/6ZDtkxqJS4")
    end
})

section2:addButton({
    title = "December 13, 2024",
    callback = function(): ()
        setclipboard("December 13, 2024")
    end
})

section3:addButton({
    title = "_extreme",
    callback = function(): ()
        setclipboard("_extreme")
    end
})

section4:addButton({
    title = "Feel free to use or modify. Just credit me for copied parts.",
    callback = function(): ()
        setclipboard("Feel free to use or modify. Just credit me for copied parts.")
    end
})


local mainUI = CoreGui:FindFirstChild("extremehub") :: ScreenGui?

section5:addButton({
    title = "Destroy",
    callback = function(): ()
        if mainUI then
            mainUI:Destroy()
        end
    end
})

section5:addButton({
    title = "Reset Settings (Effective Next Script Run)",
    callback = function(): ()
        local path = "extremehub/snowman-simulator.txt"
        if isfolder("extremehub") then
            if isfile(path) then
                delfile(path)
            end
        end
    end
})

if mainUI then
    mainUI.Destroying:Connect(function()
        for name, value in config do
            if typeof(value) == "boolean" then
                config[name] = false
            end
        end
    end)
end


local extremehub = [[
 /$$$$$$$$             /$$                                                       /$$   /$$ /$$   /$$ /$$$$$$$ 
| $$_____/            | $$                                                      | $$  | $$| $$  | $$| $$__  $$
| $$       /$$   /$$ /$$$$$$    /$$$$$$   /$$$$$$  /$$$$$$/$$$$   /$$$$$$       | $$  | $$| $$  | $$| $$  \ $$
| $$$$$   |  $$ /$$/|_  $$_/   /$$__  $$ /$$__  $$| $$_  $$_  $$ /$$__  $$      | $$$$$$$$| $$  | $$| $$$$$$$ 
| $$__/    \  $$$$/   | $$    | $$  \__/| $$$$$$$$| $$ \ $$ \ $$| $$$$$$$$      | $$__  $$| $$  | $$| $$__  $$
| $$        >$$  $$   | $$ /$$| $$      | $$_____/| $$ | $$ | $$| $$_____/      | $$  | $$| $$  | $$| $$  \ $$
| $$$$$$$$ /$$/\  $$  |  $$$$/| $$      |  $$$$$$$| $$ | $$ | $$|  $$$$$$$      | $$  | $$|  $$$$$$/| $$$$$$$/
|________/|__/  \__/   \___/  |__/       \_______/|__/ |__/ |__/ \_______/      |__/  |__/ \______/ |_______/ 
]]

print("\n", extremehub)

UI:SelectPage({
    page = UI.pages[6], 
    toggle = true
})
