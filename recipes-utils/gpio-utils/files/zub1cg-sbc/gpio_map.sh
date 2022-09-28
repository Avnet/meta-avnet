#!/bin/sh

source /usr/local/bin/gpio/gpio_common.sh

# axi_gpio_0 rgb_led_0
BASE_RGB_LED_0=$(get_gpiochip_base a0000000)
# axi_gpio_1 rgb_led_1
BASE_RGB_LED_1=$(get_gpiochip_base a0010000)
# axi_gpio_2 szg_trx2_mio_lb
BASE_SZG_TRX2_MIO_LB=$(get_gpiochip_base a0020000)
# axi_gpio_3 szg_trx2_pl_lb
BASE_SZG_TRX2_PL_LB=$(get_gpiochip_base a0030000)
# axi_gpio_4 szg_std_lb
BASE_SZG_STD_LB=$(get_gpiochip_base a0040000)
# axi_gpio_5 szg_trx2_pl_pwr
BASE_SZG_TRX2_PL_PWR=$(get_gpiochip_base a0050000)
# axi_gpio_6 szg_std_pwr
BASE_SZG_STD_PWR=$(get_gpiochip_base a0060000)
# axi_gpio_7 pl_pb
BASE_PL_PB=$(get_gpiochip_base a0070000)
# axi_gpio_8 click_test_leds
BASE_CLICK_TEST_LEDS=$(get_gpiochip_base a0080000)

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

# CLICK_TEST_LEDS
echo CLICK_TEST_LED_RST:$((BASE_CLICK_TEST_LEDS + 0)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_CS:$((BASE_CLICK_TEST_LEDS + 1)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_SCK:$((BASE_CLICK_TEST_LEDS + 2)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_SDO:$((BASE_CLICK_TEST_LEDS + 3)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_SDI:$((BASE_CLICK_TEST_LEDS + 4)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_PWM:$((BASE_CLICK_TEST_LEDS + 5)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_INT:$((BASE_CLICK_TEST_LEDS + 6)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_TX:$((BASE_CLICK_TEST_LEDS + 7)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_RX:$((BASE_CLICK_TEST_LEDS + 8)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_SCL:$((BASE_CLICK_TEST_LEDS + 9)):out:1 >> $GPIO_CONF
echo CLICK_TEST_LED_SDA:$((BASE_CLICK_TEST_LEDS + 10)):out:1 >> $GPIO_CONF
