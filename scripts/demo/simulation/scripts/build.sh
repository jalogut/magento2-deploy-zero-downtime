set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../../properties.sh

GIT_REPO=https://github.com/jalogut/magento-2.2-demo.git

BUILD=${VERSION}

printf "${CYAN}GET CODE${COLOR_RESET}\n"
echo "git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${BUILD}"
printf "wait... ~10sec \n"
mv ${WORKING_DIR}/../demo-backups/builds/${VERSION}-build ${BUILD}
sleep 2
echo "cd ${BUILD}"
echo "composer install --no-dev --prefer-dist --optimize-autoloader"
printf "wait... ~4min \n"
sleep 3
echo ""

printf "${CYAN}GENERATE FILES${COLOR_RESET}\n"
echo "cd ${BUILD}/${MAGENTO_DIR}"
echo "bin/magento setup:di:compile"
printf "wait... ~2min \n"
sleep 4
echo "bin/magento setup:static-content:deploy -f en_US de_CH"
printf "wait... ~5min \n"
sleep 6
echo "find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;\n"
printf "wait... ~3min \n"
sleep 4
echo ""

printf "${CYAN}CREATE ARTIFACT${COLOR_RESET}\n"
echo "cd ${BUILD}"
ARTIFACT_FILENAME=../${VERSION}.tar.gz
echo "tar --exclude-from=../artifact.excludes -czf ${ARTIFACT_FILENAME} ."
echo ""

printf "${YELLOW}Artifact created: "${ARTIFACT_FILENAME}" ${COLOR_RESET}\n"
mv ${WORKING_DIR}/../demo-backups/builds/${VERSION}.tar.gz .
