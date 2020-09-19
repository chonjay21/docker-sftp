#!/usr/bin/env bash
set -e

FORCE_REINIT_CONFIG=${FORCE_REINIT_CONFIG:=false}
APP_UID=${APP_UID:=1000}
APP_GID=${APP_GID:=1000}
APP_USER_NAME=${APP_USER_NAME:=admin}
APP_USER_PASSWD=${APP_USER_PASSWD:=admin}
APP_UMASK=${APP_UMASK:=007}
APP_SSHD_PORT=${APP_SSHD_PORT:=22}
APP_MOTD_MSG=${APP_MOTD_MSG:=Welcome!!!}
if [ -f "$SFTP_SOURCE_DIR/Initialized" ] && [ "$FORCE_REINIT_CONFIG" = false ]; then
	echo "[] Skip initializing"
else
	echo "[] Creating initial data ..."	
	chmod 770 $SFTP_SOURCE_DIR/eventscripts/*.sh || true
	echo "[] Running on_pre_init.sh ..."
		. $SFTP_SOURCE_DIR/eventscripts/on_pre_init.sh || true
	echo "[] Done."


	echo "[] Setting UID/GID ..."
		groupadd $APP_USER_NAME || true
		useradd $APP_USER_NAME -g $APP_USER_NAME -d $SFTP_DATA_PATH -s /bin/bash || true
		groupmod -o -g $APP_GID $APP_USER_NAME || true
		usermod -o -u $APP_UID $APP_USER_NAME || true
	echo "[] Done."
	
	echo "[] Coping configs ..."	
		cp $SFTP_SOURCE_DIR/sshd_config $SFTP_CONF_PATH || true
		sed -i "s|Port 22|Port ${APP_SSHD_PORT}|g" $SFTP_CONF_PATH
		sed -i "s|Subsystem sftp internal-sftp -u 007|Subsystem sftp internal-sftp -u ${APP_UMASK}|g" $SFTP_CONF_PATH
		sed -i "s|umask .*|umask ${APP_UMASK}|g" /etc/profile

		cp $SFTP_SOURCE_DIR/motd $SFTP_MOTD_PATH || true
		echo ${APP_MOTD_MSG} > $SFTP_MOTD_PATH
	echo "Done ."
	
	echo "[] Fixing permision ..."
		chown -R $APP_USER_NAME:$APP_USER_NAME $SFTP_CONF_PATH
		chown $APP_USER_NAME:$APP_USER_NAME $SFTP_DATA_PATH
		chown $APP_USER_NAME:$APP_USER_NAME $SFTP_DATA_PATH/data || true
	echo "Done."
	
	echo "[] Setting password: ${APP_USER_NAME}"	
		echo ${APP_USER_NAME}:${APP_USER_PASSWD} | chpasswd
	echo "[] Done."
	
	echo "[] Creating ssh_host_key ..."	
		ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N "" || true
		ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N "" || true
	echo "[] Done."

	touch $SFTP_SOURCE_DIR/Initialized || true
	echo "[] Running on_post_init.sh ..."
		. $SFTP_SOURCE_DIR/eventscripts/on_post_init.sh || true
	echo "[] Done."	
	echo "[] Initialize complete."
fi

echo "[] Running on_run.sh ..."
. $SFTP_SOURCE_DIR/eventscripts/on_run.sh || true
echo "[] Done."	
echo "[] Run sshd ..."
(umask $APP_UMASK && /usr/sbin/sshd -D -e)
echo "[] Done."	

