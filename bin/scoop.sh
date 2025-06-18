#!/bin/bash

scoop_install() {
    for package in "$@"; do
        if [ -d "$SCOOP_APPS/$package" ]; then
            log DEBUG "$package installed"
        else
            scoop install $package
        fi
    done
}

scoop_install_admin() {
    for package in "$@"; do
        if [ -d "$SCOOP_APPS/$package" ]; then
            log DEBUG "$package installed"
        else
            gsudo scoop install $package
        fi
    done
}
