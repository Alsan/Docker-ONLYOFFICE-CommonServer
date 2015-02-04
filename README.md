## What is ONLYOFFICE Common Server? ##

ONLYOFFICE is a business service that resolves collaboration issues for both small medium-sized teams. Available in more than 20 languages ONLYOFFICE increases the overall performance of any team no matter how remote the members are located. The platform allows for optimization of your business processes from lead generation to order fulfillment. Combining a versatile set of tools ONLYOFFICE helps entities in any field from retail sales and to industrial engineering and banking. Broad access rights settings make ONLYOFFICE an asset to any executive striving for business excellence.

## Supported Docker versions ##

This image is officially supported on Docker version 1.4.1.

## How to use this image ##

The Docker image is provided fully functional and ready to use (additional setup is only required if you plan to use HTTPS, please see sections below on how to do that). To run the image the latest version of Docker must be installed and the following command needs to be executed:

    sudo docker run -i -t -d -p 80:80 ascensiosystemsia/onlyoffice-commonserver

#### Running the image using HTTPS 

The following command is used to rung the image using HTTPS:

	sudo docker run -i -t -d -p 80:80  -p 443:443 -v /opt/onlyoffice/Data:/var/www/onlyoffice/Data  ascensiosystemsia/onlyoffice-commonserver

Please note, that in case you run the image using HTTPS you need to create and install the following files:

	/opt/onlyoffice/Data/certs/onlyoffice.key
	/opt/onlyoffice/Data/certs/onlyoffice.crt

See the sections below to find out how to do that.

## HTTPS

Access to the onlyoffice application can be secured using SSL so as to prevent unauthorized access. While a CA certified SSL certificate allows for verification of trust via the CA, a self signed certificates can also provide an equal level of trust verification as long as each client takes some additional steps to verify the identity of your website. Below the instructions on achieving this are provided.

To secure the application via SSL basically two things are needed:

- **Private key (.key)**
- **SSL certificate (.crt)**

When using CA certified certificates, these files are provided to you by the CA. When using self-signed certificates you need to generate these files yourself. Skip the following section if you are have CA certified SSL certificates.

#### Generation of Self Signed Certificates

Generation of self-signed SSL certificates involves a simple 3 step procedure.

**STEP 1**: Create the server private key

```bash
openssl genrsa -out onlyoffice.key 2048
```

**STEP 2**: Create the certificate signing request (CSR)

```bash
openssl req -new -key onlyoffice.key -out onlyoffice.csr
```

**STEP 3**: Sign the certificate using the private key and CSR

```bash
openssl x509 -req -days 365 -in onlyoffice.csr -signkey onlyoffice.key -out onlyoffice.crt
```

You have now generated an SSL certificate that's valid for 365 days.

#### Strengthening the server security

This section provides you with instructions to [strengthen your server security](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html).
To achieve this you need to generate stronger DHE parameters.

```bash
openssl dhparam -out dhparam.pem 2048
```

#### Installation of the SSL Certificates

Out of the four files generated above, you need to install the `onlyoffice.key`, `onlyoffice.crt` and `dhparam.pem` files at the onlyoffice server. The CSR file is not needed, but do make sure you safely backup the file (in case you ever need it again).

The default path that the onlyoffice application is configured to look for the SSL certificates is at `/var/www/onlyoffice/Data/certs`, this can however be changed using the `SSL_KEY_PATH`, `SSL_CERTIFICATE_PATH` and `SSL_DHPARAM_PATH` configuration options.

The `/var/www/onlyoffice/Data/` path is the path of the data store, which means that you have to create a folder named certs inside `/opt/onlyoffice/Data/` and copy the files into it and as a measure of security you will update the permission on the `onlyoffice.key` file to only be readable by the owner.

```bash
mkdir -p /opt/onlyoffice/Data/certs
cp onlyoffice.key /opt/onlyoffice/Data/certs/
cp onlyoffice.crt /opt/onlyoffice/Data/certs/
cp dhparam.pem /opt/onlyoffice/Data/certs/
chmod 400 /opt/onlyoffice/Data/certs/onlyoffice.key
```

You are now just one step away from having our application secured.

### Available Configuration Parameters

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command.*

Below is the complete list of parameters that can be set using environment variables.

- **ONLYOFFICE_HTTPS_HSTS_ENABLED**: Advanced configuration option for turning off the HSTS configuration. Applicable only when SSL is in use. Defaults to `true`.
- **ONLYOFFICE_HTTPS_HSTS_MAXAGE**: Advanced configuration option for setting the HSTS max-age in the onlyoffice nginx vHost configuration. Applicable only when SSL is in use. Defaults to `31536000`.
- **SSL_CERTIFICATE_PATH**: The path to the SSL certificate to use. Defaults to `/var/www/onlyoffice/Data/certs/onlyoffice.crt`.
- **SSL_KEY_PATH**: The path to the SSL certificate's private key. Defaults to `/var/www/onlyoffice/Data/certs/onlyoffice.key`.
- **SSL_DHPARAM_PATH**: The path to the Diffie-Hellman parameter. Defaults to `/var/www/onlyoffice/Data/certs/dhparam.pem`.
- **SSL_VERIFY_CLIENT**: Enable verification of client certificates using the `CA_CERTIFICATES_PATH` file. Defaults to `false`

## User Feedback ##

If you have any problems with or questions about this image, please contact us through a [dev.onlyoffice.org][1].

  [1]: http://dev.onlyoffice.org
