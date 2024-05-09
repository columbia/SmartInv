import os
import re
import shutil
import sys


def find_between(s, start, end):
    return s.split(start)[1].split(end)[0]

def extract_name(file):
        start = "contract"
        end = "{"
        file = open(file, "r")
        s = file.readlines()
        raw_list = []
        name_list = []
        for line in s:
                if start in line and end in line:  
                        raw_list.append(find_between(line, start, end))
        for item in raw_list:
                if "is" in item:                      
                        x = item.replace("is", ",")
                        name_list.append(x)
                if "," in item: 
                        name_list.append(x)             

        final = []
        for breakdown in name_list:
                for each in breakdown.split(','):
                        final.append(each)
        return final
 

                #print(result.group(1))
        #print((s.split(start))[1].split(end)[0])
        

if __name__ == "__main__":
	extract_name("./0xfffffffff15abf397da76f1dcc1a1604f45126db.sol")
        