local present, impatient = pcall(require, "impatient")

if present then
    impatient.enable_profile()
end

local core_modules = {
    "core.options",
    "core.autocmd",
    "core.keymaps",
}

if vim.fn.filereadable(vim.fn.stdpath "config" .. "/lua/plugins.lua") == 1 then
    local ok, err = pcall(require, "plugins")
    if not ok then
        vim.notify("Error loading plugins init.lua\n\n" .. err)
    end
end

for _, module in ipairs(core_modules) do
    local ok, err = pcall(require, module)
    if not ok then
        vim.notify("Error loading " .. module .. "\n\n" .. err)
    end
end
