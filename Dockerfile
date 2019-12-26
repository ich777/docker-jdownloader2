FROM ich777/debian-baseimage

MAINTAINER ich777

RUN export TZ=Europe/Rome && \
	apt-get update && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	apt-get -y install xvfb wmctrl x11vnc fluxbox screen novnc fonts-takao && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i '/    document.title =/c\    document.title = "jDownloader2 - noVNC";' /usr/share/novnc/include/ui.js

ENV DATA_DIR=/jDownloader2
ENV CUSTOM_RES_W=1280
ENV CUSTOM_RES_H=1024
ENV RUNTIME_NAME="jre1.8.0_211"
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID jdownloader && \
	chown -R jdownloader $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN rm /usr/share/novnc/favicon.ico
COPY /jdownloader.ico /usr/share/novnc/favicon.ico
COPY /x11vnc /usr/bin/x11vnc
RUN chmod -R 770 /opt/scripts/ && \
	chown -R jdownloader /opt/scripts && \
	chmod -R 770 /mnt && \
	chown -R jdownloader /mnt && \
	chmod 751 /usr/bin/x11vnc

USER jdownloader

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]