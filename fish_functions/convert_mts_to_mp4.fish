function convert_mts_to_mp4
    set -l output_name (path change-extension mp4 $argv[1])
    ffmpeg -i $argv[1] -c:v copy -c:a aac -strict experimental -b:a 128k "$output_name"
end