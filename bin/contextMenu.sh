add_context_menu_app() {
    local app="$1"
    local exe="$2"
    local icon="$3"

    REAL_APP="$SCOOP_APPS/$app/current"
    FAKE_APP="$SCOOP_APPS/$app-fakeapp"

    log INFO $FAKE_APP
    rm -rf $FAKE_APP
    mkdir $FAKE_APP
    cp $ASSETS/regs/install-context.reg $FAKE_APP/install-context.reg

    sed -i "s|APPNAME|$app|g" $FAKE_APP/install-context.reg
    sed -i "s|ICON|$icon|g" $FAKE_APP/install-context.reg
    sed -i "s|EXE|$exe|g" $FAKE_APP/install-context.reg
    sed -i "s|SCOOPAPP|$app|g" $FAKE_APP/install-context.reg
    sed -i "s|USERNAME|$USERNAME|g" $FAKE_APP/install-context.reg
}
