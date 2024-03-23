#!/bin/bash

# 安装依赖
apt-get update
apt-get install -y wget

# 下载frpc armv7版本
FRPC_URL="http://43.132.227.252:9090/https://github.com/fatedier/frp/releases/download/v0.47.0/frp_0.47.0_linux_arm.tar.gz"
wget --no-check-certificate -O frpc.tar.gz $FRPC_URL
tar -xzf frpc.tar.gz

# 安装frpc
mkdir -p /usr/local/frp
mv frp_0.47.0_linux_arm /usr/local/frp/frpc
chmod +x /usr/local/frp/frpc

# 提示用户输入服务器信息
read -p "请输入frps服务器的IP地址: " SERVER_ADDR
read -p "请输入frps服务器的端口: " SERVER_PORT
read -p "请输入frps分配的远程端口: " REMOTE_PORT
read -p "请输入连接密码: " TOKEN

# 创建配置文件
cat > /usr/local/frp/frpc.ini << EOF
[common]
server_addr = $SERVER_ADDR
server_port = $SERVER_PORT
token = $TOKEN

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = $REMOTE_PORT
EOF

# 创建systemd服务
cat > /etc/systemd/system/frpc.service << EOF
[Unit]
Description=frpc
After=network.target

[Service]
Type=simple
User=nobody
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/frp/frpc -c /usr/local/frp/frpc.ini

[Install]
WantedBy=multi-user.target
EOF

# 启动frpc
systemctl daemon-reload
systemctl enable frpc
systemctl start frpc

echo "frpc已安装并启动"
