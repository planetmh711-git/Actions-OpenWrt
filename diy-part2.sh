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

# Fix 1: Unclamp 5GHz transmit power from 9 dBm to 20 dBm (0x14) inside the v25.12.5 feeds tree
sed -i '/index = mt7615_eeprom_get_target_power_index(dev, chan, j);/a \ \ \ \ \ \ \ \ if (eep[index] == 0 && mt7615_ext_pa_enabled(dev, chan->band)) {\n\t\t\teep[index] = 0x14;\n\t\t}' feeds/base/package/kernel/mt76/src/mt7615/init.c 2>/dev/null || true

# Fix 2: Comment out the mt7615 MCU pre-calibration routine inside the v25.12.5 feeds tree
sed -i 's/mt7615_mcu_init_precal(dev);/\/\/mt7615_mcu_init_precal(dev);/g' feeds/base/package/kernel/mt76/src/mt7615/mcu.c 2>/dev/null || true
