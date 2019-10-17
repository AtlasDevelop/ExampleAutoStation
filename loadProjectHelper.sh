#!/bin/sh

#captureFolder="$HOME/Library/Atlas/Backups/$(date +%Y%m%d-%H%M%S)"

homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function echoerr { echo "$@" 1>&2; }

function copyFolder {
    #mv "$HOME/Library/Atlas/$1" "$captureFolder/$1"
    rm -r "$HOME/Library/Atlas/$1"
    if [[ -d "$root/$1" ]]; then
        cp -r "$root/$1/" "$HOME/Library/Atlas/$1/"
    else
        mkdir "$HOME/Library/Atlas/$1"
    fi
}

function init {
    #mkdir -p "$captureFolder"

    # Clear out and copy new files
    copyFolder Sequences
    copyFolder Resources
    copyFolder ParseDefinitions


    # Clear out plugins
    #mv "$HOME/Library/Atlas/Plugins" "$captureFolder/Plugins"
    rm -r "$HOME/Library/Atlas/Plugins"
    mkdir -p "$HOME/Library/Atlas/Plugins"


    # Compile plugins (if needed) and copy in new ones
    # OUTPUT=$("$HOME/Library/Atlas/Developer/Plugins/build" --lazy)
    # if [[ $? != 0 ]]; then
    #     echoerr "Error compiling Developer plugins"
    #     echoerr $OUTPUT
    #     exit 1
    # fi
}

function copyDeveloperPlugin {
    cp -R "$homePath/bundles/$1" "$HOME/Library/Atlas/Plugins/$1"
    if [[ $? != 0 ]]; then
        echoerr "Error copying Developer plugin: $1"
        exit 1
    fi
}

function sign {
    # Sign the files if Atlas dev tools are installed
    dynamicPassword=$(uuidgen)
    metadata="/usr/local/bin/atlas-metadata"
    signer="/usr/local/bin/atlas-signer"
    if [[ -f "$metadata" && -f "$signer" ]]; then
        $metadata -p "$dynamicPassword" -f ~/Library/Atlas/Resources/ -kb mykey,000102030405060708090A0B0C0D0E0F10111213
        if [[ $? != 0 ]]; then
            echoerr "Failed to create metadata file"
            exit 1
        fi
        $signer -t "$HOME/Library/Atlas" -p "$dynamicPassword"
        if [[ $? != 0 ]]; then
            echoerr "Failed to sign folder"
            exit 1
        fi
    fi
}
