#!/usr/bin/python

"""
Save this file as server.py
>>> python server.py
Serving on localhost:80
You can use this to test GET and POST methods.
"""

import http.server
import socketserver
import logging
import cgi
import sys
import re
import subprocess
import time, struct

#Read GPIO offsets from a file that /sys/glass/gpio/gpiochipN/label fields
for line in open("/mnt/emmc/gpio_offsets.txt"):
 if "MIO0_OFFSET" in line:
  MIO0_OFFSET = line.split("=")[-1]
 if "AXI_GPIO_MAX_OFFSET" in line:
  AXI_GPIO_MAX_OFFSET = line.split("=")[-1]
PsButtonPortnumber = str(int(MIO0_OFFSET)+int(0))
PS_RedPortnumber = str(int(MIO0_OFFSET)+int(52))
PS_GreenPortnumber = str(int(MIO0_OFFSET)+int(53))
PL_RedPortnumber = str(int(AXI_GPIO_MAX_OFFSET)+int(1))
PL_GreenPortnumber = str(int(AXI_GPIO_MAX_OFFSET)+int(0))

EnableMicPortnumber = str(int(AXI_GPIO_MAX_OFFSET)-int(8))

if len(sys.argv) > 2:
    PORT = int(sys.argv[2])
    I = sys.argv[1]
elif len(sys.argv) > 1:
    PORT = int(sys.argv[1])
    I = ""
else:
    PORT = 80
    I = ""

class ServerHandler(http.server.SimpleHTTPRequestHandler):

    def do_GET(self):
        logging.warning("======= GET STARTED =======")
        logging.warning(self.headers)

        http.server.SimpleHTTPRequestHandler.do_GET(self)

    def do_POST(self):
        logging.warning("======= POST STARTED =======")
        logging.warning(self.headers)
        form = cgi.FieldStorage(
            fp=self.rfile,
            headers=self.headers,
            environ={'REQUEST_METHOD':'POST',
                     'CONTENT_TYPE':self.headers['Content-Type'],
                     })
        logging.warning("Host: %s", form.getvalue('Host'));

        if (form.getvalue('SETPSLED')):
            ledChosen = form.getvalue('PSledSel')
            logging.warning("PS LED Setting is %s", ledChosen)
            RedPath = '/sys/class/gpio/gpio' + PS_RedPortnumber + '/value'
            RedFile= open (RedPath,'w')
            GreenPath = '/sys/class/gpio/gpio' + PS_GreenPortnumber + '/value'
            GreenFile= open (GreenPath,'w')
            #"""
            if (int(ledChosen) == 0):
                RedFile.write('0')
                GreenFile.write('0')
            elif (int(ledChosen) == 1):
                RedFile.write('1')
                GreenFile.write('0')
            elif (int(ledChosen) == 2):
                RedFile.write('0')
                GreenFile.write('1')
            else:
                RedFile.write('1')
                GreenFile.write('1')
            """
            # Start for PS Button testing:
            ButtonPath = '/sys/class/gpio/gpio' + PsButtonPortnumber + '/value'
            ButtonFile= open (ButtonPath,'r')
            ButtonStatus = ButtonFile.read()
            ButtonFile.close()
            logging.warning("Button is %s", ButtonStatus)
            if (int(ButtonStatus) == 1):
                RedFile.write('1')
                GreenFile.write('0')
            else:
                RedFile.write('0')
                GreenFile.write('1')
            # End for PS Button testing
            """
            RedFile.close()
            GreenFile.close()


        if (form.getvalue('SETPLLED')):
            ledChosen = form.getvalue('PLledSel')
            logging.warning("PL LED Setting is %s", ledChosen)
            RedPath = '/sys/class/gpio/gpio' + PL_RedPortnumber + '/value'
            RedFile= open (RedPath,'w')
            GreenPath = '/sys/class/gpio/gpio' + PL_GreenPortnumber + '/value'
            GreenFile= open (GreenPath,'w')

            # Make sure the microphone isn't clobbering the led setting
            EnableMicPath = '/sys/class/gpio/gpio' + EnableMicPortnumber + '/value'
            EnableMicFile= open (EnableMicPath,'w')
            EnableMicFile.write('1')
            EnableMicFile.close()

            #time.sleep(0.5)
            if (int(ledChosen) == 0):
                RedFile.write('0')
                GreenFile.write('0')
            elif (int(ledChosen) == 1):
                RedFile.write('1')
                GreenFile.write('0')
            elif (int(ledChosen) == 2):
                RedFile.write('0')
                GreenFile.write('1')
            else:
                RedFile.write('1')
                GreenFile.write('1')
            RedFile.close()
            GreenFile.close()

        if (form.getvalue('SETMICLLED')):
            enableChosen = form.getvalue('PLledMode')
            EnableMicPath = '/sys/class/gpio/gpio' + EnableMicPortnumber + '/value'
            EnableMicFile= open (EnableMicPath,'w')
            if (int(enableChosen) == 0):
                EnableMicFile.write('1')
            elif (int(enableChosen) == 1):
                EnableMicFile.write('0')

            EnableMicFile.close()

Handler = ServerHandler
httpd = socketserver.TCPServer(("", PORT), Handler)
httpd.serve_forever()
