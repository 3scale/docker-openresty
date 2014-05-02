FROM quay.io/3scale/base:trusty

MAINTAINER Michal Cichra <michal@3scale.net> # 2014-02-24

# all the apt-gets in one command & delete the cache after installing
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 136221EE520DDFAF0A905689B9316A7BC7917B12 \
 && echo 'deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu trusty main' > /etc/apt/sources.list.d/redis \
 && apt-get -q -y update \
 && apt-get -q -y install redis-server cron luarocks supervisor logrotate \
                          make build-essential libpcre3-dev libssl-dev wget \
                          iputils-arping libexpat1-dev \
 && apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*


ADD ngx_openresty-1.5.12.1.tar.gz /root/
RUN cd /root/ngx_openresty-1.5.12.1 \
 && ./configure --prefix=/opt/openresty --with-http_gunzip_module --with-luajit \
    --with-luajit-xcflags=-DLUAJIT_ENABLE_CHECKHOOK \
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
 && rm -rf /root/ngx_openresty*

ADD supervisor /etc/supervisor

ONBUILD CMD ["supervisord", "-n"]
