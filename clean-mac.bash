#!/bin/bash
# ┌────────────────────────────────────────────┐
# │  Made by Mike <yum650350@github> in 2021   |
# └────────────────────────────────────────────┘

FOLDERS=(
    # XCode caches
    # https://ktatsiu.wordpress.com/2017/01/03/how-to-clean-up-tons-of-disk-space-from-xcode/
    ~/Library/Developer/Xcode/DerivedData
    ~/Library/Logs/CoreSimulator
    ~/Library/Developer/Xcode/iOS\ DeviceSupport
    ~/Library/Developer/Xcode/iOS\ Device\ Logs
    ~/Library/Caches/com.apple.dt.XCode
    ~/Library/Developer/Xcode/Archives
    $(getconf DARWIN_USER_CACHE_DIR)org.llvm.clang/ModuleCache
    $(getconf DARWIN_USER_CACHE_DIR)org.llvm.clang.$(whoami)/ModuleCache
    # Others
    ~/Library/Developer/CoreSimulator
    ~/Library/Application\ Support/Flipper
    ~/Library/Containers/com.apple.AppStore/Data/Library/Caches
    ~/Library/Logs
    /var/log
    /System/Library/Caches/com.apple.coresymbolicationd
    /Library/Caches/com.apple.iconservices.store
)

CAN_REMOVE=false
PRINT_FOLDERS=""
for ((i = 0; i < ${#FOLDERS[@]}; i++)); do
    if [ -d "${FOLDERS[$i]}" ]; then
        PRINT_FOLDERS+="\e[0m\e[96mo\t$(sudo du -hs "${FOLDERS[$i]}")\n"
        CAN_REMOVE=true
    else
        PRINT_FOLDERS+="\e[2m\e[39mx\tNONE\t"${FOLDERS[$i]}"\n"
    fi
done

if [ "$CAN_REMOVE" = false ]; then
    printf "\e[0mFolders are all removed\n"
    exit
fi

printf "\e[0m┌──────────────────────┐\n"
printf "│  Folder(s) to remove │\n"
printf "│ \e[0m\e[96mo : Folder exists    \e[0m│\n"
printf "│ \e[2m\e[39mx : Folder not found \e[0m│\n"
printf "└──────────────────────┘\n"
printf "$PRINT_FOLDERS"
printf "\e[0mDo \e[1mrm -rf\e[0m to all the existing folders above? (y/n)\n"

while true; do
    read -n 1 -r -s
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "\e[0mStart removing folder(s)\n"
        sleep 2
        printf "\e[0mRemoving folder(s)\n"
        for ((i = 0; i < ${#FOLDERS[@]}; i++)); do
            sudo rm -rf "${FOLDERS[$i]}"
        done
        printf "\e[0mComplete\n"
        break
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
        break
    fi
done
