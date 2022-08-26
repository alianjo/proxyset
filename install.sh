#! /bin/bash
which ssh
if [[ $? -ne 0 ]]; then
	echo 'install ssh first'
	if [[ $whoami != "root" ]] ; then
		echo "$USER is not privilaged"
		exit 1
	fi 
	apt install ssh-client -y
fi

chmod +x app/proxyset && cp app/proxyset /bin
# add config file
cat > /etc/proxyset.conf << EOF
# Note: this is env file pass variables like environment variables
#ssh-server-IP
SERVER_IP=     

#ssh-port : default 22
SERVER_PORT= 

#ssh-private-key: default is ~/.ssh/id_rsa of root user
SERVER_PRIVATE_KEY=   

#port of proxy : default 8050
TUNNEL_PORT=     

# ssh server user : default ubuntu
SSH_USER=             
EOF

echo "Add app to systemd services"

cat > /etc/systemd/system/proxyset.service << EOF
[Unit]
Description= Proxyset helps you keep your tunnel connected 
After=network.target

[Service]
Type=simple
ExecStart=/bin/proxyset
Restart=always


[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload