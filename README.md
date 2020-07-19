# magnetico Docker environment
[_"magnetico is an autonomous (self-hosted) BitTorrent DHT search engine suite."_](https://github.com/boramalper/magnetico)
This Docker runs a basic magnetico environment, magneticow, the webserver and magneticod, the DHT Crawler.

[results]: https://raw.githubusercontent.com/DyonR/docker-templates/master/Screenshots/magnetico-environment/magneticow-results.png "magneticow results page"
![alt text][results]

## Docker Features
* Base: Debian 10
* Latest magneticow and magneticod
* All magnetico settings adjustable via environment variables.
* Build with [Unraid](https://unraid.net/) in mind

# Run container from Docker registry
The container is available from the Docker registry and this is the simplest way to get it.
To run the container use this command:

```
$ docker run  -d \
              -v /your/database/path/:/root/.local/share/magneticod \
              -e "USERNAME=magneticow" \
              -e "PASSWORD=magneticow" \
              -p 8080:8080 \
              --restart unless-stopped \
              dyonr/magnetico-environment
```

# Variables, Volumes, and Ports
## Environment Variables
| Variable | Required | Description | Example | Default |
|----------|----------|----------|----------|----------|
| **magneticow** | | | | |
|`MAGNETICOW_USERNAME`| No* | Username used to access the magneticow web interface |`MAGNETICOW_USERNAME=magneticow`|`magneticow`||
|`MAGNETICOW_PASSWORD`| No* | Password used to access the magneticow web interface |`MAGNETICOW_USERNAME=magneticow`|`magneticow`||
|`MAGNETICOW_ADDRESS`| No | Host address of magneticow |`MAGNETICOW_ADDRESS=0.0.0.0`|`0.0.0.0`|
|`MAGNETICOW_PORT`| No | Port that magneticow gets hosted on |`MAGNETICOW_PORT=8080`|`8080`|
|`MAGNETICOW_VERBOSE`| No | If set to `1`, `true` or `yes`, magneticow will run verbose |`MAGNETICOW_VERBOSE=yes`||
| **magneticod** | | | | |
|`MAGNETICOD_ADDRESS`| No | IP-address used by magneticod for indexing on the DHT network |`MAGNETICOD_ADDRESS=0.0.0.0`|`0.0.0.0`|
|`MAGNETICOD_PORT`| No | Port used by magneticod for indexing on the DHT network |`MAGNETICOD_PORT=54231`|`0`|
|`MAGNETICOD_INTERVAL`| No | The indexing interval in seconds |`MAGNETICOD_INTERVAL=30`|`1`|
|`MAGNETICOD_NEIGHBORS`| No | The maximum numbers of neighbors of an indexer |`MAGNETICOD_NEIGHBORS=500`|`1000`|
|`MAGNETICOD_LEECHES`| No | The maximum numbers of leeches |`MAGNETICOD_LEECHES=25`|`50`|
|`MAGNETICOD_VERBOSE`| No | If set to `1`, `true` or `yes`, magneticod will run verbose |`MAGNETICOD_VERBOSE=yes`||

\* Username and password are not required if both aren't defined. It's either both empty, or both filled in.

## Volumes
| Volume | Required | Description | Example |
|----------|----------|----------|----------|
| `config` | Yes | The path where magneticod will store its database | `/your/database/path/:/root/.local/share/magneticod/database.sqlite3`|

## Ports
| Port | Proto | Required | Description | Example |
|----------|----------|----------|----------|----------|
| `8080` | TCP | Yes | Port of the magneticow web interface | `8080:8080`|

# Access the magnetico web interface
Access http://IPADDRESS:PORT from a browser on the same network (for example: http://192.168.0.90:8080).

# Issues
If you are having issues with this container please submit an issue on GitHub.
Please provide logs, Docker version and other information that can simplify reproducing the issue.
Using the latest stable verison of Docker is always recommended. Support for older version is on a best-effort basis.
If the issue is related to magneticow or magneticod, [please sumbit an issue on their GitHub](https://github.com/boramalper/magnetico).
