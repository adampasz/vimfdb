#Start FDB in new terminal window and start listening for something to debug
#This script assumes you are using the terminal only as a debugger window.
#i.e.: In my setup, I use iterm as my main terminal.
#If you depend on the basic terminal for your workflow, you'll probably want to revise this.
export _JAVA_OPTIONS="-Xms1024m -Xmx1024m -XX:MaxPermSize=512m"
osascript -e '
	tell application "Terminal" to activate
	tell application "Terminal" to quit
	do shell script "killall adl"
	delay 1
'

osascript -e '
	tell application "Terminal"
		tell application "Terminal" to activate
		delay 1
		do script ("fdb")  in window 1
		tell application "Terminal" to deactivate
	end tell
'
### Sample ~/.fdbinit File ###
#run
#b FooBar.as:75
#continue

