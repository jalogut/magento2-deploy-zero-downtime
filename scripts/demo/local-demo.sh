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
DEMO_PROMPT="➜ ${BCyan}\W "

# hide the evidence
clear

# ====================
# Skip maintenance
# ====================
pe "cd luma-shop"
pe "${MAGENTO_DIR}/bin/magento setup:db:status"
unset TYPE_SPEED
pe "vim ${MAGENTO_DIR}/app/code/Demo/Settings/etc/module.xml"
pe "${MAGENTO_DIR}/bin/magento setup:db:status"

TYPE_SPEED=TYPE_SPEED_ORIG
pe "vim ${MAGENTO_DIR}/app/etc/config.php"
pe "vim ${MAGENTO_DIR}/bin/magento app:config:import"

git reset --hard

cd ${WORKING_DIR}