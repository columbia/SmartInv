# Datatsets Overview

## Dataset for PEFT style models

the ``.txt`` files are in general designed for PEFT models. [This](https://github.com/columbia/SmartInv/blob/main/dataset_gen/datasets/complex_tot_train_data.txt) is the largest one. 

[This data](https://github.com/columbia/SmartInv/blob/main/dataset_gen/datasets/invariant_per_line.txt) has one invariant per critical program points. 
[This data](https://github.com/columbia/SmartInv/blob/main/dataset_gen/datasets/tot_context.txt) only trains for context
[This data](https://github.com/columbia/SmartInv/blob/main/dataset_gen/datasets/tot_bug.txt) only trains for bugs
etc. The names of the datasets are self-explanatory. 

## Dataset for GPT and Alpaca style models

The json files serve this purpose in case you want to fine-tune GPT4 and Alpaca separately. 



## Clean the Folder
If you added raw samples to the raw data and would like to generate the training data again, you can just run: 
```
python clean.py
python generator.py
```
