#!/bin/sh

OUTPUT=""

wifi_connection()
{
  WIFI="$(cat /proc/net/wireless | grep wlan | awk '{print $3}' | sed 's/\.//')%"
  if [ ${STATUS_BAR_WIFI_EXTENDED} ]; then
    WIFI="${WIFI}($(cat /proc/net/wireless | grep wlan | awk '{print $4}' | sed 's/\.//')%)"
  fi
  OUTPUT="${OUTPUT} ${WIFI}"
}

temperature_sensor()
{
  SENSORS="$(sensors | grep 'temp1:' | awk '{print $2}' | sed 's/\..*//' | sed 's/\+//')°C"
  OUTPUT="${OUTPUT} ${SENSORS}"
}

cpu_frequency_percentage()
{
  CPU_FREQUENCY="$(top -b -n 1 | grep -i "^%cpu" | awk '{print $2}' | sed 's/\..*//')%"
  OUTPUT="${OUTPUT} ${CPU_FREQUENCY}"
}

available_memory_swap()
{
  AMS="$(free | grep Mem: | awk '{print ($3*100)/$2}' | sed 's/\..*//')%"
  if [ ${STATUS_BAR_ASK_SWAP} ]; then
    AMS="${AMS}($(free | grep Swap: | awk '{print ($3*100)/$2}' | sed 's/\..*//')%)"
  fi
  OUTPUT="${OUTPUT} ${AMS}"
}

charge_capacity()
{
  ADAPTER=$(cat /sys/class/power_supply/ADP0/online)
  CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
  case ${ADAPTER} in
    1) BATCHAR="" ;;
    *)
      RANGE=$(bc -l <<< "scale=0; $CAPACITY / 20")
      case ${RANGE} in
        0) BATCHAR="" ;;
        1) BATCHAR="" ;;
        2) BATCHAR="" ;;
        3) BATCHAR="" ;;
        4) BATCHAR="" ;;
      esac
    ;;
  esac
  BATCHAR="${BATCHAR}${CAPACITY}%"
  OUTPUT="${OUTPUT} ${BATCHAR}"
}

audio_volume()
{
  AUDIO="$(amixer get Master | grep -o '[0-9]*%' | xargs | awk '{print $1}')"
  OUTPUT="${OUTPUT} ${AUDIO}"
}

date_and_time()
{
  CALENDOUR="$(date +'%H:%M')"
  OUTPUT="${OUTPUT} ${CALENDOUR}"
}

while getopts "abcdmtw" "char"; do
  case $char in
    a) audio_volume ;;
    b) charge_capacity ;;
    c) cpu_frequency_percentage ;;
    d) date_and_time ;;
    m) available_memory_swap ;;
    t) temperature_sensor ;;
    w) wifi_connection ;;
    *) printf "ERROR: No given input.\n"; exit 1 ;;
  esac
done

printf "%s" "${OUTPUT}"

