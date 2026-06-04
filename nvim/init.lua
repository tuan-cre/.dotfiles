-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath
  })
  end
  vim.opt.rtp:prepend(lazypath)

  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  require("lazy").setup({
    spec = {

      -- 🌳 FILE TREE
      {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
        require("nvim-tree").setup({
          update_focused_file = {
            enable = true,
            update_cwd = true,
          },
          view = {
            width = 30,
            side = "left",
          },
          renderer = {
            highlight_git = true,
            highlight_opened_files = "all",
          },
          git = { enable = true },
          actions = {
            open_file = { quit_on_open = true },
          },
        })

        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
        end,
      },

      -- 🔍 TELESCOPE
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files)
        vim.keymap.set("n", "<leader>fg", builtin.live_grep)
        end,
      },

      -- 🌲 TREESITTER
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
        local ok, ts = pcall(require, "nvim-treesitter.configs")
        if not ok then return end

          ts.setup({
            highlight = { enable = true },
            indent = { enable = true },
          })
          end,
      },

      -- 📦 MASON (LSP installer)
  {
    "williamboman/mason.nvim",
    config = function()
    require("mason").setup()
    end,
  },

  -- 🧠 LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
    -- setup lua LSP theo API mới
    vim.lsp.config("lua_ls", {})
    vim.lsp.enable("lua_ls")
    end,
  },

  -- ⚡ AUTOCOMPLETE
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
    local cmp = require("cmp")

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
                                          ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      },
    })
    end,
  },

  -- 📊 STATUSLINE
  {
    "nvim-lualine/lualine.nvim",
    config = function()
    require("lualine").setup()
    end,
  },
    },

    rocks = { enabled = false },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
  })

  -- 🌳 AUTO OPEN TREE (nhưng không cướp focus)
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
    require("nvim-tree.api").tree.open()
    vim.cmd("wincmd p")
    end,
  })
