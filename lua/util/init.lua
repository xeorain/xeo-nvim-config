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

--- Makes use of the internal terminal to create a pager with color support.
function M.colorize()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.statuscolumn = ""
  vim.wo.signcolumn = "no"
  vim.opt.listchars = { space = " " }

  local buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  -- Concatenate lines and send it to an internal terminal
  vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))

  vim.keymap.set("n", "q", "<Cmd>qa!<CR>", { silent = true, buffer = buf })
  vim.api.nvim_create_autocmd("TextChanged", { buffer = buf, command = "normal! G$" })
  vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
end

return M
