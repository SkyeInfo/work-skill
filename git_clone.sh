#!/bin/bash
## 两个目录 ~/code/ 和 ~/soyoung-go/
for dir in ~/code/ ~/soyoung-go/
do
    cd $dir
    for dir in $(ls -d */)
    do
    cd $dir
    if [ -d ".git" ]; then
        # 获取远程仓库地址
        remote=$(git remote -v | grep fetch | awk '{print $2}')
        echo "git clone $remote"
    fi
    cd ..
    done
echo "---------------------------"
done