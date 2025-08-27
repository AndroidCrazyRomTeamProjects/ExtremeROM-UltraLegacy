# ⚙️ ArtisanROM Quick Setup Guide

This guide helps you understand how to set up your ArtisanROM build environment using the automated script provided.

---

## 🚀 One-Liner Installer

Run the following command in your terminal to get started:

```bash
curl -fsSL -o artisan.sh https://raw.githubusercontent.com/ArtisanROM/ExtremeROM-UltraLegacy/refs/heads/fifteen/artisan.sh && bash artisan.sh
```

## 🚀 What the Installer Does

When you run the installer script, it performs the following steps:

1. **Downloads the setup script** from the official ArtisanROM repository.
2. **Configures Git** by prompting you to enter your Git name and email. This is required to interact with Git tools.
3. **Installs all required packages** using the APT package manager. These include compilers, libraries, and tools needed for Android ROM development.
4. **Clones the ArtisanROM source code** from GitHub (if it hasn't already been cloned).
5. **Prompts you to choose your device** by entering the correct codename:
   - `crownlte` – Galaxy Note9
   - `r7n` – Galaxy Note10 Lite
   - `star2lte` – Galaxy S9+
   - `starlte` – Galaxy S9
6. **Sources the build environment script** based on your selected codename.
7. **Optionally begins the build process**, which will download more than 25GB of files and compile the ROM for your device.

---

## 🧩 What You’ll Need

- A Linux system based on Ubuntu or Debian
- At least **400 GB** of free disk space
- A stable internet connection
- Sudo (administrator) access to install packages and extract android partitions

---

## 📝 What to Expect During Setup

The script will ask you for:

- Your name and email (for Git configuration)
- Your device codename (to configure the correct environment)
- Confirmation before downloading large files and starting the build

---

## 📦 After Building

When the build finishes successfully:

- Your custom ROM will be available in the `out/` directory within the project folder.

---

## 🧠 Troubleshooting

- Ensure your system has internet access and the `apt` package manager is working correctly.
- If something fails, you can simply rerun the script. It will resume or reuse existing data where possible.

---

ArtisanROM - Build with style ⚙️📱
