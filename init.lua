--- Check whether Neovim is running within VSCode
if vim.env.VSCODE then
  vim.g.vscode = true
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
