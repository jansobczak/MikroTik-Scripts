/system package update
check-for-updates once
:delay 2s;
:if ( [get status] = "New version is available") do={ 
	/system script run AutoBackFTP;
	install;
}