import argparse
import os
import shutil
import sys
import subprocess
import argparse



results_dir = '/home/sallyjunsongwang/SmartInv/results/contexts'
large_exp_results_dir = "/home/sallyjunsongwang/SmartInv/large_exp_results"
refined_exp_results = "/home/sallyjunsongwang/SmartInv/SmartInv/refined_exp_results"


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
	if verbose:      
		print(std_out.strip(), std_err)

def runcmd_out(cmd, *args, **kwargs):

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
	print(std_out)
	print(std_err)
	return std_out, std_err 

def parse_arguments(args):
	parser = argparse.ArgumentParser(sys.argv[0])
	parser.add_argument('--file', type=str, required=False, default='')
	parser.add_argument('--contract', type=str, required=False, default='')
	parser.add_argument('--exp1', type=bool, required=False, default=True)
	parser.add_argument('--exp2', type=bool, required=False, default=True)
	parser.add_argument('--large_exp', type=bool, required=False, default=True)
	parser.add_argument('--refined_exp', type=bool, required=False, default=True)
	parser.add_argument('--easy', type=bool, required=False, default=True)
	parser.add_argument('--heavy', type=bool, required=False, default=False)
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
		
	
def run_veriSmart(contract_file):
	auto_compiler_detect(contract_file)
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/veriSmart")) is False:
		os.mkdir(f"{large_exp_results_dir}/veriSmart")
	if (os.path.isdir(f"{large_exp_results_dir}/veriSmart/{contract_file}")) is False:
		os.mkdir(f"{large_exp_results_dir}/veriSmart/{contract_file}")
	results_dir = f"{large_exp_results_dir}/veriSmart/{contract_file}"
	std_out, std_err = runcmd_out(f"~/VeriSmart-public/main.native -input {contract_file} -verify_timeout 60 -z3timeout 10000")
	result_file = open(f"{results_dir}/report", "w+")
	result_file.write(std_out)
	result_file.write(std_err)
	result_file.close()
	
def run_smartest(contract_file):
	auto_compiler_detect(contract_file)
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/smartest")) is False:
		os.mkdir(f"{large_exp_results_dir}/smartest")
	if (os.path.isdir(f"{large_exp_results_dir}/smartest/{contract_file}")) is False:
		os.mkdir(f"{large_exp_results_dir}/smartest/{contract_file}")
	results_dir = f"{large_exp_results_dir}/smartest/{contract_file}"
	std_out, std_err = runcmd_out(f"~/VeriSmart-public/main.native -input {contract_file} -mode exploit -exploit_timeout 10000 leak")
	result_file = open(f"{results_dir}/report", "w+")
	result_file.write(std_out)
	result_file.write(std_err)
	result_file.close()

def run_mythril(contract_file):
	if (os.path.isdir(large_exp_results_dir)) is False:
		os.mkdir(large_exp_results_dir)
	if (os.path.isdir(f"{large_exp_results_dir}/mythril")) is False:
		os.mkdir(f"{large_exp_results_dir}/mythril")
	if (os.path.isdir(f"{large_exp_results_dir}/mythril/{contract_file}")) is False:
		os.mkdir(f"{large_exp_results_dir}/mythril/{contract_file}")
	results_dir = f"{large_exp_results_dir}/mythril/{contract_file}"
	std_out, std_err = runcmd_out(f"docker run -v $(pwd):/tmp mythril/myth analyze /tmp/{contract_file}")
	result_file = open(f"{results_dir}/report", "w+")
	result_file.write(std_out)
	result_file.write(std_err)
	result_file.close()
	
	
def run_large_scale_exp():
	test_dir = "/home/sallyjunsongwang/SmartInv/tests/contracts"
	for filename in os.listdir(test_dir):
		#run_veriSmart(filename)
		#run_smartest(filename)
		run_mythril(filename)
	
			 
def main():
	args = parse_arguments(sys.argv[1:])
	if args.large_exp == True:
		run_large_scale_exp()

if __name__ == "__main__":
	main()
