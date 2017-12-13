#!/usr/bin/env bash

########################
# include the magic
########################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/demo-magic.sh

########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
# TYPE_SPEED=20

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="➜ ${CYAN}\W "

# hide the evidence
clear

# COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

WORKING_DIR=`pwd`
LIVE_DIRECTORY_ROOT='public_html'
MAGENTO_DIR=magento

: '
########################
# Manually
########################
PROMPT_TIMEOUT=0
pe "ls -lah"
pe "cd ${LIVE_DIRECTORY_ROOT}"
cd ${MAGENTO_DIR}
pe "bin/magento maintenance:enable"
cd ${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
p "git pull"
echo "wait..."
wait
p "composer install --no-dev"
echo "wait..."
wait 
cd ${MAGENTO_DIR}
p "bin/magento setup:di:compile"
echo "wait..."
wait
p "bin/magento setup:static-content:deploy en_US de_CH"
echo "wait..."
wait
p "set-permissions"
echo "find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;"
echo "wait..."
wait
p "bin/magento setup:upgrade --keep-generated"
echo "wait..."
wait
pe "bin/magento maintenance:disable"
echo ""
printf "${Yellow}Release finish - Downtime: [15min - 1hour]"
'
########################
# Simple Automation
########################
PROMPT_TIMEOUT=2
p "deploy.sh"
echo "cd ${LIVE_DIRECTORY_ROOT}"
printf "${MAGENTO_DIR}/bin/magento maintenance:enable\n"
printf "${Green}Enabled maintenance mode${Color_Off}\n"

printf "git pull\n"
printf "wait...\n\n"
wait
printf "composer install --no-dev\n"
printf "wait...\n\n"
wait 
printf "${MAGENTO_DIR}/bin/magento setup:di:compile\n"
printf "wait...\n\n"
wait
printf "${MAGENTO_DIR}/bin/magento setup:static-content:deploy en_US de_CH\n"
printf "wait...\n\n"
wait
printf "find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;\n"
printf "wait...\n\n"
wait
printf "${MAGENTO_DIR}/bin/magento setup:upgrade --keep-generated\n"
printf "wait...\n\n"
wait
printf "${MAGENTO_DIR}/bin/magento maintenance:disable\n"
printf "${Green}Disabled maintenance mode${Color_Off}\n"
echo ""
printf "${Yellow}Release finish - Downtime: [15min - 1hour]\n"
