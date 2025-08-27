#!/bin/bash

echo "📄 Samsung Galaxy Device Markdown Generator"
echo "------------------------------------------"

# General info
read -p "📱 Device Name (e.g. S24 Ultra): " DEVICE_NAME
read -p "🧪 Device Codename (e.g. e3q): " CODENAME
read -p "📅 Release Date (e.g. Jan 2024): " RELEASE_DATE
read -p "🔢 Model Numbers (comma-separated, e.g. SM-S928B, SM-S928U): " MODELS
read -p "🖼️ Image URL: " IMAGE_URL

# Hardware
read -p "⚙️  SoC (e.g. Exynos 2400 / Snapdragon 8 Gen 3): " SOC
read -p "🧠 CPU (e.g. Octa-core 1x3.2 GHz + 3x2.9 GHz + 4x2.1 GHz): " CPU
read -p "🎮 GPU (e.g. Xclipse 940 / Adreno 750): " GPU
read -p "📏 RAM (e.g. 8GB / 12GB LPDDR5X): " RAM
read -p "💾 Storage Options (e.g. 128GB, 256GB, 512GB UFS 4.0): " STORAGE
read -p "💽 microSD Support? (Yes/No): " MICROSD

# Display
read -p "📐 Screen Size (e.g. 6.8 inches): " DISPLAY_SIZE
read -p "💡 Display Type (e.g. Dynamic AMOLED 2X): " DISPLAY_TYPE
read -p "🔳 Resolution (e.g. 3088x1440 px): " RESOLUTION
read -p "⚡ Refresh Rate (e.g. 120Hz): " REFRESH_RATE

# Camera
read -p "📸 Rear Camera - Main Sensor (e.g. 200MP, f/1.7, OIS): " CAM_MAIN
read -p "🔍 Rear Camera - Ultra-wide (e.g. 12MP, f/2.2): " CAM_ULTRA
read -p "🔭 Rear Camera - Telephoto (e.g. 10MP 3x, 10MP 10x): " CAM_TELE
read -p "🤳 Front Camera (e.g. 12MP, f/2.2): " CAM_FRONT

# Battery
read -p "🔋 Battery Capacity (e.g. 5000 mAh): " BATTERY
read -p "⚡ Charging Info (e.g. 45W wired, 15W wireless): " CHARGING

# Connectivity
read -p "📶 5G Support? (Yes/No): " SUPPORT_5G
read -p "📡 Wi-Fi Version (e.g. Wi-Fi 6E): " WIFI
read -p "🔵 Bluetooth Version (e.g. 5.3): " BT
read -p "💳 NFC? (Yes/No): " NFC
read -p "🔌 USB Type (e.g. USB Type-C 3.2): " USB
read -p "📲 SIM Type (e.g. Single SIM / Dual SIM Hybrid): " SIM

# Software
read -p "🧠 One UI Version (e.g. One UI 6.1): " ONEUI
read -p "🤖 Android Version (e.g. Android 14): " ANDROID
read -p "🔓 Bootloader Unlock Supported? (Yes/No): " BOOTLOADER
read -p "⚙️  Custom ROM Support? (Yes/No/Limited): " CUSTOM_ROM

# Other
read -p "🔐 Fingerprint Sensor Location (e.g. Under-display): " FINGERPRINT
read -p "💧 IP Rating (e.g. IP68 / None): " IP_RATING
read -p "🧱 Materials (e.g. Gorilla Glass front/back, Aluminum frame): " MATERIALS

# Output file name
FILENAME="readme.md"

# Generate Markdown
cat << EOF > "$FILENAME"
# Samsung Galaxy $DEVICE_NAME 📱

**Codename:** \`$CODENAME\`

![Samsung Galaxy $DEVICE_NAME]($IMAGE_URL)

## 📦 General Information

- **Brand:** Samsung  
- **Model Name:** Galaxy $DEVICE_NAME  
- **Device Codename:** \`$CODENAME\`  
- **Release Date:** $RELEASE_DATE  
- **Model Numbers:** \`$MODELS\`

## ⚙️ Hardware Specifications

| Component       | Specification |
|----------------|---------------|
| **Chipset (SoC)** | $SOC |
| **CPU**           | $CPU |
| **GPU**           | $GPU |
| **RAM**           | $RAM |
| **Storage Options** | $STORAGE |
| **microSD Support** | $MICROSD |

## 📱 Display

- **Size:** $DISPLAY_SIZE  
- **Type:** $DISPLAY_TYPE  
- **Resolution:** $RESOLUTION  
- **Refresh Rate:** $REFRESH_RATE

## 📷 Camera Setup

### Rear Camera:
- Main Sensor: $CAM_MAIN
- Ultra-wide: $CAM_ULTRA
- Telephoto: $CAM_TELE

### Front Camera:
- $CAM_FRONT

## 🔋 Battery & Charging

- **Battery Capacity:** $BATTERY  
- **Charging:** $CHARGING

## 📡 Connectivity

- 5G Support: $SUPPORT_5G  
- Wi-Fi: $WIFI  
- Bluetooth: $BT  
- NFC: $NFC  
- USB: $USB  
- SIM: $SIM

## 🧠 Software

- **One UI Version:** $ONEUI  
- **Android Version:** $ANDROID  
- **Bootloader Unlock:** $BOOTLOADER  
- **Custom ROM Support:** $CUSTOM_ROM

## 🛠️ Other Info

- **Fingerprint Sensor:** $FINGERPRINT  
- **IP Rating:** $IP_RATING  
- **Materials:** $MATERIALS

---

> **Note:** Specs may vary by region (Exynos/Snapdragon).  
> **Sources:** Samsung official site, GSMArena, device community pages.
EOF

echo ""
echo "✅ Markdown file generated: $FILENAME"

