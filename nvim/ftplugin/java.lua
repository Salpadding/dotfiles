local cmd = vim.fn.expand('$HOME/bin/opt/jdtls/bin/jdtls')
local config = {
    cmd = { cmd, vim.fn.expand("--jvm-arg=-javaagent:$HOME/.m2/repository/org/projectlombok/lombok/1.18.32/lombok-1.18.32.jar") },
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
    init_options = {
        bundles = {
            vim.fn.glob(
                "$HOME/bin/opt/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
                1
            )
        },
    }
}

require('jdtls').start_or_attach(config)
