#/bin/bash

DATA_DIR="/var/www/onlyoffice/Data"
LOG_DIR="/var/log/onlyoffice/8.1"

ONLYOFFICE_HTTPS=${ONLYOFFICE_HTTPS:-false}

SSL_CERTIFICATES_DIR="${DATA_DIR}/certs"
SSL_CERTIFICATE_PATH=${SSL_CERTIFICATE_PATH:-${SSL_CERTIFICATES_DIR}/onlyoffice.crt}
SSL_KEY_PATH=${SSL_KEY_PATH:-${SSL_CERTIFICATES_DIR}/onlyoffice.key}
SSL_DHPARAM_PATH=${SSL_DHPARAM_PATH:-${SSL_CERTIFICATES_DIR}/dhparam.pem}
SSL_VERIFY_CLIENT=${SSL_VERIFY_CLIENT:-off}
ONLYOFFICE_HTTPS_HSTS_ENABLED=${ONLYOFFICE_HTTPS_HSTS_ENABLED:-true}
ONLYOFFICE_HTTPS_HSTS_MAXAGE=${ONLYOFFICE_HTTPS_HSTS_MAXAG:-31536000}
SYSCONF_TEMPLATES_DIR="/app/onlyoffice/setup/config"

# stop services
service mysql stop
service monoserve stop
service nginx stop

# setup HTTPS
if [ -f "${SSL_CERTIFICATE_PATH}" -a -f "${SSL_KEY_PATH}" ]; then
	cp ${SYSCONF_TEMPLATES_DIR}/nginx/onlyoffice-ssl /etc/nginx/sites-enabled/onlyoffice
           
        mkdir ${LOG_DIR}/nginx

	# configure nginx
	sed 's,{{SSL_CERTIFICATE_PATH}},'"${SSL_CERTIFICATE_PATH}"',' -i /etc/nginx/sites-enabled/onlyoffice
	sed 's,{{SSL_KEY_PATH}},'"${SSL_KEY_PATH}"',' -i /etc/nginx/sites-enabled/onlyoffice

	# if dhparam path is valid, add to the config, otherwise remove the option
	if [ -r "${SSL_DHPARAM_PATH}" ]; then
	  sed 's,{{SSL_DHPARAM_PATH}},'"${SSL_DHPARAM_PATH}"',' -i /etc/nginx/sites-enabled/onlyoffice
	else
	  sed '/ssl_dhparam {{SSL_DHPARAM_PATH}};/d' -i /etc/nginx/sites-enabled/onlyoffice
	fi

	sed 's,{{SSL_VERIFY_CLIENT}},'"${SSL_VERIFY_CLIENT}"',' -i /etc/nginx/sites-enabled/onlyoffice

	if [ -f /usr/local/share/ca-certificates/ca.crt ]; then
	  sed 's,{{CA_CERTIFICATES_PATH}},'"${CA_CERTIFICATES_PATH}"',' -i /etc/nginx/sites-enabled/onlyoffice
	else
	  sed '/{{CA_CERTIFICATES_PATH}}/d' -i /etc/nginx/sites-enabled/onlyoffice
	fi

	if [ "${ONLYOFFICE_HTTPS_HSTS_ENABLED}" == "true" ]; then
	  sed 's/{{ONLYOFFICE_HTTPS_HSTS_MAXAGE}}/'"${ONLYOFFICE_HTTPS_HSTS_MAXAGE}"'/' -i /etc/nginx/sites-enabled/onlyoffice
	else
	  sed '/{{ONLYOFFICE_HTTPS_HSTS_MAXAGE}}/d' -i /etc/nginx/sites-enabled/onlyoffice
	fi
fi

# start services
service mysql start
service monoserve start
service nginx start
service onlyofficeFeed start
service onlyofficeIndex start
service onlyofficeJabber start
service onlyofficeMailAggregator start
service onlyofficeMailWatchdog start
service onlyofficeNotify start
#service onlyofficeBackup start

