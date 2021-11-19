#!/bin/sh

source /usr/local/bin/gpio/gpio_common.sh

BASE_41210000=$(get_gpiochip_base 41210000)
BASE_ZYNQ_GPIO=$(get_gpiochip_base zynq_gpio)

cat > $GPIO_CONF <<EOF
PL_LED4:$((BASE_41210000 + 1)):out:1
SW6:$((BASE_ZYNQ_GPIO + 51)):in
EOF
