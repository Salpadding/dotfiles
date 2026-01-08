local defaults = require "u.defaults"
local home = vim.env.HOME
local jdtls_home = "/opt/homebrew/opt/jdtls/libexec"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

return {
  cmd = {
    defaults.jdtls_java_home .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", jdtls_home .. "/config_mac",
    "-data", workspace_dir,
  },
  root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
  settings = {
    java = {
      home = defaults.jdtls_java_home,
      configuration = {
        runtimes = {
          {
            name = "JavaSE-17",
            path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
          },
          {
            name = "JavaSE-21",
            path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
            default = true,
          },
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
}
