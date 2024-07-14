# Machine Translation using Gemini API  
* End to End translation using Okapi Tikal, Gemini.
* Multi file format such as IDML, HTML, etc. 
* Not only efficiency, aim to ensure "quality" of translation much more than NMT. 
* "Collaboration with GenAI" , focusing on prompt engineering.
## Steps
* 1. Convert original file (such as HTML) into XLIFF(.xlf) using **Tikal**
* 2. Extract JP part which will be translated by Gemini
* 3. Make patch file for 1 and 2 <br>
--> 1-3: **[gemini_trans_1.sh](./gemini_trans_1.sh)**
* 4. Translate with Python script using Gemini API(Customize Prompts)<br>
--> 4: **[gemini_trans.py](./gemini_trans.py)**
* 5. Compare line counts pre-translated file and post-translated file
* 6. Apply reverse patch file made in step 3 to merge translated JP parts into XLIFF<br>
--> 5-6: **[gemini_trans_2.sh](./gemini_trans_2.sh)**
* 7. Check and modify manually. (not yet automated)
* 8. Convert XLIFF file into HTML and fix some cosmetics issues such as fonts,etc. <br>
--> 7-8: **Manual tasks** (not yet automated)

## My environment
* Ubuntu 22.04LTS 
* Python 3.11.0 (pyenv+venv)
* Google Gemini Pro 1.5 (**API Key required**)
* VSCode with extensions 
