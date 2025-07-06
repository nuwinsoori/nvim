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
    ---------------------------------------------------------------------------
    -- 0.------ Requires -------------------------------------------------------
    ---------------------------------------------------------------------------
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    ---------------------------------------------------------------------------
    -- 1.------ Mason & mason-lspconfig ---------------------------------------
    ---------------------------------------------------------------------------
    mason.setup()

    mason_lspconfig.setup({
      ensure_installed = {
        "clangd", -- C/C++ (auto‑installed & auto‑enabled)
        "lua_ls", -- Lua
        "svelte",
        "graphql",
        "emmet_ls",
      },
      automatic_installation = true, -- download missing servers
      automatic_enable = true, -- start them automatically (v2+)
    })

    ---------------------------------------------------------------------------
    -- 2.------ Global diagnostic UI -----------------------------------------
    ---------------------------------------------------------------------------
    vim.diagnostic.config({
      virtual_text = true, -- inline messages
      signs = true,
      underline = true,
      update_in_insert = false,
    })

    -- Pretty diagnostic signs in the gutter
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      vim.fn.sign_define("DiagnosticSign" .. type, {
        text = icon,
        texthl = "DiagnosticSign" .. type,
        numhl = "",
      })
    end

    ---------------------------------------------------------------------------
    -- 3.------ LspAttach – per-buffer key‑maps ------------------------------- ------------------------------------------------------------------------
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
        keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
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
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Smart rename" }))
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
        keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
        keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
        keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
      end,
    })

    ---------------------------------------------------------------------------
    -- 4.------ Shared capabilities ------------------------------------------
    ---------------------------------------------------------------------------
    local capabilities = cmp_nvim_lsp.default_capabilities()

    ---------------------------------------------------------------------------
    -- 5.------ Per‑server overrides (only when we need extra settings) -------
    ---------------------------------------------------------------------------

    -- Lua ------------------------------------------------------------------
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    })

    -- Svelte ---------------------------------------------------------------
    lspconfig.svelte.setup({
      capabilities = capabilities,
      on_attach = function(client, _)
        -- Hot‑reload TS/JS files so svelte‑language‑server picks them up
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    -- GraphQL --------------------------------------------------------------
    lspconfig.graphql.setup({
      capabilities = capabilities,
      filetypes = {
        "graphql",
        "gql",
        "svelte",
        "typescriptreact",
        "javascriptreact",
      },
    })

    -- Clangd
    lspconfig.clangd.setup({
      capabilities = capabilities,
      filetypes = {
        "cpp",
        "tpp",
        "h",
        "hpp",
        "c++",
      },
    })

    -- Emmet ----------------------------------------------------------------
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
        html = { options = { ["bem.enabled"] = true } },
      },
    })
  end,
}
