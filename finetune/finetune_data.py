import io
import os
import xlrd
import subprocess
import pandas as pd
import fnmatch
import simplejson as json
from collections import OrderedDict
from numpy import random
from numpy import random
from glob import iglob

RESULT_DIR = '/home/sallyjunsongwang/llmfz/results-20240124'
ONE_STEP = "onestep.json" 
GPT4_DATA = "gpt4.jsonl"
CONTEXTUALIZED = "context.txt"

def find_function(file, first, last):
    try:
        start = file.rindex(first) + len(first)
        end = file.rindex(last, start)
        return file[start:end]
    except ValueError:
        return ""

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
    f = _make_w_io_base(f, mode)
    if isinstance(obj, (dict, list)):
        json.dump(obj, f, indent=indent, default=default)
    elif isinstance(obj, str):
        f.write(obj)
    else:
        raise ValueError(f"Unexpected type: {type(obj)}")
    f.close()

def gpt4_data_prep(result_dir,train_file): 
        data_list = []   
        train_file_path = os.path.join(result_dir, train_file)
        #train_data = open(train_file_path, "a+") 
        for (root, directories, files) in os.walk(result_dir, topdown=False):
                data = OrderedDict()
                prompt = ""
                for name in files:
                        if name == "prompt.txt":
                                prompt_file = os.path.join(root, name)
                                with open(prompt_file, "r") as file:
                                        prompt =  file.read()                                                                                                                                
                for name in directories:
                        if name == "fixed_targets": 
                                targets_dir = os.path.join(root, name)
                                for target in os.listdir(targets_dir):
                                        possible_target = os.path.join(targets_dir, target)
                                        if os.path.isfile(possible_target):
                                                with open(possible_target, "r") as target_file:
                                                        single_target = target_file.read()
                                                        data["prompt"] = prompt                                                          
                                                        data["completion"] = single_target
                                                        data_list.append(data)
        jdump(data_list, train_file_path)   

def one_step_data_prep(result_dir,train_file): 
        data_list = []   
        train_file_path = os.path.join(result_dir, train_file)
        for (root, directories, files) in os.walk(result_dir, topdown=False):
                data = OrderedDict()
                for name in files:
                        if name == "prompt.txt":
                                prompt_file = os.path.join(root, name)
                                with open(prompt_file, "r") as file:
                                        file =  file.read()
                                        first = "<function header>"
                                        last = "</function header>"
                                        function = find_function(file, first, last)                                                                                                                                       
                for name in directories:
                        if name == "fixed_targets": 
                                targets_dir = os.path.join(root, name)
                                for target in os.listdir(targets_dir):
                                        possible_target = os.path.join(targets_dir, target)
                                        if os.path.isfile(possible_target):
                                                with open(possible_target, "r") as target_file:
                                                        single_target = target_file.read()
                                                        data["prompt"] = "function signature is: " + function.strip()                                                          
                                                        data["completion"] = single_target
                                                        data_list.append(data)
        jdump(data_list, train_file_path)                                   

def contextualized_data_prep(result_dir,train_file):
        train_file_path = os.path.join(result_dir, train_file)
        train_data = open(train_file_path, "a+") 
        first_thought = ""
        second_thought = ""
        third_thought = ""
        for (root, directories, files) in os.walk(result_dir, topdown=False):
                for name in files:
                        if name == "prompt.txt":
                                prompt_file = os.path.join(root, name)
                                with open(prompt_file, "r") as file:
                                        file =  file.read()
                                        first = "<function header>"
                                        last = "</function header>"
                                        function = find_function(file, first, last)
                                        first_thought = "This is the function signature: " + \
                                        function.strip() + "\n"
                                        second_thought = file  + "\n"
                               
                for name in directories:
                        if name == "fixed_targets": 
                                targets_dir = os.path.join(root, name)
                                for target in os.listdir(targets_dir):
                                        possible_target = os.path.join(targets_dir, target)
                                        if os.path.isfile(possible_target):
                                                with open(possible_target, "r") as target_file:
                                                        single_target = target_file.read()
                                                        third_thought = "function fuzz target(s) are: " + \
                                                        single_target + "\n"
                if first_thought != "" and  second_thought != "" and third_thought != "":                                    
                        one_sample = first_thought + second_thought + third_thought + "<end of text>" + "\n"
                        train_data.write(one_sample)
        train_data.close()

def collectData(result_dir):
        target_files = [ONE_STEP, GPT4_DATA, CONTEXTUALIZED]
        for (root, directories, files) in os.walk(result_dir, topdown=False):
                for f in files:
                        if f in target_files:
                                full_path = os.path.join(root, f)
                                subprocess.call(["mv", str(full_path), "/home/sallyjunsongwang/llmfz/train_data"])


def main():
        contextualized_data_prep(RESULT_DIR, CONTEXTUALIZED)
        one_step_data_prep(RESULT_DIR, ONE_STEP)
        gpt4_data_prep(RESULT_DIR, GPT4_DATA)
        collectData(RESULT_DIR)

if __name__ == "__main__":
       main()    