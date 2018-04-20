FROM bestwu/deepin
LABEL maintainer="sxyzy1016 <sxyzy1016@outlook.com>"

RUN echo 'deb http://mirrors.kernel.org/deepin panda main non-free contrib universe' > /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends locales \
    && echo 'zh_CN.UTF-8 UTF-8' > /etc/locale.gen \
    && locale-gen \
    && echo -e 'LC_ALL="zh_CN.UTF-8"\nLANG="zh_CN.UTF-8"\nLANGUAGE="zh_CN:zh"\n' > /etc/default/locale \
    && rm -rf /var/lib/apt/lists/*

ENV LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    LANG=zh_CN.UTF-8 \
    TZ=UTC-8

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends deepin-wine deepin-wine32 deepin-wine32-preloader deepin-wine-helper deepin-wine-uninstaller \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends fonts-wqy-microhei fonts-wqy-zenhei fonts-adobe-source-han-serif-cn fonts-adobe-source-han-sans-cn \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends deepin.net.cnki.cajviewer \
    && rm -rf /var/lib/apt/lists/*

ENV APP=CAJViewer \
    AUDIO_GID=60 \
    VIDEO_GID=60 \
    GID=1000 \
    UID=1000

RUN groupadd -o -g $GID cajviewer \
    && groupmod -o -g $AUDIO_GID audio \
    && groupmod -o -g $VIDEO_GID video \
    && useradd -d "/home/cajviewer" -m -o -u $UID -g cajviewer -G audio,video cajviewer \
    && mkdir /Documents \
    && chown -R cajviewer:cajviewer /Documents \
    && ln -s /Documents /home/cajviewer/Documents

VOLUME [ "/Documents" ]

ADD entrypoint.sh /entrypoint.sh
ADD run.sh /run.sh

RUN chmod +x /entrypoint.sh \
    && chmod +x /run.sh

ENTRYPOINT [ "/entrypoint.sh" ]