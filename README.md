# GSMRPi
Examples connecting GSM-batcorder and RaspberryPi

The GSM-batcorder 1.0 and the GSM-batcorder 4G 1.0 can both be connected to a RaspberryPi using the builtin USB connector. This allows to access the contents of the SD-card of the GSM-batcorder whenever it is not in scanning mode (thus searching for bats). This allows access to the logfile or the recordings from remote, for sending status information per email or for uploading recordings to a cloud server. We will compile small sample scripts to show you how to get such tasks done.

## Requirements

Currently we use a RPi3B+ running RaspberryPi OS Lite 64 bit: Debian GNU/Linux 12 (bookworm) from September 2025 for testing. The RPi is installed in an outdsoor isntallation using GSM-batcorder 1.0 setup with the box extension. The RPi connects to a local WiFi. Other forms of connection with a 4G or 5G modem were not tested, but should work as well.

### Connecting the GSM-batcorder to RPi
The GSM-batcorder must be mounted automatically whenever it publishes the availability of its SD card. We are using udiskie to detect and mount the card into the RPi filesystem. Note that it is necessary to connect as RO (read-only). Any writing operation on the SD-card that changes the content of the file directory will render the card unreadable by the GSM-batcorder. udiskie usually mounts RO.
```
sudo apt-get install udiskie
```

We use udiskie as a system wide systemd service for stability reasons. You will need to create a service configuration:
```
sudo nano /etc/systemd/system/udiskie.service 
```
containing
```
[Unit]
    Description=udiskie - Automatisches Mounten von Laufwerken
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=root
    Group=root
    ExecStart=/usr/bin/udiskie -a
    Restart=always

    [Install]
    WantedBy=default.target
```
Manually activate the service, at reboot the service is automatically activated
```
sudo systemctl enable udiskie.service
sudo systemctl start udiskie.service
```
Make sure to mount the GSM-batcorder readable by any user create a rule file
```
sudo nano /etc/udev/rules.d/99-udisks2.rules
```
with
```
# UDISKS_FILESYSTEM_SHARED
# ==1: mount filesystem to a shared directory (/media/VolumeName)
# ==0: mount filesystem to a private directory (/run/media/$USER/VolumeName)
# See udisks(8)
ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{UDISKS_FILESYSTEM_SHARED}="1"
```

