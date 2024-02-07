#!/bin/bash

# Directory where BusyBox is installed
INSTALL_DIR="./_install"

# Find all symbolic links in the installation directory that point to the BusyBox binary
find "$INSTALL_DIR" -type l -exec ls -l {} + | awk '{print $9 " -> " $11}' | while read link; do
    target=$(readlink -f $(echo $link | awk '{print $1}'))
    if [[ "$target" == *"busybox" ]]; then
        # Extract and print the applet name from the link path
        echo $(basename $(echo $link | awk '{print $1}'))
    fi
done
