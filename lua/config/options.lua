-- [[ User options and global variables for XeoVim ]]
--
-- Below are some global variables that you are likely to set. See
-- XeoVim/lua/xeovim/config/option.lua for more preset options and global
-- variables.

--- Set LSP logging level, valid options are "TRACE", "DEBUG", "INFO", "WARN"
--- (preset), "ERROR" and "OFF".
--- Set it to "ERROR" to prevent the log file from blowing too quickly.
---
vim.g.xeovim_lsp_log_level = "ERROR"

--- Set the maximum size (in Megebytes) for the LSP log rotation, which archives
--- a log file once it exceeds the size limit. (preset to 2)
---
--vim.g.xeovim_lsp_log_max_size = 2

-- Choose XeoVim default extra plugins ========================================

--- Choose a picker plugin, valid options:
--- * "auto": leave it to XeoVim to decide (preset)
--- * "snacks": use `xeovim.plugins.extras.editor.snacks_picker` (default)
--- * "blink": use `xeovim.plugins.extras.editor.blink`
--- * "telescope": use `xeovim.plugins.extras.editor.telescope`
---
--vim.g.xeovim_picker = "snacks"

--- Choose a code completion engine plugin, valid options:
--- * "auto": leave it to XeoVim to decide (preset)
--- * "blink": use `xeovim.plugins.extras.coding.blink` (default)
--- * "nvim-cmp": use `xeovim.plugins.extras.coding.nvim-cmp`
---
--vim.g.xeovim_cmp = "blink"

--- Choose a file explorer plugin, valid options:
--- * "auto": leave it to XeoVim to decide (preset)
--- * "snacks": use `xeovim.plugins.extras.editor.snacks_explorer` (default)
--- * "neo-tree": use `xeovim.plugins.extras.editor.neo-tree`
---
-- vim.g.xeovim_explorer = "snacks"

-- INFO: Other required XeoVim extra plugins can be specified in the
-- lua/config/xeovim_extras.lua file.

-- Define color schemes for dark and light backgrounds ========================

--vim.g.xeovim_colorscheme_dark = "github_dark_dimmed"
--vim.g.xeovim_colorscheme_light = "modus_operandi"

-- Github mirror for mason.nvim ===============================================

--- A boolean that indicates whether to use Github mirror site for manson.nvim
--- to download resources. (preset to false)
---
--vim.g.xeovim_mason_github_use_mirror = true

--- The Github download URL template for mason.nvim, requiring
--- vim.g.xeovim_mason_github_mirror to be true to take effective. (no preset)
--- See `h: mason-download-mirror-github`
---
--vim.g.xeovim_mason_github_download_url_tpl = "https://gh-proxy.org/https://github.com/%s/releases/download/%s/%s"

-- LSP severs =================================================================

--- Choose the LSP server for Python, valid options are "basepyright",
--- "pyright", and "ty" (preset)
---
--vim.g.xeovim_python_lsp = "ty"

--- Choose the LSP server for TypeScript, valid options are "vtsls" and "tsgo"
--- (preset)
---
--vim.g.xeovim_ts_lsp = "tsgo"

--- Misc. =====================================================================

--- Whether to auto-format a file on save. (preset to false)
---
--vim.g.autoformat = true

--- Enable/disable the animation feature in the Snacks plugin. (preset to false)
---
--vim.g.snacks_animate = true

--- Markdown preview browser (optional)
--- XeoVim takes this setting as highest priority, and falls back to the
--- $BROWSER environment variable, and system default.
--vim.g.mkdp_browser = "firefox"
