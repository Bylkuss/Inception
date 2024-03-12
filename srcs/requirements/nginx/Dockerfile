FROM alpine:3.19.1

ARG DOMAIN

# Installing nginx, openssl and ca-certifaces services.
RUN apk add --no-cache nginx openssl ca-certificates  && mkdir -p /run/nginx /etc/ssl /etc/ssl/certs /etc/ssl/private

# Naming and versionning the docker builded image
LABEL description="Inception"
LABEL version="1.0"


# Copying all needed files
#	- the script that generates the SSL certificates
#	- nginx configuration file
#	- static website files
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/sslGenerateCertificate.sh /tools/
COPY portfolioWebsite /usr/share/nginx/portfolioWebsite


# Adding execute permission and run the script
RUN chmod +x tools/sslGenerateCertificate.sh
RUN tools/sslGenerateCertificate.sh $DOMAIN

# Exposing the server ports
#	- 80:  for http requests.
#	- 443: for https requests.
EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
