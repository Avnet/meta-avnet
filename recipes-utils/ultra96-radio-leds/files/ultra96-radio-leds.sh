#!/bin/sh -e

### BEGIN INIT INFO
# Provides: BT/WIFI LED control for Ultra96
# Required-Start:
# Required-Stop:
# Default-Start:S
# Default-Stop:0 6
# Short-Description: Turns BT/WIFI LEDS on or off
# Description:
### END INIT INFO

source /usr/local/bin/gpio/gpio_common.sh
LED_ON=1
LED_OFF=0

BT_LED=$(get_gpio BT_LED)
WIFI_LED=$(get_gpio WIFI_LED)

echo "   WIFI LED GPIO = $WIFI_LED"
echo "   BT   LED GPIO = $BT_LED"

if [ -z "$BT_LED" ]; then
	echo "ERROR: /etc/init.d/ultra96-radio-leds.sh : Could not find axi gpio device with base address 0xa0050000 !"
	exit 1
fi

DESC="ultra96-radio-leds.sh will turn the WiFi and Bluetooth LEDs on and off on Ultra96"

set_leds() {
    value=$1
    # Set their direction to output
    # Turn each of the LEDs
    export_gpio $WIFI_LED out $value
    export_gpio $BT_LED out $value

    # Release the sysfs GPIOs
    unexport_gpio $WIFI_LED
    unexport_gpio $BT_LED
}

start ()
{
    echo -n "Turning Ultra96 WiFi & Bluetooth LEDs ON..."
    set_leds $LED_ON

    echo "done."
    echo " "
}

stop ()
{
    echo -n "Turning Ultra96 WiFi & Bluetooth LEDs OFF..."
    set_leds $LED_OFF

    echo "done."
    echo " "
}

case "$1" in
	start)
		start;
		;;
	stop)
		stop;
		;;
	*)
		echo "Usage: /etc/init.d/ultra96-radio-leds.sh {start|stop}"
		exit 1
esac

exit 0

