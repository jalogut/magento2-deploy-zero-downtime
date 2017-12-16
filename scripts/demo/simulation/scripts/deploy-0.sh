set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../../properties.sh

echo "cd ${LIVE_DIRECTORY_ROOT}"
printf "${MAGENTO_DIR}/bin/magento maintenance:enable\n"
printf "${GREEN}Enabled maintenance mode${COLOR_RESET}\n"

printf "git pull\n"
printf "wait...\n\n"
sleep 2
printf "composer install --no-dev\n"
printf "wait... ~3min \n\n"
sleep 2
printf "${MAGENTO_DIR}/bin/magento setup:di:compile\n"
printf "wait... ~2 min \n\n"
sleep 2
printf "${MAGENTO_DIR}/bin/magento setup:static-content:deploy en_US de_CH\n"
printf "wait... ~5min \n\n"
sleep 2
printf "find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;\n"
printf "wait... ~3min \n\n"
sleep 2
printf "${MAGENTO_DIR}/bin/magento setup:upgrade --keep-generated\n"
printf "wait... ~20sec \n\n"
sleep 2
printf "${MAGENTO_DIR}/bin/magento maintenance:disable\n"
printf "${GREEN}Disabled maintenance mode${COLOR_RESET}\n"
printf "${MAGENTO_DIR}/bin/magento cache:flush\n"
echo ""
printf "${YELLOW}Release finish - Downtime: [15min - 30min]\n"