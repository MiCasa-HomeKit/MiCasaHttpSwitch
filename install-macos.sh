#!/bin/sh

echo "Building MiCasaHttpPlugin"
swift build -c release

echo "Installing to /usr/local..."
mkdir -p /usr/local/lib/micasa
cp  .build/x86_64-apple-macosx/release/libMiCasaHttpSwitch.dylib /usr/local/lib/micasa/libMiCasaHttpSwitch.mcplugin

