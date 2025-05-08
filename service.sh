#!/system/bin/sh
# ThunderFlash Thermal Disabler (ZygiskNext-safe)

# Wait for boot completion
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

# Wait for Zygisk to inject (zygote & system_server)
while ! pidof zygote >/dev/null || ! pidof system_server >/dev/null; do
    sleep 2
done

# Final delay to ensure system is fully ready
sleep 20

# Disable thermal trip points if they exist
for zone in 0 9 10; do
    path="/sys/class/thermal/thermal_zone$zone/trip_point_0_temp"
    if [ -e "$path" ]; then
        chmod 0644 "$path" 2>/dev/null
        echo 999999999 > "$path" 2>/dev/null
    fi
done

# Stop known thermal services
stop thermald
stop thermal_core
stop vendor.thermal-hal-2-0.mtk

# Stop any thermal service dynamically
getprop | grep thermal | cut -f1 -d] | cut -f2 -d[ | grep -F init.svc. | sed 's/init.svc.//' | while read svc; do
    stop "$svc"
done

# Set thermal services as stopped
getprop | grep thermal | cut -f1 -d] | cut -f2 -d[ | grep -F init.svc. | while read svc; do
    setprop "$svc" stopped
done

# Clear thermal debug PIDs
getprop | grep thermal | cut -f1 -d] | cut -f2 -d[ | grep -F init.svc_ | while read svc; do
    setprop "$svc" ""
done

exit 0