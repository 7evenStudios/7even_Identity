RegisterNetEvent('7even_identity:nui:focus', function()
  SetNuiFocus(true, true);
end);

RegisterNetEvent('7even_identity:nui:send', function(data)
  SendNUIMessage(data);
end);

RegisterNUICallback('createCharacter', function(data)
  TriggerServerEvent('7even_identity:createCharacter', data);
end);

RegisterNetEvent('7even_identity:setPlayerData', function(data)
  for key, value in pairs(data) do
    ESX.SetPlayerData(key, value);
  end

  SetNuiFocus(false, false);
end);