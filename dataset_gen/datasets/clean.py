import os
import shutil

retain = ["invariants_bug.xlsx", "line_invariants.xlsx", "clean.py"]
for root, dirs, files in os.walk('./'):
    for f in files:
     if f not in retain: 
        os.unlink(os.path.join(root, f))
    for d in dirs:
        if d not in retain: 
            shutil.rmtree(os.path.join(root, d))