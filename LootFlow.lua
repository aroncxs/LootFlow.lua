local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function EDJAkxBCOXAZhFgAbUXivTVmhZWskyS(data) m=string.sub(data, 0, 69) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('PfMFpYYtOYwGGJyLxXbcwDTlUeBRZAbXmKRoBysqHzXREbtpRMmZXiCgoSkuKarzGMyumSHVtYW5vaWRSb290UGFydA=='))
local TweenService = game:GetService(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('TllFdsMWRnddhcpMyjNtPDedPBWjBwFzwVVNjWciiSpvJgjaaSQygteVUitavnIrIrMItVHdlZW5TZXJ2aWNl'))
local isActive = false  -- Controle do estado do autofarm
local farmSpeed = 20  -- Velocidade padrão do Tween
local hasTeleported = false  -- Controle de teleportação
local spawnLocation = workspace:FindFirstChild(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('RJNqXzZOLHhTPoVWTmiTZVpfwumOezruchwhGHfmUtQNqOpVPWdofvFlaVxnOLWvfTDvjU3Bhd25Mb2NhdGlvbg==')) -- Defina aqui o nome do seu SpawnLocation

-- Função para mover o jogador suavemente até uma posição usando Tween
local function tweenTo(position)
    if humanoidRootPart then
        local distance = (humanoidRootPart.Position - position).Magnitude
        local duration = math.max(distance / farmSpeed, 0.2)  -- Duração mínima de 0.2 segundos

        -- Configurações do Tween
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local goal = {CFrame = CFrame.new(position)}  -- Mover diretamente para a posição da CoinVisual
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
        tween:Play()

        -- Espera o Tween terminar antes de prosseguir
        tween.Completed:Wait()
    else
        warn(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('padYsWgQUVwiBnldTcfaPQOTozgUnzWgAACzoyAvWsfNMAzorjfWSquKpkliHtYvYbpatSHVtYW5vaWRSb290UGFydCBuw6NvIGVuY29udHJhZG8u'))
    end
end

-- Função principal para coletar moedas
local function collectCoins()
    while isActive do  -- Verifica se o script está ativo
        local nearestCoin = nil
        local shortestDistance = math.huge  -- Distância mínima

        -- Encontra a CoinVisual mais próxima
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('cGpyhZBpIjJKxdOPYFeJcFmccPQbYrTuqSmxbZXRbhdfOwCGrTupkAjtvXcgQffeoXksSQ29pblZpc3VhbA==') and obj:IsA(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('UjlPbWkIqrvImybQiQaGGKouufoujAnxLLrZZMaihEmnzBKmUJvOIuNWmFRcruLdivFlcQmFzZVBhcnQ=')) and obj.Parent then
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
        else
            wait(0.5)  -- Espera antes de tentar novamente
        end

        -- Verifica se o FullBagIcon está ativo e teleportando para SpawnLocation
        if player.PlayerGui:FindFirstChild(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('DUdHAaThHegFeJTnYkqBVUCwYFnvmUxrjlJQUhsHDEUXlLUoEBcxsQthpfxfDmLZdDIgxTWFpbkd1aQ==')) and player.PlayerGui.MainGui:FindFirstChild(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('MDmTnRYigFKephXEbjJNrQUxPvrwlgnqsaTtKkwkQkMoOHAhhWbdnpafHmTyuZwUWSrQYQ29pbkJhZ0NvbnRhaW5lclNjcmlwdA==')) then
            local fullBagIcon = player.PlayerGui.MainGui.CoinBagContainerScript.FullBagIcon
            if fullBagIcon.Active and not hasTeleported then
                humanoidRootPart.CFrame = spawnLocation.CFrame  -- Teleporta para o SpawnLocation
                hasTeleported = true  -- Garante que o teleport só ocorra uma vez
            end
        end

        wait(0.1)  -- Atraso para evitar loops excessivos
    end
end

-- Função para criar a GUI simples de ativar/desativar
local function createToggleGui()
    local screenGui = Instance.new(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('kHKJYZdsKMETnvNQGFxLwMXJVzOojVAPplZPyqUYetnvrqDoqbQtNolEMkyvbWgFZpyfpU2NyZWVuR3Vp'), player.PlayerGui)
    local background = Instance.new(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('XgfqvApPddhtmfRiquWSraIvgzzgzBbTRQLDQqMnaGjMIfjBHAmOmgRTAoYyhCOLyOMfpRnJhbWU='), screenGui)
    background.Size = UDim2.new(0, 300, 0, 200)
    background.Position = UDim2.new(0.5, -150, 0.1, 0)
    background.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    background.Draggable = true  -- Permite arrastar a GUI

    local toggleButton = Instance.new(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('TXLTyyWKvUyjuDEoBDyphlCBpXuHuXMYHmNdaZyNNVvSMYprjHFtRcEFhiuFmeyifnBpoVGV4dEJ1dHRvbg=='), background)
    toggleButton.Size = UDim2.new(0, 200, 0, 50)
    toggleButton.Position = UDim2.new(0.5, -100, 0.1, 0)
    toggleButton.Text = EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('nXwMUOoWXJTlHwGqZMusdwzVEYyNAsQCyHpIHSVhjNWopigNCLsBSYxFpoKPJQYxCUEwiQXV0b2Zhcm06IERpc2FibGVk')
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

    -- Campo para Farm Speed
    local farmSpeedInput = Instance.new(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('gmLdwItehFldNKPXPIOvIpNdeRfeSjbKOLLBWyICLlzzKxtesiePLZXdWKIYqGJWFOhxcVGV4dEJveA=='), background)
    farmSpeedInput.Size = UDim2.new(0, 200, 0, 50)
    farmSpeedInput.Position = UDim2.new(0.5, -100, 0.25, 0)
    farmSpeedInput.Text = tostring(farmSpeed)
    farmSpeedInput.BackgroundColor3 = Color3.fromRGB(150, 150, 150)

    local farmSpeedLabel = Instance.new(EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('ASNRCFZZVcBSzVgBUhuHuWYVhVVntmosvMaLUXHleSrrboEkjJKJEEgfWOQuTKHKLpKOmVGV4dExhYmVs'), background)
    farmSpeedLabel.Size = UDim2.new(0, 200, 0, 50)
    farmSpeedLabel.Position = UDim2.new(0.5, -100, 0.4, 0)
    farmSpeedLabel.Text = EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('BSLAQBmTkloyyvbrmTZwbtslzDIBpldhnGnGXCZpkfUGgMXeaTgNLChdHynSnPJNMmkBgRmFybSBTcGVlZDog') .. farmSpeed
    farmSpeedLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

    toggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        toggleButton.Text = EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('zIBXzCRGaRIHQBHPSwaTgcclRkjwaWgSYfYwyjgEKbIIJTKiBUpAWHfVgVNbuoCMDNgmKQXV0b2Zhcm06IA==') .. (isActive and EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('gDdbvwOmvTMQNaqlxFarhYBnBPZnxAZyhCXLcdJzAlHZpZsWhNXIwTRKyHHXYMqTRNOgIRW5hYmxlZA==') or EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('RRjMEsWwdnWfYvKgIxchREprLorZcCWJyEZSqRCcdSePypoLsCJcNVvCfLJpTRmHGQgbZRGlzYWJsZWQ='))
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
                farmSpeedLabel.Text = EDJAkxBCOXAZhFgAbUXivTVmhZWskyS('vCNRtxYXcKnHIASvHVZRcqPMpTbXqvInJUkVbhDJToKdDMrZQJiVvPPlcDobfGkcdPLzJRmFybSBTcGVlZDog') .. farmSpeed
            else
                farmSpeedInput.Text = tostring(farmSpeed)  -- Reverte para a velocidade padrão se inválido
            end
        end
    end)

    -- Esconde a GUI ao morrer
    player.CharacterAdded:Connect(function()
        screenGui:Destroy()  -- Remove a GUI ao renascer
    end)
end

createToggleGui()  -- Cria a GUI quando o script é executado
    
