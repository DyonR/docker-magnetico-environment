FROM debian:10
MAINTAINER DyonR

# Creathe the directory in which magneticod and magneticow will be placed
RUN mkdir -p /opt/magnetico

# Update, upgrade and install some required packages
RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    curl \
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
    && curl -o /opt/magnetico/magneticod -L https://github.com/boramalper/magnetico/releases/download/$magnetico_latest/magneticod \
	&& curl -o /opt/magnetico/magneticow -L https://github.com/boramalper/magnetico/releases/download/$magnetico_latest/magneticow \
	&& chmod +x /opt/magnetico/magnetico*

WORKDIR /opt/magnetico

EXPOSE 8080
CMD ["/bin/bash"]
