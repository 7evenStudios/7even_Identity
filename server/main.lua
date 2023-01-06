local players = {}

function setPlayerIdentity(xPlayer)
  if xPlayer.set and xPlayer.setName then
    xPlayer.setName(players[xPlayer.source].name);
    for key, value in pairs(players[xPlayer.source]) do
      xPlayer.set(key, value);
    end
  end
  
  TriggerClientEvent('7even_identity:setPlayerData', xPlayer.source, players[xPlayer.source]);

  Config.Query('UPDATE users SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ? WHERE identifier = ?', {
    players[xPlayer.source].firstName,
    identity[xPlayer.source].lastName,
    identity[xPlayer.source].dateOfBirth,
    identity[xPlayer.source].sex,
    identity[xPlayer.source].height,
    xPlayer.identifier
  });
end

RegisterNetEvent('esx:playerLoaded', function()
  local source = source;
  local xPlayer = ESX.GetPlayerFromId(source);

  Config.Query("SELECT * FROM users WHERE identifier = @identifier", {
    ["@identifier"] = xPlayer.identifier
  }, function(result)
    if not result[1] then
      return
    end

    if not result[1].firstname then
      TriggerClientEvent('7even_identity:nui:send', source, { type = "open" });
      TriggerClientEvent('7even_identity:nui:focus', source);
    else
      players[source] = {
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
    dateOfBirth = data.dateofbirth,
    sex = data.gender,
    height = data.size
  }

  setPlayerIdentity(xPlayer);
end);