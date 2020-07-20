FROM debian:10
MAINTAINER DyonR

# Creathe the directory in which magneticod and magneticow will be placed
RUN mkdir -p /opt/magnetico

# Update, upgrade and install some required packages
RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    curl \
    apache2-utils \
    moreutils \
    lsb-base \
    procps \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/locale \
    /usr/share/info \
    /usr/share/lintian
    
# Get magneticod and magneticow
RUN magnetico_latest=$(curl --silent "https://api.github.com/repos/boramalper/magnetico/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
    && curl -so /opt/magnetico/magneticod -L https://github.com/boramalper/magnetico/releases/download/$magnetico_latest/magneticod \
    && curl -so /opt/magnetico/magneticow -L https://github.com/boramalper/magnetico/releases/download/$magnetico_latest/magneticow

VOLUME /root/.local/share/magneticod

ADD magnetico/ /opt/magnetico/
WORKDIR /opt/magnetico

RUN chmod +x /opt/magnetico/*

EXPOSE 8080
CMD ["/opt/magnetico/run.sh"]

ENV MAGNETICOW_USERNAME= \
    MAGNETICOW_PASSWORD= \
	MAGNETICOW_ADDRESS=0.0.0.0 \
	MAGNETICOW_PORT=8080 \
	MAGNETICOW_VERBOSE=false \
	MAGNETICOD_ADDRESS=0.0.0.0 \
	MAGNETICOD_PORT=0 \
	MAGNETICOD_INTERVAL=1 \
	MAGNETICOD_NEIGHBORS=1000 \
	MAGNETICOD_LEECHES=50 \
	MAGNETICOD_VERBOSE=false