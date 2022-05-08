#!/bin/bash

# 将work-skill放在项目代码同级目录位置

cd ..

for dir in `ls`;
do
  if [ -d $dir ];then
    if [ $dir == "work-skill" ];then
      continue
    fi

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

