#!/bin/bash /bin/zsh
export OXIDIZER=${OXIDIZER:-"${HOME}/oxidizer"}

##########################################################
# Oxidizer Configuration Files
##########################################################

# plugins
declare -A OX_OXYGEN=(
    [oxd]=${OXIDIZER}/defaults.sh
    [oxwz]=${OXIDIZER}/defaults/wezterm.lua
    [oxpx]=${OXIDIZER}/defaults/verge.yaml
    [oxpm]=${OXIDIZER}/oxplugins-zsh/ox-macos.sh
    [oxpd]=${OXIDIZER}/oxplugins-zsh/ox-debians.sh
    [oxpb]=${OXIDIZER}/oxplugins-zsh/ox-brew.sh
    [oxpg]=${OXIDIZER}/oxplugins-zsh/ox-git.sh
    [oxpc]=${OXIDIZER}/oxplugins-zsh/ox-conda.sh
    [oxpbw]=${OXIDIZER}/oxplugins-zsh/ox-bitwarden.sh
    [oxpcn]=${OXIDIZER}/oxplugins-zsh/ox-conan.sh
    [oxpct]=${OXIDIZER}/oxplugins-zsh/ox-container.sh
    [oxpes]=${OXIDIZER}/oxplugins-zsh/ox-espanso.sh
    [oxphx]=${OXIDIZER}/oxplugins-zsh/ox-helix.sh
    [oxpjl]=${OXIDIZER}/oxplugins-zsh/ox-julia.sh
    [oxpjn]=${OXIDIZER}/oxplugins-zsh/ox-jupyter.sh
    [oxpnj]=${OXIDIZER}/oxplugins-zsh/ox-node.sh
    [oxppd]=${OXIDIZER}/oxplugins-zsh/ox-podman.sh
    [oxppu]=${OXIDIZER}/oxplugins-zsh/ox-pueue.sh
    [oxprs]=${OXIDIZER}/oxplugins-zsh/ox-rust.sh
    [oxptl]=${OXIDIZER}/oxplugins-zsh/ox-texlive.sh
    [oxput]=${OXIDIZER}/oxplugins-zsh/ox-utils.sh
    [oxpvs]=${OXIDIZER}/oxplugins-zsh/ox-vscode.sh
    [oxpzj]=${OXIDIZER}/oxplugins-zsh/ox-zellij.sh
    [oxpfm]=${OXIDIZER}/oxplugins-zsh/ox-formats.sh
    [oxpwr]=${OXIDIZER}/oxplugins-zsh/ox-weather.sh
    [oxpns]=${OXIDIZER}/oxplugins-zsh/ox-notes.sh
)

##########################################################
# System Configuration Files
##########################################################

declare -A OX_ELEMENT=(
    [ox]=${OXIDIZER}/custom.sh
    [vi]=${HOME}/.vimrc
    [px]=${HOME}/.config/clash-verge/verge.yaml
)

declare -A OX_OXIDE

##########################################################
# Load Plugins
##########################################################

# load system plugin
case $(uname -a) in
*Darwin*)
    . "${OX_OXYGEN[oxpm]}"
    ;;
*Ubuntu* | *Debian* | *WSL*)
    . "${OX_OXYGEN[oxpd]}"
    ;;
esac

# load custom plugins
declare -a OX_PLUGINS

. "${OX_ELEMENT[ox]}"

for plugin in "${OX_PLUGINS[@]}"; do
    . "${OX_OXYGEN[$plugin]}"
done

declare -a OX_CORE_PLUGINS
OX_CORE_PLUGINS=(oxpb oxput oxppu)

# load core plugins
for core_plugin in "${OX_CORE_PLUGINS[@]}"; do
    . ${OX_OXYGEN[$core_plugin]}
done

##########################################################
# Shell Settings
##########################################################

export SHELLS=/private/etc/shells

case ${SHELL} in
*zsh)
    OX_ELEMENT[zs]=${HOME}/.zshrc
    OX_ELEMENT[zshst]=${HOME}/.zsh_history
    OX_OXIDE[bkzs]=${OX_BACKUP}/shell/.zshrc
    ;;
*bash)
    OX_OXIDE[bs]=${HOME}/.bash_profile
    OX_OXIDE[bshst]=${HOME}/.bash_history
    OX_OXIDE[bkbs]=${OX_BACKUP}/shell/.bash_profile
    ;;
esac

OX_OXIDE[bkvi]=${OX_BACKUP}/shell/.vimrc

##########################################################
# Oxidizer Management
##########################################################

# update all packages
up_all() {
    for obj in "${OX_UPDATE_PROG[@]}"; do
        eval "up_$obj"
    done
}

# backup package lists
back_all() {
    for obj in "${OX_BACKUP_PROG[@]}"; do
        eval "back_$obj"
    done
}

# export configurations
epall() {
    for obj in "${OX_EXPORT_FILE[@]}"; do
        epf "$obj"
    done
}

# import configurations
ipall() {
    for obj in "${OX_IMPORT_FILE[@]}"; do
        ipf "$obj"
    done
}

iiox() {
    printf "📦 Installing Required packages...\n"
    cat ${OXIDIZER}/defaults/Brewfile.txt | while read -r pkg; do
        case $pkg in
        ripgrep)
            cmd='rg'
            ;;
        bottom)
            cmd='btm'
            ;;
        tealdear)
            cmd='tldr'
            ;;
        zoxide)
            cmd='z'
            ;;
        *)
            cmd=$pkg
            ;;
        esac
        if test ! "$(command -v $cmd)"; then
            brew install "$pkg"
        fi
    done
}

# update Oxidizer
upox() {
    cd ${OXIDIZER} || exit
    printf "Updating Oxidizer...\n"
    git fetch origin master
    git reset --hard origin/master

    if [ ! -d ${OXIDIZER}/oxplugins-zsh ]; then
        printf "\n\nCloning Oxidizer Plugins...\n"
        git clone --depth=1 https://github.com/ivaquero/oxplugins-zsh.git
    else
        printf "\n\nUpdating Oxidizer Plugins...\n"
        cd ${OXIDIZER}/oxplugins-zsh || exit
        git fetch origin main
        git reset --hard origin/main
    fi

    cd ${OXIDIZER} || exit
    ox_change=$(git diff defaults.sh)
    if [ -n "$ox_change" ]; then
        printf "\n\nDefaults changed, don't forget to update your custom.sh accordingly...\n"
        printf "Compare the difference using 'edf oxd'"
    fi
    cd ${HOME} || exit
}

##########################################################
# Starship
##########################################################

if test "$(command -v starship)"; then
    # system files
    export STARSHIP_CONFIG=${HOME}/.config/starship.toml
    OX_ELEMENT[ss]=${STARSHIP_CONFIG}
    # backup files
    OX_OXIDE[ss]=${OX_BACKUP}/shell/starship.toml

    case ${SHELL} in
    *zsh)
        eval "$(starship init zsh)"
        ;;
    *bash)
        eval "$(starship init bash)"
        ;;
    esac
fi

if [[ ${OX_STARTUP} ]]; then
    startup
fi
