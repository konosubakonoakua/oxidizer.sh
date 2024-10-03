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

# package managers
# - oxppc: conda
# - oxppcn: conan (c++)
# - oxppnj: npm + yarn
# - oxpptl: tlmgr (texlive)
# languages
# - oxpljl: julia
# - oxplrb: ruby (include gem)
# - oxplrs: rust (include cargo)
# services
# - oxpsol: ollama
# - oxpspu: pueue
# app cli
# - oxpcbw: bitwarden
# - oxpces: espanso
# - oxpcjr: jupyter (notebook, lab, book)
# - oxpcvs: vscode
# system utils
# - oxpufm: format conversion
# extra utils
# - oxpxns: notes

$Global:OX_PLUGINS = @(
    'oxpufm',
    'oxpcvs'
)

##########################################################
# select initial and backup configurations
##########################################################

# backup file path
$env:OX_BACKUP = "$HOME\Documents\backup"

# shell
$Global:OX_OXIDE.bkox = "$env:OX_BACKUP\shell\custom.ps1"

##########################################################
# git
##########################################################

# default files
$Global:OX_OXYGEN.oxg = "$env:OXIDIZER\defaults\.gitconfig"
# system files
$Global:OX_ELEMENT.g = "$HOME\.gitconfig"

##########################################################
# terminal
##########################################################

$Global:OX_ELEMENT.wt = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if ( Test-Path $Global:OX_ELEMENT.wt ) {
    $Global:OX_OXIDE.bkwt = "$env:OX_BACKUP\terminal\windows-terminal.jsonc"
}
else {
    $Global:OX_ELEMENT.wz = "$HOME\.wezterm.lua"
    if ( !(Test-Path $Global:OX_ELEMENT.wz) ) {
        New-Item -Path $Global:OX_ELEMENT.wz -ItemType File
    }
    $Global:OX_OXIDE.bkwz = "$env:OX_BACKUP\terminal\wezterm.lua"
}

##########################################################
# proxy settings
##########################################################

# c: clash, m: clash-meta, v: v2ray
$Global:OX_PROXY = @{
    'c' = '7898'
    'm' = '7897'
    'v' = '1080'
}

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

# predefined conda environments
# set the length of key < 3
$Global:OX_CONDA_ENV = @{
    b = 'base'
}

# # conda env stats with bkce, and should be consistent with OX_CONDA_ENV
# # $Global:OX_OXIDE.bkceb = "$env:OX_BACKUP\conda\conda-base.txt"

##########################################################
# julia settings
##########################################################

# predefined julia environments
# set the length of key <= 3
# if ([string]::IsNullOrEmpty($env:JULIA_DEPOT_PATH)) {
#     $env:JULIA_DEPOT_PATH = "$HOME\.julia"
# }
# $Global:OX_JULIA_ENV = @{
#     b = "$env:JULIA_DEPOT_PATH\environments\v$(julia -v | rg -o '\d+\.\d+')"
#     # t = "tutorial"
# }

# # julia env stats with bkjl, and should be consistent with OX_JULIA_ENV
# $Global:OX_OXIDE.bkjlb = "$env:OX_BACKUP\julia\julia-base.txt"

##########################################################
# other settings
##########################################################

# git
$Global:OX_OXIDE.bkg = "$env:OX_BACKUP\.gitconfig"
$Global:OX_OXIDE.bkgi = "$env:OX_BACKUP\git\.gitignore"
# vscode
$Global:OX_OXIDE.bkvs = "$env:OX_BACKUP\vscode\settings.json"
$Global:OX_OXIDE.bkvs = "$env:OX_BACKUP\vscode\settings.json"
$Global:OX_OXIDE.bkvsk = "$env:OX_BACKUP\vscode\keybindings.json"
$Global:OX_OXIDE.bkvss_ = "$env:OX_BACKUP\vscode\snippets"
$Global:OX_OXIDE.bkvsx = "$env:OX_BACKUP\vscode\vscode-exts.txt"

##########################################################
# common aliases
##########################################################

# shortcuts
function .. { cd .. }
function ... { cd ../.. }
function cat { bat $args }
function ls { lsd $args }
function ll { lsd -l $args }
function la { lsd -a $args }
function lla { lsd -la $args }
function e { echo $args }
function rr { rm -rf $args }
function c { clear }

# tools
function man { tdtlrc $args }
function hf { hyperfine $args }

# oxidizer
# export config
function epf { oxf $args }
# import config
function ipf { rdf $args }
# initialize config
function iif { clzf $args }

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
    Set-Location "$HOME\Desktop"
}

##########################################################
# notes apps
##########################################################

# $Global:OX_OXIDIAN = ""
