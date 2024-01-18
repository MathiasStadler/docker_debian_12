sudo docker run -it \
-e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
-v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
--group-add $(getent group audio | cut -d: -f3) \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
--cap-add SYS_ADMIN \
--security-opt apparmor=unconfined \
--tmpfs /run \ 
debian_chrome_xvfb_rust_9   bash
