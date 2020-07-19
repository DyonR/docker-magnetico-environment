#!/bin/bash
set -e

# Refresh the credentials files
if [ -z "$MAGNETICOW_USERNAME" ] && [ -z "$MAGNETICOW_PASSWORD" ]; then
    echo "No username and password provided in the environment variables. Using '--no-auth' for magneticow"
	magneticow_params="--no-auth"
elif [ -z "$MAGNETICOW_USERNAME" ] && [ ! -z "$MAGNETICOW_PASSWORD" ]; then
    echo "No username for magneticow is provided in the environment variable"
	exit 0
elif [ ! -z "$MAGNETICOW_USERNAME" ] && [ -z "$MAGNETICOW_PASSWORD" ]; then
    echo "No password for magneticow is provided in the environment variable"
	exit 0
elif [ ! -z "$MAGNETICOW_USERNAME" ] && [ ! -z "$MAGNETICOW_PASSWORD" ]; then
    echo "Refreshing the credentials file"
	htpasswd -cbBC 12 /opt/magnetico/credentials "$MAGNETICOW_USERNAME" "$MAGNETICOW_PASSWORD"
	magneticow_params="--credentials=/opt/magnetico/credentials"
fi