#!/bin/bash

rm rf ./tmp
git clone https://github.com/longnguyen245/windows-autosetup tmp
rm -rf ./bin ./assets
cp ./tmp/bin ../
cp ./tmp/assets ../
cp ./tmp/*.cmd ../
cp ./tmp/*.md ../
rm -rf ./tmp

echo "Update done"