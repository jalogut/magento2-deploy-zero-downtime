set -ux

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/properties.sh

BASENAME=$(basename ${WORKING_DIR})
if [[ ${BASENAME} != 'deployment-demo' ]]; then
    echo "Current dir is not deployment-demo"
	exit 1;
fi

# Local
cd ${WORKING_DIR}
LOCAL_DIR='local'
PROJECT_NAME='luma-shop'
cd ${LOCAL_DIR}/${PROJECT_NAME}
git reset --hard
magento/bin/magento setup:upgrade
magento/bin/magento c:f

# Live server
cd ${WORKING_DIR}
LIVE_SERVER_DIR='live-server'

unlink ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}
mv ${LIVE_SERVER_DIR}/releases/0.0.1 ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}

unlink ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php
unlink ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media
unlink ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log

mv ${LIVE_SERVER_DIR}/shared/${MAGENTO_DIR}/app/etc/env.php ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/app/etc/env.php
mv ${LIVE_SERVER_DIR}/shared/${MAGENTO_DIR}/pub/media ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/pub/media
mv ${LIVE_SERVER_DIR}/shared/${MAGENTO_DIR}/var/log ${LIVE_SERVER_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/var/log

mv ${LIVE_SERVER_DIR}/downloads/1.2.tar.gz demo-backups/builds/
mv ${LIVE_SERVER_DIR}/releases/* demo-backups/releases

rm -rf ${LIVE_SERVER_DIR}/releases
rm -rf ${LIVE_SERVER_DIR}/shared
rm -rf ${LIVE_SERVER_DIR}/downloads
rm ${LIVE_SERVER_DIR}/deploy.sh

# Build Server
cd ${WORKING_DIR}
BUILD_SERVER_DIR='build-server'

rm ${BUILD_SERVER_DIR}/artifact.excludes
rm ${BUILD_SERVER_DIR}/build.sh
mv ${BUILD_SERVER_DIR}/1.2 demo-backups/builds/1.2-build
mv ${BUILD_SERVER_DIR}/1.2.tar.gz demo-backups/builds/

cd ${WORKING_DIR}

