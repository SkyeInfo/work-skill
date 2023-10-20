#!/bin/bash

# 指定目录
directory="/Users/yangshengkai/pic-handle/精修"

# 遍历目录中的文件
for file in "$directory"/*; do
    # 获取文件名
    filename=$(basename "$file")

    # 去掉后缀
    filename_without_extension="${filename%.*}"

    convert /Users/yangshengkai/pic-handle/精修/$filename_without_extension.jpg -quality 80 /Users/yangshengkai/pic-handle/img1/$filename_without_extension.jpg
done