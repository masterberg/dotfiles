#!/usr/bin/env bash
# https://privacy.sexy — v0.12.9 — Sat, 13 Jan 2024 04:32:37 GMT
if [ "$EUID" -ne 0 ]; then
    script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
    sudo "$script_path" || (
        echo 'Administrator privileges are required.'
        exit 1
    )
    exit 0
fi


# ----------------------------------------------------------
# ---------------Clear CUPS printer job cache---------------
# ----------------------------------------------------------
echo '--- Clear CUPS printer job cache'
sudo rm -rfv /var/spool/cups/c0*
sudo rm -rfv /var/spool/cups/tmp/*
sudo rm -rfv /var/spool/cups/cache/job.cache*
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------------Empty trash on all volumes----------------
# ----------------------------------------------------------
echo '--- Empty trash on all volumes'
# on all mounted volumes
sudo rm -rfv /Volumes/*/.Trashes/* &>/dev/null
# on main HDD
sudo rm -rfv ~/.Trash/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Clear system cache--------------------
# ----------------------------------------------------------
echo '--- Clear system cache'
sudo rm -rfv /Library/Caches/* &>/dev/null
sudo rm -rfv /System/Library/Caches/* &>/dev/null
sudo rm -rfv ~/Library/Caches/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------Clear Xcode's derived data and archives----------
# ----------------------------------------------------------
echo '--- Clear Xcode'\''s derived data and archives'
rm -rfv ~/Library/Developer/Xcode/DerivedData/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/Archives/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/iOS Device Logs/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------------Clear DNS cache----------------------
# ----------------------------------------------------------
echo '--- Clear DNS cache'
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear inactive memory-------------------
# ----------------------------------------------------------
echo '--- Clear inactive memory'
sudo purge
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Disable online spell correction--------------
# ----------------------------------------------------------
echo '--- Disable online spell correction'
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Disable remote Apple events----------------
# ----------------------------------------------------------
echo '--- Disable remote Apple events'
sudo systemsetup -setremoteappleevents off
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable automatic storage of documents in iCloud Drive--
# ----------------------------------------------------------
echo '--- Disable automatic storage of documents in iCloud Drive'
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Disable display of recent applications on Dock------
# ----------------------------------------------------------
echo '--- Disable display of recent applications on Dock'
defaults write com.apple.dock show-recents -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Disable AirDrop file sharing---------------
# ----------------------------------------------------------
echo '--- Disable AirDrop file sharing'
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------------Disable Spotlight indexing----------------
# ----------------------------------------------------------
echo '--- Disable Spotlight indexing'
sudo mdutil -i off -d /
# ----------------------------------------------------------


# Disable personalized advertisements and identifier tracking
echo '--- Disable personalized advertisements and identifier tracking'
defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
defaults write com.apple.AdLib forceLimitAdTracking -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Disable Captive portal------------------
# ----------------------------------------------------------
echo '--- Disable Captive portal'
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false
# ----------------------------------------------------------


# Disable library validation entitlement (library signature validation)
echo '--- Disable library validation entitlement (library signature validation)'
sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist 'DisableLibraryValidation' -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Clear bash history--------------------
# ----------------------------------------------------------
echo '--- Clear bash history'
rm -f ~/.bash_history
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Clear zsh history---------------------
# ----------------------------------------------------------
echo '--- Clear zsh history'
rm -f ~/.zsh_history
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear system application logs---------------
# ----------------------------------------------------------
echo '--- Clear system application logs'
sudo rm -rfv /Library/Logs/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------------Clear Mail logs----------------------
# ----------------------------------------------------------
echo '--- Clear Mail logs'
rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*
# ----------------------------------------------------------


# Clear user activity audit logs (login, logout, authentication, etc.)
echo '--- Clear user activity audit logs (login, logout, authentication, etc.)'
sudo rm -rfv /var/audit/*
sudo rm -rfv /private/var/audit/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear user report logs------------------
# ----------------------------------------------------------
echo '--- Clear user report logs'
sudo rm -rfv ~/Library/Logs/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------------Clear daily logs---------------------
# ----------------------------------------------------------
echo '--- Clear daily logs'
sudo rm -fv /System/Library/LaunchDaemons/com.apple.periodic-*.plist
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Clear receipt logs for installed packages/apps------
# ----------------------------------------------------------
echo '--- Clear receipt logs for installed packages/apps'
sudo rm -rfv /var/db/receipts/*
sudo rm -vf /Library/Receipts/InstallHistory.plist
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Clear Adobe cache---------------------
# ----------------------------------------------------------
echo '--- Clear Adobe cache'
sudo rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Clear Gradle cache--------------------
# ----------------------------------------------------------
echo '--- Clear Gradle cache'
if [ -d "~/.gradle/caches" ]; then
    rm -rfv ~/.gradle/caches/ &> /dev/null
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear Dropbox cache--------------------
# ----------------------------------------------------------
echo '--- Clear Dropbox cache'
if [ -d "~/Dropbox/.dropbox.cache" ]; then
    sudo rm -rfv ~/Dropbox/.dropbox.cache/* &>/dev/null
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Clear Google Drive File Stream cache-----------
# ----------------------------------------------------------
echo '--- Clear Google Drive File Stream cache'
killall "Google Drive File Stream"
rm -rfv ~/Library/Application\ Support/Google/DriveFS/[0-9a-zA-Z]*/content_cache &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear Composer cache-------------------
# ----------------------------------------------------------
echo '--- Clear Composer cache'
if type "composer" &> /dev/null; then
    composer clearcache &> /dev/null
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear Homebrew cache-------------------
# ----------------------------------------------------------
echo '--- Clear Homebrew cache'
if type "brew" &>/dev/null; then
    brew cleanup -s &>/dev/null
    rm -rfv $(brew --cache) &>/dev/null
    brew tap --repair &>/dev/null
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear old Ruby gem versions----------------
# ----------------------------------------------------------
echo '--- Clear old Ruby gem versions'
if type "gem" &> /dev/null; then
    gem cleanup &>/dev/null
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------------Clear unused Docker data-----------------
# ----------------------------------------------------------
echo '--- Clear unused Docker data'
if type "docker" &> /dev/null; then
    docker system prune -af
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear Pyenv-Virtualenv cache---------------
# ----------------------------------------------------------
echo '--- Clear Pyenv-Virtualenv cache'
if [ "$PYENV_VIRTUALENV_CACHE_PATH" ]; then
    rm -rfv $PYENV_VIRTUALENV_CACHE_PATH &>/dev/null
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------------Clear NPM cache----------------------
# ----------------------------------------------------------
echo '--- Clear NPM cache'
if type "npm" &> /dev/null; then
    npm cache clean --force
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------------Clear Yarn cache---------------------
# ----------------------------------------------------------
echo '--- Clear Yarn cache'
if type "yarn" &> /dev/null; then
    echo 'Cleanup Yarn Cache...'
    yarn cache clean --force
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Clear iOS app copies from iTunes-------------
# ----------------------------------------------------------
echo '--- Clear iOS app copies from iTunes'
rm -rfv ~/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear iOS photo cache-------------------
# ----------------------------------------------------------
echo '--- Clear iOS photo cache'
rm -rf ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------------Clear iOS Device Backups-----------------
# ----------------------------------------------------------
echo '--- Clear iOS Device Backups'
rm -rfv ~/Library/Application\ Support/MobileSync/Backup/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear iOS simulators-------------------
# ----------------------------------------------------------
echo '--- Clear iOS simulators'
if type "xcrun" &>/dev/null; then
    osascript -e 'tell application "com.apple.CoreSimulator.CoreSimulatorService" to quit'
    osascript -e 'tell application "iOS Simulator" to quit'
    osascript -e 'tell application "Simulator" to quit'
    xcrun simctl shutdown all
    xcrun simctl erase all
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Clear list of connected iOS devices------------
# ----------------------------------------------------------
echo '--- Clear list of connected iOS devices'
sudo defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
sudo defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist Devices
sudo defaults delete /Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
sudo defaults delete /Library/Preferences/com.apple.iPod.plist Devices
sudo rm -rfv /var/db/lockdown/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear diagnostics logs------------------
# ----------------------------------------------------------
echo '--- Clear diagnostics logs'
sudo rm -rfv /private/var/db/diagnostics/*
sudo rm -rfv /var/db/diagnostics/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Clear shared cache strings data--------------
# ----------------------------------------------------------
echo '--- Clear shared cache strings data'
sudo rm -rfv /private/var/db/uuidtext/
sudo rm -rfv /var/db/uuidtext/
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear Apple System Logs (ASL)---------------
# ----------------------------------------------------------
echo '--- Clear Apple System Logs (ASL)'
sudo rm -rfv /private/var/log/asl/*
sudo rm -rfv /var/log/asl/*
sudo rm -fv /var/log/asl.log # Legacy ASL (10.4)
sudo rm -fv /var/log/asl.db
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Clear install logs--------------------
# ----------------------------------------------------------
echo '--- Clear install logs'
sudo rm -fv /var/log/install.log
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Clear all system logs in `/var/log/` directory------
# ----------------------------------------------------------
echo '--- Clear all system logs in `/var/log/` directory'
sudo rm -rfv /var/log/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear Chrome browsing history---------------
# ----------------------------------------------------------
echo '--- Clear Chrome browsing history'
rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/History &>/dev/null
rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/History-journal &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Clear Chrome cache--------------------
# ----------------------------------------------------------
echo '--- Clear Chrome cache'
sudo rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/Application\ Cache/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear Safari browsing history---------------
# ----------------------------------------------------------
echo '--- Clear Safari browsing history'
rm -f ~/Library/Safari/History.db
rm -f ~/Library/Safari/History.db-lock
rm -f ~/Library/Safari/History.db-shm
rm -f ~/Library/Safari/History.db-wal
# For older versions of Safari
rm -f ~/Library/Safari/History.plist # URL, visit count, webpage title, last visited timestamp, redirected URL, autocomplete
rm -f ~/Library/Safari/HistoryIndex.sk # History index
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear Safari downloads history--------------
# ----------------------------------------------------------
echo '--- Clear Safari downloads history'
rm -f ~/Library/Safari/Downloads.plist
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------Clear Safari frequently visited sites-----------
# ----------------------------------------------------------
echo '--- Clear Safari frequently visited sites'
rm -f ~/Library/Safari/TopSites.plist
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------------Clear Safari history copy-----------------
# ----------------------------------------------------------
echo '--- Clear Safari history copy'
rm -rfv ~/Library/Caches/Metadata/Safari/History
# ----------------------------------------------------------


# ----------------------------------------------------------
# -Clear search term history embedded in Safari preferences-
# ----------------------------------------------------------
echo '--- Clear search term history embedded in Safari preferences'
defaults write ~/Library/Preferences/com.apple.Safari RecentSearchStrings '( )'
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear Safari cookies-------------------
# ----------------------------------------------------------
echo '--- Clear Safari cookies'
rm -f ~/Library/Cookies/Cookies.binarycookies
# Used before Safari 5.1
rm -f ~/Library/Cookies/Cookies.plist
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Clear Safari zoom level preferences per site-------
# ----------------------------------------------------------
echo '--- Clear Safari zoom level preferences per site'
rm -f ~/Library/Safari/PerSiteZoomPreferences.plist
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Clear allowed URLs for Safari notifications--------
# ----------------------------------------------------------
echo '--- Clear allowed URLs for Safari notifications'
rm -f ~/Library/Safari/UserNotificationPreferences.plist
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear Firefox cache--------------------
# ----------------------------------------------------------
echo '--- Clear Firefox cache'
sudo rm -rf ~/Library/Caches/Mozilla/
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/netpredictions.sqlite
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------------Clear Firefox form history----------------
# ----------------------------------------------------------
echo '--- Clear Firefox form history'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/formhistory.sqlite
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/formhistory.dat
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------------Clear Firefox passwords------------------
# ----------------------------------------------------------
echo '--- Clear Firefox passwords'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons2.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons3.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons.sqlite
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/logins.json
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear Firefox HTML5 cookies----------------
# ----------------------------------------------------------
echo '--- Clear Firefox HTML5 cookies'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/webappsstore.sqlite
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear Firefox crash reports----------------
# ----------------------------------------------------------
echo '--- Clear Firefox crash reports'
rm -rfv ~/Library/Application\ Support/Firefox/Crash\ Reports/
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/minidumps/*.dmp
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Clear Safari cached blobs, URLs and timestamps------
# ----------------------------------------------------------
echo '--- Clear Safari cached blobs, URLs and timestamps'
rm -f ~/Library/Caches/com.apple.Safari/Cache.db
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Clear Safari URL bar web page icons------------
# ----------------------------------------------------------
echo '--- Clear Safari URL bar web page icons'
rm -f ~/Library/Safari/WebpageIcons.db
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------Clear Safari webpage previews (thumbnails)--------
# ----------------------------------------------------------
echo '--- Clear Safari webpage previews (thumbnails)'
rm -rfv ~/Library/Caches/com.apple.Safari/Webpage\ Previews
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------Disable Parallels Desktop advertisements---------
# ----------------------------------------------------------
echo '--- Disable Parallels Desktop advertisements'
defaults write 'com.parallels.Parallels Desktop' 'ProductPromo.ForcePromoOff' -bool yes
defaults write 'com.parallels.Parallels Desktop' 'WelcomeScreenPromo.PromoOff' -bool yes
# ----------------------------------------------------------


# ----------------------------------------------------------
# Disable automatic downloads for Parallels Desktop updates-
# ----------------------------------------------------------
echo '--- Disable automatic downloads for Parallels Desktop updates'
defaults write 'com.parallels.Parallels Desktop' 'Application preferences.Download updates automatically' -bool no
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable automatic checks for Parallels Desktop updates--
# ----------------------------------------------------------
echo '--- Disable automatic checks for Parallels Desktop updates'
defaults write 'com.parallels.Parallels Desktop' 'Application preferences.Check for updates' -int 0
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------Disable remote management service-------------
# ----------------------------------------------------------
echo '--- Disable remote management service'
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Remove Apple Remote Desktop Settings-----------
# ----------------------------------------------------------
echo '--- Remove Apple Remote Desktop Settings'
sudo rm -rf /var/db/RemoteManagement
sudo defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist
sudo rm -rf /Library/Application\ Support/Apple/Remote\ Desktop/
rm -r ~/Library/Application\ Support/Remote\ Desktop/
rm -r ~/Library/Containers/com.apple.RemoteDesktop
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Disable participation in Siri data collection-------
# ----------------------------------------------------------
echo '--- Disable participation in Siri data collection'
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Disable "Ask Siri"--------------------
# ----------------------------------------------------------
echo '--- Disable "Ask Siri"'
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Disable Siri voice feedback----------------
# ----------------------------------------------------------
echo '--- Disable Siri voice feedback'
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disable "Do you want to enable Siri?" pop-up-------
# ----------------------------------------------------------
echo '--- Disable "Do you want to enable Siri?" pop-up'
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------------Remove Siri from menu bar-----------------
# ----------------------------------------------------------
echo '--- Remove Siri from menu bar'
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Remove Siri from status menu---------------
# ----------------------------------------------------------
echo '--- Remove Siri from status menu'
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Enable application firewall----------------
# ----------------------------------------------------------
echo '--- Enable application firewall'
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------------Enable firewall logging------------------
# ----------------------------------------------------------
echo '--- Enable firewall logging'
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Enable stealth mode--------------------
# ----------------------------------------------------------
echo '--- Enable stealth mode'
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true
# ----------------------------------------------------------


# Enable password requirement for waking from sleep or screen saver
echo '--- Enable password requirement for waking from sleep or screen saver'
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true
# ----------------------------------------------------------


# Enable session lock five seconds after screen saver initiation
echo '--- Enable session lock five seconds after screen saver initiation'
sudo defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------Disable guest sign-in from login screen----------
# ----------------------------------------------------------
echo '--- Disable guest sign-in from login screen'
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disable guest access to file shares over AF--------
# ----------------------------------------------------------
echo '--- Disable guest access to file shares over AF'
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disable guest access to file shares over SMB-------
# ----------------------------------------------------------
echo '--- Disable guest access to file shares over SMB'
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disable incoming SSH and SFTP remote logins--------
# ----------------------------------------------------------
echo '--- Disable incoming SSH and SFTP remote logins'
echo 'yes' | sudo systemsetup -setremotelogin off
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------Disable the insecure TFTP service-------------
# ----------------------------------------------------------
echo '--- Disable the insecure TFTP service'
sudo launchctl disable 'system/com.apple.tftpd'
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------Disable Bonjour multicast advertising-----------
# ----------------------------------------------------------
echo '--- Disable Bonjour multicast advertising'
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Disable insecure telnet protocol-------------
# ----------------------------------------------------------
echo '--- Disable insecure telnet protocol'
sudo launchctl disable system/com.apple.telnetd
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----Disable local printer sharing with other computers----
# ----------------------------------------------------------
echo '--- Disable local printer sharing with other computers'
cupsctl --no-share-printers
# ----------------------------------------------------------


# Disable printing from external addresses, including the internet
echo '--- Disable printing from external addresses, including the internet'
cupsctl --no-remote-any
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------Disable remote printer administration-----------
# ----------------------------------------------------------
echo '--- Disable remote printer administration'
cupsctl --no-remote-admin
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable automatic incoming connections for signed apps--
# ----------------------------------------------------------
echo '--- Disable automatic incoming connections for signed apps'
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false
# ----------------------------------------------------------


# Disable automatic incoming connections for downloaded signed apps
echo '--- Disable automatic incoming connections for downloaded signed apps'
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# -Clear logs of all downloaded files from File Quarantine--
# ----------------------------------------------------------
echo '--- Clear logs of all downloaded files from File Quarantine'
db_file=~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
db_query='delete from LSQuarantineEvent'
if [ -f "$db_file" ]; then
    echo "Database exists at \"$db_file\""
    if ls -lO "$db_file" | grep --silent 'schg'; then
        sudo chflags noschg "$db_file"
        echo "Found and removed system immutable flag"
        has_system_immutable_flag=true
    fi
    if ls -lO "$db_file" | grep --silent 'uchg'; then
        sudo chflags nouchg "$db_file"
        echo "Found and removed user immutable flag"
        has_user_immutable_flag=true
    fi
    sqlite3 "$db_file" "$db_query"
    echo "Executed the query \"$db_query\""
    if [ "$has_system_immutable_flag" = true ] ; then
        sudo chflags schg "$db_file"
        echo "Added system immutable flag back"
    fi
    if [ "$has_user_immutable_flag" = true ] ; then
        sudo chflags uchg "$db_file"
        echo "Added user immutable flag back"
    fi
else
    echo "No action needed, database does not exist at \"$db_file\""
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Clear File Quarantine attribute from downloaded files---
# ----------------------------------------------------------
echo '--- Clear File Quarantine attribute from downloaded files'
find ~/Downloads        \
        -type f         \
        -exec           \
            sh -c       \
                '
                    attr="com.apple.quarantine"
                    file="{}"
                    if [[ $(xattr "$file") = *$attr* ]]; then
                        if xattr -d "$attr" "$file" 2>/dev/null; then
                            echo "🧹 Cleaned attribute from \"$file\""
                        else
                            >&2 echo "❌ Failed to clean attribute from \"$file\""
                        fi
                    else
                        echo "No attribute in \"$file\""
                    fi
                '       \
            {} \;
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Disable downloaded file logging in quarantine-------
# ----------------------------------------------------------
echo '--- Disable downloaded file logging in quarantine'
file_to_lock=~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
if [ -f "$file_to_lock" ]; then
    sudo chflags schg "$file_to_lock"
    echo "Made file immutable at \"$file_to_lock\""
else
    echo "No action is needed, file does not exist at \"$file_to_lock\""
fi
# ----------------------------------------------------------


# Disable extended quarantine attribute for downloaded files (disables warning)
echo '--- Disable extended quarantine attribute for downloaded files (disables warning)'
sudo defaults write com.apple.LaunchServices 'LSQuarantine' -bool NO
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disable Gatekeeper's automatic reactivation--------
# ----------------------------------------------------------
echo '--- Disable Gatekeeper'\''s automatic reactivation'
sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Disable Gatekeeper--------------------
# ----------------------------------------------------------
echo '--- Disable Gatekeeper'
os_major_ver=$(sw_vers -productVersion | awk -F "." '{print $1}')
os_minor_ver=$(sw_vers -productVersion | awk -F "." '{print $2}')
if [[ $os_major_ver -le 10 \
        || ( $os_major_ver -eq 10 && $os_minor_ver -lt 7 ) \
    ]]; then
    echo "No action needed, Gatekeeper is not available this OS version"
else
    gatekeeper_status="$(spctl --status | awk '/assessments/ {print $2}')"
    if [ $gatekeeper_status = "disabled" ]; then
        echo "No action needed, Gatekeeper is already disabled"
    elif [ $gatekeeper_status = "enabled" ]; then
        sudo spctl --master-disable
        sudo defaults write '/var/db/SystemPolicy-prefs' 'enabled' -string 'no'
        echo "Disabled Gatekeeper"
    else
        >&2 echo "Unknown gatekeeper status: $gatekeeper_status"
    fi
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------Disable Microsoft Office telemetry------------
# ----------------------------------------------------------
echo '--- Disable Microsoft Office telemetry'
defaults write com.microsoft.office DiagnosticDataTypePreference -string ZeroDiagnosticData
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------Remove Google Software Update service-----------
# ----------------------------------------------------------
echo '--- Remove Google Software Update service'
googleUpdateFile=~/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/ksinstall
if [ -f "$googleUpdateFile" ]; then
    $googleUpdateFile --nuke
    echo 'Uninstalled Google update'
else
    echo 'Google update file does not exist'
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------Disable Siri services (Siri and assistantd)--------
# ----------------------------------------------------------
echo '--- Disable Siri services (Siri and assistantd)'
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
sudo launchctl disable 'system/com.apple.assistantd'
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"
sudo launchctl disable 'system/com.apple.Siri.agent'
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
    >&2 echo 'This script requires SIP to be disabled. Read more: https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Disable automatic checks for updates (revert)-------
# ----------------------------------------------------------
echo '--- Disable automatic checks for updates (revert)'
# For OS X Yosemite and newer (>= 10.10)
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'AutomaticCheckEnabled' -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----Disable automatic downloads for updates (revert)-----
# ----------------------------------------------------------
echo '--- Disable automatic downloads for updates (revert)'
# For OS X Yosemite and newer (>= 10.10)
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'AutomaticDownload' -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -Disable automatic installation of macOS updates (revert)-
# ----------------------------------------------------------
echo '--- Disable automatic installation of macOS updates (revert)'
# For OS X Yosemite through macOS High Sierra (>= 10.10 && < 10.14)
sudo defaults write /Library/Preferences/com.apple.commerce 'AutoUpdateRestartRequired' -bool true
# For Mojave and newer (>= 10.14)
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'AutomaticallyInstallMacOSUpdates' -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# Disable automatic app updates from the App Store (revert)-
# ----------------------------------------------------------
echo '--- Disable automatic app updates from the App Store (revert)'
# For OS X Yosemite and newer
sudo defaults write /Library/Preferences/com.apple.commerce 'AutoUpdate' -bool true
# For Mojave and newer (>= 10.14)
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'AutomaticallyInstallAppUpdates' -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----Disable macOS beta release installation (revert)-----
# ----------------------------------------------------------
echo '--- Disable macOS beta release installation (revert)'
# For OS X Yosemite and newer (>= 10.10)
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'AllowPreReleaseInstallation' -bool true
# ----------------------------------------------------------


# Disable automatic installation for configuration data (e.g. XProtect, Gatekeeper, MRT) (revert)
echo '--- Disable automatic installation for configuration data (e.g. XProtect, Gatekeeper, MRT) (revert)'
# For OS X Yosemite and newer (>= 10.10)
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'ConfigDataInstall' -bool true
# ----------------------------------------------------------


# Disable automatic installation for system data files and security updates (revert)
echo '--- Disable automatic installation for system data files and security updates (revert)'
# For OS X Yosemite and newer (>= 10.10)
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'CriticalUpdateInstall' -bool true
# Trigger background check with normal scan (critical updates only)
sudo softwareupdate --background-critical
# ----------------------------------------------------------


echo 'Your privacy and security is now hardened 🎉💪'
echo 'Press any key to exit.'
read -n 1 -s