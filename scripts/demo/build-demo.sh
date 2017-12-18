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
DEMO_PROMPT="➜ ${WHITE} build@demo-build-server "

# hide the evidence
clear

pe "ls -l"
pbcopy < ${DIR}/chunks/chunk-build-1-1
sleep 1
pe "touch build.sh && open build.sh"
pe "chmod +x build.sh"

pbcopy < ${DIR}/chunks/chunk-build-1-2
sleep 1
pe "vim artifact.excludes"

VERSION="1.2"
p "VERSION=${VERSION} ~/simulation/build.sh"
VERSION=${VERSION} ${DIR}/simulation/scripts/build.sh

unset TYPE_SPEED
#pe "ls -l ${VERSION}/${MAGENTO_DIR}/app/etc/"
pe "ls -l"

p ""
clear

p "ssh-copy-id lumashop@demo-live-server.jalogut.com"
cat ${DIR}/simulation/logs/ssh-copy-id-2.log
wait
cat ${DIR}/simulation/logs/ssh-copy-id-3.log

p "scp ${VERSION}.tar.gz lumashop@demo-live-server.jalogut.com:downloads/"
mv ${WORKING_DIR}/${VERSION}.tar.gz ../live-server/downloads/
sleep 4
cat ${DIR}/simulation/logs/scp.log
TYPE_SPEED=${TYPE_SPEED_ORIG}

cd ${WORKING_DIR}

p ""