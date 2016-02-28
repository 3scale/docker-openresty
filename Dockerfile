FROM quay.io/3scale/base:trusty

MAINTAINER Michal Cichra <michal@3scale.net>

ENV OPENRESTY_VERSION 1.9.7.3

COPY system-ssl.patch /tmp/

# all the apt-gets in one command & delete the cache after installing
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 136221EE520DDFAF0A905689B9316A7BC7917B12 \
 && echo 'deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu trusty main' > /etc/apt/sources.list.d/redis.list \
 && apt-install redis-server cron supervisor logrotate make build-essential libpcre3-dev libssl-dev wget libexpat1-dev unzip \
 && wget -qO- https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz | tar xvz -C /tmp/ \
 && cd /tmp/openresty-* \
 && patch -p0 < /tmp/system-ssl.patch \
 && ./configure --prefix=/opt/openresty --with-http_gunzip_module --with-luajit \
    --with-luajit-xcflags=-DLUAJIT_ENABLE_LUA52COMPAT \
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
    --with-md5-asm \
    --with-sha1-asm \
    --with-file-aio \
 && make \
 && make install \
 && rm -rf /tmp/openresty* \
 && ln -sf /opt/openresty/nginx/sbin/nginx /usr/local/bin/nginx \
 && ln -sf /usr/local/bin/nginx /usr/local/bin/openresty \
 && ln -sf /opt/openresty/bin/resty /usr/local/bin/resty \
 && ln -sf /opt/openresty/luajit/bin/luajit-* /opt/openresty/luajit/bin/lua \
 && ln -sf /opt/openresty/luajit/bin/lua /usr/local/bin/lua \
 && wget -qO- http://keplerproject.github.io/luarocks/releases/luarocks-2.3.0.tar.gz | tar xvz -C /tmp/ \
 && cd /tmp/luarocks-* \
 && ./configure --with-lua=/opt/openresty/luajit \
    --with-lua-include=/opt/openresty/luajit/include/luajit-2.1 \
    --with-lua-lib=/opt/openresty/lualib \
 && make && make install \
 && rm -rf /tmp/luarocks-* \
 && cd && apt-get remove make -y

COPY etc /etc/

ONBUILD CMD ["supervisord", "-n"]
