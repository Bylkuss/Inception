FROM alpine:3.19.1

RUN apk add --no-cache nginx && \
    mkdir -p /run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY portfolioWebsite /usr/share/nginx/html/portfolioWebsite

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
