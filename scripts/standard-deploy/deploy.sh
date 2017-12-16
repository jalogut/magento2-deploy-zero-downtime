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

GIT_REPO=https://github.com/jalogut/magento-2.2-demo.git
LANGUAGES='en_US de_CH'
STATIC_DEPLOY_PARAMS='--exclude-theme=Magento/blank'

WORKING_DIR=`pwd`
MAGENTO_DIR='magento'
LIVE_DIRECTORY_ROOT='public_html'
LIVE=${WORKING_DIR}/${LIVE_DIRECTORY_ROOT}
MAGERUN_BIN=bin/n98-magerun2
KEEP_RELEASES=3
KEEP_DB_BACKUPS=3

TARGET=releases/${VERSION}
if [[ ${VERSION} = "develop" ]]; then
    TARGET=${TARGET}-$(date +%s)
fi
RELEASE=${WORKING_DIR}/${TARGET}

# GET CODE
git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${RELEASE}
cd ${RELEASE}
composer install --no-dev --prefer-dist --optimize-autoloader

# SYMLINKS SHARED
cd ${WORKING_DIR}
ln -sf ${WORKING_DIR}/shared/magento/app/etc/env.php ${RELEASE}/${MAGENTO_DIR}/app/etc/env.php
ln -sf ${WORKING_DIR}/shared/magento/pub/media ${RELEASE}/${MAGENTO_DIR}/pub/media
ln -sf ${WORKING_DIR}/shared/magento/var/log ${RELEASE}/${MAGENTO_DIR}/var/log

# GENERATE FILES
cd ${RELEASE}/${MAGENTO_DIR}
bin/magento setup:di:compile
bin/magento setup:static-content:deploy ${LANGUAGES} ${STATIC_DEPLOY_PARAMS}
find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \;

# DATABASE UPDATE
cd ${RELEASE}/${MAGENTO_DIR}

bin/magento setup:db:status && UPGRADE_NEEDED=0 || UPGRADE_NEEDED=1
if [[ 1 == ${UPGRADE_NEEDED} ]]; then
  	bin/magento maintenance:enable
  	${LIVE}/${MAGERUN_BIN} db:dump --compression='gzip' ${WORKING_DIR}/backups/live-$(date +%s).sql.gz
  	bin/magento setup:upgrade --keep-generated
fi
CONFIG_OUPUT=$(bin/magento config:set workaround/check/config_status 1) || echo ${CONFIG_OUPUT}
if [[ ${CONFIG_OUPUT} == "This command is unavailable right now. To continue working with it please run app:config:import or setup:upgrade command before." ]]; then
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
