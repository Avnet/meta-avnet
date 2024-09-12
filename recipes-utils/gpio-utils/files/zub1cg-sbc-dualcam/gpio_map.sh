#!/bin/sh

source /usr/local/bin/gpio/gpio_common.sh

# MIO GPIO
BASE_ZYNQMP_GPIO=$(get_gpiochip_base zynqmp_gpio)

# MIO LEDs (PCB D9, D8, D7, D6)
echo MIO_LED_1:$((BASE_ZYNQMP_GPIO + 7)):out:1 > $GPIO_CONF
echo MIO_LED_2:$((BASE_ZYNQMP_GPIO + 24)):out:1 >> $GPIO_CONF
echo MIO_LED_3:$((BASE_ZYNQMP_GPIO + 25)):out:1 >> $GPIO_CONF
echo MIO_LED_4:$((BASE_ZYNQMP_GPIO + 33)):out:1 >> $GPIO_CONF

# PS PB switch (PCB SW1)
echo MIO_PB:$((BASE_ZYNQMP_GPIO + 32)):in >> $GPIO_CONF

# PS DIP switches (PCB SW4)
echo MIO_SW_1:$((BASE_ZYNQMP_GPIO + 44)):in >> $GPIO_CONF
echo MIO_SW_2:$((BASE_ZYNQMP_GPIO + 40)):in >> $GPIO_CONF
echo MIO_SW_3:$((BASE_ZYNQMP_GPIO + 39)):in >> $GPIO_CONF
echo MIO_SW_4:$((BASE_ZYNQMP_GPIO + 31)):in >> $GPIO_CONF
