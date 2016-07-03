#AutoBackup to FTP
#This script allow to send MikroTik backup to external FTP
#using /tool fetch. 
#
#@author Jan Sobczak (jasobeczek@gmail.com)
#
:local backupName "MikroTik"; #prefix of backupname
:local ftpAddress "****";
:local ftpUser "****";
:local ftpPwd "****";
:local ftpFolder "backup/"; #Use this to specify a folder inside FTP, like backup/inner-folder/

## SCRIPT
:log info message="Auto backup has started"
:local months ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");
:local varDate [/system clock get date];
:local varMonth [:pick $varDate 0 3];
:set varMonth ([:find $months $varMonth -1 ] + 1);
if ($varMonth < 10) do={ :set varMonth ("0" . "$varMonth"); };
:local varDay [:pick $varDate 4 6];
##if ($varDay < 10) do={ :set varDay ("0" . "$varDay"); };
:local varYear [:pick $varDate 7 11];
:local varTime [/system clock get time];
:set $varTime ([:pick $varTime 0 2] . [:pick $varTime 3 5]);
:local curDate ("$varYear$varMonth$varDay-$varTime")
/system backup save name="flash/$backupName-$curDate";
/tool fetch address="$ftpAddress" src-path=("flash/" . "$backupName-$curDate" . ".backup") user="$ftpUser" mode=ftp password="$ftpPwd" dst-path=("$ftpFolder" . "$backupName-$curDate" . ".backup") upload=yes;
/file remove [/file find where name="flash/$backupName-$curDate.backup"];