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
## [ ] 5. Compare line counts pre-translated file and post-translated file
## [ ] 6. Apply reverse patch file made in step 3 to merge translated JP parts into XLIFF
## [x] 7. Create final, translated file(such as HTML) 

#Note: step 1-6 is done in previous process (gemini_trans_1.sh) 　

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

# 7. Create final, translated file(such as HTML) 

${java_path} -jar ${tikal_path}/tikal.jar -m ${output_file} -sl EN -tl JA -od ./output 

#echo ""
#echo "*** IN CASE OF TIKAL ISSUES ERROR; ***"
#echo "Modify ./${output_file} file MANUALLY. Then execute as follows:"
#echo "${java_path} -jar ${tikal_path}/tikal.jar -m ${output_file} -sl EN -tl JA -od ./output " 
#echo "**************************************"

echo "**** End of  Phase 3 of 3 (If no error, It's done.) ********" 
