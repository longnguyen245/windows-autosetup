scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add java
scoop bucket add versions
scoop update

scoop_install wget2 openssl
scoop_install innounp-unicode                # Inno Setup Unpacker
scoop_install googlechrome brave firefox     # Browser
scoop_install dos2unix scrcpy adb gsudo jadx # Tool
scoop_install windows-terminal
scoop_install vscode vscodium fnm sublime-text postman heidisql sourcetree android-studio android-clt mongodb mongodb-compass warp-terminal # Coding
scoop_install python openjdk17                                                                                                              # Runtime lib
scoop_install telegram ayugram neatdownloadmanager anydesk bifrost dolphin beyondcompare                                                    # Apps
scoop_install Hack-NF firacode Cascadia-Code                                                                                                # Fonts

scoop_install_admin vcredist-aio # Windows libs

source $PC_DIR/acer.sh &
source $PC_DIR/custom.sh &
# add_context_menu_app vlc vlc.exe vlc.ico
