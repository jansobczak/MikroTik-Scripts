#Wifi monitor (client drops)
#This script drops clients that have too
#weak signal.
#This is useful if network have more AP.
#
#@author Jan Sobczak (jasobeczek@gmail.com)
#
# Config
:local minUptime "15s"; # A minimal uptime. This is useful to give chance users to connect to this AP
:local minSignalStrength -75; # A minimal strength below which users will be disconnected

## SCRIPT
/interface wireless registration-table
:foreach i in=[ /interface wireless registration-table find ap=no] do={
	:local signal
	:set signal [get $i signal-strength]
	:set signal [:pick $signal 0 [:find $signal "dBm"]]	
	:if ([get $i uptime] > $minUptime && $signal < $minSignalStrength) do={
		:log warning ([get $i  mac-address] . " was disconnected due to low signal strength: " . [get $i signal-strength])
		/interface wireless registration-table remove $i
		:delay 5s
	}
}