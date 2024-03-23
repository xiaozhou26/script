#!/bin/bash

# 安装必要的软件包
apt-get update
apt-get install -y wget

# 下载frp
wget https://github.com/fatedier/frp/releases/download/v0.44.0/frp_0.44.0_linux_amd64.tar.gz

# 解压frp
tar -zxvf frp_0.44.0_linux_amd64.tar.gz

# 进入frp目录
cd frp_0.44.0_linux_amd64

# 复制frps及配置文件到指定目录
mkdir -p /usr/local/frp
cp frps /usr/local/frp

# 提示用户输入bind_port
read -p "请输入frps的bind_port [默认7000]: " bind_port
bind_port=${bind_port:-7000}

# 提示用户输入token
read -p "请输入frps的token [默认12345678]: " token
token=${token:-12345678}

# 创建frps配置文件
cat > /usr/local/frp/frps.ini <<EOF
[common]
bind_port = $bind_port
token = $token
vhost_http_port = 80
vhost_https_port = 443
EOF

# 创建frps系统服务
cat > /lib/systemd/system/frps.service <<EOF
[Unit]
Description=frps service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/local/frp/frps -c /usr/local/frp/frps.ini

[Install]
WantedBy=multi-user.target
EOF

# 重新加载systemd配置
systemctl daemon-reload

# 设置开机自启动
systemctl enable frps

# 启动frps服务
systemctl start frps

echo "Frps 安装完成！"
