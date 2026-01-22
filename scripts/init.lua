----------------------
--- Basic Settings ---
----------------------
vim.o.compatible = false  -- 关闭对vi的兼容模式
vim.wo.relativenumber = true  -- 相对行号
vim.o.ignorecase = true  -- / ? 不区分大小写
vim.opt.termguicolors = true	-- 启动真彩色
vim.o.autochdir = true	-- 新标签页自动更换当前目录

vim.opt.tabstop = 4     -- 设置tab为4个空格
vim.opt.shiftwidth = 4  -- >>和<<命令时每次缩进的空格数
vim.opt.softtabstop = 4 -- 退格键删除tab时，视为4个空格
vim.opt.expandtab = true    -- tab插入空格
vim.opt.autoindent = true   -- 启用自动缩进

-- Below settings for GBK never work.
-- Finally, I set "Beta版：使用 Unicode UTF-8 提供全球语言支持" in Windows11
-- And now copy to system clipboard works fine.
-- -- 设置 Neovim 内部编码为 GBK（CP936）
-- vim.env.LANG = 'zh_CN.GBK'
-- vim.env.LC_ALL = 'zh_CN.GBK'

-- { and } stop at empty line, even the line contains white space
-- nnoremap } <cmd>call search('^\s*$', 'W')<cr>
-- nnoremap { <cmd>call search('^\s*$', 'bW')<cr>
-- For visual mode, use xnoremap in place of nnoremap
-- See: https://vi.stackexchange.com/questions/37057/next-paragraph-dont-skip-lines-with-white-spaces
vim.keymap.set('n', '{', [[<Cmd>call search('^\s*$', 'bW')<CR>]], {noremap = true, silent = true})
vim.keymap.set('n', '}', [[<Cmd>call search('^\s*$', 'W')<CR>]], {noremap = true, silent = true})
vim.keymap.set('v', '{', [[<Cmd>call search('^\s*$', 'bW')<CR>]], {noremap = true, silent = true})
vim.keymap.set('v', '}', [[<Cmd>call search('^\s*$', 'W')<CR>]], {noremap = true, silent = true})

vim.opt.clipboard = "unnamedplus"
vim.opt.fileencoding = "utf-8"

-- NOTE: The below code snippet will lead to garbled text in zh UTF-8,
--       if the system does not install WSL. For safety, we comment it out.
--       See https://www.cnblogs.com/slwang/p/17641670.html
-- Clipboard Settings for WSL
-- Provided By NVim Official
-- vim.g.clipboard = {
--   name = 'WslClipboard',
--   copy = {
--     ['+'] = 'clip.exe',
--     ['*'] = 'clip.exe',
--   },
--   paste = {
--     ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--   },
--   cache_enabled = 0,
-- }


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})


--------------------
--- Key Bindings ---
--------------------
-- Leader
vim.g.mapleader = ' '


-- ***** NORMAL Mode *****
-- Faster Movement
vim.api.nvim_set_keymap('n', 'J', '5j', {noremap = true})
vim.api.nvim_set_keymap('n', 'K', '5k', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader><Leader>j', 'J', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', {noremap = true})

-- Tabs
-- vim.api.nvim_set_keymap('n', '<Leader>t', ':tabnew<CR>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<Leader>to', ':tabo<CR>', {noremap = true})

-- New Terminal
vim.api.nvim_set_keymap('n', '<Leader>n', ':sp<CR>:wincmd j<CR>:terminal<CR>i', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>t', ':tabnew | term<CR>', {noremap = true})

-- Save and Quit Current File
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-w>', ':q<CR>', {noremap = true})

-- Disable highlight after search
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR>', { silent = true, noremap = true })

-- y = copy to System Clipboard
vim.api.nvim_set_keymap('n', 'y', '"+y', {noremap = true})
vim.api.nvim_set_keymap('v', 'y', '"+y', {noremap = true})

-- leader + p = paste System Clipboard
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>P', '"+P', {noremap = true})

-- leader + o = Create a new line below and Remain in normal mode
vim.api.nvim_set_keymap('n', '<Leader>o', 'o<Esc>', {noremap = true})

-- leader + O = Create a new line above and Remain in normal mode
vim.api.nvim_set_keymap('n', '<Leader>O', 'O<Esc>', {noremap = true})

-- Quicker Window Switch
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})

-- Change Window Size ( - = + _ H L ) 
-- For convinence, '-' and '_' are exchanged
vim.api.nvim_set_keymap('n', '-', '<C-w>_', {noremap = true})
vim.api.nvim_set_keymap('n', '_', '<C-w>-', {noremap = true})
vim.api.nvim_set_keymap('n', '=', '<C-w>=', {noremap = true})
vim.api.nvim_set_keymap('n', '+', '<C-w>+', {noremap = true})
vim.api.nvim_set_keymap('n', 'H', '<C-w><<C-w><', {noremap = true})
vim.api.nvim_set_keymap('n', 'L', '<C-w>><C-w>>', {noremap = true})

-- Quicker Tab Switch
vim.api.nvim_set_keymap('n', '<Tab>', 'gt', {noremap = true})
vim.api.nvim_set_keymap('n', '<S-Tab>', 'gT', {noremap = true})


-- ***** INSERT Mode *****
-- inoremap jk <Esc> 


-- ***** VISUAL Mode *****
vim.api.nvim_set_keymap('v', 'J', '5j', {noremap = true})
vim.api.nvim_set_keymap('v', 'K', '5k', {noremap = true})


-- ***** TERMINAL Mode *****
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})



----------------------
--- Custom Command ---
----------------------
-- Create new terminal below current window
vim.cmd[[
command! -nargs=0 T sp | wincmd j | terminal
]]


---------------
--- Plugins ---
---------------

-- ***** EasyMotion *****
-- Set Single Leader
vim.api.nvim_set_keymap('', '<Leader>', '<Plug>(easymotion-prefix)', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader><Leader>w', '<Plug>(easymotion-w)', {noremap = true})	-- <Leader>w is Ocupied by Save
vim.api.nvim_set_keymap('n', '<Leader>e', '<Plug>(easymotion-e)', {noremap = true})


-- ***** FZF *****
vim.api.nvim_set_keymap('n', '<C-t>', ':Files<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-e>', ':Buffers<CR>', {noremap = true})
