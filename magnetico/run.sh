#!/bin/bash
set -e

echo "[INFO] Changing the ownership of the database" | ts '%Y-%m-%d %H:%M:%.S'
chown -Rv ${PUID}:${PGID} /root/.local/share/magneticod

# magneticow settings
# Refresh the credentials files
echo "----------- magneticow -----------"
if [ -z "$MAGNETICOW_USERNAME" ] && [ -z "$MAGNETICOW_PASSWORD" ]; then
    echo "[WARNING] No username and password provided in the environment variables. Using '--no-auth' for magneticow. Anyone can access magneticow without a password now." | ts '%Y-%m-%d %H:%M:%.S'
	magneticow_args="--no-auth"
elif [ -z "$MAGNETICOW_USERNAME" ] && [ ! -z "$MAGNETICOW_PASSWORD" ]; then
    echo "[ERROR] No username for magneticow is provided in the environment variable" | ts '%Y-%m-%d %H:%M:%.S'
	echo "[ERROR] You need to enter a username. It's either both username and password empty, or both filled in." | ts '%Y-%m-%d %H:%M:%.S'
	exit 0
elif [ ! -z "$MAGNETICOW_USERNAME" ] && [ -z "$MAGNETICOW_PASSWORD" ]; then
    echo "[ERROR] No password for magneticow is provided in the environment variable" | ts '%Y-%m-%d %H:%M:%.S'
	echo "[ERROR] You need to enter a password. It's either both username and password empty, or both filled in." | ts '%Y-%m-%d %H:%M:%.S'
	exit 0
elif [ ! -z "$MAGNETICOW_USERNAME" ] && [ ! -z "$MAGNETICOW_PASSWORD" ]; then
    echo "[INFO] Refreshing the credentials file" | ts '%Y-%m-%d %H:%M:%.S'
	htpasswd -cbBC 12 /opt/magnetico/credentials "$MAGNETICOW_USERNAME" "$MAGNETICOW_PASSWORD"
	magneticow_args="--credentials=/opt/magnetico/credentials"
fi

# Web address
if [ -z "$MAGNETICOW_ADDRESS" ]; then
    echo "[INFO] No address for magneticow is provided in the environment variable, using default 0.0.0.0" | ts '%Y-%m-%d %H:%M:%.S'
	MAGNETICOW_ADDRESS="0.0.0.0"
else
    echo "[INFO] Setting magneticow address to $MAGNETICOW_ADDRESS" | ts '%Y-%m-%d %H:%M:%.S'
fi

# Web port
if [ -z "$MAGNETICOW_PORT" ]; then
    echo "[INFO] No port for magneticow is provided in the environment variable, using default 8080" | ts '%Y-%m-%d %H:%M:%.S'
	MAGNETICOW_PORT="8080"
else
    echo "[INFO] Setting magneticow port to $MAGNETICOW_PORT" | ts '%Y-%m-%d %H:%M:%.S'
fi

magneticow_args="$magneticow_args --addr=$MAGNETICOW_ADDRESS:$MAGNETICOW_PORT"

if [[ $MAGNETICOW_VERBOSE == "1" || $MAGNETICOW_VERBOSE == "true" || $MAGNETICOW_VERBOSE == "yes" ]]; then
	echo "[INFO] Enabling verbosity for magneticow" | ts '%Y-%m-%d %H:%M:%.S'
	magneticow_args="$magneticow_args --verbose"
fi

export magneticow_args

# magneticod settings
# Indexing address
echo "----------- magneticod -----------"
if [ -z "$MAGNETICOD_ADDRESS" ]; then
    echo "[INFO] No indexing address for magneticod is provided in the environment variable, using default 0.0.0.0" | ts '%Y-%m-%d %H:%M:%.S'
	MAGNETICOD_ADDRESS="0.0.0.0"
else
    echo "[INFO] Setting magneticod indexing address to $MAGNETICOD_ADDRESS" | ts '%Y-%m-%d %H:%M:%.S'
fi

if [ -z "$MAGNETICOD_PORT" ]; then
    echo "[INFO] No indexing port for magneticod is provided in the environment variable, using default 0" | ts '%Y-%m-%d %H:%M:%.S'
	MAGNETICOD_PORT="0"
else
    echo "[INFO] Setting magneticod indexing port to $MAGNETICOD_PORT" | ts '%Y-%m-%d %H:%M:%.S'
fi

# Indexing interval
if [ -z "$MAGNETICOD_INTERVAL" ]; then
    echo "[INFO] No indexing interval for magneticod is provided in the environment variable, using default 1" | ts '%Y-%m-%d %H:%M:%.S'
	MAGNETICOD_INTERVAL="1"
else
    echo "[INFO] Setting magneticod indexing interval to $MAGNETICOD_INTERVAL" | ts '%Y-%m-%d %H:%M:%.S'
fi

# Maximum neighours for an indexer
if [ -z "$MAGNETICOD_NEIGHBORS" ]; then
    echo "[INFO] No maximum number of neighbors for magneticod is provided in the environment variable, using default 1000" | ts '%Y-%m-%d %H:%M:%.S'
	MAGNETICOD_NEIGHBORS="1000"
else
    echo "[INFO] Setting magneticod maximum number of neighbors to $MAGNETICOD_NEIGHBORS" | ts '%Y-%m-%d %H:%M:%.S'
fi

# Maximum leeches
if [ -z "$MAGNETICOD_LEECHES" ]; then
    echo "[INFO] No maximum number of leeches for magneticod is provided in the environment variable, using default 50" | ts '%Y-%m-%d %H:%M:%.S'
	MAGNETICOD_LEECHES="50"
else
    echo "[INFO] Setting magneticod maximum number of leeches to $MAGNETICOD_LEECHES" | ts '%Y-%m-%d %H:%M:%.S'
fi

magneticod_args="--indexer-addr=$MAGNETICOD_ADDRESS:$MAGNETICOD_PORT --indexer-interval=$MAGNETICOD_INTERVAL --indexer-max-neighbors=$MAGNETICOD_NEIGHBORS --leech-max-n=$MAGNETICOD_LEECHES"

# magneticod verbosity
if [[ $MAGNETICOD_VERBOSE == "1" || $MAGNETICOD_VERBOSE == "true" || $MAGNETICOD_VERBOSE == "yes" ]]; then
	echo "[INFO] Enabling verbosity for magneticod" | ts '%Y-%m-%d %H:%M:%.S'
	magneticod_args="$magneticod_args --verbose"
fi
export magneticod_args

echo "----------------------------------"

echo "[INFO] Starting magneticow..." | ts '%Y-%m-%d %H:%M:%.S'
/bin/bash /opt/magnetico/magneticow.init start &
chmod -R 755 /opt/magnetico
sleep 1

magneticowpid=$(pgrep -o -x magneticow)
echo "[INFO] magneticow PID: $magneticowpid" | ts '%Y-%m-%d %H:%M:%.S'

echo "[INFO] Starting magneticod..." | ts '%Y-%m-%d %H:%M:%.S'
/bin/bash /opt/magnetico/magneticod.init start &
chmod -R 755 /opt/magnetico
sleep 1

magneticodpid=$(pgrep -o -x magneticod)
echo "[INFO] magneticod PID: $magneticodpid" | ts '%Y-%m-%d %H:%M:%.S'
sleep 1

if [ -e /proc/$magneticowpid ] && [ -e /proc/$magneticodpid ]; then
	if [[ -e /opt/magnetico/Logs/magneticow.txt ]] && [[ -e /opt/magnetico/Logs/magneticod.txt ]]; then
		chmod 775 /opt/magnetico/Logs/magneticow.txt /opt/magnetico/Logs/magneticod.txt
	fi
	sleep infinity
else
	echo "[ERROR] magneticow or magneticod failed to start!"
fi