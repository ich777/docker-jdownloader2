# jDownloader2 in Docker optimized for Unraid
This Docker will download and install jDownloader2.

JDownloader 2 is a free, open-source download management tool with a huge community of developers that makes downloading as easy and fast as it should be. Users can start, stop or pause downloads, set bandwith limitations, auto-extract archives and much more...


>**Update Notice:** Updates will be handled through jDownloader2 directly, simply click the 'Check for Updates' in the WebGUI.


>**NOTE:** Please also check out the homepage from jDownloader: http://jdownloader.org/

## Env params
| Name | Value | Example |
| --- | --- | --- |
| CUSTOM_RES_W | Minimum of 1024 pixesl (leave blank for 1024 pixels) | 1024 |
| CUSTOM_RES_H | Minimum of 768 pixesl (leave blank for 768 pixels) | 768 |
| UMASK | Set permissions for newly created files | 000 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name jDownloader2 -d \
    -p 8080:8080 \
    --env 'CUSTOM_RES_W=1024' \
    --env 'CUSTOM_RES_H=768' \
    --env 'UMASK=000' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /mnt/user/appdata/jdownloader2:/jDownloader2 \
    --volume /mnt/user/jDownloader2:/mnt/jDownloader \
    --restart=unless-stopped\
	ich777/jdownloader2
```

### Webgui address: http://[SERVERIP]:[PORT]/vnc.html?autoconnect=true


#### Reverse Proxy with nginx example:

```
server {
	listen 443 ssl;

	include /config/nginx/ssl.conf;
	include /config/nginx/error.conf;

	server_name jdownloader2.example.com;

	location /websockify {
		auth_basic           example.com;
		auth_basic_user_file /config/nginx/.htpasswd;
		proxy_http_version 1.1;
		proxy_pass http://192.168.1.1:8080/;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";

		# VNC connection timeout
		proxy_read_timeout 61s;

		# Disable cache
		proxy_buffering off;
	}
		location / {
		rewrite ^/$ https://jdownloader2.example.com/vnc.html?autoconnect=true redirect;
		auth_basic           example.com;
		auth_basic_user_file /config/nginx/.htpasswd;
		proxy_redirect     off;
		proxy_set_header Range $http_range;
		proxy_set_header If-Range $http_if_range;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_pass http://192.168.1.1:8080/;
	}
}
```

## Set noVNC Password:
 Please be sure to create the password first inside the container, to do that open up a console from the container (Unraid: In the Docker tab click on the container icon and on 'Console' then type in the following):

1) **su $USER**
2) **vncpasswd**
3) **ENTER YOUR PASSWORD TWO TIMES AND PRESS ENTER AND SAY NO WHEN IT ASKS FOR VIEW ACCESS**

Unraid: close the console, edit the template and create a variable with the `Key`: `TURBOVNC_PARAMS` and leave the `Value` empty, click `Add` and `Apply`.

All other platforms running Docker: create a environment variable `TURBOVNC_PARAMS` that is empty or simply leave it empty:
```
    --env 'TURBOVNC_PARAMS='
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/