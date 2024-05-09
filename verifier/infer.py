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

model = None
tokenizer = None
#lora_param = "sallywww/invariants_ranking"
lora_param = 'sallywww/CoT_llama'
tot_param = 'sallywww/tot_llama'
updated_tot_param = 'sallywww/tot_llama_update'
inv_only_param = 'sallywww/invonly'
results_dir = '../all_results/sampled_results/contexts'
pp_dir = '../all_results/sampled_results/pp'
inv_dir = '../all_results/sampled_results/inv'
criticalInv_dir = '../all_results/sampled_results/criticalInv'
rankedInv_dir = '../all_results/sampled_results/rankedInv'
vul_dir = '../all_results/sampled_results/vul'
large_exp_results_dir = "./large_exp_results"
refined_exp_results = "./refined_exp_results"
client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))

def load_trained_llama(model_name):
	global model
	global tokenizer
	peft_model_id = model_name
	config = PeftConfig.from_pretrained(peft_model_id)
	model = LlamaForCausalLM.from_pretrained("sallywww/Llama-7B")
	model = PeftModel.from_pretrained(model, peft_model_id)
	tokenizer = LlamaTokenizer.from_pretrained("sallywww/Llama-7B")
	#the line below is optional, depending on your hardware
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
			torch.cuda.empty_cache()
	return invariants

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


def invariants_gen_one_session(file, results_dir, param, model, tokenizer):
	file_tuple = os.path.splitext(file)
	file_name = file_tuple[0]
	file_results_dir = os.path.join(results_dir, file_name)
	result_file_path = os.path.join(file_results_dir, "raw_output_onesession.txt")
	if (os.path.isdir(results_dir)) is False:
		os.mkdir(results_dir)
	if (os.path.isdir(file_results_dir)) is False:
		os.mkdir(file_results_dir)
	result_file = open(f'{result_file_path}', "w+")
	test_file = open(f'{file}', "r")
	tier_1A = test_file.read() + "\n" + "What's the transaction context of the contract?" + "\n"
	start_tier_1A = time.time()
	tier_1A_output = infer_invariants(model=model,
													tokenizer=tokenizer,
													test_data=tier_1A,
													temperature=None,
													top_p=None,
													top_k=None,
													max_new_tokens=512)
	print(f"tier_1A_output: {tier_1A_output}\n")
	end_tier_1A = time.time()
	tier_1A_runtime = end_tier_1A - start_tier_1A
	'''
	context = tier_1A_output[tier_1A_output.rfind("What's the transaction context of the contract?\n") + \
	len("What's the transaction context of the contract?\n"):]
	print(f"context: {context}\n")
	'''
	#tier_1B = test_file.read() + "\n" + "Given transaction context " + str(context)+ \
	#					"What are the critical program points?" + "\n"
	tier_1B = "What are the critical program points?" + "\n"
	start_tier_1B = time.time()
	tier_1B_output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=tier_1B,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	end_tier_1B = time.time()
	print(f"tier_1B_output: {tier_1B_output}\n")
	tier_1B_runtime = end_tier_1B - start_tier_1B
	'''
	program_points = tier_1B_output[tier_1B_output.rfind("Given transaction context " + str(context)+ \
										"What are the critical program points?\n") + \
										len("Given transaction context " + str(context)+ \
										"What are the critical program points?\n"):]
	print(f"program_points: {program_points}\n")
	tier_2A = test_file.read() + "\n" + "Given inferred critical program points " + str(program_points) + \
										"what are the invariants?" + "\n"
	'''
	tier_2A = "Given inferred critical program points, what are the invariants?" + "\n"
	start_tier_2A = time.time()
	tier_2A_output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=tier_2A,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	print(f"tier_2A_output: {tier_2A_output}\n")
	end_tier_2A = time.time()
	tier_2A_runtime = end_tier_2A - start_tier_2A
	'''
	invariants = tier_2A_output[tier_2A_output.rfind("Given inferred critical program points " + str(program_points) + \
										"what are the invariants?\n") +                    
										len("Given inferred critical program points " + str(program_points) + \
										"what are the invariants?\n"):]
	print(f"invariants: {invariants}\n")

	tier_2B = test_file.read() + "\n" + "Given inferred invariants " + str(invariants) + \
										"what are the critical invariants?" + "\n"
	'''
	tier_2B =  "Given inferred invariants, what are the critical invariants?" + "\n"
	start_tier_2B = time.time()
	tier_2B_output = infer_invariants(model=model,
				   tokenizer=tokenizer, 
				   test_data=tier_2B,
				   temperature=None, 
				   top_p=None, 
				   top_k=None,
				   max_new_tokens=512)													
	end_tier_2B = time.time()
	print(f"tier_2B_output: {tier_2B_output}\n")
	tier_2B_runtime = end_tier_2B - start_tier_2B
	'''
	critical_invariants = tier_2B_output[tier_2B_output.rfind("Given inferred invariants " + str(invariants) + \
										"what are the critical invariants?\n") +                    
										len("Given inferred invariants " + str(invariants) + \
										"what are the critical invariants?\n"):]
	print(f"critical_invariants: {critical_invariants}\n")
	
	tier_3A = test_file.read() + "\n" + "Given inferred invariants " + str(invariants) + \
										"what are the critical invariants?" + "\n"
	'''
	tier_3A = "Given inferred invariants, what are the ranks of critical invariants?" + "\n"
	start_tier_3A = time.time()
	tier_3A_output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=tier_3A,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	print(f"tier_3A_output: {tier_3A_output}\n")
	end_tier_3A = time.time()
	tier_3A_runtime = end_tier_3A - start_tier_3A
	'''
	ranked_critical_invariants = tier_3A_output[tier_3A_output.rfind("Given inferred critical invariants "  + str(invariants) + \
										"what are the ranks of inferred critical invariants?\n") +                    
										len("Given inferred critical invariants "  + str(invariants) + \
										"what are the ranks of inferred critical invariants?\n"):]
	print(f"ranked_critical_invariants: {ranked_critical_invariants}\n")
	'''
	tier_3B = test_file.read() + "\n" + "What are the vulnerabilities in the contract?" + "\n"
	if param is updated_tot_param: 
		start_tier_3B = time.time()
		tier_3B_output = infer_invariants(model=model, 
														tokenizer=tokenizer, 
														test_data=tier_3B,
														temperature=None, 
														top_p=None, 
														top_k=None,
														max_new_tokens=512)
		end_tier_3B = time.time()
		tier_3B_runtime = end_tier_3B - start_tier_3B
		bugs = tier_3B_output[tier_3B_output.rfind("What are the vulnerabilities in the contract?\n") +                    
											len("What are the vulnerabilities in the contract?\n"):]
	tier_3B = test_file.read() + "\n" + "Please study the smart contract and understand the code carefully. Please find potential bugs in the contract if there is any." + \
						"if there is no bug, please answer healthy. You are allowed to identify and generate bugs in the smart contract code only.\n"
	start_tier_3B = time.time()
	bugs = gpt_infer(tier_3B)
	end_tier_3B = time.time()
	tier_3B_runtime = end_tier_3B - start_tier_3B
	avg_runtime = float(tier_1A_runtime + tier_1B_runtime + tier_2A_runtime + \
						tier_2B_runtime + tier_3A_runtime + tier_3B_runtime)/6
	runtime = "{:.2f}".format(avg_runtime)
	result_file.write(f"<context> + \n + {tier_1A_output} + \n + \
											<program points> + \n + {tier_1B_output} + \n + \
											<invariants> + \n + {tier_2A_output} + \n + \
											<critical invariants> + \n + {tier_2B_output} + \n + \
											<potential bugs> + \n + {bugs} + \n + \
											")
	result_file.close()
	return tier_1A_output, \
	tier_1B_output, \
	tier_2A_output, \
	tier_2B_output, \
	tier_3A_output, \
	bugs, \
	avg_runtime, \
	runtime
	'''
	return context, \
	program_points, \
	invariants, \
	critical_invariants, \
	ranked_critical_invariants, \
	bugs, \
	avg_runtime, \
	runtime
	'''


def invariants_gen_refreshed(file, results_dir, param):
	model, tokenizer = load_trained_llama(param)
	file_tuple = os.path.splitext(file)
	file_name = file_tuple[0]
	file_results_dir = os.path.join(results_dir, file_name)
	result_file_path = os.path.join(file_results_dir, "raw_output_refreshed.txt")
	if (os.path.isdir(results_dir)) is False:
		os.mkdir(results_dir)
	if (os.path.isdir(file_results_dir)) is False:
		os.mkdir(file_results_dir)
	result_file = open(f'{result_file_path}', "w+")
	test_file = open(f'{file}', "r")
	tier_1A = test_file.read() + "\n" + "What's the transaction context of the contract?" + "\n"
	start_tier_1A = time.time()
	tier_1A_output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=tier_1A,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	print(tier_1A)
	print(tier_1A_output)
	end_tier_1A = time.time()
	tier_1A_runtime = end_tier_1A - start_tier_1A
	context = tier_1A_output[tier_1A_output.rfind("What's the transaction context of the contract?\n") + \
	len("What's the transaction context of the contract?\n"):]
	tier_1B = test_file.read() + "\n" + "Given transaction context " + str(context)+ \
										"What are the critical program points?" + "\n"
	del model
	del tokenizer
	model, tokenizer = load_trained_llama(param)
	start_tier_1B = time.time()
	tier_1B_output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=tier_1B,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	print(tier_1B)
	print(tier_1B_output)
	end_tier_1B = time.time()
	tier_1B_runtime = end_tier_1B - start_tier_1B
	program_points = tier_1B_output[tier_1B_output.rfind("Given transaction context " + str(context)+ \
										"What are the critical program points?\n") + \
										len("Given transaction context " + str(context)+ \
										"What are the critical program points?\n"):]
	tier_2A = test_file.read() + "\n" + "Given inferred critical program points " + str(program_points) + \
										"what are the invariants?" + "\n"
	del model
	del tokenizer
	model, tokenizer = load_trained_llama(param)
	start_tier_2A = time.time()
	tier_2A_output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=tier_2A,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	print(tier_2A)
	print(tier_2A_output)
	end_tier_2A = time.time()
	tier_2A_runtime = end_tier_2A - start_tier_2A
	invariants = tier_2A_output[tier_2A_output.rfind("Given inferred critical program points " + str(program_points) + \
										"what are the invariants?\n") +                    
										len("Given inferred critical program points " + str(program_points) + \
										"what are the invariants?\n"):]
	tier_2B = test_file.read() + "\n" + "Given inferred invariants " + str(invariants) + \
										"what are the critical invariants?" + "\n"
	del model
	del tokenizer
	model, tokenizer = load_trained_llama(param)
	start_tier_2B = time.time()
	tier_2B_output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=tier_2B,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	end_tier_2B = time.time()
	print(tier_2B)
	print(tier_2B_output)
	tier_2B_runtime = end_tier_2B - start_tier_2B
	critical_invariants = tier_2B_output[tier_2B_output.rfind("Given inferred invariants " + str(invariants) + \
										"what are the critical invariants?\n") +                    
										len("Given inferred invariants " + str(invariants) + \
										"what are the critical invariants?\n"):]
	tier_3A = test_file.read() + "\n" + "Given inferred invariants " + str(invariants) + \
										"what are the critical invariants?" + "\n"
	del model
	del tokenizer
	model, tokenizer = load_trained_llama(param)
	start_tier_3A = time.time()
	tier_3A_output = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=tier_3A,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	end_tier_3A = time.time()
	tier_3A_runtime = end_tier_3A - start_tier_3A
	ranked_critical_invariants = tier_3A_output[tier_3A_output.rfind("Given inferred critical invariants "  + str(invariants) + \
										"what are the ranks of inferred critical invariants?\n") +                    
										len("Given inferred critical invariants "  + str(invariants) + \
										"what are the ranks of inferred critical invariants?\n"):]
	if param is updated_tot_param: 
		del model
		del tokenizer
		model, tokenizer = load_trained_llama(param)
		tier_3B = test_file.read() + "\n" + "What are the vulnerabilities in the contract?" + "\n"
		start_tier_3B = time.time()
		tier_3B_output = infer_invariants(model=model, 
														tokenizer=tokenizer, 
														test_data=tier_3B,
														temperature=None, 
														top_p=None, 
														top_k=None,
														max_new_tokens=512)
		end_tier_3B = time.time()
		tier_3B_runtime = end_tier_3B - start_tier_3B
		bugs = tier_3B_output[tier_3B_output.rfind("What are the vulnerabilities in the contract?\n") +                    
											len("What are the vulnerabilities in the contract?\n"):]
	tier_3B = test_file.read() + "\n" + "Please study the smart contract and understand the code carefully. Please find potential bugs in the contract if there is any." + \
						"if there is no bug, please answer healthy. You are allowed to identify and generate bugs in the smart contract code only.\n"
	start_tier_3B = time.time()
	bugs = gpt_infer(tier_3B)
	end_tier_3B = time.time()
	tier_3B_runtime = end_tier_3B - start_tier_3B
	avg_runtime = float(tier_1A_runtime + tier_1B_runtime + tier_2A_runtime + \
						tier_2B_runtime + tier_3A_runtime + tier_3B_runtime)/6
	runtime = "{:.2f}".format(avg_runtime)
	result_file.write(f"<context> + \n + {tier_1A_output} + \n + \
	 <program points> + \n + {tier_1B_output} + \n + \
		 <invariants> + \n + {tier_2A_output} + \n + \
			 <critical invariants> + \n + {tier_2B_output} + \n + \
				 <potential bugs> + \n + {bugs} + \n")
	result_file.close()
	return context, \
	program_points, \
	invariants, \
	critical_invariants, \
	ranked_critical_invariants, \
	bugs, \
	avg_runtime, \
	runtime

def simple_invariants_gen(file, results_dir, tryAnother=False):
	file_tuple = os.path.splitext(file)
	file_name = file_tuple[0]
	file_results_dir = os.path.join(results_dir, file_name)
	result_file_path = os.path.join(file_results_dir, "raw_output_simple.txt")
	if (os.path.isdir(results_dir)) is False:
		os.mkdir(results_dir)
	if (os.path.isdir(file_results_dir)) is False:
		os.mkdir(file_results_dir)
	result_file = open(f'{result_file_path}', "w+")
	test_file = open(f'{file}', "r")
	test_data = test_file.read() + "\n" + "What are the critical program points?"
	print(f"test_data: {test_data}\n")
	raw_program_points = infer_invariants(model=model, 
													tokenizer=tokenizer, 
													test_data=test_data,
													temperature=None, 
													top_p=None, 
													top_k=None,
													max_new_tokens=512)
	print(f"{raw_program_points}\n")
	program_points = raw_program_points[raw_program_points.rfind("What are the critical program points?") + \
	len("What are the critical program points?"):]
	test_data_2 = test_file.read() + "\n" + f"Given inferred program points{program_points}, what are the invariants?\n"
	raw_invariants = infer_invariants(model=model,
				   tokenizer=tokenizer,
				   test_data=test_data_2,
				   temperature=None, 
				   top_p=None, 
				   top_k=None,
				   max_new_tokens=512)
	invariants = 	raw_program_points[raw_invariants.rfind(f"Given inferred program points{program_points}, what are the invariants?\n") + \
	len(f"Given inferred program points{program_points}, what are the invariants?\n"):] 
	result_file.write(f"<program points> + \n + {raw_program_points} + \n + \<invariants> + \n + {raw_invariants} + \n")
	result_file.close()
	if tryAnother is True: 
		test_data = test_file.read() + "\n" + "What are the critical invariants?"
		output = infer_invariants(model=model,
			    tokenizer=tokenizer,
			    test_data=test_data,
			    temperature=None, 
			    top_p=None, 
			    top_k=None,
			    max_new_tokens=512)
		invariants = test_data[test_data.rfind("What are the critical invariants?") + \
		len("What are the secondary invariants?"):] 
	return invariants   


def find_context(file, results_dir, param, model, tokenizer):
	file_tuple = os.path.splitext(file)
	file_name = file_tuple[0]
	result_file_path = os.path.join(results_dir, f"{file_name}.txt")
	if (os.path.isdir(results_dir)) is False:
		os.mkdir(results_dir)
	result_file = open(f'{result_file_path}', "w+")
	test_file = open(f'{file}', "r")
	tier_1A = test_file.read() + "\n" + "What's the transaction context of the contract?" + "\n"
	start_tier_1A = time.time()
	tier_1A_output = infer_invariants(model=model,
				   tokenizer=tokenizer,
				   test_data=tier_1A,
				   temperature=None, 
				   top_p=None, 
				   top_k=None,
				   max_new_tokens=100)
	end_tier_1A = time.time()
	duration = end_tier_1A - start_tier_1A
	result_file.write(tier_1A_output)
	result_file.close()
	return duration, tier_1A_output, result_file

def find_program_points(file, contract_name, results_dir, param):
	context = prune_for_context(contract_name)      
	model, tokenizer = load_trained_llama(param)
	result_file_path = os.path.join(results_dir, f"{contract_name}_program_point.txt")
	if (os.path.isdir(results_dir)) is False:
		os.mkdir(results_dir)
	result_file = open(f'{result_file_path}', "w+")
	test_file = open(f'{file}', "r")
	tier_1B = test_file.read() + "\n" + f"Given transaction context {context}, what are the critical program points?" + "\n"
	start_tier_1B = time.time()
	tier_1B_output = infer_invariants(model=model, 
				   tokenizer=tokenizer, 
				   test_data=tier_1B,
				   temperature=None, 
				   top_p=None, 
				   top_k=None,
				   max_new_tokens=200)
	end_tier_1B = time.time()
	duration = end_tier_1B - start_tier_1B
	program_points = tier_1B_output[tier_1B_output.rfind("Given transaction context " + str(context)+ \
										"What are the critical program points?\n") + \
										len("Given transaction context " + str(context)+ \
										"What are the critical program points?\n"):]
	result_file.write(program_points)
	result_file.close()
	print("==========inferred critical program points are: ======================\n")
	print(program_points)
	return duration, program_points


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

def insert_and_annotate(contract_file, contract_name, invariants): 
	p = re.compile(r'(\d+)')
	new_template = open(f'../verifier/instrumented_{contract_name}', "w+")
	test_contract = open(contract_file, "r")
	for line in test_contract.read().split("\n"): 
			new_template.write(line + '\n')
			for item in invariants:
				item[0]=item[0].replace("\n", "").replace(" ", "")
				if item[0] in p.findall(line[:5]):
					new_template.write("//SmartInv inferred:" + "\n" + item[1]+";" + "\n")         
	new_template.close()

def cleaned_contract(contract_name):
	file = open(f"../verifier/instrumented_{contract_name}.sol", 'r')
	filedata = file.read()
	final_template = open(f'../verifier/cleaned_{contract_name}', "w+")
	for line in filedata.split("\n"):
		line = line.lstrip("0123456789+")
		final_template.write(line + "\n")
	final_template.close()

def optional_inference(contract_file, param):
	#The following methods are optional and can be uesful if you have substantial computational resources: 
	model, tokenizer = load_trained_llama(param)
	'''
	[Note: this function below doesn't refresh the model at each prompt, so you might see 
	muddled results]
	'''
	_, _, _, _, _, _, onesession_rt, _ = invariants_gen_one_session(contract_file, results_dir, param, model, tokenizer)
	print(f"inference time (combined session) of a single contract {onesession_rt}(s).\n")
	del model
	del tokenizer
	model, tokenizer = load_trained_llama(lora_param)
	_ = simple_invariants_gen(contract_file, results_dir, tryAnother=False)
	#[Note: this function below refreshes the model at each prompt, it requires a lot of computational resources]
	_, _, _, _, _, _, refresh_rt, _ = invariants_gen_refreshed(contract_file, results_dir, param)
	print(f"inference time (refreshing session) of a single contract {refresh_rt}(s).\n")


def infer_one_contract_tier1(contract_file, results_dir, param):
	 tier1_runtime, pp = find_program_points(contract_file, results_dir, param)
	 #tier2A_runtime, inv = find_invariants(contract_file, results_dir, param)

def infer_tier1_context(folder):
	param = updated_tot_param
	model, tokenizer = load_trained_llama(param)
	for filename in os.listdir(folder):
		contract_file = os.path.join(folder, filename)
		if os.path.isfile(contract_file):
			param = updated_tot_param
			dir = results_dir
			find_context(contract_file, results_dir, param, model, tokenizer)

def infer_tier1_context_single_contract(contract_file):
	param = updated_tot_param
	model, tokenizer = load_trained_llama(param)
	if os.path.isfile(contract_file):
		param = updated_tot_param
		dir = results_dir
		runtime, raw_context, result_file = find_context(contract_file, results_dir, param, model, tokenizer)
		print("==========inferred context is: ======================\n")
		print(raw_context)
		result_file_path = os.path.join(results_dir, f"{contract_file}.txt")
		result_file = open(f'{result_file_path}', "w+")
		result_file.write(raw_context)
		print(f"inferred context is saved in {str(round(runtime, 2))} seconds.")

def infer_bugs(folder, file_results_dir, limit):
	if (os.path.isdir(file_results_dir)) is False:
		os.mkdir(file_results_dir)
	for filename in os.listdir(folder):
		contract_file = os.path.join(folder, filename)
		preparation_1 = open("./prompts/temp.txt", "r")
		preparation_2 = open(contract_file, "r")
		x = len(preparation_2.readlines())
		prompt = preparation_1.read() + preparation_2.read()
		result_file_path = os.path.join(file_results_dir, f"{filename}_alarm.txt")
		if os.path.isfile(contract_file) and os.path.exists(result_file_path)==False and x != 1 and x <=limit:			
			result_file = open(f'{result_file_path}', "w+")
			raw_output = gpt_infer(prompt)
			print(f"=========vulnerability detection of {filename}=======")
			print(raw_output)
			result_file.write(raw_output)
			result_file.close()
		       	

def single_contract_test():
	contract_file = "numbered_timecontroller.sol"
	param = updated_tot_param
	dir = results_dir
	infer_one_contract_tier1(contract_file, dir, param)
 
def prune_for_context(contract_name):
	context_list = ["cross-function", "arithmetics","loop", "ERC", "tokenSale", "asset swapping",\
	"tokenSale", "money market", "cross bridge", "simple", "lottery", "funds transfer", "ERC677",\
	"voting", "bidding proposal", "bidding", "vault", "proxy", "protocol", "funds transfer", "payment",\
	"safemath library", "liquidity pool", "liquidity", "token transfer", "safemath"]
	result = ''
	file = open(f"{results_dir}/{contract_name}.txt", "r")
	for context in context_list:
		if context in file.read():
				result += f"{context}\n" 		
	return result

def prune_for_pp(contract_name):
	context = prune_for_context(contract_name)
	file = open(f"{pp_dir}/{contract_name}_program_point.txt", "r")
	string = file.read()
	program_points = string[string.rfind("what are the critical program points?\n") + \
										len("what are the critical program points?\n"):]
	
	pp = ""
	new_list = []
	for substring in program_points.split():
		if "+" in substring and substring not in new_list:
			new_list.append(substring)
	for item  in new_list:	
		pp += item + ", "
	return new_list, pp
	 
def find_invariants(test_file, contract_name, results_dir, param):
	model, tokenizer = load_trained_llama(param)
	_, pp = prune_for_pp(contract_name)
	result_file_path = os.path.join(results_dir, f"{contract_name}.txt")
	if (os.path.isdir(results_dir)) is False:
		os.mkdir(results_dir)
	test_file = open(f'{test_file}', "r")
	result_file = open(f'{result_file_path}', "w+")
	tier_2A = test_file.read() + "\n" + f"Given inferred critical program points {pp}, what are the invariants?" + "\n"
	start_tier_2A = time.time()
	tier_2A_output = infer_invariants(model=model, 
				   tokenizer=tokenizer, 
				   test_data=tier_2A,
				   temperature=None, 
				   top_p=None, 
				   top_k=None,
				   max_new_tokens=500)
	end_tier_2A = time.time()
	duration = end_tier_2A - start_tier_2A
	invariants = tier_2A_output[tier_2A_output.rfind(f"Given inferred critical program points {pp}, what are the invariants?\n") + \
										len(f"Given inferred critical program points {pp}, what are the invariants?\n"):]
	result_file.write(invariants)
	result_file.close()
	print("==========inferred invariants based on prior program points are: ======================\n")
	print(invariants)
	return duration, invariants

def prune_for_inv(contract_name):
	pp_list, _ = prune_for_pp(contract_name)
	file = open(f"{inv_dir}/{contract_name}.txt", "r")
	string = file.read()	
	inv = ""
	new_list = []
	for pp in pp_list: 
		for substring in string.split(";"):
			if "old" in substring:
				substring = substring.replace("old", "VeriSol.Old")
			if "Old" in substring:
				substring = substring.replace("Old", "VeriSol.Old")
			if substring not in new_list and pp in substring:
				new_list.append(substring + ";")
	for item  in new_list:	
		inv += item +  "\n"
	return new_list, inv

def find_critical_invariants(test_file, contract_name, results_dir, param):
	model, tokenizer = load_trained_llama(param)
	_, inv = prune_for_inv(contract_name)
	result_file_path = os.path.join(results_dir, f"{contract_name}.txt")
	if (os.path.isdir(results_dir)) is False:
		os.mkdir(results_dir)
	test_file = open(f'{test_file}', "r")
	result_file = open(f'{result_file_path}', "w+")
	tier_2A = test_file.read() + "\n" + f"Given inferred invariants {inv}, what are the critial invariants?\n"
	start_tier_2B = time.time()
	tier_2B_output = infer_invariants(model=model, 
				   tokenizer=tokenizer, 
				   test_data=tier_2A,
				   temperature=None, 
				   top_p=None, 
				   top_k=None,
				   max_new_tokens=500)
	end_tier_2B = time.time()
	duration = end_tier_2B - start_tier_2B
	criticalInv = tier_2B_output[tier_2B_output.rfind(f"Given inferred invariants {inv}, what are the critial invariants?\n") + \
										len(f"Given inferred invariants {inv}, what are the critial invariants?\n"):]
	result_file.write(criticalInv)
	result_file.close()
	print("==========inferred critical invariants are: ======================\n")
	print(criticalInv)
	return duration, criticalInv


def prune_for_critical_inv(contract_name):
	pp_list, _ = prune_for_pp(contract_name)
	file = open(f"{criticalInv_dir}/{contract_name}.txt", "r")
	string = file.read()	
	inv = ""
	new_list = []
	for pp in pp_list: 
		for substring in string.split(";"):
			if "old" in substring:
				substring = substring.replace("old", "VeriSol.Old")
			if "Old" in substring:
				substring = substring.replace("Old", "VeriSol.Old")
			if substring not in new_list and pp in substring:
				new_list.append(substring + ";")
	for item  in new_list:	
		inv += item +  "\n"
	return new_list, inv

def find_vulnerabilities(test_file, contract_name, results_dir, param):
	model, tokenizer = load_trained_llama(param)
	result_file_path = os.path.join(results_dir, f"{contract_name}.txt")
	if (os.path.isdir(results_dir)) is False:
		os.mkdir(results_dir)
	test_file = open(f'{test_file}', "r")
	result_file = open(f'{result_file_path}', "w+")
	tier_3B = test_file.read() + "\n" + f"What are the vulnerabilities in the contract?\n"
	start_tier_3B = time.time()
	tier_3B_output = infer_invariants(model=model, 
				   tokenizer=tokenizer, 
				   test_data=tier_3B,
				   temperature=None, 
				   top_p=None, 
				   top_k=None,
				   max_new_tokens=500)
	end_tier_3B = time.time()
	duration = end_tier_3B - start_tier_3B
	vul = tier_3B_output[tier_3B_output.rfind(f"What are the vulnerabilities in the contract?\n") + \
										len(f"What are the vulnerabilities in the contract?\n"):]
	result_file.write(vul)
	result_file.close()
	print("==========inferred bugs are: ======================\n")
	print(vul)
	return duration, vul
	
if __name__ == "__main__":
	os.environ['CUDA_VISIBLE_DEVICES'] = '0'
	print(torch.cuda.is_available()) 
	contract_file = "./numbered_timecontroller.sol"
	contract_name = "numbered_timecontroller.sol"
	param = updated_tot_param
	_, cr = prune_for_critical_inv(contract_name)
	print(cr)
	#time, inv = find_invariants(contract_file, contract_name, inv_dir, param)
	#_, inv = prune_for_inv(contract_name)
	#inv = invariants_list(inv)
	#insert_and_annotate(contract_file, contract_name, inv)
	#cleaned_contract(contract_name)
	
	
	#duration, criticalInv = find_critical_invariants(contract_file, contract_name, criticalInv_dir, param)
	#prune_for_pp(contract_name)
	#time, pp = find_program_points(contract_file, contract_name, pp_dir, param)
	#print(pp)
	#infer_tier1_context_single_contract(contract_file)
	#single_contract_test()
	#test_folder_path = "../tests/instrumented_contracts"
	#infer_tier1_context(test_folder_path)
	'''
	folder = test_folder_path
	dir = large_exp_results_dir
	limit = 100
	infer_bugs(folder, dir, limit)
	'''
 

