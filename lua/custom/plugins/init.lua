-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dapui.setup {
      icons = {
        expanded = '▾',
        collapsed = '▸',
        current_frame = '▶',
      },
      mappings = {
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      element_mappings = {},
      expand_lines = true,
      force_buffers = true,
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          position = 'left',
          size = 40,
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          position = 'bottom',
          size = 10,
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = '◀',
          run_last = '↻',
          terminate = '⏹',
        },
      },
    }

    dap.adapters.php = {
      type = 'executable',
      command = 'node',
      args = { os.getenv 'HOME' .. '/vscode-php-debug/out/phpDebug.js' },
    }
    dap.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Docker Xdebug',
        port = 9003,
        host = '0.0.0.0',
        stopOnEntry = false,
        log = true,
        pathMappings = {
          {
            localRoot = vim.fn.getcwd(), -- Absolute local path
            remoteRoot = '/srv/open_marketplace', -- Exact Docker container path
          },
        },
        serverSourceRoot = '/srv/open_marketplace',
        localSourceRoot = vim.fn.getcwd(),
        ignore_file_errors = true,
        env = {
          XDEBUG_CONFIG = 'idekey=neovim client_host=host.docker.internal',
        },
      },
    }

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set('n', '<F5>', function()
      require('dap').continue()
    end)
    vim.keymap.set('n', '<F10>', function()
      require('dap').step_over()
    end)
    vim.keymap.set('n', '<F11>', function()
      require('dap').step_into()
    end)
    vim.keymap.set('n', '<F12>', function()
      require('dap').step_out()
    end)
    vim.keymap.set('n', '<Leader>b', function()
      require('dap').toggle_breakpoint()
    end)
    vim.keymap.set('n', '<Leader>B', function()
      require('dap').set_breakpoint()
    end)
    vim.keymap.set('n', '<Leader>lp', function()
      require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
    end)
    vim.keymap.set('n', '<Leader>dr', function()
      require('dap').repl.open()
    end)
    vim.keymap.set('n', '<Leader>dl', function()
      require('dap').run_last()
    end)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.scopes)
    end)
  end,
}
