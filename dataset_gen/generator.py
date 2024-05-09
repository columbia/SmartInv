#    Copyright 2023 Sally Junsong Wang, Kexin Pei, Junfeng Yang
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

import io
import os
import xlrd
import pandas as pd
import simplejson as json
from collections import OrderedDict
from numpy import random
from numpy import random


def _make_w_io_base(f, mode: str):
    if not isinstance(f, io.IOBase):
        f_dirname = os.path.dirname(f)
        if f_dirname != "":
            os.makedirs(f_dirname, exist_ok=True)
        f = open(f, mode=mode)
    return f


def _make_r_io_base(f, mode: str):
    if not isinstance(f, io.IOBase):
        f = open(f, mode=mode)
    return f


def jdump(obj, f, mode="w", indent=4, default=str):
    """Dump a str or dictionary to a file in json format.
    Args:
        obj: An object to be written.
        f: A string path to the location on disk.
        mode: Mode for opening the file.
        indent: Indent for storing json dictionaries.
        default: A function to handle non-serializable entries; defaults to `str`.
    """
    f = _make_w_io_base(f, mode)
    if isinstance(obj, (dict, list)):
        json.dump(obj, f, indent=indent, default=default)
    elif isinstance(obj, str):
        f.write(obj)
    else:
        raise ValueError(f"Unexpected type: {type(obj)}")
    f.close()


def jload(f, mode="r"):
    """Load a .json file into a dictionary."""
    f = _make_r_io_base(f, mode)
    jdict = json.load(f)
    f.close()
    return jdict

def prepare_actor_model_data(df): 
    data_list=[]
    df = df.fillna('')
    for index, row in df.iterrows():
        data = OrderedDict()
        data["prompt"] = row['Source']
        data["completion"] = row['Target']
        data_list.append(data)
    jdump(data_list, './datasets/alpaca_opt_training_data.json')

#we do not use the two functions below for this tool: but it might be useful for 
#other RLHF data tasks
def prepare_rlhf_model_data(df): 
    data_list=[]
    for index, row in df.iterrows():
        data = OrderedDict()
        print("one tow: ", row)
        data["prompt"] = row['Source']
        data_list.append(data)
    jdump(data, './datasets/reward_training_data.json')

#this is useful for rlhf as future development,
#which we currently do not support in SmartInv
def prepare_reward_model_data(df):
    data_list=[]    
    for index, row in df.iterrows():
        data = OrderedDict()
        data["prompt"] = row['Source']
        data["completion"] = row['Target']
        data["score"] = 5
        data_list.append(data)
    jdump(data, './datasets/rlhf_training_data.json')

def prepare_model_data(df): 
    df = df.fillna('')
    data_list=[]
    for index1, row1 in df.iterrows():
        data1 = OrderedDict()
        data1["prompt"] = row1['Source']
        data1["completion"] = row1['Target']
        data1["line"] = row1['All_Line']
        data1["critical_target"] = row1['Critical_Target']
        data1["ranked_target"] = row1['Ranked_Target']
        data1["context"] = row1['Context']
        data1["bug"] = row1['Bug']
        data_list.append(data1)
    jdump(data_list, './datasets/bulk_invariant_data.json')

def prepare_prompt_line(df): 
    df = df.fillna('')
    data_list=[]
    for index2, row2 in df.iterrows():
        data2 = OrderedDict()
        data2["prompt"] = row2['Source']
        data2["completion"] = row2['Target']
        data2["line"] = row2['Line']
        data2["invariants"] = row2['Invariants']
        data_list.append(data2)
    jdump(data_list, './datasets/line_invariant_data.json')

#this is not exactly Chain of Thought (CoT) prompting, 
#but we adapted a similar approach for invariant inference as a baseline 
def prepare_cot_train_data(df, df2):
    data_list=[]
    for index1, row1 in df.iterrows():
        data1 = OrderedDict()
        data2 = OrderedDict()
        data3 = OrderedDict()
        data4 = OrderedDict()
        data1["prompt"] = str(row1['Source']) + "\n" + \
                   "What are the critical program points for invariants prediction?"+ "\n" 
        data1["completion"] = str(row1['All_Line']) 
        data2["prompt"] = str(row1['Source']) + "\n" + str(row1['All_Line']) + \
                              "Given input contract and program points, what are the invariants?" + "\n"      
        data2["completion"] = str(row1['Target'])
        data3["prompt"] = str(row1['Source']) + "\n" + str(row1['Target']) + \
                            "Given input contract and all invariants, what are the critical invariants?" + "\n"
        data3["completion"] = str(row1['Critical_Target'])
        data4["prompt"] =  str(row1['Source']) + "\n" + str(row1['Critical_Target']) + \
                                "Given input and critical invariants, what are the vulnerabilities?" + "\n"
        data4["completion"] = str(row1['Bug'])
        data_list.append(data1)
        data_list.append(data2)
        data_list.append(data3)
        data_list.append(data4)
    for index2, row2 in df2.iterrows():
        data5 = OrderedDict()
        data5["prompt"] = str(row2['Source']) + "\n" + str(row2['Line']) + "\n" + \
                            "Given input contract and the program point, what's the invariant?" + "\n"
        data5["completion"] = str(row2["Invariants"])
        data_list.append(data5)
    jdump(data_list, 'datasets/cot_data.json')

#This json format data is useful for openAI model and VertexAI fine-tuning 
def prepare_tot_train_data(df, df2):
    data_list=[]
    for index1, row1 in df.iterrows():
        data1 = OrderedDict()
        data2 = OrderedDict()
        data3 = OrderedDict()
        data4 = OrderedDict()
        data5 = OrderedDict()
        data6 = OrderedDict()
        #Tier 1A
        data1["prompt"] = str(row1['Source']) + "\n" + \
                   "What's the transaction context of the contract?"+ "\n" 
        data1["completion"] = "The transaction context is " + str(row1['Context']) 
        #Tier 1B
        data2["prompt"] = str(row1['Source']) + "\n" + "Given transaction context " + str(row1['Context'])+ \
                              "What are the critical program points?" + "\n"      
        data2["completion"] = "Critical program points are " + str(row1['All_Line']) 
        #Tier 2A
        data3["prompt"] = str(row1['Source']) + "\n" + \
                            "Given inferred critical program points " + str(row1['All_Line']) + \
                            "what are the invariants?" + "\n"
        data3["completion"] = str(row1['Target'])
        #Tier 2B
        data4["prompt"] = str(row1['Source']) + "\n" + \
                            "Given inferred invariants" + str(row1['Target']) + \
                            "what are the critical invariants?" + "\n"
        data4["completion"] = str(row1['Critical_Target'])
        #Tier 3A
        data5["prompt"] = str(row1['Source']) + "\n" + \
                            "Given inferred critical invariants" + str(row1['Critical_Target']) + \
                            "what are the ranks of inferred critical invariants?" + "\n"
        data5["completion"] = str(row1['Ranked_Target'])
        #Tier 3B
        data6["prompt"] =  str(row1['Source']) + "\n" + \
                           "What are the vulnerabilities in the contract?" + "\n"
        data6["completion"] = str(row1['Bug'])
        data_list.append(data1)
        data_list.append(data2)
        data_list.append(data3)
        data_list.append(data4)
        data_list.append(data5)
        data_list.append(data6)
    for index2, row2 in df2.iterrows():
        data7 = OrderedDict()
         #line by line invariant supplement: 
        data7["prompt"] = str(row2['Source']) + "\n" + str(row2['Line']) + "\n" + \
                            "Given the program point, what's the invariant?" + "\n"
        data7["completion"] = str(row2["Invariants"])
        data_list.append(data7)
    jdump(data_list, 'datasets/tot_train_data.json')


#this function generates similar txt data as the json file above
#we use txt file for peft fine-tuning 
def complex_prepare_peft_text_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + transaction context
        sample 1: contract + prompt + all critical program points
        sample 2: contract + program points + prompt + all invariants
        sample 3: contract + all invariants  + prompt  + critical invariants
        sample 4: contract + all invariants  + prompt + ranked critical invariants   
        sample 5: contract + all invariants  + prompt + inferred bugs
        sample 6: contract + program point 1 + prompt + invariant at program point 1
        ...
        sample i:  contract + program point i + prompt + invariant at program point i
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/complex_tot_train_data.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                    #Tier 1A
                    str(d["prompt"]) + "\n" + \
                    "What's the transaction context of the contract?"+ "\n" + \
                    "\n" + str(d["context"]) + "\n" + "<end of text>" + "\n" + \
                    #Tier 1B
                    str(d["prompt"]) + "\n" + \
                    "Given transaction context " + str(d['context'])+ \
                    "What are the critical program points?" + "\n" + \
                    str(d["line"]) + "\n" + "<end of text>" + "\n" + \
                    #Tier 2A
                    str(d["prompt"]) + "\n" + \
                    f"Given inferred critical program points {str(d['line'])}, "+ \
                    "what are the invariants?" + "\n" + \
                    str(d["completion"]) + "\n" + "<end of text>" + "\n" + \
                    #Tier 2B
                    str(d["prompt"]) + "\n" + \
                    f"Given inferred invariants {str(d['completion'])}, " + \
                    "what are the critical invariants?" + "\n" + \
                    d["critical_target"] + "\n" + "<end of text>" + "\n" + \
                    #Tier 3A
                    str(d["prompt"]) + "\n" + \
                    f"Given inferred critical invariants {str(d['critical_target'])}, " + \
                    "what are the ranks of inferred critical invariants?" + "\n" + \
                    d["ranked_target"] + "\n" + "<end of text>" + "\n" + \
                    #Tier 3B
                     str(d["prompt"]) + "\n" + \
                    "What are the vulnerabilities in the contract?" + "\n" + \
                    d["bug"] + "\n" + "<end of text>" + "\n"                  
                     )
            for i in line_data:
                file.write(
                    str(i["prompt"]) + "\n" + str(i["line"]).replace(" ", "") + "\n" + \
                    "Given input contract and the program point, what's the invariant?" + \
                    "\n" + str(i["invariants"]) + "\n" + "<end of text>" + "\n")
        file.close()

def simple_prepare_peft_text_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + transaction context
        sample 1: contract + prompt + all critical program points
        sample 2: contract + program points + prompt + all invariants
        sample 3: contract + all invariants  + prompt  + critical invariants
        sample 4: contract + all invariants  + prompt + ranked critical invariants   
        sample 5: contract + all invariants  + prompt + inferred bugs
        sample 6: contract + program point 1 + prompt + invariant at program point 1
        ...
        sample i:  contract + program point i + prompt + invariant at program point i
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/simple_tot_train_data.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                    #Tier 1A
                    str(d["prompt"]) + "\n" + \
                    "What's the transaction context of the contract?"+ "\n" + \
                    "\n" + str(d["context"]) + "\n" + "<end of text>" + "\n" + \
                    #Tier 1B
                    str(d["prompt"]) + "\n" + \
                    "Given transaction context " + str(d['context'])+ \
                    "What are the critical program points?" + "\n" + \
                    str(d["line"]) + "\n" + "<end of text>" + "\n" + \
                    #Tier 2A
                    str(d["prompt"]) + "\n" + \
                    f"Given inferred critical program points {str(d['line'])}, "+ \
                    "what are the invariants?" + "\n" + \
                    str(d["completion"]) + "\n" + "<end of text>" + "\n" + \
                    #Tier 2B
                    str(d["prompt"]) + "\n" + \
                    f"Given inferred invariants {str(d['completion'])}, " + \
                    "what are the critical invariants?" + "\n" + \
                    d["critical_target"] + "\n" + "<end of text>" + "\n" + \
                    #Tier 3A
                    str(d["prompt"]) + "\n" + \
                    f"Given inferred critical invariants {str(d['critical_target'])}, " + \
                    "what are the ranks of inferred critical invariants?" + "\n" + \
                    d["ranked_target"] + "\n" + "<end of text>" + "\n" + \
                    #Tier 3B
                     str(d["prompt"]) + "\n" + \
                    "What are the vulnerabilities in the contract?" + "\n" + \
                    d["bug"] + "\n" + "<end of text>" + "\n"             
                     )
        file.close()


def prepare_context_text_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + transaction context
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/tot_context.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                    #Tier 1A
                    str(d["prompt"]) + "\n" + \
                    "What's the transaction context of the contract?"+ "\n" + \
                    "\n" + str(d["context"]) + "\n" + "<end of text>" + "\n"           
                     )
        file.close()

def prepare_program_points_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + program points
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/tot_program_points.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                    #Tier 1A
                    str(d["prompt"]) + "\n" + \
                    "What are the critical program points?"+ "\n" + \
                    "\n" +  str(d["line"]) + "\n" + "<end of text>" + "\n"           
                     )
        file.close()

def complex_program_points_inferred_invariants_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + inferred program points + invariants
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/one_pp_per_invariant.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                    str(d["prompt"]) + "\n" + \
                    f"Given inferred critical program points {str(d['line'])}, " + \
                    "what are the invariants?" + "\n" + \
                    str(d["completion"]) + "\n" + "<end of text>" + "\n"        
                     )
            for i in line_data:
                file.write(
                    str(i["prompt"]) + "\n" + \
                    f"Given inferred critical program points {str(i['line']).replace(' ', '')}, " + \
                    "what are the invariants?" + "\n" + \
                    str(i["invariants"]) + "\n" + "<end of text>" + "\n")
        file.close()

def prepare_program_points_inferred_invariants_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + inferred program points + invariants
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/tot_pp2invariants.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                    str(d["prompt"]) + "\n" + \
                    f"Given inferred critical program points {str(d['line'])}, " + \
                    "what are the invariants?" + "\n" + \
                    str(d["completion"]) + "\n" + "<end of text>" + "\n"        
                     )
        file.close()


def prepare_invariants_only_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + invariants
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/tot_invaraiants_only.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                    str(d["prompt"]) + "\n" + \
                    "what are the invariants?" + "\n" + \
                    str(d["completion"]) + "\n" + "<end of text>"  + "\n"      
                     )
        file.close()

def prepare_critical_invariants_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + invariants + critical invariants
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/tot_critical_invariants.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>               
                file.write(
                str(d["prompt"]) + "\n" + \
                f"Given inferred invariants {str(d['completion'])}, " + \
                "what are the critical invariants?" + "\n" + \
                d["critical_target"] + "\n" + "<end of text>" + "\n")
        file.close()

def prepare_ranked_invariants_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + invariants + critical invariants
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/tot_ranked_invariants.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                str(d["prompt"]) + "\n" + \
                f"Given inferred critical invariants {str(d['critical_target'])}, " + \
                "what are the ranks of inferred critical invariants?" + "\n" + \
                d["ranked_target"] + "\n" + "<end of text>" + "\n")
        file.close()


def prepare_bug_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + invariants + critical invariants
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/tot_bug.txt', "a") as file:
            for d in bulk_data:
                #ToT processing for txt file: each training sample is separated by <end of text>
                file.write(
                str(d["prompt"]) + "\n" + \
                "What are the vulnerabilities in the contract?" + "\n" + \
                str(d["bug"]) + "\n" + "<end of text>" + "\n")     
        file.close()

def invariant_per_line_data():
    """prepare pomrpts for CoT 
    Args:
        bulk_invariant_data.json: source contract, all critical program points, 
        and all of its invariants, ranekd ivariants, contexts, and bugs if there's any

        line_invariant_data.json: source cotract + one critical program point + one invariant 
        
        For one contract, we create different versions of copies for ToT: 
        sample 0: contract + prompt + invariants + critical invariants
    """

    with open('./datasets/bulk_invariant_data.json', "r") as file1:
        bulk_data = json.load(file1)
    with open('./datasets/line_invariant_data.json', "r") as file2:
        line_data = json.load(file2)
        with open('./datasets/invariant_per_line.txt', "a") as file:
            for i in line_data:
                file.write(
                    str(i["prompt"]) + "\n" + str(i["line"]).replace(" ", "") + "\n" + \
                    "Given input contract and the program point, what's the invariant?" + \
                    "\n" + str(i["invariants"]) + "\n" + "<end of text>" + "\n")
        file.close()


def main():
    #one contract and one cell of all its invariants
    df = pd.read_excel(open('./datasets/invariants_bug.xlsx','rb'))
    print("==========one example in the dataset to be processed: =====================\n")
    print(df.iloc[0])
    df.columns = ['Source', 'Target', 'All_Line', 'Critical_Target', 'Ranked_Target', 'Context', 'Bug']
    #one contract one invariant per row 
    #multiple versions 
    df2 = pd.read_excel(open('./datasets/line_invariants.xlsx','rb'))
    df2.columns = ['Source', 'Target', 'Line', 'Invariants']
    prepare_actor_model_data(df)
    prepare_model_data(df)
    prepare_prompt_line(df2)
    prepare_cot_train_data(df, df2)
    prepare_tot_train_data(df, df2)
    complex_prepare_peft_text_data()
    complex_program_points_inferred_invariants_data()
    simple_prepare_peft_text_data()
    prepare_context_text_data()
    prepare_program_points_data()
    prepare_program_points_inferred_invariants_data()
    prepare_invariants_only_data()
    prepare_critical_invariants_data()
    prepare_ranked_invariants_data()
    prepare_bug_data()
    invariant_per_line_data()

    
if __name__ == "__main__":
       main()    