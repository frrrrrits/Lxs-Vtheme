import "com.google.android.material.progressindicator.CircularProgressIndicator"

local itemHolder = {}

local cardColor
local textColorSecondary = theme.color.textColorSecondary
local textColorPrimary = theme.color.textColorPrimary
local dividerColor = ContextCompat.getColor(this, R.color.divider_default)

itemHolder.itemFonts = {
    LinearLayout,
    layout_height = "wrap_content",
    layout_width = "match_parent",
    {
        FrameLayout,
        id = "frame",
        layout_height = "wrap_content",
        layout_width = "match_parent",
        layout_margin = "5dp",
        padding = "3dp",
        background = "@drawable/library_item_selector",
        {
            MaterialCardView,
            id = "card",
            layout_height = "100dp",
            layout_width = "match_parent",
            elevation = "0dp",
            strokeWidth = "1dp",
            strokeColor = "#E1E2EC",
            cardBackgroundColor = "#F2F0F4",
            {
                ShapeableImageView,
                id = "cover",
                layout_height = "match_parent",
                layout_width = "match_parent",
                layout_gravity = "center",
                layout_margin = "3dp"
            }
        }
    }
}


itemHolder.itemWallpaper = {
    LinearLayout,
    layout_height = "wrap_content",
    layout_width = "match_parent",
    {
        FrameLayout,
        id = "frame",
        layout_height = "wrap_content",
        layout_width = "match_parent",
        layout_margin = "5dp",
        padding = "3dp",
        background = "@drawable/library_item_selector",
        {
            MaterialCardView,
            id = "card",
            layout_height = "280dp",
            layout_width = "match_parent",
            elevation = "0dp",
            strokeWidth = "1dp",
            strokeColor = dividerColor,
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
                ShapeableImageView,
                id = "cover",
                layout_height = "match_parent",
                layout_width = "match_parent",
                scaleType = "centerCrop"
            }
        }
    }
}


itemHolder.itemTheme = {
    LinearLayout,
    layout_height = "wrap_content",
    layout_width = "match_parent",
    {
        FrameLayout,
        id = "frame",
        layout_height = "wrap_content",
        layout_width = "match_parent",
        background = "@drawable/library_item_selector",
        layout_margin = "5dp",
        padding = "3dp",
        {
            RelativeLayout,
            layout_height = "wrap_content",
            layout_width = "match_parent",
            {
                FrameLayout,
                id = "card",
                layout_height = "320dp",
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
                    ShapeableImageView,
                    id = "cover",
                    layout_height = "match_parent",
                    layout_width = "match_parent",
                    scaleType = "centerCrop"
                }
            },
            {
                LinearLayout,
                layout_below = "card",
                layout_height = "wrap_content",
                layout_width = "match_parent",
                orientation = "vertical",
                layout_marginTop = "3dp",
                padding = "4dp",
                {
                    TextView,
                    id = "title",
                    ellipsize = "end",
                    maxLines = "2",
                    textSize = "16sp",
                    textColor = textColorPrimary,
                    textAppearance = "textAppearanceSubtitle2"
                }
            }
        }
    }
}

itemHolder.loadImage = function(views, url, disk, shapeable)
    local requestOptions = RequestOptions()
    .diskCacheStrategy(disk or DiskCacheStrategy.NONE)

    local factory = DrawableCrossFadeFactory.Builder()
    .setCrossFadeEnabled(true).build()

    Glide.with(this).load(url)
    .apply(requestOptions)
    .transition(DrawableTransitionOptions.withCrossFade(factory))
    .into(views)
    
    if shapeable then else
       views.setShapeAppearanceModel(
          views.getShapeAppearanceModel()
          .toBuilder()
          .setAllCornerSizes(theme.number.card_radius)
          .build()
       )
    end
end

return itemHolder
