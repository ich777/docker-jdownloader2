#!/bin/bash
echo "---Checking for 'jDownloader.jar'---"
if [ ! -f ${DATA_DIR}/JDownloader.jar ]; then
	echo "---'jDownloader.jar' not found, copying...---"
	cd ${DATA_DIR}
	cp /tmp/JDownloader.jar ${DATA_DIR}/JDownloader.jar
	if [ ! -f ${DATA_DIR}/JDownloader.jar ]; then
		echo "--------------------------------------------------------------------------------------"
		echo "---Something went wrong can't copy 'jDownloader.jar', putting server in sleep mode!---"
		echo "--------------------------------------------------------------------------------------"
		sleep infinity
	fi
else
	echo "---'jDownloader.jar' folder found---"
fi

echo "---Preparing Server---"
echo "---Checking libraries---"
if [ ! -d ${DATA_DIR}/libs ]; then
	mkdir ${DATA_DIR}/libs
fi
if [ ! -f ${DATA_DIR}/libs/sevenzipjbinding1509Linux.jar ]; then
	cd ${DATA_DIR}/libs
	if [ ! -f ${DATA_DIR}/libs/lib.tar.gz ]; then
		cp /tmp/lib.tar.gz ${DATA_DIR}/libs/lib.tar.gz
	fi
    if [ -f ${DATA_DIR}/libs/lib.tar.gz ]; then
    	tar -xf ${DATA_DIR}/libs/lib.tar.gz
    	rm ${DATA_DIR}/libs/lib.tar.gz
	fi
else
	echo "---Libraries found!---"
fi
if [ ! -f ${DATA_DIR}/libs/sevenzipjbinding1509.jar ]; then
	cd ${DATA_DIR}/libs
	if [ ! -f ${DATA_DIR}/libs/lib.tar.gz ]; then
		cp /tmp/lib.tar.gz ${DATA_DIR}/libs/lib.tar.gz
	fi
    if [ -f ${DATA_DIR}/libs/lib.tar.gz ]; then
    	tar -xf ${DATA_DIR}/libs/lib.tar.gz
    	rm ${DATA_DIR}/libs/lib.tar.gz
	fi
fi

echo "---Checking for old logfiles---"
find $DATA_DIR -name "XvfbLog.*" -exec rm -f {} \;
find $DATA_DIR -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old display lock files---"
find /tmp -name ".X99*" -exec rm -f {} \; > /dev/null 2>&1

echo "---Resolution check---"
if [ -z "${CUSTOM_RES_W} ]; then
	CUSTOM_RES_W=1024
fi
if [ -z "${CUSTOM_RES_H} ]; then
	CUSTOM_RES_H=768
fi

if [ "${CUSTOM_RES_W}" -le 1024 ]; then
	echo "---Width to low must be a minimal of 1024 pixels, correcting to 1024...---"
    CUSTOM_RES_W=1024
fi
if [ "${CUSTOM_RES_H}" -le 768 ]; then
	echo "---Height to low must be a minimal of 768 pixels, correcting to 768...---"
    CUSTOM_RES_H=768
fi

if [ ! -d ${DATA_DIR}/cfg ]; then
	mkdir ${DATA_DIR}/cfg
fi

if [ ! -f "${DATA_DIR}/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.lastframestatus.json" ]; then
    cd "${DATA_DIR}/cfg"
    touch "org.jdownloader.settings.GraphicalUserInterfaceSettings.lastframestatus.json"
	echo '{
  "extendedState" : "NORMAL",
  "width" : '${CUSTOM_RES_W}',
  "height" : '${CUSTOM_RES_H}',
  "x" : 0,
  "visible" : true,
  "y" : 0,
  "silentShutdown" : false,
  "screenID" : ":0.0",
  "locationSet" : true,
  "focus" : true,
  "active" : true
}' >> "${DATA_DIR}/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.lastframestatus.json"
fi

sed -i '/"width"/c\  "width" : '${CUSTOM_RES_W}',' "${DATA_DIR}/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.lastframestatus.json"
sed -i '/"height"/c\  "height" : '${CUSTOM_RES_H}',' "${DATA_DIR}/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.lastframestatus.json"
if [ ! -f "${DATA_DIR}/cfg/org.jdownloader.settings.GeneralSettings.json" ]; then
    cd "${DATA_DIR}/cfg"
    touch "org.jdownloader.settings.GeneralSettings.json"
	echo '{
  "defaultdownloadfolder" : "/mnt/jDownloader"
}' >> "${DATA_DIR}/cfg/org.jdownloader.settings.GeneralSettings.json"
fi
sed -i '/Downloads"/c\  "defaultdownloadfolder" : "\/mnt\/jDownloader",' "${DATA_DIR}/cfg/org.jdownloader.settings.GeneralSettings.json"
echo "---Window resolution: ${CUSTOM_RES_W}x${CUSTOM_RES_H}---"

chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Xvfb server---"
screen -S Xvfb -L -Logfile ${DATA_DIR}/XvfbLog.0 -d -m /opt/scripts/start-Xvfb.sh
sleep 2
echo "---Starting x11vnc server---"
screen -S x11vnc -L -Logfile ${DATA_DIR}/x11vncLog.0 -d -m /opt/scripts/start-x11.sh
sleep 2
echo "---Starting noVNC server---"
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem ${NOVNC_PORT} localhost:${RFB_PORT}
sleep 2

echo "---Starting jDownloader2---"
export DISPLAY=:99
cd ${DATA_DIR}
/usr/bin/java -jar ${DATA_DIR}/JDownloader.jar