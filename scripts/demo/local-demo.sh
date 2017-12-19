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
p "bin/magento setup:db:status"
printf "${GREEN}All modules are up to date.${COLOR_RESET}\n"
pe "vim app/code/Demo/Settings/etc/module.xml"
p "bin/magento setup:db:status"
printf "${GREEN}The module code base doesn't match the DB schema and data.
       Demo_Settings     schema:       0.0.1  ->  0.0.2
       Demo_Settings       data:       0.0.1  ->  0.0.2
Run 'setup:upgrade' to update your DB schema and data.${COLOR_RESET}\n"

pe "vim app/code/Demo/Settings/etc/module.xml"
# pe "vim setup/src/Magento/Setup/Console/Command/DbStatusCommand.php"
TYPE_SPEED=${TYPE_SPEED_ORIG}

p ""

# pe "vim app/etc/config.php"
# outputCache=$(MAGENTO_DIR=. ${DIR}/simulation/scripts/cache-flush.sh)
# p "bin/magento app:config:import"
# sleep 2
# printf "${GREEN}Processing configurations data from configuration file...${COLOR_RESET}\n"
# printf "System config was processed\n"
# output=$(git reset --hard)

p "bin/magento | grep config:"
echo "  app:config:dump                          Create dump of application
  app:config:import                        Import data from shared configuration files to appropriate data storage
  config:sensitive:set                     Set sensitive configuration values
  config:set                               Change system configuration
  config:show                              Shows configuration value for given path. If path is not specified, all saved values will be shown
  setup:config:set                         Creates or modifies the deployment configuration
  setup:store-config:set                   Installs the store configuration. Deprecated since 2.2.0. Use config:set instead"

TYPE_SPEED=30
p "bin/magento config:set path/non_existing 1"
printf "${BackRed}The \"path/non_existing\" path does not exist${COLOR_RESET}\n"
TYPE_SPEED=${TYPE_SPEED_ORIG}

unset TYPE_SPEED
# cat ${DIR}/chunks/chunk-local-1-0 > app/etc/config.php
pe "vim app/etc/config.php"
outputCache=$(MAGENTO_DIR=. ${DIR}/simulation/scripts/cache-flush.sh)
p "bin/magento config:set path/non_existing 1"
printf "${BackRed}This command is unavailable right now. To continue working with it please run app:config:import or setup:upgrade command before.${COLOR_RESET}\n"
pe "vim app/etc/config.php"

output=$(git reset --hard)
TYPE_SPEED=${TYPE_SPEED_ORIG}

p ""

# ====================
# Dump config for Build
# ====================
p ""
clear

p "bin/magento app:config:dump"
rm app/code/Demo/Settings/etc/di.xml
outputConfigImport=$(MAGENTO_DIR=. ${DIR}/simulation/scripts/cache-flush.sh)
cat ${DIR}/simulation/logs/config-dump.log
printf "${GREEN}Done.${COLOR_RESET}\n"
cat ${DIR}/chunks/chunk-local-1-1 > app/etc/config.php
sleep 3
pe "open app/etc/config.php"

p ""
clear
pe "git reset --hard"
rm app/code/Demo/Settings/etc/di.xml
cat ${DIR}/chunks/chunk-local-1-2 > app/etc/config.php
pe "open app/etc/config.php"

pbcopy < ${DIR}/chunks/chunk-local-1-3
sleep 1
unset TYPE_SPEED
pe "vim app/code/Demo/Settings/etc/di.xml"
p "bin/magento cache:flush"
MAGENTO_DIR=. ${DIR}/simulation/scripts/cache-flush.sh
p "bin/magento app:config:dump"
cat ${DIR}/chunks/chunk-local-1-4 > app/etc/config.php
printf "${GREEN}Done.${COLOR_RESET}\n"
pbcopy < ${DIR}/chunks/chunk-local-1-5
sleep 1
pe "open app/etc/config.php"

TYPE_SPEED=${TYPE_SPEED_ORIG}
p "git commit -am'Dump config to minify assets'"
cat ${DIR}/simulation/logs/commit-config.log
p "git push"
cat ${DIR}/simulation/logs/push-config.log

cd ${WORKING_DIR}

p ""