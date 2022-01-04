import "com.google.android.material.slider.Slider"

local PrefSettingsLayUtil={}

PrefSettingsLayUtil.TITLE=1
PrefSettingsLayUtil.ITEM=2
PrefSettingsLayUtil.ITEM_NOSUMMARY=3
PrefSettingsLayUtil.ITEM_SWITCH=4
PrefSettingsLayUtil.ITEM_SWITCH_NOSUMMARY=5
PrefSettingsLayUtil.ITEM_ITEMWITHSLIDER=6
PrefSettingsLayUtil.ITEM_AVATAR_NOSUMMARY=7
PrefSettingsLayUtil.ITEM_ONLYSUMMARY=8
PrefSettingsLayUtil.ITEM_DIVIDER=9
PrefSettingsLayUtil.ITEM_PREFHEADER=10
PrefSettingsLayUtil.ITEM_PREFMARGIN=11

local colorAccent=theme.color.colorAccent
local textColorPrimary=theme.color.textColorPrimary
local textColorSecondary=theme.color.textColorSecondary
local colorOnSurface=theme.color.colorOnSurface
local toolbarColor=theme.color.colorToolbar

local dividerColor=ContextCompat.getColor(this,R.color.divider_default)

local newPageIconLay={
  AppCompatImageView,
  id="rightIcon",
  layout_margin="16dp",
  layout_marginLeft=0,
  layout_width="24dp",
  layout_height="24dp",
  colorFilter=textColorSecondary,
}

local pref_header = {
  LinearLayout,
  gravity="center",  
  layout_width="match_parent",
  layout_height="wrap_content",   
  backgroundColor=toolbarColor,  
  {
    AppCompatImageView,
    id="icon",    
    layout_margin="18dp",
    layout_width="80dp",
    layout_height="80dp",
  },
}

local itemsLay={
  {
    LinearLayoutCompat,
    layout_width="match_parent",
    layout_height="40dp",
    gravity="bottom|left",
    focusable=false,
    {
      AppCompatTextView,
      id="title",
      AllCaps=true,
      textSize="12sp",
      textColor=colorAccent,
      layout_marginLeft="13dp",
      layout_marginRight="16dp",
      layout_marginTop="5dp",
      letterSpacing="0.1",
      --
    },
  },

  {
    LinearLayoutCompat,
    layout_width="match_parent",
    gravity="center",
    background="@drawable/list_item_selector_background",
    focusable=true,
    {
      AppCompatImageView,
      id="icon",
      layout_margin="13dp",
      layout_width="24dp",
      layout_height="24dp",
      colorFilter=colorAccent,
    },
    {
      LinearLayoutCompat,
      orientation="vertical",
      gravity="center",
      layout_weight=1,
      layout_margin="16dp",
      {
        AppCompatTextView,
        id="title",
        textSize="16sp",
        layout_width="match_parent",
        textColor=textColorPrimary,
      },
      {
        AppCompatTextView,
        textSize="14sp",
        id="summary",
        layout_width="match_parent",
      },
    },
  },

  {
    LinearLayoutCompat,
    layout_width="match_parent",
    gravity="center",
    background="@drawable/list_item_selector_background",
    focusable=true,
    {
      AppCompatImageView,
      id="icon",
      layout_margin="13dp",
      layout_width="24dp",
      layout_height="24dp",
      colorFilter=colorAccent,
    },
    {
      AppCompatTextView,
      id="title",
      textSize="16sp",
      textColor=textColorPrimary,
      layout_weight=1,
      layout_margin="16dp",
      layout_width="match_parent",
    },
  },

  {
    LinearLayoutCompat,
    gravity="center",
    layout_width="match_parent",
    focusable=true,
    --layout_height="72dp",
    {
      AppCompatImageView,
      id="icon",
      layout_margin="16dp",
      layout_marginLeft="16dp",
      layout_width="24dp",
      layout_height="24dp",
      colorFilter=colorAccent,
    },
    {
      LinearLayoutCompat,
      orientation="vertical",
      gravity="center",
      layout_weight=1,
      layout_margin="16dp",
      {
        AppCompatTextView,
        textSize="16sp",
        textColor=textColorPrimary,
        id="title",
        layout_width="match_parent",
      },
      {
        AppCompatTextView,
        layout_width="match_parent",
        textSize="14sp",
        id="summary",
      },
    },
    {
      SwitchCompat,
      focusable=false,
      clickable=false,
      layout_marginRight="16dp",
      id="status",
    },
  },

  {
    LinearLayoutCompat,
    gravity="center",
    layout_width="match_parent",
    focusable=true,
    {
      AppCompatImageView,
      id="icon",
      layout_margin="16dp",
      layout_width="24dp",
      layout_height="24dp",
      colorFilter=colorAccent,
    },
    {
      AppCompatTextView,
      id="title",
      textSize="16sp",
      layout_weight=1,
      layout_margin="16dp",
      textColor=textColorPrimary,
    },
    {
      SwitchCompat,
      id="status",
      focusable=false,
      clickable=false,
      layout_marginRight="16dp",
    },
  },

  {
    LinearLayoutCompat,
    layout_width="match_parent",
    gravity="center",
    focusable=true,
    {
      LinearLayoutCompat,
      orientation="vertical",
      gravity="center",
      layout_weight=1,
      layout_margin="13dp",
      {
        AppCompatTextView,
        id="title",
        textSize="16sp",
        layout_width="match_parent",
        textColor=textColorPrimary,
      },
      {
        AppCompatTextView,
        textSize="14sp",
        id="summary",
        layout_width="match_parent",
      },
      {
        Slider,
        id="slider",
        layout_height="wrap_content",
        layout_width="match_parent",
        layout_marginEnd="12dp",
        paddingTop="6dp",
        paddingBottom="6dp",
        valueFrom="0",
        valueTo="7",
        stepSize="1",
      },
    },
  },

  {
    LinearLayoutCompat,
    layout_width="match_parent",
    gravity="center",
    focusable=true,
    {
      MaterialCardView,
      layout_height="40dp",
      layout_width="40dp",
      layout_margin="16dp",
      radius="20dp",
      {
        CardView,
        layout_height="match_parent",
        layout_width="match_parent",
        radius="18dp",
        {
          AppCompatImageView,
          layout_height="match_parent",
          layout_width="match_parent",
          id="icon",
        },
      },
    },
    {
      AppCompatTextView,
      id="title",
      textSize="16sp",
      layout_weight=1,
      textColor=textColorPrimary,
      layout_margin="16dp",
      layout_marginLeft=0,
    },
  },

  {
    LinearLayoutCompat,
    gravity="center",
    layout_width="match_parent",
    focusable=false,
    {
      AppCompatTextView,
      layout_weight=1,
      layout_marginLeft="72dp",
      layout_margin="16dp",
      layout_width="match_parent",
      textSize="14sp",
      id="summary",
    },
  },

  {
    LinearLayoutCompat,
    gravity="center",
    layout_height="1.3dp",
    layout_width="match_parent",
    focusable=false,
    backgroundColor=dividerColor,
  },

  pref_header,

  {
    LinearLayoutCompat,
    gravity="center",
    layout_height="80dp",
    layout_width="match_parent",
    focusable=false,
  }
}

PrefSettingsLayUtil.itemsLay=itemsLay

function PrefSettingsLayUtil.adapter(data,onItemClick)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      return data[position+1][1]
    end,
    onCreateViewHolder=function(parent,viewType)
      local ids={}
      local view=loadlayout(itemsLay[viewType],ids)
      local holder=LuaRecyclerHolder(view)
      holder.itemView.setTag(ids)
      if viewType~=1 then
        holder.itemView.setFocusable(true)
        holder.itemView.onClick=function(view)
          local data=ids._data
          local key=data.key
          if not(onItemClick and onItemClick(view,ids,key,data)) then
            local statusView=ids.status
            if statusView then
              local checked=not(statusView.checked)
              statusView.setChecked(checked)
              if data.checked~=nil then
                data.checked=checked
               elseif data.key then
                activity.setSharedData(data.key,checked)
              end
            end
          end
        end
      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      local data=data[position+1]
      local tag=holder.itemView.getTag()
      tag._data=data
      local title=data.title
      local taxtAlCaps=data.taxtAlCaps
      local icon=data.icon
      local summary=data.summary
      local statusView=tag.status
      local rightIconView=tag.rightIcon
      local iconView=tag.icon
      if title then
        tag.title.text=title
      end
      if icon then
        if type(icon)=="number" then
          iconView.setImageResource(icon)
         else
          Glide.with(activity)
          .load(icon)
          .transition(DrawableTransitionOptions.withCrossFade())
          .into(iconView)
        end
      end
      if summary then
        tag.summary.text=summary
      end
      if icon then
        if type(icon)=="number" then
          iconView.setImageResource(icon)
        end
      end
    end,
  }))
end
return PrefSettingsLayUtil