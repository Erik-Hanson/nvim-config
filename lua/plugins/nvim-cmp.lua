return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    -- Add Copilot dependencies
    'zbirenbaum/copilot.lua',
    'zbirenbaum/copilot-cmp',
  },
  config = function()
    local cmp = require('cmp')

    -- Setup Copilot first
    require('copilot').setup({
      suggestion = { enabled = false }, -- Disable inline suggestions to use cmp
      panel = { enabled = false },      -- Disable panel to use cmp
    })

    -- Setup Copilot cmp integration
    require('copilot_cmp').setup()

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'copilot', priority = 1000 }, -- Add Copilot with highest priority
        { name = 'nvim_lsp', priority = 900 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 300 },
      }),
      -- Add formatting to distinguish sources
      formatting = {
        format = function(entry, vim_item)
          -- Add icons to identify completion sources
          local icons = {
            copilot = '🤖',
            nvim_lsp = '🔧',
            buffer = '📄',
            path = '📁',
          }

          vim_item.kind = string.format('%s %s', icons[entry.source.name] or '❓', vim_item.kind)
          vim_item.menu = ({
            copilot = '[Copilot]',
            nvim_lsp = '[LSP]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]

          return vim_item
        end,
      },
    })
  end
}
