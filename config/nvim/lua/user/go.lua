local M = {}

function M.setup()
  -- Initialize the ray-x/go.nvim plugin
  require('go').setup({
    lsp_cfg = true, -- Tell go.nvim to manage gopls setup
    lsp_gofumpt = true,
    lsp_on_attach = function(client, bufnr)
      -- This ensures gopls settings are applied correctly
    end,
  })

  -- Add the gopls specific config (go.nvim will merge this)
  vim.lsp.config('gopls', {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  })

  vim.lsp.enable('gopls')

  -- Use go.nvim's optimized format on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
      require('go.format').goimports()
    end,
  })
end

return M
