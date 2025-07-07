#!/bin/bash

SYNTAX="
`basename $0` OPTION
    copy <remote>   copy all files from remotes to dest folder
    move <remote>   move all files from remotes to dest folder
    list <remote>   list files in remotes
    list            list remotes

    es: $0 copy gais
"
if [ -z "$1" ]; then
    echo "${SYNTAX}"
    exit
fi

if [[ "$1" == "copy" ]]; then
    if [[ ! -z "$2" ]]; then
        rclone copy $2: /dest/
        exit 0
     else
        echo "${SYNTAX}"
        exit 1
    fi
elif [[ "$1" == "move" ]] ; then
    if [[ ! -z "$2" ]]; then
        rclone move $2: /dest/
        exit 0
     else
        echo "${SYNTAX}"
        exit 1
    fi
elif [[ "$1" == "list" ]] ; then
    if [[ ! -z "$2" ]]; then
        rclone ls $2:
        exit 0
     else
        rclone listremotes
        exit 0
    fi
else
    echo "${SYNTAX}"
    exit 1
fi

