option=$( echo -e "⏻ Poweroff\n Reboot\n⏾ Sleep\n󰒲 Hibernate" | wofi -i --dmenu | awk '{print tolower($2)}' )

case $option in
    poweroff)
        poweroff
        ;;
    reboot)
        reboot
        ;;
    sleep)
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
esac