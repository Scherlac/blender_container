#!/bin/env bash


#!/bin/bash

if [ -z "$ACCESS_PW" ]; then
	echo >&2 'error: No ACCESS_PW provided'
	echo >&2 '  Did you forget to add -e ACCESS_PW= to the docker run command?'
	exit 1
fi

if [ -z "$XFB_SCREEN" ]; then
	XFB_SCREEN=1024x768x24
fi

if [ ! -z "$XFB_SCREEN_DPI" ]; then
	DPI_OPTIONS="-dpi $XFB_SCREEN_DPI"
fi

# first we need our security cookie and add it to user's .Xauthority
mcookie | sed -e 's/^/add :0 MIT-MAGIC-COOKIE-1 /' | xauth -q

# now place the security cookie with FamilyWild on volume so client can use it
# see http://stackoverflow.com/25280523 for details on the following command
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f /Xauthority/xserver.xauth nmerge -

# now boot X-Server, tell it to our cookie and give it sometime to start up
Xvfb :0 -auth ~/.Xauthority $DPI_OPTIONS -screen 0 $XFB_SCREEN >>~/xvfb.log 2>&1 &
sleep 2

# start the jupyter notebook
jupyter notebook --allow-root --no-browser --ip=0.0.0.0 --port=8888 &
# --token='' --password="${ACCESS_PW}" 
# start noVNC
novnc --listen 0.0.0.0:6080 --target localhost:5900 &
#websockify --web /usr/share/novnc/ 6080 localhost:5900 &
sleep 2


# finally we can run the VNC-Server based on our just started X-Server
x11vnc -forever -passwd $ACCESS_PW -display :0 & # -rfbport 5900 -shared -rfbauth /Xauthority/xserver.xauth -create &

sleep inf