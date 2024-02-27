#!/bin/bash

main_folder="../website/data"

# Function to compress and generate HTML links
compress_and_generate_links() {
    local folder="$1"
    local compressed_folder="$folder/compressed"
    mkdir -p "$compressed_folder"

    declare -a text_files
    declare -a picture_files
    declare -a video_files
    declare -a audio_files
    declare -a other_files

    for file in "$folder"/*; do
        if [ -f "$file" ]; then
            case "$file" in
                *.txt|*.md|*.sh|*.html)
                    text_files+=("$file")
                    ;;
                *.jpeg | *.jpg|*.png|*.gif|*.heic)
                    picture_files+=("$file")
                    ;;
                *.mp4|*.mov|*.mkv|*.avi)
                    video_files+=("$file")
                    ;;
                *.mp3|*.wav|*.flac|*.aiff)
                    audio_files+=("$file")
                    ;;
                *index.html)  # Exclude index.html files TODO spiegalo poi
                    continue
                    ;;
                *)
                    other_files+=("$file")
                    ;;
            esac
        fi
    done


    # Add links to subfolders with their names displayed
    subfolders=()
    for subfolder in "$folder"/*; do
        if [ -d "$subfolder" ] && [ ! "$(basename "$subfolder")" == "compressed" ]; then
            subfolder_name=$(basename "$subfolder")
        fi
    done



    # Compress and display picture files in the subfolder
    if [ ${#picture_files[@]} -gt 0 ]; then
        for picture_file in "${picture_files[@]}"; do
            compressed_file="$compressed_folder/$(basename "$picture_file")_compressed.jpg"
            if [ ! -f "$compressed_file" ]; then
                convert "$picture_file" -resize 30% "$compressed_file"
            fi
        done
    fi

    # Compress and display video files in the subfolder
    if [ ${#video_files[@]} -gt 0 ]; then
        for video_file in "${video_files[@]}"; do
            compressed_file="$compressed_folder/$(basename "$video_file")_compressed.mp4"
            if [ ! -f "$compressed_file" ]; then
                ffmpeg -i "$video_file" -vf "scale=640:480" -c:v libx264 -crf 23 -c:a aac -strict experimental "$compressed_file" -y
            fi
        done
    fi

    # Compress and display audio files in the subfolder
    if [ ${#audio_files[@]} -gt 0 ]; then
        for audio_file in "${audio_files[@]}"; do
            compressed_file="$compressed_folder/$(basename "$audio_file")_compressed.mp3"
            if [ ! -f "$compressed_file" ]; then
                ffmpeg -i "$audio_file" -b:a 96k "$compressed_file" -y
            fi
        done
    fi

}

# Function to iterate through all subfolders excluding "compressed"
function iterate_subfolders() {
    local folder="$1"

    # Loop through each item in the folder
    for item in "$folder"/*; do
        # Check if the item is a directory
        if [ -d "$item" ]  && [ ! "$(basename "$item")" == "compressed" ]  && [ ! "$(basename "$item")" == "*" ]; then
            compress_and_generate_links "$item"
            iterate_subfolders "$item"
            echo "$item"
        fi
    done
}



# Start iterating from the main folder
iterate_subfolders $main_folder

echo "HTML files created for each subfolder."




# stuff:

# imagemagick got different implementations called "delegates":
# "Delegates (built-in): bzlib fontconfig freetype gslib heic jng jp2 jpeg jxl lcms lqr ltdl lzma openexr png ps raw tiff webp xml zlib"
# you can configure it through a file called delegates.xml