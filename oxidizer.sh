#!/bin/bash /bin/zsh
export OXIDIZER=${OXIDIZER:-"${HOME}/oxidizer"}

##########################################################
# Oxidizer Configuration Files
##########################################################

# plugins
declare -A OX_OXYGEN=(
    [oxd]=${OXIDIZER}/defaults.sh
    [oxwz]=${OXIDIZER}/defaults/wezterm.lua
    [oxpm]=${OXIDIZER}/oxplugins-zsh/ox-macos.sh
    [oxpd]=${OXIDIZER}/oxplugins-zsh/ox-debians.sh
    [oxpw]=${OXIDIZER}/oxplugins-zsh/ox-windows.sh
    [oxpb]=${OXIDIZER}/oxplugins-zsh/ox-brew.sh
    [oxps]=${OXIDIZER}/oxplugins-zsh/ox-scoop.sh
    [oxpg]=${OXIDIZER}/oxplugins-zsh/ox-git.sh
    [oxpc]=${OXIDIZER}/oxplugins-zsh/ox-conda.sh
    [oxpbw]=${OXIDIZER}/oxplugins-zsh/ox-bitwarden.sh
    [oxpcn]=${OXIDIZER}/oxplugins-zsh/ox-conan.sh
    [oxpct]=${OXIDIZER}/oxplugins-zsh/ox-container.sh
    [oxpes]=${OXIDIZER}/oxplugins-zsh/ox-espanso.sh
    [oxpfm]=${OXIDIZER}/oxplugins-zsh/ox-formats.sh
    [oxpjl]=${OXIDIZER}/oxplugins-zsh/ox-julia.sh
    [oxpjn]=${OXIDIZER}/oxplugins-zsh/ox-jupyter.sh
    [oxpnj]=${OXIDIZER}/oxplugins-zsh/ox-node.sh
    [oxpns]=${OXIDIZER}/oxplugins-zsh/ox-notes.sh
    [oxpnw]=${OXIDIZER}/oxplugins-zsh/ox-network.sh
    [oxppd]=${OXIDIZER}/oxplugins-zsh/ox-podman.sh
    [oxppu]=${OXIDIZER}/oxplugins-zsh/ox-pueue.sh
    [oxprb]=${OXIDIZER}/oxplugins-zsh/ox-ruby.sh
    [oxprs]=${OXIDIZER}/oxplugins-zsh/ox-rust.sh
    [oxptl]=${OXIDIZER}/oxplugins-zsh/ox-texlive.sh
    [oxput]=${OXIDIZER}/oxplugins-zsh/ox-utils.sh
    [oxpvs]=${OXIDIZER}/oxplugins-zsh/ox-vscode.sh
    [oxpwr]=${OXIDIZER}/oxplugins-zsh/ox-weather.sh
    [oxpzj]=${OXIDIZER}/oxplugins-zsh/ox-zellij.sh
)

##########################################################
# System Configuration Files
##########################################################

declare -A OX_ELEMENT=(
    [ox]=${OXIDIZER}/custom.sh
    [vi]=${HOME}/.vimrc
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
    if [[ -f "${OX_OXYGEN[$plugin]}" ]]; then
        . "${OX_OXYGEN[$plugin]}"
    else
        echo "Plugin not found: ${plugin}"
    fi
done

declare -a OX_CORE_PLUGINS
if [[ $(uname) = "Darwin" || $(uname) = "Linux" ]]; then
    OX_CORE_PLUGINS=(oxpb oxput oxpnw)
else
    OX_CORE_PLUGINS=(oxps oxput oxpnw)
fi

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
    OX_ELEMENT[bs]=${HOME}/.bash_profile
    OX_ELEMENT[bshst]=${HOME}/.bash_history
    OX_OXIDE[bkbs]=${OX_BACKUP}/shell/.bash_profile
    ;;
esac

OX_OXIDE[bkvi]=${OX_BACKUP}/shell/.vimrc

##########################################################
# Oxidizer Management
##########################################################

# update Oxidizer
upox() {
    cd "${OXIDIZER}" || exit
    printf "Updating Oxidizer...\n"
    git fetch origin master
    git reset --hard origin/master

    if [ ! -d "${OXIDIZER}"/oxplugins-zsh ]; then
        printf "\n\nCloning Oxidizer Plugins...\n"
        git clone --depth=1 https://github.com/ivaquero/oxplugins-zsh.git
    else
        printf "\n\nUpdating Oxidizer Plugins...\n"
        cd "${OXIDIZER}"/oxplugins-zsh || exit
        git fetch origin main
        git reset --hard origin/main
    fi

    cd "${OXIDIZER}" || exit
    ox_change=$(git diff defaults.sh)
    if [ -n "$ox_change" ]; then
        printf "\n\nDefaults changed, don't forget to update your custom.sh accordingly...\n"
        printf "Compare the difference using 'edf oxd'"
    fi
    cd "${HOME}" || exit
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
