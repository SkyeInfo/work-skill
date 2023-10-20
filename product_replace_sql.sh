#!/bin/bash

# 将work-skill软链到项目代码同级目录位置

#projectPath="/Users/yangshengkai/soyoung-code/php/"
projectPath="/Users/yangshengkai/soyoung-code/go/src/"

funcList=("getProductInfo" "getProductInfos" "getProductInfosByEs" "getProductSimpleInfo" "getProductsInfoFromEs" "getFeedSaleProductList" "getPostContentProductCard")
exportFileName="not_need_replace"

rpcDirList=("admin.soyoung.com" "api.soyoung.com" "b.soyoung.com" "base" "m.soyoung.com" "rpc_communitylogic" "rpc_doctor" "rpc_go_acn" "rpc_go_activity" "rpc_go_brand" "rpc_go_index" "rpc_go_useroperation" "rpc_item" "rpc_mentor" "rpc_mose" "rpc_postcalendar" "rpc_privatedomain" "rpc_solution" "synewod.xinyangwang.net" "www.soyoung.com" "wxapi.soyoung.com")

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
	output=$(grep -riwn -e "$function_name" "$fullPath")
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

# 循环遍历function数组和目录数组，并调用search_functions函数进行搜索
for func in "${funcList[@]}"; do
	for directory in "${rpcDirList[@]}"; do
		search_functions "$func" "$directory"
	done
done

echo "done"
