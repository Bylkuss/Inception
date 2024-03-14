FROM alpine:3.19.1

# Maintainer information
LABEL maintainer="Lounes Adjou <loadjou@42quebec.fr>"

# Install MariaDB server and client
RUN apk update && \
    apk add --no-cache mariadb mariadb-client && \
    rm -rf /var/cache/apk/*

# Set environment variables from build args
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
ENV MYSQL_DATABASE=$MYSQL_DATABASE
ENV MYSQL_USER=$MYSQL_USER
ENV MYSQL_PASSWORD=$MYSQL_PASSWORD

# Copy custom configuration files
COPY conf/mariadb.cnf /etc/mysql/conf.d/
COPY tools/mariadbLauncher.sh /etc/mysql

EXPOSE 3306

# Start MariaDB service
CMD ["sh", "-c", "mysqld --user=mysql --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid --bind-address=0.0.0.0 --character-set-server=utf8 --collation-server=utf8_general_ci --domain=$DOMAIN --root-password=$MYSQL_ROOT_PASSWORD --user=$MYSQL_USER --password=$MYSQL_PASSWORD"]

