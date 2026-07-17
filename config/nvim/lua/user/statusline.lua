local M = {}

-- Private helper for counts
local function get_count(severity)
  local count = #vim.diagnostic.get(0, { severity = severity })
  return count > 0 and tostring(count) or "0"
end

-- Exported for the statusline string
function M.get_err()  return get_count(vim.diagnostic.severity.ERROR) end
function M.get_warn() return get_count(vim.diagnostic.severity.WARN) end
function M.get_hint() return get_count(vim.diagnostic.severity.HINT) end

function M.setup()
  local sections = {
    "[%n] ", "%<%.99f ", "%h%w%m%r%y ", "- %{FugitiveStatusline()} ", "- [",
    "%#DiagnosticError#%{v:lua.require('user.statusline').get_err()}E%*", " ",
    "%#DiagnosticWarn#%{v:lua.require('user.statusline').get_warn()}W%*", " ",
    "%#DiagnosticHint#%{v:lua.require('user.statusline').get_hint()}H%*",
    "]", "%=", "[%05b:0x%04B] ", "%-16( %l,%c %)", "%L/%P"
  }
  vim.opt.statusline = table.concat(sections)
end

return M
