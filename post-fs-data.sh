#!/system/bin/sh
# Extra security - override props and disable thermal zones

resetprop -n dalvik.vm.dexopt.thermal-cutoff 0
resetprop -n debug.thermal.throttle.support no
resetprop -n persist.vendor.powerhal.thermal_ux_temp_max 99999
resetprop -n persist.vendor.powerhal.thermal_ux_temp_min 0
resetprop -n ro.esports.thermal_config.support 0
resetprop -n ro.tran_thermal_cc_support 0
resetprop -n ro.vendor.mtk_thermal_2_0 0
resetprop -n ro.vendor.powerhal.thermal_ux_support 0
resetprop -n ro.vendor.tran.hbm.thermal-patch ""
resetprop -n ro.vendor.tran.hbm.thermal.temp.clr 99999
resetprop -n ro.vendor.tran.hbm.thermal.temp.trig 99999

# Disable all thermal_zone modes
for i in $(seq 0 28); do
    if [ -e /sys/class/thermal/thermal_zone$i/mode ]; then
        echo disabled > /sys/class/thermal/thermal_zone$i/mode
    fi
done
