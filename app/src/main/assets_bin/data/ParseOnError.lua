import "util.widget.EmptyView"

local ParseOnError={}
setmetatable(ParseOnError,ParseOnError)

local CodeList={
  [301] ="Moved Permanently",
  [305] ="Use Proxy",
  [405] ="Method Not Allowed",
  [205] ="Reset Content",
  [412] ="Precondition Failed",
  [401] ="Unauthorized",
  [409] ="Conflict",
  [307] ="Temporary Redirect",
  [407] ="Proxy Authentication Required",
  [303] ="See Other",
  [203] ="Non-Authoritative Information",
  [503] ="Service Unavailable",
  [403] ="Forbidden",
  [410] ="Gone",
  [202] ="Accepted",
  [302] ="Found",
  [406] ="Not Acceptable",
  [206] ="Partial Content",
  [502] ="Bad Gateway",
  [408] ="Request Timeout",
  [204] ="No Content",
  [304] ="Not Modified",
  [404] ="Not Found",
  [413] ="Request Entity Too Large",
  [300] ="Multiple Choices",
  [100] ="Continue",
  [414] ="Request URI Too Long",
  [500] ="Internal Server Error",
  [400] ="Bad Request",
  [505] ="HTTP Version Not Supported",
  [504] ="Gateway Timeout",
  [416] ="Requested Range Not Satisfiable",
  [501] ="Not Implemented",
  [101] ="Switching Protocols",
  [411] ="Length Required",
}

function ParseOnError.onErrorStr(code)
  local errStr=CodeList[code]
  if errStr then
    return ("%s (%s)"):format(errStr,code)
   else
    return ("Unknown error (%s)"):format(code)
  end
end

function ParseOnError.onError(ids,errMsg,call)
  uihelper.runOnUiThread(activity,function()
    EmptyView:intoView(ids.mainlay)
    :label(ParseOnError.onErrorStr(errMsg))
    :addActions("Coba lagi",R.drawable.ic_refresh_24dp,call)
    :show()
  end)
end

return FetchOnError