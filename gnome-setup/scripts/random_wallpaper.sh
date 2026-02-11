#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/SEZ/WALLPAPERS"

# Image extensions to search for
IMAGE_EXTENSIONS="jpg jpeg png bmp gif webp"

# Interval (in seconds)
INTERVAL=600

# Ensure wallpaper dir exists
if [ ! -d "$WALLPAPER_DIR" ]; then
	echo "ERROR: Wallpaper directory does not exist: $WALLPAPER_DIR"
	exit 1
fi

# Find all valid image files (ignore Apple `._` junk)
get_wallpapers() {
	local wallpapers=()
	for ext in $IMAGE_EXTENSIONS; do
		while IFS= read -r -d '' file; do
			[[ "$(basename "$file")" =~ ^\._ ]] && continue
			wallpapers+=("$file")
		done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f -iname "*.${ext}" -print0 2>/dev/null)
	done
	echo "${wallpapers[@]}"
}

# Set wallpaper for GNOME (Wayland compatible)
set_wallpaper() {
	local file_path="$1"
	local uri="file://$file_path"

	if ! command -v gsettings &>/dev/null; then
		echo "ERROR: gsettings not found"
		return 1
	fi

	gsettings set org.gnome.desktop.background picture-uri "$uri" || {
		echo "ERROR: Failed to set picture-uri"
		return 1
	}

	gsettings set org.gnome.desktop.background picture-uri-dark "$uri" 2>/dev/null || {
		echo "NOTE: picture-uri-dark not set (possibly not supported)"
	}

	echo "✔ Wallpaper set: $(basename "$file_path")"
	return 0
}

# Pick a random wallpaper from list
pick_random_wallpaper() {
	local files=("$@")
	local total=${#files[@]}
	if [ "$total" -eq 0 ]; then
		echo "ERROR: No wallpapers found in $WALLPAPER_DIR"
		exit 1
	fi
	local index=$((RANDOM % total))
	echo "${files[$index]}"
}

# Main loop
echo " Wallpaper changer started (every $((INTERVAL / 60)) min)"
echo " Directory: $WALLPAPER_DIR"
echo " Desktop: $XDG_CURRENT_DESKTOP | Session: $XDG_SESSION_TYPE"
echo

all_wallpapers=($(get_wallpapers))

while true; do
	echo "----------------------------------------"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - Changing wallpaper..."

	selected=$(pick_random_wallpaper "${all_wallpapers[@]}")
	set_wallpaper "$selected" || echo "⚠ Failed to apply wallpaper"

	echo "$(date '+%Y-%m-%d %H:%M:%S') - Waiting $((INTERVAL / 60)) minutes..."
	sleep "$INTERVAL"
done
