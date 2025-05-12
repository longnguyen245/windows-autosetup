#!/bin/bash

scoop_nstall() {
    for package in "$@"; do
        scoop install $package
    done
}

scoop_install_admin() {
    for package in "$@"; do
        sudo scoop install $package
    done
}
