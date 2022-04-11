##########################################################
# config
##########################################################

# config files
Element[jl]=$HOME/.julia/config/startup.jl
Element[jlp]=$HOME/.julia/environments/v$(julia -v | rg --only-matching "\d.\d")/Project.toml
Element[jlm]=$HOME/.julia/environments/v$(julia -v | rg --only-matching "\d.\d")/Manifest.toml

# backup files
Oxide[bkjl]=$BACKUP/julia/startup.jl

if [[ ! -d $BACKUP/julia ]]; then
    mkdir -p $BACKUP/julia
fi

init_julia() {
    echo "Initialize Julia using Oxidizer configuration"
    local pkgs=[\"$(<$OXIDIZER/defaults/julia.txt | sd '\n' '", "')\"]
    local pkgs_vec=$(echo $pkgs | sd ', ""' '')
    echo "Installing $pkgs_vec"
    local cmd=$(echo 'using Pkg; Pkg.add(,,)' | sd ',,' "$pkgs_vec")
    julia --eval "$cmd"
}

up_julia() {
    echo "Update Julia by self-defined configuration"
    local pkgs=[\"$(<$BACKUP/install/julia.txt | sd '\n' '", "')\"]
    local pkgs_vec=$(echo $pkgs | sd ', ""' '')
    local cmd=$(echo 'using Pkg; Pkg.add(,,)' | sd ',,' "$pkgs_vec")
    julia --eval "$cmd"
}

back_julia() {
    echo "Backup Julia to $BACKUP/install"
    <$Element[jlp] | rg --only-matching "\w.*=" | sd "[= ]" "" >$BACKUP/install/julia.txt
}

##########################################################
# packages
##########################################################

alias jl="julia --quiet"
alias jlh="julia --help"
alias jlr="julia --eval"
alias jlcl="julia --eval 'using Pkg; Pkg.gc()'"
alias jlst="julia --eval 'using Pkg; Pkg.status()'"

# install packages
jlis() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.add([,,])' | sd ',,' "$pkgs")
    julia --eval "$cmd"
}

# uninstall packages
jlus() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.rm([,,])' | sd ',,' "$pkgs")
    julia --eval "$cmd"
}

# update packages
jlup() {
    if [[ -z $@ ]]; then
        julia --eval "using Pkg; Pkg.update()"
    else
        local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
        local cmd=$(echo 'using Pkg; Pkg.update([,,])' | sd ',,' "$pkgs")
        julia --eval "$cmd"
    fi
}

# list leave packages
jllvs() {
    <$Element[jlp] | rg --only-matching "\w+ =" | sd " =" " "
}

# list packages
jlls() {
    <$Element[jlm] | rg --only-matching "deps\.\w+" | sd "deps\." ""
}

jlpn() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.pin([,,])' | sd ',,' "$pkgs")
    julia --eval "$cmd"
}

jlupn() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.free([,,])' | sd ',,' "$pkgs")
    julia --eval "$cmd"
}

# calculate mature rate
jlmt() {
    local num_total=$(<$Element[jlm] | rg "\[\[" | wc -l)
    echo "total: $num_total"
    local num_immature=$(<$Element[jlm] | rg '"0\.' | wc -l)
    local mature_rate=$((100 - num_immature * 100 / num_total))
    echo "mature rate: $mature_rate %"
}

##########################################################
# project
##########################################################

jlb() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.build([,,])' | sd ',,' "$pkgs")
    julia --eval "$cmd"
}

jlts() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.test([,,])' | sd ',,' "$pkgs")
    julia --eval "$cmd"
}
