#!/bin/bash
set -e

# Refresh the credentials files
if [ -z "$MAGNETICOW_USERNAME" ] && [ -z "$MAGNETICOW_PASSWORD" ]; then
    echo "No username and password provided in the environment variables. Using '--no-auth' for magneticow"
	magneticow_args="--no-auth"
elif [ -z "$MAGNETICOW_USERNAME" ] && [ ! -z "$MAGNETICOW_PASSWORD" ]; then
    echo "No username for magneticow is provided in the environment variable"
	exit 0
elif [ ! -z "$MAGNETICOW_USERNAME" ] && [ -z "$MAGNETICOW_PASSWORD" ]; then
    echo "No password for magneticow is provided in the environment variable"
	exit 0
elif [ ! -z "$MAGNETICOW_USERNAME" ] && [ ! -z "$MAGNETICOW_PASSWORD" ]; then
    echo "Refreshing the credentials file"
	htpasswd -cbBC 12 /opt/magnetico/credentials "$MAGNETICOW_USERNAME" "$MAGNETICOW_PASSWORD"
	magneticow_args="--credentials=/opt/magnetico/credentials"
fi

if [ -z "$MAGNETICOW_ADDRESS" ]; then
    echo "No address for magneticow is provided in the environment variable, using default 0.0.0.0"
	MAGNETICOW_ADDRESS="0.0.0.0"
else
    echo "Setting magneticow address to $MAGNETICOW_ADDRESS"
fi

if [ -z "$MAGNETICOW_PORT" ]; then
    echo "No port for magneticow is provided in the environment variable, using default 8080"
	MAGNETICOW_PORT="8080"
else
    echo "Setting magneticow port to $MAGNETICOW_PORT"
fi
magneticow_args="$magneticow_args --addr=$MAGNETICOW_ADDRESS:$MAGNETICOW_PORT"

echo "[INFO] Starting magneticow..." | ts '%Y-%m-%d %H:%M:%.S'
/bin/bash /opt/magnetico/magneticow.init start &
chmod -R 755 /opt/magnetico

sleep 1
magneticowpid=$(pgrep -o -x magneticow)
echo "[INFO] magneticow PID: $magneticowpid" | ts '%Y-%m-%d %H:%M:%.S'

if [ -e /proc/$jackettpid ]; then
	if [[ -e /opt/magnetico/Logs/magneticow.txt ]]; then
		chmod 775 /opt/magnetico/Logs/magneticow.txt
	fi
	sleep infinity
else
	echo "magneticow failed to start!"
fi