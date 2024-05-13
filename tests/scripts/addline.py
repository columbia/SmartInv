import os, glob
import re
import json
import sys

folder_path = '../contracts'


def text_lines(file, new_folder_path):
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
	audited_bug_folder_path = f"/home/sallyjunsongwang/SmartInv/tests/refined_analysis/natural_bugs/additional_audited_bugs"
	sets = ["set1", "set2", "set3"]
	for i in sets:
		test_folder_path = f"/home/sallyjunsongwang/SmartInv/tests/refined_analysis/natural_bugs/{i}"
		new_folder_path = f"{test_folder_path}/instrumented"
		#infer_bugs(test_folder_path, file_results_dir,  exp_name_manual, manual_prompt, limit)
		for root, dirs, files in os.walk(test_folder_path):
			for filename in files:
				file = os.path.join(root,filename)
				text_lines(file, new_folder_path)
	for root, dirs, files in os.walk(audited_bug_folder_path):
		for filename in files:
			file = os.path.join(root,filename)
			text_lines(file, new_folder_path)
	sample_folder_path = f"/home/sallyjunsongwang/SmartInv/tests/sample_test"
	new_folder_path = f"{sample_folder_path}/instrumented"
	for root, dirs, files in os.walk(sample_folder_path):
		for filename in files:
			file = os.path.join(root,filename)
			text_lines(file, new_folder_path)
	
