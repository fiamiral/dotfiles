# Nushell Environment Config File
#
# version = 0.83.1

# XDG Base Directory
$env.XDG_CONFIG_HOME = ("~/.config" | path expand)
$env.XDG_CACHE_HOME = ("~/.cache" | path expand)
$env.XDG_DATA_HOME = ("~/.local/share" | path expand)
$env.XDG_STATE_HOME = ("~/.local/state" | path expand)

# XDG Spec for applications
$env.CARGO_HOME = ($"($env.XDG_DATA_HOME)/cargo") # cargo
$env.RUSTUP_HOME = ($"($env.XDG_DATA_HOME)/rustup") # rustup

# Editor
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"


# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
echo $env.PATH
$env.PATH = ($env.PATH | split row (char esep)
    | prepend ("~/.local/bin" | path expand)
    | prepend $"($env.CARGO_HOME)/bin")
