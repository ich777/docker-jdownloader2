FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV TZ=Europe/Rome
RUN apt-get -y install wget xvfb wmctrl x11vnc fluxbox screen novnc language-pack-en
ENV LANG=en_US.utf8

ENV DATA_DIR=/jDownloader2
ENV RUNTIME_NAME="jre1.8.0_211"
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID jdownloader
RUN chown -R jdownloader $DATA_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R jdownloader /opt/scripts
RUN chmod -R 770 /mnt
RUN chown -R jdownloader /mnt

USER jdownloader

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]