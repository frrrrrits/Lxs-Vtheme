-- installer untuk tema & font
import "com.androlua.LuaUtil"
import "com.androlua.LuaFileObserver"

import "android.text.format.Formatter"

local ThemeInstaller={}
setmetatable(ThemeInstaller,ThemeInstaller)

local material_style_center = R.style.ThemeOverlay_Material3_MaterialAlertDialog_Centered
local dividerColor = ContextCompat.getColor(this,R.color.divider_default)
local textColorSecondary = theme.color.textColorSecondary

local rootThemeDir = "/storage/emulated/0/.dwd/c/o/m/b/b/k/t/h/e/m/e/T/"
local rootFontsDir = "/storage/emulated/0/.dwd/c/o/m/b/b/k/t/h/e/m/e/F/"

theme_data_table = {
  key = 0,
  themetype = 0,
  themefile = 0,
  themeistype = 0,
  keyname = 0,
  themename = 0,
  isvivo = false
}

key_random_table = {
  keyrandom = false
}

local key_random = {}

local item = {
  LinearLayoutCompat,
  orientation="vertical",
  layout_height="wrap_content",
  layout_width="match_parent",
  {
    FrameLayout,
    id="card",
    background="@drawable/list_item_selector_background",
    layout_height="wrap_content",
    layout_width="match_parent",
    {
      LinearLayoutCompat,
      gravity="center|left",
      layout_margin="9dp",
      layout_height="wrap_content",
      layout_width="match_parent",
      {
        AppCompatImageView,
        layout_marginLeft="10dp",
        src="@drawable/ic_folder_zip_outline",
        layout_height="wrap_content",
        layout_width="wrap_content",
        colorFilter="0xFFF9A825",
      },
      {
        LinearLayoutCompat,
        orientation="vertical",
        gravity="center|left",
        layout_margin="16dp",
        layout_marginTop="8dp",
        layout_marginBottom="8dp",
        layout_height="wrap_content",
        layout_width="match_parent",
        {
          AppCompatTextView,
          id="title",
          textSize="15sp",
          layout_height="wrap_content",
          layout_width="wrap_content",
        },
        {
          TextView,
          id="subtitle",
          textSize="13sp",
          textColor=textColorSecondary,
          layout_height="wrap_content",
          layout_width="wrap_content",
        }
      },
    },
  },
}

-- dialog
local function createDialog(msg, title)
  return MaterialAlertDialogBuilder(this, material_style_center)
  .setTitle(title or "Terjadi kesalahan")
  .setIcon(R.drawable.ic_error_outline_24dp)
  .setMessage(msg)
  .setPositiveButton("Baik", function() end)
  .create()
  .show()
end

local function resetdata()
end

local function instaltheme()
  local rootpath
  local themename = string.format("%d.%s",
  theme_data_table.keyname:gsub("Key ",""),
  theme_data_table.themename)

  -- buat directory
  local dirPath = File(string.format("%s/.LxsTemp/%s", AppPath.Sdcard, themename:gsub(".itz", "")))
  if not(dirPath.exists()) then
    dirPath.mkdirs()
  end

  -- unzip semua file yg berkaitan
  local keyPath = tostring(theme_data_table.key)
  local themePath = tostring(theme_data_table.themefile)

  LuaUtil.unZip(themePath, tostring(dirPath))
  LuaUtil.unZip(keyPath, tostring(dirPath))

  -- dapatkan list file
  local astable = luajava.astable(dirPath.listFiles())
  table.foreach(astable, function(index,content)
    if content.name:find("fonts") then
      theme_data_table.themeistype = 4
     elseif content.name:find("icons")
      theme_data_table.themeistype = 1
    end
    if content.name:find("vivo") then            
      theme_data_table.isvivo = true
    end
  end)

  local istype = tonumber(theme_data_table.themeistype)
  local themetype = tonumber(theme_data_table.themetype)
  -- compare kalau [istype] [themetype] itu sama
  if istype == themetype then
    ThemeInstaller:createLoading() -- rada gaguna karna cepat bgt ngezip nya
    if theme_data_table.isvivo == true then
      createDialog("Sebelum membuka iTheme pastikan untuk mengubah nama [vivo] ke [vivo1] di berkas Tema.\nJika sudah buka iTheme dan rubah kembali [vivo1] ke [vivo]", "Notes").show()
    end
    xpcall(function()      
      if themetype == 1 then
        rootpath = tostring(rootThemeDir)
       elseif themetype == 4 then
        rootpath = tostring(rootFontsDir)
      end
      -- zip semua file berkaitan
      LuaUtil.zip(tostring(dirPath),rootpath,tostring(themename))
      LuaUtil.rmDir(dirPath)
      
      ThemeInstaller:dismissLoading()
      MyToast.showSnackBar("Berhasil memasang.")
    end,
    function(err)
      ThemeInstaller:dismissLoading()

      MyToast.showSnackBar("Gagal memasang.")
      LuaUtil.rmDir(dirPath)
    end)
   else
    createDialog("Saat ini tidak support untuk pemasangan fonts.\n").show()
    LuaUtil.rmDir(dirPath)
  end
end

-- dapatkan files list key.
-- dan mesukan ke table
local function getKeyList(data)
  local dirPath = File(activity.getLuaDir() .. "/data/key")
  local astable = luajava.astable(dirPath.listFiles())

  table.foreach(astable, function(index,content)
    local size = content.length()
    local formatSize = Formatter.formatFileSize(activity, size)

    local name = content.name:gsub(".key.zip", "")
    table.insert(data,{name = string.format("Key %d", name), filepath = content})
  end)
end

-- dapatkan files list tema.
-- dan mesukan ke table
local function getFileList(data)
  local dirPath = File(AppPath.Downloads)
  if not(dirPath.exists()) then dirPath.mkdirs() end

  local astable = luajava.astable(dirPath.listFiles())
  table.foreach(astable, function(index,content)
    if not(content.isDirectory) then

     elseif content.name:find("%.itz") then
      local size = content.length()

      local formatSize = Formatter.formatFileSize(activity, size)
      table.insert(data,{name = content.name, filepath = content, filesize = formatSize})
    end
  end)
end

-- adapter
local adapter = function(data, type)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      return position
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      local holder=LuaRecyclerHolder(loadlayout(item, views))
      holder.itemView.setTag(views)
      holder.itemView.onClick=function()
        local pos = holder.getAdapterPosition() + 1

        -- dismiss dialog dan buat ulang jika key random tidak perlu
        ThemeInstaller:dismiss()

        if not(key_random_table.keyrandom) then
          ThemeInstaller:dialog(2, "Pilih Key")
        end

        -- masukan yg di perlukan ke table
        if tonumber(type) == 1 then
          theme_data_table.themefile = data[pos].filepath
          theme_data_table.themename = data[pos].name

         elseif tonumber(type) == 2 then
          ThemeInstaller:dismiss()
          theme_data_table.key = data[pos].filepath
          theme_data_table.keyname = data[pos].name
          instaltheme()
        end

        if key_random_table.keyrandom then
          for k, _ in ipairs(key_random) do key_random[k] = nil end
          getKeyList(key_random)

          local random = math.random(#key_random)
          theme_data_table.key = key_random[random].filepath
          theme_data_table.keyname = key_random[random].name

          instaltheme()
        end

      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      position = position + 1
      local item = data[position]
      local views = holder.itemView.getTag()

      local title = item.name
      local subtitle = item.filesize

      if item==nil or views==nil then return end
      if title then
        views.title.text = item.name
      end

      if not(subtitle) then
        views.subtitle.textSize = 0
       else
        views.subtitle.textSize = 13
        views.subtitle.text = item.filesize
        views.title.textAppearance = uihelper.getAttr("textAppearanceBody2")
      end
    end,
  }))
end

-- main dialog
function ThemeInstaller:dialog(type, title)
  local ids = {}
  local data = {}
  local layout = {
    LinearLayout,
    orientation="vertical",
    layout_height = "wrap_content",
    layout_width = "match_parent",
    gravity = "center",
    {
      LinearLayout,
      layout_marginTop="9dp",
      orientation="vertical",
      layout_height = "wrap_content",
      layout_width = "match_parent",
      gravity = "center",
      {
        RecyclerView,
        id = "recycler",
        layout_height = "wrap_content",
        layout_width = "match_parent",
      }
    },
  }

  if tonumber(type)==1 then
    getFileList(data)
    table.sort(data, function(a, b)
      return a.name < b.name
    end)
   elseif tonumber(type)==2 then
    getKeyList(data)
    table.sort(data, function(a, b)
      local l = a.name:gsub("Key", "")
      local r = b.name:gsub("Key", "")
      return tonumber(l) < tonumber(r)
    end)
  end

  self.mdialog = MaterialAlertDialogBuilder(this, material_style_center)
  .setTitle(title or "Pilih Berkas")
  .setIcon(R.drawable.ic_folder_outline)
  .setView(loadlayout(layout, ids))
  .setPositiveButton("Batal", function() end)
  .create()

  self.mdialog.show()

  local manager = LinearLayoutManager(activity, 1, false)
  local adapter = adapter(data, type)
  ids.recycler.adapter=adapter
  ids.recycler.setLayoutManager(manager)

  return self
end

-- dismiss main dialog
function ThemeInstaller:dismiss()
  self.mdialog.dismiss()
  return self
end

-- loading dialog
function ThemeInstaller:createLoading()
  local layout = {
    LinearLayout,
    layout_width = "match_parent",
    layout_height = "wrap_content",
    {
      LinearProgressIndicator,
      layout_width = "match_parent",
      layout_height = "wrap_content",
      layout_gravity = "center",
      trackCornerRadius = "100dp",
      indeterminate = true,
      layout_margin = "18dp",
    },
  }

  self.ldialog = MaterialAlertDialogBuilder(this, material_style_center)
  .setTitle("Mohon Tunggu")
  .setIcon(R.drawable.ic_error_outline_24dp)
  .setView(loadlayout(layout))
  .setCancelable(false)
  .create()

  self.ldialog.show()
  return self
end

function ThemeInstaller:dismissLoading()
  self.ldialog.dismiss()
  return self
end
return ThemeInstaller