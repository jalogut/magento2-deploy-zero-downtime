set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../../properties.sh

GIT_REPO=https://github.com/jalogut/magento-2.2-demo.git
LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
TARGET=releases/${VERSION}

printf "${CYAN}GET CODE${COLOR_RESET}\n"
echo "git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${TARGET}"
printf "wait... ~10sec \n"
sleep 2
echo "cd ${TARGET}"
echo "composer install --no-dev --prefer-dist --optimize-autoloader"
printf "wait... ~4min \n"
sleep 3
echo ""

printf "${CYAN}SYMLINKS SHARED${COLOR_RESET}\n"
echo "cd ${WORKING_DIR}"
echo "ln -sfn ${WORKING_DIR}/shared/magento/app/etc/env.php ${TARGET}/${MAGENTO_DIR}/app/etc/env.php"
echo "ln -sfn ${WORKING_DIR}/shared/magento/pub/media ${TARGET}/${MAGENTO_DIR}/pub/media"
echo "ln -sfn ${WORKING_DIR}/shared/magento/var/log ${TARGET}/${MAGENTO_DIR}/var/log"
sleep 1
echo ""

printf "${CYAN}GENERATE FILES${COLOR_RESET}\n"
echo "cd ${TARGET}/${MAGENTO_DIR}"
echo "bin/magento setup:di:compile"
printf "wait... ~2min \n"
sleep 4
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
sleep 2
echo ""

printf "${CYAN}SWITCH LIVE${COLOR_RESET}\n"
echo "cd ${WORKING_DIR}"
printf "${GREEN}unlink ${LIVE_DIRECTORY_ROOT} && ln -sf ${TARGET} ${LIVE_DIRECTORY_ROOT}${COLOR_RESET}\n"
printf "${LIVE}/${MAGENTO_DIR}/bin/magento cache:flush\n"
echo ""
printf "${YELLOW}Release finish - Downtime: [~20sec]${COLOR_RESET}\n"

mv ${WORKING_DIR}/../demo-backups/${TARGET} ${TARGET}
unlink ${LIVE_DIRECTORY_ROOT} && ln -s ${TARGET} ${LIVE_DIRECTORY_ROOT}