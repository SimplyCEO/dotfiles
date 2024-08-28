#!/bin/sh

LIGHT_WALLPAPER=""
DARK_WALLPAPER=""

while getopts "l:d:" char; do
  case $char in
    l) LIGHT_WALLPAPER="$OPTARG" ;;
    d) DARK_WALLPAPER="$OPTARG" ;;
    *) printf "Not regonized flag: %s\n" "$char" ;;
  esac
done

if [[ ! "$LIGHT_WALLPAPER" || ! "$DARK_WALLPAPER" ]]; then
  printf "ERROR: No wallpaper provided.\n"
  exit 1
fi

while true; do
  TIME=$(date +'%H')
  case $TIME in
    00|01|02|03|04|05|06|17|18|19|20|21|22|23|24)
      sh -c "swaybg --output \"*\" --image \"$DARK_WALLPAPER\" --mode fill" &
      SWAYBG_PID=$(pgrep --exact swaybg)
      ;;
    *)
      sh -c "swaybg --output \"*\" --image \"$LIGHT_WALLPAPER\" --mode fill" &
      SWAYBG_PID=$(pgrep --exact swaybg)
      ;;
  esac
  sleep 3600
  kill $SWAYBG_PID
done

