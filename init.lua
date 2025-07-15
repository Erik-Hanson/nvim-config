require("keymaps")
require("options")
require("config.lazy")
require("plugins.bufferline")

-- Your on_attach function (same as before)
  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    -- Documentation
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- Code actions
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)

    -- Formatting
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)
  end

  -- Configure diagnostic display
  vim.diagnostic.config({
    virtual_text = {
      enabled = true,
      source = "if_many",
      prefix = "●", -- Could be '■', '▎', 'x'
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })

  -- Define signs for diagnostics (modern way)
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      }
    }
  })

  -- Add diagnostic keymaps for easy navigation
  vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, { noremap = true, silent = true })  -- Changed from <space>e to <space>d
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true })
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

  -- Get completion capabilities from nvim-cmp
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Setup TypeScript/JavaScript language server
  require('lspconfig').ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,  -- Add this line
  })

  -- Add ESLint language server
  require('lspconfig').eslint.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      workingDirectory = { mode = "auto" },  -- Auto-detect project root
      -- If you have ESLint globally installed, you can specify the path
      -- eslintPath = "path/to/eslint"
    },
    root_dir = require('lspconfig').util.root_pattern(
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.json',
      'eslint.config.js',
      'package.json'
    ),
  })

  -- Setup Python language server
  require('lspconfig').pylsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- Setup Lua language server
  require('lspconfig').lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  -- Setup HTML language server with specific filetypes
  require('lspconfig').html.setup({
    filetypes = { "html", "isml" },
    settings = {
      html = {
        format = {
          templating = true,
          wrapLineLength = 120,
          wrapAttributes = 'auto',
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
  })
