# SWITCH LIVE
${LIVE}/${MAGENTO_DIR}/bin/magento maintenance:disable
cd ${WORKING_DIR}
unlink ${LIVE_DIRECTORY_ROOT} && ln -sf ${TARGET} ${LIVE_DIRECTORY_ROOT}
