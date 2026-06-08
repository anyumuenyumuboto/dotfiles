# [Setup - carapace-bin](https://carapace-sh.github.io/carapace-bin/setup.html#nushell)
## ${UserConfigDir}/nushell/env.nu
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

# [Installation | Yazi](https://yazi-rs.github.io/docs/installation/#windows)
# windows上のyaziでファイルプレビューするためにfile.exeへのパスが必要
$env.YAZI_FILE_ONE = ($nu.home-dir | path join "scoop" "apps" "git" "current" "usr" "bin" "file.exe")
