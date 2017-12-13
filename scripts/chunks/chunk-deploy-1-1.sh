GIT_REPO=https://github.com/jalogut/deployment-magento-2-2.git
TARGET=releases/${VERSION}

# GET CODE
git clone --depth 1 --branch ${VERSION} ${GIT_REPO} ${TARGET}
cd ${TARGET}
