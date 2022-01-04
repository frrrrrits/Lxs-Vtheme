import "util.widget.EmptyView"
import "data.LxsDatas"
import "data.ParseOnError"
import "util.system.Preferences"

local ParseDatas={}
local JSON = require "json"

local serverPrefs = Preferences.server(0)
local valueGlobal = Preferences.values.appserver.global
local valueCn = Preferences.values.appserver.cn

local function onError(str, ids, fun)
  MyToast.snackActions(ids.mainlay,str,"coba lagi", fun)
end

ParseDatas.getData=function(data, type, params, adapter, fragment, ids, reload)
  local postUrl
  if serverPrefs == valueGlobal then
    if type == 1 then
      postUrl = LxsDatas.globalPostTheme(params.page, params.query)
     elseif type == 4 then
      postUrl = LxsDatas.globalPosFonts(params.page, params.query)
     elseif type == 9 then
      postUrl = LxsDatas.globalPosWallpaper(params.page, params.query)
    end
   elseif serverPrefs == valueCn then
    if type == 1 then
      postUrl = LxsDatas.cnPostTheme(params.page, params.query)
     elseif type == 4 then
      postUrl = LxsDatas.cnPostFonts(params.page, params.query)
     elseif type == 9 then
      postUrl = LxsDatas.cnPostWallpaper(params.page, params.query)
    end
  end
  local options={url=postUrl}
  ids.swiperefresh.setRefreshing(true)
  LuaHttp.request(options, function(error, code, body)
    if error or code ~= 200 then
      ids.swiperefresh.setRefreshing(false)
      if params.page == 0 then
        ids.empty:label("Terjadi kesalahan ("..code..")"):show()
        onError("Gagal memuat data", ids, function()
          ParseDatas.getData(data, params, adapter, fragment, ids, true)
        end) else
        onError("Gagal memuat data", ids, function()
          ParseDatas.getData(data, params, adapter, fragment, ids, false)
        end)
      end
      return
    end
    if reload then
      for k, _ in ipairs(data) do data[k] = nil end
      for k, _ in ipairs(params) do params[k] = nil end
    end
    local json = JSON.decode(body)
    local arr = json.resList
    if #arr == 0 then
      ids.swiperefresh.setRefreshing(false)
      if params.page == 0 then
        ids.empty:label("Tidak di temukan"):show()
       else
        ids.empty:hide()
        params.limit = 1
        MyToast.showSnackBar("Habis.")
      end
      return
    end
    if serverPrefs == valueGlobal then
      params.page = params.page + 12
     elseif serverPrefs == valueCn then
      params.page = params.page + 1
    end
    uihelper.runOnUiThread(activity, function()
      for i = 1, # arr do
        data[#data + 1] = arr[i]
      end
      adapter.notifyDataSetChanged()
      ids.swiperefresh.setRefreshing(false)
    end)
  end)
end

ParseDatas.getDetailUrl = function(packageId, resId)
  local path
  if serverPrefs == valueGlobal then
    path = LxsDatas.globalPostThemeDetail(packageId, resId)
   elseif serverPrefs == valueCn then
    path = LxsDatas.cnPostThemeDetail(packageId)
  end
  return {url=path}
end

return ParseDatas