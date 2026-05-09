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

-----------------------------------------------------------------------------
-- GOLANG CONFIGURATION
-------------------------------------------------------------------------------
-- Automatic formatting and import cleanup on every Go file save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimports()
  end,
})
