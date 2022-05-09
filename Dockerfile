FROM debian:bullseye-slim

LABEL maintainer "Yuki Kikuchi <bclswl0827@yahoo.co.jp>"
ENV APT_MIRROR="mirrors.bfsu.edu.cn" \
    DEBIAN_FRONTEND=noninteractive

COPY rootfs /
RUN if [ "x${APT_MIRROR}" != "x" ]; then \
      sed -e "s/security.debian.org/${APT_MIRROR}/g" \
          -e "s/deb.debian.org/${APT_MIRROR}/g" \
          -i /etc/apt/sources.list; \
    fi \
    && apt-get update \
    && apt-get -y --no-install-recommends install software-properties-common curl apache2-utils ibus-pinyin \
                                       supervisor nginx sudo net-tools zenity xz-utils ibus-gtk3 ibus-clutter \
                                       dbus-x11 x11-utils mesa-utils libgl1-mesa-dri lxde ibus-gtk build-essential \
                                       xvfb x11vnc firefox-esr ttf-wqy-zenhei im-config ibus ffmpeg tini arc-theme \
                                       gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf \
                                       gtk2-engines-murrine python3-pip python3-dev \
    && ln -s /usr/bin/python3 /usr/local/bin/python; pip3 install setuptools wheel numpy -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip3 install -r /usr/local/lib/web/backend/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && ln -sf /usr/local/lib/web/frontend/websockify /usr/local/lib/web/frontend/novnc/utils/websockify \
    && ln -s /usr/bin/tini /bin/tini; chmod +x /usr/local/lib/web/frontend/websockify/run; im-config -n ibus \
    && sed -i "s/%sudo	ALL=(ALL:ALL) ALL/%sudo	ALL=(ALL:ALL) NOPASSWD:ALL/g" /etc/sudoers \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 5900
EXPOSE 8888

ENTRYPOINT ["/startup.sh"]
