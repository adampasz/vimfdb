#Start FDB in new terminal window and start listening for something to debug
export _JAVA_OPTIONS="-Xms1024m -Xmx1024m -XX:MaxPermSize=512m"
osascript -e '
	tell application "Terminal" to activate
	do shell script "killall Terminal"
	do shell script "killall adl"
	delay 1
	tell application "Terminal" to close window 1
'

osascript -e '
	tell application "Terminal"
		tell application "Terminal" to activate
		do script ("cd ~")
		delay 1
		do script ("fdb")  in window 1
		tell application "Terminal" to deactivate
	end tell
'
### Sample ~/.fdbinit File ###
#run
#b FooBar.as:75
#continue
