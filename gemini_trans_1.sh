#!/bin/bash

# Machine Translation using Gemini API 
# Command: 
# bash ../scripts/gemini_trans_1.sh [arg1]
# arg1: original file to be translated  

# Steps ( [x] : This script's scope)  
## [x] 1. Convert original file (such as HTML) into XLIFF(.xlf) using **Tikal** 
## [x] 2. Extract JP part which will be translated by Gemini
## [x] 3. Make patch file for 1 and 2 
## [ ] 4. Translate with Python script 
## [ ] 5. Compare line counts pre-translated file and post-translated file
## [ ] 6. Apply reverse patch file made in step 3 to merge translated JP parts into XLIFF

# Input file check 
# --------------------------------------------
## Check if the first argument is provided
if [ $# -eq 0 ]; then
  echo "Error: Please provide the first argument."
  exit 1
fi

## Check if there are more than one arguments
if [ $# -gt 1 ]; then
  echo "Error: More than one argument is provided."
  exit 1
fi

## Check if the file exists
if [ ! -f "$1" ]; then
  echo "Error: File $1 does not exist."
  exit 1
fi

## Set the first argument to the variable original_file
original_file="$1"


# Other variables

export PYTHONPATH=/home/tani/Gemini/gem_venv/lib/python3.11/site-packages/
tikal_path="/home/tani/translation/okapi-apps_gtk2-linux-x86_64_0.37/lib" 
java_path=`which java`
python_path=`which python3`
script_path="/home/tani/Gemini/scripts"
pre_trans_file="pre_jp_only_${original_file}.xlf"
patch_file="jp_part.patch"
post_trans_file="post_jp_only_${original_file}.xlf"

## Export input filename to "conf.sh"  to reuse variables here in another script. 

cat << EOS > ${script_path}/conf.sh 
#!/bin/bash
export PYTHONPATH=/home/tani/Gemini/gem_venv/lib/python3.11/site-packages/
tikal_path=${tikal_path}
java_path=${java_path}
python_path=${python_path}
script_path=${script_path}
original_file=${original_file}
pre_trans_file=${pre_trans_file}
patch_file=${patch_file}
post_trans_file=${post_trans_file}

echo "===== Variables imported ======" 
echo "PYTHONPATH: "${PYTHONPATH}
echo "tikal_path: "${tikal_path}
echo "java_path: "${java_path}
echo "python_path: "${python_path}
echo "script_path: "${script_path}
echo "original_file: "${original_file}
echo "pre_trans_file: "${pre_trans_file}
echo "patch_file: "${patch_file}
echo "post_trans_file: "${post_trans_file}
echo "===============================" 
EOS

# --------------------------------------------

echo ${original_file}


# 1. Convert Original HTML into XLIFF(.xlf) using Tikal
## Output:${original_file}.xlf 

${java_path} -jar ${tikal_path}/tikal.jar -x ${original_file} -sl EN -tl JA

# 2. Extract JP part which will be translated by Gemini
grep "<target xml:lang=\"ja\">"  ${original_file}.xlf > ./${pre_trans_file}

# 3. Make Patch file for 1 and 2
diff  ${original_file}.xlf  ${pre_trans_file} > ./${patch_file}

# 4. Translate with Python script
# Note: this process takes time (because of API limtation of Gemini) 
echo ${pre_trans_file}
echo ${post_trans_file}


${python_path} ${script_path}/gemini_trans.py ${pre_trans_file} ${post_trans_file}

echo "****** Translation done ******"


