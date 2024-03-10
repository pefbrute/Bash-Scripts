#!/bin/bash

while true; do
    # Получаем текущий уровень заряда батареи
    battery_level=$(cat /sys/class/power_supply/BAT0/capacity)

    # Получаем статус зарядки батареи
    charging_status=$(cat /sys/class/power_supply/BAT0/status)

    # Проверяем условия для разных действий
    if [ $battery_level -lt 40 ] && [ "$charging_status" != "Charging" ]; then
        # Условие для выключения ноутбука, если заряд низкий и он не заряжается
        systemctl poweroff
    elif [ $battery_level -ge 40 ] && [ $battery_level -le 50 ] && [ "$charging_status" != "Charging" ]; then
        # Условие для вывода сообщения, если заряд батареи между 40 и 50
        zenity --warning --text="СРОЧНО ПОСТАВЬ БАТАРЕЮ НА ЗАРЯДКУ!" --title="Предупреждение о зарядке" 2>/dev/null || echo "СРОЧНО ПОСТАВЬ БАТАРЕЮ НА ЗАРЯДКУ!"
    elif [ $battery_level -gt 80 ] && [ "$charging_status" = "Charging" ]; then
        # Условие для предупреждения о необходимости отключить зарядное устройство, если заряд высок
        zenity --warning --text="Срочно нужно отрубить батарею от зарядки!" --title="Предупреждение о зарядке" 2>/dev/null || echo "Графический интерфейс недоступен. Срочно нужно отрубить батарею от зарядки!"
    else
        # Условия, когда зарядка в норме или устройство заряжается
        if [ "$charging_status" = "Charging" ]; then
            echo "Не вырубаю ноут, потому что он на зарядке."
        else
            echo "Не вырубаю ноут, потому что зарядка выше 40%."
        fi
    fi

    # Пауза на 2 минуты перед следующей итерацией
    sleep 2m
done
