-- created by @lxs7499
-- activity preview cover

require "import"
import "initapp"
import "ui.adapter.ItemHolder"

local ids = {}
local view = {}
local data = ...
local ic_window_close = R.drawable.ic_window_close_24dp
local colorOnSurface = theme.color.colorOnSurface
local borderless = theme.number.id.selectableItemBackgroundBorderless

local function PageViewFix()
  return luajava.override(luajava.bindClass("android.widget.PageView"),{
    onInterceptTouchEvent=function(event)
      return false
    end,  
    onTouchEvent=function(event)
      return false
    end
  })
end

local layout = {
    FrameLayout,
    id="mainlay",
    layout_height = "match_parent",
    layout_width = "match_parent",
      {
        CircularProgressIndicator,
        layout_width = "wrap_content",
        layout_height = "wrap_content",
        layout_gravity = "center",
        trackCornerRadius = "100dp",
        indicatorSize = "34dp",
        indeterminate = true
    },
    {
        PhotoView,
        id = "cover",
        layout_height = "match_parent",
        layout_width = "match_parent"
    },
  --[[  {
        PageViewFix,
        id = "pageview",
        overScrollMode = 2,
        layout_width = "match_parent",
        layout_height = "match_parent"
    },]]
    {
        ImageButton,
        id = "actionclose",        
        src = "@drawable/ic_window_close_24dp",
        colorFilter = colorOnSurface,
        backgroundResource = borderless,
        layout_margin = "6dp",
        layout_marginTop = "35dp"
    }
}


local item = {
    FrameLayout,
    layout_height = "match_parent",
    layout_width = "match_parent",
    {
        CircularProgressIndicator,
        layout_width = "wrap_content",
        layout_height = "wrap_content",
        layout_gravity = "center",
        trackCornerRadius = "100dp",
        indicatorSize = "34dp",
        indeterminate = true
    },
    {
        PhotoView,
        id = "cover",
        layout_height = "match_parent",
        layout_width = "match_parent"
    }
}

function onCreate()
    activity.setContentView(loadlayout(layout, ids))

    -- get data
    --[[table.foreach(
        luajava.astable(data),
        function(index, content)
            table.insert(view, loadlayout(item, ids))
            ItemHolder.loadImage(ids.cover, content.preview, DiskCacheStrategy.RESOURCE, true)            
        end
    )

    -- set for adapter
    local adapter = ArrayPageAdapter(View(view))
    ids.pageview.setAdapter(adapter)      ]]  
    
    ItemHolder.loadImage(ids.cover, data, DiskCacheStrategy.RESOURCE, true)

    -- closebutton
    ids.actionclose.onClick = function()
        finishActivity()
    end

    -- make ui transparant
    window.setNavigationBarColor(0)
    window.setStatusBarColor(0)
end

function onKeyDown(keyCode, keyEvent)
    finishActivity()
end
