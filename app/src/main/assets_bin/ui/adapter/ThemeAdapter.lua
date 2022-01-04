import "ui.adapter.ItemHolder"
import "util.widget.BottomSheetDownload"
import "com.google.android.material.shape.ShapeAppearanceModel"

return function(data,params,fragment,ids)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      return position
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      local holder=LuaRecyclerHolder(loadlayout(ItemHolder.itemTheme, views))
      local coverHeight=ids.recycler.getMeasuredWidth() / manager.spanCount / 3 * 5
      local params=RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,coverHeight)
      views.card.layoutParams=params
      holder.itemView.setTag(views)
      holder.itemView.onClick=function()
        local pos=holder.getAdapterPosition() + 1
        BottomSheetDownload:build()
        :parseData(data[pos].packageId, data[pos].resId)
        :setTitle(data[pos].name)
      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      position=position + 1
      local item=data[position]
      local views=holder.itemView.getTag()
      if item==nil or views==nil then return end
      local title=item.name
      local cover=item.thumbPath
      if title then
        views.title.text=title
      end
      if cover then
        ItemHolder.loadImage(views.cover, cover)
      end
      if position == #data and not(params.limit == 1) then
        ParseDatas.getData(data, 1, params, themeAdapter, fragment, ids)
      end
    end,
  }))
end