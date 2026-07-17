-------------------------------------------------------------------------------
-- EDITOR SETTINGS & UI
-------------------------------------------------------------------------------
local opt = vim.opt

-- General UI settings
opt.number = true           -- Show line numbers
opt.ruler = true            -- Show cursor position in status line
opt.hidden = true           -- Enable background buffers (switch without saving)
opt.wrap = false            -- Don't wrap lines (replaces 'nowrap')
opt.list = true             -- Show invisible characters (tabs/trailing spaces)
opt.listchars = {           -- Custom symbols for 'list' mode
  tab = "  ",
  trail = ".",
  extends = ">",
  precedes = "<"
}

-- Indentation and tab settings
opt.tabstop = 2             -- Number of spaces a tab counts for
opt.shiftwidth = 2          -- Number of spaces for auto-indentation
opt.expandtab = true        -- Use spaces instead of actual tabs

-- Search behavior settings
opt.ignorecase = true       -- Ignore case in search patterns
opt.smartcase = true        -- ...unless the search contains a capital letter
opt.hlsearch = true         -- Highlight all matches of the last search
opt.incsearch = true        -- Show matches as you type

-- Coding assistance settings
opt.foldmethod = "indent"   -- Fold code blocks based on indentation levels
opt.foldlevel = 3           -- Start with most folds open
opt.background = "dark"     -- Set background to dark for colorschemes
opt.updatetime = 300        -- Faster completion/hover response (default is 4000ms)

-- Automatically reload files if they are changed outside Neovim (e.g., by Claude CLI)
opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-------------------------------------------------------------------------------
-- PLUGIN MANAGEMENT (Lazy.nvim Bootstrap)
-------------------------------------------------------------------------------
require("config.lazy")


-------------------------------------------------------------------------------
-- CUSTOM MODULES
-------------------------------------------------------------------------------
require('user.lsp_config').setup()
require('user.statusline').setup()

require('user.go').setup()

-------------------------------------------------------------------------------
---- GOLANG CONFIGURATION
---------------------------------------------------------------------------------
---- Automatic formatting and import cleanup on every Go file save
--vim.api.nvim_create_autocmd("BufWritePre", {
--  pattern = "*.go",
--  callback = function()
--    require('go.format').goimports()
--  end,
--})
--
---- gopls
---- Configure
--vim.lsp.config('gopls', {
--  settings = {
--    gopls = {
--      analyses = {
--        unusedparams = true,
--      },
--      staticcheck = true,
--    },
--  },
--})
---- Auto-start
--vim.lsp.enable('gopls')
--
--
------ ## Auto open error window
------vim.api.nvim_create_autocmd("CursorHold", {
------  callback = function()
------    vim.diagnostic.open_float(nil, { focusable = false })
------  end,
------})
------
-------- Note: You may need to lower your 'updatetime' for this to feel snappy
-------- (default is 4000ms/4s; 300ms is a common choice)
------vim.opt.updatetime = 300
----
------ Show diagnostic popup on a keypress
----vim.keymap.set('n', '<leader>e', function()
----  -- focus = true is the key here; it jumps your cursor into the window
----  local _, winid = vim.diagnostic.open_float(nil, {
----    focusable = true,
----    focus = true,
----    border = "rounded",
----    source = "always"
----  })
----
----  -- Optional: If you want Esc to close it immediately while inside
----  if winid then
----    vim.api.nvim_buf_set_keymap(vim.api.nvim_win_get_buf(winid), 'n', '<Esc>', '<cmd>close<CR>', {
----      noremap = true, silent = true
----    })
----  end
----end)
----vim.diagnostic.config({
----  float = {
----    border = "rounded",       -- Options: "none", "single", "double", "rounded", "solid", "shadow"
----    source = "always",        -- Shows "gopls" or "shellcheck" so you know what linter found it
----    header = "",              -- Removes the "Diagnostics:" header for a cleaner look
----    prefix = "",              -- Removes the prefix before each error
----    -- This ensures that if we are IN the float, Esc takes us back to the code
----    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
----  },
----})
----
------ Bonus: Use [d and ]d to jump between errors and open the float automatically
----vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev({ float = true }) end)
----vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next({ float = true }) end)
----
----
------ ## Show at the bottom like ALE
-------- Disables virtual text at ends of lines (like g:ale_virtualtext_cursor = 'disabled')
------vim.diagnostic.config({ virtual_text = false })
------
-------- Function to echo the diagnostic message for the current line
------local function echo_diagnostic()
------  local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
------  if #line_diagnostics == 0 then return end
------
------  -- Format the message similar to your ale_echo_msg_format
------  local d = line_diagnostics[1]
------  local severity = ({ [1]='E', [2]='W', [3]='I', [4]='H' })[d.severity]
------  local msg = string.format("[%s] %s [%s]", d.source or "LSP", d.message, severity)
------
------  vim.api.nvim_echo({{msg, "Normal"}}, false, {})
------end
------
-------- Update message when moving the cursor
------vim.api.nvim_create_autocmd("CursorMoved", {
------  callback = echo_diagnostic,
------})
----local function echo_diagnostic()
----  local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
----  if #line_diagnostics == 0 then
----    vim.api.nvim_command('echo ""')
----    return
----  end
----
----  local d = line_diagnostics[1]
----  local severity = ({ [1]='E', [2]='W', [3]='I', [4]='H' })[d.severity]
----
----  -- Include the tool source (e.g., [gopls])
----  local source = d.source or "LSP"
----  local msg = string.format("[%s][%s] %s", source, severity, d.message:gsub("\n", " "))
----
----  local max_width = vim.v.echospace - 10
----  if #msg > max_width then
----    msg = msg:sub(1, max_width) .. "..."
----  end
----
----  vim.api.nvim_echo({{msg, "Normal"}}, false, {})
----end
----vim.api.nvim_create_autocmd("CursorMoved", { callback = echo_diagnostic })
