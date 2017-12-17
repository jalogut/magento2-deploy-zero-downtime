#!/bin/bash
# ============ 
# Bash configuration
# -e exit on first error
# -u error is variable unset
# -x display commands for debugging
set -eux

GIT_REPO=https://github.com/jalogut/magento-2.2-demo.git
LANGUAGES='en_US de_CH'
STATIC_DEPLOY_PARAMS='--exclude-theme=Magento/blank'
DOWNLOADS_DIR='downloads'

WORKING_DIR=`pwd`
MAGENTO_DIR='magento'

BUILD=${WORKING_DIR}/${VERSION}

# GET CODE
git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${BUILD}
cd ${BUILD}
composer install --no-dev --prefer-dist --optimize-autoloader

# GENERATE FILES
cd ${BUILD}/${MAGENTO_DIR}
bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f ${LANGUAGES} ${STATIC_DEPLOY_PARAMS}
find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;

# CREATE ARTIFACT
cd ${BUILD}
ARTIFACT_FILENAME=../${VERSION}.tar.gz
tar --exclude-from=../artifact.excludes -czf ${ARTIFACT_FILENAME} .

# TRANSFER ARTIFACT
scp -P 22 ${ARTIFACT_FILENAME} ${SERVER_USERNAME}@${SERVER_HOST}:${DOWNLOADS_DIR}

# RETURN TO WORKING DIR
cd ${WORKING_DIR}