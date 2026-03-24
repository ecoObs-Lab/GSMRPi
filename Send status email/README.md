# GSMRPi - send status email
Examples for sending an email with status information on the last night of data sampling.

The script mimicks the daily status SMS in form of an automated email message including information on the GSM-batcorder status.

## Requirements

The GSM-batcorder has to be connected and mounted by the RPi as described in the parent document.

### Setting up email
This short manual is based on the following installation instructions:
https://goneuland.de/raspberry-pi-e-mails-versenden-mit-msmtp/

For sending email messages three packages have to be installed - superuser access (sudo) may be necessary:

```
sudo apt-get update
sudo apt-get install msmtp msmtp-mta mailutils
```
Successful installation can be tested by querying the mail server version:
```
msmtp --version
```
Configuration per file is as follows:
```
sudo nano /etc/msmtprc
```
Adapt the config content to your email server!
```
# Set default values for all following accounts.
defaults

# Use the mail submission port 587 instead of the SMTP port 25.
port 587

# Always use TLS.
tls on

# Mail account
# The email account is configured
# A name of your liking
account gsmbc  

# Host name of the SMTP server
# Adjust to your mail server
host smtp.web.de  

# Envelope-from address
# Adjust to your sender adress
from euerName@web.de  

auth on
# Adjust!
user euerName@web.de 
# Adjust!
password geheimesPasswort 

# Set a default account
# Accoutn name used above
account default: gsmbc
```
Now you need to adjust permissions for the file:
```
chmod 666 /etc/msmtprc
```
Finally the email application must be configured:
```
sudo nano /etc/mail.rc
```
Content of email.rc
```
set sendmail="/usr/bin/msmtp -t"
```
Sending a test email:
```
echo "E-Mail Text" | sudo mail -s "E-Mail Betreff" ziel@euredomain.de
```
As a last step a service has to be established to send an email whenever the GSM-batcorder gets mounted. In our test case this script sends an email, but other scenarios like data upload or backup creation are possible as well. Create the service:
```
sudo nano /etc/systemd/system/gsm_bc.service
```
The contet of this file is:
```
[Unit]
Description=My flashdrive script trigger
After=media-GSM_BC.mount

[Service]
ExecStart=/usr/bin/email.sh
User=root
#Achtung: adjust the path in the line above to point to the script location!

[Install]
WantedBy=media-GSM_BC.mount
```

A simple example script is given with this README. This script is called email.sh. To make it executable, it needs:
```
chmod +x <skript-name>
```
