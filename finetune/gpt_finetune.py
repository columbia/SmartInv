import os
import json
import tiktoken # for token counting
import subprocess
import numpy as np
from openai import OpenAI
from collections import defaultdict

client = OpenAI()
client.api_key = os.getenv("OPENAI_API_KEY")
DATA_PATH = "/home/sallyjunsongwang/llmfz/train_data/formatted_working_gpt4.json"
UPLOAD_PATH = "./datafile.json"

#commented code is for finetuning dataset generation

def validateGPTData(data_path):
	with open(data_path, 'r', encoding='utf-8') as f:
		dataset = [json.loads(line) for line in f]
	# Initial dataset stats
		print("Num examples:", len(dataset))
		print("First example: \n")
		print("PROMPT: \n")
		print(dataset[0]["prompt"])
		print("========================================\n")
		print("COMPLETION: \n")
		print(dataset[0]["completion"])

def createGPTData(data_path, uploade_path):
	#Sally[todo]: fix with full path of auto-formatting
	#subprocess.call('python /home/sallyjunsongwang/llmfz/train_data/format.py', shell=True)
	client.files.create(
	file=open(data_path, "rb"),
	purpose="fine-tune"
	)
	with open(uploade_path, "w") as datafile:
		subprocess.call(["curl", "https://api.openai.com/v1/files", \
		"-H", f"Authorization: Bearer {client.api_key}"],  stdout=datafile)

def cleanGPTData(uploade_path): 
	if os.path.exists(uploade_path) != True:
		print("No uploaded data file to OpenAI yet!\n")
	else: 
		datafile_ids = []
		with open(uploade_path, 'r') as f:	
			for line in f:
				if "id" in line: 
					rewrite_line = line[12:].replace('"', '')
					id = rewrite_line.replace(',', '')
					datafile_ids.append(id)
			for id in datafile_ids:
				path = f"https://api.openai.com/v1/files/{id.strip()}"
				subprocess.call(["curl", str(path), \
				"-X", "DELETE", "-H", f"Authorization: Bearer {client.api_key}"])

def createFinetuneJob(uploade_path): 
	datafile_ids = []
	with open(uploade_path, 'r') as f:	
		for line in f:
			if "id" in line: 
				rewrite_line = line[12:].replace('"', '')
				id = rewrite_line.replace(',', '')
				datafile_ids.append(id)
	client.fine_tuning.jobs.create(
	training_file=datafile_ids[0].strip(), 
	model="davinci-002", 
	hyperparameters={
		"n_epochs":10
	}  
	)
	print(client.fine_tuning.jobs.list(limit=10))


def main():
	cleanGPTData(UPLOAD_PATH)
	createGPTData(DATA_PATH, UPLOAD_PATH)
	validateGPTData(DATA_PATH)
	createFinetuneJob(UPLOAD_PATH)
		

if __name__ == "__main__":
	main()  