#PPPOE monitor
#This script monitor pppoe client
#If connection failed this script
#try to reconnect
#
#@author Jan Sobczak (jasobeczek@gmail.com)
#
:local searchVar "status: "; #What variable is desired to find
:local tempFileName "pppoe-monitor-file.txt"; #Temp file name

#SCRIPT
:foreach i in=[/interface pppoe-client find disabled=no] do={	
	/interface pppoe-client monitor $i once file=$tempFileName;
	:delay 1s; #Wait for writing the file
	:local tempStatus [/file get [/file find name=$tempFileName] contents];
	:local pickStart [:find $tempStatus $searchVar ];
	:set $pickStart ($pickStart + [:len $searchVar ]);
	:local pickEnd [:find $tempStatus "\n" ($pickStart) ];
	:local curStatus [:pick $tempStatus ($pickStart) ($pickEnd)];

	#Those are out put for status:
	if ($curStatus = "connected") do={
		:put ([/interface pppoe-client get $i name] . ": OK");
	}
	if ($curStatus = "connecting...") do={
		:put ([/interface pppoe-client get $i name] . ": connecting...");
		/system script run PPPOE-restart;
		/interface pppoe-client enable $i; #Try to enable?
	}
	if ($curStatus = "disconnected") do={
		:put ([/interface pppoe-client get $i name] . ": disconnected!");
		:log warning ([/interface pppoe-client get $i name] . ": disconnected!")
		/interface pppoe-client enable $i; #Try to enable?
	};
	if ([/find $curStatus "terminating"] = 0) do={
		:put ([/interface pppoe-client get $i name] . ": terminating!");
		:log warning ([/interface pppoe-client get $i name] . ": terminating!")
		/system script run PPPOE-restart;
		/interface pppoe-client enable $i; #Try to enable?
	};
        if ([/find $curStatus "terminated"] = 0) do={
		:put ([/interface pppoe-client get $i name] . ": terminated!");
		:log warning ([/interface pppoe-client get $i name] . ": terminated!")
		/interface pppoe-client enable $i; #Try to enable?
	};
	/file remove [/file find where name=$tempFileName];
}