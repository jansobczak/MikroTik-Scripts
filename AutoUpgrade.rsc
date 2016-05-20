#AutoUpgrade
#This script is based on:
#http://wiki.mikrotik.com/wiki/Manual:Upgrading_RouterOS
#
#@author Jan Sobczak (jasobeczek@gmail.com)
#

/system package update
check-for-updates once
:delay 2s;
:if ( [get status] = "New version is available") do={ 
	/system script run AutoBackFTP; #Choose script for backup operation (AutoBackUp)
	install;
}