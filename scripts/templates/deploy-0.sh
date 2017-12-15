#!/bin/bash
# ============ 
# Bash configuration
# -e exit on first error
# -u error is variable unset
# -x display commands for debugging
set -eux

LANGUAGES='en_US de_CH'
STATIC_DEPLOY_PARAMS="--exclude-theme=Magento/blank"

WORKING_DIR=`pwd`
LIVE_DIRECTORY_ROOT='public_html'
LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
MAGENTO_DIR='magento'

# SET MAINTENANCE
${LIVE}/${MAGENTO_DIR}/bin/magento maintenance:enable

# GET CODE
cd ${LIVE}
git pull
composer install --no-dev

# GENERATE FILES
cd ${LIVE}/${MAGENTO_DIR}
bin/magento setup:di:compile
bin/magento setup:static-content:deploy ${LANGUAGES} ${STATIC_DEPLOY_PARAMS}
find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;

# DATABASE UPDATE
cd ${LIVE}/${MAGENTO_DIR}
bin/magento setup:upgrade --keep-generated

# UNSET MAINTENANCE
${LIVE}/${MAGENTO_DIR}/bin/magento maintenance:disable

# CLEAR CACHE
${LIVE}/${MAGENTO_DIR}/bin/magento cache:flush

# RETURN TO WORKING DIR
cd ${WORKING_DIR}
