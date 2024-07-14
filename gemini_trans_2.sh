#!/bin/bash

# Machine Translation using Gemini API 
# Command: 
# bash ../scripts/gemini_trans_1.sh [arg1]
# arg1: original file to be translated  

# Steps ( [x] : This script's scope)  
## [ ] 1. Convert original file (such as HTML) into XLIFF(.xlf) using **Tikal** 
## [ ] 2. Extract JP part which will be translated by Gemini
## [ ] 3. Make patch file for 1 and 2 
## [ ] 4. Translate with Python script 
## [x] 5. Compare line counts pre-translated file and post-translated file
## [x] 6. Apply reverse patch file made in step 3 to merge translated JP parts into XLIFF

#Note: step 1-4 is done in previous process (gemini_trans_1.sh) 　

# Set variables()
export PYTHONPATH="path/to/venv/lib/python_ver/site-packages/"
tikal_path="path/to/tikal/" 
java_path=`which java`
python_path=`which python3`
script_path="path/to/these/scripts"
pre_trans_file="pre_jp_only_${original_file}.xlf"
patch_file="jp_part.patch"
post_trans_file="post_jp_only_${original_file}.xlf"

# import variables set in gemini_trans_1.sh 
source ${script_path}/conf.sh

echo "Original file: "${original_file}

# 5. Compare line counts pre-translated file and post-translated file
# --------------------------------------------
# Check if both files exist
if [ -f ${pre_trans_file} ] && [ -f ${post_trans_file} ]; then
  # Both files exist, proceed with processing
  echo "OK! Both of (1) \"${pre_trans_file}\" and (2) \"${post_trans_file}\" exist."

  # Your processing logic here

else
  # Either file or both files don't exist
  echo "Error: Both of (1) \"${pre_trans_file}\" and (2) \"${post_trans_file} \"must exist."
  exit 1
fi
## Check if two arguments (filenames) are provided
##  Get the line counts of each file
pre_file_lines=$(wc -l < "${pre_trans_file}")
post_file_lines=$(wc -l < "${post_trans_file}")

echo "Line # of "${pre_trans_file}" is: "${pre_file_lines}
echo "Line # of "${post_trans_file}" is: "${post_file_lines}

## Compare the line counts
if [ ${pre_file_lines} -eq ${post_file_lines} ]; then
  echo "OK! Line number DOES match! continue processing..."
  #is_same=True
else
  #is_same=False
  echo "Error: Line number does NOT match! check \"${post_trans_file}.\"" 
  exit
fi
# --------------------------------------------

# 6. Apply reverse patch  to translated JP parts
patched_file="patch_${post_trans_file}"
patch -R  ${post_trans_file} ${patch_file} --output ${patched_file} #Reverse patch 

# 7. Convert XLIFF file into original format
# Check if the directory exists

if [ ! -d html_out ]; then
  # Create the directory
  mkdir output
  echo "Directory 'output' created."
else
  echo "Directory 'output' already exists."
fi

output_file=${original_file}.xlf

mv ${patched_file} ${output_file}

${java_path} -jar ${tikal_path}/tikal.jar -m ${output_file} -sl EN -tl JA -od ./output 

if [ $? -eq 0 ]; then
  # Command executed successfully
  echo "Command executed successfully. Processing for success."

  # Your success processing logic here

else
  # Command failed
  echo ""
  echo "*** Tikal processing FAILED ***"
  echo "Modify ./output/${output_file} file MANUALLY. Then execute as follows:"
  echo "${java_path} -jar ${tikal_path}/tikal.jar -m ${output_file} -sl EN -tl JA -od ./output " 
  echo "*******************************"

  # Your failure processing logic here

  exit 1
fi

echo "**** Gemini Translation Done ********" 
