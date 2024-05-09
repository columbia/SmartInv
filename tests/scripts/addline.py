import os, glob
import re
import json
import sys

folder_path = '../contracts'
new_folder_path = '../instrumented_contracts'



def text_lines(file):
    if os.path.exists(new_folder_path) is False:
        os.mkdir(new_folder_path)       
    c = open(file, "r")
    list_of_lines = c.readlines()
    _, filename = os.path.split(file)
    c.close()
    number = 1
    numbered_list_of_lines = []
    for i in list_of_lines:
        numbered_lines = str(number) + " " + i
        numbered_list_of_lines.append(numbered_lines)
        number += 1
    f = open(f"{new_folder_path}/numerated_{filename}", "w+")
    for i in numbered_list_of_lines:
        f.write(i)
    print(f.read())
    f.close()

def add_lines(folder_path):
    for filename in os.listdir(folder_path):
            file = os.path.join(folder_path, filename)
            if os.path.isfile(file):
                    text_lines(file)
        
if __name__ == "__main__":
    add_lines(folder_path)
    
    
