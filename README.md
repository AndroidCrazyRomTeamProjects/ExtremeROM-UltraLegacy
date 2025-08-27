<h1 align="center">
  <img loading="eager" src="readme-res/banner.png"/>
</h1>
<p align="center">
  <a href="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy/blob/fifteen/LICENSE"><img loading="lazy" src="https://img.shields.io/github/license/ArtisanROM/ExtremeROM-UltraLegacy?style=for-the-badge&logo=github"/></a>
  <a href="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy/commits/fifteen"><img loading="lazy" src="https://img.shields.io/github/last-commit/ArtisanROM/ExtremeROM-UltraLegacy/fifteen?style=for-the-badge"/></a>
  <a href="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy/stargazers"><img loading="lazy" src="https://img.shields.io/github/stars/ArtisanROM/ExtremeROM-UltraLegacy?style=for-the-badge"/></a>
  <a href="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy/graphs/contributors"><img loading="lazy" src="https://img.shields.io/github/contributors/ArtisanROM/ExtremeROM-UltraLegacy?style=for-the-badge"/></a>
  <a href="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy/actions/workflows/build-9810.yml"><img loading="lazy" src="https://img.shields.io/github/actions/workflow/status/ArtisanROM/ExtremeROM-UltraLegacy/build-9810.yml?branch=fifteen&style=for-the-badge&logo=githubactions&logoColor=white&label=Build%20ArtisanROM"/>
  </a>
</p>

<p align="center">ArtisanROM Ultra is a work-in-progress custom firmware for Samsung Galaxy devices.</p>
<p align="center">
  <a href="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy/wiki">📖 Wiki</a>
  <a href="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy/blob/fifteen/MAINTAINERS.md">🧑‍💻 Maintainers</a>
</p>

# What is ArtisanROM Ultra?
ArtisanROM Ultra is a work-in-progress custom firmware for Samsung Galaxy devices based on ExtremeROM. It's based on the latest and greatest iteration of Samsung's UX and it also includes additional features and tweaks to ensure the best possible experience out of the box.
It is based on the UN1CA build system which allows automatic downloading/extraction of the firmware, applying the required patches and generating a flashable zip/tar package for the specified target device.
ArtisanROM Ultra will support the Note9/Note10 Lite/S9/S9+ running an Exynos 9810 SoC

Any form of contribution, suggestions, bug report or feature request for the project will be welcome.

# Features
- Based on the latest stable OneUI 7 Galaxy S24 FE firmware
- All software features from S24 FE
- S25 Ultra CSC, ringtones and more
- Moderately Debloated
- Heavily DeKnoxed
- Full SELinux Support
- Full Galaxy AI support
- Now Brief Support
- Adaptive color tone support
- Super HDR support
- Adaptive Brightness support
- Full CSC support
- Multi-User support
- High end animations
- Native/live blur support
- Debloated from useless system services/additional apps
- [BluetoothLibraryPatcher](https://github.com/3arthur6/BluetoothLibraryPatcher) included
- [KnoxPatch](https://github.com/salvogiangri/KnoxPatch) implemented in system frameworks
- Extra mods (Disable Secure Flag, OutDoor mode, more coming soon)
- Extra CSC features (Call recording, Network speed in status bar, 5GHz Hotspot)
- Countless other small optimizations

# Bugs
See the <a href="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy/issues">⚠ Issues</a> tab

# Licensing
This project is licensed under the terms of the [GNU General Public License v3.0](LICENSE). External dependencies might be distributed under a different license, such as:
- [android-tools](https://github.com/nmeum/android-tools), licensed under the [Apache License 2.0](https://github.com/nmeum/android-tools/blob/master/LICENSE)
- [apktool](https://github.com/iBotPeaches/Apktool), licensed under the [Apache License 2.0](https://github.com/iBotPeaches/Apktool/blob/master/LICENSE.md)
- [erofs-utils](https://github.com/sekaiacg/erofs-utils/), dual license ([GPL-2.0](https://github.com/sekaiacg/erofs-utils/blob/dev/LICENSES/GPL-2.0), [Apache-2.0](https://github.com/sekaiacg/erofs-utils/blob/dev/LICENSES/Apache-2.0))
- [img2sdat](https://github.com/xpirt/img2sdat), licensed under the [MIT License](https://github.com/xpirt/img2sdat/blob/master/LICENSE)
- [platform_build](https://android.googlesource.com/platform/build/) (ext4_utils, f2fs_utils, signapk), licensed under the [Apache License 2.0](https://source.android.com/docs/setup/about/licenses)
- [smali](https://github.com/google/smali), [multiple licenses](https://github.com/google/smali/blob/main/third_party/NOTICE)

# Accountability
```cpp
#include <std_disclaimer.h>

/*
* Your warranty is now void.
*
* I am not responsible for bricked devices, dead SD cards,
* thermonuclear war, or you getting fired because the alarm app failed. Please
* do some research if you have any concerns about doing this to your device
* YOU are choosing to make these modifications, and if
* you point the finger at me for messing up your device, I will laugh at you.
*
* I am also not responsible for you getting in trouble for using any of the
* features in this ROM, including but not limited to Call Recording, secure
* flag removal etc.
*/
```

# Credits
- **[ExtremeXT](https://github.com/ExtremeXT)** - For the ExtremeROM the base of this repo and the inspiration to start android porting.
- **[Salvo Giangreco](https://github.com/salvogiangri)** - For the the UN1CA build system.
- **[Yacine](https://github.com/Yacinegti-DZ)** - For all the support, recomendations, The Amazing banner and more!
- **[ElVettorato](https://github.com/gabrl12345678900)** - For testing ArtisanROM Ultra on his star2lte (S9+).
- **[Oskar](https://github.com/osrott61-gh)** - For making PR #2 to fix the README and the One UI 8 apps mod
- **[Rust-Arcee/Amber](https://github.com/Rust-Arcee)** - For all the support
- I forgot the rest. I lost most my braincells with my 200+ commits in the fork lol. place an issue if I forgot you 

# Original ExtremeROM credits:
A big thanks goes to the following for their invaluable contributions in no particular order (MORE INFO AND PEOPLE: TO BE WRITTEN)
- **[salvogiangri](https://github.com/salvogiangri)** for the UN1CA build system, OneUI patches, and general help and support while developing
- **[Ocin4Ever](https://github.com/Ocin4Ever)** for a lot of help especially on smali, advice and emotional support :D
- **[Igor](https://github.com/BotchedRPR)** for getting me into porting, teaching me the basics, and emotional support down the road
- **[Halal Beef](https://github.com/halal-beef)** for lk3rd, testing and misc help
- **[Emad](https://github.com/emadhamid7)** for help with S10-specific fixes
- **[Duhan](https://github.com/duhansysl)** for help with vendor backports, a lot of fixes and advice
- **[Anan](https://github.com/ananjaser1211)** for all of his contributions to OneUI porting
- **[PeterKnecht93](https://github.com/PeterKnecht93)** for help with smali and a lot of misc fixes
- **[tsn](https://github.com/tisenu100)** for some smali fixes and advice
- **[Nguyen Long](https://github.com/LumiPlayground)** for misc fixes and support
- **[AlexFurina](https://github.com/AlexFurina)** for S10 specific fixes
- **[Luphaestus](https://github.com/Luphaestus)** for Note 20 specific fixes
- **[Yagzie](https://github.com/Yagzie)** for engmode and misc fixes
- **[Fred](https://github.com/xfwdrev)** for WFD, HDR10+, audiopolicy and more fixes
- **[Saad](https://github.com/saadelasfur)** for help with build system
- **[Vince](https://github.com/borbelyvince)** for help with kernel upstream
- **Nhat Vo** for Google Telemetry app removal
- **[Code Malaya](https://github.com/jomiejoshiro)** for SPen Air Actions
- **[Renox](https://github.com/renoxtv)** for overlay patches and testing
- **[Ksawlii](https://github.com/Ksawlii)** for FOD animation patch
- **[nalz0](https://github.com/nalz0)** for Multi-User support
- **[EndaDwagon](https://github.com/EndaDwagon)** for the big majority of the ExtremeROM Wiki
- **[Oskar](https://github.com/osrott61-gh)** N20/S22 Odinpacks, Building alot before we started using actions, some parts of the Wiki
- **[Mesazane](https://github.com/Mesazane)** for Building alot before we started using actions
- **[Dupa](https://github.com/dupazlasu)** for Maintaining S22 Series (ROM + Kernel)
- **[RayShocker](https://github.com/RayShocker)** for HRM fix
- **@april865** (TG) for ExtremeROM Nexus banner
- And everyone else who aided in testing, wiki, translations etc!

# Original UN1CA credits:
- **[ShaDisNX255](https://github.com/ShaDisNX255)** for his help, time and for his [NcX ROM](https://github.com/ShaDisNX255/NcX_Stock) which inspired this project
- **[DavidArsene](https://github.com/DavidArsene)** for his help and time
- **[paulowesll](https://github.com/paulowesll)** for his help and support
- **[Simon1511](https://github.com/Simon1511)** for his support and some of the device-specific patches
- **[ananjaser1211](https://github.com/ananjaser1211)** for troubleshooting and his time
- **[iDrinkCoffee](https://github.com/iDrinkCoffee-TG)** and **[RisenID](https://github.com/RisenID)** for documentation revisioning
- **[LineageOS Team](https://www.lineageos.org/)** for their original [OTA updater implementation](https://github.com/LineageOS/android_packages_apps_Updater)
- *All the UN1CA project contributors and testers ❤️*

# Stargazers over time
[![Stargazers over time](https://starchart.cc/ArtisanROM/ExtremeROM-UltraLegacy.svg)](https://starchart.cc/ArtisanROM/ExtremeROM-UltraLegacy)
