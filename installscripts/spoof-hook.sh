#! /bin/sh

# Turn off Wi-Fi interface
blueutil --power 0
networksetup -setairportpower en0 off
