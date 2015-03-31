# Basic Hello world example

```bash
cd hello-world
sudo docker pull 3scale/openresty
```
Then have a look at the config files, but you shouldn't need to change anything for now.

```bash
sudo docker build -t YOURNAME/openresty .
sudo docker run -t -i -p 80 -v `pwd`/web:/var/www YOURNAME/openresty:latest
sudo docker ps
CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS                   NAMES
ee48bd3597a3        YOURNAME/openresty:latest   "supervisord"       7 seconds ago       Up 6 seconds        0.0.0.0:49171->80/tcp   thirsty_bardeen
```
Now you should see which local port got chosen for the port 80 redirection.

```
 curl localhost:49171
Hello, World!#
```

