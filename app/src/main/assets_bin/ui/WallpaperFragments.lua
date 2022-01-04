-- fonts fragments

require "import"
import "initapp"
import "ui.adapter.WallpaperAdapter"
import "data.ParseDatas"

local function newInstance()
  local layout = {
    CoordinatorLayout,
    id="mainlay",
    layout_height="match_parent",
    layout_width="match_parent",
    {
      SwipeRefreshLayout,
      id="swiperefresh",
      layout_width="match_parent",
      {
        AutofitRecyclerView,
        id="recycler",
        layout_width="match_parent",
        layout_height="match_parent",
        overScrollMode=2,
      }
    }
  }
  local emptyView = EmptyView()
  local params = {page=0, query=0}
      
  local ids = {empty=emptyView}
  local data = {}
  
  local fragment = LuaFragment.newInstance()
  wallpaperAdapter = WallpaperAdapter(data,params,fragment,ids)

  local function setupRecycler()
    local manager = GridLayoutManager(this,2)
    ids.recycler.adapter=wallpaperAdapter
    ids.recycler.setLayoutManager(manager)
    ids.recycler.columnWidth=uihelper.dp2int(140)
    ids.recycler.setHasFixedSize(true)
    ids.swiperefresh.enabled=true
  end

  local function resetData()
    params.page = 0
    params.limit = 0
    for k, _ in ipairs(data) do
      data[k] = nil
    end
  end

  function doWallpaperFragment(query)
    resetData()
    setupRecycler()
    ids.empty:hide()
        
    params.query = query
    ParseDatas.getData(data, 9, params, wallpaperAdapter, fragment, ids, true)
  end

  fragment.setCreator(LuaFragment.FragmentCreator{
    onCreateView = function(inflater, container, savedInstanceState)
      return loadlayout(layout,ids)
    end,
    onViewCreated = function(view, savedInstanceState)
      ThemedSwipeRefresh()
      .init(ids.swiperefresh)
      .distanceToTrigger()

      ids.empty:intoView(ids.mainlay)
      :label("Klik pencarian untuk memulai")
      :show()

      ids.swiperefresh.enabled=false
      ids.swiperefresh.setOnRefreshListener{
        onRefresh=function()
           ids.swiperefresh.setRefreshing(false)
        end
      }
      
    end,
    onDestroy=function()
      manager=nil
      wallpaperAdapter=nil
      LuaHttp.cancelAll()
    end
  })

  return fragment
end

return {
  newInstance = newInstance
}