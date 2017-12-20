set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/../../../properties.sh

LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
TARGET=releases/${VERSION}

printf "${CYAN}SWITCH LIVE${COLOR_RESET}\n"
echo "cd ${WORKING_DIR}"
printf "${GREEN}unlink ${LIVE_DIRECTORY_ROOT} && ln -sf ${TARGET} ${LIVE_DIRECTORY_ROOT}${COLOR_RESET}\n"
printf "${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/bin/magento cache:flush\n"
echo ""
printf "${YELLOW}Release finish - Downtime: [~20sec]${COLOR_RESET}\n"

mv ${WORKING_DIR}/../demo-backups/${TARGET} ${TARGET}
unlink ${LIVE_DIRECTORY_ROOT} && ln -s ${TARGET} ${LIVE_DIRECTORY_ROOT}
touch ${TARGET}/release-timestamp