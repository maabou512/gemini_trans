#Python 3.11.0(pyenv + venv)

# Machine Translation using Gemini API 
# This script is invoked by gemini_trans_1.sh automatically

# Steps ( [x] : This script's scope)  
## [ ] 1. Convert original file (such as HTML) into XLIFF(.xlf) using **Tikal** 
## [ ] 2. Extract JP part which will be translated by Gemini
## [ ] 3. Make patch file for 1 and 2 
## [x] 4. Translate with Python script 
## [ ] 5. Compare line counts pre-translated file and post-translated file
## [ ] 6. Apply reverse patch file made in step 3 to merge translated JP parts into XLIFF

#Note: step 1-3 is done in previous process (gemini_trans_1.sh) 　


import google.generativeai as genai
import sys
import time


# 翻訳ファイル

# API キーを設定
API_KEY = "YOUR API KEY"
genai.configure(api_key=API_KEY)

##　入力ファイル名と出力ファイル名をチェック

## --------------------------------------------------
# Check if the first argument is provided
if len(sys.argv) < 2:
    print("Error: Please provide the first argument (filename1).")
    sys.exit(1)

# Check if the second argument is provided
if len(sys.argv) < 3:
    print("Error: Please provide the second argument (filename2).")
    sys.exit(1)

# Set the first argument to the variable f_name1
f_name1 = sys.argv[1]

# Set the second argument to the variable f_name2
f_name2 = sys.argv[2]
## --------------------------------------------------


# プロンプト準備

prompt = """
### 指示
あなたはITおよびOSS（オープンソースソフトウェア）の専門家です。次の文章を日本語に翻訳してください
* 翻訳にあたってはタグ間だけを翻訳してください
* タグの中は絶対に翻訳しないでください
* 入力ファイルのタグも併せて出力してください
* タグ間に文字列が何もない場合は空文字を出力してください
* 改行を入れてください
* ですます調で翻訳してください
* 翻訳にあたってはそれ以前に翻訳した用語を踏襲するようにしてください
### 注意
* <target xml:lang="ja"> や<g id="1">や<g id="2">タグの中は翻訳しない
* 英語→```<target xml:lang="en"><g id="1">Members</g></target>```、 翻訳後日本語→```<target xml:lang="ja"><g id="1">メンバー</g></target>```
### 入力
"""

# モデルをインスタンス化
model = genai.GenerativeModel("gemini-1.5-pro-latest")

# メイン処理
def main():
    # 入力ファイルと出力ファイルのパスを設定
    input_file_path  = f_name1
    output_file_path = f_name2

    # 入力ファイルを開く
    with open(input_file_path, "r", encoding="utf-8") as input_file:
        # 出力ファイルを開く
        with open(output_file_path, "w", encoding="utf-8") as output_file:
            # 一行ずつ処理
            for line in input_file:
                # 各行を加工
                result = generate_content(prompt,line)
                print(result)
                # 加工結果を書き込む
                output_file.write(result)
                time.sleep(30)

# 各行での翻訳処理
def generate_content(prompt,line):
    request=prompt + line
    response = model.generate_content(request)
    return response.text
    #print(response.text)

if __name__ == "__main__":
    main()


