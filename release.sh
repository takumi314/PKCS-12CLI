#!/bin/sh

# build
echo "building ...."
swift build --disable-sandbox --configuration release

# binary location
if [[ ! -e ./binary ]]; then
   echo "Create ./binary directory"
   mkdir ./binary
fi
cp -f .build/release/p12_importer ./binary

if [[ -e ./binary/p12_importer ]]; then
    echo "Completed🎉🎉🎉🎉"
fi
