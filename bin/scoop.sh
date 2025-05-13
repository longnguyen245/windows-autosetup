#!/bin/bash

scoop_install() {
    for package in "$@"; do
        scoop install $package
    done
}

scoop_install_admin() {
    for package in "$@"; do
        gsudo scoop install $package
    done
}
