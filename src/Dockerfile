# Run Chrome in a container
#
# docker run -it \
#   --net host \ # may as well YOLO
#   --cpuset-cpus 0 \ # control the cpu
#   --memory 512mb \ # max memory it can use
#   -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
#   -e DISPLAY=unix$DISPLAY \
#   -v $HOME/Downloads:/home/chrome/Downloads \
#   -v $HOME/.config/google-chrome/:/data \ # if you want to save state
#   --security-opt seccomp=$HOME/chrome.json \
#   --device /dev/snd \ # so we have sound
#   --device /dev/dri \
#   -v /dev/shm:/dev/shm \
#   --name chrome \
#   debian_12_google_chrome


# FROM debian:stable-slim
FROM debian:12.4

RUN apt -y  --fix-missing update
RUN apt -y  --fix-missing upgrade
RUN apt -y  install xvfb \
    x11vnc \
    fluxbox \ 
    apt-transport-https \
    curl \
    gpg \
    sudo \
    systemd \
    systemd-sysv \
    dbus \
    dbus-x11 \
    dbus-user-session \ 
    mesa-utils \
    mesa-utils-extra \
    libcanberra-gtk* \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    hicolor-icon-theme \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpango1.0-0 \
    libpulse0 \
    libv4l-0 \
    fonts-symbola \
    systemd \
    bash \
    vim
# --no-install-recommends




# install google-chrome from here
# https://linux.how2shout.com/install-google-chrome-on-debian-12-bookworm/

# alt RUN apt -yqq install apt-transport-https curl gpg sudo
RUN curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
RUN echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list
RUN apt update
RUN apt -yqq install google-chrome-stable 
# --no-install-recommends

#create user
# Environment variables for user
ENV PUID='1001'
ENV PGID='1001'
ENV USER='user'

# create user $USERdocker buildx build --progress=plain -t debian_12_google_chrome -f Dockerfile "."

RUN groupadd --gid "$PGID" "$USER" 
RUN useradd --home-dir /home/$USER --shell /bin/bash --uid "$PUID" --gid "$PGID" "$USER" 
# RUN echo $USER | passwd --stdin $USER
RUN mkdir /home/$USER && chown -R $USER:$USER /home/$USER 
# add $USER to sudo
RUN mkdir -p /etc/sudoers.d 
RUN echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"$USER" \
    && chmod 0440 /etc/sudoers.d/"$USER"
#set dbus for user 
RUN echo "export XDG_RUNTIME_DIR=/run/user/$(id -u ${USER})" > /home/${USER}/.bashrc && \
    echo "export DBUS_SESSION_BUS_ADDRESS=\"unix:path=$XDG_RUNTIME_DIR/bus\"" >> /home/${USER}/.bashrc

# install dbus
#FROM HERE https://github.com/mviereck/x11docker/issues/229
# alt RUN apt-get update && apt-get install -yqq systemd \
#    systemd-sysv \
#    dbus \
#    dbus-x11 \
#    dbus-user-session \ 
#    mesa-utils \
#    mesa-utils-extra

# copy bootstrap.sh
RUN mkdir -p /opt
COPY /bootstrap.sh /opt

# copy docker-entrypoint
COPY docker-dbus-entrypoint.sh /opt


# clean up
RUN apt-get autoremove --purge --auto-remove -y \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

RUN chmod +x /opt//docker-dbus-entrypoint.sh
ENTRYPOINT ["/opt/docker-dbus-entrypoint.sh"]

# docker buildx build --progress=plain -t debian_12_google_chrome -f Dockerfile "."

# docker run -it debian_12_google_chrome bash

# docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --security-opt apparmor=unconfined --tmpfs /run debian_12_google_chrome bash

# overwrite entrypoint
# docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --security-opt apparmor=unconfined --tmpfs /run  --entrypoint bash debian_12_google_chrome

# /w dri
# docker run -it --net host --cpuset-cpus 0 --memory 512mb -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v $HOME/Downloads:/home/chrome/Downloads -v $HOME/.config/google-chrome/:/data --security-opt seccomp=$HOME/chrome.json --device /dev/snd --device /dev/dri -v /dev/shm:/dev/shm --name chrome --entrypoint bash debian_12_google_chrome

# /w --tmpfs /run
# docker run -it --net host --cpuset-cpus 0 --memory 512mb -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v $HOME/Downloads:/home/chrome/Downloads -v $HOME/.config/google-chrome/:/data --security-opt seccomp=$HOME/chrome.json --device /dev/snd --device /dev/dri -v /dev/shm:/dev/shm --tmpfs /run --name chrome --entrypoint bash debian_12_google_chrome
