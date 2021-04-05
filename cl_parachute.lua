ESX = nil
CreateThread(function() while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(1) end end)

local sautnordboucle, sautsudboucle, showhelp2, showhelp1
local TriggerServEvent = TriggerServerEvent
local posautsud = {position = {{possudparachute = vector3(-1070.537, -2868.123, 13.95187)}}}
local posautnord = {positionnord = {{posnordparachute = vector3(501.3716, 5601.049, 796.6155)}}}

local PedCoords = {
    {-1070.34, -2867.662, 14.04, "Saut en parachute Sud", heading = 153.301, hash = 0x8CCE790F, name = "cs_carbuyer"},
    {501.3186, 5601.619, 796.709, "Saut en parachute Nord", heading = 177.840, hash = 0x3521A8D2, name = "a_m_y_genstreet_02"},
}

local BlipsCoords = {
    {501.1114, 5601.089, 796.5886, titre ="Parachute", scale = 0.7, couleur = 50, type = 377},
    {-1070.645, -2868.181, 13.95184, titre ="Parachute", scale = 0.7, couleur = 50, type = 377},
}

local function Notification(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end

local function Draw2DText(msg, time)
    ClearPrints()
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, 1)
end

local function HelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
    DisplayHelpTextThisFrame('HelpNotification', false)
end

local function SautenParachute(typedesaut, model, coords, heading)
    if typedesaut == "nord" then
        ESX.Game.SpawnLocalVehicle(GetHashKey(model), coords, heading, function(helico1) 
            heliconord = helico1
            DoScreenFadeOut(1500)
            Wait(1500)
            sautnordboucle = true
            TaskWarpPedIntoVehicle(PlayerPedId(), heliconord, -1)
            GiveWeaponToPed(PlayerPedId(), GetHashKey("gadget_parachute"),0, true, false)
            Wait(1500)
            DoScreenFadeIn(1500)
            Notification("~o~Moniteur~g~\nVous avez recu un Parachute")
        end)
    elseif typedesaut == "sud" then
        ESX.Game.SpawnLocalVehicle(GetHashKey(model), coords, heading, function(helico2) 
            helicosud = helico2
            DoScreenFadeOut(1500)
            Wait(1500)
            sautsudboucle = true
            TaskWarpPedIntoVehicle(PlayerPedId(), helicosud, -1)
            GiveWeaponToPed(PlayerPedId(), GetHashKey("gadget_parachute"),0, true, false)
            Wait(1500)
            DoScreenFadeIn(1500)
            Notification("~o~Moniteur~g~\nVous avez recu un Parachute")
        end)
    end
end

CreateThread(function()
    for _,peed in pairs(PedCoords) do
        RequestModel(GetHashKey(peed.name))
        while not HasModelLoaded(GetHashKey(peed.name)) do
            Wait(1)
        end
        local createpeds = CreatePed(4, peed.hash, peed[1], peed[2], peed[3]-1, 3374176, false, true)
        SetEntityHeading(createpeds, peed.heading)
        FreezeEntityPosition(createpeds, true)
        SetEntityInvincible(createpeds, true)
        SetBlockingOfNonTemporaryEvents(createpeds, true)
    end
    for _, cfg in pairs(BlipsCoords) do
        cfg.blips = AddBlipForCoord(cfg[1], cfg[2], cfg[3])
        SetBlipSprite(cfg.blips, cfg.type)
        SetBlipDisplay(cfg.blips, 4)
        SetBlipScale(cfg.blips, cfg.scale)
        SetBlipColour(cfg.blips, cfg.couleur)
        SetBlipAsShortRange(cfg.blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(cfg.titre)
        EndTextCommandSetBlipName(cfg.blips)
    end
end)

CreateThread(function()
    while true do
        local pCoords2 = GetEntityCoords(PlayerPedId())
        local activerfps = false
        for _,v in pairs(posautsud.position) do
            if #(pCoords2 - v.possudparachute) < 1.5 then
                activerfps = true
                Draw2DText("Appuyer sur ~g~E~s~ pour faire un saut en parachute", 1)
                if IsControlJustReleased(0, 38) then
                    TriggerServEvent("parachcute:pourpayer", 2)
                end
            elseif #(pCoords2 - v.possudparachute) < 5.0 then
                activerfps = true
                DrawMarker(21, v.possudparachute, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 46, 199, 0, 170, 0, 1, 2, 0, nil, nil, 0)
            end
        end
        for _,v in pairs(posautnord.positionnord) do
            if #(pCoords2 - v.posnordparachute) < 1.5 then
                activerfps = true
                Draw2DText("Appuyer sur ~g~E~s~ pour faire un saut en parachute", 1)
                if IsControlJustReleased(0, 38) then
                    TriggerServEvent("parachcute:pourpayer", 1)
                end
            elseif #(pCoords2 - v.posnordparachute) < 5.0 then
                activerfps = true
                DrawMarker(21, v.posnordparachute, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 46, 199, 0, 170, 0, 1, 2, 0, nil, nil, 0)
            end
        end
        if activerfps then
            Wait(1)
        else
            Wait(1500)
        end
    end
end)

CreateThread(function()
    while true do 
        Wait(1)
        if sautnordboucle then
		DisableControlAction(0, 75, true)  -- Disable exit vehicle
		DisableControlAction(27, 75, true) -- Disable exit vehicle
            DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(0, 108, true) -- NUMPAD 4
			DisableControlAction(0, 109, true) -- NUMPAD 6
            DisableControlAction(0, 111, true) -- NUMPAD 8
            DisableControlAction(0, 112, true) -- NUMPAD 5

            DisableControlAction(0, 124, true) -- NUMPAD 4
			DisableControlAction(0, 123, true) -- NUMPAD 6
            DisableControlAction(0, 127, true) -- NUMPAD 8
            DisableControlAction(0, 128, true) -- NUMPAD 5
            DisplayRadar(false)
            showhelp1 = true
            if IsControlJustPressed(1, 38) then
                showhelp1 = false
                DisplayRadar(true)
                EnableAllControlActions(1)
                TaskLeaveVehicle(PlayerPedId(), heliconord, 0)
                Wait(2500)
                DeleteEntity(heliconord)
                sautnordboucle = false
            end
        else
            Wait(200)
        end
        if showhelp1 then
            HelpNotification("~INPUT_PICKUP~ pour sauter\n~INPUT_ENTER~ pour déployer votre parachute")
        else
            Wait(200)
        end
    end
end)

CreateThread(function()
    while true do 
        Wait(1)
        if sautsudboucle then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
            DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(0, 108, true) -- NUMPAD 4
			DisableControlAction(0, 109, true) -- NUMPAD 6
            DisableControlAction(0, 111, true) -- NUMPAD 8
            DisableControlAction(0, 112, true) -- NUMPAD 5

            DisableControlAction(0, 124, true) -- NUMPAD 4
		DisableControlAction(0, 123, true) -- NUMPAD 6
            DisableControlAction(0, 127, true) -- NUMPAD 8
            DisableControlAction(0, 128, true) -- NUMPAD 5
            DisplayRadar(false)
            showhelp2 = true
            if IsControlJustPressed(1, 38) then
                showhelp2 = false
                DisplayRadar(true)
                EnableAllControlActions(1)
                TaskLeaveVehicle(PlayerPedId(), helicosud, 0)
                Wait(2500)
                DeleteEntity(helicosud)
                sautsudboucle = false
            end
        else
            Wait(200)
        end
        if showhelp2 then
            HelpNotification("~INPUT_PICKUP~ pour sauter\n~INPUT_ENTER~ pour déployer votre parachute")
        else
            Wait(200)
        end
    end
end)

RegisterNetEvent("animations:parachutiste")
AddEventHandler("animations:parachutiste", function(sautmec)
    if sautmec == "nordiste" then
        SautenParachute("nord", "frogger", vector3(497.5639, 5559.027, 1799.813), 0.0)
    elseif sautmec == "sudiste" then
        SautenParachute("sud", "frogger", vector3(510.9638, -497.7841, 2684.909), 0.0)
    end
end)
