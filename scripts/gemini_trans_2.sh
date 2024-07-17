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
## [ ] 7. Create final, translated file(such as HTML) 

#Note: step 1-4 is done in previous process (gemini_trans_1.sh) 　

## import variables  
source ../scripts/settings.conf
source ./variables.conf

## List up all variables
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
echo "output_file "${output_file}
echo "===============================" 

# 5. Check whether line counts are correct or not
echo "**********************************" 
echo "pre_trans_file: "${pre_trans_file} 
echo "post_trans_file:"${post_trans_file}

if [ -f ./${pre_trans_file} ] && [ -f ./${post_trans_file} ]; then
  # Both files exist, proceed with processing
  echo "Both of (1) \"${pre_trans_file}\" and (2) \"${post_trans_file}\" exist."

  # Your processing logic here

else
  # Either file or both files don't exist
  echo "Error: Both of (1) \"${pre_trans_file}\" and (2) \"${post_trans_file} \" must exist."
  exit 1
fi

# --------------------------------------------
## Check if two arguments (filenames) are provided
##  Get the line counts of each file
pre_file_lines=$(wc -l < "${pre_trans_file}")
post_file_lines=$(wc -l < "${post_trans_file}")

echo "Line # of "${pre_trans_file}" is: "${pre_file_lines}
echo "Line # of "${post_trans_file}" is: "${post_file_lines}

## Compare the line counts
if [ ${pre_file_lines} -eq ${post_file_lines} ]; then
  echo "OK! # of line matched! continue processing..."
  #is_same=True
else
  #is_same=False
  echo "Error: Line number does NOT match! check \"${post_trans_file}.\"" 
  exit
fi

# 6. Apply patch file to translated JP parts
patched_file="patch_${post_trans_file}"

# Check if the patch file work (dry run) 
#patch --dry-run ${post_trans_file} ${patch_file} 

echo "Patched file: "${patched_file}

# Do reverse patch
patch -R  ${post_trans_file} ${patch_file} --output=${patched_file} 

#************************************************************
# IF YOU CANNOT PATCH, 
# Modify ${post_trans_file} comparing with ${pre_trans_file} and ${patch_file}
# (In some cases, there is a space char after the end of line)
# Please use ```postprocessing.sh``` which is here. 
# $bash postprocessing.sh ${post_trans_file} 
#************************************************************


# 7. Convert XLIFF file into HTML 
# Check if the directory exists

if [ ! -d output ]; then
  # Create the directory
  mkdir output
  echo "Directory 'output' created."
else
  echo "Directory 'output' already exists."
fi

#output_file=${original_file}.xlf
#
cp ${patched_file} ${output_file}

#
#${java_path} -jar ${tikal_path}/tikal.jar -m ${output_file} -sl EN -tl JA -od ./output 
#
#echo ""
#echo "*** IN CASE OF TIKAL ISSUES ERROR; ***"
#echo "Modify ./output/${output_file} file MANUALLY. Then execute as follows:"
#echo "${java_path} -jar ${tikal_path}/tikal.jar -m ${output_file} -sl EN -tl JA -od ./output " 
#echo "**************************************"
#
#  # Your failure processing logic here
#
#  exit 1
#fi

echo "**** Phase 2 of 3 is done. ********" 
