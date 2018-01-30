#!/bin/bash

bold=$(tput bold)
yellow='\033[1;33m'
red='\033[0;31m'
green='\033[0;32m'
nocolor='\033[0m'


IF=$1
MAC=$2

if [ "$IF" == "" ]; then
        IF="-"
fi
if [ "$MAC" == "" ]; then
        MAC="-"
        MACERR="${red}Please specify a MAC-Adress to set${nocolor}"
fi


DIR="/sys/class/net/$IF/"

if [ -d "$DIR" ]; then
        ifcolor=$green
        OLDMAC=$(cat /sys/class/net/$IF/address)
        IFERR=""
else
        if [ $IF != "" ] && [ $IF != "-" ]; then
                ifcolor=$red
                IFERR="${red}Interface not existing!${nocolor}"
                echo ""
        fi
        if [ $IF == "-" ] && [ $IF != "" ]; then
                ifcolor=$nocolor
                IFERR="${red}Please specify an Interface!${nocolor}"
        fi
fi

if [ "$OLDMAC" == "" ]; then
        OLDMAC="-"
fi

echo ""
printf "${bold}INPUT${nocolor}\n"
echo "======================================"
printf "INTERFACE:  ${ifcolor}$IF${nocolor}   $IFERR\n"
echo "OLD-MAC:    $OLDMAC"
printf "NEW-MAC:    $MAC   $MACERR\n"

if [ $# -eq 2 ] && [ $OLDMAC != "-" ]; then
        ifconfig wlan0 down
        ifconfig wlan0 hw ether $MAC
        ifconfig wlan0 up
        if [ $(cat /sys/class/net/$IF/address) = $MAC ]; then
                echo ""
                echo "New MAC applied!"
                echo ""
        else
                echo "Please enter a valid MAC!"
        fi
else
#       if [ "$IF" == "-" ] || [ "$MAC" == "-" ]; then
#               printf "\n${red}Please specify a MAC-Adress to set${nocolor}\n"
#       fi
        echo ""
        printf "${bold}USAGE${nocolor}\n"
        printf "   ${bold}./macchanger ${yellow}<INTERFACE> <NEW-MAC XX:XX:XX:XX:XX:XX>${nocolor}\n"
        echo ""
fi
