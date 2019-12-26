FROM ich777/debian-baseimage

MAINTAINER ich777

RUN export TZ=Europe/Rome && \
	apt-get update && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	apt-get -y install --no-install-recommends xvfb wmctrl x11vnc fluxbox screen novnc fonts-takao && \
	echo "ko_KR.UTF-8 UTF-8
ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i '/    document.title =/c\    document.title = "jDownloader2 - noVNC";' /usr/share/novnc/app/ui.js && \
	rm /usr/share/novnc/app/images/icons/*


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
COPY /x11vnc /usr/bin/x11vnc && \
	/icons/16x16.png /usr/share/novnc/app/images/icons/novnc-16x16.png && \
	/icons/24x24.png /usr/share/novnc/app/images/icons/novnc-24x24.png && \
	/icons/32x32.png /usr/share/novnc/app/images/icons/novnc-32x32.png && \
	/icons/48x48.png /usr/share/novnc/app/images/icons/novnc-48x48.png && \
	/icons/60x60.png /usr/share/novnc/app/images/icons/novnc-60x60.png && \
	/icons/64x64.png /usr/share/novnc/app/images/icons/novnc-64x64.png && \
	/icons/72x72.png /usr/share/novnc/app/images/icons/novnc-72x72.png && \
	/icons/76x76.png /usr/share/novnc/app/images/icons/novnc-76x76.png && \
	/icons/96x96.png /usr/share/novnc/app/images/icons/novnc-96x96.png && \
	/icons/120x120.png /usr/share/novnc/app/images/icons/novnc-120x120.png && \
	/icons/144x144.png /usr/share/novnc/app/images/icons/novnc-144x144.png && \
	/icons/152x152.png /usr/share/novnc/app/images/icons/novnc-152x152.png && \
	/icons/192x192.png /usr/share/novnc/app/images/icons/novnc-192x192.png && \
	/icons/icon.svg /usr/share/novnc/app/images/icons/novnc-icon.svg && \
	/icons/icon.svg /usr/share/novnc/app/images/icons/novnc-icon-sm.svg
RUN chmod -R 770 /opt/scripts/ && \
	chown -R jdownloader /opt/scripts && \
	chmod -R 770 /mnt && \
	chown -R jdownloader /mnt && \
	chmod 751 /usr/bin/x11vnc

USER jdownloader

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]