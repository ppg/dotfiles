local M = {}

local function echo_diagnostic()
  local line_diags = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #line_diags == 0 then
    vim.api.nvim_command('echo ""')
    return
  end

  -- Pick only the FIRST diagnostic to avoid cluttering the bottom line
  local d = line_diags[1]
  local severity_map = { [1] = "E", [2] = "W", [3] = "I", [4] = "H" }
  local sev = severity_map[d.severity] or "?"
  local msg = string.format("[%s][%s] %s", d.source or "LSP", sev, d.message:gsub("\n", " "))

  local max_width = vim.v.echospace - 10
  if #msg > max_width then msg = msg:sub(1, max_width) .. "..." end
  vim.api.nvim_echo({{msg, "Normal"}}, false, {})
end

function M.setup()
  vim.api.nvim_create_autocmd("CursorMoved", { callback = echo_diagnostic })

  vim.keymap.set('n', '<leader>e', function()
    -- 1. Open the float (doesn't matter if it's already open)
    -- Using nil for the first arg uses the current buffer
    vim.diagnostic.open_float(nil, {
        focusable = true,
        border = "rounded",
        source = "always"
      })

    -- 2. Move cursor into the floating window
    -- This is the most reliable way to ensure Esc works
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>w', true, false, true), 'n', false)

    -- 3. Set a temporary buffer-local Esc key inside the float
    vim.schedule(function()
      local current_win = vim.api.nvim_get_current_win()
      local config = vim.api.nvim_win_get_config(current_win)
      if config.relative ~= "" then -- We are indeed in a float
        vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = true, silent = true })
      end
    end)
  end)


  vim.diagnostic.config({
    virtual_text = false,
    float = {
      focusable = false, -- This prevents the cursor from entering the window
      --close_events = { "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" },
      close_events = {},
      header = "",
    },
  })
end

return M
