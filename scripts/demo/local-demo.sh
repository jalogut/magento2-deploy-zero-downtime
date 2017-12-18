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
pe "ls -l"
pe "cd ${PROJECT_NAME}/${MAGENTO_DIR}"

# ====================
# Skip maintenance
# ====================
unset TYPE_SPEED
pe "vim setup/src/Magento/Setup/Console/Command/DbStatusCommand.php"
# pe "vim ${MAGENTO_DIR}/app/code/Demo/Settings/etc/module.xml"
# pe "${MAGENTO_DIR}/bin/magento setup:db:status"

TYPE_SPEED=${TYPE_SPEED_ORIG}
pe "vim app/etc/config.php"
outputCache=$(bin/magento c:c)
pe "bin/magento app:config:import"

pe "bin/magento | grep config:"
pe "bin/magento config:set path/non_existing 1"

unset TYPE_SPEED
pe "vim app/etc/config.php"
pe "bin/magento config:set path/non_existing 1"

outputConfigImport=$(bin/magento app:config:import)
TYPE_SPEED=${TYPE_SPEED_ORIG}

p ""

# ====================
# Dump config for Build
# ====================
p ""
clear

p "bin/magento app:config:dump"
rm app/code/Demo/Settings/etc/di.xml
outputConfigImport=$(bin/magento c:c)
bin/magento app:config:dump

pe "open app/etc/config.php"

p ""
clear
pe "git reset --hard"
rm app/code/Demo/Settings/etc/di.xml
cat ${DIR}/chunks/chunk-local-1-0 > app/etc/config.php
pe "open app/etc/config.php"

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

p ""