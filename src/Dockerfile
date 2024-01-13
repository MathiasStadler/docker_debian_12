FROM debian:stable-slim


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
    mesa-utils-extra


# install google-chrome from here
# https://linux.how2shout.com/install-google-chrome-on-debian-12-bookworm/

# alt RUN apt -yqq install apt-transport-https curl gpg sudo
RUN curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
RUN echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list
RUN apt update
RUN apt -yqq install google-chrome-stable


#create user
# Environment variables for user
ENV PUID='1001'
ENV PGID='1001'
ENV USER='user'

# create user $USER
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
RUN apt-get autoremove --auto-remove -y \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

RUN chmod +x /opt//docker-dbus-entrypoint.sh
ENTRYPOINT ["/opt/docker-dbus-entrypoint.sh"]


# docker buildx build --progress=plain -t debian_12 -f Dockerfile "."

# docker run -it debian_12 bash

# docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --security-opt apparmor=unconfined --tmpfs /run debian_12 bash

# overwrite entrypoint
# docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN --security-opt apparmor=unconfined --tmpfs /run  --entrypoint bash debian_12