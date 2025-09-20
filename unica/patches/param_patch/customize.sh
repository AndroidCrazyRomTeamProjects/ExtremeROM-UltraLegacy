if [[ $TARGET_SINGLE_SYSTEM_IMAGE == "essi" || $TARGET_SINGLE_SYSTEM_IMAGE == "essi_64" ]]; then
    echo 'Exynos target detected, applying param patch...'

    EXTRACT_PARAM() {
        MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f1)
        REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f2)
        BL_TAR=$(find "$ODIN_DIR/${MODEL}_${REGION}" -name "BL*" | head -n1)
        
        if [[ -z "$BL_TAR" ]]; then
            echo "ERROR: BL firmware not found for ${MODEL}_${REGION}"
            echo "Skipping param Patch"
        fi

        UNPACK_DIR="$FW_DIR/${MODEL}_${REGION}"

        # Check for param files
        if [[ ! -f "$UNPACK_DIR/up_param.bin" && ! -f "$UNPACK_DIR/param.bin" ]]; then
            # Auto-detect which .lz4 file exists in the tar
            LZ4_FILE=$(tar -tf "$BL_TAR" | grep -E '^(up_param|param)\.bin\.lz4$' | head -n1)

            if [[ -z "$LZ4_FILE" ]]; then
                echo "ERROR: No param file found inside $BL_TAR"
                exit 1
            fi

            tar -xf "$BL_TAR" -C "$UNPACK_DIR" "$LZ4_FILE"

            # Determine output name
            if [[ "$LZ4_FILE" == "up_param.bin.lz4" ]]; then
                PARAM_BIN="$UNPACK_DIR/up_param.bin"
                PARAM_NAME="up_param"
            else
                PARAM_BIN="$UNPACK_DIR/param.bin"
                PARAM_NAME="param"
            fi

            lz4 -d "$UNPACK_DIR/$LZ4_FILE" "$PARAM_BIN"
            rm -f "$UNPACK_DIR/$LZ4_FILE"
        elif [[ -f "$UNPACK_DIR/up_param.bin" ]]; then
            PARAM_BIN="$UNPACK_DIR/up_param.bin"
            PARAM_NAME="up_param"
        else
            PARAM_BIN="$UNPACK_DIR/param.bin"
            PARAM_NAME="param"
        fi
    }
    # Only apply patch if the target model matches the target firmware for safty reson
    if [[ " ${TARGET_ASSERT_MODEL[@]} " =~ " ${MODEL} " ]]; then
    EXTRACT_PARAM

    mkdir -p "$WORK_DIR/$PARAM_NAME"
    tar -xf "$PARAM_BIN" -C "$WORK_DIR/$PARAM_NAME"

    # Remove Unlock Bootloader Warning
    rm -f "$WORK_DIR/$PARAM_NAME/svb_orange.jpg"
    rm -f "$WORK_DIR/$PARAM_NAME/booting_warning.jpg"

    # Create a new lpm image
    orig_lpm="$WORK_DIR/$PARAM_NAME/lpm.jpg"

    if ${TARGET_HAS_QHD_DISPLAY}; then
        one_ui_7_lpm="$SRC_DIR/unica/patches/param_patch/images/lpm-qhd.jpg"
    else
        one_ui_7_lpm="$SRC_DIR/unica/patches/param_patch/images/lpm-fhd.jpg"
    fi
    output_lpm="$WORK_DIR/$PARAM_NAME/lpm.jpg"

    if [[ ! -f "$orig_lpm" ]]; then
        echo "ERROR: Original lpm.jpg not found at $orig_lpm"
        exit 1
    fi

    chmod 644 "$WORK_DIR/$PARAM_NAME/"* #make writable first

    python3 "$SRC_DIR/unica/patches/param_patch/lpm_patch.py" "$orig_lpm" "$one_ui_7_lpm" "$output_lpm"

    # Clean up
    rm -f "$WORK_DIR/$PARAM_NAME/lpm_bg.jpg"

    # Set permissions
    chmod 444 "$WORK_DIR/$PARAM_NAME/"*

    echo "Param patch applied successfully."
    else {
        echo "Target model ${TARGET_ASSERT_MODEL[@]} does not match firmware model $MODEL, skipping param patch"
    }
fi
else
    echo 'Non-Exynos target detected, skipping param patch...'
fi