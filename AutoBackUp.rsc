#AutoBackup
#This script allow to make internal backups
#
#@author Jan Sobczak (jasobeczek@gmail.com)
#
## Config
:local backupName "MikroTik"; # Filter - prefix of backup name
:local daysAgo 8; # How long back up should be stored
:local folderName ""; # folderName - [optional] if set backup will be stored in other folder than default root

## SCRIPT
:local months ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");
:local varDate [/system clock get date];
:local varMonth [:pick $varDate 0 3];
:set varMonth ([ :find $months $varMonth -1 ] + 1);
:local varDay [:pick $varDate 4 6];
:local varYear [:pick $varDate 7 11];
:local varTime [/system clock get time];
:set varTime ([:pick $varTime 0 2] . [:pick $varTime 3 5]);
:local curDate ("$varYear$varMonth$varDay-$varTime")
:if ($folderName != "") do={
	/system backup save name=("$folderName" . "$backupName-$curDate")
} else={
	/system backup save name=("$backupName-$curDate")
};
:log info message="AutoBackUp: Backup saved"

:set $curDate [ /system clock get date ];
:local curMonth [ :pick $curDate 0 3 ];
:set $curMonth ([ :find $months $curMonth -1 ] + 1);
:local curDay [ :pick $curDate 4 6 ];
:local curYear [ :pick $curDate 7 11 ];
:foreach i in=[/file find where type=backup] do={
	:local fileDate [/file get number="$i" creation-time]
	:set fileDate [ :pick $fileDate 0 11 ];
	:local fileMonth [ :pick $fileDate 0 3 ];
	:set fileMonth ([ :find $months $fileMonth -1 ] + 1);
	:local fileDay [ :pick $fileDate 4 6 ];
	:local fileYear [ :pick $fileDate 7 11 ];
	:local sum 0;
	:set sum ($sum + (($curYear - $fileYear)*365));
	:set sum ($sum + (($curMonth - $fileMonth) * 30));
	:set sum ($sum + ($curDay - $fileDay));
	# if the sum is greater than or equal to our daysAgo and the file name contains our backupName
	:if ($sum >= $daysAgo) do={
		:local fileName [/file get number="$i" name]
	 	:log warning message="AutoBackUp: Backup $fileName ($fileDate) expired $sum days ago"
	 	/file remove number="$i"
	 	:log warning message="AutoBackUp: Backup was deleted"
	}
}