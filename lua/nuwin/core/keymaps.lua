vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "<C-H>", "<C-w>", { desc = "Delete whole word with Ctrl+Delete" })

-- formatting markdown
keymap.set("v", "<C-b>", 'c**<C-r>"**<Esc>', { desc = "make bold" })
keymap.set("i", "<C-b>", "****<Left><Left>", { desc = "bold insert mode" })
keymap.set("i", "<C-e>", "**<Left>", { desc = "italics insert" })
keymap.set("v", "<C-e>", 'c*<C-r>"*<Esc>', { desc = "italicise" })

-- increment/decrement numbers
keymap.set("n", "<leader>=", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sw", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tw", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Resize splits with Alt + h/j/k/l
keymap.set("n", "<M-l>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap.set("n", "<M-h>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
keymap.set("n", "<M-k>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap.set("n", "<M-j>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })

-- Terminal
keymap.set("n", "<leader>t", "<cmd>vsplit | terminal<CR>", { desc = "Split vertically and open terminal" }) -- split vertically and open terminal
keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode with jk" })

-- Other
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "clear search highlights" })
-- keymap.set("n", "J", "<nop>", { desc = "Unbind J in normal mode" })
keymap.set("v", "J", "<nop>", { desc = "Unbind J in visual mode" })
keymap.set("n", "ci}", "f{ci{", { desc = "Change in inner" })
keymap.set("n", "di}", "f{di{", { desc = "Delete in inner" })
keymap.set("n", "si}", "f{si{", { desc = "Substitute in inner" })

keymap.set("n", "ci)", "f(ci(", { desc = "Change in inner" })
keymap.set("n", "di)", "f(di(", { desc = "Delete in inner" })
keymap.set("n", "si)", "f(si(", { desc = "Substitute in inner" })

-- MacOS
keymap.set("i", "<A-BS>", "<C-w>", { desc = "Delete last word in insert mode with Option+Delete" })
keymap.set("i", "<C-BS>", "<Space><C-O>d0", { desc = "Delete to start of line " })
