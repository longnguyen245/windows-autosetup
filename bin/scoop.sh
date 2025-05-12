#!/bin/bash

scoop-install() {
    for package in "$@"; do
        scoop install $package
    done
}

scoop-install-admin() {
    for package in "$@"; do
        sudo scoop install $package
    done
}
