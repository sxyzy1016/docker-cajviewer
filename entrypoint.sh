#!/bin/bash

groupmod -o -g $AUDIO_GID audio
groupmod -o -g $VIDEO_GID video
groupmod -o -g $GID cajviewer
usermod  -o -u $UID cajviewer

chown cajviewer:cajviewer /Documents

su cajviewer << EOF

echo "启动 $APP"
/run.sh

EOF