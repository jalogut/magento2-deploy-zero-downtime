#!/bin/bash
# ============ 
# Bash configuration
# -e exit on first error
# -u error is variable unset
# -x display commands for debugging
set -eux

GIT_REPO=https://github.com/jalogut/magento-2.2-demo.git
LANGUAGES='en_US de_CH'
STATIC_DEPLOY_PARAMS="--exclude-theme=Magento/blank"

WORKING_DIR=`pwd`
LIVE_DIRECTORY_ROOT='public_html'
LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
MAGENTO_DIR='magento'

TARGET=releases/${VERSION}
RELEASE=${WORKING_DIR}/${TARGET}

# GET CODE
git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${RELEASE}
cd ${RELEASE}
composer install --no-dev --prefer-dist --optimize-autoloader

# SYMLINKS SHARED
cd ${WORKING_DIR}
ln -sf ${WORKING_DIR}/shared/magento/app/etc/env.php ${RELEASE}/${MAGENTO_DIR}/app/etc/env.php
rm -rf ${RELEASE}/${MAGENTO_DIR}/pub/media && ln -sf ${WORKING_DIR}/shared/magento/pub/media ${RELEASE}/${MAGENTO_DIR}/pub/media
ln -sf ${WORKING_DIR}/shared/magento/var/log ${RELEASE}/${MAGENTO_DIR}/var/log

# GENERATE FILES
cd ${RELEASE}/${MAGENTO_DIR}
bin/magento setup:di:compile
bin/magento setup:static-content:deploy ${LANGUAGES} ${STATIC_DEPLOY_PARAMS}
find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;

# DATABASE UPDATE
${LIVE}/${MAGENTO_DIR}/bin/magento maintenance:enable
cd ${RELEASE}/${MAGENTO_DIR}
bin/magento setup:upgrade --keep-generated

# SWITCH LIVE
cd ${WORKING_DIR}
unlink ${LIVE} && ln -sf ${RELEASE} ${LIVE}

# CLEAR CACHE
${LIVE}/${MAGENTO_DIR}/bin/magento cache:flush

# RETURN TO WORKING DIR
cd ${WORKING_DIR}
