#!/usr/bin/env bash

########################
# include the magic
########################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/demo-magic.sh
source ${DIR}/properties.sh

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
DEMO_PROMPT="➜ ${BRed}lumashop@demo-live-server "

# hide the evidence
clear

########################
# Manually
########################
PROMPT_TIMEOUT=0
pe "ls -lah"
pe "cd ${LIVE_DIRECTORY_ROOT}"
pe "ls -lah"
cd ${MAGENTO_DIR}
pe "bin/magento maintenance:enable"
cd ${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
p "git pull"
echo "wait... ~10sec"
wait
p "composer install --no-dev"
echo "wait... ~3min"
wait 
cd ${MAGENTO_DIR}
p "bin/magento setup:di:compile"
echo "wait... ~2min"
wait
p "bin/magento setup:static-content:deploy en_US de_CH"
echo "wait... ~5min"
wait
p "set-permissions"
echo "find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;"
echo "wait... ~3min"
wait
p "bin/magento setup:upgrade --keep-generated"
echo "wait... ~20sec"
wait
pe "bin/magento maintenance:disable"
pe "bin/magento cache:flush"
echo ""
printf "${YELLOW}Release finish - Downtime: [15min - 30min]${COLOR_RESET}\n"

cd ${WORKING_DIR}

########################
# Simple Automation
########################
pe "clear"
pbcopy < ${DIR}/templates/deploy-0.sh
pe "touch deploy.sh && open deploy.sh"
pe "chmod +x deploy.sh"
pe "ls -lah"

p "~/simulation/deploy-0.sh"
${DIR}/simulation/scripts/deploy-0.sh

cd ${WORKING_DIR}

########################
# Right Deployment
########################
pe "clear"
PROMPT_TIMEOUT=0

pe "mkdir releases"
pe "mv ${LIVE_DIRECTORY_ROOT} releases/0.0.1"
pe "ln -s releases/0.0.1 ${LIVE_DIRECTORY_ROOT}"

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
#pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/"
#pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub"
#pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var"

pbcopy < ${DIR}/chunks/chunk-deploy-1-1
sleep 1
pbcopy < ${DIR}/chunks/chunk-deploy-1-2
sleep 1
pbcopy < ${DIR}/chunks/chunk-deploy-1-3
sleep 1
pbcopy < ${DIR}/chunks/chunk-deploy-1-4
sleep 1

pe "open deploy.sh"
VERSION="1.0"
p "VERSION=${VERSION} ~/simulation/deploy-1.sh"
VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-1.sh

pe "ls -lah"
pe "ls -lah releases"
unset TYPE_SPEED
pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php"
pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media"
pe "ls -lah ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log"
TYPE_SPEED=${TYPE_SPEED_ORIG}

########################
# Zero Downtime
########################
pe "clear"
PROMPT_TIMEOUT=0

p "open deploy.sh"
pbcopy < ${DIR}/chunks/chunk-deploy-2-1
sleep 1
open deploy.sh
VERSION="1.1"
p "VERSION=${VERSION} ~/simulation/deploy-2.sh"
VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-2.sh

pe "ls -lah && ls -lah releases"

########################
# Build System
########################
pe "clear"
PROMPT_TIMEOUT=0

p "open deploy.sh"
pbcopy < ${DIR}/chunks/chunk-deploy-3-1
sleep 1
open deploy.sh
pe "mkdir downloads"

VERSION="1.2"
p "VERSION=${VERSION} ~/simulation/deploy-3.sh"
VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-3.sh

pe "ls -lah && ls -lah releases"

cd ${WORKING_DIR}



