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
from transformers import LlamaForCausalLM, LlamaTokenizer, GenerationConfig
from peft import PeftConfig, LoraConfig, get_peft_model, PeftModel
from collections import defaultdict
from copy import deepcopy


model = None
tokenizer = None
#lora_param = "sallywww/invariants_ranking"
lora_param = 'sallywww/CoT_llama'

cmd_list = ["wget -q http://ftp.de.debian.org/debian/pool/main/i/icu/libicu63_63.1-6+deb10u3_amd64.deb",
						"wget -q http://ftp.de.debian.org/debian/pool/main/libu/liburcu/liburcu6_0.12.2-1_amd64.deb",
						"wget -q http://mirrors.kernel.org/ubuntu/pool/main/u/ust/liblttng-ust-ctl4_2.11.0-1_amd64.deb",
						"wget -q http://ftp.us.debian.org/debian/pool/main/u/usbutils/usbutils_010-3_amd64.deb",
						"sudo dpkg -i ./libicu63_63.1-6+deb10u3_amd64.deb",
						"sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF",  
						"wget -q https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.ps1", 
						"wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list", 
						"sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list", 
						"sudo apt update", 
						"sudo apt-get install libicu63", 
						"wget -q https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.ps1",
						"wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list", 
						"sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list",
						"sudo apt update",
						"sudo apt-get install libicu63",
						"sudo dpkg -i ./liblttng-ust0_2.11.0-1_amd64.deb",
						"sudo dpkg -i ./libssl1.1_1.1.1f-1ubuntu2_amd64.deb",
						"sudo dpkg -i ./liblttng-ust-ctl4_2.11.0-1_amd64.deb",
						"sudo dpkg -i ./liburcu6_0.12.2-1_amd64.deb",
						"sudo dpkg -i ./usbutils_010-3_amd64.deb",
						"sudo apt-get install aspnetcore-runtime-2.2 -Y",
						"sudo apt-get install dotnet-sdk-2.2",
						"git clone https://github.com/microsoft/verisol.git",           
						"cd verisol/Sources",
						"dotnet build ./verisol/Sources"]

#command for building python wrapper around C# for VeriSol 
def runcmd(cmd, verbose=False, *args, **kwargs):

		process = subprocess.Popen(
				cmd,
				stdout = subprocess.PIPE,
				stderr = subprocess.PIPE,
				text = True,
				shell = True
		)
		std_out, std_err = process.communicate()
		with open('./stdout.txt', 'w') as f:
			f.write(std_out)
		#f.close()
		if verbose:      
				print(std_out.strip(), std_err)

def runcmd_out(cmd, verbose=False, *args, **kwargs):

		process = subprocess.Popen(
				cmd,
				stdout = subprocess.PIPE,
				stderr = subprocess.PIPE,
				text = True,
				shell = True
		)
		std_out, std_err = process.communicate()
		with open('./stdout.txt', 'w') as f:
			f.write(std_out)
		#f.close()
		print(std_out)
		print(std_err)
		if verbose:      
				print(std_out.strip(), std_err)
		return std_out, std_err 
	
def iteratecmd(cmd_list):
				for i in cmd_list: 
								runcmd(i)

def load_trained_llama(model_name):
	global model
	global tokenizer
	peft_model_id = model_name
	config = PeftConfig.from_pretrained(peft_model_id)
	model = LlamaForCausalLM.from_pretrained("sallywww/Llama-7B")
	model = PeftModel.from_pretrained(model, peft_model_id)
	tokenizer = LlamaTokenizer.from_pretrained("sallywww/Llama-7B")
	model.cuda()
	return model, tokenizer

def infer_invariants(model, tokenizer, test_data, \
										 temperature, top_p, top_k, max_new_tokens):
	model.eval()
	inputs = tokenizer(test_data, return_tensors="pt")
	with torch.no_grad():
			outputs = model.generate(input_ids=inputs["input_ids"].cuda(), \
			 temperature=temperature, 
			 top_p=top_p, 
			 top_k=top_k,
			max_new_tokens=max_new_tokens)
			invariants = tokenizer.batch_decode(outputs.detach().cpu().numpy(), skip_special_tokens=True)[0]
	return invariants

def invariants_gen(file, tryAnother=False):
	model, tokenizer = load_trained_llama(model_name=lora_param)
	test_file = open(f'{file}', "r")
	test_data = test_file.read() + "\n" + "What are the critical program points?"
	raw_program_points = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=test_data,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	program_points = test_data[raw_program_points.rfind("What are the critical program points?") + \
	len("What are the critical program points?"):]
	if tryAnother is True: 
		test_data = test_file.read() + "\n" + "What are the secondary invariants?"
		output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=test_data,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
		invariants = test_data[test_data.rfind("What are the secondary invariants?") + \
		len("What are the secondary invariants?"):]    
	return invariants

def invariants_list(invariants_set):
	line_df = [] 
	for line in invariants_set.split(';'):
		line_df.append(line)
	invariants = []
	for i in range(len(line_df)-1): 
			letter_index = 0
			letter = line_df[i][0]
			line_number = ''
			invariant = ''
			while letter != '+':  
				line_number += letter 
				letter_index += 1  
				if letter_index > (len(line_df[i]) - 1):
					break        
				letter = line_df[i][letter_index]        
				if letter_index >= 5:
					line_number = ''        
					break 
			if letter_index >= 5:
				line_number = '' 
				invariant = line_df[i][0:len(line_df[i])] 
			else: 
				invariant = line_df[i][letter_index+1:len(line_df[i])]
			invariants.append([line_number.replace(" ", ""), invariant])
	return invariants

def insert_and_annotate(test_contract, invariants): 
	p = re.compile(r'(\d+)')
	new_template = open(f'./instrumented.sol', "w")
	for line in test_contract.split("\n"): 
			new_template.write(line + '\n')
			for item in invariants:
				item[0]=item[0].replace("\n", "").replace(" ", "")
				if item[0] in p.findall(line[:5]):
					new_template.write("//SmartInv inferred:" + "\n" + item[1]+";" + "\n")         
	new_template.close()

def cleaned_contract(contract_file):
	file = open("./instrumented.sol", 'r')
	filedata = file.read()
	path = os.path.dirname(contract_file)
	final_template = open(f'{path}/cleaned.sol', "w")
	for line in filedata.split("\n"):
		line = line.lstrip("0123456789+")
		final_template.write(line + "\n")
	final_template.close()


def model_guided_verify(contract_file, contract_name, invariants_set, flags):
	start = time.now()
	if flags is None:
		runcmd(f"dotnet /content/verisol/bin/Debug/VeriSol.dll {contract_file} {contract_name} /contractInfer /inlineDepth:100", verbose=True)
	else:
		runcmd(f"dotnet /content/verisol/bin/Debug/VeriSol.dll {contract_file} {contract_name} {flags}", verbose=True)
	with open("./boogie.txt") as f:
		lines = f.readlines()
		for line in lines:
			if "0 error" in f.read():
				print("verification success with the following set of invariants: \n")
				for i in invariants_set:
					print(i)
				end = time.time()
				elapsed = end-start
				print("Verification runtime is: {:0.2f}s".format(elapsed))
				return 1, elapsed
		else:
			with open("./stdout.txt") as out_f:
				lines = out_f.readlines()
				for line in lines:
					if line.find("Transaction Sequence for Defect") != -1:
						print("============================================================================ \n")
						print("vulnerable transaction sequences found with the following verified invariants: \n")
						print("============================================================================ \n")
						for i in invariants_set:
							print(i)
						end = time.time()
						elapsed = end-start
						print("Verification runtime is: {:0.2f}s".format(elapsed))
						return 1, elapsed
				else:
					end = time.time()
					elapsed = end-start
					print("Verification runtime is: {:0.2f}s".format(elapsed))           
					return 0, elapsed	
								
				 
def full_auto_model_guided_verify(contract_file, contract_name, try_flag, flags):
	print("instrumenting contracts...\n")
 # first_invariants = invariants_gen(contract_file, tryAnother=try_flag)
	first_invariants = '\n10+ require(proposal.sTime == 0,"on-going proposal"); \n\n14+ require(proposal.sTime + 2 days > block.timestamp);'
	invariants = invariants_list(first_invariants)
	path = os.path.dirname(contract_file)
	test_file = open(f'{contract_file}', 'r')
	data = test_file.read()
	insert_and_annotate(data, invariants)
	cleaned_contract(contract_file)
	start = time.time()
	if flags is None:
		runcmd(f'dotnet /content/verisol/bin/Debug/VeriSol.dll {path}/cleaned.sol {contract_name} /contractInfer /inlineDepth:100', verbose=True)
	else:
		runcmd(f'dotnet /content/verisol/bin/Debug/VeriSol.dll {path}/cleaned.sol {contract_name} {flags}', verbose=True)
	with open("./boogie.txt") as f:
		lines = f.readlines()
		for line in lines:
			if "0 error" in f.read():
				print("verification success with the following set of invariants: \n")
				for i in invariants:
					print(i)
				end = time.time()
				elapsed = end-start
				print("Verification runtime is: {:0.2f}s".format(elapsed))
				return 1, elapsed
			else:
				with open("./stdout.txt") as out_f:
					lines = out_f.readlines()
					for line in lines:
						if line.find("Transaction Sequence for Defect") != -1:
							 print("============================================================================ \n")
							 print("vulnerable transaction sequences found with the following verified invariants: \n")
							 print("============================================================================ \n")
							 for i in invariants:
								 print(i)
							 end = time.time()
							 elapsed = end-start
							 print("Verification runtime is: {:0.2f}s".format(elapsed))
							 return 1, elapsed
					else:
						end = time.time()
						elapsed = end-start
						print("Verification runtime is: {:0.2f}s".format(elapsed))
						return 0, elapsed

def run_verifier(dir, contract_file, contract_name, verbose=False, *args, **kwargs):
		process = subprocess.Popen(
				f"dotnet ./verisol/bin/Debug/VeriSol.dll {contract_file} {contract_name} /contractInfer /inlineDepth:100",
				stdout = subprocess.PIPE,
				stderr = subprocess.PIPE,
				text = True,
				shell = True
		)
		std_out, std_err = process.communicate()
		if verbose==False:
			if os.path.exists(f"{dir}/{contract_name}") is False:
				os.mkdir(f"{dir}/{contract_name}")
			with open(f"{dir}/{contract_name}_out.txt", 'w+') as f:
				f.write(std_out)
				f.write(std_err)
		#f.close()
		if verbose:      
				print(std_out.strip(), std_err)
		pass                  
if __name__ == "__main__":
	print("installing SmartInv verifier...")
	#iteratecmd(cmd_list)
	#test runcmd of a single instrumented contract below:  
	#print(invariants_gen("./timecontroller.sol"))
	runcmd("dotnet ./verisol/bin/Debug/VeriSol.dll ./timecontroller.sol TimelockController /contractInfer /inlineDepth:100", verbose=True)
	'''
	if len(sys.argv) < 3:
		print("please provide contract file and contract name at least.")
		print("possible flags: --file --contract, [optional]all VeriSol flags are also supported.")
	parser = argparse.ArgumentParser()
	parser.add_argument('--file', type=str, required=True, default='')
	parser.add_argument('--contract', type=str, required=True, default='')
	parser.add_argument('--auto', type=bool, required=False, default=False)
	parser.add_argument('--VeriSol', type=str, required=False,  default=None)
	args = parser.parse_args()
	#invariants_set = invariants_gen(args.file)
	invariants_set = [['\n10', '  require(proposal.sTime == 0,"on-going proposal")'], ['\n\n14', '  require(proposal.sTime + 2 days > block.timestamp, "execution has ended")'], ['\n\n15', '  votingToken.transferFrom(\n16+  msg.sender, address(this), amount)'], ['\n\n20', '  require(proposal.sTime != 0, "no proposal")'], ['\n20', '  require(proposal.sTime + 2 days < \n21+ block.timestamp, "execution has not ended")'], ['\n20', '  require(votingToken.balanceOf(address(this))*2 >\n22+ votingToken.totalSupply(), "execution failed")'], ['\n20', '  assert(votingToken.balanceOf(address(this))==votingToken.balanceOf(address(this))*2)'], ['', '\n\n\n\n\nWhat are the critical invariants?\n15+  require(proposal.sTime != 0, "no proposal")'], ['\n15', '  require(proposal.sTime + 2 days > block.timestamp, "execution has ended")'], ['', '\n\n\nWhat are the critical invariants?\n14+  require(proposal.sTime + 2 days > block.timestamp, "execution has ended")'], ['\n15', '  votingToken.transferFrom(\n16+  msg.sender, address(this), amount)'], ['\n\n20', '  require(proposal.sTime != 0, "no proposal")'], ['\n20', '  require(proposal.sTime + 2 days < \n21+ block.timestamp, "execution has not ended")'], ['\n20', '  require(votingToken.balanceOf(address(this))*2 >\n22+ votingToken.totalSupply(), "execution failed")'], ['\n20', '  assert(votingToken.balanceOf(address(this))==votingToken.balanceOf(address(this))*2)'], ['', '\n\nWhat are the non-critical invariants?\n10+  require(proposal.sTime == 0,"on-going proposal")']]
	print("===================================== \n")
	print("initial critical invariants set report\n")
	print("===================================== \n")
	for invariant in invariants_set:
		print(invariant)
	if args.auto is False: 
		output1, runtime1 = model_guided_verify(args.file, args.contract, invariants_set, args.VeriSol)
		if (output1==0):
		 print("We can't concretely prove or disapprove with this set of invariant...\n")
		 print("Let's ask the model for a secondary set.\n")	
		 secondary_invariants = invariants_gen(args.file, tryAnother=True)
		 print("======================================= \n")
		 print("secondary critical invariants set report\n")
		 print("======================================= \n")
		 for i in secondary_invariants:
			print(i)
	if args.auto is True: 			
		output2, runtime2 = full_auto_model_guided_verify(args.file, args.contract, try_flag=False, flags=args.VeriSol)
		if (output2==0):
			print("We can't concretely prove or disapprove with this set of invariant...\n")
			print("Let's ask the model for a secondary set.\n")	
			print("auto verifying secondary invariants...\n")
			full_auto_model_guided_verify(args.file, args.contract, try_flag=True, flags=args.VeriSol)
	'''