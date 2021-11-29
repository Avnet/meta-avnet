#!/bin/sh

source /usr/local/bin/gpio/gpio_common.sh

BASE_41200000=$(get_gpiochip_base 41200000)
BASE_41220000=$(get_gpiochip_base 41220000)
BASE_ZYNQ_GPIO=$(get_gpiochip_base zynq_gpio)
BASE_41210000=$(get_gpiochip_base 41210000)


cat > $GPIO_CONF <<EOF
PL_R:$((BASE_41200000 + 1)):out:0
PL_G:$((BASE_41200000)):out:0
PS_R:$((BASE_ZYNQ_GPIO + 52)):out:0
PS_G:$((BASE_ZYNQ_GPIO + 53)):out:0
PL_SWITCH:$((BASE_41210000)):in
PS_BUTTON:$((BASE_ZYNQ_GPIO)):in
EOF

for i in $(seq 0 7); do
    echo PL_MIC${i}:$((BASE_41220000 + i)):out:0 >> $GPIO_CONF
done
