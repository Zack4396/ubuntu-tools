#!usr/bin/env bash

# If LOCAL_TEMP_PROXY is not set, just leave a note.
LOCAL_TEMP_PROXY=${LOCAL_TEMP_PROXY:-none}

# If LOCAL_PROXY_PORT is not set, use default port 10809.
LOCAL_PROXY_PORT=${LOCAL_PROXY_PORT:-10809}

# If LOCAL_VPS_ADDRESS is not set, just leave a note.
LOCAL_VPS_ADDRESS=${LOCAL_VPS_ADDRESS:-none}

# If LOCAL_VPS_KEY is not set, just leave a note.
LOCAL_VPS_KEY=${LOCAL_VPS_KEY:-none}

# If LOCAL_VPS_PORT is not set, just leave a note.
LOCAL_VPS_PORT=${LOCAL_VPS_PORT:-none}

# If LOCAL_VPS_PORT is not set, use default protocol shadowsocks.
LOCAL_VPS_PROTOCOL=${LOCAL_VPS_PROTOCOL:-shadowsocks}

install_v2ray() {
  sudo apt install -y curl git

  git config --global http.sslverify "false"
  curl -x "$LOCAL_TEMP_PROXY" https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh -o /tmp/install-release.sh
  sudo bash /tmp/install-release.sh --remove
  sudo bash /tmp/install-release.sh -p $LOCAL_TEMP_PROXY
  git config --global --unset http.sslverify
}

create_shadowsocks_json() {
# Please visit https://v2ray.com/chapter_02/protocols/shadowsocks.html for more details.
cat > /tmp/config-shadowsocks.json <<EOF
{
  "inbounds": [{
    "port": $LOCAL_PROXY_PORT,
    "listen": "0.0.0.0",
    "protocol": "http",
    "settings": {
      "udp": false
    }   
  }],
  "outbounds": [{
    "protocol": "shadowsocks",
    "settings": {
      "servers": [{
            "address": "$LOCAL_VPS_ADDRESS",
            "method": "aes-128-gcm",
            "ota": false,
            "password": "$LOCAL_VPS_KEY",
            "port": $LOCAL_VPS_PORT,
            "level": 1
      }]
    }
  },{
    "protocol": "freedom",
    "tag": "direct",
    "settings": {}
  }],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [{
      "type": "field",
      "ip": ["geoip:private"],
      "outboundTag": "direct"
    }]
  }
}
EOF
sudo mv /tmp/config-shadowsocks.json /usr/local/etc/v2ray/config-shadowsocks.json
}

create_vmess_json() {
# Please visit https://v2ray.com/chapter_02/protocols/vmess.html for more details.
cat > /tmp/config-vmess.json <<EOF
{
  "inbounds": [{
    "port": $LOCAL_PROXY_PORT,
    "listen": "0.0.0.0",
    "protocol": "http",
    "settings": {
      "udp": false
    }
  }],
  "outbounds": [{
    "protocol": "vmess",
    "settings": {
      "vnext": [{
        "address": "$LOCAL_VPS_ADDRESS",
        "port": $LOCAL_VPS_PORT,
        "users": [{
          "id": "$LOCAL_VPS_KEY",
          "alterId": 0,
          "security": "auto",
          "level": 0
        }]
      }]
    }
  },{
    "protocol": "freedom",
    "tag": "direct",
    "settings": {}
  }],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [{
      "type": "field",
      "ip": ["geoip:private"],
      "outboundTag": "direct"
    }]
  }
}
EOF
sudo mv /tmp/config-vmess.json /usr/local/etc/v2ray/config-vmess.json
}

setup_v2ray() {
  echo -e "\n\n\n\n"
  echo "Here are the VPS settings"
  echo "LOCAL_VPS_PROTOCOL: $LOCAL_VPS_PROTOCOL"
  echo "LOCAL_VPS_ADDRESS : $LOCAL_VPS_ADDRESS"
  echo "LOCAL_VPS_KEY     : $LOCAL_VPS_KEY"
  echo "LOCAL_VPS_PORT    : $LOCAL_VPS_PORT"
  echo -e "\n\n\n\n"
  echo "Here are some commands which use to set/unset global proxy"
  echo "// repo, wget"
  echo "# export http_proxy=127.0.0.1:$LOCAL_PROXY_PORT"
  echo "# export https_proxy=127.0.0.1:$LOCAL_PROXY_PORT"
  echo "# export http_proxy="
  echo "# export https_proxy="
  echo "// curl"
  echo "# echo "proxy = 127.0.0.1:$LOCAL_PROXY_PORT" > ~/.curlrc"
  echo "# rm ~/.curlrc"
  echo "// git"
  echo "# git config --global http.proxy http://127.0.0.1:$LOCAL_PROXY_PORT"
  echo "# git config --global https.proxy http://127.0.0.1:$LOCAL_PROXY_PORT"
  echo "# git config --global --unset http.proxy"
  echo "# git config --global --unset https.proxy"

  create_shadowsocks_json
  create_vmess_json
  if [ $LOCAL_VPS_PROTOCOL == "vmess" ]; then
    create_vmess_json
    sudo cp /usr/local/etc/v2ray/config-vmess.json /usr/local/etc/v2ray/config.json
  else

    sudo cp /usr/local/etc/v2ray/config-shadowsocks.json /usr/local/etc/v2ray/config.json
  fi
  sudo systemctl enable v2ray
  sudo systemctl start v2ray
}

install_v2ray
setup_v2ray
