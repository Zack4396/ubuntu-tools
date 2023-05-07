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

log_info() {
  # green
  echo -en "\033[30;32m$@\033[0m"
}

log_notice() {
  # red
  echo -en "\033[30;31m$@\033[0m"
}

usage() {
  log_notice "Here are your exported settings\n"
  log_info "export LOCAL_TEMP_PROXY="$LOCAL_TEMP_PROXY"\n"
  log_info "export LOCAL_PROXY_PORT="$LOCAL_PROXY_PORT"\n"
  log_info "export LOCAL_VPS_PROTOCOL="$LOCAL_VPS_PROTOCOL"\n"
  log_info "export LOCAL_VPS_ADDRESS="$LOCAL_VPS_ADDRESS"\n"
  log_info "export LOCAL_VPS_PORT="$LOCAL_VPS_PORT"\n"
  log_info "export LOCAL_VPS_KEY="$LOCAL_VPS_KEY"\n"
}

check_is_running_as_root() {
  # Please don't executing this script with root, it will lose some exported env.
  if [[ "$UID" -eq '0' ]]; then
    echo "Running with root, exiting..."
    echo "Please switch to the normal user"
    exit 1
  fi
}

check_is_valid_env() {
  is_valid="true"
  ip=${LOCAL_TEMP_PROXY%:*}
  port=${LOCAL_TEMP_PROXY#*:}
  # Check IP address is or not valid
  if ! echo "$ip" | grep -qE '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'; then
    log_notice "LOCAL_TEMP_PROXY - has invalid IP address: $ip\n"
    is_valid="false"
  fi
  # Check port is or not valid
  if ! [[ "$port" =~ ^[0-9]+$ ]] || (( port < 1 )) || (( port > 65535 )); then
    log_notice "LOCAL_TEMP_PROXY - has invalid port number: $port\n"
    is_valid="false"
  fi

  proxy_port=$LOCAL_PROXY_PORT
  # Check proxy port is or not valid
  if ! [[ "$proxy_port" =~ ^[0-9]+$ ]] || (( proxy_port < 1 )) || (( proxy_port > 65535 )); then
    log_notice "LOCAL_PROXY_PORT - Invalid port number: $proxy_port\n"
    is_valid="false"
  fi

  vps_port=$LOCAL_VPS_PORT
  # Check vps port is or not valid
  if ! [[ "$vps_port" =~ ^[0-9]+$ ]] || (( vps_port < 1 )) || (( vps_port > 65535 )); then
    log_notice "LOCAL_VPS_PORT - Invalid port number: $vps_port\n"
    is_valid="false"
  fi

  vps_uuid=$LOCAL_VPS_KEY
  # Check vps uuid is or not valid
  if ! [[ "$vps_uuid" =~ ^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$ ]]; then
    log_notice "LOCAL_VPS_KEY - Invalid uuid: $vps_uuid\n"
    is_valid="false"
  fi

  vps_address=$LOCAL_VPS_ADDRESS
  log_info "try to ping vps server address - $vps_address\n"
  ping -c 1 "$vps_address" >/dev/null 2>&1
  if ! [[ $? -eq 0 ]]; then
    log_notice "LOCAL_VPS_ADDRESS - cannot be pinged: $vps_address\n"
    is_valid="false"
  fi

  if ! [[ "$is_valid" == "true" ]]; then
    log_notice "\nBefore running this script again, make sure you have corrected ENV.\n"
    usage
    exit 1
  fi
}

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

main() {
  check_is_valid_env
  check_is_running_as_root
  install_v2ray
  setup_v2ray

  echo -e "\n"
  log_notice "Please use this command to check the proxy is working now.\n"
  log_info   "$ wget -e "http_proxy=http://127.0.0.1:$LOCAL_PROXY_PORT/" www.google.com -O /dev/null\n"
  echo -e "\n"
}

main $@
