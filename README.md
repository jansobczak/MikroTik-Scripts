# MikroTik-Scripts
Various scripts for MikroTik routers

I tested script on hAP lite (RB941-2nD) but it should works on others router too. 

Quick description of scripts:

- AutoBackUp - this script make system-(configuration)-backup to internal storage and delete old ones.
- AutoBackFTP - this script make system-(configuration)-backup to external FTP server.
- AutoUpgrade - this script check if updates are available. Make backup and upgrade router. (Please choose which type of backup it should be performing).
- PPPOE monitor - this script monitor all PPPoE interfaces (connection) and try to reset or reconnect if needed.
- PPPOE ping monitor - this script monitor all PPPoe interfaces by ping specified IP and try to reconnect if needed.
- PPPOE restart - this script restart all enabled PPPoE interfaces.
- WiFi monitor - this script disconnect clients with too weak signal after desired test time.
