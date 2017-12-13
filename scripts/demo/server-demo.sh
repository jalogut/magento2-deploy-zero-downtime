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
TYPE_SPEED_ORIG=${TYPE_SPEED}

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

########################
# Manually
########################
: '
PROMPT_TIMEOUT=0
pe "ls -lah"
pe "cd ${LIVE_DIRECTORY_ROOT}"
pe "ls -lah"
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
pe "bin/magento cache:flush"
echo ""
printf "${Yellow}Release finish - Downtime: [15min - 30min]"

cd ${WORKING_DIR}

########################
# Simple Automation
########################
pbcopy < ${DIR}/../templates/deploy-0.sh
pe "vim deploy.sh"
chmod +x deploy.sh

p "simulate deploy.sh"
PROMPT_TIMEOUT=2
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
printf "${MAGENTO_DIR}/bin/magento cache:flush\n"
echo ""
printf "${Yellow}Release finish - Downtime: [15min - 30min]\n"

cd ${WORKING_DIR}
'
########################
# Right Deployment
########################
PROMPT_TIMEOUT=0

pe "mkdir releases"
pe "mv ${LIVE_DIRECTORY_ROOT} releases/1.0"
pe "ln -s releases/1.0 ${LIVE_DIRECTORY_ROOT}"

unset TYPE_SPEED
p "mkdir shared \\
mkdir -p shared/${MAGENTO_DIR}/app/etc \\
mkdir -p shared/${MAGENTO_DIR}/pub/media \\
mkdir -p shared/${MAGENTO_DIR}/var/log"

mkdir shared && mkdir -p shared/${MAGENTO_DIR}/app/etc && mkdir -p shared/${MAGENTO_DIR}/pub/media && mkdir -p shared/${MAGENTO_DIR}/var/log

p "mv ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php shared/${MAGENTO_DIR}/app/etc/env.php \\
mv ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media shared/${MAGENTO_DIR}/pub/media \\
mv ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log shared/${MAGENTO_DIR}/var/log"

mv ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php shared/${MAGENTO_DIR}/app/etc/env.php
mv ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media shared/${MAGENTO_DIR}/pub/media
mv ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log shared/${MAGENTO_DIR}/var/log

p "ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/app/etc/env.php ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php \\
ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/pub/media ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media \\
ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/var/log ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log"

ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/app/etc/env.php ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php
ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/pub/media ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media
ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/var/log ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log

TYPE_SPEED=${TYPE_SPEED_ORIG}
pe "ls -lah"
pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/"
pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub"
pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var"

pbcopy < ${DIR}/../chunks/chunk-deploy-1-1.sh
sleep 1
pbcopy < ${DIR}/../chunks/chunk-deploy-1-2.sh
sleep 1
pbcopy < ${DIR}/../chunks/chunk-deploy-1-3.sh
sleep 1
pbcopy < ${DIR}/../chunks/chunk-deploy-1-4.sh
sleep 1

pe "vim deploy.sh"
VERSION="1.1"
p "VERSION=${VERSION} simulate deploy.sh"
PROMPT_TIMEOUT=1

GIT_REPO=https://github.com/jalogut/deployment-magento-2-2.git
LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
TARGET=releases/${VERSION}

echo "git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${TARGET}"
printf "wait...\n\n"
wait
echo "cd ${TARGET}"
echo "composer install --no-dev --prefer-dist --optimize-autoloader"
printf "wait...\n\n"
wait
echo "cd ${WORKING_DIR}"
echo "ln -sfn ${WORKING_DIR}/shared/magento/app/etc/env.php ${TARGET}/${MAGENTO_DIR}/app/etc/env.php"
echo "ln -sfn ${WORKING_DIR}/shared/magento/pub/media ${TARGET}/${MAGENTO_DIR}/pub/media"
echo "ln -sfn ${WORKING_DIR}/shared/magento/var/log ${TARGET}/${MAGENTO_DIR}/var/log"
echo "cd ${TARGET}/${MAGENTO_DIR}"
echo "bin/magento setup:di:compile"
printf "wait...\n\n"
wait
echo "bin/magento setup:static-content:deploy en_US de_CH"
printf "wait...\n\n"
wait
echo "find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;\n"
printf "wait...\n\n"
wait
echo "${LIVE}/${MAGENTO_DIR}/bin/magento maintenance:enable"
printf "${Green}Enabled maintenance mode${Color_Off}\n"
echo "bin/magento setup:upgrade --keep-generated"
printf "wait...\n\n"
wait
echo "cd ${WORKING_DIR}"
echo "unlink ${LIVE_DIRECTORY_ROOT} && ln -sf ${TARGET} ${LIVE_DIRECTORY_ROOT}"
printf "${LIVE}/${MAGENTO_DIR}/bin/magento cache:flush\n"
echo ""
printf "${Yellow}Release finish - Downtime: [20seg]\n"

# TODO
# mv simulation/releases/1.0 ${TARGET}
# unlink ${LIVE_DIRECTORY_ROOT} ln -s ${TARGET} ${LIVE_DIRECTORY_ROOT}
PROMPT_TIMEOUT=0
pe "ls -lah"
pe "ls -lah releases"

########################
# Improvements
########################
pbcopy < ${DIR}/../chunks/chunk-deploy-2-1.sh
sleep 1
pbcopy < ${DIR}/../chunks/chunk-deploy-2-2.sh
sleep 1
pbcopy < ${DIR}/../chunks/chunk-deploy-2-3.sh
sleep 1
pbcopy < ${DIR}/../chunks/chunk-deploy-2-4.sh
sleep 1

pe "vim deploy.sh"



