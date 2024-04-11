#SFP LXT GPON Change Speed for LEOX LXT-010S-H
#V3.3.4L5rc1 - This version adds “auto-negotiation” capability to the stick. It always prefers 1G (to keep the stick consistently accessible). 
#Force the link to 2.5G (disabling auto-negotiation), it takes at least 40 seconds to establish the connection after 1G link is up
#@author Jan Sobczak (jasobeczek@gmail.com)
#
############
## Config ##
############

:local interface "sfp-sfpplus1";
:local initalSpeed "1G-baseX";
:local targetSpeed "2.5G-baseT";

#For scheduler with startup wait for SFP to comes up 
#TODO change to auto check
:delay 15s;
#Try to change the SFP to the initalSpeed
/interface ethernet set $interface auto-negotiation=no speed=$initalSpeed;
:delay 40s;
/interface ethernet set [ find name=$interface ] auto-negotiation=no speed=$targetSpeed;
