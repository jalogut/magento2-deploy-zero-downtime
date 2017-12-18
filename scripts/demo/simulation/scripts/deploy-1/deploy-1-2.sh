set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../../../properties.sh

LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
TARGET=releases/${VERSION}

echo "bin/magento setup:static-content:deploy en_US de_CH --exclude-theme=Magento/blank"
printf "wait... ~5min \n"
sleep 6
echo "find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;\n"
printf "wait... ~3min \n"
sleep 4
echo ""

printf "${CYAN}DATABASE UPDATE${COLOR_RESET}\n"
echo "${LIVE}/${MAGENTO_DIR}/bin/magento maintenance:enable"
printf "${GREEN}Enabled maintenance mode${COLOR_RESET}\n"
echo "bin/magento setup:upgrade --keep-generated"
printf "wait... ~20sec \n"
echo ""
