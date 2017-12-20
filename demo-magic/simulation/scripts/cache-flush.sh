output=$(rm -rf ${MAGENTO_DIR}/var/cache/*)
output=$(rm -rf ${MAGENTO_DIR}/var/page_cache/*)
echo "Flushed cache types:
config
layout
block_html
collections
reflection
db_ddl
eav
customer_notification
full_page
config_integration
config_integration_api
translate
config_webservice"