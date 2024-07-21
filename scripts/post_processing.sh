#!/bin/bash

# A Script to modify ${post_trans_file} and ${output_file}'s XML related errors after STEP 4
# Steps ( [x] : This script's scope)  
## [ ] 1. Convert original file (such as HTML) into XLIFF(.xlf) using **Tikal** 
## [ ] 2. Extract JP part which will be translated by Gemini
## [ ] 3. Make patch file for 1 and 2 
## [ ] 4. Translate with Python script 
##  *** Run HERE **** 
## [ ] 5. Compare line counts pre-translated file and post-translated file
## [ ] 6. Apply reverse patch file made in step 3 to merge translated JP parts into XLIFF
## [ ] 7. Create final, translated file(such as HTML) 
# Run by
# bash ../../post_prcessing.sh

## Import variables 
source "../../scripts/settings.conf" 
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
echo "sed 1 ....." 
sed   -i -E "s/^[\`]+xml$//g" ${post_trans_file}
sed   -i -E "s/^[\`]+$//g" ${post_trans_file}
sed   -i -E "s/^[\`]+</</g" ${post_trans_file}

## 2. Delete empty line which generated above""
echo "sed 2 ....." 
sed   -i -E "/^$/d" ${post_trans_file}

## 3. Delete space at the end of line("> $") 
echo "sed 3 ....." 
sed   -i -E "s/(> )$/>/g" ${post_trans_file}

## 4. Recorvery XML tags misprocessed by Gemini
# Case 1:
# </target 
echo "sed 4-1 ....." 
sed -i -E  "s/<(\/target)$/\1>/g"  ${post_trans_file}
sed -i -E "s/(<\/g)[^>]/\1>/g"  ${post_trans_file}

# Case3 
# <target xml:lang="ja"<g id="1">
echo "sed 4-2 ....." 
sed -i -E "s/(^<target xml:lang=\"ja\")[^>]/\1>/g" ${post_trans_file}

# Case 2(example):
echo "sed 4-3 ....." 
# <g id="1"</g>             --->  <g id="1"> </g>
# <g id="2"/<g id="3">      --->   <g id="2"/> <g id="3">     
sed -i -E  "s/<(g|x|bx|ex)( id=\"[0-9]\")([^\/>])/<\1\2> </g"  ${output_file}
sed -i -E  "s/<(g|x|bx|ex)( id=\"[0-9]\"\/)([^>])/<\1\2> </g"  ${output_file}

#Case 4 
echo "sed 4-4 ....." 
# <target xml:lang="ja">/target>
sed -i -E  "s/[^<](\/target>$)/ <\1/g" ${output_file}

# Case 5
# <target xml:lang="ja"<g id="1">
echo "sed 4-5 ....." 
sed -i -E "s/(^<target xml:lang=\"ja\" )[^>]/\1>/g" ${output_file}

# Case 6 
# Change  normal space (Hair space,"200a") to No break space("c2a0",aka "NBSP") to
# e.g. 
# original:<target xml:lang="ja"> </target> = <target xml:lang="ja">M-BM- </target>$
# $echo  " " |xxd 
# 00000000: c2a0 0a                                  ...
# translated: <target xml:lang="ja"> </target> = <target xml:lang="ja">00000000</target>
# tani@tani-pc:/home/tani/Gemini/git/gemini_trans/trans_work/fledge
# $echo " " |xxd
# 00000000: 200a  
# (Hair Space)

## Convert 
echo "sed 6....." 
sed -i -E "s/<target xml:lang=\"ja\"> <\/target>/<target xml:lang=\"ja\"> <\/target>/g" ${post_trans_file}
sed -i -E "s/<target xml:lang=\"ja\"> <\/target>/<target xml:lang=\"ja\"> <\/target>/g" ${post_trans_file}
