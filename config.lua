TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Config = {
  Query = function(query, params, cb)
    local res, resReceived = {}, false;

    exports["oxmysql"]:query(query, params, cb or function(result)
      res = result;
      resReceived = true;
    end);

    while not resReceived do
      Citizen.Wait(0);
    end

    return res;
  end,
  DateFormat = "{day}.{month}.{year}"
}
