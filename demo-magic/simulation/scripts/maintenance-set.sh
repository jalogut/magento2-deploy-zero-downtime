GREEN="\033[0;32m"
COLOR_RESET="\033[0m"
output=$(touch ${MAGENTO_DIR}/var/.maintenance.flag)
printf "${GREEN}Enabled maintenance mode${COLOR_RESET}\n"