local M = {}

--- A PowerShel script implemention for token decryption utilizing the .NET
--- framework, which is intended to be used as a fallback on Windows 10/11 if
--- OpenSSL is not available.
---
---@param token string The encrypted token.
---@param passphrase string The decryption passphrase.
---@return string A full command to run the decryption script in `cmd.exe`.
local function ps_decrypt_xeovim_token(token, passphrase)
  local function psquote(s)
    return "'" .. s:gsub("'", "''") .. "'"
  end

  local ps_script = string.format(
    [[
      $ProgressPreference = 'SilentlyContinue'
      $WarningPreference = 'SilentlyContinue'
      $ErrorActionPreference = 'Stop'

      $token = %s
      $passphrase = %s
      $key = $null
      $plainBytes = $null

      try {
          $data = [Convert]::FromBase64String($token)

          if ($data.Length -lt 56 -or
              [Text.Encoding]::ASCII.GetString($data, 0, 4) -ne 'XVT1') {
              throw 'Invalid encrypted token format'
          }

          $iterations = [int](
              ([long]$data[4] * 16777216) +
              ([long]$data[5] * 65536) +
              ([long]$data[6] * 256) +
              [long]$data[7]
          )

          if ($iterations -ne 10000) {
              throw 'Unexpected iteration count'
          }

          $salt = New-Object byte[] 16
          $iv = New-Object byte[] 16
          [Array]::Copy($data, 8, $salt, 0, 16)
          [Array]::Copy($data, 24, $iv, 0, 16)

          $cipherLength = $data.Length - 40
          if ($cipherLength -le 0 -or ($cipherLength %% 16) -ne 0) {
              throw 'Invalid ciphertext length'
          }

          $cipher = New-Object byte[] $cipherLength
          [Array]::Copy($data, 40, $cipher, 0, $cipherLength)

          $sha256 = [Security.Cryptography.HashAlgorithmName]::SHA256
          $kdf = New-Object Security.Cryptography.Rfc2898DeriveBytes(
              $passphrase, $salt, $iterations, $sha256
          )

          try {
              $key = $kdf.GetBytes(16)
          }
          finally {
              $kdf.Dispose()
          }

          $aes = [Security.Cryptography.Aes]::Create()
          try {
              $aes.KeySize = 128
              $aes.Mode = [Security.Cryptography.CipherMode]::CBC
              $aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
              $aes.Key = $key
              $aes.IV = $iv

              $decryptor = $aes.CreateDecryptor()
              try {
                  $plainBytes = $decryptor.TransformFinalBlock(
                      $cipher, 0, $cipher.Length
                  )
              }
              finally {
                  $decryptor.Dispose()
              }
          }
          finally {
              $aes.Dispose()
          }

          $plain = [Text.Encoding]::UTF8.GetString($plainBytes)
          if ([string]::IsNullOrEmpty($plain)) {
              throw 'Decrypted token is empty'
          }

          [Console]::Out.Write($plain)
      }
      catch {
          [Console]::Error.WriteLine('Token decryption failed.')
          throw
      }
      finally {
          if ($key) {
              [Array]::Clear($key, 0, $key.Length)
          }
          if ($plainBytes) {
              [Array]::Clear($plainBytes, 0, $plainBytes.Length)
          }
      }
    ]],
    psquote(token),
    psquote(passphrase)
  )

  -- HACK: Encode the script as the raw PowerShell script doesn't work as
  -- expected in `vim.fn.system` call. PowerShell requires a base64 string of
  -- UTF-16LE encoded text as the encoded command.
  local safe_ps_script = vim.base64.encode(vim.iconv(ps_script, "utf-8", "utf-16le") or "")
  return "powershell -NoProfile -NonInteractive -OutputFormat Text -EncodedCommand " .. safe_ps_script .. " 2>nul"
end

function M.decrypt_xeovim_token(token, passphrase)
  local res
  local ostype = jit.os
  if ostype == "Linux" or ostype == "OSX" or ostype == "Windows" then
    if vim.fn.executable("openssl") ~= 1 then
      if ostype ~= "Windows" then
        vim.api.nvim_echo({
          { "\n'openssl' not found to decrypt XeoVim token\n", "ErrorMsg" },
          { "Press any key to quit..." },
        }, true, {})
        os.exit(1)
      else
        res = vim.fn.system(ps_decrypt_xeovim_token(token, passphrase))
      end
    else
      res = vim.fn.system(
        "openssl enc -d -aes-128-cbc -pbkdf2 -a -A -pass " .. vim.fn.shellescape("pass:" .. passphrase),
        token
      )
    end
  else
    vim.api.nvim_echo({
      { "\n" .. ostype .. " not supported by XeoVim\n", "ErrorMsg" },
      { "Press any key to quit..." },
    }, true, {})
    os.exit(1)
  end
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

  vim.b[buf].minianimate_disable = true

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

  vim.defer_fn(function()
    vim.b[buf].minianimate_disable = false
  end, 2000)
end

return M
