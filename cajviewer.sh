#!/bin/bash

IM=${GTK_IM_MODULE:-fcitx}

function stop() {
	if [ -n "$(docker ps -a -f "name=cajviewer_${USER}" -q)" ]; then
		docker stop cajviewer_${USER}
		docker rm -f cajviewer_${USER}
	fi
}

function start() {
	stop

	docker run -d --name cajviewer_${USER} --privileged=true \
        --device /dev/snd \
    	-v /tmp/.X11-unix:/tmp/.X11-unix \
        -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    	-v ${HOME}/文档:/Documents \
    	-e DISPLAY=unix${DISPLAY} \
        -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
        -e XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} \
    	-e XMODIFIERS=@im=${IM} \
    	-e QT_IM_MODULE=${IM} \
    	-e GTK_IM_MODULE=${IM} \
    	-e AUDIO_GID=`getent group audio | cut -d: -f3` \
        -e VIDEO_GID=`getent group video | cut -d: -f3` \
    	-e GID=`id -g` \
    	-e UID=`id -u` \
    	sxyzy1016/cajviewer
}

xhost +

case $1 in
	start)	start ;;
	stop)	stop ;;
	*)	echo "Usage: $0 (start|stop)" ;;
esac
