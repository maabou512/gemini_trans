#!/bin/bash

#Note: step 1-4 is done in previous process (gemini_trans_1.sh) 　

# Set variables()
export PYTHONPATH=/home/tani/Gemini/gem_venv/lib/python3.11/site-packages/
tikal_path="/home/tani/translation/okapi-apps_gtk2-linux-x86_64_0.37/lib" 
java_path=`which java`
python_path=`which python3`

source ./conf.sh

echo "Original file: "${original_file}



# 5. Check whether line counts are correct or not

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

# --------------------------------------------
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


# 6. Apply patch file to translated JP parts
patched_file="patch_${post_trans_file}"
patch -R  ${post_trans_file} ${patch_file} --output ${patched_file} #Reverse patch 

# 7. Convert XLIFF file into HTML 
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






