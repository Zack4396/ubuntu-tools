# ubuntu-tools
Provide some initial tools for a new ubuntu system.

## bin/v2ray-setup.sh

* Setup commands

```
// Only support 'shadowsocks' and 'vmess'
# export LOCAL_VPS_PROTOCOL="shadowsocks"
# export LOCAL_PROXY_PORT="10809"

// You may need a temporary proxy ip and port to prevent downloading failure
// e.g.
//  export LOCAL_TEMP_PROXY="192.168.2.139:10809"
# export LOCAL_TEMP_PROXY="<proxy ip>:<proxy port>"
# export LOCAL_VPS_ADDRESS="your-vps-server-address"
# export LOCAL_VPS_PORT="your-vps-server-port"
# export LOCAL_VPS_KEY="your-vps-passwd"

# bash ./bin/v2ray-setup.sh

// Test the proxy network
# wget -e "http_proxy=http://127.0.0.1:$LOCAL_PROXY_PORT/" www.google.com -O /dev/null
```

* Logs
```
kiki@ubuntu:~/ubuntu-tools$ export LOCAL_VPS_PROTOCOL="shadowsocks"
kiki@ubuntu:~/ubuntu-tools$ export LOCAL_TEMP_PROXY="192.168.2.139:10809"
kiki@ubuntu:~/ubuntu-tools$ export LOCAL_PROXY_PORT="10809"
kiki@ubuntu:~/ubuntu-tools$ export LOCAL_VPS_ADDRESS="your-vps-address"
kiki@ubuntu:~/ubuntu-tools$ export LOCAL_VPS_PORT="your-vps-port"
kiki@ubuntu:~/ubuntu-tools$ export LOCAL_VPS_KEY="your-vps-key"
kiki@ubuntu:~/ubuntu-tools$ 
kiki@ubuntu:~/ubuntu-tools$ bash bin/v2ray-setup.sh
Reading package lists... Done
Building dependency tree       
Reading state information... Done
curl is already the newest version (7.68.0-1ubuntu2.18).
git is already the newest version (1:2.25.1-1ubuntu3.11).
0 upgraded, 0 newly installed, 0 to remove and 97 not upgraded.
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 22454  100 22454    0     0  58934      0 --:--:-- --:--:-- --:--:-- 58934
info: Stop the V2Ray service.
removed: /usr/local/bin/v2ray
removed: /usr/local/share/v2ray
removed: /etc/systemd/system/v2ray.service
removed: /etc/systemd/system/v2ray@.service
removed: /etc/systemd/system/v2ray.service.d
removed: /etc/systemd/system/v2ray@.service.d
Please execute the command: systemctl disable v2ray
You may need to execute a command to remove dependent software: apt purge curl unzip
info: V2Ray has been removed.
info: If necessary, manually delete the configuration and log files.
info: e.g., /usr/local/etc/v2ray and /var/log/v2ray/ ...
info: Installing V2Ray v5.4.1 for x86_64
Downloading V2Ray archive: https://github.com/v2fly/v2ray-core/releases/download/v5.4.1/v2ray-linux-64.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 11.2M  100 11.2M    0     0  6012k      0  0:00:01  0:00:01 --:--:-- 11.2M
Downloading verification file for V2Ray archive: https://github.com/v2fly/v2ray-core/releases/download/v5.4.1/v2ray-linux-64.zip.dgst
info: Extract the V2Ray package to /tmp/tmp.bE5QZcP5oT and prepare it for installation.
info: Systemd service files have been installed successfully!
warning: The following are the actual parameters for the v2ray service startup.
warning: Please make sure the configuration file path is correctly set.
# /etc/systemd/system/v2ray.service
[Unit]
Description=V2Ray Service
Documentation=https://www.v2fly.org/
After=network.target nss-lookup.target

[Service]
User=nobody
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/v2ray run -config /usr/local/etc/v2ray/config.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target

# /etc/systemd/system/v2ray.service.d/10-donot_touch_single_conf.conf
# In case you have a good reason to do so, duplicate this file in the same directory and make your customizes there.
# Or all changes you made will be lost!  # Refer: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
[Service]
ExecStart=
ExecStart=/usr/local/bin/v2ray run -config /usr/local/etc/v2ray/config.json

installed: /usr/local/bin/v2ray
installed: /usr/local/share/v2ray/geoip.dat
installed: /usr/local/share/v2ray/geosite.dat
installed: /etc/systemd/system/v2ray.service
installed: /etc/systemd/system/v2ray@.service
removed: /tmp/tmp.bE5QZcP5oT
info: V2Ray v5.4.1 is installed.
You may need to execute a command to remove dependent software: apt purge curl unzip
Please execute the command: systemctl enable v2ray; systemctl start v2ray





Here are the VPS settings
LOCAL_VPS_PROTOCOL: shadowsocks
LOCAL_VPS_ADDRESS : xxxx
LOCAL_VPS_KEY     : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
LOCAL_VPS_PORT    : xxxx





Here are some commands which use to set/unset global proxy
// repo, wget
# export http_proxy=127.0.0.1:10809
# export https_proxy=127.0.0.1:10809
# export http_proxy=
# export https_proxy=
// curl
# echo proxy = 127.0.0.1:10809 > ~/.curlrc
# rm ~/.curlrc
// git
# git config --global http.proxy http://127.0.0.1:10809
# git config --global https.proxy http://127.0.0.1:10809
# git config --global --unset http.proxy
# git config --global --unset https.proxy
kiki@ubuntu:~/ubuntu-tools$ 
kiki@ubuntu:~/ubuntu-tools$ wget -e "http_proxy=http://127.0.0.1:$LOCAL_PROXY_PORT/" www.google.com -O /dev/null
--2023-05-06 21:08:21--  http://www.google.com/
Connecting to 127.0.0.1:10809... connected.
Proxy request sent, awaiting response... 200 OK
Length: unspecified [text/html]
Saving to: ‘/dev/null’

/dev/null                                              [ <=>                                                                                                            ]  15.67K  --.-KB/s    in 0.02s   

2023-05-06 21:08:22 (950 KB/s) - ‘/dev/null’ saved [16044]

```
