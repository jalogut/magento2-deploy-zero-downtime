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
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# hide the evidence
clear

WORKING_DIR=`pwd`
PUBLIC_DIR='public_html'
MAGENTO_DIR=magento

pe "ls -lah"
pe "cd ${PUBLIC_DIR}"
cd ${MAGENTO_DIR}
pe "bin/magento maintenance:enable"
cd ${WORKING_DIR}/${PUBLIC_DIR}
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
echo "Release finish - Downtime: [15min - 1hour]"