#!/usr/bin/env python3
import sys
from PIL import Image

if len(sys.argv) != 4:
    print("Usage: lpm_patch.py <orig_img> <center_img> <output_img>")
    sys.exit(1)

orig_lpm_path = sys.argv[1]
oneui7_center_lpm_path = sys.argv[2]
output_lpm_path = sys.argv[3]

# Open original
orig = Image.open(orig_lpm_path)

# Dimensions
width, height = orig.size

# DPI
dpi = orig.info.get("dpi")[0]

# Bit depth
bits_per_channel = 8
channels = len(orig.getbands())
color_depth = bits_per_channel * channels

print(f"Original lpm.jpg: Width: {width}, Height: {height}, DPI: {dpi}, Color depth: {color_depth}")

# Create black background with same size
bg = Image.new("RGB", (width, height), (0, 0, 0))

center = Image.open(oneui7_center_lpm_path)

# Compute position for centering
cx = (width - center.width) // 2
cy = (height - center.height) // 2

# Paste with alpha support
bg.paste(center, (cx, cy), center.convert("RGBA"))

# Save result with original DPI
bg.save(output_lpm_path, dpi=(dpi, dpi), quality=95)

print(f"Saved patched image: {output_lpm_path}")