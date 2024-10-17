-- Function to check for the existence of Chart.yaml in parent directories
local function is_helm_template_file(filepath)
  local function file_exists(name)
    local f = io.open(name, "r")
    if f then f:close() end
    return f ~= nil
  end

  local function find_chart_yaml(path)
    local current_path = path
    while current_path ~= "/" do
      if file_exists(current_path .. "/Chart.yaml") then
        return true
      end
      current_path = current_path:match("(.*/)[^/]+/?$")
    end
    return false
  end

  return find_chart_yaml(filepath:match("(.*/)[^/]+/?$"))
end

-- Autocommand to check for Helm template files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local filepath = vim.fn.expand("%:p")
    if is_helm_template_file(filepath) then
      vim.bo.filetype = "helm"  -- Set the filetype to 'helm' or any other appropriate type
    end
  end
})

