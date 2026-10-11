#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
# Fix 1: Unclamp 5GHz transmit power from 9 dBm to 20 dBm (0x14) when ePA is detected
sed -i '/index = mt7615_eeprom_get_target_power_index(dev, chan, j);/a \ \ \ \ \ \ \ \ if (eep[index] == 0 && mt7615_ext_pa_enabled(dev, chan->band)) {\n\t\t\teep[index] = 0x14;\n\t\t}' package/kernel/mt76/src/mt7615/init.c 2>/dev/null || sed -i '/index = mt7615_eeprom_get_target_power_index(dev, chan, j);/a \ \ \ \ \ \ \ \ if (eep[index] == 0 && mt7615_ext_pa_enabled(dev, chan->band)) {\n\t\t\teep[index] = 0x14;\n\t\t}' build_dir/target-*/mt76-*/mt7615/init.c

# Fix 2: Comment out the mt7615 MCU pre-calibration routine to eliminate PHY rate fluctuations
sed -i 's/mt7615_mcu_init_precal(dev);/\/\/mt7615_mcu_init_precal(dev);/g' package/kernel/mt76/src/mt7615/mcu.c 2>/dev/null || sed -i 's/mt7615_mcu_init_precal(dev);/\/\/mt7615_mcu_init_precal(dev);/g' build_dir/target-*/mt76-*/mt7615/mcu.c
