local theme                                     = {}

theme.dir                                       = os.getenv("HOME") .. "/.config/awesome"
theme.wallpaper                                 = theme.dir .. "/wallpaper.jpg"

theme.useless_gap                               = 60
theme.border_width                              = 0

theme.font                                      = "PragmataPro 8"
theme.fg_normal                                 = "#586e75"
theme.fg_focus                                  = "#232730"
theme.fg_urgent                                 = "#cc9393"
theme.bg_normal                                 = "#2b303b"
theme.bg_widget                                 = "#bf616a88"
theme.fg_widget                                 = "#232730"
theme.bg_focus                                  = "#bf616a55"
theme.bg_urgent                                 = "#1a1a1a"
theme.border_normal                             = "#2b303b"
theme.border_focus                              = "#ffffff"
theme.border_marked                             = "#cc9393"
theme.tasklist_bg_normal                        = "#00000000"
theme.tasklist_fg_focus                         = "#bf616a"
theme.tasklist_bg_focus                         = "#bf616a11"
theme.bg_systray                                = "#343d46"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus

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
