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

# add path helper script
import sys
sys.path.insert(1, '/usr/local/bin/gpio')
from gpio_common import gpio_map

PsButtonPortnumber  = gpio_map['PS_BUTTON'].gpio
PS_RedPortnumber    = gpio_map['PS_R'].gpio
PS_GreenPortnumber  = gpio_map['PS_G'].gpio
PL_RedPortnumber    = gpio_map['PL_R'].gpio
PL_GreenPortnumber  = gpio_map['PL_G'].gpio
EnableMicPortnumber = gpio_map['PL_MIC1'].gpio

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
