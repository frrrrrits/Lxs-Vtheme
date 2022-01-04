-- created by lxs7499
-- BottomSheet show download page

import "util.ChromeTabs"
import "util.enviroment.AppPath"
import "util.system.Preferences"

import "data.ParseDatas"
import "ui.adapter.ItemHolder"
import "android.util.DisplayMetrics"

import "com.downloader.PRDownloader"
import "com.downloader.Priority"
import "com.downloader.Status"

import "com.google.android.material.bottomsheet.BottomSheetBehavior"
import "com.google.android.material.bottomsheet.BottomSheetDialog"

local ids={}
local res={}
local data={}

local downloadId = -1
local BottomSheetDownload={}

local dividerColor=ContextCompat.getColor(this,R.color.divider_default)
local actionbarSize=theme.number.actionBarSize
local textColorPrimary=theme.color.textColorPrimary
local textColorSecondary=theme.color.textColorSecondary
local colorOnSurface=theme.color.colorOnSurface
local borderless=theme.number.id.selectableItemBackgroundBorderless

local flg=View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR

local serverPrefs = Preferences.server(0)
local valueGlobal = Preferences.values.appserver.global
local valueCn = Preferences.values.appserver.cn

-- this useless sometimes
local function nilOrBlank(s)
  local s = tostring(s)
  if s ~= nil or s ~="" then
    return s
   else
    return "Tidak di ketahui"
  end
end

local JSON = require "json"

-- layout
BottomSheetDownload.layout= {
  LinearLayout,
  id="mainlay",
  layout_height="match_parent",
  layout_width="match_parent",
  orientation="vertical",
  {
    FrameLayout,
    layout_height=actionbarSize,
    layout_width="match_parent",
    {
      CardView,
      id="card",
      layout_width="40dp",
      layout_height="4dp",
      layout_margin="9dp",
      elevation="0dp",
      radius="200dp",
      layout_gravity="center|top",
    },
    {
      LinearLayout,
      layout_height="match_parent",
      layout_width="match_parent",
      gravity="center",
      {
        TextView,
        id="title",
        text="Download",
        textSize="16sp",
        maxLines="1",
        ellipsize="end",
        layout_margin="8dp",
        layout_marginLeft="12dp",
        layout_width="match_parent",
        layout_weight="1",
        textColor=textColorPrimary,
      };
      {
        ImageButton,
        id="actionClose",
        layout_margin="6dp",
        src="@drawable/ic_window_close_24dp",
        colorFilter=colorOnSurface,
        backgroundResource=borderless
      },
    },
    {
      View,
      layout_width="match_parent",
      layout_height="1dp",
      backgroundColor=dividerColor,
      layout_gravity="bottom",
    },
  },
  {
    ScrollView,
    id="scrollView",
    layout_height="match_parent",
    layout_width="match_parent",
    overScrollMode=2,
    VerticalScrollBarEnabled=false,
    {
      LinearLayout,
      orientation="vertical",
      layout_height="wrap_content",
      layout_width="match_parent",
      layout_gravity="top",
      paddingBottom="8dp",
      {
        LinearLayout,
        orientation="vertical",
        layout_marginTop="10dp",
        layout_height="match_parent",
        layout_width="match_parent",
        {
          RecyclerView,
          id="recycler",
          layout_height="wrap_content",
          layout_width="match_parent",
          overScrollMode=2,
        },
      },
      {
        LinearLayout,
        layout_height="wrap_content",
        layout_width="match_parent",
        gravity="center|left",
        layout_marginTop="8dp",
        {
          TextView,
          id="titleHeaderSize",
          text="Ukuran",
          layout_marginLeft="12dp",
          textColor=textColorPrimary,
          layout_weight="1",
        },
        {
          TextView,
          id="titleBodySize",
          layout_marginRight="12dp",
          textAppearance="textAppearanceBody1",
          textColor=textColorPrimary,
        },
      },
      {
        LinearLayout,
        layout_height="wrap_content",
        layout_width="match_parent",
        gravity="center|left",
        layout_marginTop="6dp",
        layout_marginLeft="12dp",
        layout_marginRight="12dp",
        orientation="vertical",
        {
          TextView,
          id="titleAuthor",
          layout_height="wrap_content",
          layout_width="match_parent",
          textColor=textColorSecondary,
        },
        {
          TextView,
          id="titleDescription",
          layout_marginTop="3dp",
          layout_height="wrap_content",
          layout_width="match_parent",
          textColor=textColorSecondary,
        },
      },
      {
        View,
        layout_width="match_parent",
        layout_height="1dp",
        backgroundColor=dividerColor,
        layout_margin="15dp",
      },
      {
        LinearLayout,
        layout_height="wrap_content",
        layout_width="match_parent",
        {
          CircularProgressIndicator,
          max="100",
          progress="0",
          id="actionsProgress",
          visibility=View.GONE,
          layout_marginLeft="14dp",
          layout_marginRight="14dp",
          layout_width="120dp",
          layout_height="wrap_content",
          layout_gravity="center",
          trackCornerRadius="100dp",
          indicatorSize="34dp",
        },
        {
          MaterialButton,
          text="unduh",
          id="actionsDownload",
          layout_marginLeft="12dp",
          layout_marginRight="12dp",
          layout_gravity="center",
          layout_height="wrap_content",
          layout_width="match_parent",
        },
      },
      {
        TextView,
        id = "titletips",        
        text = "tersimpan di /storage/emulated/0/download/LxsVTheme",
        layout_height = "wrap_content",
        layout_width = "wrap_content",
        layout_gravity = "center",
        layout_marginTop = "8dp",
        textColor = textColorPrimary,
        textAppearance = "textAppearanceCaption",
        visibility = View.GONE,
      },
    }
  }
}

-- item layout preview
BottomSheetDownload.item={
  LinearLayoutCompat,
  orientation="vertical",
  layout_height="wrap_content",
  layout_width="wrap_content",
  gravity="center",
  {
    FrameLayout,
    id="card",
    background="@drawable/library_item_selector",
    layout_height="wrap_content",
    layout_width="wrap_content",
    layout_gravity="center",
    padding="10dp",
    {
      CircularProgressIndicator,
      layout_width="wrap_content",
      layout_height="wrap_content",
      layout_gravity="center",
      trackCornerRadius="100dp",
      indicatorSize="34dp",
      indeterminate=true,
    },
    {
      ShapeableImageView,
      id="cover",
      layout_height="340dp",
      layout_width="wrap_content",
      scaleType="fitXY",
      layout_gravity="center",
    }
  }
}

-- byte converter
local function byteConvert(size)
  local total
  if size<=1023 then
    total = string.format('%.2f',size) .. " K"
   elseif size>= 1024 && size <= (1024*1024)-1 then
    total = string.format('%.2f',size/1024) .. " KB"
   elseif size>= 1024*1024 && size <= (1024*1024*1024)-1 then
    total = string.format('%.2f',(size/1024)/1024) .. " MB"
   elseif size>= 1024*1024*1024 then
    total = string.format('%.2f',size/(1024*1024*1024)) .. " GB"
  end
  return tostring(total)
end

-- download
local function downloadFile(url, fileName)
  local dirPath = File(AppPath.Downloads)
  local status = PRDownloader.getStatus(downloadId)

  -- create dir if not exist
  if not(dirPath.exists()) then
    dirPath.mkdirs()
  end

  ids.actionsDownload.text = "Menunggu"

  -- check for status
  if Status.RUNNING == status then
    PRDownloader.pause(downloadId)
    return
  end

  if Status.PAUSED == status then
    PRDownloader.resume(downloadId)
    return
  end

  -- start download
  downloadId = PRDownloader.download(url, tostring(dirPath), fileName).build()
  .setPriority(Priority.MEDIUM)
  .setOnStartOrResumeListener {
    onStartOrResume = function()
      -- apply progressBar when download start
      ids.actionsProgress.visibility = View.VISIBLE
    end
  }
  .setOnPauseListener {
    onPause = function()
      ids.actionsDownload.text = "Lanjutkan"
      ids.actionsProgress.setProgressCompat(ids.actionsProgress.getProgress(), true)
    end
  }
  .setOnCancelListener {
    onCancel = function()
      ids.actionsDownload.text = "Unduh"
      ids.actionsProgress.visibility=View.GONE
      print("Unduhan di batalkan")
    end
  }
  .setOnProgressListener {
    onProgress = function(progress)
      local progressPercent = progress.currentBytes * 100 / progress.totalBytes
      ids.actionsProgress.setProgressCompat(progressPercent, true)
      ids.actionsDownload.text = ids.actionsProgress.getProgress() .. "%"
    end
  }
  .start {
    onDownloadComplete = function()
      -- remove progressBar when download success
      ids.titletips.visibility = View.VISIBLE
      ids.actionsProgress.visibility = View.GONE
      ids.actionsDownload.text = "Terunduh"
      ids.actionsDownload.enabled = false
    end,
    onError=function(error)
    end
  }

end

-- get data request
function BottomSheetDownload:parseData(packageId, resId)
  local options = ParseDatas.getDetailUrl(packageId, resId)
  LuaHttp.request(options, function(error, code, body)
    if error or code ~= 200 then return end
    -- clear all data in tables
    for k, _ in ipairs(data) do data[k] = nil end
    for k, _ in ipairs(res) do res[k] = nil end

    local json = JSON.decode(body)
    local arr = json.detail

    -- important for download stuff
    table.insert(res, arr)

    local prevwUri = arr.previewUris
    local rootUrl = arr.urlRoot

    uihelper.runOnUiThread(activity, function()
      -- apply detail summary
      ids.titleBodySize.text = byteConvert(arr.fileSize)
      ids.titleDescription.text = nilOrBlank(arr.description)
      ids.titleAuthor.text = string.format("Pengarang: %s", arr.author)

      -- insert preview image to table
      for i = 1, #prevwUri do
        data[#data+1] = {preview = rootUrl .. prevwUri[i]}
      end
      -- attach to adapter
      self.adapter.notifyDataSetChanged()
    end)
  end)
  return self
end

-- adapter for recyclerview
local function Adapters(data)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function() return #data end,
    getItemViewType=function(position) return position end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      local holder=LuaRecyclerHolder(loadlayout(BottomSheetDownload.item, views))
      holder.itemView.setTag(views)
      holder.itemView.onClick=function()
        local pos=holder.getAdapterPosition()+1
        newActivity("ui/PreviewActivity",{
          data[pos].preview
        })
      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      position=position + 1
      local item=data[position]
      local views=holder.itemView.getTag()
      if item==nil or views==nil then return end
      local cover=item.preview
      if cover then
        ItemHolder.loadImage(views.cover, cover, DiskCacheStrategy.RESOURCE)
      end
    end,
  }))
end

-- title text
function BottomSheetDownload:setTitle(text)
  ids.title.text=text
  return self
end

function BottomSheetDownload:build()
  -- BottomSheetDialog
  local viewParent=loadlayout(BottomSheetDownload.layout,ids)
  local bottomSheetDialog=BottomSheetDialog(this,R.style.ThemeOverlay_BottomSheetDialog)
  bottomSheetDialog.setContentView(viewParent)

  local metrics=DisplayMetrics()
  activity.getWindowManager().getDefaultDisplay().getMetrics(metrics)

  local bottomSheet=bottomSheetDialog.findViewById(R.id.design_bottom_sheet)
  local behavior=BottomSheetBehavior.from(bottomSheet)
  local layoutParams=bottomSheet.layoutParams

  behavior.setBottomSheetCallback(BottomSheetBehavior.BottomSheetCallback {
    onStateChanged=function(bottomSheet, newState)
      if newState == BottomSheetBehavior.STATE_HIDDEN
        for k, _ in ipairs(data) do data[k] = nil end
        self.adapter = nil
        LuaHttp.cancelAll()
        bottomSheetDialog.dismiss()
      end
    end
  })

  layoutParams.height=WindowManager.LayoutParams.MATCH_PARENT
  bottomSheet.layoutParams=layoutParams

  behavior.peekHeight=metrics.heightPixels/2*1.86

  if not(Themes.isSysNightMode()) then
    viewParent.parent.setSystemUiVisibility(flg)
  end

  bottomSheetDialog.window.setNavigationBarColor(0)
  ViewCompat.setNestedScrollingEnabled(ids.scrollView,true)

  -- applying detail textAppearance, why like this, cuz if put in layout sometimes its not applying
  ids.title.textAppearance=uihelper.getAttr("textAppearanceHeadline6")
  ids.titleHeaderSize.textAppearance=uihelper.getAttr("textAppearanceHeadline5")
  ids.titleBodySize.textAppearance=uihelper.getAttr("textAppearanceSubtitle1")
  ids.titleBodySize.textAppearance=uihelper.getAttr("textAppearanceBody1")

  -- change background of cardView
  ids.card.getBackground().setTint(dividerColor)

  -- close button
  ids.actionClose.onClick=function()
    bottomSheetDialog.dismiss()
  end

  -- download button
  ids.actionsDownload.onClick=function()
    local url = tostring(res[1].dlurl)
    local fileName = tostring(res[1].name):gsub("%s","-")..".itz"
    if not(url == nil or url == "") then
      if serverPrefs == valueGlobal then
        url = url:gsub("model=.-&","countrycode=ID&")
       elseif serverPrefs == valueCn then
        url = url
      end
      downloadFile(url, fileName)
    end
  end

  ids.actionsDownload.onLongClick=function()
    local status = PRDownloader.getStatus(downloadId)
    -- make dialog for cancel button
    local dialog = MaterialAlertDialogBuilder(this, R.style.ThemeOverlay_Material3_MaterialAlertDialog_Centered)
    .setTitle("Ingin membatalkan unduhan?")
    .setIcon(R.drawable.ic_error_outline_24dp)
    .setPositiveButton("Ya",function()
      PRDownloader.cancel(downloadId)
    end)
    .setNeutralButton("Tidak",function() end)
    .create()
    -- check if its running and show the dialog
    if Status.RUNNING == status or Status.PAUSED == status then
      dialog.show()
    end
  end

  -- create recyclerview & adapter
  local manager = LinearLayoutManager(activity, LinearLayoutManager.HORIZONTAL, false)
  self.adapter = Adapters(data)
  ids.recycler.adapter=self.adapter
  ids.recycler.setLayoutManager(manager)

  -- show bottomsheet
  bottomSheetDialog.show()
  return self
end

return BottomSheetDownload