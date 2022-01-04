local Themes={}

local context=activity or service
local theme=_G.theme
local SDK_INT=Build.VERSION.SDK_INT

local function isSysNightMode()
  import "android.content.res.Configuration"
  return (context.getResources().getConfiguration().uiMode)==Configuration.UI_MODE_NIGHT_YES+1 
  and Preferences.values.apptheme.dark
end

Themes.isSysNightMode=isSysNightMode

function Themes.refreshThemeColor()
  local array = context.getTheme().obtainStyledAttributes({
    android.R.attr.textColorTertiary,
    android.R.attr.textColorPrimary,
    android.R.attr.colorPrimary,
    android.R.attr.colorPrimaryDark,
    android.R.attr.colorAccent,
    android.R.attr.navigationBarColor,
    android.R.attr.statusBarColor,
    android.R.attr.colorButtonNormal,
    android.R.attr.windowBackground,
    android.R.attr.textColorSecondary,
    R.attr.colorToolbar,
    R.attr.colorSurface,
    R.attr.colorOnSurface,
    R.attr.colorTertiary,
    R.attr.colorOnTertiary,
    R.attr.colorSecondary,
  })

  local colorList=theme.color
  colorList.textColorTertiary=array.getColor(0,0)
  colorList.textColorPrimary=array.getColor(1,0)
  colorList.colorPrimary=array.getColor(2,0)
  colorList.colorPrimaryDark=array.getColor(3,0)
  colorList.colorAccent=array.getColor(4,0)
  colorList.navigationBarColor=array.getColor(5,0)
  colorList.statusBarColor=array.getColor(6,0)
  colorList.colorButtonNormal=array.getColor(7,0)
  colorList.windowBackground=array.getColor(8,0)
  colorList.textColorSecondary=array.getColor(9,0)
  colorList.colorToolbar=array.getColor(10,0)
  colorList.colorSurface=array.getColor(11,0)
  colorList.colorOnSurface=array.getColor(12,0)
  colorList.colorTertiary=array.getColor(13,0)
  colorList.colorOnTertiary=array.getColor(14,0)
  colorList.colorSecondary=array.getColor(15,0)
  array.recycle()

  local numberList=theme.number
  local array = context.getTheme().obtainStyledAttributes({
    android.R.attr.selectableItemBackgroundBorderless,
    android.R.attr.selectableItemBackground,
    R.attr.actionBarTheme,
  })

  numberList.id.selectableItemBackgroundBorderless=array.getResourceId(0,0)
  numberList.id.selectableItemBackground=array.getResourceId(1,0)
  numberList.id.actionBarTheme=array.getResourceId(2,0)
  array.recycle()

  local booleanList=theme.boolean
  local array = context.getTheme().obtainStyledAttributes({
    R.bool.lightStatusBar,
    R.bool.lightNavigationBar,
  })

  booleanList.lightNavigationBar=array.getBoolean(0,false)
  booleanList.lightStatusBar=array.getBoolean(1,false)
  array.recycle()

  local array = context.getTheme().obtainStyledAttributes(numberList.id.actionBarTheme,{
    android.R.attr.textColorSecondary,
    R.attr.colorControlNormal,
  })

  local actionBarColorList=theme.color.ActionBar
  actionBarColorList.textColorSecondary=array.getColor(0,0)
  actionBarColorList.colorControlNormal=array.getColor(1,0)
  array.recycle()

  local array = context.getTheme().obtainStyledAttributes(numberList.id.actionBarTheme,{
    R.attr.elevation,
    R.attr.actionBarSize
  })
  numberList.actionBarElevation=array.getDimension(0,0)
  numberList.actionBarSize=array.getDimension(1,0)
  array.recycle()
  return colorList
end


function Themes.setStatusBarColor(color)
  theme.color.statusBarColor=color
  window.setStatusBarColor(color)
  return color
end

function Themes.setNavigationbarColor(color)
  theme.color.navigationBarColor=color
  window.setNavigationBarColor(color)
  return color
end


function Themes.getRippleDrawable(color,square)
  local rippleId
  if square then
    rippleId=theme.number.id.selectableItemBackground
   else
    rippleId=theme.number.id.selectableItemBackgroundBorderless
  end
  local drawable=context.getResources().getDrawable(rippleId)
  if color then
    if type(color)=="number" then
      drawable.setColor(ColorStateList({{}},{color}))
     else
      drawable.setColor(color)
    end
  end
  return drawable
end


function Themes.refreshUI()
  import "util.system.Preferences"
  
  local themeKey,appTheme

  appTheme="default"

  local systemUiVisibility=0
  if not(decorView) then
    decorView=activity.getDecorView()
  end

  local colorList=theme.color

  Themes.refreshThemeColor()

  if appTheme.color then
    for index,content in pairs(appTheme.color) do
      colorList[index]=content
    end
  end

  if isSysNightMode() then alpha = 232 else alpha = 212 end
  local colorSurface=MaterialColors.getColor(context,R.attr.colorSurface,Color.BLACK);
  local elevationOverlay=ElevationOverlayProvider(this).compositeOverlayIfNeeded(
     colorSurface, 9.0
  )
  
  theme.color.scrimColor = ColorUtils.setAlphaComponent(elevationOverlay, alpha)

  window.setStatusBarColor(theme.color.colorSurface)
  window.setNavigationBarColor(ColorUtils.setAlphaComponent(theme.color.colorSurface, alpha))
  
  if not(isSysNightMode()) then
    if SDK_INT >= 23 then
      systemUiVisibility=systemUiVisibility| View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR|
      View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
    end
  end

  decorView.setSystemUiVisibility(systemUiVisibility)
  WindowCompat.setDecorFitsSystemWindows(window, false)  
end

return Themes