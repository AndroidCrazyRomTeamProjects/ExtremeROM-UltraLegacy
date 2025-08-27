#!/usr/bin/env bash
#
# Copyright (C) 2023 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

# shellcheck disable=SC2162

set -e

# [
GET_LATEST_FIRMWARE()
{
    curl -s --retry 5 --retry-delay 5 "https://fota-cloud-dn.ospserver.net/firmware/$REGION/$MODEL/version.xml" \
        | grep latest | sed 's/^[^>]*>//' | sed 's/<.*//'
}

GET_IMG_FS_TYPE()
{
    if [[ "$(xxd -p -l "2" --skip "1080" "$1")" == "53ef" ]]; then
        echo "ext4"
    elif [[ "$(xxd -p -l "4" --skip "1024" "$1")" == "1020f5f2" ]]; then
        echo "f2fs"
    elif [[ "$(xxd -p -l "4" --skip "1024" "$1")" == "e2e1f5e0" ]]; then
        echo "erofs"
    else
        echo "unknown"
    fi
}

EXTRACT_KERNEL_BINARIES()
{
    local PDR
    PDR="$(pwd)"

    # Determine if .lz4 suffix should be used
    local lz4_compressed=true
    if [[ "$TARGET_PLATFORM" == "exynos7420" ]]; then
        lz4_compressed=false
    fi

    # List base filenames, suffix will be added dynamically
    local FILES_BASENAMES="boot.img dtb.img dtbo.img init_boot.img vendor_boot.img"

    echo "- Extracting kernel binaries..."
    cd "$FW_DIR/${MODEL}_${REGION}"
    for file_basename in $FILES_BASENAMES
    do
        local file_in_tar="${file_basename}"
        if $lz4_compressed; then
            file_in_tar="${file_basename}.lz4"
        fi

        [ -f "${file_basename}" ] && continue # Check for the final uncompressed file

        tar tf "$AP_TAR" "$file_in_tar" &>/dev/null || continue
        
        echo "Extracting ${file_basename}"
        tar xf "$AP_TAR" "$file_in_tar"
        
        # Only perform lz4 decompression if it was an lz4 compressed file.
        # If not lz4_compressed (exynos7420), tar extracted it as file_basename already,
        # so no further action is needed.
        if $lz4_compressed; then
            lz4 -d -q --rm "$file_in_tar" "${file_basename}"
        fi
    done

    cd "$PDR"
}

EXTRACT_OS_PARTITIONS()
{
    local PDR
    PDR="$(pwd)"

    local SHOULD_EXTRACT=false
    local SHOULD_EXTRACT_SUPER=false

    echo "- Extracting OS partitions..."
    cd "$FW_DIR/${MODEL}_${REGION}"

    local COMMON_FOLDERS="product system vendor"
    local NON_DYNAMIC_PARTITIONS="product system vendor"

    # Determine if .lz4 suffix should be used for extraction and decompression
    local lz4_compressed=true
    if [[ "$TARGET_PLATFORM" == "exynos7420" ]]; then
        lz4_compressed=false
    fi

    # --- MODIFICATION START ---
    # If TARGET_PLATFORM is "exynos7420", only super.img will be skipped.
    # Product and vendor partitions will be processed if they exist.
    if [[ "$TARGET_PLATFORM" == "exynos7420" ]]; then
        echo "TARGET_PLATFORM is exynos7420. Skipping super.img extraction."
        # COMMON_FOLDERS and NON_DYNAMIC_PARTITIONS remain "product system vendor"
        # The skipping of super.img is handled by the conditional 'if' below.
    fi
    # --- MODIFICATION END ---

    for folder in $COMMON_FOLDERS
    do
        [ ! -d "$folder" ] && SHOULD_EXTRACT=true
        [ ! -f "$folder.img" ] && SHOULD_EXTRACT_SUPER=true
    done

    if $SHOULD_EXTRACT; then
        # Only attempt to extract super.img if TARGET_PLATFORM is NOT "exynos7420"
        # and if super.img (with or without .lz4 suffix) exists in the AP_TAR
        local super_img_in_tar="super.img"
        if $lz4_compressed; then
            super_img_in_tar="super.img.lz4"
        fi

        if [[ "$TARGET_PLATFORM" != "exynos7420" ]] && tar tf "$AP_TAR" "$super_img_in_tar" &>/dev/null; then
            if [ ! -f "lpdump" ] || $SHOULD_EXTRACT_SUPER; then
                echo "Extracting super.img"
                tar xf "$AP_TAR" "$super_img_in_tar"
                
                if $lz4_compressed; then
                    lz4 -d -q --rm "$super_img_in_tar" "super.img.sparse"
                else
                    # If not lz4_compressed (exynos7420), rename the extracted .img to .img.sparse
                    mv "$super_img_in_tar" "super.img.sparse"
                fi
                simg2img "super.img.sparse" "super.img" && rm "super.img.sparse"
                { lpunpack "super.img" > /dev/null; } 2>&1
                lpdump "super.img" > "lpdump" && rm "super.img"
            fi
            if [ ! -f "prism.img" ]; then
                local CSC_PARTITIONS="prism optics"
                for partition in $CSC_PARTITIONS
                do
                    local partition_in_tar="${partition}.img"
                    if $lz4_compressed; then
                        partition_in_tar="${partition}.img.lz4"
                    fi

                    echo "Extracting $partition.img from TAR"
                    tar xf "$CSC_TAR" "$partition_in_tar"
                    
                    if $lz4_compressed; then
                        lz4 -d -q --rm "$partition_in_tar" "$partition.img.sparse"
                    else
                        # If not lz4_compressed (exynos7420), rename the extracted .img to .img.sparse
                        mv "$partition_in_tar" "$partition.img.sparse"
                    fi
                    simg2img "$partition.img.sparse" "$partition.img" && rm "$partition.img.sparse"
                done
            fi
        else
            # This block handles non-dynamic partitions (product, system, vendor).
            # For exynos7420, these will now be processed.
            for partition in $NON_DYNAMIC_PARTITIONS
            do
                echo "Extracting $partition.img from TAR"
                local partition_file_in_tar="${partition}.img"
                if $lz4_compressed; then
                    partition_file_in_tar="${partition}.img.lz4"
                fi

                # Try to extract from AP_TAR first, then CSC_TAR
                if tar tf "$AP_TAR" "$partition_file_in_tar" &>/dev/null; then
                    tar xf "$AP_TAR" "$partition_file_in_tar"
                elif tar tf "$CSC_TAR" "$partition_file_in_tar" &>/dev/null; then
                    tar xf "$CSC_TAR" "$partition_file_in_tar"
                else
                    echo "Warning: Could not find $partition_file_in_tar in AP/CSC TARs. Skipping."
                    continue # Skip to the next partition if not found
                fi

                # Handle decompression/renaming to .sparse for simg2img
                if $lz4_compressed; then
                    lz4 -d -q --rm "$partition_file_in_tar" "${partition}.img.sparse"
                else
                    # If not lz4_compressed (exynos7420), rename the extracted .img to .img.sparse
                    mv "$partition_file_in_tar" "${partition}.img.sparse"
                fi
                simg2img "${partition}.img.sparse" "${partition}.img" && rm "${partition}.img.sparse"
            done
        fi

        [ -d "tmp_out" ] && mountpoint -q "tmp_out" && sudo umount "tmp_out"
        mkdir -p "tmp_out"
        for img in *.img
        do
            local PREFIX=""
            local PARTITION="${img%.img}"

            if [[ $img == *_a.img ]]; then
                PARTITION=${img%_a.img}
            elif [[ $img == *_b.img ]]; then
                rm -f "$img"
                continue
            else
                PARTITION="${img%.img}"
            fi

            case "$(GET_IMG_FS_TYPE "$img")" in
                "erofs")
                    echo "Extracting $img"
                    PREFIX=""
                    [ -d "$PARTITION" ] && rm -rf "$PARTITION"
                    mkdir -p "$PARTITION"
                    fuse.erofs "$img" "tmp_out" &>/dev/null
                    cp -a --preserve=all tmp_out/* "$PARTITION"
                    ;;
                "f2fs" | "ext4")
                    echo "Extracting $img"
                    PREFIX="sudo"
                    [ -d "$PARTITION" ] && rm -rf "$PARTITION"
                    mkdir -p "$PARTITION"
                    $PREFIX mount -o ro "$img" "tmp_out"
                    $PREFIX cp -a --preserve=all tmp_out/* "$PARTITION"
                    $PREFIX chown -hR "$(whoami)" "$PARTITION"
                    [[ -e "$PARTITION/lost+found" ]] && rm -rf "$PARTITION/lost+found"
                    ;;
                *)
                    continue
                    ;;
            esac

            echo "Generating fs_config/file_context for $img"
            [ -f "file_context-$PARTITION" ] && rm "file_context-$PARTITION"
            [ -f "fs_config-$PARTITION" ] && rm "fs_config-$PARTITION"
            while read -r i; do
                {
                    echo -n "$i "
                    $PREFIX getfattr -n security.selinux --only-values -h "$i"
                    echo ""
                } >> "file_context-$PARTITION"

                case "$i" in
                    *"run-as" | *"simpleperf_app_runner")
                        CAPABILITIES="0xc0"
                        ;;
                    *)
                        CAPABILITIES="0x0"
                        ;;
                esac
                $PREFIX stat -c "%n %u %g %a capabilities=$CAPABILITIES" "$i" >> "fs_config-$PARTITION"
            done <<< "$($PREFIX find "tmp_out")"
            if [ "$PARTITION" = "system" ]; then
                sed -i "s/tmp_out /\/ /g" "file_context-$PARTITION" \
                    && sed -i "s/tmp_out\//\//g" "file_context-$PARTITION"
                sed -i "s/tmp_out / /g" "fs_config-$PARTITION" \
                    && sed -i "s/tmp_out\///g" "fs_config-$PARTITION"
            else
                sed -i "s/tmp_out/\/$PARTITION/g" "file_context-$PARTITION"
                sed -i "s/tmp_out / /g" "fs_config-$PARTITION" \
                    && sed -i "s/tmp_out/$PARTITION/g" "fs_config-$PARTITION"
            fi
            sed -i "s/\x0//g" "file_context-$PARTITION" \
                && sed -i 's/\./\\./g' "file_context-$PARTITION" \
                && sed -i 's/\+/\\+/g' "file_context-$PARTITION" \
                && sed -i 's/\[/\\[/g' "file_context-$PARTITION"

            $PREFIX umount "tmp_out"
            rm "$img"
        done

        rm -r "tmp_out"
    fi

    cd "$PDR"
}

EXTRACT_AVB_BINARIES()
{
    local PDR
    PDR="$(pwd)"

    # --- MODIFICATION START ---
    # If TARGET_PLATFORM is "exynos7420", skip AVB binaries extraction entirely.
    if [[ "$TARGET_PLATFORM" == "exynos7420" ]]; then
        echo "TARGET_PLATFORM is exynos7420. Skipping AVB binaries extraction (no vbmeta)."
        cd "$PDR" # Ensure we return to the original directory
        return 0 # Exit the function successfully
    fi
    # --- MODIFICATION END ---

    local lz4_compressed=true
    if [[ "$TARGET_PLATFORM" == "exynos7420" ]]; then
        lz4_compressed=false
    fi

    echo "- Extracting AVB binaries..."
    cd "$FW_DIR/${MODEL}_${REGION}"
    
    local vbmeta_file_in_tar="vbmeta.img"
    if $lz4_compressed; then
        vbmeta_file_in_tar="vbmeta.img.lz4"
    fi

    if [ ! -f "vbmeta.img" ] && tar tf "$BL_TAR" "$vbmeta_file_in_tar" &>/dev/null; then
        echo "Extracting vbmeta.img"
        tar xf "$BL_TAR" "$vbmeta_file_in_tar"
        
        # Only perform lz4 decompression if it was an lz4 compressed file.
        # If not lz4_compressed (exynos7420), tar extracted it as vbmeta.img already,
        # so no further action is needed.
        if $lz4_compressed; then
            lz4 -d -q --rm "$vbmeta_file_in_tar" "vbmeta.img"
        fi
    fi

    if [ ! -f "vbmeta_patched.img" ]; then
        echo "Generating vbmeta_patched.img"
        cp --preserve=all "vbmeta.img" "vbmeta_patched.img"
        printf "\x03" | dd of="vbmeta_patched.img" bs=1 seek=123 count=1 conv=notrunc &> /dev/null
    fi

    cd "$PDR"
}

EXTRACT_ALL()
{
    BL_TAR=$(find "$ODIN_DIR/${MODEL}_${REGION}" -name "BL*")
    AP_TAR=$(find "$ODIN_DIR/${MODEL}_${REGION}" -name "AP*")
    CSC_TAR=$(find "$ODIN_DIR/${MODEL}_${REGION}" -name "CSC*")

    mkdir -p "$FW_DIR/${MODEL}_${REGION}"
    EXTRACT_KERNEL_BINARIES
    EXTRACT_OS_PARTITIONS
    EXTRACT_AVB_BINARIES

    cp --preserve=all "$ODIN_DIR/${MODEL}_${REGION}/.downloaded" "$FW_DIR/${MODEL}_${REGION}/.extracted"

    echo ""
}

FIRMWARES=( "$SOURCE_FIRMWARE" "$TARGET_FIRMWARE" )
IFS=':' read -a SOURCE_EXTRA_FIRMWARES <<< "$SOURCE_EXTRA_FIRMWARES"
if [ "${#SOURCE_EXTRA_FIRMWARES[@]}" -ge 1 ]; then
    for i in "${SOURCE_EXTRA_FIRMWARES[@]}"
    do
        FIRMWARES+=( "$i" )
    done
fi
IFS=':' read -a TARGET_EXTRA_FIRMWARES <<< "$TARGET_EXTRA_FIRMWARES"
if [ "${#TARGET_EXTRA_FIRMWARES[@]}" -ge 1 ]; then
    for i in "${TARGET_EXTRA_FIRMWARES[@]}"
    do
        FIRMWARES+=( "$i" )
    done
fi
# ]

FORCE=false

while [ "$#" != 0 ]; do
    case "$1" in
        "-f" | "--force")
            FORCE=true
            ;;
        *)
            echo "Usage: extract_fw [options]"
            echo " -f, --force : Force firmware extraction"
            exit 1
            ;;
    esac

    shift
done

mkdir -p "$FW_DIR"

for i in "${FIRMWARES[@]}"
do
    MODEL=$(echo -n "$i" | cut -d "/" -f 1)
    REGION=$(echo -n "$i" | cut -d "/" -f 2)

    if [ -f "$FW_DIR/${MODEL}_${REGION}/.extracted" ]; then
        [ -z "$(GET_LATEST_FIRMWARE)" ] && continue
        if [ -f "$ODIN_DIR/${MODEL}_${REGION}/.downloaded" ] && \
            [[ "$(cat "$ODIN_DIR/${MODEL}_${REGION}/.downloaded")" != "$(cat "$FW_DIR/${MODEL}_${REGION}/.extracted")" ]]; then
            if $FORCE; then
                echo "- Updating $MODEL firmware with $REGION CSC..."
                rm -rf "$FW_DIR/${MODEL}_${REGION}" && EXTRACT_ALL
            else
                echo    "- $MODEL firmware with $REGION CSC is already extracted."
                echo    "  A newer version of this device's firmware is available."
                echo -e "  To extract, clean your extracted firmwares directory or run this cmd with \"--force\"\n"
                continue
            fi
        elif [[ "$(GET_LATEST_FIRMWARE)" != "$(cat "$FW_DIR/${MODEL}_${REGION}/.extracted")" ]]; then
            echo    "- $MODEL firmware with $REGION CSC is already extracted."
            echo    "  A newer version of this device's firmware is available."
            echo -e "  Please download the firmware using the \"download_fw\" cmd\n"
            continue
        else
            echo -e "- $MODEL firmware with $REGION CSC is already extracted. Skipping...\n"
            continue
        fi
    elif [ -f "$ODIN_DIR/${MODEL}_${REGION}/.downloaded" ]; then
        echo -e "- Extracting $MODEL firmware with $REGION CSC...\n"
        EXTRACT_ALL
        if [ -n "$GITHUB_ACTIONS" ]; then
            rm -rf "$ODIN_DIR/${MODEL}_${REGION}"
        fi
    else
        echo    "- $MODEL firmware with $REGION CSC is not downloaded."
        echo -e "  Please download the firmware first using the \"download_fw\" cmd\n"
        exit 1
    fi
done

exit 0
