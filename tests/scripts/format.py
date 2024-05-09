import os, glob
import re
import json
import sys

folder_path = './contracts'
exclude = "content"
for filename in glob.glob(os.path.join(folder_path, '*.json')):
  with open(filename, 'r') as f:
    print("=======================================\n")
    text = f.read()
    res=re.findall(exclude+"(.*)"+exclude, text)
    print(res)
    print("=======================================\n")
