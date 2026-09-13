local markdownlint_config = vim.fn.stdpath("config") .. "/opts/markdownlint.jsonc"

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        groovy = { "npm-groovy-lint" },
      },
      linters = {
        ["npm-groovy-lint"] = {
          args = { "-c", "recommended-jenkinsfile", "-o", "json", "-" },
        },
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", markdownlint_config },
        },
      },
    },
  },
}
