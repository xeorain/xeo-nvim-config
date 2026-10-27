--- Check whether Neovim is running within VSCode
if vim.env.VSCODE then
  vim.g.vscode = true
end

--- Neovide configuration (tuned for 60Hz display)
if vim.g.neovide then
  vim.o.guifont = "Aporetic Sans Mono,Symbols Nerd Font Mono:h9"

  vim.g.neovide_no_idle = false                       -- Allow idle while not typing
  vim.g.neovide_refresh_rate = 60                     -- Match 60Hz display
  vim.g.neovide_refresh_rate_idle = 5                 -- Drop framework redraw while not typing

  vim.g.neovide_cursor_animation_length = 0.05        -- Faster cursor movement
  vim.g.neovide_cursor_short_animation_length = 0.02  -- Time for 1-2 character jumps (typing)
  --vim.g.neovide_cursor_animate_in_insert_mode = false -- Disable cursor animation in Insert mode
  vim.g.neovide_cursor_animate_command_line = false   -- Disable cursor animation when entering/leaving command line
  vim.g.neovide_cursor_smooth_blink = false           -- Disable smooth cursor blinking
  vim.g.neovide_cursor_trail_size = 0.5               -- Keep cursor trail short to reduce visual afterimage
  vim.g.neovide_cursor_vfx_mode = ""                  -- Disable cursor particle effects
  vim.g.neovide_scroll_animation_length = 0.15        -- Faster scroll transition
  vim.g.neovide_scroll_animation_far_lines = 0        -- Disable animation for long-distance scrolls
  vim.g.neovide_position_animation_length = 0         -- Disable animation when windows change position
  vim.g.neovide_floating_shadow = false               -- Disable floating-window shadows
  vim.g.neovide_floating_corner_radius = 0.0          -- Use square floating-window corners
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_normal_opacity = 1.0
end

require("config.bootstrap").load({
  --- The installation mode for the XeoVim plugin, supporting:
  --- * "dev": Load XeoVim directly from the local project directory for
  ---   developoment purpose
  --- * "local": Clone XeoVim from a local repository into the lazy plugin
  ---   directory
  --- * "remote": Clone XeoVim from a remote repository (Github)
  ---
  ---@type "dev" | "local" | "remote"
  xeovim_install_mode = "remote"
  -- Use the `lazy` table to extend settings for lazy.nvim.
  -- See https://lazy.folke.io/configuration
  --lazy = {},
})
