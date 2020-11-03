#!/bin/sh

echo "Building MiCasaHttpPlugin"
swift build -c release

echo "Installing to /usr/local..."
mkdir -p /usr/local/lib/micasa
cp .build/x86_64-unknown-linux-gnu/release/libMiCasaHttpSwitch.so /usr/local/lib/micasa/libMiCasaHttpSwitch.mcplugin

