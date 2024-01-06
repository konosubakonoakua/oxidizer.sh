if ([string]::IsNullOrEmpty($env:OXIDIZER)) {
    $env:OXIDIZER = "$HOME\oxidizer"
}

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    echo "Scoop Already Installed"
}
else {
    echo "Scoop Not Found. Installing..."

    $f_scoop = Join-Path $HOME "install.ps1"

    if ( $env:scoop_mirror ) {
        Invoke-WebRequest 'https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1' -UseBasicParsing -OutFile $f_scoop

        scoop config SCOOP_REPO 'https://gitee.com/glsnames/scoop-installer'
    }
    else {
        Invoke-WebRequest 'https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1' -UseBasicParsing -OutFile $f_scoop
    }
    if ( $env:scoop_test ) { & $f_scoop -RunAsAdmin -ScoopDir 'C:\Scoop' }
    else { & $f_scoop -ScoopDir 'C:\Scoop' }
}

scoop install aria2 7zip

# add additional buckets
if ( $env:scoop_mirror ) {
    $scoopBuckets = @("nerd-fonts https://gitee.com/scoop-bucket/nerd-fonts", "extras https://gitee.com/scoop-bucket/extras.git")
}
else {
    $scoopBuckets = @("nerd-fonts", "extras")
}

ForEach ( $bucket in $scoopBuckets ) {
    scoop bucket add $bucket
}

$pkgs = cat "$env:OXIDIZER\defaults\Scoopfile.txt"

ForEach ( $pkg in $pkgs ) {
    Switch ($pkg) {
        ripgrep { $cmd = "rg" }
        zoxide { $cmd = "z" }
        Default { $cmd = $pkg }
    }
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        echo "$pkg Already Installed"
    }
    else {
        echo "Installing $pkg"
        scoop install $pkg
    }
    scoop install scoop-completion psreadline dark innounp
}

###################################################
# Update PowerShell Settings
###################################################

Remove-Item alias:cp -Force -ErrorAction SilentlyContinue

$OX_SHELL = "$HOME/.bash_profile"

echo "Adding Oxidizer into $OX_SHELL..."

if (!(Test-Path -Path $OX_SHELL)) {
    New-Item -ItemType File -Force -Path $OX_SHELL
}

echo '# Oxidizer' >> $OX_SHELL

if ([string]::IsNullOrEmpty($env:OXIDIZER)) {
    echo '
        export OXIDIZER='${OXIDIZER}'' >> $OX_SHELL
    echo 'source '${OXIDIZER}'/oxidizer.sh' >> $OX_SHELL
}
else {
    echo "source '${OXIDIZER}'/oxidizer.sh" >> $OX_SHELL
}

echo "Adding Custom settings..."
cp -R -v "$env:OXIDIZER\defaults.sh" "$env:OXIDIZER\custom.sh"

# load zoxide
sed -i.bak "s|.* OX_STARTUP = .*|$Global:OX_STARTUP=1|" "$env:OXIDIZER\custom.ps1"
# set path of oxidizer
# sed -i.bak "s| = .*\oxidizer.ps1| = $env:OXIDIZER\oxidizer.ps1|" $OX_SHELL
# echo $(cat $OX_SHELL | rg -o 'source .+')

###################################################
# Load Plugins
###################################################

git clone --depth=1 https://github.com/ivaquero/oxplugins-zsh.git $env:OXIDIZER\plugins

echo "Oxidizer installation complete!"
echo "Please use it in Git Bash and hit 'edf ox' to tweak your preferences.\n"
echo "Finally, run 'upox' function to activate the plugins. Enjoy!"
