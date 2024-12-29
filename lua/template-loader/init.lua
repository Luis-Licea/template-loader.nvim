---Initialize the plugin.
---@author Luis David Licea Torres
---@license GPL3

local joinpath = vim.fs.joinpath

local M = {}

---Load the given file into the current buffer.
---@param path string The path to the file to load.
local function load_file(path)
    if not path or #path == 0 then
        print('No path given.')
    elseif vim.fn.filereadable(path) == 1 then
        vim.fn.execute('0r ' .. path)
    elseif vim.fn.isdirectory(path) == 1 then
        print('Path is a directory: ' .. path)
    elseif path then
        print('File is not readable: ' .. path)
    end
end

---Load a template into the current buffer based on the file extension and the file name.
---@param template_folder string The folder in which to look for templates.
local function load_template_from_file_type(template_folder)
    -- Expand ~ symbol and environment variables.
    template_folder = vim.fn.expand(template_folder)

    -- The path to the skeleton file with the same file extension.
    -- Examples: skeleton.c, skeleton.html, skeleton.awk, etc.
    local skeleton_file = joinpath(template_folder, 'skeleton.' .. vim.fn.expand('%:e'))

    -- The path to the template to with the same file name and extension.
    local template_file = joinpath(template_folder, vim.fn.expand('%:t'))

    -- Load the template or the skeleton file if either file exists.
    for _, path in ipairs({ template_file, skeleton_file }) do
        if vim.fn.filereadable(path) == 1 then
            load_file(path)
        end
    end
end

local function folder_files(folder)
    local files = vim.fn.glob('`find ' .. vim.fn.fnameescape(folder) .. ' -type f`', true, true)
    files = vim.fn.filter(files, function(_, file)
        return vim.fn.filereadable(file) == 1
    end)
    local trailingSlashLength = #(string.match(folder, '/$') or '')
    files = vim.fn.map(files, function(_, file)
        return string.sub(file, #folder + trailingSlashLength)
    end)
    return files
end

local function select_template(template_folder)
    local templates = folder_files(template_folder)
    vim.ui.select(templates, { prompt = 'Select template to load into file:' }, function(choice)
        load_file(joinpath(template_folder, choice))
    end)
end

---@class SetupOptions
---@field auto_loading_pattern string A pattern or list of patterns such as `"*"` or `{ "*.html", "*.cpp", "Makefile" }`. Use `nil` to disable loading templates for new files. Default is `"*"`.
---@field template_folder string The folder in which to look for templates. Defaults to `~/.config/nvim/templates/`.
---@field select_template_command string The name of the command to register to select templates. Use `nil` to avoid registering this command. Defaults to `SelectTemplate`.
---@field load_template_command string The name of the command to register to load templates. Use `nil` to avoid registering this command. Defaults to `LoadTemplate`.

---Register an auto-command to load templates when a file is first created.
---Define the commands to load and select templates.
---@param options SetupOptions
function M.setup(options)
    options = options or {}
    options.auto_loading_pattern = options.auto_loading_pattern or '*'
    options.template_folder = options.template_folder or vim.fn.expand('~/.config/nvim/templates/')
    options.select_template_command = options.select_template_command or 'SelectTemplate'
    options.load_template_command = options.load_template_command or 'LoadTemplate'

    M.autogroup = vim.api.nvim_create_augroup('TemplateLoader', {})
    -- Load templates for new files using the file type.
    if options.auto_loading_pattern then
        -- Validate template folder path.
        if vim.fn.isdirectory(vim.fn.expand(options.template_folder)) == 0 then
            error('The template folder is invalid: ' .. options.template_folder)
        end

        vim.api.nvim_create_autocmd('BufNewFile', {
            group = M.autogroup,
            pattern = options.auto_loading_pattern,
            callback = function()
                load_template_from_file_type(options.template_folder)
            end,
        })
    end

    -- Register a command for selecting and loading templates.
    if options.select_template_command then
        -- Validate command name.
        if #options.select_template_command == 0 then
            error('The select template command is invalid.')
        end
        vim.api.nvim_create_user_command(options.select_template_command, function()
            select_template(options.template_folder)
        end, { nargs = 0, desc = 'Select a template and load it into the buffer.' })
    end

    vim.api.nvim_create_autocmd('CmdlineLeave', {
        group = M.autogroup,
        pattern = options.auto_loading_pattern,
        callback = function()
            -- Remove cache.
            M.files = nil
        end,
    })

    -- Register a command for loading templates.
    if options.load_template_command then
        -- Validate command name.
        if #options.load_template_command == 0 then
            error('The load template command is invalid.')
        end
        vim.api.nvim_create_user_command(options.load_template_command, function(opts)
            load_file(joinpath(options.template_folder, opts.args))
        end, {
            nargs = 1,
            complete = function(argument_lead)
                if not M.files then
                    -- Cache all the files, which is an expensive operation.
                    M.files = folder_files(options.template_folder)
                end

                return vim.fn.filter(M.files, function(_, file)
                    return not not string.find(file, argument_lead)
                end)
            end,
            desc = 'Load template into the buffer.',
        })
    end
    return M
end

return M
