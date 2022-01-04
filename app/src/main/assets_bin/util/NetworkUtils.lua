local NetworkUtils = {}
local NETWORK_NOT = "Perangkat saat ini tidak terhubung ke internet！"
local NETWORK_WIFI = "Terhubung ke jaringan WIFI！"
local NETWORK_MOBILE = "Terhubung ke jaringan seluler！"

function NetworkUtils:getNetworkState()
  import "android.net.ConnectivityManager"
  local networkType = -1
  local systemService = this.getSystemService(Context.CONNECTIVITY_SERVICE)
  local networkInfo = systemService.getActiveNetworkInfo()
  if networkInfo == nil then
    return networkType
  end
  local type = networkInfo.getType()
  if type == ConnectivityManager.TYPE_MOBILE then
    networkType = 2
   elseif type == ConnectivityManager.TYPE_WIFI then
    networkType = 1
  end
  return networkType
end

function NetworkUtils:getNetworkType()
  local state = self:getNetworkState()
  switch state
   case -1
    return NETWORK_NOT
   case 1
    return NETWORK_WIFI
   case 2
    return NETWORK_MOBILE
  end
end

return NetworkUtils