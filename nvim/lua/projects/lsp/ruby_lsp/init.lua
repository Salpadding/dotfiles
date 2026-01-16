return {
  cmd = { "bundle", "exec", "ruby-lsp" },
  init_options = {
    enabledFeatures = {
      "codeActions",
      "codeLens",
      "completion",
      "definition",
      "diagnostics",
      "documentHighlights",
      "documentLink",
      "documentSymbols",
      "foldingRanges",
      "formatting",
      "hover",
      "inlayHint",
      "onTypeFormatting",
      "selectionRanges",
      "semanticHighlighting",
      "signatureHelp",
      "typeHierarchy",
      "workspaceSymbol",
    },
    featuresConfiguration = {
      inlayHint = {
        implicitHashValue = true,
        implicitRescue = true,
      },
    },
    -- Sorbet addon is auto-enabled when sorbet-runtime is in Gemfile
    addonSettings = {
      ["Ruby LSP Sorbet"] = {
        enabled = true,
      },
    },
  },
}
