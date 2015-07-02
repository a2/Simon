#!/usr/bin/env bash

hash convert &>/dev/null
if [ $? -eq 1 ]; then
  echo >&2 "convert not found. To install imagemagick, run:"
  echo >&2 "$ brew install imagemagick"
  exit 1
fi

OUTPUT_DIR="$(dirname $0)/../Simon WatchKit App/Assets.xcassets"

NUM_SIZES=3
SIZE_NAMES=(small large unspecified)
SIZE_PIXELS=(132 152 152)

NUM_TILES=4
TILE_NAMES=(Red Yellow Green Blue)
TILE_COLORS=('#FF6961' '#FDFD96' '#77DD77' '#779ECB')
TILE_CIRCLE_OFFSETS=(1211 2122 2221 1112)

FOLDER_JSON=$(cat <<EOF
{
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}

EOF)

IMAGESET_JSON=$(cat <<EOF
{
  "images" : [
    {
      "idiom" : "watch",
      "scale" : "2x",
      "filename" : "unspecified.png"
    },
    {
      "idiom" : "watch",
      "screenWidth" : "{130,145}",
      "filename" : "small.png",
      "scale" : "2x"
    },
    {
      "idiom" : "watch",
      "screenWidth" : "{146,165}",
      "filename" : "large.png",
      "scale" : "2x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}

EOF)

for ((i=0; i<$NUM_TILES; i++)); do
    tile_name=${TILE_NAMES[$i]}
    tile_color=${TILE_COLORS[$i]}

    folder_dir="$OUTPUT_DIR/$tile_name"
    mkdir -p "$folder_dir"
    echo "$FOLDER_JSON" > "$folder_dir/Contents.json"

    base_imageset_dir="$folder_dir/${tile_name}11.imageset"
    mkdir -p "$base_imageset_dir"
    echo "$IMAGESET_JSON" > "$base_imageset_dir/Contents.json"

    for ((j=0; j<$NUM_SIZES; j++)); do
        size_name=${SIZE_NAMES[$j]}
        size_pixels=${SIZE_PIXELS[$j]}

        offset=$((${TILE_CIRCLE_OFFSETS[$i]}))

        circle_x=$(($size_pixels * ($offset / 1000 - 1)))
        circle_y=$(($size_pixels * (($offset / 100) % 10 - 1)))

        circle_x2=$((($size_pixels - 1) * (($offset / 10) % 10 - 1)))
        circle_y2=$((($size_pixels - 1) * ($offset % 10 - 1)))

        base="$base_imageset_dir/${size_name}.png"
        convert -size ${size_pixels}x${size_pixels} xc:none -fill $tile_color -draw "circle $circle_x,$circle_y $circle_x2,$circle_y2" "$base"

        for k in $(seq 10 1); do
            imageset_dir="${folder_dir}/${tile_name}${k}.imageset"
            mkdir -p "$imageset_dir"
            echo "$IMAGESET_JSON" > "$imageset_dir/Contents.json"

            output="$imageset_dir/${size_name}.png"
            highlight=$((100 - 10 * ($k - 1)))
            convert "$base" -fill white -colorize ${highlight}% "$output"
        done
    done
done

exit 0