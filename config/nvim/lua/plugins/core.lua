return {
  { "maxmx03/solarized.nvim", config = function() vim.cmd.colorscheme("solarized") end },
  -- Standard Git integration
  { "tpope/vim-fugitive" },
  -- Inline git change markers (Gutter)
  { "lewis6991/gitsigns.nvim", config = true },
  -- Better highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Ensure you are on the new main branch
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "go", "lua", "vim", "markdown" },
      highlight = { enable = true },
    },
    config = function(_, opts)
      -- The new main branch uses this simplified entry point
      require("nvim-treesitter").setup(opts)
    end,
  }
}
