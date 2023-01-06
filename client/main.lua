local isNuiReady = false;

RegisterNetEvent('7even_identity:nui:focus', function()
  repeat Citizen.Wait(100) until isNuiReady;
  SetNuiFocus(true, true);
end);

RegisterNetEvent('7even_identity:nui:send', function(data)
  repeat Citizen.Wait(100) until isNuiReady;

  if data.type == "open" then
    TriggerEvent('esx_skin:resetFirstSpawn');
  end

  SendNUIMessage(data);
end);

RegisterNUICallback('createCharacter', function(data)
  TriggerEvent('esx_skin:playerRegistered');
  TriggerServerEvent('7even_identity:createCharacter', data);
end);

RegisterNUICallback('nuiReady', function(data)
  isNuiReady = true;
end);

RegisterNetEvent('7even_identity:setPlayerData', function(data)
  for key, value in pairs(data) do
    ESX.SetPlayerData(key, value);
  end

  SetNuiFocus(false, false);
end);