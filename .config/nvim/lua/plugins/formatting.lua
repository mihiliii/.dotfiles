local markdownlint_config = vim.fn.stdpath("config") .. "/opts/markdownlint.jsonc"

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      jdtls = function(opts)
        opts.settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = "all",
              },
            },
          },
        }
        return opts
      end,
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        timeout_ms = 10000,
      },
      formatters_by_ft = {
        cpp = { "clang_format" },
        c = { "clang_format" },
        groovy = { "npm-groovy-lint" },
      },
      formatters = {
        clang_format = {
          prepend_args = {
            "--style=file",
            "--fallback-style=none",
            "--assume-filename=" .. os.getenv("HOME") .. "/.clang-format",
          },
        },
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", markdownlint_config },
        },
        ["npm-groovy-lint"] = {
          args = { "--format", "--no-insight", "$FILENAME" },
        },
      },
    },
  },
}
