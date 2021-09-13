#!/usr/bin/env bash

function isRoot () {
        if [ "$EUID" -ne 0 ]; then
                return 1
        fi
}

banner()
{
  echo "+------------------------------------------+"
  printf "| %-40s |\n" "`date`"
  echo "|                                          |"
  printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "+------------------------------------------+"
}

banner="$(banner "Pentest Cleanup Script")"

RED='\033[41m'
NC='\033[0m' # No Color
BLUEB='\033[44m'
BLUE='\033[0;34m' 

logs=()

function clearLogs () {
        echo
        printf "${BLUEB}[!] The following paths will be cleaned (if existing): ${NC}\n"
        logs="$(cat standard.txt)"
        echo "$logs"
        echo "~/.zsh_history"
        echo "~/.bash_history"
        echo "history -c"
        echo

        while true; do
                read -p "$(echo -e $RED"[!] Are you sure? Please answer Y/N:$NC ")" yn
                case $yn in
                        [Yy]* ) echo; printf "${BLUEB}[!] Cleaning Logs ${NC}\n"; break;;
                        [Nn]* ) echo; printf "${BLUE}[-] Exiting... ${NC}\n"; exit;;
                        * ) printf "[!] Please answer yes or no.\n\n";;
                esac
        done

        for i in $logs
        do
                if [ -f "$i" ]; then
                        if [ -w "$i" ]; then
                                rm "${i:?}"
                                
                                echo "[+] $i cleaned."
                        else
                                printf "[!] ${RED}$i$ is not writable! Retry using sudo.${NC}\n"
                        fi
                elif [ -d "$i" ]; then
                        if [ -w "$i" ]; then
                                rm -rf "${i:?}"/*
                                echo "[+] $i cleaned."
                        else
                                printf "[!] ${RED}$i$ is not writable! Retry using sudo.${NC}\n"
                        fi
                fi
        done

        if [ -f ~/.zsh_history ]; then
                echo "" > ~/.zsh_history
                echo "[+] ~/.zsh_history cleaned."
        fi

        echo "" > ~/.bash_history
        echo "[+] ~/.bash_history cleaned."

        history -c
        printf "[+] History file deleted.\n"
}

tools=()

function cleanTools () {
        echo
        printf "${BLUEB}[!] Searching... ${NC}\n"
        echo
        tools="$(bash paths.txt)"
        printf "${BLUEB}[!] The following paths have been found: ${NC}\n"
        echo "$tools"
        echo

        while true; do
                read -p "$(echo -e $RED"[!] Are you sure? Please answer Y/N:$NC ")" yn
                case $yn in
                        [Yy]* ) echo; printf "${BLUEB}[!] Cleaning Tools ${NC}\n"; break;;
                        [Nn]* ) echo; printf "${BLUE}[-] Exiting...${NC}\n"; exit;;
                        * ) printf "[!] Please answer yes or no.\n\n";;
                esac
        done
        
        for i in $tools
        do
                if [ -f "$i" ]; then
                        if [ -w "$i" ]; then
                                rm "${i:?}"
                                
                                echo "[+] $i cleaned."
                        else
                                printf "[!] ${RED}$i$ is not writable! Retry using sudo.${NC}\n"
                        fi
                elif [ -d "$i" ]; then
                        if [ -w "$i" ]; then
                                rm -rf "${i:?}"/*
                                echo "[+] $i cleaned."
                        else
                                printf "[!] ${RED}$i$ is not writable! Retry using sudo.${NC}\n"
                        fi
                fi
        done
}

clear # Clear output

if (( $# != 1 )); then
        echo "$banner"
        printf "\n${RED}[!] Please choose 1 option for cleaning: -t for tools, -s for standard or -a for all (both).${NC}\n"
else
        if [ -n "$1" ] && [ "$1" == '-s' ]; then
                echo "$banner"
                clearLogs
                exit
        elif [ -n "$1" ] && [ "$1" == '-t' ]; then
                echo "$banner"
                cleanTools
                exit 
        elif [ -n "$1" ] && [ "$1" == '-a' ]; then
                echo "$banner"
                clearLogs
                cleanTools
                exit
        fi
fi