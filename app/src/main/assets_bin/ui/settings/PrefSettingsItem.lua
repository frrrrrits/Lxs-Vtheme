local data = { format = "0 kb" }

local cacheDir = File(activity.externalCacheDir, "cover_cache")
if not(cacheDir.exists()) then cacheDir.mkdirs() end
local astable = luajava.astable(cacheDir.listFiles())

-- get cache size
table.foreach(astable, function(index,content)
  if content.isDirectory then
    local size = content.length()
    local formater = Formatter.formatFileSize(activity, size)
    data.format = formater
  end
end)

return {
  {
    PrefSettingsLayUtil.ITEM_PREFHEADER,
    icon = R.mipmap.ic_launcher_round
  },
  {
    PrefSettingsLayUtil.ITEM_DIVIDER
  },
  {
    PrefSettingsLayUtil.ITEM,
    icon = R.drawable.ic_palette_24dp,
    title = "Tema aplikasi",
    key = "theme_picker",
    summary = Preferences.themeMode(0)
  },
  {
    PrefSettingsLayUtil.ITEM,
    icon = R.drawable.ic_server_24dp,
    title = "Server theme",
    key = "server_picker",
    summary = Preferences.server(0)
  },
  {
    PrefSettingsLayUtil.ITEM,
    icon = R.drawable.ic_delete_24dp,
    title = "Hapus cache gambar",
    summary = "Total "..tostring(data.format),
    key = "delete_cache"
  },
  {
    PrefSettingsLayUtil.ITEM_DIVIDER
  },
  {
    PrefSettingsLayUtil.ITEM_NOSUMMARY,
    icon = R.drawable.ic_error_outline_24dp,
    title = "Tentang",
    key = "about"
  },
  {
    PrefSettingsLayUtil.ITEM_PREFMARGIN
  }
}
