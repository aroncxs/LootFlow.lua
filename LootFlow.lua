local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")
local isActive = false  -- Controle do estado do autofarm
local farmSpeed = 20  -- Velocidade padrão do Tween
local coinsCollected = 0

-- Função para mover o jogador suavemente até uma posição usando Tween
local function tweenTo(position)
    if humanoidRootPart then
        local distance = (humanoidRootPart.Position - position).Magnitude
        local duration = math.max(distance / farmSpeed, 0.4)  -- Duração mínima de 0.4 segundos

        -- Configurações do Tween
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local goal = {CFrame = CFrame.new(position)}  -- Mover diretamente para a posição da CoinVisual
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
        tween:Play()

        -- Espera o Tween terminar antes de prosseguir
        tween.Completed:Wait()
    else
        warn("HumanoidRootPart não encontrado.")
    end
end

-- Função principal para coletar moedas
local function collectCoins()
    while isActive do  -- Verifica se o script está ativo
        local nearestCoin = nil
        local shortestDistance = math.huge  -- Distância mínima

        -- Encontra a CoinVisual mais próxima
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "CoinVisual" and obj:IsA("BasePart") and obj.Parent then
                local distance = (humanoidRootPart.Position - obj.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestCoin = obj
                end
            end
        end

        -- Se encontrar uma moeda, faz o Tween até ela
        if nearestCoin then
            tweenTo(nearestCoin.Position)  -- Move suavemente até a CoinVisual
            nearestCoin:Destroy()  -- Remove a moeda assim que o jogador chega a ela
            coinsCollected = coinsCollected + 1 -- Atualiza o contador de moedas

            -- Atualiza o valor das moedas coletadas na GUI
            local coinLabel = player.PlayerGui:FindFirstChild("CoinLabel")
            if coinLabel then
                coinLabel.Text = "Coins: " .. coinsCollected
            end
        else
            wait(0.5)  -- Espera antes de tentar novamente
        end

        wait(0.1)  -- Atraso para evitar loops excessivos
    end
end

-- Função para criar a GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui", player.PlayerGui)
    screenGui.Name = "AutoFarmGUI"

    local frame = Instance.new("Frame", screenGui)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.02, 0, 0.02, 0)
    frame.Size = UDim2.new(0, 200, 0, 300)
    frame.BackgroundTransparency = 0.1
    frame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    frame.BorderMode = Enum.BorderMode.Inset

    -- Arredondar bordas do frame
    local uicorner = Instance.new("UICorner", frame)
    uicorner.CornerRadius = UDim.new(0.1, 0)

    -- Label para exibir a quantidade de moedas
    local coinLabel = Instance.new("TextLabel", frame)
    coinLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    coinLabel.BackgroundTransparency = 0.3
    coinLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
    coinLabel.Size = UDim2.new(0, 180, 0, 50)
    coinLabel.Text = "Coins: " .. coinsCollected
    coinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    coinLabel.TextScaled = true
    coinLabel.Name = "CoinLabel"
    local coinUICorner = Instance.new("UICorner", coinLabel)
    coinUICorner.CornerRadius = UDim.new(0.2, 0)

    -- Botão para ativar/desativar o autofarm
    local toggleButton = Instance.new("TextButton", frame)
    toggleButton.Size = UDim2.new(0.8, 0, 0, 50)
    toggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
    toggleButton.Text = "Autofarm: Disabled"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    local toggleUICorner = Instance.new("UICorner", toggleButton)
    toggleUICorner.CornerRadius = UDim.new(0.2, 0)

    -- Campo para Farm Speed
    local farmSpeedInput = Instance.new("TextBox", frame)
    farmSpeedInput.Size = UDim2.new(0.8, 0, 0, 30)
    farmSpeedInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    farmSpeedInput.Text = tostring(farmSpeed)
    farmSpeedInput.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    farmSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    local farmSpeedUICorner = Instance.new("UICorner", farmSpeedInput)
    farmSpeedUICorner.CornerRadius = UDim.new(0.15, 0)

    -- Label para exibir a velocidade do Farm
    local farmSpeedLabel = Instance.new("TextLabel", frame)
    farmSpeedLabel.Size = UDim2.new(0.8, 0, 0, 30)
    farmSpeedLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
    farmSpeedLabel.Text = "Farm Speed: " .. farmSpeed
    farmSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmSpeedLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    local farmSpeedUICorner = Instance.new("UICorner", farmSpeedLabel)
    farmSpeedUICorner.CornerRadius = UDim.new(0.15, 0)

    -- Ação para o botão de ativar/desativar o autofarm
    toggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        toggleButton.Text = "Autofarm: " .. (isActive and "Enabled" or "Disabled")
        toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)

        if isActive then
            collectCoins()  -- Inicia a coleta
        end
    end)

    -- Atualiza a velocidade do Farm quando o campo é alterado
    farmSpeedInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newSpeed = tonumber(farmSpeedInput.Text)
            if newSpeed and newSpeed >= 20 and newSpeed <= 35 then
                farmSpeed = newSpeed
                farmSpeedLabel.Text = "Farm Speed: " .. farmSpeed
            else
                farmSpeedInput.Text = tostring(farmSpeed)  -- Reverte para a velocidade padrão se inválido
            end
        end
    end)
end

-- Cria a GUI
createGUI()

-- Mantém a GUI ativa após a morte do jogador
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)
