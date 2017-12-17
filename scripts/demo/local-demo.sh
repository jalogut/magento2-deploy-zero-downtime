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

PROJECT_NAME='luma-shop'

# Start
pe "ls -lah"
pe "cd ${PROJECT_NAME}"

# ====================
# Skip maintenance
# ====================
: '
unset TYPE_SPEED
pe "vim ${MAGENTO_DIR}/setup/src/Magento/Setup/Console/Command/DbStatusCommand.php"
# pe "vim ${MAGENTO_DIR}/app/code/Demo/Settings/etc/module.xml"
# pe "${MAGENTO_DIR}/bin/magento setup:db:status"

TYPE_SPEED=${TYPE_SPEED_ORIG}
pe "vim ${MAGENTO_DIR}/app/etc/config.php"
outputCache=$(${MAGENTO_DIR}/bin/magento c:c)
pe "${MAGENTO_DIR}/bin/magento app:config:import"

pe "${MAGENTO_DIR}/bin/magento | grep config:"
pe "${MAGENTO_DIR}/bin/magento config:set path/non_existing 1"

unset TYPE_SPEED
pe "vim ${MAGENTO_DIR}/app/etc/config.php"
pe "${MAGENTO_DIR}/bin/magento config:set path/non_existing 1"

outputConfigImport=$(${MAGENTO_DIR}/bin/magento app:config:import)
TYPE_SPEED=${TYPE_SPEED_ORIG}
'
# ====================
# Dump config for Build
# ====================
p "${MAGENTO_DIR}/bin/magento app:config:dump"
rm ${MAGENTO_DIR}/app/code/Demo/Settings/etc/di.xml
outputConfigImport=$(${MAGENTO_DIR}/bin/magento c:c)
${MAGENTO_DIR}/bin/magento app:config:dump

pe "open ${MAGENTO_DIR}/app/etc/config.php"
pe "git reset --hard"
rm ${MAGENTO_DIR}/app/code/Demo/Settings/etc/di.xml
cat ${DIR}/chunks/chunk-local-1-0 > ${MAGENTO_DIR}/app/etc/config.php
pe "open ${MAGENTO_DIR}/app/etc/config.php"

pbcopy < ${DIR}/chunks/chunk-local-1-1
sleep 1
unset TYPE_SPEED
pe "vim ${MAGENTO_DIR}/app/code/Demo/Settings/etc/di.xml"
pe "${MAGENTO_DIR}/bin/magento c:c"
pe "${MAGENTO_DIR}/bin/magento app:config:dump"
pbcopy < ${DIR}/chunks/chunk-local-1-2
sleep 1
pe "open ${MAGENTO_DIR}/app/etc/config.php"

TYPE_SPEED=${TYPE_SPEED_ORIG}
p "git commit -am'Dump config to minify assets'"
cat ${DIR}/simulation/logs/commit-config.log
p "git push"
cat ${DIR}/simulation/logs/push-config.log

cd ${WORKING_DIR}