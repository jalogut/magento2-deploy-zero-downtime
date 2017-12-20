GREEN="\033[0;32m"
COLOR_RESET="\033[0m"
output=$(rm ${MAGENTO_DIR}/var/.maintenance.flag)
printf "${GREEN}Disabled maintenance mode${COLOR_RESET}\n"