################################################################################
#                                                                              #
#                          sslGenerateCertificate.sh                           #
#                                                                              #
#     Shell script to generate an SSL certificate using OpenSSL service.       #
#                                                                              #
#     42 Québec - Inception                                                    #
#                                                                              #
#     Lounes Adjou <loadjou>, 08/03/2024                                       #
#                                                                              #
################################################################################

#!/bin/bash

# Validation of the args
if [ "$#" -ne 1 ]; then
    echo "Mismatch args number. Please provide a domain name"
    exit 1
fi

# Args
DOMAIN_NAME=$1

# Util paths
SSL_SRC=/etc/ssl
KEY_SRC=$SSL_SRC/private
CERT_SRC=$SSL_SRC/certs

# Check if directories exist, create them if not
if [ ! -d "$SSL_SRC" ]; then
    mkdir -p "$SSL_SRC"
fi

if [ ! -d "$KEY_SRC" ]; then
    mkdir -p "$KEY_SRC"
fi

if [ ! -d "$CERT_SRC" ]; then
    mkdir -p "$CERT_SRC"
fi

# 1st step: Generate a CA certificate (PEM) for self-signing requests for an SSL certificate.
openssl req -x509 -newkey rsa:2048 -nodes -keyout "$KEY_SRC/myCA.key" -sha256 -days 365 \
-out "$CERT_SRC/myCA.pem" -subj "/C=CA/ST=QC/L=QC/O=42Québec/OU=loadjou/CN=loadjou.42.fr"


# 2nd step: Copying the generated certificate (.PEM) to the "ca-certificates" package section in nginx
# so now, the package will manage it and it becomes a well-formatted CA certificate.
cp "$CERT_SRC/myCA.pem" /usr/share/ca-certificates/myCA.crt

# Updating the ca-certificates package.
apk update update-ca-certificates

# Generating a Certificate Signing Request (CSR) to send to the CA (CRT)
# params:
#       req: Specifying the certificate type.
#       -newkey: Forcing a new key generation.
#       -rsa:2048: Using RSA algorithm with 2048 bits (size).
#       -nodes: Specifying that it's not an encrypted key - no passphrase.
#       -out: redirection of the key to the path.
openssl req -newkey rsa:2048 -nodes -keyout "$KEY_SRC/$DOMAIN_NAME.key" -out "$CERT_SRC/$DOMAIN_NAME.csr" -subj "/C=CA"

# Writing configuration that will be included in the request to be signed
cat > "$CERT_SRC/$DOMAIN_NAME.ext" << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName=@alt_names
[alt_names]
DNS.1=$DOMAIN_NAME
EOF

# Final step: generating a self-signed certificate generated above
# (it means the request to be signed) by using our own CA.
openssl x509 -req -in "$CERT_SRC/$DOMAIN_NAME.csr" -CA "$CERT_SRC/myCA.pem" -CAkey "$KEY_SRC/myCA.key" -CAcreateserial -out "$CERT_SRC/$DOMAIN_NAME.crt" -days 365 -sha256 -extfile "$CERT_SRC/$DOMAIN_NAME.ext"





