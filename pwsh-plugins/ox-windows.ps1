##########################################################
# config
##########################################################

function open { param ( $path ) explorer $path }

##########################################################
# main
##########################################################

function clean {
    param ( $obj )
    switch ($obj) {
        sd { Remove-Item -Recurse -Confirm $env:SCOOP\cache }
        Default { Clear-RecycleBin -Confirm }
    }
}

function hide {
    $file = Get-Item $args[0] -Force
    $file.attributes = 'Hidden'
}

function shutdown { Stop-Computer -Force }
function restart { Restart-Computer -Force }

##########################################################
# files
##########################################################

function sha1 { param ( $pkg ) Get-FileHash -Algorithm SHA1 $pkg }
function sha2 { param ( $pkg ) Get-FileHash $pkg }

##########################################################
# winget
##########################################################

function init_winget {
    Write-Output "Initialize WinGet to $($Global:Oxygen.oxw)"
    winget import -i $Global:Oxygen.oxw
}
function up_winget {
    Write-Output "Update Scoop by $($Global:Oxide.bkw)"
    winget import -i $Global:Oxide.bkw
}
function back_winget {
    Write-Output "Backup Scoop by $($Global:Oxide.bkw)"
    winget export -o $Global:Oxide.bkw
}

function w { winget $args }
function wis { winget install $args }
function wus { winget uninstall $args }
function wls { winget list }
function wif { winget show $args }
function wifs { winget --info }
function wsc { winget search $args }
function wup {
    if ([string]::IsNullOrEmpty($args)) { winget upgrade * }
    else { winget upgrade $args }
}
function wups { winget source update }
function wxa { param ( $repo ) winget source add $repo }
function wxrm { param ( $repo ) winget source remove $repo }
function wxls { param ( $repo ) winget source list }


##########################################################
# wsl
##########################################################

function wlis {
    if ([string]::IsNullOrEmpty($args)) { wsl --install }
    else { wsl --install -d $args }
}

function wlls { wsl -l -v }
function wllso { wsl -l -o }

function wlsv {
    param ( $ver )
    switch ($ver) {
        { $ver -eq 2 } { 1 }
        Default { 2 }
    }
    wsl --set-version $ver
}
