# scoop bucket add extras
# scoop bucket add nerd-fonts
# scoop bucket add java
# scoop bucket add versions
# scoop update
scoop_add_bucket extras java 

scoop_install innounp-unicode                # Inno Setup Unpacker
scoop_install googlechrome firefox     # Browser
scoop_install scrcpy adb jadx # Tool
scoop_install vscode vscodium sublime-text postman heidisql sourcetree android-studio android-clt nodejs-lts # Coding
scoop_install python openjdk17                                                                                                              # Runtime lib
scoop_install ayugram neatdownloadmanager anydesk beyondcompare memreduct                                                    # Apps                                                                                               # Fonts

# scoop_install_admin vcredist-aio # Windows libs

(
source $PC_DIR/acer.sh 
)&
(
	source $PC_DIR/custom.sh
) &
# add_context_menu_app vlc vlc.exe vlc.ico

"$SCOOP_APPS/neatdownloadmanager/current/NeatDM.exe"