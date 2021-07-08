#!/usr/bin/env bash
RUN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

CMD="/usr/local/bin/ddns -c /etc/config.json";

# Add ddns.timer to /etc/systemd/system
echo "[Unit]
Description=DDNS Timer
Wants=network-online.target
After=network-online.target

[Timer]
OnStartupSec=60
OnUnitActiveSec=10

[Install]
WantedBy=timers.target" > /etc/systemd/system/ddns.timer;

# Add ddns.service to /etc/systemd/system
echo "[Unit]
Description=DDNS Service
Wants=network-online.target
After=network-online.target

[Service]
User=root
Type=oneshot
ExecStart=$CMD
TimeoutSec=180

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/ddns.service;

# Enable and start ddns.timer
systemctl enable ddns.timer;
systemctl start ddns.timer;

echo "Use \"systemctl status ddns.service\" to view run logs,
Use \"systemctl status ddns.timer\" to view timer logs."
