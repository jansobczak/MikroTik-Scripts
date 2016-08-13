#PPPOE ping monitor
#This script monitor PPPoE client
#If connection failed this script try to
#reconnect
#
#@author Jan Sobczak (jasobeczek@gmail.com)
#
############
## Config ##
############

:local searchVar "status: "; #What variable is desired to find
:local tempFileName "pppoe-monitor-file.txt"; #Temp file name for logs
:local testIP "8.8.8.8"; #IP to test connection

############
## SCRIPT ##
############
:foreach i in=[/interface pppoe-client find disabled=no] do={	
	# Check if connected to Internet
    if ([/ping $testIP count=3] < "2") do={
    	:put ([/interface pppoe-client get $i name] . ": ping test failed!");
		:log warning ([/interface pppoe-client get $i name] . ": ping test failed!")
		/interface pppoe-client enable $i; #Try to enable?
	} else={
		:put ([/interface pppoe-client get $i name] . ": OK");
	}
}