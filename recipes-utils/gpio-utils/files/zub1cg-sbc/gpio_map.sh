#!/bin/sh

source /usr/local/bin/gpio/gpio_common.sh

# axi_gpio_0 rgb_led_0
BASE_A0000000=$(get_gpiochip_base A0000000)
# axi_gpio_1 rgb_led_1
BASE_A0010000=$(get_gpiochip_base A0010000)
# axi_gpio_2 push_button_1bit
BASE_A0020000=$(get_gpiochip_base A0020000)
# axi_gpio_3 szg_trx2_pl_lb
BASE_A0030000=$(get_gpiochip_base A0030000)
# axi_gpio_4 szg_std_lb
BASE_A0040000=$(get_gpiochip_base A0040000)
# axi_gpio_5 szg_trx2_pl_pwr
BASE_A0050000=$(get_gpiochip_base A0050000)
# axi_gpio_6 szg_std_pwr
BASE_A0060000=$(get_gpiochip_base A0060000)
# axi_gpio_7 pl_pb
BASE_A0070000=$(get_gpiochip_base A0070000)

# MIO GPIO
BASE_ZYNQMP_GPIO=$(get_gpiochip_base zynqmp_gpio)

# PS LEDs (PCB D9, D8, D7, D6)
echo PS_LED1:$((BASE_ZYNQMP_GPIO + 7)):out:1 > $GPIO_CONF
echo PS_LED2:$((BASE_ZYNQMP_GPIO + 24)):out:1 >> $GPIO_CONF
echo PS_LED3:$((BASE_ZYNQMP_GPIO + 25)):out:1 >> $GPIO_CONF
echo PS_LED4:$((BASE_ZYNQMP_GPIO + 33)):out:1 >> $GPIO_CONF


# PL RGB LEDs (PCB D4,D5)
for i in $(seq 3); do
    echo PL_LED$i:$((BASE_A0000000 + i - 1)):out:1 >> $GPIO_CONF
    echo PL_LED$i:$((BASE_A0010000 + i - 1)):out:1 >> $GPIO_CONF
done

# PL PB switch (PCB SW3)
echo SW3:$((BASE_A0070000)):in >> $GPIO_CONF

# PS PB switch (PCB SW1)
echo SW1:$((BASE_ZYNQMP_GPIO + 32)):in >> $GPIO_CONF

# PS DIP switches (PCB SW4)
echo SW4_1:$((BASE_ZYNQMP_GPIO + 44)):in >> $GPIO_CONF
echo SW4_2:$((BASE_ZYNQMP_GPIO + 40)):in >> $GPIO_CONF
echo SW4_3:$((BASE_ZYNQMP_GPIO + 39)):in >> $GPIO_CONF
echo SW4_4:$((BASE_ZYNQMP_GPIO + 31)):in >> $GPIO_CONF


