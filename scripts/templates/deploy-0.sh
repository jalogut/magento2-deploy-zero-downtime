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

cd ${LIVE}

# SET MAINTENANCE
${MAGENTO_DIR}/bin/magento maintenance:enable

# GET CODE
git pull
composer install --no-dev

# GENERATE FILES
cd ${MAGENTO_DIR}
bin/magento setup:di:compile
bin/magento setup:static-content:deploy en_US de_CH
find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;

# DATABASE UPDATE
bin/magento setup:upgrade --keep-generated

# UNSET MAINTENANCE
bin/magento maintenance:disable

# CLEAR CACHE
${LIVE}/${MAGENTO_DIR}/bin/magento cache:flush

cd ${WORKING_DIR}
