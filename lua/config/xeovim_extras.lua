-- [[ Extra plugin modules to enable for XeoVim ]]
--
-- There is no need to manually enable extra plugin modules for three
-- categories: picker, file explorer, and code completion engine. They are
-- intended to be automatically enabled by XeoVim, but you are allowed to choose
-- a specific plugin for each category via the following variables in your
-- `lua/config/options.lua` file:
--
-- * `vim.g.xeovim_picker` for picker
-- * `vim.g.xeovim_explorer` for file explorer
-- * `vim.g.xeovim_cmp` for code completion engine
--
-- See lua/xeovim/config/options.lua in the XeoVim plugin for all valid values
-- for these variables.
--
-- If not specfied, the following extras are loaded as default:
--
-- * `xeovim.plugins.extras.editor.snacks_picker` as picker
-- * `xeovim.plugins.extras.editor.snacks_explorer` as file explorer
-- * `xeovim.plugins.extras.coding.blink` as code completion engine
--
-- NOTE: Never manually enable `xeovim.plugins.extras.vscode`, as it is
-- automatically enabled when Neovim is running within VSCode.

return {
  --- Debugger integration (enable it if you need to debug code within Neovim)
  --"xeovim.plugins.extras.dap.core",

  --- Editor enhancement
  "xeovim.plugins.extras.editor.dial", -- incremental file renaming
  --"xeovim.plugins.extras.editor.diffview", -- enhanced git diff review
  "xeovim.plugins.extras.editor.inc-rename", -- incremental file renaming
  "xeovim.plugins.extras.editor.yanky", -- better yank/paste

  --- Coding enhancement
  --"xeovim.plugins.extras.formatting.prettier", -- general code formatters for a lot of filetypes

  --- Additional utilities
  "xeovim.plugins.extras.util.dot", -- treesitter, lsp, linter for some dotfiles
  --"xeovim.plugins.extras.util.im-select", -- input method auto-switch (useful for CJK users)
  "xeovim.plugins.extras.util.mini-hipatterns", -- highlight hex color code
  --"xeovim.plugins.extras.util.mkdnflow", -- a Markdown-based note-taking and workflow assistant

  --- The image.nvim plugin supports multiple terminal image protocols
  --- including:
  --- * Kitty Grahpics Protocol: best performance, the default protocol to use
  ---   as long as your terminal supports.
  --- * Ueberzug: much slower than Kitty Graphics Protocol, requiring the
  ---   external `ueberzugpp` utility. Uou must set `use_ueberzug` to `true`
  ---   in the `image` table below to use this protocol.
  ---   dependencies except for ImageMagick, the fallback protocol to use if
  ---   the above two are not supported.
  ---
  --- You need to use a terminal emulator that supports at least one protocol
  --- mentioned in the enabled extra.
  --"xeovim.plugins.extras.util.image", -- view image in Neovim (supporting more terminal image protocols)

  --- Enable language-specific extras as needed
  "xeovim.plugins.extras.lang.git",
  "xeovim.plugins.extras.lang.json",
  "xeovim.plugins.extras.lang.markdown",
  "xeovim.plugins.extras.lang.toml",
  "xeovim.plugins.extras.lang.yaml",

  --- Enable battery (power-saving) mode
  --"xeovim.plugins.extras.battery-mode",
}
