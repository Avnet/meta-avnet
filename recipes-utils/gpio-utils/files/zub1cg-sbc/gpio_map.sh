#!/bin/sh

source /usr/local/bin/gpio/gpio_common.sh

# axi_gpio_0 rgb_led_0
BASE_RGB_LED_0=$(get_gpiochip_base a0000000)
# axi_gpio_1 rgb_led_1
BASE_RGB_LED_1=$(get_gpiochip_base a0010000)
# axi_gpio_2 pl_pb
BASE_PL_PB=$(get_gpiochip_base a0020000)

# MIO GPIO
BASE_ZYNQMP_GPIO=$(get_gpiochip_base zynqmp_gpio)

# MIO LEDs (PCB D9, D8, D7, D6)
echo MIO_LED_1:$((BASE_ZYNQMP_GPIO + 7)):out:1 > $GPIO_CONF
echo MIO_LED_2:$((BASE_ZYNQMP_GPIO + 24)):out:1 >> $GPIO_CONF
echo MIO_LED_3:$((BASE_ZYNQMP_GPIO + 25)):out:1 >> $GPIO_CONF
echo MIO_LED_4:$((BASE_ZYNQMP_GPIO + 33)):out:1 >> $GPIO_CONF

# PL RGB LEDs (PCB D4,D5)
for i in $(seq 0 2); do
    echo RGB_LED_0_$i:$((BASE_RGB_LED_0 + i)):out:1 >> $GPIO_CONF
    echo RGB_LED_1_$i:$((BASE_RGB_LED_1 + i)):out:1 >> $GPIO_CONF
done

# PL PB switch (PCB SW3)
echo PL_PB:$((BASE_PL_PB)):in >> $GPIO_CONF

# PS PB switch (PCB SW1)
echo MIO_PB:$((BASE_ZYNQMP_GPIO + 32)):in >> $GPIO_CONF

# PS DIP switches (PCB SW4)
echo MIO_SW_1:$((BASE_ZYNQMP_GPIO + 44)):in >> $GPIO_CONF
echo MIO_SW_2:$((BASE_ZYNQMP_GPIO + 40)):in >> $GPIO_CONF
echo MIO_SW_3:$((BASE_ZYNQMP_GPIO + 39)):in >> $GPIO_CONF
echo MIO_SW_4:$((BASE_ZYNQMP_GPIO + 31)):in >> $GPIO_CONF
