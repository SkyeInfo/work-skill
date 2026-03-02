#!/bin/bash

# 将work-skill软链到项目代码同级目录位置

currentProjectPath="/Users/yangshengkai/soyoung-code/go/src/work-skill/"
projectPath="/Users/yangshengkai/soyoung-code/go/src/"

#currentProjectPath="/Users/yangshengkai/soyoung-code/php/work-skill/"
#projectPath="/Users/yangshengkai/soyoung-code/php/"


exportFileName="fans"

func="tb_user_fans_"

# 定义一个函数用于搜索指定的function在目录中的使用情况
search_functions() {
	results=()

	local function_name="$1"
	local directory="$2"

	fullPath=$projectPath$directory

	if ! [ -d "$fullPath" ]; then
		return
	fi
	# 使用grep命令进行完全匹配搜索
	output=$(grep -rin -e "$function_name" "$fullPath")
	if [ -z "$output" ]; then
		return
	else
		IFS=$'\n' read -rd '' -a output_array <<< "$output"
		results+=("${output_array[@]}")
	fi

	for result in "${results[@]}"; do
		IFS=':'
		read -ra fields <<< "$result"
		# 输出分隔后的字段
		allField=""
		for field in "${fields[@]}"; do
			trimmed_field="${field#"${field%%[![:space:]]*}"}"
			trimmed_field="${trimmed_field%"${field##*[![:space:]]}"}"
			allField="$allField$trimmed_field|"
		done

		echo "$function_name|$directory|$allField" >> "$(dirname "$0")/$exportFileName.txt"

		# 恢复IFS为默认值（空格、制表符、换行符）
		IFS=' '
	done
}

cd "$currentProjectPath"/.. || return
for dir in *; do
	if [ -d "$dir" ]; then
		if  [ "$dir" == "work-skill" ]; then
			continue
		fi

		echo "$dir"

		search_functions  "$func" "$dir"

	else
		echo     "$dir 此文件不是目录"
		echo  "===================================="
	fi
done

echo "done"
