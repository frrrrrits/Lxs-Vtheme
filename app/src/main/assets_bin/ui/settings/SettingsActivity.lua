-- settings activity

require "import"
import "initapp"

import "util.system.Preferences"
import "util.PrefSettingsLayUtil"
import "util.widget.StyleButton"
import "util.ChromeTabs"

import "android.text.format.Formatter"

import "ui.settings.PrefSettingsItem"

local ids = {}
local ic_window_close = R.drawable.ic_window_close_24dp
local material_style_center = R.style.ThemeOverlay_Material3_MaterialAlertDialog_Centered

local layout = {
    CoordinatorLayout,
    id = "mainlay",
    layout_height = "match_parent",
    layout_width = "match_parent",
    fitsSystemWindows = "true",
    {
        AppBarLayout,
        id = "appbar",
        layout_height = "wrap_content",
        layout_width = "match_parent",
        fitsSystemWindows = "true",
        liftOnScroll = true,
        {
            MaterialToolbar,
            id = "toolbar",
            layout_height = "wrap_content",
            layout_width = "match_parent",
            applayout_scrollFlags = 0x15,
            navigationIcon = ic_window_close,
        }
    },
    {
        RecyclerView,
        id = "recycler",
        layout_height = "match_parent",
        layout_width = "match_parent",
        overScrollMode = 2,
        applayout_behavior = appbar_scrolling_behavior()
    }
}

function onCreate()
    activity.setContentView(loadlayout(layout, ids))
    activity.setSupportActionBar(ids.toolbar)
    activity.getSupportActionBar().setTitle("Pengaturan")
    
    ids.toolbar.setNavigationOnClickListener{
      onClick=function()
        newActivity("main")
        finishActivity()
      end
    }
        
    local manager = LinearLayoutManager(activity)
    ids.recycler.adapter = PrefSettingsLayUtil.adapter(PrefSettingsItem,onItemClick)
    ids.recycler.setLayoutManager(manager)
end

function onItemClick(view, views, key, data)
    if key == "theme_picker" then
        createThemeDialog().show()  
    elseif key == "server_picker" then
        createServerDialog(views).show()
    elseif key == "delete_cache" then
        deleteCovers(views)
    elseif key == "about" then
        createAboutDialog().show()
    end
end

function createAboutDialog()
    local text =
        "Versi: 1.0-alpha\nPengembang: @lxs7499\nThanks to: @AideLua - @AndroidIDE.\n\n@note: pm owner kalo ada bug"
    local disclaimer = "\n\nDisclaimer: Pengembang aplikasi ini tidak memiliki afiliasi dengan penyedia konten yang tersedia."
    local layout = {
        LinearLayout,
        layout_height = "wrap_content",
        layout_width = "match_parent",
        gravity = "center",
        {
            MaterialButton,
            text = "Telegram channel",
            id = "action_telegram",
            layout_margin = "6dp",
            icon = "@drawable/ic_telegram_24dp",
            layout_gravity = "center|right",
            onClick = function()
                openInBrowser("https://t.me/vivothemelx49")
            end
        }
    }

    return MaterialAlertDialogBuilder(this, material_style_center)
     .setTitle("Tentang")
     .setMessage(text..disclaimer)
     .setIcon(R.drawable.ic_error_outline_24dp)
     .setView(loadlayout(layout))
     .create()
end

function createServerDialog(views)
    local mode
    local selectedItem
    local server = Preferences.server(0)
    local valueGlobal = Preferences.values.appserver.global
    local valueCn = Preferences.values.appserver.cn
    local listOf = {"Server global", "Server china"}
    if server == valueGlobal then
        selectedItem = 0
    elseif server == valueCn then
        selectedItem = 1
    end
    return MaterialAlertDialogBuilder(this, material_style_center)
     .setTitle("Pilih server")
     .setIcon(R.drawable.ic_server_24dp)
     .setSingleChoiceItems(listOf, selectedItem,
        function(dialog, which)
            if which == 0 then
                mode = valueGlobal
            elseif which == 1 then
                mode = valueCn
            end
            dialog.dismiss()
            Preferences.server(1, mode)
            views.summary.text = tostring(mode)
        end
     ).create()
end


function createThemeDialog()
    local selectedItem
    local mode = { themeMode = 0, mode = 0}
    local themeMode = Preferences.themeMode(0)    
    local valueSystem = Preferences.values.apptheme.system
    local valueDark = Preferences.values.apptheme.dark
    local valueLight = Preferences.values.apptheme.light        
    local listOf = {"Ikuti system", "Mode gelap", "Mode Terang"}            
    if themeMode == valueSystem then
       selectedItem = 0
    elseif themeMode == valueDark then
       selectedItem = 1
    elseif themeMode == valueLight then
       selectedItem = 2
    end  
    return MaterialAlertDialogBuilder(this, material_style_center)
     .setTitle("Tema aplikasi")
     .setIcon(R.drawable.ic_palette_24dp)
     .setSingleChoiceItems(listOf,selectedItem,
        function(dialog, which)
            if which == 0 then
                mode.mode = -1
                mode.themeMode = Preferences.values.apptheme.system                
            elseif which == 1 then
                mode.mode = AppCompatDelegate.MODE_NIGHT_YES
                mode.themeMode = Preferences.values.apptheme.dark
            elseif which == 2 then
                mode.mode = AppCompatDelegate.MODE_NIGHT_NO
                mode.themeMode = Preferences.values.apptheme.light
            end
            dialog.dismiss()
            Preferences.themeMode(1, mode.themeMode)                              
            ActivityCompat.recreate(this or activity)
            AppCompatDelegate.setDefaultNightMode(mode.mode)
        end
     ).create()
end

function deleteCovers(ids)
    local cacheDir = File(activity.externalCacheDir, "cover_cache")    
    table.foreach(
        luajava.astable(cacheDir.listFiles()),
        function(index, content)
            if content.exists() then                
                content.delete()
                ids.summary.text = "Total 0 kb"
                MyToast.showToast("Cache gambar di hapus")
            end
        end
    )
end

function onKeyDown(keyCode,keyEvent)
    newActivity("main")
    finishActivity()
end