return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },

  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    ---------------------------------------------------------------------------
    -- 1.------ LSP-specific key-maps (run once per attached server)
    ---------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        keymap.set(
          "n",
          "gR",
          "<cmd>Telescope lsp_references<CR>",
          vim.tbl_extend("force", opts, { desc = "Show LSP references" })
        )
        keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, {
          desc = "Go to declaration",
        }))
        keymap.set(
          "n",
          "gd",
          "<cmd>Telescope lsp_definitions<CR>",
          vim.tbl_extend("force", opts, { desc = "Show LSP definitions" })
        )
        keymap.set(
          "n",
          "gi",
          "<cmd>Telescope lsp_implementations<CR>",
          vim.tbl_extend("force", opts, { desc = "Show LSP implementations" })
        )
        keymap.set(
          "n",
          "gt",
          "<cmd>Telescope lsp_type_definitions<CR>",
          vim.tbl_extend("force", opts, { desc = "Show LSP type definitions" })
        )
        keymap.set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "See code actions" })
        )
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, {
          desc = "Smart rename",
        }))
        keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          vim.tbl_extend("force", opts, { desc = "Show buffer diagnostics" })
        )
        keymap.set(
          "n",
          "<leader>d",
          vim.diagnostic.open_float,
          vim.tbl_extend("force", opts, { desc = "Show line diagnostics" })
        )
        keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, {
          desc = "Prev diagnostic",
        }))
        keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, {
          desc = "Next diagnostic",
        }))
        keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", vim.tbl_extend("force", opts, {
          desc = "Restart LSP",
        }))
      end,
    })

    ---------------------------------------------------------------------------
    -- 2.------ Shared capabilities / diagnostic icons
    ---------------------------------------------------------------------------
    local capabilities = cmp_nvim_lsp.default_capabilities()

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
    end

    ---------------------------------------------------------------------------
    -- 3.------ Mason-lspconfig v2: auto-enable servers
    ---------------------------------------------------------------------------
    mason_lspconfig.setup({
      ensure_installed = { "svelte", "graphql", "emmet_ls", "lua_ls" },
      automatic_enable = true, -- default true, explicit for clarity
    })

    ---------------------------------------------------------------------------
    -- 4.------ Extra per-server overrides
    ---------------------------------------------------------------------------

    -- Svelte --------------------------------------------------------------
    lspconfig.svelte.setup({
      capabilities = capabilities,
      on_attach = function(client, _)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    -- GraphQL -------------------------------------------------------------
    lspconfig.graphql.setup({
      capabilities = capabilities,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- Emmet ---------------------------------------------------------------
    lspconfig.emmet_ls.setup({
      capabilities = capabilities,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "svelte",
      },
      init_options = {
        html = {
          options = { ["bem.enabled"] = true },
        },
      },
    })

    -- Lua -----------------------------------------------------------------
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    })
  end,
}
