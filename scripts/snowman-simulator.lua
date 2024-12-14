--!strict

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
    local response: string? = game:HttpGet("https://raw.githubusercontent.com/ExtremeAntonis/Venyx-UI-Library/main/source2")
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
    ["selected_boss"] = "",
    ["auto_fire"] = false,
    ["fire_rate"] = 25,
    ["fire_only_in_zone"] = false,
    ["target_all_bosses"] = false,
    ["target_priority"] = "Closest",
    ["killing_mode"] = "Normal",
}

local function SetConfig(name: string, value: any): ()
    if not name then error("Invalid parameters passed to SetConfig.") end
    if config[name] == nil then error("The specified toggle name does not exist in the configuration.") end
    config[name] = value
end

local function GetConfig(name: string): any
    if not name then error("Invalid parameter passed to GetConfig.") end
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
    toggled = false,
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

section1:addToggle({
    title = "Auto Add Snow To Snowman",
    toggled = false,
    callback = function(value: boolean)
        SetConfig("auto_add_snow_to_snowman", value)
        while GetConfig("auto_add_snow_to_snowman") do task.wait(.5)
            pcall(function()
                local snowmanBase = GetSnowmanBase()
                local snowballs = LocalPlayer.localData.snowballs.Value
                if snowmanBase and not snowmanBase.rebirthActive.Value and snowballs > 0 and not snowmanBase.addingToSnowman.Value then
                    game:GetService("ReplicatedStorage").Signals.addToSnowman:FireServer("addToSnowman")
                end
            end)
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
    toggled = false,
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
    toggled = false,
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
    toggled = false,
    callback = function(value: boolean): ()
        SetConfig("hide_popups", value)
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
    local RelativePosition: Vector3 = (to.Position - from.Position) * 10
    SnowballProjectileClient.playerSnowball(LocalPlayer, RelativePosition, 125, from * CFrame.new(0, 5, 0))
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

local function GetBossCFrame(name: string?): CFrame?
    if name then
        for _, instance in pairs(steps:GetChildren()) do
            if instance.Name == "bossLedge" then
                local BossFolder: Folder? = instance:FindFirstChild("Boss")
                if BossFolder then
                    local Boss = BossFolder:FindFirstChild("Boss") :: Model?
                    if Boss then
                        local Configuration = Boss:FindFirstChild("Configuration") :: Folder?
                        if Configuration then
                            local bossName = Configuration:FindFirstChild("bossName") :: StringValue?
                            local state = Configuration:FindFirstChild("state") :: StringValue?
                            if bossName and state then
                                if bossName.Value == name then
                                    if state.Value == "alive" then
                                        local HumanoidRootPart = Boss:FindFirstChild("HumanoidRootPart") :: BasePart?
                                        if HumanoidRootPart then
                                            return HumanoidRootPart.CFrame
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

export type BossInfo = {
    [string]: {
        currentHealth: number,
        currentCFrame: CFrame,
        level: number,
        spawnPosition: Vector3,
        bossName: string,
        maxHealth: number,
        state: string,
    },
}

local function GetBossInfo(): BossInfo    
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

local function GetBoss(): string?
    local TargetPriority = GetConfig("target_priority")
    local TargetAllBosses = GetConfig("target_all_bosses")
    local BossInfo: BossInfo = GetBossInfo()
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
        return BossName
    end
    return GetConfig("selected_boss")
end

section1:addDropdown({
    title = "Select Boss",
    default = nil,
    list = Bosses,
    callback = function(value: string)
        SetConfig("selected_boss", value)
    end
})

section1:addToggle({
    title = "Auto Fire",
    toggled = false,
    callback = function(value: boolean) : ()
        SetConfig("auto_fire", value)
        while GetConfig("auto_fire") do task.wait(1/GetConfig("fire_rate"))
            local BossName: string? = GetBoss()
            local BossCFrame: CFrame? = GetBossCFrame(BossName)
            local LocalPlayerCFrame: CFrame? = GetLocalPlayerCFrame()
            if BossCFrame and LocalPlayerCFrame and IsPlayerInBossZone(BossName) then
                if GetConfig("killing_mode") == "Normal" then
                    ThrowSnowball(LocalPlayerCFrame, BossCFrame)
                elseif GetConfig("killing_mode") == "Unstoppable" then
                    ThrowSnowball(BossCFrame, BossCFrame)
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
    default = nil,
    list = {"Lowest Health", "Highest Health", "Closest", "Furthest", "Lowest MaxHealth", "Highest MaxHealth", "Highest Level", "Lowest Level"},
    callback = function(value: string)
        SetConfig("target_priority", value)
    end
})

section1:addDropdown({
    title = "Killing Mode",
    default = nil,
    list = {"Normal", "Unstoppable"},
    callback = function(value: string): ()
        SetConfig("killing_mode", value)
    end
})

local fire_rate_toggle
fire_rate_toggle = section1:addSlider({
    title = `Fire Rate {GetConfig("fire_rate")}.0 (Shots Per Second)`,
    default = GetConfig("fire_rate"),
    min = 1,
    max = 100,
    callback = function(value: boolean): ()
        SetConfig("fire_rate", value)
        fire_rate_toggle.Options:Update({title= `Fire Rate: {value}.0 (Shots Per Second)`})
    end
})

local SelectedBossToTeleportTo: string?

section2:addDropdown({
    title = "Select Boss",
    default = nil,
    list = Bosses,
    callback = function(value): ()
        SelectedBossToTeleportTo = value
    end
})

section2:addButton({
    title = "Teleport",
    callback = function()
        if SelectedBossToTeleportTo then
            local CFrame = BossTeleportSpots[SelectedBossToTeleportTo]
            if CFrame then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame
            end
        end
    end
})

local page3 = UI:addPage({
    title = "Misc",
    icon = 15196113798
})

local section1 = page3:addSection({
    title = "Misc"
})

local infinite_double_jumps_connection: RBXScriptConnection?

section1:addToggle({
    title = "Infinite Double Jumps",
    toggled = false,
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

local page4 = UI:addPage({
    title = "Info",
    icon = 15084116748
})

local section1 = page4:addSection({
    title = "Join My Discord Server"
})

local section2 = page4:addSection({
    title = "Last Updated"
})

local section3 = page4:addSection({
    title = "Contributors"
})


local section4 = page4:addSection({
    title = "Known Issues"
})

local section5 = page4:addSection({
    title = "Open Source Script"
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
    title = "Auto Fire in Bosses is not compatible with Solara.",
    callback = function(): ()
        setclipboard("Auto Fire in Bosses is not compatible with Solara.")
    end
})

section5:addButton({
    title = "Feel free to use or modify. Just credit me for copied parts.",
    callback = function(): ()
        setclipboard("Feel free to use or modify. Just credit me for copied parts.")
    end
})


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
    page = UI.pages[4], 
    toggle = true
})
