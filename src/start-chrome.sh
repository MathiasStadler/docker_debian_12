export DISPLAY=:1
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
xhost +
# google-chrome-stable --no-sandbox --no-gpu --use-gl=desktop -ozone-plattform=wayland --disable-dev-shm-usage
# --disable-gpu --disable-software-rasterizer
google-chrome-stable --no-sandbox --no-gpu --use-gl=desktop -ozone-plattform=wayland --disable-dev-shm-usage --disable-gpu --disable-software-rasterizer --no-init