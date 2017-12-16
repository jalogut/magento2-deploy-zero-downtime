set -eux

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/properties.sh

LIVE_SERVER_DIR='live-server'

mv ${LIVE_SERVER_DIR}/releases/0.0.1 ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}

unlink ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php
unlink ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media
unlink ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log

mv ${LIVE_SERVER_DIR}/shared/${MAGENTO_DIR}/app/etc/env.php ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php
mv ${LIVE_SERVER_DIR}/shared/${MAGENTO_DIR}/pub/media ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media
mv ${LIVE_SERVER_DIR}/shared/${MAGENTO_DIR}/var/log ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log

mv ${LIVE_SERVER_DIR}/releases/* demo-backups/releases

rm -rf ${LIVE_SERVER_DIR}/releases
rm -rf ${LIVE_SERVER_DIR}/shared