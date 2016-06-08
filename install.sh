cat << EOF | sudo tee -a /etc/systemd/system/overwatch-api.service > /dev/null
[Unit]
Description=Unofficial Overwatch API
After=network.target

[Service]
User=prof-oak
Group=prof-oak
WorkingDirectory=/opt/overwatch-api
ExecStart=/usr/bin/ruby /opt/overwatch-api/server.rb foobared
ExecStop=/bin/kill -15 $MAINPID
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo adduser --system --group --no-create-home prof-oak
sudo chown prof-oak:prof-oak /opt/overwatch-api
sudo chown prof-oak:prof-oak /etc/systemd/system/overwatch-api.service
sudo chmod 770 /opt/overwatch-api
sudo systemctl enable overwatch-api
sudo systemctl daemon-reload
sudo systemctl start overwatch-api
