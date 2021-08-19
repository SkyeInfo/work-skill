#!/bin/bash

for dir in `ls`;
do
  if [ -d $dir ];then
    cd $dir
    git pull;
    echo "$dir 更新完毕！"
    echo "===================================="
    cd ..
  else
    echo "$dir 此文件不是目录"
    echo "===================================="
  fi
done

