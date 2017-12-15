if [[ -n ${DISABLE_MODULES} ]]; then
    bin/magento module:disable ${DISABLE_MODULES}
fi
