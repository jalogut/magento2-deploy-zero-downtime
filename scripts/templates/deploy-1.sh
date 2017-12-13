#!/bin/bash
# ============ 
# Bash configuration
# -e exit on first error
# -u error is variable unset
# -x display commands for debugging
set -eux

WORKING_DIR=`pwd`
LIVE_DIRECTORY_ROOT='public_html'
LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
MAGENTO_DIR='magento'

GIT_REPO=https://github.com/jalogut/deployment-magento-2-2.git
TARGET=releases/${VERSION}

# GET CODE
git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${TARGET}
cd ${TARGET}
composer install --no-dev --prefer-dist --optimize-autoloader

# SYMLINKS SHARED
cd ${WORKING_DIR}
ln -sf ${WORKING_DIR}/shared/magento/app/etc/env.php ${TARGET}/${MAGENTO_DIR}/app/etc/env.php
ln -sf ${WORKING_DIR}/shared/magento/pub/media ${TARGET}/${MAGENTO_DIR}/pub/media
ln -sf ${WORKING_DIR}/shared/magento/var/log ${TARGET}/${MAGENTO_DIR}/var/log

# GENERATE FILES
cd ${TARGET}/${MAGENTO_DIR}
bin/magento setup:di:compile
bin/magento setup:static-content:deploy en_US de_CH
find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;

# DATABASE UPDATE
${LIVE}/${MAGENTO_DIR}/bin/magento maintenance:enable
bin/magento setup:upgrade --keep-generated

# SWITCH LIVE
${LIVE}/${MAGENTO_DIR}/bin/magento maintenance:disable
cd ${WORKING_DIR}
unlink ${LIVE_DIRECTORY_ROOT} && ln -sf ${TARGET} ${LIVE_DIRECTORY_ROOT}

# CLEAR CACHE
${LIVE}/${MAGENTO_DIR}/bin/magento cache:flush

cd ${WORKING_DIR}










