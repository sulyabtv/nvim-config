-- Iterate over all Lua files in the themes directory and load them
local themes_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'themes')
for file_name, type in vim.fs.dir(themes_dir, { follow = true }) do
  if (type == 'file' or type == 'link') and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('themes.' .. module)
  end
end

-- schedule a colorscheme load to overcome half-loaded theme headache
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(function() vim.cmd('colorscheme ' .. vim.g.colors_name) end)
  end,
})
