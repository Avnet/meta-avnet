#!/bin/sh

source /usr/local/bin/gpio/gpio_common.sh

BASE_A0000000=$(get_gpiochip_base a0000000)
BASE_ZYNQMP_GPIO=$(get_gpiochip_base zynqmp_gpio)

echo WIFI_LED:$((BASE_A0000000)):out:0 > $GPIO_CONF
echo BT_LED:$((BASE_A0000000 + 1)):out:0 >> $GPIO_CONF

echo GPIO_PB:$((BASE_ZYNQMP_GPIO + 23)):in >> $GPIO_CONF


# MIO PS LEDs (PCB D3, D4, D6, D7)
echo MIO_PS_LED_0:$((BASE_ZYNQMP_GPIO + 20)):out:1 >> $GPIO_CONF
echo MIO_PS_LED_1:$((BASE_ZYNQMP_GPIO + 19)):out:1 >> $GPIO_CONF
echo MIO_PS_LED_2:$((BASE_ZYNQMP_GPIO + 18)):out:1 >> $GPIO_CONF
echo MIO_PS_LED_3:$((BASE_ZYNQMP_GPIO + 17)):out:1 >> $GPIO_CONF

for i in $(seq 0 22); do
    echo LOOPBACK_GPIO_OUT_$i:$((BASE_ZYNQMP_GPIO + 78 + i)):out:1 >> $GPIO_CONF
done

for i in $(seq 0 20); do
    echo LOOPBACK_GPIO_IN_$i:$((BASE_ZYNQMP_GPIO + 78 + 23 + i)):in:1 >> $GPIO_CONF
done
