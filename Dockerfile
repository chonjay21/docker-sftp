FROM alpine:latest

# Labels
LABEL Description "Our goal is to create a simple, consistent, customizable and convenient image using official image" \
	  maintainer "https://github.com/chonjay21"

# Environment variables
ENV SFTP_SOURCE_DIR=/sources/sftp \
	SFTP_DATA_PATH=/home/sftp \
	SFTP_MOTD_PATH=/etc/motd \
	SFTP_CONF_PATH=/etc/ssh/sshd_config
	
# install apps... (shadow for usermod/groupmode)
RUN apk update && apk upgrade; \
	apk add --no-cache \
	shadow \
	bash \
	tzdata \
	openssh \
	openssh-sftp-server \
	curl

ADD sources/ $SFTP_SOURCE_DIR/

# set permission
RUN chmod 770 $SFTP_SOURCE_DIR/*.sh; \
	chmod 770 $SFTP_SOURCE_DIR/eventscripts/*.sh; \
	mkdir -p /var/run/sshd

ENTRYPOINT $SFTP_SOURCE_DIR/entrypoint.sh