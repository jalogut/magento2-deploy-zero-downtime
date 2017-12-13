#!/bin/bash
# ============ 
# Bash configuration
# -e exit on first error
# -u error is variable unset
# -x display commands for debugging
set -eux

LIVE_DIRECTORY_ROOT='public_html'
MAGENTO_DIR=magento

cd ${LIVE_DIRECTORY_ROOT}

# Set maintenance
${MAGENTO_DIR}/bin/magento maintenance:enable

# UPDATE PROJECT
git pull
composer install --no-dev

# GENERATE FILES
${MAGENTO_DIR}/bin/magento setup:di:compile
${MAGENTO_DIR}/bin/magento setup:static-content:deploy en_US de_CH
find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;

# DATABASE UPDATE
${MAGENTO_DIR}/bin/magento setup:upgrade --keep-generated

# UNSET MAINTENANCE
${MAGENTO_DIR}/bin/magento maintenance:disable
