FROM 3scale/openresty

## add your supervisor openresty config
ADD openresty.conf /etc/supervisor/conf.d/
ADD nginx.conf /opt/openresty/nginx/config/nginx.conf

EXPOSE 80

CMD ["supervisord"]
