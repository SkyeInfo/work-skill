#!/bin/bash

# 指定目录
directory="/Users/yangshengkai/Music/婚礼循环音乐"

# 遍历目录中的文件
for file in "$directory"/*; do
    # 获取文件名
    filename=$(basename "$file")

    # 去掉后缀
    filename_without_extension="${filename%.*}"

    ffmpeg -i $file -acodec libmp3lame -b:a 320k -q:a 9 /Users/yangshengkai/Music/婚礼循环音乐mp3/$filename_without_extension.mp3
done