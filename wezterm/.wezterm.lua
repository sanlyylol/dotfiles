local wezterm = require 'wezterm'

local default_padding = {
  left = 12,
  right = 12,
  top = 12,
  bottom = 6,
}

wezterm.on("update-status", function(window, _)
  local tab = window:active_tab()
  local panes = tab:panes()
  local alt = false

  for _, pane in ipairs(panes) do
    if pane:is_alt_screen_active() then
      alt = true
      break
    end
  end

  if alt then
    window:set_config_overrides({
      window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
    })
  else
    window:set_config_overrides({
      window_padding = default_padding,
    })
  end
end)

return {
  term = "xterm-256color",
  window_background_image = "~/Pictures/wallpapers/walls/minimal-gradient-4.png",
  enable_wayland = true,
  front_end = "OpenGL",
  window_background_opacity = 1.0,
  text_background_opacity = 0.92,
  adjust_window_size_when_changing_font_size = false,
  window_decorations = "NONE",
  window_padding = default_padding,
  initial_cols = 100,
  initial_rows = 30,
  color_scheme = "Catppuccin Mocha",
  colors = { background = 'rgba(0, 0, 0, 0)' },
  font = wezterm.font_with_fallback({ "FiraCode Nerd Font Propo Ret", "Noto Color Emoji" }),
  font_size = 10,
  line_height = 1.1,
  enable_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = false,
  use_fancy_tab_bar = false,
  tab_max_width = 25,
  keys = {
    {key="F11", action="ToggleFullScreen"},
  },
  warn_about_missing_glyphs = false,
  animation_fps = 60,
  cursor_blink_rate = 800,
  scrollback_lines = 2000,
  enable_kitty_graphics = true,
}

