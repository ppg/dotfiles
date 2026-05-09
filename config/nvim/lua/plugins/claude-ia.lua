return {
  -- AI: Integration for the Claude Code CLI
  {
    "coder/claudecode.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claudecode").setup({
        terminal_position = "right", -- Opens the Claude CLI in a right-hand split
      })
    end,
    -- Simple keymap to toggle the Claude CLI split
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    },
  },
}
