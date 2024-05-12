import os
import csv
import shutil
import sys
import subprocess
import argparse
import random
import time
import re
import json 
import numpy as np
import pandas as pd
import openai
from openai import OpenAI
#uncomment and use the following line instead when calling from smartinv.py
#from .prompts.GPTScan.query_template import prompt_single_yes_no_question, prompt_multiple_choice_scenarios 
from prompts.GPTScan.query_template import prompt_single_yes_no_question, prompt_multiple_choice_scenarios 


refined_exp_results = "./refined_exp_results"
large_exp_results_dir = "./large_exp_results"
prompt_exp_results = '/home/sallyjunsongwang/SmartInv/all_results/prompting_results'
client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
vul_list = ["price manipulation", "privilege escalation", "business logic flaw", "inconsistent state update", "atomicity violation", "cross bridge inconsistency", "ID uniqueness violation"]

scenarios = ["add or check approval via require/if statements before the token transfer",
"deposit/mint/add the liquidity pool/amount/share",
"have code statements that get or calculate LP token's value/price",
"buy some tokens",
"calculate vote amount/number",
"mint or vest or collect token/liquidity/earning and assign them to the address recipient or to variable",
"have inside code statements that update/accrue interest/exchange rate",
"have inside code statements that invoke user checkpoint",
"involve calculating swap/liquidity or adding liquidity, and there is asset exchanges or price queries",
"involve transfering token from an address different from message sender"]


def gpt_infer(prompt):
	chat_completion = client.chat.completions.create(
			messages=[
					{
					"role": "user",
					"content": f"{prompt}",
					}
			],
			model="gpt-3.5-turbo",
	)
	return chat_completion.choices[0].message.content

def find_program_points(folder, file_results_dir, limit):
	path =f"/home/sallyjunsongwang/SmartInv/verifier/prompts/program_point.txt"
	preparation_1 = open(path, "r")
	if (os.path.isdir(file_results_dir)) is False:
		os.mkdir(file_results_dir)
	'''
	for root, dirs, files in os.walk(folder):
		for filename in files:
			contract_file = os.path.join(root, filename)
			print(contract_file)
	'''
	contract_file = f"./numbered_timecontroller.sol"
	filename = "numbered_timecontroller.sol"
	preparation_2 = open(contract_file, "r")
	x = len(preparation_2.readlines())
	result_file_path = os.path.join(file_results_dir, f"{filename}_light_pp.txt")
	if os.path.isfile(contract_file) and x != 1 and x <=limit:
		preparation_2 = open(contract_file, "r")
		result_file = open(f'{result_file_path}', "w+")
		prompt = preparation_1.read() + preparation_2.read()
		print(prompt)
		raw_output = gpt_infer(prompt)
		print(f"=========program points inferred for {filename}=======")
		print(raw_output)
		result_file.write(raw_output)
		result_file.close()


def find_invariants(folder, file_results_dir, limit):
	path =f"/home/sallyjunsongwang/SmartInv/verifier/prompts/invariant.txt"
	preparation_1 = open(path, "r")
	if (os.path.isdir(file_results_dir)) is False:
		os.mkdir(file_results_dir)
	'''
	for root, dirs, files in os.walk(folder):
		for filename in files:
			contract_file = os.path.join(root, filename)
			print(contract_file)
	'''
	contract_file = "./numbered_timecontroller.sol"
	filename = "numbered_timecontroller.sol"
	prior_answer = os.path.join(file_results_dir, f"{filename}_light_pp.txt")
	if os.path.isfile(prior_answer): 
		preparation_2 = open(prior_answer, "r")
	preparation_3 = open(contract_file, "r")
	x = len(preparation_2.readlines() + preparation_3.readlines())
	result_file_path = os.path.join(file_results_dir, f"{filename}_inv.txt")
	if os.path.isfile(contract_file) and x != 1 and x <=limit:			
		result_file = open(f'{result_file_path}', "w+")
		if os.path.isfile(prior_answer): 
			preparation_2 = open(prior_answer, "r")
		preparation_3 = open(contract_file, "r")
		prompt = preparation_1.read() + preparation_2.read() + preparation_3.read()
		print(prompt)
		raw_output = gpt_infer(prompt)
		print(f"=========invariants inferred for {filename}=======")
		print(raw_output)
		result_file.write(raw_output)
		result_file.close()   
	    

def infer_bugs(folder, file_results_dir, exp_name, prompt, limit):
	list = []
	path =f"/home/sallyjunsongwang/SmartInv/verifier/prompts/{prompt}"
	print(path)
	if exp_name == "gptscan":
		preparation_1 = f"You are a smart contract auditor. You will be asked \
	  questions related to code properties. You can mimic answering them in the background five times and provide me\
		  with the most frequently appearing answer. Furthermore,\
			  please strictly adhere to the output format specified in the\
				  question; there is no need to explain your answer."
	else:
	
		preparation_1 = open(path, "r")
	if (os.path.isdir(file_results_dir)) is False:
		os.mkdir(file_results_dir)
	if (os.path.isdir(f"{file_results_dir}/{exp_name}")) is False:
		os.mkdir(f"{file_results_dir}/{exp_name}")
	for root, dirs, files in os.walk(folder):
		for filename in files:
			contract_file = os.path.join(root, filename)
			print(contract_file)
			bug = ""
			preparation_2 = open(contract_file, "r")
			x = len(preparation_2.readlines())
			if exp_name == "gptscan":
				preparation_2 = open(contract_file, "r")
				prompt = prompt_multiple_choice_scenarios(scenarios, preparation_2.read())
			else: 
				preparation_1 = open(path, "r")
				preparation_2 = open(contract_file, "r")
				prompt = preparation_1.read() + " Source code is: " + preparation_2.read()
			result_file_path = os.path.join(file_results_dir, exp_name, f"{filename}_alarm.txt")
			#and os.path.exists(result_file_path)==False
			if os.path.isfile(contract_file) and x != 1 and x <=limit:			
				result_file = open(f'{result_file_path}', "w+")
				raw_output = gpt_infer(prompt)
				print(f"=========vulnerability detection of {filename}=======")
				print(raw_output)
				for item in vul_list: 
					if item in raw_output.lower(): 
						bug += f"{item}, "     
				dict = {contract_file, bug}
				list.append(dict.copy())
				print(dict)
				result_file.write(raw_output)
				result_file.close()
	df = pd.DataFrame(list)
	writer = pd.ExcelWriter(f'{exp_name}_result.xlsx', engine='xlsxwriter')
	df.to_excel(writer, sheet_name='bugs', index=False)
	writer._save()


def single_contract_test():
	contract_file = "numbered_timecontroller.sol"

	infer_one_contract_tier1(contract_file, dir, param)

if __name__ == "__main__":
	sets = ["set1", "set2", "set3"]
	file_results_dir = prompt_exp_results
	exp_name_gpt = "gpt"
	exp_name_gptscan = "gptscan"
	prompt = "gpt.txt"
	exp_name_smartinv = "smartinv"
	smartinv_prompt = "smartinv_functionalbug.txt"
	exp_name_manual = "manual_audit"
	manual_prompt = "manual_audit.txt"
	limit = 300
	audited_bug_folder_path = f"../tests/refined_analysis/natural_bugs/additional_audited_bugs"
	find_program_points(audited_bug_folder_path, "./test", limit)
	find_invariants(audited_bug_folder_path, "./test", limit)
	'''
	infer_bugs(audited_bug_folder_path, file_results_dir, exp_name_manual, manual_prompt, limit)
	for i in sets:
		test_folder_path = f"../tests/refined_analysis/natural_bugs/{i}"
		infer_bugs(test_folder_path, file_results_dir,  exp_name_manual, manual_prompt, limit)
	
	
		folder = test_folder_path
		dir = refined_exp_results
		limit = 300
		infer_bugs(folder, dir, limit)
	'''
 

