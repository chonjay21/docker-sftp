# [**Sftp**](https://github.com/chonjay21/docker-sftp)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/chonjay21/sftp)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/chonjay21/sftp)
![Docker Pulls](https://img.shields.io/docker/pulls/chonjay21/sftp)
![GitHub](https://img.shields.io/github/license/chonjay21/docker-sftp)
![Docker Stars](https://img.shields.io/docker/stars/chonjay21/sftp?style=social)
![GitHub stars](https://img.shields.io/github/stars/chonjay21/docker-sftp?style=social)
## Sftp based on official latest alpine image
* Support Multiple architectures
* Support ssh
* Support sftp
* Support ssh proxy tunnel
* Support umask change
* Support UserID|GroupID change
* Support custom TimeZone
* Support custom event script override

<br />

Our goal is to create a simple, consistent, customizable and convenient image using official image

Find me at:
* [GitHub](https://github.com/chonjay21)
* [Blog](https://chonjay.tistory.com/)

<br />

# Supported Architectures

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64, latest |
| armhf | arm32v7, latest |
| arm64 | arm64v8, latest |

<br />

# Usage

Here are some example snippets to help you get started running a container.

## docker (simple)

```
docker run -e APP_USER_NAME=admin -e APP_USER_PASSWD=admin -e APP_UID=1000 -e APP_GID=1000 -p 22:22 -v /sftp/data:/home/sftp/data chonjay21/sftp
```

## docker

```
docker run \
  -e APP_USER_NAME=admin	\
  -e APP_USER_PASSWD=admin	\
  -e APP_UID=1000	\
  -e APP_GID=1000	\
  -e FORCE_REINIT_CONFIG=false                                        `#optional` \
  -e APP_UMASK=007                                                    `#optional` \
  -e APP_SSHD_PORT=22                                                 `#optional` \
  -e APP_MOTD_MSG="Welcome!!!"                                        `#optional` \
  -e TZ=America/Los_Angeles                                           `#optional` \
  -p 22:22 \
  -v /sftp/data:/home/sftp/data \
  -v /etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key:ro           `#optional` \
  -v /etc/ssh/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key:ro   `#optional` \
  chonjay21/sftp
```


## docker-compose

Compatible with docker-compose v2 schemas. (also compatible with docker-compose v3)

```
version: '2.2'
services:
  sftp:
    container_name: sftp
    image: "chonjay21/sftp:latest"
    ports:
      - "22:22"
    environment:
      - APP_USER_NAME=admin
      - APP_USER_PASSWD=admin
      - APP_UID=1000
      - APP_GID=1000
      - FORCE_REINIT_CONFIG=false                                                #optional
      - APP_UMASK=007                                                            #optional
      - APP_SSHD_PORT=22                                                         #optional
      - APP_MOTD_MSG="Welcome!!!"                                                #optional
      - TZ=America/Los_Angeles                                                   #optional
    volumes:
      - /sftp/data:/home/sftp/data
      - /etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key:ro                   #optional
      - /etc/ssh/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key:ro           #optional
```

# Parameters

| Parameter | Function | Optional |
| :---- | --- | :---: |
| `-p 22` | for sftp port |  |
| `-e APP_USER_NAME=admin` | for login username |  |
| `-e APP_USER_PASSWD=admin` | for login password |  |
| `-e APP_UID=1000` | for filesystem permission (userid)  |  |
| `-e APP_GID=1000` | for filesystem permission (groupid)  |  |
| `-e APP_UMASK=007` | for filesystem umask with sftp  | O |
| `-e APP_SSHD_PORT=22` | for default ssh/sftp port  | O |
| `-e APP_MOTD_MSG="Welcome!!!"` | for user login message  | O |
| `-e TZ=America/Los_Angeles` | for timezone  | O |
| `-e FORCE_REINIT_CONFIG=false` | if true, always reinitialize APP_USER_NAME etc ...  | O |
| `-v /home/sftp/data` | for data access with this container |  |
| `-v /etc/ssh/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key:ro` | for custom host key | O |
| `-v /etc/ssh/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key:ro` | for custom host key | O |

<br />

# Event scripts

All of our images are support custom event scripts

| Script | Function |
| :---- | --- |
| `/sources/sftp/eventscripts/on_pre_init.sh` | called before initialize container (only for first time) |
| `/sources/sftp/eventscripts/on_post_init.sh` | called after initialize container (only for first time) |
| `/sources/sftp/eventscripts/on_run.sh` | called before running app (every time) |

You can override these scripts for custom logic
for example, if you don`t want your password exposed by environment variable, you can override on_pre_init.sh in this manner

## Exmaple - on_pre_init.sh
```
#!/usr/bin/env bash
set -e

APP_USER_PASSWD=mysecretpassword    # or you can set password from secret store and get with curl etc ...
```

## 1. Override with volume mount
```
docker run \
  ...
  -v /sftp/on_pre_init.sh:/sources/sftp/eventscripts/on_pre_init.sh \
  ...
  chonjay21/sftp
```

## 2. Override with Dockerfile and build
```
FROM chonjay21/sftp:latest
ADD host/on_pre_init.sh /sources/sftp/
```

<br />

# Logs to file
* If you want to sshd access logs to file for fail2ban etc, you can use docker command with redirect in this manner.
```
docker logs -f sftp >> access.log 2>&1 &
```
```
docker logs -f sftp |tee -a access.log &
```

<br />

# License

View [license information](https://github.com/chonjay21/docker-sftp/blob/master/LICENSE) of this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.