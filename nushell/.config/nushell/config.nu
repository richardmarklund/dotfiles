source ~/.cache/carapace/init.nu
use ~/.cache/starship/init.nu
$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/Cellar/neovim/0.10.2_1/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')
$env.config = {
  show_banner: false,
	edit_mode: vi,
}
source ~/.zoxide.nu

alias cd = z
