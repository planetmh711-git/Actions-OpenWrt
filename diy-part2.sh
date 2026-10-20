#!/bin/bash
#
# https://github.com
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Step 1: Force initialization of package directories so feed targets are mapped
mkdir -p feeds/base/package/kernel/mt76/patches/

# Step 2: Inject the exact community patch structure
cat << 'EOF' > feeds/base/package/kernel/mt76/patches/999-mt7615-fix-power-and-mcs.patch
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

--- a/mt7615/mcu.c
+++ b/mt7615/mcu.c
@@ -37,7 +37,7 @@ int mt7615_mcu_init(struct mt7615_dev *dev)
 	if (err < 0)
 		return err;
 
-	mt7615_mcu_init_precal(dev);
+	/* mt7615_mcu_init_precal(dev); */
 
 	return 0;
 }
EOF
