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
pe "ls -l"
pe "cd ${LIVE_DIRECTORY_ROOT}"
pe "ls -l"
cd ${MAGENTO_DIR}
p "bin/magento maintenance:enable"
MAGENTO_DIR=. ${DIR}/simulation/scripts/maintenance-set.sh

cd ${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
p "git pull"
echo "wait... ~10sec"
wait
p "composer install --no-dev"
echo "wait... ~3min"
wait 
unset TYPE_SPEED
cd ${MAGENTO_DIR}
p "bin/magento setup:di:compile"
echo "wait... ~2min"
wait
p "bin/magento setup:static-content:deploy en_US de_CH"
echo "wait... ~5min"
wait
p "find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;"
echo "wait... ~3min"
wait
p "bin/magento setup:upgrade --keep-generated"
echo "wait... ~20sec"
wait
p "bin/magento maintenance:disable"
MAGENTO_DIR=. ${DIR}/simulation/scripts/maintenance-unset.sh
p "bin/magento cache:flush"
MAGENTO_DIR=. ${DIR}/simulation/scripts/cache-flush.sh
echo ""
printf "${YELLOW}Release finish - Downtime: [15min - 30min]${COLOR_RESET}\n"
TYPE_SPEED=${TYPE_SPEED_ORIG}

cd ${WORKING_DIR}
p ""

########################
# Simple Automation
########################
p ""
clear
pbcopy < ${DIR}/templates/deploy-0.sh
pe "touch deploy.sh && open deploy.sh"
pe "chmod +x deploy.sh"
p "./deploy.sh"
${DIR}/simulation/scripts/deploy-0.sh

cd ${WORKING_DIR}
p ""

########################
# Right Deployment
########################
p ""
clear
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

p "ln -sf ../../../../shared/${MAGENTO_DIR}/app/etc/env.php ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php \\
ln -sf ../../../shared/${MAGENTO_DIR}/pub/media ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media \\
ln -sf ../../../shared/${MAGENTO_DIR}/var/log ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log"

ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/app/etc/env.php ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php
ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/pub/media ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media
ln -sf ${WORKING_DIR}/shared/${MAGENTO_DIR}/var/log ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log

unset TYPE_SPEED
pe "ls -l"
p "ls -l ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php"
echo "lrwxr-xr-x  1 alojua  989599490  67 20 Dez 03:15 public_html/magento/app/etc/env.php -> ../../../../shared/magento/app/etc/env.php"
# pe "ls -l ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media"
# pe "ls -l ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log"
TYPE_SPEED=${TYPE_SPEED_ORIG}

pbcopy < ${DIR}/chunks/chunk-deploy-1-1
sleep 1
pbcopy < ${DIR}/chunks/chunk-deploy-1-2
sleep 1
pbcopy < ${DIR}/chunks/chunk-deploy-1-3
sleep 1
pbcopy < ${DIR}/chunks/chunk-deploy-1-4
sleep 1
pbcopy < ${DIR}/chunks/chunk-deploy-1-5
sleep 1

TYPE_SPEED=${TYPE_SPEED_ORIG}
pe "open deploy.sh"
p ""
clear

VERSION="1.0"
p "VERSION=${VERSION} ./deploy.sh"
# --- Demo in one part
# VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-1.sh
# ---
# Demo in three parts
VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-1/deploy-1-1.sh
wait
VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-1/deploy-1-2.sh
$(MAGENTO_DIR=${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR} ${DIR}/simulation/scripts/maintenance-set.sh)
wait
VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-1/deploy-1-3.sh
# ---

unset TYPE_SPEED
pe "ls -l && ls -l releases"
pe "ls -l ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php"
echo "lrwxr-xr-x  1 alojua  989599490  67 19 Dez 02:17 public_html/magento/app/etc/env.php -> ../../../../shared/magento/app/etc/env.php"
# pe "ls -l ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media"
# pe "ls -l ${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log"
TYPE_SPEED=${TYPE_SPEED_ORIG}

cd ${WORKING_DIR}
p ""
########################
# Zero Downtime
########################
p ""
clear
PROMPT_TIMEOUT=0

p "open deploy.sh"
pbcopy < ${DIR}/chunks/chunk-deploy-2-1
sleep 1
open deploy.sh
VERSION="1.1"
p "VERSION=${VERSION} ./deploy.sh"
VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-2.sh

# unset TYPE_SPEED
# pe "ls -l && ls -l releases"
# TYPE_SPEED=${TYPE_SPEED_ORIG}
p ""

########################
# Build System
########################
p ""
clear
PROMPT_TIMEOUT=0

p "open deploy.sh"
pbcopy < ${DIR}/chunks/chunk-deploy-3-1
sleep 1
open deploy.sh
pe "mkdir downloads"
pbcopy < ${DIR}/chunks/chunk-deploy-3-1
sleep 1
pe "ls -l downloads"

VERSION="1.2"
p "VERSION=${VERSION} ./deploy.sh"
VERSION=${VERSION} ${DIR}/simulation/scripts/deploy-3.sh

# pe "ls -l && ls -l releases"

cd ${WORKING_DIR}
p ""



