# $HOME
# $SCOOP_DIR
# $SCOOP_APPS
# $ASSETS
# $PC_DIR

scoop bucket add extras
scoop update

scoop_install googlechrome     # Browser

scoop_install_admin vcredist-aio # Windows libs

# Add context menu for some apps
# add_context_menu_app vlc vlc.exe vlc.ico
