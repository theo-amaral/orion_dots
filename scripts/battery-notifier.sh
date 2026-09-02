#!/bin/bash
# Detecta o ID do usuário atual (necessário se o script rodar como root, mas útil sempre)
USER_ID=$(id -u)

# Define o display (quase sempre é :0 em desktops comuns)
export DISPLAY=:0

# Define o endereço do D-Bus (essencial para o notify-send funcionar)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus"
CRITICAL_CAP=10
WARNING_CAP=30

ran1=false
ran2=false

while true; do
    capacity=$(</sys/class/power_supply/BAT0/capacity)
    status=$(</sys/class/power_supply/BAT0/status)
    if [[ $capacity -le $CRITICAL_CAP ]] && [[ $status != "Charging" ]] && [[ $ran2 == false ]]; then
        ran2=true
        notify-send -u critical -t 10000 "Battery critical" "Charge your device."
    elif [[ $capacity -le $WARNING_CAP ]] && [[ $status != "Charging" ]] && [[ $ran1 == false ]]; then
        ran1=true
        notify-send -u critical -t 10000 "Battery low" "Charge your device."
    fi

    if [[ $status != "Charging" ]]; then
        if [[ $capacity -gt $WARNING_CAP ]]; then
            ran1=false
            ran2=false
        elif [[ $capacity -gt $CRITICAL_CAP ]]; then
            ran2=false
        fi
    fi

    sleep 5
done
