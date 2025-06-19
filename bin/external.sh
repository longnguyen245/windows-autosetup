#!/bin/bash

download_external() {
    local file_name="$1"
    local url="$2"

    wget2 -O "$SETUP_TMP_DIR/$file_name" $url
}

extract() {
    local file_name="$1"
    unzip "$SETUP_TMP_DIR/$file_name" -d "$SETUP_TMP_DIR/$file_name.out"
}

get_extract_folder() {
    local file_name="$1"
    echo "$SETUP_TMP_DIR/$file_name.out"
}

download_file() {
    local url="$1"
    local output="$2"

    if command -v curl >/dev/null 2>&1; then
        curl -L -o "$output" "$url"
    else
        return 1
    fi
}
