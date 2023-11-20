##########################################################
# conventions
##########################################################

# uppercase for global variables
# lowercase for local variables

##########################################################
# basic settings
##########################################################

# default editor, can be changed by function `ched()`
$env:EDITOR = 'code'
# terminal editor
$env:EDITOR_T = 'vi'

##########################################################
# select ox-plugins
##########################################################

# oxpg: ox-git
# oxpc: ox-conda
# oxpcn: ox-conan
# oxphx: ox-helix
# oxpjl: ox-julia
# oxpnj: ox-nodejs
# oxprb: ox-ruby
# oxprs: ox-rust
# oxpbw: ox-bitwarden
# oxpct: ox-container
# oxpes: ox-espanso
# oxpjn: ox-jupyter
# oxptl: ox-texlive
# oxpvs: ox-vscode
# oxpfm: ox-formats
# oxpwr: ox-weather
# oxpwr: ox-notes

$Global:OX_PLUGINS = @(
    'oxpwr',
    'oxpvs'
)

##########################################################
# select initial and backup configurations
##########################################################

# options: scoop, conda, vscode, julia, texlive, node
$Global:OX_UPDATE_PROG = @('scoop')
$Global:OX_BACKUP_PROG = @('scoop')

# backup file path
$env:OX_BACKUP = "$HOME\Documents\backup"

# shell
$Global:OX_OXIDE.bkox = "$env:OX_BACKUP\shell\custom.ps1"
# $Global:OX_OXIDE.bkpx = "$env:OX_BACKUP\verge.yaml"

# terminal
$Global:OX_ELEMENT.wz = "$HOME\.wezterm.lua"
# $Global:OX_ELEMENT.al = "$env:APPDATA\alacritty\alacritty.yml"

$Global:OX_OXIDE.bkwz = "$env:OX_BACKUP\terminal\wezterm.lua"
# $Global:OX_OXIDE.bkal = "$env:OX_BACKUP\terminal\alacritty.yml"

##########################################################
# register proxy ports
##########################################################

# c: clash, v: v2ray
$Global:OX_PROXY = @{
    'c' = '7890'
    'v' = '1080'
}

##########################################################
# select export and import configurations
##########################################################

# files to be exported to backup folder
# ox: custom.sh of Oxidizer
# rs: cargo's env
# pu: pueue's config.yml
# pua: pueue's aliases.yml
# jl: julia's startup.jl
# vs: vscode's settings.json
# vsk: vscode's keybindings.json
# vss_: vscode's snippets folder
$Global:OX_EXPORT_FILE = @('ox', 'vs', 'vsk', 'vss_')

# files to be import from backup folder
# $Global:OX_IMPORT_FILE = @("ox", "vs", "vsk", "vss_")

##########################################################
# git settings
##########################################################

# backup files
$Global:OX_OXIDE.bkg = "$env:OX_BACKUP\.gitconfig"
$Global:OX_OXIDE.bkgi = "$env:OX_BACKUP\git\.gitignore"

##########################################################
# pueue settings
##########################################################

# pueue demo
# function upp {
#     pueue group add up_all
#     pueue parallel 3 -g up_all
#     pueue add -g up_all 'scoop update *; scoop upgrade'
#     pueue add -g up_all 'conda update --all --yes'
#     pueue add -g up_all 'tlmgr update --all'
#     # or use predefined items in pueue_aliase
#     # pueue add -g up_all 'tlup'
# }

##########################################################
# conda settings
##########################################################

# # predefined conda environments
# # set the length of key < 3
# $Global:OX_CONDA_ENV = @{
#     b = 'base'
# }

# # conda env stats with bkce, and should be consistent with OX_CONDA_ENV
# # $Global:OX_OXIDE.bkceb = "$env:OX_BACKUP\conda\conda-base.txt"

##########################################################
# vscode settings
##########################################################

$Global:OX_OXIDE.bkvs = "$env:OX_BACKUP\vscode\settings.json"

##########################################################
# common aliases
##########################################################

# shortcuts
function cat { bat $args }
function ls { lsd $args }
function ll { lsd -l $args }
function la { lsd -a $args }
function lla { lsd -la $args }
function e { echo $args }
function rr { rm -rf $args }
function c { clear }

# tools
function man { tldr $args }
function hf { hyperfine $args }

##########################################################
# powershell
##########################################################

function tt { hyperfine --warmup 3 --shell powershell '. $PROFILE' }

##########################################################
# startup & daily commands
##########################################################

# donwload path
$env:OX_DOWNLOAD = "$HOME\Desktop"

$Global:OX_STARTUP = 1

function startup {
    cd "$HOME\Desktop"
}

##########################################################
# notes apps
##########################################################

# $Global:OX_OXIDIAN = ""
