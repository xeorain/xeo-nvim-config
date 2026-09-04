local M = {}

function M.decrypt_xeovim_token(token, passphrase)
  local cmd
  if jit.os == "Linux" or jit.os == "OSX" then
    if vim.fn.executable("/usr/bin/openssl") ~= 1 then
      vim.api.nvim_echo({
        { "\n'openssl' not found to decrypt XeoVim token\n", "ErrorMsg" },
        { "Press any key to quit..." },
      }, true, {})
      os.exit(1)
    end
    cmd = "printf %s "
      .. vim.fn.shellescape(token)
      .. "| openssl enc -d -aes-128-cbc -pbkdf2 -a -A -pass "
      .. vim.fn.shellescape("pass:" .. passphrase)
  elseif jit.os == "Windows" then
    vim.api.nvim_echo({
      { "\nWindows support for XeoVim comming soon\n", "ErrorMsg" },
      { "Press any key to quit..." },
    }, true, {})
    os.exit(1)
  else
    vim.api.nvim_echo({
      { "\n" .. jit.os .. " not supported by XeoVim\n", "ErrorMsg" },
      { "Press any key to quit..." },
    }, true, {})
    os.exit(1)
  end
  local res = vim.fn.system(cmd)
  return vim.v.shell_error == 0 and res or nil
end

return M
