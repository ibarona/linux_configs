local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- General
config.term = "wezterm"
config.default_prog = {"/usr/bin/zsh", "-l"}
config.audible_bell = "Disabled"

-- Fonts configuration
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.font_size = 12.0
config.warn_about_missing_glyphs = false

-- Tabs configuration
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.show_new_tab_button_in_tab_bar = false

-- Window configuration

config.color_scheme = "Noctalia"
config.window_background_opacity = 0.85
config.adjust_window_size_when_changing_font_size = true
config.initial_rows = 24
config.initial_cols = 102

-- Cursor configuration

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500

-- Keyboard

config.use_ime = false
config.enable_kitty_keyboard = true

-- Keybindings

config.keys = {

       {
        key = 'f',mods = 'ALT',
        action = wezterm.action.ToggleFullScreen,
        },

       {
        key = 'RightArrow',mods = 'CTRL',
        action = wezterm.action.SplitHorizontal {  domain = 'CurrentPaneDomain'},
        },

       {
        key = 'DownArrow',mods = 'CTRL',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain'},
        }
        }

return config
