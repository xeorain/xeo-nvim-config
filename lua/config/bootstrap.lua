-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "Press any key to quit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:append(lazypath)

local M = {}

-- The directory where your local XeoVim repository resides, used by "local" and
-- "dev" modes to locate the XeoVim local repository.
local dev_dir = vim.fn.expand("~/Projects/personal")

local xeovim_token

local function get_xeovim_token()
  -- stylua: ignore
  local xeovim_token_enc = "U2FsdGVkX18UTnWBFZw6X/epT1W+QqEfi6BhcxVSUIw5oSKWDm4NeIDByPBSLdIf/nUdy1NzMEABnSD+kSy2w6zXZxHcLLfKDS5jZVudQbZvGxsKf9aUJsJpfblMtwY+UTEeF8rpvOUvWzSJcbJRZA=="

  local cache = vim.fn.stdpath("config") .. "/.xeovim.token"
  xeovim_token = vim.fn.filereadable(cache) == 1 and vim.fn.readfile(cache)[1] or nil

  if xeovim_token and not vim.startswith(xeovim_token, "github_pat_") then
    xeovim_token = nil
  end

  if not xeovim_token then
    local ok, passphrase = pcall(vim.fn.inputsecret, "Enter passphrase for XeoVim token: ")
    if not ok then
      vim.cmd("qa!")
    end

    xeovim_token = require("util").decrypt_xeovim_token(xeovim_token_enc, passphrase)
    if not xeovim_token then
      vim.api.nvim_echo({
        { "\nInvalid passphrase for XeoVim token\n", "ErrorMsg" },
        { "Press any key to quit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
    vim.fn.writefile({ xeovim_token }, cache)
    vim.fn.setfperm(cache, "rw-------")
  end
end

function M.load(opts)
  -- Prepare installation mode
  local xeovim_install_mode = opts.xeovim_install_mode or "remote"

  local xeovim_spec_ver = xeovim_install_mode ~= "dev" and "*" or false
  local xeovim_spec_dev = xeovim_install_mode == "dev"
  local xeovim_spec_shorthand, xeovim_spec_url

  if xeovim_install_mode == "remote" then
    get_xeovim_token()
    xeovim_spec_shorthand = "xeorain/XeoVim"
    xeovim_spec_url = "https://xeorain:" .. xeovim_token .. "@github.com/xeorain/XeoVim.git"
  else
    xeovim_spec_shorthand = "XeoVim"
    xeovim_spec_url = "file://" .. dev_dir .. "/XeoVim"
  end

  -- Construct settings for lazy.nvim
  opts = vim.tbl_deep_extend("force", {
    spec = {
      {
        xeovim_spec_shorthand,
        url = xeovim_spec_url,
        version = xeovim_spec_ver,
        dev = xeovim_spec_dev,
        lazy = false,
        cond = true,
        priority = 10000,
        import = "xeovim.plugins",
        -- Override core settings for XeoVim
        opts = {
          --- A string of a color scheme name or a function that loads a color
          --- scheme to override the XeoVim default color scheme.
          ---@type string|fun()|nil
          --colorscheme = "tokyonight",
        },
      },
    },
    defaults = {
      -- Set to `true` load all plugins lazily by default.
      lazy = false,
      -- Set to `*` to install the latest *stable* version of a plugin that
      -- supports semver. It's recommended to leave version=false for now since
      -- a lot of plugins that supprt semver have outdated stable releases,
      -- which may be incompatible with your Neovim installation.
      version = false, -- always use the latest git commit of a plugin
    },
    dev = xeovim_install_mode == "dev" and {
      path = dev_dir,
      patterns = { "XeoVim" },
      fallback = jit.os == "Windows",
    } or nil,
    checker = {
      enabled = false, -- check for plugin updates periodically
      notify = false, -- notify on update
    },
    performance = {
      rtp = {
        -- Disable some built-in plugins to speed up startup
        disable_plugins = {
          "gzip",
          --"matchit",
          --"matchparen",
          --"netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }, opts and opts.lazy or {})

  require("lazy").setup(opts)
end

return M
