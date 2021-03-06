local HIDPI = os.getenv("HIDPI") == "1"

local theme                                     = {}

theme.dir                                       = os.getenv("HOME") .. "/.config/awesome"
theme.wallpaper                                 = theme.dir .. "/wallpaper.png"

theme.screen_padding                            = 0
theme.useless_gap                               = 0
theme.border_width                              = 2
theme.font                                      = "PragmataPro Bold 9"
theme.fg_normal                                 = "#586e75"
theme.fg_focus                                  = "#232730"
theme.fg_urgent                                 = "#cc9393"
theme.bg_normal                                 = "#00000000"
theme.bg_widget                                 = "#bf616a88"
theme.fg_widget                                 = "#232730"
theme.bg_focus                                  = "#ffffff00"
theme.bg_urgent                                 = "#1a1a1a"
theme.border_normal                             = "#000000"
theme.border_focus                              = "#444444"
theme.border_marked                             = "#cc9393"
theme.tasklist_bg_normal                        = "#00000000"
theme.tasklist_fg_focus                         = "#ffffff"
theme.tasklist_bg_focus                         = "#ffffff09"
theme.taglist_bg_focus                          = "#ffffff09"
theme.taglist_fg_focus                          = "#ffffff"
theme.bg_systray                                = "#343d46"

if HIDPI then
  theme.useless_gap                             = 0
  theme.font                                    = "PragmataPro Bold 8"
end

theme.menu_height                               = 60
theme.menu_width                                = 140
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"

theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tilegaps                           = theme.dir .. "/icons/tilegaps.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"

theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true

return theme
