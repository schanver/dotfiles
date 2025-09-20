vim.opt.expandtab = true
vim.opt.foldlevelstart = 15
vim.opt.foldmethod = 'syntax'
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'

-- Set the colorscheme to retrobox
vim.cmd.colorscheme "retrobox"

-- Disable swap files
vim.opt.swapfile = false

-- Clear highlighting on search after pressing <Esc> in normal mode 
vim.opt.hlsearch = true
vim.keymap.set('n', '<ESC>' ,':nohlsearch<CR>')

-- Enter zen mode 
vim.keymap.set('n', 'zz', ':ZenMode<CR>')


-- Confirm that a NerdFont is installed 
vim.g.have_nerd_font = true

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Make background transparent
vim.keymap.set('n','<leader>t',':TransparentToggle<CR>')

-- Enable the mouse 
vim.opt.mouse = 'a'

-- Don't show the mode
vim.opt.showmode = false

-- Sync clipboard with system 
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent 
vim.opt.breakindent = true

-- Save undo history 
vim.opt.undofile = true

-- Enable case-insensitive searching 
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250

-- Set new splits right and bottom
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decrease mapped sequence wait time 
vim.opt.timeoutlen = 350

-- 
vim.opt.list = true
vim.opt.listchars = {tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substituions live
vim.opt.inccommand = 'split'

-- Show which line the cursor is on
vim.opt.cursorline = true

--
vim.opt.scrolloff = 12

-- Exit terminal mode 
vim.keymap.set('t', '<Esc><Esc>','<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set('n','<leader>lt', function ()
  vim.cmd(":0r ~/Templates/latex_template.tex")
end, { desc = "Insert LaTeX template to the buffer" })
