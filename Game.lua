-- Global Variables
_G.AutoCoinActive = false
_G.AutoJoinActive = false
_G.CardValueActive = true -- Kann über ein Toggle gesteuert werden

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Connection storage for AutoJoin
local autoQueueConnection = nil

-- Remotes requirement
local remotesSuccess, remotes = pcall(function()
    return require(ReplicatedStorage:WaitForChild("Draft"):WaitForChild("Remotes"))
end)

if not remotesSuccess then
    warn("Failed to load Draft Remotes module!")
end

---------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------

-- 1. AutoCoin Function
local function PlayerAutoCoin()
    print("AutoCoin activated")
    local coinsFolder = workspace:WaitForChild("Coins", 10)

    if not coinsFolder then
        warn("Coins folder not found in Workspace!")
        return
    end

    while _G.AutoCoinActive do
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)

        if rootPart then
            local coins = {}
            for _, child in ipairs(coinsFolder:GetChildren()) do
                if child:IsA("MeshPart") and child.Name == "Coin" then
                    table.insert(coins, child)
                end
            end

            if #coins > 0 then
                for _, coin in ipairs(coins) do
                    if not _G.AutoCoinActive then break end
                    if coin and coin.Parent then
                        rootPart.CFrame = coin.CFrame
                        task.wait(0.5)
                    end
                end
            else
                task.wait(1)
            end
        else
            task.wait(1)
        end
    end

    print("AutoCoin deactivated")
end

-- 2. AutoJoin Function
local function StartAutoQueue()
    if not remotes or not remotes.SeatCall then return nil end

    local isQueuing = false

    return remotes.SeatCall.OnClientEvent:Connect(function(data)
        if not _G.AutoJoinActive then return end
        if isQueuing or not data or typeof(data.seat) ~= "Instance" then return end
        if data.userId == player.UserId then return end
        if data.seat.Occupant ~= nil then return end

        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 or humanoid.Sit then return end

        isQueuing = true

        task.spawn(function()
            task.wait(0.1)
            if data and data.seat then
                remotes.SeatJoin:FireServer(data.seat)
            end
            task.wait(0.5)
            isQueuing = false
        end)
    end)
end

-- 3. Character Value Overlay Setup
local function InitCardValueOverlay()
    local playerGui = player:WaitForChild("PlayerGui")
    local success, draftUI = pcall(function()
        return playerGui:WaitForChild("DraftUI", 5)
    end)

    if not success or not draftUI then
        warn("DraftUI not found for Card Value Overlay!")
        return
    end

    local HUD = draftUI:WaitForChild("HUD")
    local objectCard = HUD:WaitForChild("ObjectCard")
    local objectName = objectCard:WaitForChild("ObjectName")
    local subtitleLabel = objectCard:WaitForChild("SubtitleLabel")

    local CardValues = {
local CardValues = {
        ["Accelerator"] = { val = 12, exact = false },
        ["Ainz Ooal Gown"] = { val = 21, exact = false },
        ["Akaza"] = { val = 3, exact = false },
        ["Akainu"] = { val = 12, exact = false },
        ["All For One"] = { val = 5, exact = false },
        ["All Might"] = { val = 5.7, exact = true },
        ["Alucard"] = { val = 16.3, exact = true },
        ["Anos Voldigoad"] = { val = 75.1, exact = true },
        ["Anti-Spiral"] = { val = 65, exact = false },
        ["Aokiji"] = { val = 9.5, exact = true },
        ["Arceus"] = { val = 79.6, exact = true },[cite: 7]
        ["Asta"] = { val = 9.8, exact = true },
        ["Beerus"] = { val = 62.5, exact = true },
        ["Big Mom"] = { val = 10.6, exact = true },
        ["Blackbeard"] = { val = 11, exact = true },
        ["Boros"] = { val = 19, exact = false },
        ["Broly"] = { val = 30.2, exact = true },
        ["Cell"] = { val = 22, exact = false },
        ["Charlotte Katakuri"] = { val = 8.3, exact = true },
        ["Chrollo Lucilfer"] = { val = 5.5, exact = true },
        ["Coyote Starkk"] = { val = 9, exact = false },
        ["Denji"] = { val = 4, exact = false },
        ["Dio Brando"] = { val = 6, exact = false },
        ["Dracule Mihawk"] = { val = 11, exact = false },
        ["Edward Elric"] = { val = 2.0, exact = true },
        ["Enrico Pucci"] = { val = 27.1, exact = true },
        ["Eren Yeager"] = { val = 7.6, exact = true },
        ["Erza Scarlet"] = { val = 9, exact = false },
        ["Escanor"] = { val = 19.7, exact = true },
        ["Featherine Augustus Aurora"] = { val = 88.3, exact = true },
        ["Femto"] = { val = 9, exact = false },
        ["Frieza"] = { val = 32.9, exact = true },
        ["Frieren"] = { val = 12.5, exact = true },[cite: 7]
        ["Garou"] = { val = 24, exact = false },
        ["Genryusai Yamamoto"] = { val = 20, exact = false },
        ["Gilgamesh"] = { val = 41.7, exact = true },
        ["Ging Freecss"] = { val = 6, exact = false },
        ["Gintoki Sakata"] = { val = 2, exact = false },
        ["Giorno Giovanna"] = { val = 28.1, exact = true },
        ["Gogeta"] = { val = 29, exact = false },
        ["Gohan"] = { val = 28.2, exact = true },[cite: 7]
        ["Goku"] = { val = 28, exact = false },
        ["Gol D. Roger"] = { val = 11.8, exact = true },
        ["Gon Freecss"] = { val = 5, exact = false },
        ["Grimmjow"] = { val = 10.4, exact = true },
        ["Guts"] = { val = 3.4, exact = true },
        ["Hao Asakura"] = { val = 16.6, exact = true },
        ["Hiei"] = { val = 7, exact = false },
        ["Hisoka Morow"] = { val = 5.3, exact = true },
        ["Hit"] = { val = 15, exact = false },
        ["Ichibe Hyosube"] = { val = 18.7, exact = true },
        ["Ichigo Kurosaki"] = { val = 23.8, exact = true },
        ["Isaac Netero"] = { val = 7, exact = false },
        ["Isshiki Otsutsuki"] = { val = 20, exact = false },
        ["Itachi Uchiha"] = { val = 9, exact = false },
        ["Izuku Midoriya"] = { val = 4.2, exact = true },
        ["Jiren"] = { val = 28.8, exact = true },
        ["Jin Mori"] = { val = 43.2, exact = true },
        ["John Kaisen"] = { val = 444, exact = true },
        ["Jotaro Kujo"] = { val = 6, exact = false },
        ["Kaguya Otsutsuki"] = { val = 20.6, exact = true },
        ["Kaido"] = { val = 15.2, exact = true },
        ["Kakashi Hatake"] = { val = 10.8, exact = true },
        ["Kamina"] = { val = 2.1, exact = true },
        ["Kars"] = { val = 7, exact = false },
        ["Kenjaku"] = { val = 18, exact = false },
        ["Kenpachi Zaraki"] = { val = 11, exact = true },
        ["Kenshiro"] = { val = 2.7, exact = true },
        ["Killua Zoldyck"] = { val = 5.5, exact = true },
        ["Kirito"] = { val = 1.8, exact = true },
        ["Kisuke Urahara"] = { val = 11, exact = false },
        ["Kizaru"] = { val = 9, exact = false },
        ["Kokushibo"] = { val = 4, exact = false },
        ["Krillin"] = { val = 14.9, exact = true },
        ["Levi Ackerman"] = { val = 2, exact = false },
        ["Light Yagami"] = { val = 2, exact = false },
        ["Madara Uchiha"] = { val = 22.3, exact = true },
        ["Majin Buu"] = { val = 18, exact = false },
        ["Makima"] = { val = 18, exact = false },
        ["Meliodas"] = { val = 19.5, exact = true },[cite: 7]
        ["Meruem"] = { val = 7.6, exact = true },
        ["Might Guy"] = { val = 9, exact = false },
        ["Mikasa Ackerman"] = { val = 2, exact = false },
        ["Milim Nava"] = { val = 31.3, exact = true },
        ["Minato Namikaze"] = { val = 10.8, exact = true },
        ["Momoshiki Otsutsuki"] = { val = 18.9, exact = true },
        ["Monkey D. Garp"] = { val = 10.0, exact = true },
        ["Monkey D. Luffy"] = { val = 13, exact = false },
        ["Mr. Satan"] = { val = 8, exact = false },
        ["Muzan Kibutsuji"] = { val = 4.3, exact = true },
        ["Naruto Uzumaki"] = { val = 19, exact = false },
        ["Natsu Dragneel"] = { val = 7.5, exact = true },
        ["Portgas D. Ace"] = { val = 6, exact = false },
        ["Rimuru Tempest"] = { val = 41.6, exact = true },
        ["Roronoa Zoro"] = { val = 8, exact = false },
        ["Ryomen Sukuna"] = { val = 21.1, exact = true },
        ["Saiki Kusuo"] = { val = 70, exact = false },
        ["Sailor Cosmos"] = { val = 70, exact = false },
        ["Saitama"] = { val = 40, exact = false },
        ["Sakura Haruno"] = { val = 1, exact = false },
        ["Sanji"] = { val = 6, exact = false },
        ["Satoru Gojo"] = { val = 18, exact = false },
        ["Sasuke Uchiha"] = { val = 19.6, exact = true },
        ["Sesshomaru"] = { val = 6, exact = false },
        ["Shanks"] = { val = 13.0, exact = true },
        ["Shigeo Kageyama"] = { val = 15, exact = true },
        ["Sinbad"] = { val = 44.6, exact = true },
        ["Sosuke Aizen"] = { val = 21, exact = false },
        ["Sung Jinwoo"] = { val = 16.4, exact = true },
        ["Tanjiro Kamado"] = { val = 4, exact = false },
        ["Tatsumaki"] = { val = 13, exact = false },
        ["Toji Fushiguro"] = { val = 5.4, exact = true },
        ["Tomura Shigaraki"] = { val = 4.8, exact = true },
        ["Truth"] = { val = 70, exact = false },
        ["Ulquiorra Cifer"] = { val = 10, exact = false },
        ["Usopp"] = { val = 1, exact = true },
        ["Vegeta"] = { val = 31.8, exact = true },
        ["Vegito"] = { val = 31, exact = false },
        ["Whis"] = { val = 56.8, exact = true },
        ["Whitebeard"] = { val = 11, exact = false },
        ["Yami Sukehiro"] = { val = 7.5, exact = true },
        ["Yamcha"] = { val = 9.8, exact = true },
        ["Yhwach"] = { val = 21, exact = false },
        ["Yoriichi Tsugikuni"] = { val = 4, exact = false },
        ["Yuji Itadori"] = { val = 5.3, exact = true },
        ["Yujiro Hanma"] = { val = 3, exact = false },
        ["Yusuke Urameshi"] = { val = 7, exact = false },
        ["Yuta Okkotsu"] = { val = 17, exact = false },
        ["Zenitsu Agatsuma"] = { val = 3, exact = false },
        ["Zeno"] = { val = 81, exact = false }
    }

    local valueLabel = objectCard:FindFirstChild("CardValueLabel")
    if not valueLabel then
        valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "CardValueLabel"
        valueLabel.BackgroundTransparency = 1
        valueLabel.Size = UDim2.fromScale(1, 0.22)
        valueLabel.Position = UDim2.fromScale(0, 0.02)
        valueLabel.Font = Enum.Font.GothamBlack
        valueLabel.TextScaled = true
        valueLabel.ZIndex = objectName.ZIndex + 5
        valueLabel.Parent = objectCard
    end

    objectName.Position = UDim2.fromScale(0.05, 0.25)
    subtitleLabel.Position = UDim2.fromScale(0.05, 0.42)

    if remotes and remotes.DraftState then
        remotes.DraftState.OnClientEvent:Connect(function(data)
            if not _G.CardValueActive then 
                valueLabel.Text = ""
                return 
            end

            if type(data) == "table" and data.phase == "lot" and data.object then
                local cardName = data.object.name or "Unbekannt"
                local cardData = CardValues[cardName]

                if cardData then
                    if cardData.exact then
                        valueLabel.Text = string.format("Value: $%.1f", cardData.val)
                    else
                        valueLabel.Text = string.format("Not Sure (~($%.1f))", cardData.val)
                    end
                    
                    if cardData.val >= 50 then
                        valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                    elseif cardData.val >= 20 then
                        valueLabel.TextColor3 = Color3.fromRGB(170, 0, 255)
                    else
                        valueLabel.TextColor3 = Color3.fromRGB(0, 230, 120)
                    end
                else
                    valueLabel.Text = "VALUE: UNKNOWN"
                    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            else
                valueLabel.Text = ""
            end
        end)
    end
end

-- Start card value script safely
task.spawn(InitCardValueOverlay)

---------------------------------------------------------
-- RAYFIELD UI
---------------------------------------------------------

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ultimate Automation Hub",
    LoadingTitle = "Loading Hub...",
    LoadingSubtitle = "by Assistant",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "UltimateConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- Tabs erstellen
local AutoTab = Window:CreateTab("Automation", 4483362458)
local VisualsTab = Window:CreateTab("Visuals & UI", 4483362458)

-- Auto Tab Content
AutoTab:CreateSection("Farming & Queues")

AutoTab:CreateToggle({
    Name = "Auto Collect Coins",
    CurrentValue = false,
    Flag = "AutoCoinToggle",
    Callback = function(Value)
        _G.AutoCoinActive = Value
        if _G.AutoCoinActive then
            task.spawn(PlayerAutoCoin)
        end
    end,
})

AutoTab:CreateToggle({
    Name = "Auto Join Game",
    CurrentValue = false,
    Flag = "AutoJoinToggle",
    Callback = function(Value)
        _G.AutoJoinActive = Value
        if _G.AutoJoinActive then
            if not autoQueueConnection then
                autoQueueConnection = StartAutoQueue()
            end
        else
            if autoQueueConnection then
                autoQueueConnection:Disconnect()
                autoQueueConnection = nil
            end
        end
    end,
})

-- Visuals Tab Content
VisualsTab:CreateSection("Draft Overlay")

VisualsTab:CreateToggle({
    Name = "Show Character Value",
    CurrentValue = true,
    Flag = "CardValueToggle",
    Callback = function(Value)
        _G.CardValueActive = Value
    end,
})

-- Notification
Rayfield:Notify({
    Title = "Ultimate Hub Loaded",
    Content = "All features are ready to use!",
    Duration = 3,
    Image = 4483362458,
})
