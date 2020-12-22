#!/bin/sh

# run Xprofile
if [ -f ~/.xprofile ]; then
	# shellcheck source=/dev/null
	. ~/.xprofile
fi

# uncomment this if not using a login manager
# so i3 will start correctly
#exec i3 -V >> ~/.i3/logfile 2>&1

#ssh-agent dwm
