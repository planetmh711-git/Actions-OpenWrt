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

# Fix 1: Apply unified patch for MT7615 target power index adjustments and chain selections
mkdir -p feeds/base/package/kernel/mt76/patches/
cat << 'EOF' > feeds/base/package/kernel/mt76/patches/999-mt7615-eeprom-and-init-custom-fix.patch
--- a/mt7615/eeprom.c
+++ b/mt7615/eeprom.c
@@ -204,15 +204,6 @@ int mt7615_eeprom_get_target_power_index(struct mt7615_dev *dev,
 	if (chain_idx > 3)
 		return -EINVAL;

-	/* TSSI disabled */
-	if (mt7615_ext_pa_enabled(dev, chan->band)) {
-		if (chan->band == NL80211_BAND_2GHZ)
-			return MT_EE_EXT_PA_2G_TARGET_POWER;
-		else
-			return MT_EE_EXT_PA_5G_TARGET_POWER;
-	}
-
-	/* TSSI enabled */
 	if (chan->band == NL80211_BAND_2GHZ) {
 		index = MT_EE_TX0_2G_TARGET_POWER + chain_idx * 6;
 	} else {

--- a/mt7615/init.c
+++ b/mt7615/init.c
@@ -285,7 +285,7 @@ void mt7615_init_txpower(struct mt7615_dev *dev,
 	    (MT_EE_RATE_POWER_EN | MT_EE_RATE_POWER_SIGN))
 		delta += rate_val & MT_EE_RATE_POWER_MASK;

-	if (!is_mt7663(&dev->mt76) && mt7615_ext_pa_enabled(dev, band))
+	if (!is_mt7663(&dev->mt76) && !mt7615_ext_pa_enabled(dev, band))
 		target_chains = 1;
 	else
 		target_chains = n_chains;
EOF

# Fix 2: Comment out the mt7615 MCU pre-calibration routine inside the v25.12.5 feeds tree
sed -i 's/mt7615_mcu_init_precal(dev);/\/\/mt7615_mcu_init_precal(dev);/g' feeds/base/package/kernel/mt76/src/mt7615/mcu.c 2>/dev/null || true
