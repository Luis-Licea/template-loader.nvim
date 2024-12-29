#!/usr/bin/env -S nvim -l

-- Calling the setup function should register two functions:
-- 1. A function that loads a template when the buffer loads.
-- 2. A function that cleans the template path cache.

vim.opt.rtp:prepend('..')

local M = require('template-loader')

if M.autogroup ~= nil then
    error('The auto-group should be nil')
end

M.setup()

if M.autogroup == nil then
    error('The auto-group should not be nil')
end

M.setup()
local autocommands = vim.api.nvim_get_autocmds({ group = M.autogroup })
if #autocommands ~= 2 then
    error('Unexpected number of auto-commands')
end

-- Debugging:
-- print(vim.fn.assert_equal(1, 2))
-- print(vim.inspect(vim.v.errors))
-- print(vim.inspect(M))
-- print(vim.inspect(autocommands))
