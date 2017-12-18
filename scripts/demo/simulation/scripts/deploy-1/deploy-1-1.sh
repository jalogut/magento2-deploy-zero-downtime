set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../../../properties.sh

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