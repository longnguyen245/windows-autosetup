#!/bin/bash

rm rf ./tmp
git clone https://github.com/longnguyen245/windows-autosetup tmp
rm -rf ./bin ./assets
cp -r ./tmp/bin ./
cp -r ./tmp/assets ./
cp ./tmp/*.cmd ./
cp ./tmp/*.md ./
rm -rf ./tmp

source ./bin/afterUpdateSource.sh
echo "Update done"