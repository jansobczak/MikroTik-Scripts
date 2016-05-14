## CONFIG 
# Filter - prefix of backup name
:local backupName "MikroTik"
# daysAgo - how long back should be stored
:local daysAgo 8
# folderName - [optional] if set backup will be stored in other folder
:local folderName ""
:local diskName ""
# do USB RESET?
:local diskReset 0; 

## SCRIPT
:log info message="Auto backup has started"
# USB restart this ensure that the drive will be available
:if ([/disk find name="$diskName"] = "" && $diskReset = 1) do={
	:log info message="USB restart";
	#/disk eject-drive [find name="$diskName"];
	/system routerboard usb power-reset duration=2s;
	:delay 4;
	:log info message="USB restart done!";
	:if ([/disk find name="$diskName"] != "") do={
		:log info message="USB drive found";
	} else={
		:log warning message="USB drive not found";
		:log warning message="Auto backup exit";
		exit;
	};
};

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
:log info message="Backup saved"


# get current date
:set $curDate [ /system clock get date ];
# extract current month
:local curMonth [ :pick $curDate 0 3 ];
# get position of our month in the array = month number
:set $curMonth ([ :find $months $curMonth -1 ] + 1);
# extract current day
:local curDay [ :pick $curDate 4 6 ];
# extract current year
:local curYear [ :pick $curDate 7 11 ];
# loop through all files
:foreach i in=[/file find where type=backup] do={
	# get this file's creation time
	:local fileDate [/file get number="$i" creation-time]
	# extract the date
	:set fileDate [ :pick $fileDate 0 11 ];
	# extract the month
	:local fileMonth [ :pick $fileDate 0 3 ];
	# get position of our month in the array = month number
	:set fileMonth ([ :find $months $fileMonth -1 ] + 1);
	# extract the day
	:local fileDay [ :pick $fileDate 4 6 ];
	# extract the year
	:local fileYear [ :pick $fileDate 7 11 ];
	# the sum of total days
	:local sum 0;
	# subtract the file's year from the current year, multiply times 365 to get approx days, add to sum
	:set sum ($sum + (($curYear - $fileYear)*365));
	# subtract the file's month from the current month, multiply times 30 to get approx days, add to sum
	:set sum ($sum + (($curMonth - $fileMonth) * 30));
	# subtract the file's day from the current day, add to sum
	:set sum ($sum + ($curDay - $fileDay));
	# if the sum is greater than or equal to our daysAgo and the file name contains our backupName
	:if ($sum >= $daysAgo) do={
		:local fileName [/file get number="$i" name]
	 	:log warning message="Backup $fileName ($fileDate) expired $sum days ago"
	 	/file remove number="$i"
	 	:log warning message="Backup was deleted"
	}
}
:log info message="Auto backup end"