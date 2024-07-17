#!/bin/bash

# Preparation

## Import variables 
source "../scripts/settings.conf" 
source "./variables.conf"

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


# Detete unncessary Gemini outputs

## 1. Delete a sort of "```xml", "```<target", "``````xml" 

sed   -i -E "s/^[\`]+xml$//g" ${post_trans_file}
sed   -i -E "s/^[\`]+$//g" ${post_trans_file}
sed   -i -E "s/^[\`]+</</g" ${post_trans_file}

## 2. Delete empty line which generated above""
sed   -i -E "/^$/d" ${post_trans_file}

## 3. Delete space at the end of line("> $") 
sed   -i -E "s/> //g" ${post_trans_file}

## 4. Recorvery XML tags misprocessed by Gemini
# Case 1:
# </target 
$sed -i -E  "s/<\/target$/<\/target>/g"  ${output_file}
sed -E "s/<\/g[^>]/<\/g>/g"  ${output_file}

# Case 2(example):
# <g id="1"</g>             --->  <g id="1"> </g>
# <g id="2"/<g id="3">      --->   <g id="2"/> <g id="3">     
sed -E  "s/<(g|x|bx|ex)( id=\"[0-9]\")([^\/>])/<\1\2> </g"  ${output_file}
sed -E  "s/<(g|x|bx|ex)( id=\"[0-9]\"\/)([^>])/<\1\2> </g"  ${output_file}

exit 0