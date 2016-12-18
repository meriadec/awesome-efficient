--[[
                sombra theme
--]]

theme                               = {}

themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/sombra"
theme.wallpaper                     = themes_dir .. "/ocean-3.jpg"

theme.gray                          = "#657b83"
theme.base01                        = "#586e75"
theme.transparent                   = "#00000000"

theme.darker                        = "#232730"
theme.S_base03                      = "#002b36"
theme.S_base02                      = "#073642"
theme.S_base01                      = "#586e75"
theme.S_base00                      = "#657b83"
theme.S_base0                       = "#839496"
theme.S_base1                       = "#93a1a1"
theme.S_base2                       = "#eee8d5"
theme.S_base3                       = "#fdf6e3"
theme.S_yellow                      = "#b58900"
theme.S_orange                      = "#cb4b16"
theme.S_red                         = "#dc322f"
theme.S_magenta                     = "#d33682"
theme.S_violet                      = "#6c71c4"
theme.S_blue                        = "#268bd2"
theme.S_cyan                        = "#2aa198"
theme.S_green                       = "#859900"

theme.M_red = "#BF616A"

theme.font                          = "Fira Code 7"
theme.useless_gap_width             = 0

theme.fg_normal                     = theme.S_base01
theme.fg_focus                      = theme.M_red
theme.fg_urgent                     = "#CC9393"
theme.bg_normal                     = "#00000022"
--theme.bg_focus                      = "#272b35"
theme.bg_focus                      = "#00000000"
theme.bg_urgent                     = "#1A1A1A"
theme.border_width                  = 0
theme.border_normal                 = "#2b303b"
theme.border_focus                  = theme.M_red
theme.border_marked                 = "#CC9393"
theme.titlebar_bg_focus             = "#FFFFFF"
theme.titlebar_bg_normal            = "#FFFFFF"

theme.taglist_fg_focus              = theme.darker
theme.taglist_bg_focus              = theme.M_red
--theme.taglist_bg_focus              = "#4f5b66"
theme.taglist_bg_normal             = theme.base01

theme.tasklist_fg_focus             = theme.M_red
theme.tasklist_bg_normal            = theme.transparent
--theme.tasklist_bg_focus             = "#4f5b66"

theme.textbox_widget_margin_top     = 0
theme.notify_fg                     = theme.fg_normal
theme.notify_bg                     = theme.bg_normal
theme.notify_border                 = theme.border_focus
theme.awful_widget_height           = 14
theme.awful_widget_margin_top       = 2
theme.mouse_finder_color            = "#CC9393"
theme.menu_height                   = "16"
theme.menu_width                    = "140"

theme.menu_submenu_icon             = themes_dir .. "/icons/submenu.png"
theme.taglist_squares_sel           = themes_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel         = themes_dir .. "/icons/square_unsel.png"

theme.layout_tile                   = themes_dir .. "/icons/tile.png"
theme.layout_tilegaps               = themes_dir .. "/icons/tilegaps.png"
theme.layout_tileleft               = themes_dir .. "/icons/tileleft.png"
theme.layout_tilebottom             = themes_dir .. "/icons/tilebottom.png"
theme.layout_tiletop                = themes_dir .. "/icons/tiletop.png"
theme.layout_fairv                  = themes_dir .. "/icons/fairv.png"
theme.layout_fairh                  = themes_dir .. "/icons/fairh.png"
theme.layout_spiral                 = themes_dir .. "/icons/spiral.png"
theme.layout_dwindle                = themes_dir .. "/icons/dwindle.png"
theme.layout_max                    = themes_dir .. "/icons/max.png"
theme.layout_fullscreen             = themes_dir .. "/icons/fullscreen.png"
theme.layout_magnifier              = themes_dir .. "/icons/magnifier.png"
theme.layout_floating               = themes_dir .. "/icons/floating.png"

theme.arrl                          = themes_dir .. "/icons/arrl.png"
theme.arrl_dl                       = themes_dir .. "/icons/arrl_dl.png"
theme.arrl_ld                       = themes_dir .. "/icons/arrl_ld.png"

theme.widget_ac                     = themes_dir .. "/icons/ac.png"
theme.widget_battery                = themes_dir .. "/icons/battery.png"
theme.widget_battery_low            = themes_dir .. "/icons/battery_low.png"
theme.widget_battery_empty          = themes_dir .. "/icons/battery_empty.png"
theme.widget_cpu                    = themes_dir .. "/icons/cpu.png"
theme.widget_temp                   = themes_dir .. "/icons/temp.png"
theme.widget_net                    = themes_dir .. "/icons/net.png"
theme.widget_hdd                    = themes_dir .. "/icons/hdd.png"
theme.widget_music                  = themes_dir .. "/icons/note.png"
theme.widget_music_on               = themes_dir .. "/icons/note_on.png"
theme.widget_vol                    = themes_dir .. "/icons/vol.png"
theme.widget_vol_low                = themes_dir .. "/icons/vol_low.png"
theme.widget_vol_no                 = themes_dir .. "/icons/vol_no.png"
theme.widget_vol_mute               = themes_dir .. "/icons/vol_mute.png"
theme.widget_mail                   = themes_dir .. "/icons/mail.png"
theme.widget_mail_on                = themes_dir .. "/icons/mail_on.png"

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

return theme
