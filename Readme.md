本镜像基于[深度操作系统](https://www.deepin.org/)

感谢[bestwu](https://github.com/bestwu/)提供的深度镜像

可以使用
```
cajviewer.sh start
```
来启动

或者
```
xhost + &&\
docker run -d --name cajviewer \
    	-v /tmp/.X11-unix:/tmp/.X11-unix \
    	-v ${HOME}/文档:/Documents \
    	-e DISPLAY=unix${DISPLAY} \
    	-e XMODIFIERS=@im=${IM} \
    	-e QT_IM_MODULE=${IM} \
    	-e GTK_IM_MODULE=${IM} \
        -e VIDEO_GID=`getent group video | cut -d: -f3` \
    	-e GID=`id -g` \
    	-e UID=`id -u` \
    	sxyzy1016/cajviewer
```
也可使用docker-compose:
```yml
version: '2'
services:
  cajviewer:
    image: sxyzy1016/cajviewer
    container_name: cajviewer
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - ${HOME}/文档:/Documents
    environment:
      - DISPLAY=unix$DISPLAY
      - XMODIFIERS=@im=fcitx
      - QT_IM_MODULE=fcitx
      - GTK_IM_MODULE=fcitx
      - VIDEO_GID=??
      - GID=??
      - UID=??
```

若出现如下错误：
```
X Error of failed request： BadAccess （attempt access private resource ***）
 Major opcode of failed request：130（MIT-SHM)
```
可以：
```
cat > /etc/xorg.conf.d/00-mit-shm.conf << EOF
Section "Extensions"
     Option "MIT-SHM" "Disable"
EndSection
EOF
```
来禁用“MIT-SHM”共享（需要重启）