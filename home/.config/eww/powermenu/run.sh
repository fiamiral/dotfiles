#!/bin/bash

close() {
    eww --config ~/.config/eww/powermenu close powermenu
    eww --config ~/.config/eww/powermenu close powermenu-closer
    hyprctl dispatch submap reset
}

case $1 in
    open)
        hyprctl dispatch submap powermenu
        eww --config ~/.config/eww/powermenu open powermenu
        eww --config ~/.config/eww/powermenu open powermenu-closer
        ;;
    lock)
        close
        swaylock &
        ;;
    suspend)
        close
        systemctl suspend
        ;;
    logout) 
        close
        sway exit
        ;;
    shutdown)
        close
        shutdown 0
        ;;
    reboot) 
        close
        reboot
        ;;
    close)
        close
        ;;
    *)
        exit 1
esac
