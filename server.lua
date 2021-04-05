ESX = nil
TriggerEvent('Blow:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("parachcute:pourpayer")
AddEventHandler("parachcute:pourpayer", function(activ)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local pricenord = 70
    local pricesud = 110
    if activ == 1 then
    if xPlayer.getMoney() >= pricenord then
        xPlayer.removeMoney(pricenord)
        TriggerClientEvent("animations:parachutiste", src, "nordiste")
    else
        TriggerClientEvent("blowCore:Notification", src, "~r~Tu n'a pas assez d'argent, il te faut $" ..pricenord)
    end
        elseif activ == 2 then
            if xPlayer.getMoney() >= pricesud then
                xPlayer.removeMoney(pricesud)
                TriggerClientEvent("animations:parachutiste", src, "sudiste")
            else
            TriggerClientEvent("blowCore:Notification", src, "~r~Tu n'a pas assez d'argent, il te faut $" ..pricesud)
        end
    end
end)