#!/bin/sh
#* AppleUserTemplateScreensaver
#+ chris.gerke@gmail.com
#+
#+ Description: Payload required. Standard Screensaver.
#+
#+ Version: 1.0
#+
#+ History:
#+     1.0: Script.
#+
#+ TODO:
#+     * Add error checking?

ME=$0
SCRIPT_DIR="$1/Contents/Resources"
TARGET_DIR="$3"

#+ // fix
if [ -z "${TARGET_DIR}" ] || [ "${TARGET_DIR}" = "/" ]; then
 TARGET_DIR=""
fi

#* Detect payload & copy
if [ -r "${SCRIPT_DIR}/PAYLOAD" ]; then
 #+ TARGET_DIR
 sudo /bin/mkdir -p "${TARGET_DIR}/usr/local/bin"
 #+ Payload
 sudo /bin/cp -Rf "${SCRIPT_DIR}/PAYLOAD/screensaver" "${TARGET_DIR}/usr/local/bin/screensaver"
 #+ Payload
 sudo /bin/cp -Rf "${SCRIPT_DIR}/PAYLOAD/Default.slideSaver" "${TARGET_DIR}/Library/Screen Savers/Default.slideSaver"
fi

#+ LaunchDaemon
sudo /usr/bin/defaults write "${TARGET_DIR}/Library/LaunchAgents/ScreenSaver" Label "com.chrisgerke.ScreenSaver"
sudo /usr/bin/defaults write "${TARGET_DIR}/Library/LaunchAgents/ScreenSaver" RunAtLoad -bool TRUE
sudo /usr/bin/defaults write "${TARGET_DIR}/Library/LaunchAgents/ScreenSaver" ProgramArguments -array "/bin/sh" "-c" "/usr/local/bin/screensaver"

#+ Permissions
sudo /usr/sbin/chown root:wheel "${TARGET_DIR}/Library/LaunchAgents/ScreenSaver.plist"
sudo /bin/chmod 644 "${TARGET_DIR}/Library/LaunchAgents/ScreenSaver.plist" 

#+ Load Daemon
sudo /bin/launchctl load -w "${TARGET_DIR}/Library/LaunchAgents/ScreenSaver.plist"

exit 0
