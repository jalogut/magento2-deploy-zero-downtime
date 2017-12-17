#!/usr/bin/env bash

########################
# include the magic
########################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/demo-magic.sh
source ${DIR}/properties.sh

########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
# TYPE_SPEED=20
TYPE_SPEED_ORIG=${TYPE_SPEED}

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="➜ ${WHITE} jalogut@demo-build-server "

# hide the evidence
clear

pe "ls -lah"
pbcopy < ${DIR}/chunks/chunk-deploy-3-1
sleep 1
pe "touch build.sh && open build.sh"
pe "chmod +x build.sh"

pbcopy < ${DIR}/chunks/chunk-deploy-3-2
sleep 1
pe "vim artifact.excludes"

VERSION="1.2"
p "VERSION=${VERSION} ~/simulation/build.sh"
VERSION=${VERSION} ${DIR}/simulation/scripts/build.sh

pe "ls -lah"
pe "ls -lah ${VERSION}/${MAGENTO_DIR}/app/etc/"
p "scp ${VERSION}.tar.gz alojua@mage.deploy.demo.com:downloads/"
mv ${WORKING_DIR}/${VERSION}.tar.gz ../live-server/downloads/

cd ${WORKING_DIR}

