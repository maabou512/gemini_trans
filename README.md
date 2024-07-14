# gemini_trans

Translation using Gemini Pro API 

## Steps

* 1. Convert Original HTML into XLIFF(.xlf) using **Tikal**
* 2. Extract JP part which will be translated by Gemini
* 3. Make Patch file for 1 and 2
* 4. Translate with Python Script using Gemini API(Customize Prompts)
* 5. Compare line counts pre-translated file and post-translated file
* 6. Apply patch file made in step 3 to merge translated JP parts into XLIFF
* 7. Check and modify manually. (not yet automated)
* 8. Convert XLIFF file into HTML and fix some cosmetics issues such as fonts,etc. 
