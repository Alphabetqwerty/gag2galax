local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "GALAX GAG2"
Junkie.identifier = "1129572"

local result = (function()
    getgenv().Key = getgenv().Key or nil
    getgenv().SCRIPT_KEY = getgenv().Key
    getgenv().UI_CLOSED = true -- ตั้งค่าเป็น true เนื่องจากไม่มี UI ให้ปิดแล้ว

    local function hasFileSystemSupport()
        local hasWritefile = pcall(function() return type(writefile) == "function" end)
        local hasReadfile = pcall(function() return type(readfile) == "function" end)
        local hasIsfile = pcall(function() return type(isfile) == "function" end)
        return hasWritefile and hasReadfile and hasIsfile
    end
    
    local fileSystemSupported = hasFileSystemSupport()
    
    local function saveVerifiedKey(key)
        if not fileSystemSupported then return false end
        local ok = pcall(function()
            writefile("verified_key.txt", key)
        end)
        return ok
    end
    
    local function loadVerifiedKey()
        if not fileSystemSupported then 
            return nil 
        end
        
        local ok, content = pcall(function()
            return readfile("verified_key.txt")
        end)
        
        if not ok or not content then 
            return nil 
        end
        return content
    end
    
    local function clearSavedKey()
        if not fileSystemSupported then return false end
        local ok = pcall(function() delfile("verified_key.txt") end)
        return ok
    end

    -- ตรวจสอบ Key อัตโนมัติจาก getgenv() หรือจากไฟล์ที่เคยบันทึกไว้
    local currentKey = getgenv().Key or loadVerifiedKey()

    if currentKey and currentKey ~= "" then
        -- ส่งคีย์ไปตรวจสอบกับระบบ Junkie 
        -- หมายเหตุ: ส่วนนี้ต้องปรับคอลแบ็กให้เข้ากับฟังก์ชันตรวจสอบของสคริปต์หลักของคุณ (ปกติจะเป็น Junkie:Verify หรือคล้ายกัน)
        print("Verifying key background...")
        return currentKey
    else
        warn("No verification key found.")
        return nil
    end
end)()

local currentPlaceId = game.PlaceId
local localPlayer = game:GetService("Players").LocalPlayer

if currentPlaceId == 97598239454123 or currentPlaceId == 133438856880402 then
wait(5)

local playersService = game:GetService("Players")
local localPlayer = playersService.LocalPlayer

getgenv().antiAfkEnabled = true

local virtualUser = game:GetService("VirtualUser")

if getgenv().antiAfkConnection then
    getgenv().antiAfkConnection:Disconnect()
end

getgenv().antiAfkConnection = localPlayer.Idled:Connect(function()
    if not getgenv().antiAfkEnabled then return end
    pcall(function()
        virtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        virtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

local function waitForMapReady(timeoutSeconds)
    timeoutSeconds = timeoutSeconds or 30
    local startTime = tick()

    local replicatedStorage = game:GetService("ReplicatedStorage")
    local workspaceService = game:GetService("Workspace")

    while (tick() - startTime) < timeoutSeconds do
        local sharedModules = replicatedStorage:FindFirstChild("SharedModules")
        local gardens = workspaceService:FindFirstChild("Gardens")

        if sharedModules and gardens then
            local seedData = sharedModules:FindFirstChild("SeedData")
            local networking = sharedModules:FindFirstChild("Networking")
            local packet = sharedModules:FindFirstChild("Packet")

            if seedData and networking and packet then
                return true
            end
        end

        task.wait(0.5)
    end

    return false
end

local function waitForPlayerPlot(timeoutSeconds)
    timeoutSeconds = timeoutSeconds or 15
    local startTime = tick()

    while (tick() - startTime) < timeoutSeconds do
        local plotId = localPlayer:GetAttribute("PlotId")
        if plotId then
            local gardens = game:GetService("Workspace"):FindFirstChild("Gardens")
            if gardens then
                local playerPlot = gardens:FindFirstChild("Plot" .. tostring(plotId))
                if playerPlot then
                    return true
                end
            end
        end
        task.wait(0.5)
    end

    return false
end

local mapReady = waitForMapReady(30)

if not mapReady then
    warn("Map failed to load within 30 seconds. Script may not work correctly.")
end

local plotReady = waitForPlayerPlot(15)

if not plotReady then
    warn("Player plot not found. Some features may not work.")
end

getgenv().autoSkipLoadingEnabled = true

local virtualInputManager = game:GetService("VirtualInputManager")

task.spawn(function()
    local playerGui = nil
    local waitSuccess = pcall(function()
        playerGui = localPlayer:WaitForChild("PlayerGui", 30)
    end)

    if not waitSuccess or not playerGui then
        return
    end

    local startTime = tick()

    while getgenv().autoSkipLoadingEnabled do
        local elapsedTime = tick() - startTime

        if elapsedTime >= 10 then
            break
        end

        local success = pcall(function()
            local loadingGui = playerGui:FindFirstChild("LoadingGui")
            if not loadingGui then
                return
            end

            local variant1Frame = loadingGui:FindFirstChild("Variant1Frame")
            if not variant1Frame then
                return
            end

            for i = 1, 2 do
                pcall(function()
                    virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Delete, false, game)
                    virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Delete, false, game)
                end)
                task.wait(2)
            end
        end)

        task.wait(1)
    end
end)

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local sharedModules = replicatedStorage:WaitForChild("SharedModules", 10)

if not sharedModules then
    error("SharedModules not found. Cannot continue.")
    return
end




local Window = Fluent:CreateWindow({
    Title = "GROW A GARDEN2 | GALAXKUB",
    SubTitle = "",
    Search = true,
    Icon = "rbxassetid://90069817932137",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Sunset",
    Transparency = false,
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = true,
    UserInfoTop = false,
    UserInfoTitle = playersService.LocalPlayer.DisplayName,
    UserInfoSubtitle = "User",
    UserInfoSubtitleColor = Color3.fromRGB(255, 227, 71)
})

local Tabs = {
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "play" }),
    Pet = Window:AddTab({ Title = "Pet", Icon = "heart" }),
    TapPlayer = Window:AddTab({ Title = "Tap Player", Icon = "users" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "send" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "box" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}


local Options = Fluent.Options
local Config = getgenv().Config or {}

local seedNames = {}
local seedDataSuccess, seedDataModule = pcall(function()
    return require(sharedModules:WaitForChild("SeedData", 5))
end)

if not seedDataSuccess or not seedDataModule then
    warn("SeedData module failed to load: seed shop features disabled")
else
    for _, seedInfo in ipairs(seedDataModule) do
        if seedInfo.SeedName then
            local seedName = seedInfo.SeedName
            local isTool = seedName:match("Watering Can") or
                          seedName:match("Shovel") or
                          seedName:match("Trowel") or
                          seedName:match("Sprinkler") or
                          seedName:match("Build")

            if not isTool then
                table.insert(seedNames, seedName)
            end
        end
    end
    table.sort(seedNames)
end

local gearNames = {}
local gearDataSuccess, gearDataModule = pcall(function()
    return require(sharedModules:WaitForChild("GearShopData", 5))
end)

if not gearDataSuccess or not gearDataModule then
    warn("GearShopData module failed to load: gear shop features disabled")
elseif gearDataModule.Data then
    for _, gearInfo in ipairs(gearDataModule.Data) do
        if gearInfo.ItemName then
            table.insert(gearNames, gearInfo.ItemName)
        end
    end
    table.sort(gearNames)
end

local packetModule = sharedModules:WaitForChild("Packet", 5)
if not packetModule then
    error("Packet module not found. Cannot continue.")
    return
end

local packetRemote = packetModule:FindFirstChild("RemoteEvent")
if not packetRemote then
    error("Packet RemoteEvent not found. Cannot continue.")
    return
end

local shopNetworkingModule = nil
local shopNetworkingSuccess, shopNetworkingResult = pcall(function()
    return require(sharedModules:WaitForChild("Networking", 5))
end)
if shopNetworkingSuccess and shopNetworkingResult then
    shopNetworkingModule = shopNetworkingResult
else
    warn("Networking module failed to load: shop auto-buy features disabled")
end

do
    local shopSection = Tabs.Shop:AddSection("Seed Shop", "shopping-bag")

    local seedDropdown = Tabs.Shop:AddDropdown("SelectSeed", {
        Title = "Select Seed",
        Values = seedNames,
        Multi = true,
        Search = true,
        Default = {}
    })

    seedDropdown:OnChanged(function(selectedSeeds)
        local selectedList = {}
        for seedName, isSelected in pairs(selectedSeeds) do
            if isSelected then
                table.insert(selectedList, seedName)
            end
        end
    end)

local function buyAllSeeds()
    if not shopNetworkingModule or not shopNetworkingModule.SeedShop or not shopNetworkingModule.SeedShop.PurchaseSeed then return end
    if not Options.SelectSeed or not Options.SelectSeed.Value then return end

    for seedName, isSelected in pairs(Options.SelectSeed.Value) do
        if isSelected then
            pcall(function()
                shopNetworkingModule.SeedShop.PurchaseSeed:Fire(seedName)
            end)
            task.wait(0.1)
        end
    end
end

local function buyAllSeedsAll()
    if not shopNetworkingModule or not shopNetworkingModule.SeedShop or not shopNetworkingModule.SeedShop.PurchaseSeed then return end

    for _, seedName in ipairs(seedNames) do
        pcall(function()
            shopNetworkingModule.SeedShop.PurchaseSeed:Fire(seedName)
        end)
        task.wait(0.1)
    end
end


    local autoBuyToggle = Tabs.Shop:AddToggle("AutoBuySeed", {
        Title = "Auto Buy Seed",
        Description = "",
        Default = false
    })

    autoBuyToggle:OnChanged(function()
        local isEnabled = Options.AutoBuySeed.Value

        if isEnabled then
            getgenv().autoBuySeedEnabled = true

            task.spawn(function()
                while getgenv().autoBuySeedEnabled do
                    buyAllSeeds()
                    task.wait(0.1)
                end
            end)
        else
            getgenv().autoBuySeedEnabled = false
        end
    end)

    local autoBuyAllToggle = Tabs.Shop:AddToggle("AutoBuyAll", {
        Title = "Auto Buy All",
        Default = false
    })

    autoBuyAllToggle:OnChanged(function()
        local isEnabled = Options.AutoBuyAll.Value

        if isEnabled then
            getgenv().autoBuyAllEnabled = true

            task.spawn(function()
                while getgenv().autoBuyAllEnabled do
                    for _, seedName in ipairs(seedNames) do
                        if not getgenv().autoBuyAllEnabled then break end

                        pcall(function()
                            if shopNetworkingModule and shopNetworkingModule.SeedShop and shopNetworkingModule.SeedShop.PurchaseSeed then
                                shopNetworkingModule.SeedShop.PurchaseSeed:Fire(seedName)
                            end
                        end)

                        task.wait(0.1)
                    end
                    task.wait(0.3)
                end
            end)
        else
            getgenv().autoBuyAllEnabled = false
        end
    end)
end

do
    local gearSection = Tabs.Shop:AddSection("Gear Shop", "wrench")

    local gearDropdown = Tabs.Shop:AddDropdown("SelectGear", {
        Title = "Select Gear",
        Values = gearNames,
        Multi = true,
        Search = true,
        Default = {}
    })

    gearDropdown:OnChanged(function(selectedGears)
        local selectedList = {}
        for gearName, isSelected in pairs(selectedGears) do
            if isSelected then
                table.insert(selectedList, gearName)
            end
        end
    end)

    local function buyAllGears()
        if not Options.SelectGear or not Options.SelectGear.Value then return end

        for gearName, isSelected in pairs(Options.SelectGear.Value) do
            if isSelected then
                pcall(function()
                    local nameLength = string.len(gearName)
                    local bufferString = string.format("n\x00%s%s", string.char(nameLength), gearName)
                    packetRemote:FireServer(buffer.fromstring(bufferString))
                end)
                task.wait(0.1)
            end
        end
    end

    local function buyAllGearsAll()
        for _, gearName in ipairs(gearNames) do
            pcall(function()
                local nameLength = string.len(gearName)
                local bufferString = string.format("n\x00%s%s", string.char(nameLength), gearName)
                packetRemote:FireServer(buffer.fromstring(bufferString))
            end)
            task.wait(0.1)
        end
    end

    local autoBuyGearToggle = Tabs.Shop:AddToggle("AutoBuyGear", {
        Title = "Auto Buy Gear",
        Description = "",
        Default = false
    })

    autoBuyGearToggle:OnChanged(function()
        local isEnabled = Options.AutoBuyGear.Value

        if isEnabled then
            getgenv().autoBuyGearEnabled = true

            task.spawn(function()
                while getgenv().autoBuyGearEnabled do
                    buyAllGears()
                    task.wait(0.1)
                end
            end)
        else
            getgenv().autoBuyGearEnabled = false
        end
    end)

    local autoBuyAllGearToggle = Tabs.Shop:AddToggle("AutoBuyAllGear", {
        Title = "Auto Buy All Gear",
        Default = false
    })

    autoBuyAllGearToggle:OnChanged(function()
        local isEnabled = Options.AutoBuyAllGear.Value

        if isEnabled then
            getgenv().autoBuyAllGearEnabled = true

            task.spawn(function()
                while getgenv().autoBuyAllGearEnabled do
                    for _, gearName in ipairs(gearNames) do
                        if not getgenv().autoBuyAllGearEnabled then break end

                        pcall(function()
                            local nameLength = string.len(gearName)
                            local bufferString = string.format("n\x00%s%s", string.char(nameLength), gearName)
                            packetRemote:FireServer(buffer.fromstring(bufferString))
                        end)

                        task.wait(0.1)
                    end
                    task.wait(0.5)
                end
            end)
        else
            getgenv().autoBuyAllGearEnabled = false
        end
    end)
end

do
    local localPlayer = playersService.LocalPlayer
    local workspaceService = game:GetService("Workspace")
    local collectionService = game:GetService("CollectionService")

    local function getPlayerPlotForHarvest()
        local plotId = localPlayer:GetAttribute("PlotId")
        if not plotId then return nil end

        local gardens = workspaceService:FindFirstChild("Gardens")
        if not gardens then
            gardens = workspaceService:WaitForChild("Gardens", 5)
        end

        if not gardens then return nil end

        local plotName = "Plot" .. tostring(plotId)
        local plot = gardens:FindFirstChild(plotName)

        if not plot then
            plot = gardens:WaitForChild(plotName, 5)
        end

        return plot
    end

    Tabs.Auto:AddSection("Pick Fruits", "apple")

    local function pickAllFruits()
        local plot = getPlayerPlotForHarvest()
        if not plot then return 0 end

        local plantsFolder = plot:FindFirstChild("Plants")
        if not plantsFolder then return 0 end

        local picked = 0

        for _, plantModel in ipairs(plantsFolder:GetChildren()) do
            if not plantModel:IsA("Model") then continue end

            local fruitsFolder = plantModel:FindFirstChild("Fruits")

            if fruitsFolder then
                for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
                    if not getgenv().autoPickAllEnabled then break end

                    local harvestPart = fruitModel:FindFirstChild("HarvestPart")
                    if harvestPart then
                        local harvestPrompt = harvestPart:FindFirstChild("HarvestPrompt")
                        if harvestPrompt and harvestPrompt:IsA("ProximityPrompt") then
                            local success = pcall(function()
                                fireproximityprompt(harvestPrompt)
                            end)

                            if success then
                                picked = picked + 1
                            end

                            task.wait(0.1)
                        end
                    end
                end
            end

            if not getgenv().autoPickAllEnabled then break end

            local harvestPart = plantModel:FindFirstChild("HarvestPart")
            if harvestPart then
                local harvestPrompt = harvestPart:FindFirstChild("HarvestPrompt")
                if harvestPrompt and harvestPrompt:IsA("ProximityPrompt") then
                    local success = pcall(function()
                        fireproximityprompt(harvestPrompt)
                    end)

                    if success then
                        picked = picked + 1
                    end

                    task.wait(0.1)
                end
            end
        end

        return picked
    end

    local autoPickAllToggle = Tabs.Auto:AddToggle("AutoPickAll", {
        Title = "Auto Pick All",
        Default = false
    })

    autoPickAllToggle:OnChanged(function()
        local isEnabled = Options.AutoPickAll.Value

        if isEnabled then
            getgenv().autoPickAllEnabled = true

            task.spawn(function()
                while getgenv().autoPickAllEnabled do
                    pickAllFruits()
                    task.wait(1)
                end
            end)
        else
            getgenv().autoPickAllEnabled = false
        end
    end)

    local pickSeedDropdown = Tabs.Auto:AddDropdown("SelectPickSeed", {
        Title = "Select Fruit to Pick",
        Values = seedNames,
        Multi = true,
        Search = true,
        Default = {}
    })

    pickSeedDropdown:OnChanged(function(selectedSeeds)
        if not getgenv().selectedPickSeeds then
            getgenv().selectedPickSeeds = {}
        end

        getgenv().selectedPickSeeds = {}
        for seedName, isSelected in pairs(selectedSeeds) do
            if isSelected then
                getgenv().selectedPickSeeds[seedName] = true
            end
        end
    end)

    local function pickSelectedFruits()
        local plot = getPlayerPlotForHarvest()
        if not plot then return 0 end

        local plantsFolder = plot:FindFirstChild("Plants")
        if not plantsFolder then return 0 end

        local picked = 0
        local hasSelectedSeeds = false

        if getgenv().selectedPickSeeds then
            for _, _ in pairs(getgenv().selectedPickSeeds) do
                hasSelectedSeeds = true
                break
            end
        end

        if not hasSelectedSeeds then
            return 0
        end

        for _, plantModel in ipairs(plantsFolder:GetChildren()) do
            local plantSeedName = plantModel:GetAttribute("SeedName")

            if plantSeedName and not getgenv().selectedPickSeeds[plantSeedName] then
                continue
            end

            local fruitsFolder = plantModel:FindFirstChild("Fruits")

            if fruitsFolder then
                for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
                    local harvestPart = fruitModel:FindFirstChild("HarvestPart")
                    if harvestPart then
                        local harvestPrompt = harvestPart:FindFirstChild("HarvestPrompt")
                        if harvestPrompt and harvestPrompt:IsA("ProximityPrompt") then
                            pcall(function()
                                fireproximityprompt(harvestPrompt)
                            end)
                            picked = picked + 1
                            task.wait(0.05)
                        end
                    end
                end
            end

            local harvestPart = plantModel:FindFirstChild("HarvestPart")
            if harvestPart then
                local harvestPrompt = harvestPart:FindFirstChild("HarvestPrompt")
                if harvestPrompt and harvestPrompt:IsA("ProximityPrompt") then
                    pcall(function()
                        fireproximityprompt(harvestPrompt)
                    end)
                    picked = picked + 1
                    task.wait(0.05)
                end
            end
        end

        return picked
    end

    local autoPickSelectToggle = Tabs.Auto:AddToggle("AutoPickSelect", {
        Title = "Auto Pick Select",
        Default = false
    })

    autoPickSelectToggle:OnChanged(function()
        local isEnabled = Options.AutoPickSelect.Value

        if isEnabled then
            getgenv().autoPickSelectEnabled = true

            task.spawn(function()
                while getgenv().autoPickSelectEnabled do
                    pickSelectedFruits()
                    task.wait(1)
                end
            end)
        else
            getgenv().autoPickSelectEnabled = false
        end
    end)

    local autoSellToggle = Tabs.Auto:AddToggle("AutoSell", {
        Title = "Auto Sell",
        Default = false
    })

    autoSellToggle:OnChanged(function()
        local isEnabled = Options.AutoSell.Value

        if isEnabled then
            getgenv().autoSellEnabled = true

            task.spawn(function()
                local sellNetworking = nil
                local sellRetries = 0

                while sellRetries < 5 and not sellNetworking do
                    local success, result = pcall(function()
                        return require(replicatedStorage.SharedModules.Networking)
                    end)

                    if success and result and result.NPCS and result.NPCS.SellAll then
                        sellNetworking = result
                        break
                    end

                    sellRetries = sellRetries + 1
                    task.wait(1)
                end

                if not sellNetworking then
                    warn("SellAll packet not found. Auto Sell disabled.")
                    getgenv().autoSellEnabled = false
                    return
                end

                while getgenv().autoSellEnabled do
                    pcall(function()
                        sellNetworking.NPCS.SellAll:Fire()
                    end)
                    task.wait(1)
                end
            end)
        else
            getgenv().autoSellEnabled = false
        end
    end)

    Tabs.Auto:AddSection("Special Harvest", "star")

local autoPickRainbowGoldToggle = Tabs.Auto:AddToggle("AutoPickRainbowGold", {
    Title = "Auto Pick Rainbow/Gold Fruit",
    Default = false
})

autoPickRainbowGoldToggle:OnChanged(function()
    local isEnabled = Options.AutoPickRainbowGold.Value

    if isEnabled then
        getgenv().autoPickRainbowGoldEnabled = true

        task.spawn(function()
            local plotReferenceCFrame = nil

            local gardens = workspaceService:FindFirstChild("Gardens")
            if gardens then
                for _, gardenPlot in ipairs(gardens:GetChildren()) do
                    if gardenPlot:IsA("Model") and gardenPlot:GetAttribute("OwnerUserId") == localPlayer.UserId then
                        local plotReference = gardenPlot:FindFirstChild("PlotSizeReference")
                        if plotReference then
                            plotReferenceCFrame = plotReference.CFrame
                            break
                        end
                    end
                end
            end

            local mapFolder = workspaceService:WaitForChild("Map", 10)
            local seedPackLocations = mapFolder and mapFolder:FindFirstChild("SeedPackSpawnServerLocations")

            while getgenv().autoPickRainbowGoldEnabled do
                local foundSeedPack = false
                local playerCharacter = localPlayer.Character
                local rootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")

                if seedPackLocations and rootPart then
                    for _, spawnPart in ipairs(seedPackLocations:GetChildren()) do
                        if spawnPart:IsA("BasePart") then
                            local proximityPrompt = spawnPart:FindFirstChildOfClass("ProximityPrompt")
                            if proximityPrompt then
                                foundSeedPack = true

                                pcall(function()
                                    rootPart.CFrame = spawnPart.CFrame
                                end)

                                task.wait(0.05)

                                pcall(function()
                                    fireproximityprompt(proximityPrompt)
                                end)

                                break
                            end
                        end
                    end
                end

                if not foundSeedPack and plotReferenceCFrame and rootPart then
                    pcall(function()
                        rootPart.CFrame = plotReferenceCFrame
                    end)
                end

                task.wait()
            end
        end)
    else
        getgenv().autoPickRainbowGoldEnabled = false
    end
end)


    Tabs.Auto:AddSection("Auto Plant", "sprout")

    local plantSeedDropdown = Tabs.Auto:AddDropdown("SelectPlantSeed", {
        Title = "Select Seed",
        Values = seedNames,
        Multi = true,
        Search = true,
        Default = {}
    })

    plantSeedDropdown:OnChanged(function(selectedSeeds)
        local selectedList = {}
        for seedName, isSelected in pairs(selectedSeeds) do
            if isSelected then
                table.insert(selectedList, seedName)
            end
        end
    end)

    local networkingModule = nil
    local networkingSellModule = nil
    local maxRetries = 3
    local retryCount = 0

    while retryCount < maxRetries and not networkingModule do
        local success, result = pcall(function()
            return require(replicatedStorage.SharedModules.Networking)
        end)

        if success and result then
            networkingModule = result
            networkingSellModule = result
            break
        else
            retryCount = retryCount + 1
            if retryCount < maxRetries then
                task.wait(1)
            end
        end
    end

    if not networkingModule then
        warn("Networking module failed to load after 3 attempts. Auto-plant features may not work.")
    end

    local function getPlayerPlot()
        local plotId = localPlayer:GetAttribute("PlotId")
        if not plotId then return nil end

        local gardens = workspaceService:FindFirstChild("Gardens")
        if not gardens then
            gardens = workspaceService:WaitForChild("Gardens", 5)
        end

        if not gardens then return nil end

        local plotName = "Plot" .. tostring(plotId)
        local plot = gardens:FindFirstChild(plotName)

        if not plot then
            plot = gardens:WaitForChild(plotName, 5)
        end

        return plot
    end

    local function getSeedTool(seedName)
        local character = localPlayer.Character
        if character then
            for _, child in ipairs(character:GetChildren()) do
                local toolSeedName = child:IsA("Tool") and child:GetAttribute("SeedTool")
                if toolSeedName and toolSeedName == seedName then
                    return child
                end
            end
        end

        local backpack = localPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                local toolSeedName = child:IsA("Tool") and child:GetAttribute("SeedTool")
                if toolSeedName and toolSeedName == seedName then
                    return child
                end
            end
        end

        return nil
    end

    local function equipSeedTool(tool)
        local character = localPlayer.Character
        if not character then return false end

        if tool.Parent == character then return true end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local success = pcall(function()
                humanoid:EquipTool(tool)
            end)
            if success then
                task.wait(0.05)
                return true
            end
        end

        return false
    end

    local function getPlantAreas()
        local plot = getPlayerPlot()
        if not plot then return {} end

        local areas = {}
        for _, area in ipairs(collectionService:GetTagged("PlantArea")) do
            if area:IsA("BasePart") and area:IsDescendantOf(plot) then
                table.insert(areas, area)
            end
        end

        return areas
    end

    local function getPlantPoints(area)
        if not area or not area:IsA("BasePart") then return {} end

        local points = {}
        local step = 2
        local margin = 0.5
        local halfX = math.max((area.Size.X * 0.5) - margin, 0)
        local halfZ = math.max((area.Size.Z * 0.5) - margin, 0)

        for x = -halfX, halfX, step do
            for z = -halfZ, halfZ, step do
                local point = area.CFrame:PointToWorldSpace(Vector3.new(x, area.Size.Y * 0.5, z))
                table.insert(points, point)
            end
        end

        return points
    end

    local function getRandomPlantPoints()
        local points = {}

        for _, area in ipairs(getPlantAreas()) do
            for _, point in ipairs(getPlantPoints(area)) do
                table.insert(points, point)
            end

            local halfX = math.max((area.Size.X * 0.5) - 0.5, 0)
            local halfZ = math.max((area.Size.Z * 0.5) - 0.5, 0)

            for _ = 1, 60 do
                local offsetX = math.random() * (halfX * 2) - halfX
                local offsetZ = math.random() * (halfZ * 2) - halfZ
                local point = area.CFrame:PointToWorldSpace(Vector3.new(offsetX, area.Size.Y * 0.5, offsetZ))
                table.insert(points, point)
            end
        end

        for i = #points, 2, -1 do
            local j = math.random(i)
            points[i], points[j] = points[j], points[i]
        end

        return points
    end

    local function plantOnce()
        if not networkingModule or not networkingModule.Plant or not networkingModule.Plant.PlantSeed then
            return 0
        end

        if not Options.SelectPlantSeed or not Options.SelectPlantSeed.Value then
            return 0
        end

        local planted = 0

        for seedName, isSelected in pairs(Options.SelectPlantSeed.Value) do
            if isSelected then
                local tool = getSeedTool(seedName)
                if tool then
                    if equipSeedTool(tool) then
                        for _, point in ipairs(getRandomPlantPoints()) do
                            if tool.Parent ~= localPlayer.Character then
                                if not equipSeedTool(tool) then
                                    break
                                end
                            end

                            local success = pcall(function()
                                networkingModule.Plant.PlantSeed:Fire(point, seedName, tool)
                            end)

                            if success then
                                planted = planted + 1
                                task.wait(0.03)
                            end

                            if planted >= 25 then
                                return planted
                            end
                        end
                    end
                end
            end
        end

        return planted
    end

    local function plantOnceAll()
        if not networkingModule or not networkingModule.Plant or not networkingModule.Plant.PlantSeed then
            return 0
        end

        local planted = 0

        for _, seedName in ipairs(seedNames) do
            if seedName == "Rainbow" or seedName == "Gold" then
                continue
            end

            local tool = getSeedTool(seedName)
            if tool then
                if equipSeedTool(tool) then
                    for _, point in ipairs(getRandomPlantPoints()) do
                        if tool.Parent ~= localPlayer.Character then
                            if not equipSeedTool(tool) then
                                break
                            end
                        end

                        local success = pcall(function()
                            networkingModule.Plant.PlantSeed:Fire(point, seedName, tool)
                        end)

                        if success then
                            planted = planted + 1
                            task.wait(0.03)
                        end

                        if planted >= 25 then
                            return planted
                        end
                    end
                end
            end
        end

        return planted
    end

    local autoPlantToggle = Tabs.Auto:AddToggle("AutoPlantSeed", {
        Title = "Auto Plant Seed",
        Default = false
    })

    autoPlantToggle:OnChanged(function()
        local isEnabled = Options.AutoPlantSeed.Value

        if isEnabled then
            getgenv().autoPlantSeedEnabled = true

            task.spawn(function()
                while getgenv().autoPlantSeedEnabled do
                    local planted = plantOnce()
                    if planted == 0 then
                        task.wait(0.5)
                    else
                        task.wait(0.1)
                    end
                end
            end)
        else
            getgenv().autoPlantSeedEnabled = false
        end
    end)

    local autoPlantAllToggle = Tabs.Auto:AddToggle("AutoPlantAll", {
        Title = "Auto Plant All",
        Default = false
    })

    autoPlantAllToggle:OnChanged(function()
        local isEnabled = Options.AutoPlantAll.Value

        if isEnabled then
            getgenv().autoPlantAllEnabled = true

            task.spawn(function()
                while getgenv().autoPlantAllEnabled do
                    local planted = plantOnceAll()
                    if planted == 0 then
                        task.wait(0.5)
                    else
                        task.wait(0.1)
                    end
                end
            end)
        else
            getgenv().autoPlantAllEnabled = false
        end
    end)

    Tabs.Auto:AddSection("Tap Auto", "shovel")

    local shovelAllPlantsToggle = Tabs.Auto:AddToggle("ShovelAllPlants", {
        Title = "Shovel All Plants",
        Default = false
    })

    shovelAllPlantsToggle:OnChanged(function()
        local isEnabled = Options.ShovelAllPlants.Value

        if isEnabled then
            getgenv().shovelAllPlantsEnabled = true

            task.spawn(function()
                local shovelRemote = replicatedStorage:FindFirstChild("SharedModules")
                    and replicatedStorage.SharedModules:FindFirstChild("Packet")
                    and replicatedStorage.SharedModules.Packet:FindFirstChild("RemoteEvent")

                if not shovelRemote then
                    warn("Packet RemoteEvent not found for shovel")
                    getgenv().shovelAllPlantsEnabled = false
                    return
                end

                local function getShovelTool()
                    local playerCharacter = localPlayer.Character
                    if playerCharacter then
                        local shovelTool = playerCharacter:FindFirstChild("Shovel")
                        if shovelTool and shovelTool:IsA("Tool") then
                            return shovelTool
                        end
                    end

                    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
                    if backpack then
                        local shovelTool = backpack:FindFirstChild("Shovel")
                        if shovelTool and shovelTool:IsA("Tool") then
                            return shovelTool
                        end
                    end

                    return nil
                end

                local function equipShovel(shovelTool)
                    local playerCharacter = localPlayer.Character
                    if not playerCharacter then return false end

                    if shovelTool.Parent == playerCharacter then return true end

                    local playerHumanoid = playerCharacter:FindFirstChildOfClass("Humanoid")
                    if playerHumanoid then
                        local success = pcall(function()
                            playerHumanoid:EquipTool(shovelTool)
                        end)
                        if success then
                            task.wait(0.05)
                            return true
                        end
                    end

                    return false
                end

                while getgenv().shovelAllPlantsEnabled do
                    local plotId = localPlayer:GetAttribute("PlotId")
                    if not plotId then
                        task.wait(1)
                        continue
                    end

                    local gardens = workspaceService:FindFirstChild("Gardens")
                    if not gardens then
                        task.wait(1)
                        continue
                    end

                    local plotName = "Plot" .. tostring(plotId)
                    local playerPlot = gardens:FindFirstChild(plotName)
                    if not playerPlot then
                        task.wait(1)
                        continue
                    end

                    local plantsFolder = playerPlot:FindFirstChild("Plants")
                    if not plantsFolder then
                        task.wait(1)
                        continue
                    end

                    local plantChildren = plantsFolder:GetChildren()

                    if #plantChildren == 0 then
                        task.wait(1)
                        continue
                    end

                    local shovelTool = getShovelTool()
                    if not shovelTool then
                        warn("Shovel tool not found in inventory")
                        task.wait(2)
                        continue
                    end

                    equipShovel(shovelTool)

                    for _, plantModel in ipairs(plantChildren) do
                        if not getgenv().shovelAllPlantsEnabled then break end

                        local plantName = plantModel.Name

                        local packetData = "F\x000" .. plantName .. "\x00\x06Shovel"

                        pcall(function()
                            shovelRemote:FireServer(
                                buffer.fromstring(packetData),
                                { shovelTool }
                            )
                        end)

                        task.wait(0.3)
                    end

                    task.wait(0.5)
                end
            end)
        else
            getgenv().shovelAllPlantsEnabled = false
        end
    end)
end

do
    local webhookSection = Tabs.Webhook:AddSection("Discord Webhook", "send")

    local webhookSeedDropdown = Tabs.Webhook:AddDropdown("WebhookSelectSeed", {
        Title = "Select Seeds to Track",
        Values = seedNames,
        Multi = true,
        Search = true,
        Default = {}
    })

    webhookSeedDropdown:OnChanged(function(selectedSeeds)
        if not getgenv().webhookSelectedSeeds then
            getgenv().webhookSelectedSeeds = {}
        end

        getgenv().webhookSelectedSeeds = {}
        for seedName, isSelected in pairs(selectedSeeds) do
            if isSelected then
                getgenv().webhookSelectedSeeds[seedName] = true
            end
        end
    end)

    local webhookUrlInput = Tabs.Webhook:AddInput("WebhookURL", {
        Title = "Webhook URL",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Numeric = false,
        Finished = true
    })

    webhookUrlInput:OnChanged(function()
        getgenv().webhookUrl = Options.WebhookURL.Value
    end)

    local httpService = game:GetService("HttpService")

    local function getSeedInventory()
        local seedCounts = {}

        if not getgenv().webhookSelectedSeeds then
            return seedCounts
        end

        local backpackSuccess, backpackItems = pcall(function()
            return localPlayer.Backpack:GetChildren()
        end)

        if backpackSuccess then
            for _, item in ipairs(backpackItems) do
                if item:IsA("Tool") then
                    local seedName = item:GetAttribute("SeedTool")

                    if seedName and getgenv().webhookSelectedSeeds[seedName] then
                        seedCounts[seedName] = (seedCounts[seedName] or 0) + 1
                    end
                end
            end
        end

        local playerCharacter = localPlayer.Character
        if playerCharacter then
            local characterSuccess, characterItems = pcall(function()
                return playerCharacter:GetChildren()
            end)

            if characterSuccess then
                for _, item in ipairs(characterItems) do
                    if item:IsA("Tool") then
                        local seedName = item:GetAttribute("SeedTool")

                        if seedName and getgenv().webhookSelectedSeeds[seedName] then
                            seedCounts[seedName] = (seedCounts[seedName] or 0) + 1
                        end
                    end
                end
            end
        end

        return seedCounts
    end

    local function sendWebhookNotification()
        local webhookUrl = getgenv().webhookUrl
        if not webhookUrl or webhookUrl == "" then return end

        local seedCounts = getSeedInventory()

        local descriptionLines = {}
        local totalSeeds = 0

        for seedName, count in pairs(seedCounts) do
            table.insert(descriptionLines, string.format("- %s x%d", seedName, count))
            totalSeeds = totalSeeds + count
        end

        if #descriptionLines == 0 then
            table.insert(descriptionLines, "No tracked seeds found in inventory")
        end

        table.sort(descriptionLines)

        local description = table.concat(descriptionLines, "\n")

        local userId = localPlayer.UserId
        local displayName = localPlayer.DisplayName
        local username = localPlayer.Name

        local thumbnailUrl = string.format("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%d&size=150x150&format=Png&isCircular=false", userId)

        local profilePictureUrl = ""
        local httpRequest = (syn and syn.request) or
                           (http and http.request) or
                           (request) or
                           (http_request)

        if httpRequest then
            local thumbnailSuccess, thumbnailResponse = pcall(function()
                return httpRequest({
                    Url = thumbnailUrl,
                    Method = "GET"
                })
            end)

            if thumbnailSuccess and thumbnailResponse.StatusCode == 200 then
                local thumbnailData = httpService:JSONDecode(thumbnailResponse.Body)
                if thumbnailData and thumbnailData.data and thumbnailData.data[1] and thumbnailData.data[1].imageUrl then
                    profilePictureUrl = thumbnailData.data[1].imageUrl
                end
            end
        end

        if profilePictureUrl == "" then
            profilePictureUrl = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", userId)
        end

        local embed = {
            title = "Seed Inventory Report",
            description = description,
            color = 10181046,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer = {
                text = "GAG Script - Seed Tracker"
            },
            author = {
                name = string.format("%s (@%s)", displayName, username),
                icon_url = profilePictureUrl
            },
            thumbnail = {
                url = profilePictureUrl
            }
        }

        local payload = {
            embeds = {embed}
        }

        if httpRequest then
            pcall(function()
                httpRequest({
                    Url = webhookUrl,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = httpService:JSONEncode(payload)
                })
            end)
        end
    end

    local webhookToggle = Tabs.Webhook:AddToggle("EnableWebhook", {
        Title = "Send Webhook Notifications",
        Description = "Sends seed inventory every 1 minute",
        Default = false
    })

    webhookToggle:OnChanged(function()
        local isEnabled = Options.EnableWebhook.Value

        if isEnabled then
            getgenv().webhookEnabled = true

            task.spawn(function()
                while getgenv().webhookEnabled do
                    sendWebhookNotification()
                    task.wait(60)
                end
            end)
        else
            getgenv().webhookEnabled = false
        end
    end)

    Tabs.Webhook:AddButton({
        Title = "Test Webhook Now",
        Description = "Send a test notification immediately",
        Callback = function()
            sendWebhookNotification()
            Fluent:Notify({
                Title = "Webhook",
                Content = "Test notification sent!",
                Duration = 3
            })
        end
    })
end

do
    local petSection = Tabs.Pet:AddSection("Wild Pet", "heart")

    local petNames ={}
    local petDataSuccess, petDataResult = pcall(function()
        local petDataModule = require(replicatedStorage.SharedData.PetData)
        if type(petDataModule) == "function" then
            return petDataModule()
        end
        return petDataModule
    end)

    if petDataSuccess and petDataResult then
        for petSpecies, petInfo in pairs(petDataResult) do
            if type(petInfo) == "table" and petInfo.DisplayName then
                table.insert(petNames, petSpecies)
            end
        end
    end

    table.sort(petNames)

    local petDropdown = Tabs.Pet:AddDropdown("SelectPet", {
        Title = "Select Pet",
        Values = petNames,
        Multi = true,
        Search = true,
        Default = {}
    })

    petDropdown:OnChanged(function(selectedPets)
        getgenv().selectedPets = {}
        for petName, isSelected in pairs(selectedPets) do
            if isSelected then
                getgenv().selectedPets[petName] = true
            end
        end
    end)

    local function buySelectedPets()
        if not getgenv().selectedPets then return 0 end

        local workspaceService = game:GetService("Workspace")
        local mapFolder = workspaceService:FindFirstChild("Map")
        if not mapFolder then return 0 end

        local wildPetSpawns = mapFolder:FindFirstChild("WildPetSpawns")
        if not wildPetSpawns then return 0 end

        local playerCharacter = localPlayer.Character
        if not playerCharacter then return 0 end

        local rootPart = playerCharacter:FindFirstChild("HumanoidRootPart")
        if not rootPart then return 0 end

        local purchased = 0

        for petName, isSelected in pairs(getgenv().selectedPets) do
            if isSelected then
                for _, petFolder in ipairs(wildPetSpawns:GetChildren()) do
                    local folderName = petFolder.Name
                    local matchPattern = "WildPet_" .. petName .. "_WildPet"

                    if folderName:find(matchPattern) then
                        local petRootPart = petFolder:FindFirstChild("RootPart")
                        if petRootPart then
                            local buyPrompt = petRootPart:FindFirstChild("BuyPrompt")
                            if buyPrompt and buyPrompt:IsA("ProximityPrompt") then
                                pcall(function()
                                    rootPart.CFrame = petRootPart.CFrame
                                end)

                                task.wait(0.3)

                                pcall(function()
                                    fireproximityprompt(buyPrompt)
                                end)

                                purchased = purchased + 1
                                task.wait(0.5)
                                break
                            end
                        end
                    end
                end
            end
        end

        return purchased
    end

    local autoBuyPetToggle = Tabs.Pet:AddToggle("AutoBuyPet", {
        Title = "Auto Buy Pet",
        Default = false
    })

    autoBuyPetToggle:OnChanged(function()
        local isEnabled = Options.AutoBuyPet.Value

        if isEnabled then
            getgenv().autoBuyPetEnabled = true

            task.spawn(function()
                while getgenv().autoBuyPetEnabled do
                    buySelectedPets()
                    task.wait(1)
                end
            end)
        else
            getgenv().autoBuyPetEnabled = false
        end
    end)
end

do
    local teleportService = game:GetService("TeleportService")
    local httpService = game:GetService("HttpService")

    if not getgenv().targetPlayerList then
        getgenv().targetPlayerList = {}
    end

    if not getgenv().blacklistedServers then
        getgenv().blacklistedServers = {}
    end

    if not getgenv().currentJobId then
        getgenv().currentJobId = game.JobId
    end

    local tapPlayerSection = Tabs.TapPlayer:AddSection("Target Player Management", "user")

    local playerNameInput = Tabs.TapPlayer:AddInput("PlayerNameInput", {
        Title = "Enter Username",
        Default = "",
        Placeholder = "Username",
        Numeric = false,
        Finished = true
    })

    local targetPlayerDropdown = Tabs.TapPlayer:AddDropdown("TargetPlayerList", {
        Title = "Target Players",
        Values = getgenv().targetPlayerList,
        Multi = true,
        Search = true,
        Default = {}
    })

    local function updateTargetPlayerDropdown()
        pcall(function()
            targetPlayerDropdown:SetValues(getgenv().targetPlayerList)
        end)
    end

    local function addTargetPlayer(username)
        if not username or username:match("^%s*$") then
            Fluent:Notify({
                Title = "Tap Player",
                Content = "Username cannot be empty",
                Duration = 3
            })
            return
        end

        username = username:match("^%s*(.-)%s*$")

        for _, existingUsername in ipairs(getgenv().targetPlayerList) do
            if existingUsername == username then
                Fluent:Notify({
                    Title = "Tap Player",
                    Content = "Player already in list",
                    Duration = 3
                })
                return
            end
        end

        if #getgenv().targetPlayerList >= 50 then
            Fluent:Notify({
                Title = "Tap Player",
                Content = "Maximum 50 players reached",
                Duration = 3
            })
            return
        end

        table.insert(getgenv().targetPlayerList, username)
        updateTargetPlayerDropdown()

        Fluent:Notify({
            Title = "Tap Player",
            Content = "Added: " .. username,
            Duration = 3
        })
    end

    

    Tabs.TapPlayer:AddButton({
        Title = "Add Player",
        Description = "Add username to target list",
        Callback = function()
            local username = Options.PlayerNameInput.Value
            addTargetPlayer(username)
        end
    })

    Tabs.TapPlayer:AddButton({
        Title = "Remove Selected",
        Description = "Remove selected players from list",
        Callback = function()
            if not Options.TargetPlayerList or not Options.TargetPlayerList.Value then
                Fluent:Notify({
                    Title = "Tap Player",
                    Content = "No players selected",
                    Duration = 3
                })
                return
            end

            local removedCount = 0
            local selectedPlayers = Options.TargetPlayerList.Value

            for username, isSelected in pairs(selectedPlayers) do
                if isSelected then
                    for index, targetUsername in ipairs(getgenv().targetPlayerList) do
                        if targetUsername == username then
                            table.remove(getgenv().targetPlayerList, index)
                            removedCount = removedCount + 1
                            break
                        end
                    end
                end
            end

            updateTargetPlayerDropdown()

            Fluent:Notify({
                Title = "Tap Player",
                Content = "Removed " .. removedCount .. " player(s)",
                Duration = 3
            })
        end
    })
    local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlayerESPEnabled = false
local PlayerESPConnections = {}

local function CreatePlayerESP(Player)
    if Player == LocalPlayer then
        return
    end

    local function Setup(Character)
        local HRP = Character:WaitForChild("HumanoidRootPart", 10)
        if not HRP then return end

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "PlayerESP"
        Highlight.FillTransparency = 0.8
        Highlight.OutlineTransparency = 0
        Highlight.Adornee = Character
        Highlight.Parent = Character

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "PlayerESP"
        Billboard.Size = UDim2.new(0, 200, 0, 50)
        Billboard.AlwaysOnTop = true
        Billboard.StudsOffset = Vector3.new(0, 3, 0)
        Billboard.Parent = HRP

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.fromScale(1,1)
        Label.BackgroundTransparency = 1

        Label.TextColor3 = Color3.fromRGB(255,255,255) -- สีขาว
        Label.TextStrokeColor3 = Color3.fromRGB(0,0,0) -- ขอบดำ
        Label.TextStrokeTransparency = 0

        Label.TextScaled = true
        Label.Font = Enum.Font.GothamBold

        Label.Parent = Billboard

        task.spawn(function()
            while PlayerESPEnabled
                and Character.Parent
                and HRP.Parent do

                local MyCharacter = LocalPlayer.Character
                local MyHRP = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")

                if MyHRP then
                    local Distance = math.floor(
                        (HRP.Position - MyHRP.Position).Magnitude
                    )

                    Label.Text = string.format(
                        "%s\n[%dm]",
                        Player.Name,
                        Distance
                    )
                end

                task.wait(0.1)
            end
        end)
    end

    if Player.Character then
        Setup(Player.Character)
    end

    table.insert(
        PlayerESPConnections,
        Player.CharacterAdded:Connect(Setup)
    )
end

Tabs.TapPlayer:AddToggle("PlayerESP", {
    Title = "Player ESP",
    Default = false
}):OnChanged(function(state)

    PlayerESPEnabled = state

    if state then

        for _, Player in ipairs(Players:GetPlayers()) do
            CreatePlayerESP(Player)
        end

        table.insert(
            PlayerESPConnections,
            Players.PlayerAdded:Connect(CreatePlayerESP)
        )

    else

        for _, Player in ipairs(Players:GetPlayers()) do

            if Player.Character then

                local ESP = Player.Character:FindFirstChild("PlayerESP")
                if ESP then ESP:Destroy() end

                local HRP = Player.Character:FindFirstChild("HumanoidRootPart")

                if HRP then
                    local Billboard = HRP:FindFirstChild("PlayerESP")
                    if Billboard then Billboard:Destroy() end
                end

            end
        end

        for _, Connection in ipairs(PlayerESPConnections) do
            Connection:Disconnect()
        end

        table.clear(PlayerESPConnections)

    end
end)

    local serverSection = Tabs.TapPlayer:AddSection("Server Hopping", "globe")

    local function isTargetPlayerInServer()
        local allPlayers = playersService:GetPlayers()

        for _, player in ipairs(allPlayers) do
            for _, targetUsername in ipairs(getgenv().targetPlayerList) do
                if player.Name == targetUsername then
                    return true, targetUsername
                end
            end
        end

        return false, nil
    end

    local function addServerToBlacklist(jobId)
        if not jobId or jobId == "" then return end

        for _, existingJobId in ipairs(getgenv().blacklistedServers) do
            if existingJobId == jobId then
                return
            end
        end

        table.insert(getgenv().blacklistedServers, jobId)

        if #getgenv().blacklistedServers > 100 then
            table.remove(getgenv().blacklistedServers, 1)
        end
    end

    local function serverHop()
        local currentJobId = game.JobId
        addServerToBlacklist(currentJobId)

        Fluent:Notify({
            Title = "Tap Player",
            Content = "Searching for server...",
            Duration = 3
        })

        local httpRequest = (syn and syn.request) or
                           (http and http.request) or
                           (request) or
                           (http_request)

        if not httpRequest then
            Fluent:Notify({
                Title = "Tap Player",
                Content = "HTTP request not supported",
                Duration = 3
            })
            return
        end

        local placeId = game.PlaceId
        local serverUrl = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100"

        local success, response = pcall(function()
            return httpRequest({
                Url = serverUrl,
                Method = "GET"
            })
        end)

        if not success or response.StatusCode ~= 200 then
            Fluent:Notify({
                Title = "Tap Player",
                Content = "Failed to fetch servers",
                Duration = 3
            })
            return
        end

        local serverData = httpService:JSONDecode(response.Body)

        if not serverData or not serverData.data or #serverData.data == 0 then
            Fluent:Notify({
                Title = "Tap Player",
                Content = "No servers available",
                Duration = 3
            })
            return
        end

        local availableServers = {}

        for _, server in ipairs(serverData.data) do
            local isBlacklisted = false

            for _, blacklistedJobId in ipairs(getgenv().blacklistedServers) do
                if server.id == blacklistedJobId then
                    isBlacklisted = true
                    break
                end
            end

            if not isBlacklisted and server.playing < server.maxPlayers then
                table.insert(availableServers, server)
            end
        end

        if #availableServers == 0 then
            Fluent:Notify({
                Title = "Tap Player",
                Content = "All servers blacklisted",
                Duration = 3
            })
            return
        end

        local randomServer = availableServers[math.random(1, #availableServers)]

        Fluent:Notify({
            Title = "Tap Player",
            Content = "Hopping to new server...",
            Duration = 3
        })

        pcall(function()
            teleportService:TeleportToPlaceInstance(placeId, randomServer.id, localPlayer)
        end)
    end

    local hopWhenFindToggle = Tabs.TapPlayer:AddToggle("HopWhenFindPlayer", {
        Title = "Hop When Find Player",
        Description = "Auto hop when target player found",
        Default = false
    })

    hopWhenFindToggle:OnChanged(function()
        local isEnabled = Options.HopWhenFindPlayer.Value

        if isEnabled then
            getgenv().hopWhenFindPlayerEnabled = true

            if getgenv().hopMonitorConnection then
                getgenv().hopMonitorConnection:Disconnect()
            end

            task.spawn(function()
                while getgenv().hopWhenFindPlayerEnabled do
                    local foundPlayer, playerName = isTargetPlayerInServer()

                    if foundPlayer then
                        Fluent:Notify({
                            Title = "Tap Player",
                            Content = "Found: " .. playerName,
                            Duration = 3
                        })

                        task.wait(1)
                        serverHop()
                        break
                    end

                    task.wait(5)
                end
            end)
        else
            getgenv().hopWhenFindPlayerEnabled = false

            if getgenv().hopMonitorConnection then
                getgenv().hopMonitorConnection:Disconnect()
                getgenv().hopMonitorConnection = nil
            end
        end
    end)

    Tabs.TapPlayer:AddButton({
        Title = "Hop Server Now",
        Description = "Hop to random server immediately",
        Callback = function()
            serverHop()
        end
    })

    local serverInfoSection = Tabs.TapPlayer:AddSection("Server Information", "info")

    local serverInfoParagraph = Tabs.TapPlayer:AddParagraph({
        Title = "Current Server",
        Content = "JobId: " .. game.JobId .. "\nPlayers: " .. #playersService:GetPlayers()
    })

    Tabs.TapPlayer:AddButton({
        Title = "Clear Blacklist",
        Description = "Clear all blacklisted servers",
        Callback = function()
            getgenv().blacklistedServers = {}

            Fluent:Notify({
                Title = "Tap Player",
                Content = "Blacklist cleared",
                Duration = 3
            })
        end
    })

    task.spawn(function()
        while task.wait(10) do
            pcall(function()
                local playerCount = #playersService:GetPlayers()
                local blacklistCount = #getgenv().blacklistedServers

                serverInfoParagraph:SetDesc("JobId: " .. game.JobId .. "\nPlayers: " .. playerCount .. "\nBlacklisted Servers: " .. blacklistCount .. "/100")
            end)
        end
    end)
end

do
    local miscSection = Tabs.Misc:AddSection("FPS Boost", "zap")

    local lightingService = game:GetService("Lighting")
    local workspaceService = game:GetService("Workspace")
    local terrainService = workspaceService.Terrain

    local function applyMaximumFpsBoost()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)

        pcall(function()
            for _, effect in pairs(lightingService:GetChildren()) do
                if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or
                   effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
                    effect.Enabled = false
                end
            end

            lightingService.GlobalShadows = false
            lightingService.FogEnd = 9e9
            lightingService.Brightness = 0
        end)

        pcall(function()
            terrainService.WaterWaveSize = 0
            terrainService.WaterWaveSpeed = 0
            terrainService.WaterReflectance = 0
            terrainService.WaterTransparency = 0
            terrainService.Decoration = false
        end)

        pcall(function()
            for _, object in pairs(workspaceService:GetDescendants()) do
                if object:IsA("BasePart") then
                    object.Material = Enum.Material.Plastic
                    object.Reflectance = 0
                    object.CastShadow = false
                elseif object:IsA("Decal") or object:IsA("Texture") then
                    object.Transparency = 1
                elseif object:IsA("ParticleEmitter") or object:IsA("Trail") then
                    object.Enabled = false
                elseif object:IsA("Fire") or object:IsA("Smoke") or object:IsA("Sparkles") then
                    object.Enabled = false
                elseif object:IsA("MeshPart") then
                    object.Material = Enum.Material.Plastic
                    object.Reflectance = 0
                    object.TextureID = ""
                    object.CastShadow = false
                elseif object:IsA("SpecialMesh") then
                    object.TextureId = ""
                end
            end
        end)

        pcall(function()
            local mapFolder = workspaceService:FindFirstChild("Map")
            if mapFolder then
                for _, object in pairs(mapFolder:GetDescendants()) do
                    if object:IsA("BasePart") then
                        if not object:FindFirstAncestorOfClass("Model") or
                           not object:FindFirstAncestorOfClass("Model").Name:find("Plot") then
                            object.Material = Enum.Material.Plastic
                            object.CastShadow = false
                        end
                    end
                end
            end
        end)
    end

    local fpsBoostToggle = Tabs.Misc:AddToggle("FpsBoost", {
        Title = "FPS Boost",
        Description = "Maximum FPS optimization",
        Default = false
    })

    fpsBoostToggle:OnChanged(function()
        local isEnabled = Options.FpsBoost.Value

        if isEnabled then
            getgenv().fpsBoostEnabled = true

            applyMaximumFpsBoost()

            if getgenv().fpsBoostConnection then
                getgenv().fpsBoostConnection:Disconnect()
            end

            getgenv().fpsBoostConnection = workspaceService.DescendantAdded:Connect(function(object)
                if not getgenv().fpsBoostEnabled then return end

                task.wait()

                pcall(function()
                    if object:IsA("BasePart") then
                        object.Material = Enum.Material.Plastic
                        object.Reflectance = 0
                        object.CastShadow = false
                    elseif object:IsA("Decal") or object:IsA("Texture") then
                        object.Transparency = 1
                    elseif object:IsA("ParticleEmitter") or object:IsA("Trail") then
                        object.Enabled = false
                    elseif object:IsA("Fire") or object:IsA("Smoke") or object:IsA("Sparkles") then
                        object.Enabled = false
                    elseif object:IsA("MeshPart") then
                        object.Material = Enum.Material.Plastic
                        object.Reflectance = 0
                        object.TextureID = ""
                        object.CastShadow = false
                    elseif object:IsA("SpecialMesh") then
                        object.TextureId = ""
                    end
                end)
            end)
        else
            getgenv().fpsBoostEnabled = false

            if getgenv().fpsBoostConnection then
                getgenv().fpsBoostConnection:Disconnect()
                getgenv().fpsBoostConnection = nil
            end
        end
    end)
end


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("GAGScript")
SaveManager:SetFolder("GAGScript/config")

SaveManager:BuildConfigSection(Tabs.Settings)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

task.wait(1)

Fluent:SetTheme("Sunset")

Window:SelectTab(1)

Fluent:Notify({
    Title = "GALAX KUB",
    Content = " GROW A GARDEN2 \n Script loaded successfully!",
    Duration = 5
    
})

SaveManager:LoadAutoloadConfig()

local Config = getgenv().Config or {}

task.spawn(function()
    task.wait(2)

    for optionName, value in pairs(Config) do
        pcall(function()
            local option = Options[optionName]

            if not option then
                warn("[Config] Option not found:", optionName)
                return
            end

            -- Multi Dropdown
            if type(value) == "table" then
                local multi = {}

                for _, v in ipairs(value) do
                    multi[v] = true
                end

                option:SetValue(multi)

            -- Toggle / Slider / Input / Single Dropdown
            else
                option:SetValue(value)
            end

            print("[Config Applied]", optionName)
        end)
    end
end)

local virtualUser = game:GetService("VirtualUser")
local playersService = game:GetService("Players")
local localPlayer = playersService.LocalPlayer

localPlayer.Idled:Connect(function()
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new())
end)
end
