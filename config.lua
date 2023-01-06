local ESX = exports["es_extended"]:getSharedObject();

Config = {
  Query = function(query, params, cb)
    local res, resReceived = {}, false;

    exports["oxmysql"]:query(query, params, cb or function(result)
      res = result;
      resReceived = true;
    end);
  end,
}