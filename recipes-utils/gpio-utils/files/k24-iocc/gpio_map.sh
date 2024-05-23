#!/bin/sh

source /usr/local/bin/gpio/gpio_common.sh

# axi_gpio_0
BASE_LEDS=$(get_gpiochip_base a0000000)
# axi_gpio_1
BASE_PL_PB=$(get_gpiochip_base a0010000)

# MIO GPIO
BASE_ZYNQMP_GPIO=$(get_gpiochip_base zynqmp_gpio)

# PS LEDs (PCB D13, D14, D16, D17)
echo PS_LED_0:$((BASE_ZYNQMP_GPIO + 27)):out:0 > $GPIO_CONF
echo PS_LED_1:$((BASE_ZYNQMP_GPIO + 28)):out:0 >> $GPIO_CONF
echo PS_LED_2:$((BASE_ZYNQMP_GPIO + 29)):out:0 >> $GPIO_CONF
echo PS_LED_3:$((BASE_ZYNQMP_GPIO + 30)):out:0 >> $GPIO_CONF

# PL LEDs (PCB D19, D20)
echo PL_LED_0:$((BASE_LEDS)):out:0 >> $GPIO_CONF
echo PL_LED_1:$((BASE_LEDS + 1)):out:0 >> $GPIO_CONF

# PS RGB LEDs (PCB D18)
for i in $(seq 0 2); do
    echo PS_RGB_LED_$i:$((BASE_ZYNQMP_GPIO + 38 + i)):out:0 >> $GPIO_CONF
done

# PL RGB LEDs (PCB D15)
for i in $(seq 0 2); do
    echo PL_RGB_LED_$i:$((BASE_LEDS + 2 + i)):out:0 >> $GPIO_CONF
done

# PS PB switchs (PCB PB3, PB4)
echo PS_PB_0:$((BASE_ZYNQMP_GPIO + 31)):in >> $GPIO_CONF
echo PS_PB_1:$((BASE_ZYNQMP_GPIO + 35)):in >> $GPIO_CONF

# PL PB switchs (PCB PB5, PB6)
echo PL_PB_0:$((BASE_PL_PB)):in >> $GPIO_CONF
echo PL_PB_1:$((BASE_PL_PB + 1)):in >> $GPIO_CONF

# PS DIP switches (PCB SW2)
for i in $(seq 0 3); do
    echo PS_SW_$i:$((BASE_ZYNQMP_GPIO + 41 + i)):in >> $GPIO_CONF
done
