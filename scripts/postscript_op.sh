#!/bin/bash

## Script which modify ${output_file} (like index.html.xlf) to covert into original format (like HTML)
## Run by:
## ```bash ../../scripts/postscript_op.sh [line number]```
## ** Check line number seeing tikal's or patch command's error message
## In case that patch command issue HUNK # error, check HUNK number and line number with:
## ``` grep -E -v "^[><-]" jp_part.patch |less -N ```


# 引数の確認
if [ $# -ne 2 ]; then
  echo "引数が2つではありません。使用方法: postscript_op.sh ファイル名 行番号"
  exit 1
fi

# ファイル名の確認
filename=$1
if [ ! -f "$filename" ]; then
  echo "ファイルが存在しません: $filename"
  exit 1
fi

# 行番号の確認
lineno=$2
if [[ ! $lineno =~ ^[0-9]+$ ]]; then
  echo "行番号が不正です。4桁までの整数を入力してください。"
  exit 1
fi

# 行内容の表示と確認
target_line=$(sed -n "${lineno}p" $filename)
echo "修正対象の行: $target_line"
echo "この行を修正しますか？ (y/n):"
read answer

# 削除処理
if [ $answer = "y" ]; then
  # <g id="1"> と</g> と謎の「メンバー」の修正案を提示
  modified_line=$(echo "$target_line" | sed -E 's/<g id=\"[0-9]{,3}\">//g' | sed -E 's/<\/g>//g'|sed -E 's/メンバー//g')
  
  echo "修正後の行: $modified_line"

  # 削除確認
  echo "この変更を保存しますか？ (y/n):"
  read confirm

  if [ $confirm = "y" ]; then
    # ファイルを修正
    #sed -i -E "${lineno}s/$target_line/$modified_line/g" $filename
    sed -i -E "${lineno}s/<g id=\"[0-9]{,3}\">//g" $filename > /dev/null
    sed -i -E "${lineno}s/<\/g>//g" $filename > /dev/null
    sed -i -E "${lineno}s/メンバー//g" $filename > /dev/null
    sed -n ${lineno}p $filename

    echo "修正完了しました。"
  else
    echo "修正を中止しました。"
  fi
else
  echo "修正を中止しました。"
fi