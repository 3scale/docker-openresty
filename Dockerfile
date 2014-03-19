FROM 3scale/base:precise
MAINTAINER Michal Cichra <michal@3scale.net> # 2014-02-24

# all the apt-gets in one command & delete the cache after installing
RUN apt-get -q -y update \
 && apt-get -q -y install software-properties-common python-software-properties \
 && apt-add-repository -y ppa:chris-lea/redis-server \
 && apt-get -q -y update \
 && apt-get -q -y install redis-server cron luarocks supervisor logrotate \
                          make build-essential libpcre3-dev libssl-dev wget \
                          iputils-arping \
 && apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

ENV OPENRESTY_VERSION 1.5.8.1

RUN wget -nv http://openresty.org/download/ngx_openresty-$OPENRESTY_VERSION.tar.gz \
         -O /root/ngx_openresty-$OPENRESTY_VERSION.tar.gz \
 && tar -xzf /root/ngx_openresty-$OPENRESTY_VERSION.tar.gz -C /root/ \
 && cd /root/ngx_openresty-$OPENRESTY_VERSION/ \
 && ./configure --prefix=/opt/openresty --with-http_gunzip_module --with-luajit \
    --http-client-body-temp-path=/var/nginx/client_body_temp \
    --http-proxy-temp-path=/var/nginx/proxy_temp \
    --http-log-path=/var/nginx/access.log \
    --error-log-path=/var/nginx/error.log \
    --pid-path=/var/nginx/nginx.pid \
    --lock-path=/var/nginx/nginx.lock \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_realip_module \
    --without-http_fastcgi_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
 && make \
 && make install \
 && rm -rf /root/ngx_openresty-$OPENRESTY_VERSION*

ADD supervisor /etc/supervisor

ONBUILD CMD ["supervisord", "-n"]
