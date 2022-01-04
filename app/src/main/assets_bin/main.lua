--- activity

require "import"
import "initapp"
import "util.system.Preferences"
import "util.NetworkUtils"
import "com.PRDownloader.*"

local ids = {}
local dataFragment = {
  icon = {},
  titles = {},
  fragments = {},
}
local lastExitTime = 0
local themeMode = Preferences.themeMode(0)
local mode = AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM

-- make view
local layout = {
  CoordinatorLayout,
  id="rootView",
  layout_height="match",
  layout_width="match",
  {
    AppBarLayout,
    id="appbar",
    layout_width="match",
    layout_height="wrap",
    fitsSystemWindows="true",
    elevation="0dp",
    {
      MaterialToolbar,
      id="toolbar",
      layout_height="wrap",
      layout_width="match",
    },
    {
      TabLayout,
      id="tabs",
      layout_height="wrap",
      layout_width="match",
      applayout_scrollFlags=0x15,
    },
  },
  {
    ViewPager,
    id="pager",
    layout_height="wrap",
    layout_width="match",
    applayout_behavior=appbar_scrolling_behavior(),
  },
}

-- get fragments
local themeFragment = require "ui.ThemeFragments"
local fontsFragment = require "ui.FontsFragments"
local wallpaperFragment = require "ui.WallpaperFragments"
local myThemeFragment = require "ui.MyThemeFragments"

-- insert fragments to table
table.insert(dataFragment.fragments, themeFragment.newInstance())
table.insert(dataFragment.titles, 'Tema')

table.insert(dataFragment.fragments, fontsFragment.newInstance())
table.insert(dataFragment.titles, 'Fonts')

table.insert(dataFragment.fragments, myThemeFragment.newInstance())
table.insert(dataFragment.titles, 'Home')

-- make adapter for viewpager
local adapter = LuaFragmentPageAdapter(activity.getSupportFragmentManager(),
LuaFragmentPageAdapter.AdapterCreator{
  getCount=function()
    return #dataFragment.fragments
  end,
  getItem=function(posiion)
    local position = posiion + 1
    ids.tabs.getTabAt(posiion)
    -- .setIcon(dataFragment.icon[position])
    return dataFragment.fragments[position]
  end,
  getPageTitle=function(position)
    local position = position + 1
    return dataFragment.titles[position]
  end
})

function onCreate(bundle)
  PRDownloader.initialize(activity.getApplicationContext())
  activity.setContentView(loadlayout(layout,ids))
  activity.setSupportActionBar(ids.toolbar)

  -- bind viewpager
  ids.pager.adapter = adapter
  ids.pager.setOffscreenPageLimit(#dataFragment.fragments)
  ids.pager.currentItem = 3
  ids.pager.saveEnabled = false

  -- bind tabs from viewpager-fragments
  ids.tabs.tabMode = TabLayout.MODE_FIXED
  ids.tabs.tabGravity = TabLayout.GRAVITY_FILL
  ids.tabs.setupWithViewPager(ids.pager)
  ids.tabs.setInlineLabel(true)
  ids.appbar.setLiftOnScroll(true)

  -- apply window insets
  Insetter.builder()
  .margin(WindowInsetsCompat.Type.navigationBars(),
  Side.create(true,false,false,true,true,false))
  .applyToView(ids.rootView)

  ViewCompat.setOnApplyWindowInsetsListener(ids.rootView,{
    onApplyWindowInsets=function(view, insets)
      if insets.getInsets(WindowInsetsCompat.Type.navigationBars()).bottom > 0 then
      end
      return insets
    end
  })

  ViewCompat.requestApplyInsets(ids.rootView)

  if themeMode == Preferences.values.apptheme.light
    mode = AppCompatDelegate.MODE_NIGHT_NO
   elseif themeMode == Preferences.values.apptheme.dark
    mode = AppCompatDelegate.MODE_NIGHT_YES
   elseif themeMode == Preferences.values.apptheme.system
    mode = AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM
  end

  AppCompatDelegate.setDefaultNightMode(mode)
end

function onCreateOptionsMenu(menu,inflater)
  activity.getMenuInflater().inflate(R.menu.main_menu, menu)

  local searchManager = activity.getSystemService(Context.SEARCH_SERVICE)
  local actionbar = activity.getSupportActionBar()
  local searchItem = menu.findItem(R.id.action_search)
  local searchView = searchItem.getActionView()

  searchView.setSearchableInfo(searchManager.getSearchableInfo(activity.getComponentName()))
  searchView.findViewById(R.id.search_plate)
  .backgroundColor = Color.TRANSPARENT

  searchView.queryHint = "Pencarian"
  searchView.setMaxWidth(android.R.attr.width)
  searchView.clearFocus()

  searchView.setOnQueryTextListener{
    onQueryTextSubmit=function(query)
      -- check network status
      local netStatus = NetworkUtils:getNetworkState()
      if netStatus == -1 then
        MyToast.showSnackBar("Saat ini perangkat tidak terhubung ke internet")
        return
      end

      -- apply subtitle for query
      actionbar.setSubtitle(string.format("Pencarian: %s", query))

      -- get current viewpager position
      local currentPage = ids.pager.currentItem
      local query = tostring(searchView.getQuery())

      if currentPage == 0 then -- theme
        doThemeFragment(query)
       elseif currentPage == 1 then -- fonts
        doFontsFragment(query)
       elseif currentPage == 2 then-- wallpp
        doWallpaperFragment(query)
      end

      if not(searchView.isIconified()) then
        searchView.setIconified(true)
      end
      searchItem.collapseActionView()
      return false
    end,
    onQueryTextChange=function(newText)
      return false
    end
  }
end

function onOptionsItemSelected(menuItem)
  local itemId = menuItem.itemId
  if itemId == R.id.action_settings then
    newActivity("ui/settings/SettingsActivity")
    finishActivity()
  end
end

function onKeyDown(KeyCode,event)
  if KeyCode == KeyEvent.KEYCODE_BACK then
    if lastExitTime < System.currentTimeMillis() - 2000 then
      MyToast.showToast("Tekan lagi untuk keluar")
      lastExitTime = System.currentTimeMillis()
      return true
    end
  end
end

function onDestroy()
  actionbar = nil
  adapter = nil
  LuaHttp.cancelAll()
  PRDownloader.cancelAll()
end