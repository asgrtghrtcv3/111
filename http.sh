#!/bin/bash

# 安装 apache2-utils 软件包
sudo apt-get update
sudo apt-get install squid -y

sudo apt-get install apache2-utils -y

# 创建一个新的用户，并为其设置密码
sudo htpasswd -b -c /etc/squid/passwd 1 1




# 编辑 Squid 配置文件
sudo sed -i 's/http_access deny all/#http_access deny all/g' /etc/squid/squid.conf


# 添加白名单域名
echo "acl whitelist src 18.143.149.65" | sudo tee -a /etc/squid/squid.conf
echo "http_access allow whitelist" | sudo tee -a /etc/squid/squid.conf

# 启用基本身份验证并指定密码文件的位置
echo "auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd" | sudo tee -a /etc/squid/squid.conf
echo "auth_param basic children 5" | sudo tee -a /etc/squid/squid.conf
echo "auth_param basic realm Squid proxy-caching web server" | sudo tee -a /etc/squid/squid.conf
echo "auth_param basic credentialsttl 2 hours" | sudo tee -a /etc/squid/squid.conf
echo "acl auth_users proxy_auth REQUIRED" | sudo tee -a /etc/squid/squid.conf
echo "http_access allow auth_users" | sudo tee -a /etc/squid/squid.conf





# 重启 Squid 服务以应用更改
sudo systemctl restart squid
