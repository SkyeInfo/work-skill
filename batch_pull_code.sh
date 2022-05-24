#!/bin/bash

# 将work-skill软链到项目代码同级目录位置

projectPath=$(dirname "$0")
cd $projectPath/..

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

