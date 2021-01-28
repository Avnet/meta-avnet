#!/bin/sh

#####################
## SENSOR CONTROLS ##
#####################
DEFAULT_PATH="/dev/v4l-subdev"

AR0231_COLOR_GAIN_RED="0x0098090e"
AR0231_COLOR_GAIN_BLUE="0x0098090f"
AR0231_COLOR_GAIN_GREEN="0x00980924"
AR0231_EXPOSURE="0x00980911"
AR0231_DIGITAL_GAIN="0x00980913"
AR0231_ANALOG_GAIN="0x009e0903"
AR0231_HORIZONTAL_FLIP="0x00980914"
AR0231_VERTICAL_FLIP="0x00980915"
AR0231_TEST_PATTERN="0x009f0903"

RED_GAIN_VALUE="856"
BLUE_GAIN_VALUE="606"
GREEN_GAIN_VALUE="1401"
EXPOSURE_VALUE="878"
DIGITAL_GAIN_VALUE="606"
ANALOG_GAIN_VALUE="5"
HORIZONTAL_FLIP_VALUE="0"
VERTICAL_FLIP_VALUE="0"
TEST_PATTERN_VALUE="0"

echo -n "Setting sensor controls... "
for val in {0..3}
do
	subnode="$DEFAULT_PATH$val"
	yavta --no-query -l "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_COLOR_GAIN_RED $RED_GAIN_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_COLOR_GAIN_BLUE $BLUE_GAIN_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_COLOR_GAIN_GREEN $GREEN_GAIN_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_EXPOSURE $EXPOSURE_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_DIGITAL_GAIN $DIGITAL_GAIN_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_ANALOG_GAIN $ANALOG_GAIN_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_HORIZONTAL_FLIP $HORIZONTAL_FLIP_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_VERTICAL_FLIP $VERTICAL_FLIP_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$AR0231_TEST_PATTERN $TEST_PATTERN_VALUE" "$subnode" > /dev/null 2>&1
done
echo "Done!"

##################
## CSC CONTROLS ##
##################

CSC_BRIGHTNESS="0x0098c9a1"
CSC_CONTRAST="0x0098c9a2"
CSC_RED_GAIN="0x0098c9a3"
CSC_GREEN_GAIN="0x0098c9a4"
CSC_BLUE_GAIN="0x0098c9a5"



CSC_BRIGHTNESS_VALUE="80"
CSC_CONTRAST_VALUE="55"
CSC_RED_GAIN_VALUE="70"
CSC_GREEN_GAIN_VALUE="55"
CSC_BLUE_GAIN_VALUE="24"

echo -n "Setting csc controls... "
for val in {10..13}
do
	subnode="$DEFAULT_PATH$val"
	yavta --no-query -l "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$CSC_BRIGHTNESS $CSC_BRIGHTNESS_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$CSC_CONTRAST $CSC_CONTRAST_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$CSC_RED_GAIN $CSC_RED_GAIN_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$CSC_GREEN_GAIN $CSC_GREEN_GAIN_VALUE" "$subnode" > /dev/null 2>&1
	yavta --no-query -w "$CSC_BLUE_GAIN $CSC_BLUE_GAIN_VALUE" "$subnode" > /dev/null 2>&1
done
echo "Done!"

