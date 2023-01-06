local players = {}

function setPlayerIdentity(xPlayer)
  local playerData = players[xPlayer.source];

  if xPlayer.set and xPlayer.setName then
    xPlayer.setName(playerData.name);
    for key, value in pairs(playerData) do
      xPlayer.set(key, value);
    end
  end
  
  TriggerClientEvent('7even_identity:setPlayerData', xPlayer.source, playerData);

  Config.Query('UPDATE users SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ? WHERE identifier = ?', {
    playerData.firstName,
    playerData.lastName,
    playerData.dateOfBirth,
    playerData.sex,
    playerData.height,
    xPlayer.identifier
  });
end

RegisterNetEvent('esx:playerLoaded', function(playerId)
  local xPlayer;

  while not xPlayer do
    Citizen.Wait(250);
    xPlayer = ESX.GetPlayerFromId(playerId);
  end

  Config.Query("SELECT * FROM users WHERE identifier = @identifier", {
    ["@identifier"] = xPlayer.identifier
  }, function(result)
    if not result[1] then
      return
    end

    if not result[1].firstname then
      TriggerClientEvent('7even_identity:nui:send', playerId, { type = "open" });
      TriggerClientEvent('7even_identity:nui:focus', playerId);
    else
      players[playerId] = {
        name = ('%s %s'):format(result[1].firstname, result[1].lastname),
        firstName = result[1].firstname,
        lastName = result[1].lastname,
        dateOfBirth = result[1].dateofbirth,
        sex = result[1].sex,
        height = result[1].height
      };

      setPlayerIdentity(xPlayer);
    end
  end);
end);

RegisterNetEvent('7even_identity:createCharacter', function(data)
  local source = source;
  local xPlayer = ESX.GetPlayerFromId(source);

  players[source] = {
    name = ('%s %s'):format(data.firstname, data.lastname),
    firstName = data.firstname,
    lastName = data.lastname,
    dateOfBirth = Config.DateFormat:gsub('{day}', data.birthdate.day):gsub('{month}', data.birthdate.month):gsub('{year}', data.birthdate.year),
    sex = data.gender,
    height = data.size
  }

  setPlayerIdentity(xPlayer);
end);