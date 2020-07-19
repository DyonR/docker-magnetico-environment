FROM debian:10
MAINTAINER DyonR

# Creathe the directory in which magneticod and magneticow will be placed
RUN mkdir -p /opt/magnetico

# Update, upgrade and install some required packages
RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    wget

WORKDIR /opt/magnetico
