GIT_REPO=https://github.com/jalogut/magento-2.2-demo.git
TARGET=releases/${VERSION}
RELEASE=${WORKING_DIR}/${TARGET}

# GET CODE
git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${TARGET}
cd ${TARGET}
