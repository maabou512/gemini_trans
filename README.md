# Machine Translation using Gemini API  
* End to End translation using Okapi Tikal, Gemini.
* Multi file format such as IDML, HTML, etc. 
* Not only efficiency, aim to ensure "quality" of translation much more than NMT. 
* "Collaboration with GenAI" , focusing on prompt engineering.

## Configurations:
```./scripts/settings.conf``` includes following static variables:
* PYTHONPATH="path/to/venv/lib/python3.11/site-packages/"
* tikal_path="path/to/tikal" 
* java_path=`which java`
* python_path=`which python3`
* script_path="./scripts" 

## files processing in PJ directory are following (automatically assigined) 
original_file: "input"${1}" (input.html incase of html)
patch_file="jp_part.patch"
pre_trans_file="pre_jp_only_${original_file}.xlf"
post_trans_file="post_jp_only_${original_file}.xlf"
output_file=${original_file}.xlf

## final output
* ```output``` directory in the PJ directory
* filename is same as orignal file(input.html in case of html)

## Processsing steps
1. Convert original file (such as HTML) into XLIFF(.xlf) using **Tikal** 
2. Extract JP part which will be translated by Gemini
3. Make patch file for 1 and 2 <br>
4. Translate with Python script <br>
---> 1-4: **[gemini_trans_1.sh](./gemini_trans_1.sh)** :You need arg1 as file extention(e.g."html") <br>
(4: executed by **[gemini_trans.py](./gemini_trans.py)**)
5. Compare line counts pre-translated file and post-translated file
6. Apply reverse patch file made in step 3 to merge translated JP parts into XLIFF
--> 5-6: **[gemini_trans_2.sh](./gemini_trans_2.sh)**<br>
(maybe you need text processing by **[post_processing.sh](./post_processing.sh))
7. Create final, translated file(such as HTML) <br>
--> 7: **[gemini_trans_3.sh](./gemini_trans_3.sh)**

## My environment
* Ubuntu 22.04LTS 
* Python 3.11.0 (pyenv+venv)
* Google Gemini Pro 1.5 (**API Key required**)
* VSCode with extensions
* JAVA  
```bash
$java --version
java 17.0.10 2024-01-16 LTS
Java(TM) SE Runtime Environment (build 17.0.10+11-LTS-240)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.10+11-LTS-240, mixed mode, sharing)
```