# raspberrypi

Some useful tools I've made to ease living with my Raspberry Pi.

## bash

Small and useful scripts for bash.

### network-check

A configurable script that checks for network connectivity. After failure it does the following:

1. Retry connection a configurable number of times.
1. Reset the configured network device and try to renew the IP address using the DHCP client.
1. (optional)Reboot the machine.

The script needs to be run periodically using crontab or any other scheduler.

#### Crontab example entry

Edit your /etc/crontab file and add the following line. Replace the location with your location of the script and the time of execution to whatever suits.

```txt
*/10 * * * * root bash /home/pi/bin/network-check.sh 
```
