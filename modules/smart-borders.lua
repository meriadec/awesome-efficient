local gears = require("gears")
local cairo = require("lgi").cairo
local awful = require("awful")
local wibox = require("wibox")

local HIDPI = os.getenv("HIDPI") == "1"

local smartBorders = {}

local GUTTER = 10
local WEIGHT = 1
local STRING_OFFSET = 2
local ARROW_WEIGHT = 5
local ARROW_WIDTH = 50
local SMART_GAP = 0
local COLOR = gears.color("#2b303b")

if HIDPI then
  GUTTER = 20
  WEIGHT = 0
  ARROW_WEIGHT = 6
  ARROW_WIDTH = 80
  SMART_GAP = 5
end

function smartBorders.set(c, firstRender)
  if c.floating == true then
    hideBorders(c)
  else
    createFragment(c, "top", firstRender)
    createFragment(c, "left", firstRender)
    createFragment(c, "right", firstRender)
    createFragment(c, "bottom", firstRender)
  end
end

function hideBorders(c)
  awful.titlebar(c, { size = 0, position = "top", bg_normal = "transparent", bg_focus = "transparent" }) : setup { layout = wibox.layout.align.horizontal }
  awful.titlebar(c, { size = 0, position = "left", bg_normal = "transparent", bg_focus = "transparent" }) : setup { layout = wibox.layout.align.horizontal }
  awful.titlebar(c, { size = 0, position = "right", bg_normal = "transparent", bg_focus = "transparent" }) : setup { layout = wibox.layout.align.horizontal }
  awful.titlebar(c, { size = 0, position = "bottom", bg_normal = "transparent", bg_focus = "transparent" }) : setup { layout = wibox.layout.align.horizontal }
end

function createFragment(c, position, firstRender)

  local SPACE = GUTTER + WEIGHT
  local G = GUTTER
  local W = c.width
  local H = c.height

  -- used to center line on corners
  -- local OFFSET = ARROW_WEIGHT / 2 - WEIGHT / 2
  local OFFSET = STRING_OFFSET

  local IMG_W = W + 2 * SPACE
  local IMG_H = H + 2 * SPACE

  local img = cairo.ImageSurface.create(cairo.Format.ARGB32, IMG_W, IMG_H)
  local ctx  = cairo.Context(img)

  ctx:set_source(COLOR)

  if position == "top" then
    ctx:rectangle(0, OFFSET, W + SPACE * 2, WEIGHT)
    ctx:rectangle(SMART_GAP, SMART_GAP, ARROW_WEIGHT, ARROW_WIDTH)
    ctx:rectangle(0, 0, WEIGHT, ARROW_WIDTH)
    ctx:rectangle(SMART_GAP, SMART_GAP, ARROW_WIDTH, ARROW_WEIGHT)
    if firstRender == true then
      ctx:rectangle(W + SPACE * 2 - ARROW_WEIGHT - SMART_GAP, SMART_GAP, ARROW_WEIGHT, ARROW_WIDTH)
      ctx:rectangle(W + SPACE * 2 - WEIGHT, 0, WEIGHT, ARROW_WIDTH)
      ctx:rectangle(W - ARROW_WIDTH + SPACE * 2 - SMART_GAP, SMART_GAP, ARROW_WIDTH, ARROW_WEIGHT)
    else
      ctx:rectangle(W - ARROW_WEIGHT - SMART_GAP, SMART_GAP, ARROW_WEIGHT, ARROW_WIDTH)
      ctx:rectangle(W - WEIGHT, 0, WEIGHT, ARROW_WIDTH)
      ctx:rectangle(W - ARROW_WIDTH - SMART_GAP, SMART_GAP, ARROW_WIDTH, ARROW_WEIGHT)
    end
  elseif position == "bottom" then
    ctx:rectangle(0, SPACE - WEIGHT - OFFSET, W + SPACE * 2, WEIGHT)
    ctx:rectangle(0, 0, WEIGHT, SPACE)
    ctx:rectangle(W - WEIGHT, 0, WEIGHT, SPACE)
    ctx:rectangle(SMART_GAP, 0, ARROW_WEIGHT, SPACE - SMART_GAP)
    ctx:rectangle(SMART_GAP, SPACE - SMART_GAP - ARROW_WEIGHT, ARROW_WIDTH, ARROW_WEIGHT)
    ctx:rectangle(W - ARROW_WIDTH, SPACE - ARROW_WEIGHT - SMART_GAP, ARROW_WIDTH - SMART_GAP, ARROW_WEIGHT)
    ctx:rectangle(W - ARROW_WEIGHT - SMART_GAP, 0, ARROW_WEIGHT, SPACE - SMART_GAP)
  elseif position == "left" then
    ctx:rectangle(OFFSET, 0, WEIGHT, H)
    ctx:rectangle(SMART_GAP, 0, ARROW_WEIGHT, ARROW_WIDTH - SPACE)
    ctx:rectangle(SMART_GAP, H - ARROW_WIDTH - SPACE, ARROW_WEIGHT, ARROW_WIDTH - SPACE)
  elseif position == "right" then
    ctx:rectangle(GUTTER - OFFSET, 0, WEIGHT, H)
    ctx:rectangle(SPACE - ARROW_WEIGHT - SMART_GAP, 0, ARROW_WEIGHT, ARROW_WIDTH - SPACE)
    ctx:rectangle(SPACE - ARROW_WEIGHT - SMART_GAP, H - ARROW_WIDTH - SPACE, ARROW_WEIGHT, ARROW_WIDTH - SPACE)
  end

  ctx:fill()

  awful.titlebar(c, {
    size = GUTTER + WEIGHT,
    position = position,
    bg_normal = "transparent",
    bg_focus = "transparent",
    bgimage_focus = img,
  }) : setup { layout = wibox.layout.align.horizontal, }

end

return smartBorders
