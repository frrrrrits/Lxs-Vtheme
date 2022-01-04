-- my theme fragments

require "import"
import "initapp"
import "util.ThemeInstaller"
import "util.system.Preferences"

local dividerColor = ContextCompat.getColor(this,R.color.divider_default)
local colorAccent = theme.color.colorAccent
local textColorPrimary = theme.color.textColorPrimary
local textColorSecondary = theme.color.textColorSecondary
local actionbarSize = theme.number.actionBarSize
local material_style_center = R.style.ThemeOverlay_Material3_MaterialAlertDialog_Centered

local textTutorial = [[Memasang tema secara automatis.

~ Cari <Theme> yang ingin di gunakan
dan pilih Key nya atau bisa mengunakan secara acak.
~ Setelah itu tunggu sampai selesai
Dan buka aplikasi iTheme.

~ key yang sudah di gunakan kemungkinan tidak bisa di gunakan lagi.
lebih tepatnya key yang sudah di pakai dan di pakai ulang, maka tema yang sebelumnya akan tertimpa (menghilang) dengan tema yang baru (tergantikan).

~ @lxs7499.]]

local function newInstance()
  local layout = {
    CoordinatorLayout,
    id="mainlay",
    layout_height = "match_parent",
    layout_width = "match_parent",
    {
      ScrollView,
      id="scrollview",
      layout_height = "match_parent",
      layout_width = "match_parent",
      {
        LinearLayout,
        padding="6dp",
        orientation = "vertical",
        layout_height = "wrap_content",
        layout_width = "match_parent",
        {
          LinearLayout,
          layout_marginTop = "9dp",          
          layout_height = "wrap_content",
          layout_width = "match_parent", 
          {
            MaterialCardView,
            id = "cardtheme",
            padding = "3dp",
            clickable = "true",
            focusable = "true",
            cardElevation = "0dp",
            strokeWidth = "1dp",
            layout_margin = "9dp",
            layout_height = "100dp",
            layout_width = "wrap_content",
            layout_weight = "1",
            strokeColor = dividerColor,
            {
              TextView,
              id = "texttheme",
              text = "Pasang Tema",
              layout_height = "wrap_content",
              layout_width = "wrap_content",
              layout_gravity = "center",
              textColor = textColorPrimary,
            }
          },
        },
        {
          SwitchCompat,
          id = "switchkey",
          text = "Gunakan key secara acak",
          layout_weight = "1",
          layout_width = "match_parent",
          layout_marginLeft = "9dp",
          layout_marginRight = "9dp",
        },
        {
          MaterialButton,
          id = "tutorialbtn",
          text = "Cara Menggunakan",
          layout_margin = "10dp",
          icon = "@drawable/ic_error_outline_24dp",
          layout_gravity = "center",
        },
      }
    }
  }

  local ids = {}
  local data = {}
  local fragment = LuaFragment.newInstance()
  local keyvalue = Preferences.keyrandom(0)

  local function reset_theme()
    for k, _ in ipairs(theme_data_table) do
      theme_data_table[k] = nil
    end
  end

  local function createTutorialDialog()
    local layout = {
      LinearLayout,
      layout_height = "wrap_content",
      layout_width = "match_parent",
      gravity = "center",
      {
        MaterialButtonButtonIcon,
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
    .setTitle("Cara Menggunakan")
    .setMessage(textTutorial)
    .setIcon(R.drawable.ic_error_outline_24dp)
    .setView(loadlayout(layout))
    .create()
  end


  fragment.setCreator(LuaFragment.FragmentCreator{
    onCreateView = function(inflater, container, savedInstanceState)
      return loadlayout(layout,ids)
    end,
    onViewCreated = function(view, savedInstanceState)
      ViewCompat.setNestedScrollingEnabled(ids.scrollview,true)
      ids.texttheme.textAppearance = uihelper.getAttr("textAppearanceBody1")

      ids.cardtheme.onClick = function()
        reset_theme()
        theme_data_table.themetype = 1
        ThemeInstaller:dialog(1, "Pilih Tema")
      end

      ids.tutorialbtn.onClick = function()
        createTutorialDialog().show()
      end

      if keyvalue then
        key_random_table.keyrandom = true
        ids.switchkey.setChecked(true)
      end

      ids.switchkey.setOnCheckedChangeListener {
        onCheckedChanged=function(view, checked)
          key_random_table.keyrandom = checked
          Preferences.keyrandom(1,checked)
        end
      }
    end,
    onDestroy=function()
    end
  })

  return fragment
end

return {
  newInstance = newInstance
}