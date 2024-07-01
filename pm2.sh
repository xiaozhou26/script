# 创建 npm 全局目录并设置全局安装路径
mkdir -p ~/.npm-global && \
npm config set prefix '~/.npm-global'

# 将 npm 全局目录添加到 PATH
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile && \
source ~/.profile

# 全局安装 pm2
npm install -g pm2

# 再次加载环境变量
source ~/.profile

# 清理终端
clear
