#!/bin/bash

# 输入文件路径
input_file="vtk-libs.txt"

# 输出文件名
output_debug="vtk-libs-debug.txt"
output_release="vtk-libs-release.txt"

# 清空输出文件
> "$output_debug"
> "$output_release"

# 读取输入文件，逐行处理
while IFS= read -r line; do
    # 检查文件名中是否包含 "gd" 字符串
    if [[ $line == *gd* ]]; then
        # 包含 "gd" 字符串，是 debug 版本，保存到 debug 文件中
        echo "$line" >> "$output_debug"
    else
        # 不包含 "gd" 字符串，是 release 版本，保存到 release 文件中
        echo "$line" >> "$output_release"
    fi
done < "$input_file"

echo "Debug 版本的库名称保存在 $output_debug"
echo "Release 版本的库名称保存在 $output_release"

