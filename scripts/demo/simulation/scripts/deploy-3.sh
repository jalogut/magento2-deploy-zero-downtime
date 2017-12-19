set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../../properties.sh

LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
TARGET=releases/${VERSION}
DOWNLOADS_DIR='downloads'

printf "${CYAN}GET CODE${COLOR_RESET}\n"
echo "mkdir -p ${TARGET} && tar -xzf ${DOWNLOADS_DIR}/${VERSION}.tar.gz -C ${TARGET}"
printf "wait... ~1min \n"
sleep 2
echo ""

printf "${CYAN}SYMLINKS SHARED${COLOR_RESET}\n"
echo "cd ${WORKING_DIR}"
echo "ln -sfn ${WORKING_DIR}/shared/magento/app/etc/env.php ${TARGET}/${MAGENTO_DIR}/app/etc/env.php"
echo "ln -sfn ${WORKING_DIR}/shared/magento/pub/media ${TARGET}/${MAGENTO_DIR}/pub/media"
echo "ln -sfn ${WORKING_DIR}/shared/magento/var/log ${TARGET}/${MAGENTO_DIR}/var/log"
sleep 1
echo ""

printf "${CYAN}DATABASE UPDATE${COLOR_RESET}\n"
echo "Skipped: not needed"
echo ""

printf "${CYAN}SWITCH LIVE${COLOR_RESET}\n"
echo "cd ${WORKING_DIR}"
printf "${GREEN}unlink ${LIVE_DIRECTORY_ROOT} && ln -sf ${TARGET} ${LIVE_DIRECTORY_ROOT}${COLOR_RESET}\n"
printf "${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/bin/magento cache:flush\n"
echo ""
printf "${YELLOW}Release finish - ZERO Downtime!!${COLOR_RESET}\n"

mv ${WORKING_DIR}/../demo-backups/${TARGET} ${TARGET}
unlink ${LIVE_DIRECTORY_ROOT} && ln -s ${TARGET} ${LIVE_DIRECTORY_ROOT}
touch ${TARGET}/release-timestamp