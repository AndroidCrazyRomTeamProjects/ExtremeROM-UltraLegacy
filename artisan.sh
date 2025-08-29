#!/bin/bash

set -e

# ==== Colors ====
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
CYAN="\033[1;36m"
NC="\033[0m"

# ==== ASCII Banner ====
cat << "EOF"
+================================================================+
|                                                                |        
|                  _   _                 _____   ____  __  __    |
|       /\        | | (_)               |  __ \ / __ \|  \/  |   |
|      /  \   _ __| |_ _ ___  __ _ _ __ | |__) | |  | | \  / |   |
|     / /\ \ | '__| __| / __|/ _` | '_ \|  _  /| |  | | |\/| |   |
|    / ____ \| |  | |_| \__ \ (_| | | | | | \ \| |__| | |  | |   |
|   /_/    \_\_|   \__|_|___/\__,_|_| |_|_|  \_\\____/|_|  |_|   |
|                                                                |        
|                 ArtisanROM Ultra  V 0 . 5 . 0                  |          
+================================================================+

EOF

# ==== Git identity ====
echo -e "${YELLOW}🛠️ Git Identity Setup${NC}"
echo -e "${CYAN}If your Git identity is already configured, you can just press Enter to skip.${NC}"
read -p "Enter your name (or press Enter to skip): " git_user
read -p "Enter your email (or press Enter to skip): " git_email

if [[ -n "$git_user" && -n "$git_email" ]]; then
    git config --global user.name "$git_user"
    git config --global user.email "$git_email"
    echo -e "${GREEN}✓ Git configured as $git_user <$git_email>${NC}"
else
    echo -e "${YELLOW}⚠️ Skipping Git identity setup. Make sure it's already configured globally.${NC}"
fi

# ==== Ask before installing dependencies ====
echo
echo -e "${RED}❗ WARNING: The build will 100% fail if required dependencies are missing!${NC}"
echo -e "${CYAN}If you already installed all required packages, you can safely skip this step.${NC}"
read -p "Do you want to install all required dependencies now? (y/n): " install_deps

if [[ "$install_deps" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Installing required packages...${NC}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y attr ccache clang git golang libbrotli-dev libgtest-dev liblz4-dev \
    libpcre2-dev libprotobuf-dev libunwind-dev libusb-1.0-0-dev libzstd-dev lld openjdk-11-jdk \
    protobuf-compiler zip zipalign make cmake npm lz4 brotli patchelf curl xxd bison flex
    echo -e "${GREEN}✓ All packages installed.${NC}"
else
    echo -e "${RED}⚠️ You chose NOT to install dependencies. If they are missing, the build WILL fail.${NC}"
fi

# ==== Clone or detect repo ====
REPO_URL="https://github.com/ArtisanROM/ExtremeROM-UltraLegacy.git"
REPO_NAME="ExtremeROM-UltraLegacy"

echo
echo -e "${YELLOW}Checking for existing repo...${NC}"
if [ -d "$REPO_NAME" ]; then
    echo -e "${GREEN}✓ Found existing repo at ${REPO_NAME}${NC}"
else
    echo -e "${YELLOW}Cloning repo from $REPO_URL...${NC}"
    git clone --recurse-submodules "$REPO_URL"
    echo -e "${GREEN}✓ Repo cloned successfully.${NC}"
fi

cd "$REPO_NAME"

# ==== Prompt for device codename ====
echo
echo -e "${YELLOW}Choose a device codename to set up the build:${NC}"
echo -e "  ${CYAN}CROWNLTE${NC}   → Samsung Galaxy Note9"
echo -e "  ${CYAN}STAR2LTE${NC}   → Samsung Galaxy S9+"
echo -e "  ${CYAN}STARLTE${NC}    → Samsung Galaxy S9"
echo -e "  ${CYAN}R7N${NC}        → Samsung Galaxy Note10 Lite"
echo -e "  ${CYAN}E1S${NC}        → Samsung Galaxy S24 (WIP)"
echo -e "  ${CYAN}E2S${NC}        → Samsung Galaxy S24+ (WIP)"
echo -e "  ${CYAN}R12S${NC}       → Samsung Galaxy S24FE"
echo -e "  ${CYAN}M33X${NC}       → Samsung Galaxy M33 5G"
echo -e "  ${CYAN}M34X${NC}       → Samsung Galaxy M34 5G (WIP)"
echo

read -p "Enter codename (e.g., crownlte): " codename

if [[ -z "$codename" ]]; then
    echo -e "${RED}❌ Codename is required to continue!${NC}"
    exit 1
fi

# ==== Source buildenv ====
echo -e "${CYAN}Sourcing buildenv.sh for '${codename}'...${NC}"
source ./buildenv.sh "$codename"

# ==== Confirm before build ====
echo
echo -e "${RED}⚠️  WARNING: This process will download over 35GB of files.${NC}"
read -p "Do you want to begin building now? (y/n): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}🚀 Starting build...${NC}"
    rm -rf out/apktool
    rm -rf out/work_dir
    run_cmd make_rom --force
    echo -e "${GREEN}✅ Build complete! You can find your ROM in the ${CYAN}out${GREEN} directory.${NC}"
else
    echo -e "${YELLOW}🕓 Build was skipped. You can run it later using:${NC} ${CYAN}run_cmd make_rom${NC}"
fi

