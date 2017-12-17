#!/bin/bash
# ============ 
# Bash configuration
# -e exit on first error
# -u error is variable unset
# -x display commands for debugging
set -eux

# INIT DIRECTORIES
if [ ! -d 'releases' ]; then
  mkdir releases
fi
if [ ! -d 'shared' ]; then
  mkdir shared
fi
if [ ! -d 'backups' ]; then
  mkdir backups
fi
if [ ! -d 'downloads' ]; then
  mkdir downloads
fi

KEEP_RELEASES=3
KEEP_DB_BACKUPS=3

WORKING_DIR=`pwd`
MAGENTO_DIR='magento'
LIVE_DIRECTORY_ROOT='public_html'
LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
MAGERUN_BIN=bin/n98-magerun2

TARGET=releases/${VERSION}
if [[ ${VERSION} = "develop" ]]; then
    TARGET=${TARGET}-$(date +%s)
fi
RELEASE=${WORKING_DIR}/${TARGET}
DOWNLOADS_DIR='downloads'

# GET CODE
# Optionally: wget $url -> save in ${DOWNLOADS_DIR}/${VERSION}.tar.gz
mkdir -p ${RELEASE} && tar -xzf ${DOWNLOADS_DIR}/${VERSION}.tar.gz -C ${RELEASE}

# SYMLINKS SHARED
cd ${WORKING_DIR}
ln -sf ${WORKING_DIR}/shared/magento/app/etc/env.php ${RELEASE}/${MAGENTO_DIR}/app/etc/env.php
ln -sf ${WORKING_DIR}/shared/magento/pub/media ${RELEASE}/${MAGENTO_DIR}/pub/media
ln -sf ${WORKING_DIR}/shared/magento/var/log ${RELEASE}/${MAGENTO_DIR}/var/log

# DATABASE UPDATE
cd ${RELEASE}/${MAGENTO_DIR}
bin/magento setup:db:status && UPGRADE_NEEDED=0 || UPGRADE_NEEDED=1
if [[ 1 == ${UPGRADE_NEEDED} ]]; then
  	bin/magento maintenance:enable
  	${LIVE}/${MAGERUN_BIN} db:dump --compression='gzip' ${WORKING_DIR}/backups/live-$(date +%s).sql.gz
  	bin/magento setup:upgrade --keep-generated
fi
# NOTE: Workaround until "app:config:status" is available on Magento 2.2.3 
CONFIG_OUTPUT=$(bin/magento config:set workaround/check/config_status 1) || echo ${CONFIG_OUTPUT}
if [[ ${CONFIG_OUTPUT} == "This command is unavailable right now. To continue working with it please run app:config:import or setup:upgrade command before." ]]; then
	bin/magento maintenance:enable
	bin/magento app:config:import
fi

# UPDATE CRONTAB
cd ${RELEASE}/${MAGENTO_DIR}
bin/magento cron:install --force

# SWITCH LIVE
cd ${WORKING_DIR}
unlink ${LIVE} && ln -sf ${TARGET} ${LIVE}

# CLEAR ALL CACHES
${LIVE}/${MAGENTO_DIR}/bin/magento cache:flush
#sudo service php5-fpm reload
#sudo /etc/init.d/varnish restart

#CLEAN UP
KEEP_RELEASES_TAIL=`expr ${KEEP_RELEASES} + 1`
cd ${WORKING_DIR}/releases && rm -rf `ls -t | tail -n +${KEEP_RELEASES_TAIL}`
KEEP_DB_BACKUPS_TAIL=`expr ${KEEP_DB_BACKUPS} + 1`
cd ${WORKING_DIR}/backups && rm -rf `ls -t | tail -n +${KEEP_DB_BACKUPS_TAIL}`

# RETURN TO WORKING DIR
cd ${WORKING_DIR}
