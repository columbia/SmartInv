import argparse
import os
import shutil
import sys
import subprocess
import argparse
import random
import time
import re
import torch
import numpy as np
import transformers
import pandas as pd
import openai
from openai import OpenAI
from transformers import LlamaForCausalLM, LlamaTokenizer, GenerationConfig
from peft import PeftConfig, LoraConfig, get_peft_model, PeftModel
from verifier.infer import (
	results_dir,
	pp_dir, 
	inv_dir,
	criticalInv_dir,
	rankedInv_dir, 
	vul_dir, 
	load_trained_llama, 
	infer_invariants, 
	infer_tier1_context_single_contract,
	prune_for_context,
	prune_for_pp,
	find_invariants,
	prune_for_inv,
	find_critical_invariants,
	prune_for_critical_inv,
	find_vulnerabilities,
	invariants_list,
	insert_and_annotate,
	cleaned_contract,
)
from verifier.infer_upgrade import (
	light_results,
	prompt_exp_results,
	find_program_points,
	find_invariants,
	find_bugs_light_mode, 
	infer_bugs  	
)
from verifier.verify import (
	cmd_list,
	iteratecmd,  
	runcmd,
	runcmd_out, 
	run_verifier, 
)

model = None
tokenizer = None
updated_tot_param = 'sallywww/tot_llama_update'
verified_dir = "./verified_results"
large_exp_results_dir = "./large_exp_results"
refined_exp_results = "./refined_exp_results"
light_sampled_results = "/home/sallyjunsongwang/SmartInv/all_results/sampled_results"
client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
manual_time_budget = 150



def parse_arguments(args):
	parser = argparse.ArgumentParser(sys.argv[0])
	parser.add_argument('--file', type=str, required=False, default='')
	parser.add_argument('--contract', type=str, required=False, default='')
	parser.add_argument('--exp1', type=bool, required=False, default=False)
	parser.add_argument('--exp2', type=bool, required=False, default=False)
	parser.add_argument('--large_exp', type=bool, required=False, default=False)
	parser.add_argument('--refined_exp', type=bool, required=False, default=False)
	parser.add_argument('--prompt_exp', type=bool, required=False, default=False)
	parser.add_argument('--ablation_exp', type=bool, required=False, default=False)
	parser.add_argument('--runtime_exp', type=bool, required=False, default=False)
	parser.add_argument('--light', type=bool, required=False, default=True)
	parser.add_argument('--heavy', type=bool, required=False, default=False)
	parser.add_argument('--verify', type=bool, required=False, default=False)
	parser.add_argument('--auto', type=bool, required=False, default=False)
	parser.add_argument('--VeriSol', type=str, required=False,  default=None)
	args = parser.parse_args()
	return parser.parse_args()


def clean_paths(verified_dir, contract_name):
	if os.path.isfile("./__SolToBoogieTest_out.bpl"):
		runcmd(f"mv __SolToBoogieTest_out.bpl {verified_dir}/{contract_name}")
	if os.path.isfile("./boogie.txt"):
		runcmd(f"mv boogie.txt {verified_dir}/{contract_name}")
	if os.path.isfile("./corral.txt"):
		runcmd(f"mv corral.txt {verified_dir}/{contract_name}")
	if os.path.isfile("./corral_counterex.txt"):
		runcmd(f"mv corral_counterex.txt {verified_dir}/{contract_name}")
	if os.path.isfile("./corral_out.bpl"):
		runcmd(f"mv corral_out.bpl {verified_dir}/{contract_name}")
	if os.path.isfile("./corral_out_trace.txt"):
		runcmd(f"mv corral_out_trace.txt {verified_dir}/{contract_name}")
	if os.path.isfile("./stdout.txt"):
		runcmd(f"mv stdout.txt {verified_dir}/{contract_name}")

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
			x = item
			name_list.append(x)             

	final = []
	for breakdown in name_list:
		for each in breakdown.split(','):
			final.append(each)
	return final
 
def run_experiment1():
	install_script = "./dotnet-install.ps1"
	contract_file = "verifier/visor.sol"
	contract_name = "simplifiedVisor"
	if os.path.exists(install_script) is False:
		print("installing SmartInv verifier...")
		iteratecmd(cmd_list)
	if os.path.exists(verified_dir) is False:
		os.mkdir(verified_dir)
	run_verifier(verified_dir, contract_file, contract_name)
	clean_paths(verified_dir, contract_name)
	
def run_experiment2():
	install_script = "./dotnet-install.ps1"
	contract_file = "verifier/timecontroller_fix_inv.sol"
	contract_name = "TimelockController"
	if os.path.exists(install_script) is False:
		print("installing SmartInv verifier...")
		iteratecmd(cmd_list)
	if os.path.exists(verified_dir) is False:
		os.mkdir(verified_dir)
	run_verifier(verified_dir, contract_file, contract_name)
	clean_paths(verified_dir, contract_name)

def run_verisol(large_exp_results_dir, contract_file, filename):
	auto_compiler_detect(contract_file)
	install_script = "./dotnet-install.ps1"
	if os.path.exists(install_script) is False:
		print("installing SmartInv verifier...")
		iteratecmd(cmd_list)
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/verisol")) is False:
		os.mkdir(f"{large_exp_results_dir}/verisol")
	if (os.path.isdir(f"{large_exp_results_dir}/verisol/{filename}")) is False:
		os.mkdir(f"{large_exp_results_dir}/verisol/{filename}")
	results_dir = f"{large_exp_results_dir}/verisol/{filename}"
	name_list = extract_name(contract_file)
	for name in name_list: 
		run_verifier(large_exp_results_dir, contract_file, name, verbose=True)
	clean_paths(results_dir, contract_file)

def run_slither(large_exp_results_dir, contract_file, filename):
	auto_compiler_detect(contract_file)
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/slither")) is False:
		os.mkdir(f"{large_exp_results_dir}/slither")
	if (os.path.isdir(f"{large_exp_results_dir}/slither/{filename}")) is False:
		os.mkdir(f"{large_exp_results_dir}/slither/{filename}")
	results_dir = f"{large_exp_results_dir}/slither/{filename}"
	std_out, std_err = runcmd_out(f"slither {contract_file}")
	result_file = open(f"{results_dir}/report", "w+")
	result_file.write(std_out)
	result_file.write(std_err)
	result_file.close()

	
	
def auto_compiler_detect(contract_file):
	file = open(contract_file, "r")
	if "pragma solidity ^0.4" in file.read(): 
		runcmd("solc-select install 0.4.0")
		runcmd("solc-select use 0.4.0")
	elif "pragma solidity ^0.5" in file.read():
		runcmd("solc-select install 0.5.0") 
		runcmd("solc-select use 0.5.0")
	elif "pragma solidity ^0.6" in file.read():
		runcmd("solc-select install 0.6.0")  
		runcmd("solc-select use 0.6.0")
	elif "pragma solidity ^0.7" in file.read():
		runcmd("solc-select install 0.7.0")  
		runcmd("solc-select use 0.7.0")
	elif "pragma solidity ^0.8" in file.read():
		runcmd("solc-select install 0.8.0") 
		runcmd("solc-select use 0.8.0")
		
	
def run_veriSmart(large_exp_results_dir, contract_file, filename):
	auto_compiler_detect(contract_file)
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/veriSmart")) is False:
		os.mkdir(f"{large_exp_results_dir}/veriSmart")
	if (os.path.isdir(f"{large_exp_results_dir}/veriSmart/{filename}")) is False:
		os.mkdir(f"{large_exp_results_dir}/veriSmart/{filename}")
	results_dir = f"{large_exp_results_dir}/veriSmart/{filename}"
	std_out, std_err = runcmd_out(f"~/VeriSmart-public/main.native -input {contract_file} -verify_timeout 60 -z3timeout 10000")
	result_file = open(f"{results_dir}/report", "w+")
	result_file.write(std_out)
	result_file.write(std_err)
	result_file.close()
	
def run_smartest(large_exp_results_dir, contract_file, filename):
	auto_compiler_detect(contract_file)
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/smartest")) is False:
		os.mkdir(f"{large_exp_results_dir}/smartest")
	if (os.path.isdir(f"{large_exp_results_dir}/smartest/{filename}")) is False:
		os.mkdir(f"{large_exp_results_dir}/smartest/{filename}")
	results_dir = f"{large_exp_results_dir}/smartest/{filename}"
	std_out, std_err = runcmd_out(f"~/VeriSmart-public/main.native -input {contract_file} -mode exploit -exploit_timeout 10000 leak")
	result_file = open(f"{results_dir}/report", "w+")
	result_file.write(std_out)
	result_file.write(std_err)
	result_file.close()

def run_mythril(large_exp_results_dir, contract_file, filename):
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/mythril")) is False:
		os.mkdir(f"{large_exp_results_dir}/mythril")
	if (os.path.isdir(f"{large_exp_results_dir}/mythril/{filename}")) is False:
		os.mkdir(f"{large_exp_results_dir}/mythril/{filename}")
	results_dir = f"{large_exp_results_dir}/mythril/{filename}"
	runcmd("docker pull mythril/myth")
	std_out, std_err = runcmd_out(f"docker run -v $(pwd):/tmp mythril/myth analyze /tmp/{contract_file}")
	result_file = open(f"{results_dir}/report", "w+")
	result_file.write(std_out)
	result_file.write(std_err)
	result_file.close()

def run_manticore(large_exp_results_dir, contract_file, filename):
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/manticore")) is False:
		os.mkdir(f"{large_exp_results_dir}/manticore")
	if (os.path.isdir(f"{large_exp_results_dir}/manticore/{filename}")) is False:
		os.mkdir(f"{large_exp_results_dir}/manticore/{filename}")
	results_dir = f"{large_exp_results_dir}/manticore/{filename}"
	std_out, std_err = runcmd_out(f"manticore {contract_file}")
	result_file = open(f"{results_dir}/report", "w+")
	result_file.write(std_out)
	result_file.write(std_err)
	result_file.close()
		
def run_large_scale_exp():
	test_dir = "/home/sallyjunsongwang/SmartInv/tests/contracts"
	for filename in os.listdir(test_dir):
		contract_file = os.path.join(test_dir, filename)
		run_verisol(large_exp_results_dir, contract_file, filename)
		run_slither(large_exp_results_dir, contract_file, filename)
		#comment out the run_mythril, run_manticore, run_veriSmart and run_smartest for linux machine, unless you get 
		#verismart working on linux; only use the following two commands on MacOS 
		#the following command has to be in the test_dir, not outside it
		run_mythril(large_exp_results_dir, contract_file, filename)
		run_veriSmart(large_exp_results_dir, contract_file, filename)
		run_smartest(large_exp_results_dir, contract_file, filename)
		run_manticore(large_exp_results_dir, contract_file, filename)

def run_refined_exp():
	smartinv_exp_name = "smartinv"
	smartinv_prompt = "smartinv_functionalbug.txt"
	line_limit = 300
	file_results_dir = refined_exp_results
	audited_bug_folder_path = f"/home/sallyjunsongwang/SmartInv/tests/refined_analysis/additional_audited_bugs"
	if (os.path.isdir(file_results_dir)) is False:
		os.mkdir(file_results_dir)
	for root, dirs, files in os.walk(audited_bug_folder_path):
		for filename in files:
			if ".sol" not in filename:
				break
			contract_file = os.path.join(root, filename)			
			run_verisol(file_results_dir, contract_file, filename)
			run_slither(file_results_dir, contract_file, filename)
			#infer_bugs(audited_bug_folder_path, file_results_dir, smartinv_exp_name, smartinv_prompt, line_limit) 
				#comment out the run_mythril, run_manticore, run_veriSmart and run_smartest for linux machine, unless you get 
				#verismart working on linux; only use the following two commands on MacOS 
				#the following command has to be in the test_dir, not outside it
			run_mythril(file_results_dir, contract_file, filename)
			#run_veriSmart(file_results_dir, contract_file, filename)
			#run_smartest(file_results_dir, contract_file, filename)
			#run_manticore(file_results_dir, contract_file, filename)			
	sets = ["set1", "set2", "set3"]
	for i in sets:
		test_folder_path = f"/home/sallyjunsongwang/SmartInv/tests/refined_analysis/natural_bugs/{i}"
		for root, dirs, files in os.walk(audited_bug_folder_path):
			for filename in files:
				if ".sol" not in filename:
					break
				contract_file = os.path.join(root, filename)
				run_verisol(file_results_dir, contract_file, filename)
				run_slither(file_results_dir, contract_file, filename)
				#infer_bugs(test_folder_path, file_results_dir, smartinv_exp_name, smartinv_prompt, line_limit) 					
				#comment out the run_mythril, run_manticore, run_veriSmart and run_smartest for linux machine, unless you get 
				#verismart working on linux; only use the following two commands on MacOS 
				#the following command has to be in the test_dir, not outside it
				run_mythril(file_results_dir, contract_file, filename)
				#run_veriSmart(file_results_dir, contract_file, filename)
				#run_smartest(file_results_dir, contract_file, filename)
				#run_manticore(file_results_dir, contract_file, filename)

def run_prompt_exp():
	sets = ["set1", "set2", "set3"]
	file_results_dir = prompt_exp_results
	gptscan_exp_name = "gptscan"
	gpt_exp_name = "gpt"
	gpt_prompt = "gpt.txt"
	audit_exp_name = "manual_audit"
	audit_prompt = "manual_audit.txt"
	smartinv_exp_name = "smartinv"
	smartinv_prompt = "smartinv_functionalbug.txt"
	sets = ["set1", "set2", "set3"]
	file_results_dir = prompt_exp_results
	exp_name = "gpt"
	prompt = "gpt.txt"
	line_limit = 300
	audited_bug_folder_path = f"../tests/refined_analysis/additional_audited_bugs"
	infer_bugs(audited_bug_folder_path, file_results_dir, gpt_exp_name, gpt_prompt, line_limit)
	infer_bugs(audited_bug_folder_path, file_results_dir, gptscan_exp_name, gpt_prompt, line_limit)
	infer_bugs(audited_bug_folder_path, file_results_dir, audit_exp_name, audit_prompt, line_limit) 
	infer_bugs(audited_bug_folder_path, file_results_dir, smartinv_exp_name, smartinv_prompt, line_limit) 

	for i in sets:
		test_folder_path = f"../tests/refined_analysis/natural_bugs/{i}"
		infer_bugs(test_folder_path, file_results_dir, gpt_exp_name, gpt_prompt, line_limit) 
		infer_bugs(test_folder_path, file_results_dir, audit_exp_name, audit_prompt, line_limit) 
		infer_bugs(test_folder_path, file_results_dir, smartinv_exp_name, smartinv_prompt, line_limit) 
		infer_bugs(test_folder_path, file_results_dir, gptscan_exp_name, gpt_prompt, line_limit)

def run_ablation_exp():
	pass

def run_runtime_exp():
	pass

def run_heavy_SmartInv(contract_file, filename, verify=False): 
	assert(os.path.exists(contract_file))
	vul = ""
	param = updated_tot_param  
	infer_tier1_context_single_contract(contract_file)
	pruned_contexts = prune_for_context(filename)
	time, pp = find_program_points(contract_file, filename, pp_dir, param)
	_, pruned_pp = prune_for_pp(filename)
	time2, inv = find_invariants(contract_file, contract_name, inv_dir, param)
	_, pruned_inv = prune_for_inv(filename)
	time3, criticalInv = find_critical_invariants(contract_file, contract_name, criticalInv_dir, param)
	time4, vul = find_vulnerabilities(contract_file, contract_name, vul_dir, param)
	_, pruned_criticalInv = prune_for_critical_inv(filename)
	#TODO: add further upgraded implementation for ranked critical inv
	post_processed_inv = invariants_list(pruned_inv)
	insert_and_annotate(contract_file, filename, post_processed_inv)
	cleaned_contract(filename)
	if verify == True:
		run_verisol(f"../verifier/cleaned_{filename}", filename)
	print("===============final report========================\n")
	print(f"inferred invariants are: {inv}\n")
	print(f"inferred critical invariants are: {criticalInv}\n")
	contract_name = filename.replace(".sol", "")
	if os.path.exists({verified_dir}/{contract_name}) == False:
		print(f"inferred vulnerabilities are: {vul}\n")
	print(f"If verifier is enabled, verification proof is saved at {verified_dir}/{contract_name}\n")
	 

def run_light_SmartInv(contract_file, filename, verify=False):
	find_program_points(contract_file, filename)
	find_invariants(contract_file, filename)
	find_bugs_light_mode(contract_file, filename)
	inv_path = os.path.join(light_results, f"{filename}_inv.txt")  
	bug_path = os.path.join(light_results, f"{filename}_bug.txt")
	if verify == True:
		invFile = open(inv_path, "r")
		inv = invFile.read()
		if os.path.exists(inv_path) == True:
			insert_and_annotate(contract_file, filename, inv)
			cleaned_contract(filename)
		else:
			print("not possible to verify, due to lack of inferred invariants file.")
		run_verisol(light_results, f"../verifier/cleaned_{filename}", filename)
		print("===============final report========================\n")
		print(f"inferred invariants are: {inv}\n")
		contract_name = filename.replace(".sol", "")
		if os.path.exists({verified_dir}/{contract_name}) == False and os.path.exists(bug_path) == True:
			vul = open(bug_path, "r")
			print(f"inferred vulnerabilities are: {vul}\n")
		print(f"If verifier is enabled, verification proof is saved at {verified_dir}/{contract_name}\n")
			


def main():
	args = parse_arguments(sys.argv[1:])
	if args.exp1 == True: 
		run_experiment1()	
	if args.exp2 == True: 
		run_experiment2()
	if args.exp2 == True: 
		run_experiment2()
	if args.large_exp == True:
		run_large_scale_exp()
	if args.refined_exp == True:
		run_refined_exp()
	if args.prompt_exp == True:
		run_prompt_exp()
	if args.ablation_exp == True:
		run_ablation_exp()
	if args.runtime_exp == True:
		run_runtime_exp()
	if args.heavy == True:
		run_heavy_SmartInv(args.file, args.contract, args.verify)
	if args.light == True:
		run_light_SmartInv(contract_file, filename, args.verify)

	
if __name__ == "__main__":
	main()
	#uncomment the code below to run smartInv light mode on some sample outputs
	'''
	sets = ["set1", "set2", "set3"]
	for i in sets:
		test_folder_path = f"/home/sallyjunsongwang/SmartInv/tests/refined_analysis/natural_bugs/{i}/instrumented"
		for root, _, files in os.walk(test_folder_path):
			for filename in files:
				print(filename)
				contract_file = os.path.join(root, filename)
				run_light_SmartInv(contract_file, filename, False)
	sample_folder = f"/home/sallyjunsongwang/SmartInv/tests/sample_test/instrumented"
	for root, _, files in os.walk(sample_folder):
		for filename in files:
			print(filename)
			contract_file = os.path.join(root, filename)
			run_light_SmartInv(contract_file, filename, False)
	'''
	
