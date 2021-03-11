#!/bin/bash

source /usr/share/ultra96-startup-pages/webapp/static/ultra96-startup-page.conf
if [ $webapp_on_boot = 1 ]; then
	echo -e "Opening webpage"
	epiphany 127.0.0.1
else
	echo -e "Not opening webpage"
fi
