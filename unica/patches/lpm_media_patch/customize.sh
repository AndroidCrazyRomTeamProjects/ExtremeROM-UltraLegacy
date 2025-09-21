if ${!TARGET_HAS_QHD_DISPLAY}; then
    echo "-An FHD device detected adding FHD LPM media"
    BLOBS_LIST="
    system/media/battery_error.spi
    system/media/battery_low.spi
    system/media/battery_protection.spi
    system/media/battery_temperature_error.spi
    system/media/battery_temperature_limit.spi
    system/media/battery_water_usb.spi
    system/media/incomplete_connect.spi
    system/media/lcd_density.txt
    system/media/new_vi_0_100.spi
    system/media/new_vi_1_100.spi
    system/media/new_vi_2_100.spi
    system/media/new_vi_level_0_1.spi
    system/media/new_vi_level_0_2.spi
    system/media/new_vi_level_0_3.spi
    system/media/new_vi_level_0_4.spi
    system/media/new_vi_level_1_1.spi
    system/media/new_vi_level_1_2.spi
    system/media/new_vi_level_1_3.spi
    system/media/new_vi_level_1_4.spi
    system/media/new_vi_level_2_1.spi
    system/media/new_vi_level_2_2.spi
    system/media/new_vi_level_2_3.spi
    system/media/new_vi_level_2_4.spi
    system/media/slow_charging_usb.spi
    system/media/temperature_limit_usb.spi
    system/media/water_protection_usb.spi
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "a54xxxxxx" "system" "$blob"
    done
    else
        echo "-A QHD device skiping LPM media patch"
fi
