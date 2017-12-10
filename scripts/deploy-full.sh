#!/bin/bash

set -eux

LIVE_DIRECTORY_ROOT=public_html
GIT_REPO=https://github.com/jalogut/deployment-magento-2-2.git
MAGENTO_DIR=magento
DISABLE_MODULES=""
LANGUAGES=en_US
STATIC_DEPLOY_PARAMS="--exclude-theme=Magento/blank"
KEEP_RELEASES=3
KEEP_DB_BACKUPS=3

WORKING_DIR=`pwd`
TARGET=${VERSION}

if [[ ${VERSION} = "develop" ]]; then
    TARGET=${VERSION}-$(date +%s)
fi

#Build
cd releases
git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${TARGET}
cd ${TARGET}
composer install --no-dev --prefer-dist --optimize-autoloader

#Symlinks
cd ${WORKING_DIR}
ln -sfn ${WORKING_DIR}/shared/magento/app/etc/env.php releases/${TARGET}/${MAGENTO_DIR}/app/etc/env.php
ln -sfn ${WORKING_DIR}/shared/magento/pub/media releases/${TARGET}/${MAGENTO_DIR}/pub/media
ln -sfn ${WORKING_DIR}/shared/magento/var/log releases/${TARGET}/${MAGENTO_DIR}/var/log

#Generate Files
cd ${WORKING_DIR}/releases/${TARGET}/${MAGENTO_DIR}
if [[ -n ${DISABLE_MODULES} ]]; then
    bin/magento module:disable ${DISABLE_MODULES}
fi
bin/magento setup:di:compile
output=`bin/magento setup:static-content:deploy ${LANGUAGES} ${STATIC_DEPLOY_PARAMS}` || echo output
find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;

#DATABASE UPDATE
${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/bin/magento maintenance:enable
cd ${WORKING_DIR}/releases/${TARGET}/${MAGENTO_DIR}
n98-magerun2 db:dump --compression='gzip' ${WORKING_DIR}/backups/${TARGET}.sql.gz
bin/magento setup:upgrade --keep-generated

#Swap Live version
${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}/${MAGENTO_DIR}/bin/magento maintenance:disable
cd ${WORKING_DIR}
ln -sfn releases/${TARGET} ${LIVE_DIRECTORY_ROOT}
echo "sudo service php5-fpm reload"

#Clean up
KEEP_RELEASES_TAIL=`expr ${KEEP_RELEASES} + 1`
cd ${WORKING_DIR}/releases && rm -rf `ls -t | tail -n +${KEEP_RELEASES_TAIL}`
KEEP_DB_BACKUPS_TAIL=`expr ${KEEP_DB_BACKUPS} + 1`
cd ${WORKING_DIR}/backups && rm -rf `ls -t | tail -n +${KEEP_DB_BACKUPS_TAIL}`






