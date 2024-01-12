#!/bin/ash

# [FROM HERE](https://raw.githubusercontent.com/drcrane/xvfb-alpine-docker/master/bootstrap.sh)

launch_xvfb() {
    # Set defaults if the user did not specify envs.
    export DISPLAY=${XVFB_DISPLAY:-:1}
    local screen=${XVFB_SCREEN:-0}
    # local resolution=${XVFB_RESOLUTION:-1280x1024x24}
    # EIZO 
    local resolution=${XVFB_RESOLUTION:-1920x1080x24}
    local timeout=${XVFB_TIMEOUT:-5}

    # Start and wait for either Xvfb to be fully up,
    # or we hit the timeout.
    Xvfb ${DISPLAY} -screen ${screen} ${resolution} &
    local loopCount=0
    until xdpyinfo -display ${DISPLAY} > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            echo "[ERROR] xvfb failed to start."
            exit 1
        fi
    done
}

launch_window_manager() {
#    local timeout=${XVFB_TIMEOUT:-5}

    # Start and wait for either fluxbox to be fully up or we hit
    # the timeout.
    # test
    fluxbox -log "/root/.fluxbox/log" &
    sleep 10
    # export DISPLAY=$HOST_IP:1 && /usr/bin/google-chrome --no-sandbox \
    # export DISPLAY=:1 && google-chrome --no-sandbox \
    # --disable-features=Vulkan \
    # --no-first-run \
    # --no-setup \
    # --force-renderer-accessibility \
    # --enable-views-textfield \
    # --allow-file-access-from-files \
    # --disable-web-security \
    # --flag-switches-begin \
    # --flag-switches-end \
    # --disable-fre \
    # --no-default-browser-check \
    # --disable-session-crashed-bubble \
    # --start-fullscreen 
    # --log-severity=verbose \
    # --lang=en-US \
    # --user-data-dir=/home/user \
    # --log-file=/opt/output/debug.log \
    # --disable-gpu \
    # --disable-gpu-compositing \

#    local loopCount=0
#    until wmctrl -m > /dev/null 2>&1
#    do
#        loopCount=$((loopCount+1))
#        sleep 1
#        if [ ${loopCount} -gt ${timeout} ]
#        then
#            echo "${G_LOG_E} fluxbox failed to start."
#            exit 1
#        fi
#    done
}

run_vnc_server() {
    local passwordArgument='-nopw'

    if [ -n "${VNC_SERVER_PASSWORD}" ]
    then
        local passwordFilePath="${HOME}/x11vnc.pass"
        if ! x11vnc -storepasswd "${VNC_SERVER_PASSWORD}" "${passwordFilePath}"
        then
            echo "[ERROR] Failed to store x11vnc password."
            exit 1
        fi
        passwordArgument=-"-rfbauth ${passwordFilePath}"
        echo "[INFO] The VNC server will ask for a password."
    else
        echo "[WARN] The VNC server will NOT ask for a password."
    fi

    x11vnc -display ${DISPLAY} -forever ${passwordArgument} &
    # x11vnc -xkb -display ${DISPLAY} -forever ${passwordArgument} &
    wait $!
}

launch_google_chrome() {

/usr/bin/google-chrome --no-sandbox

}

launch_xvfb
launch_window_manager
run_vnc_server
launch_google_chrome