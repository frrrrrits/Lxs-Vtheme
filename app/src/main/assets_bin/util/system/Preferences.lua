import "android.content.res.Configuration"

local Preferences={}
setmetatable(Preferences,Preferences)

Preferences.keys={
  themeMode = "theme_mode", 
  server = "server_url",
  randomkey = "key_random"
}

Preferences.values={
  apptheme={
    light = "Terang",
    dark = "Gelap",
    system = "Ikuti system",
  },
  appserver={
    global = "Server global", 
    cn = "Server china"
  }  
}

function Preferences.setPrefIfNull(keys,values)
  if activity.getSharedData(keys)==nil then
    activity.setSharedData(keys,values)
  end
end

Preferences.setPrefIfNull(Preferences.keys.themeMode, Preferences.values.apptheme.system)
Preferences.setPrefIfNull(Preferences.keys.server, Preferences.values.appserver.global)
Preferences.setPrefIfNull(Preferences.keys.randomkey, false)

function Preferences.themeMode(s,value)
  if s==0 then
    return activity.getSharedData(Preferences.keys.themeMode)
   elseif s==1 then
    activity.setSharedData(Preferences.keys.themeMode,value)
  end
end

function Preferences.server(s,value)
  if s==0 then
    return activity.getSharedData(Preferences.keys.server)
   elseif s==1 then
    activity.setSharedData(Preferences.keys.server,value)
  end
end

function Preferences.keyrandom(s,value)
  if s==0 then
    return activity.getSharedData(Preferences.keys.randomkey)
   elseif s==1 then
    activity.setSharedData(Preferences.keys.randomkey,value)
  end
end

return Preferences