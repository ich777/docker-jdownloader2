FROM ich777/novnc-baseimage

LABEL maintainer="admin@minenet.at"

RUN export TZ=Europe/Rome && \
	apt-get update && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	apt-get -y install --no-install-recommends fonts-takao && \
	echo "ko_KR.UTF-8 UTF-8" >> /etc/locale.gen && \ 
	echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i '/    document.title =/c\    document.title = "jDownloader2 - noVNC";' /usr/share/novnc/app/ui.js && \
	rm /usr/share/novnc/app/images/icons/*


ENV DATA_DIR=/jDownloader2
ENV CUSTOM_RES_W=1280
ENV CUSTOM_RES_H=1024
ENV RUNTIME_NAME="basicjre"
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID jdownloader && \
	chown -R jdownloader $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
COPY /icons/* /usr/share/novnc/app/images/icons/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R jdownloader /opt/scripts && \
	chmod -R 770 /mnt && \
	chown -R jdownloader /mnt

USER jdownloader

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]