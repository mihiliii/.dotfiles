local markdownlint_config = vim.fn.stdpath("config") .. "/opts/markdownlint.jsonc"

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Filetype detection for Jenkinsfile* lives in lua/config/options.lua.
      linters_by_ft = {
        groovy = { "npm-groovy-lint" },
      },
      linters = {
        ["npm-groovy-lint"] = {
          -- Jenkinsfile ruleset: turns off NoDef, VariableTypeRequired, CompileStatic,
          -- MethodReturnTypeRequired and GStringExpressionWithinString, which are all
          -- noise in a declarative pipeline.
          args = { "-c", "recommended-jenkinsfile", "-o", "json", "-" },
        },
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", markdownlint_config },
        },
      },
    },
  },
}
