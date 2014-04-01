docker-openresty
================

Docker Image with Openresty, redis and luarocks


## Example Usage

    FROM 3scale/openresty
    
    ## add your supervisor openresty config
    ADD openresty.conf /etc/supervisor/conf.d/
    
    # Add your app
    ADD . /var/www
    
    CMD ["supervisor"]

### Supervisor config
Depends on your application, but something like following should work:

    [program:openresty]
    command=/opt/openresty/nginx/sbin/nginx -p /var/www/ -c config/nginx.conf
    autorestart=true


## Cron
Cron is available and running by supervisor, so you can freely use logrotate and other cron goodies.
