#!/usr/bin/bash

# CONFIGURATION
# IP to ping and check connectivity
pingAddress=192.168.88.1
# ping timeout
pingTimeout=3
# ping retry number
pingRetryCount=10
# delay between retries
pingRetryDelay=30
# network device to try to reset and renew IP
networkDevice=eth0
# log file and path
logPath=$(dirname "$0")/network-check.log
# reboot on failure to reconnect
doReboot=true

tag=[$(date -Iseconds)]:
for((i=0;i<pingRetryCount;i++)); do
    if ping -q -c 1 -W $pingTimeout $pingAddress >/dev/null; then
        exit 0
    else
        sleep $pingRetryDelay
    fi
done
echo "$tag Network down. Trying to restart $networkDevice and renew address..." >> "$logPath"
ethtool -r $networkDevice
sleep 10
dhclient -r $networkDevice
dhclient $networkDevice
sleep 10
if ping -q -c 1 -W $pingTimeout $pingAddress >/dev/null; then
    echo "$tag The network is back!" >> "$logPath"
    exit 0
else
    echo "$tag The network failed to reconnect!" >> "$logPath"
    if $doReboot; then
        echo "$tag Rebooting machine..." >> "$logPath"
        reboot
    fi
fi
