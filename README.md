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

### Webgui address: http://[SERVERIP]:[PORT]/vnc_auto.html


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/