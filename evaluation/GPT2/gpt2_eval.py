import os
import torch
import argparse
import random
import torch
import sys, time
import numpy as np
import pandas as pd
import torch.nn.functional as F
from pathlib import Path
from tqdm import tqdm, trange
from torch.utils.data import Dataset, DataLoader, RandomSampler, SequentialSampler
from transformers import GPT2Tokenizer, GPT2LMHeadModel, AdamW, get_linear_schedule_with_warmup

model = None
tokenizer = None

def initialize():
  global model
  global tokenizer
  model = GPT2LMHeadModel.from_pretrained("sallywww/GTP2-invariants")
  tokenizer = GPT2Tokenizer.from_pretrained("sallywww/GTP2-invariants")
  return model, tokenizer

def generate(
    prompt,
    model,
    tokenizer,
    entry_count=10,
    entry_length=512, #maximum number of words
    top_p=0.8,
    temperature=1.,
):
    model.eval()
    generated_num = 0
    generated_list = []

    filter_value = -float("Inf")

    with torch.no_grad():

        for entry_idx in trange(entry_count):

            entry_finished = False
            generated = torch.tensor(tokenizer.encode(prompt)).unsqueeze(0)

            for i in range(entry_length):
                outputs = model(generated, labels=generated)
                loss, logits = outputs[:2]
                logits = logits[:, -1, :] / (temperature if temperature > 0 else 1.0)

                sorted_logits, sorted_indices = torch.sort(logits, descending=True)
                cumulative_probs = torch.cumsum(F.softmax(sorted_logits, dim=-1), dim=-1)

                sorted_indices_to_remove = cumulative_probs > top_p
                sorted_indices_to_remove[..., 1:] = sorted_indices_to_remove[
                    ..., :-1
                ].clone()
                sorted_indices_to_remove[..., 0] = 0

                indices_to_remove = sorted_indices[sorted_indices_to_remove]
                logits[:, indices_to_remove] = filter_value

                next_token = torch.multinomial(F.softmax(logits, dim=-1), num_samples=1)
                generated = torch.cat((generated, next_token), dim=1)

                if next_token in tokenizer.encode("<|endoftext|>"):
                    entry_finished = True

                if entry_finished:

                    generated_num = generated_num + 1

                    output_list = list(generated.squeeze().numpy())
                    output_text = tokenizer.decode(output_list)
                    generated_list.append(output_text + '\n')
                    break
            
            if not entry_finished:
              output_list = list(generated.squeeze().numpy())
              output_text = f"{tokenizer.decode(output_list)}<|endoftext|>" 
              generated_list.append(output_text + '\n')
                
    return generated_list

def generate_test_contrct(path, ratio): 
  col = ['Target']
  f = open(path, "r")
  file = f.read()
  test_df = pd.DataFrame([file], columns=col)
  program_length = len(test_df['Target'][0].split())
  prompt_ratio = ratio
  prompt_length = int(prompt_ratio * program_length)
  return test_df, prompt_length

def truncate_test(df, prompt_length):
  copy_1 = df.copy(deep=True)
  copy_2 = df.copy(deep=True)
  #true
  a = copy_1['Target'].str.split().str[-prompt_length:].apply(' '.join)[0]
  #masked out program 
  b = copy_2['Target'].str.split().str[:-prompt_length].apply(' '.join)[0]
  return a, b

#Function to generate multiple sentences. Test data should be a dataframe
def generate_text(test_data, model, tokenizer):
  start_time = time.time()
  generated_code = []
  for i in range(len(test_data)):    
    x = generate(test_data['Target'][i], model.to('cpu'), tokenizer, entry_count=1)
    generated_code.append(x)
  runtime = time.time() - start_time
  return generated_code, runtime

def main(): 
   model, tokenizer = initialize()
   if len(sys.argv) < 1:
        print("Error: please specify a test contract folder.")
   path = Path(sys.argv[1])
   glob_path = path.glob('*.sol') 
   total_time = 0.00
   file_count = 0
   for file_path in glob_path:
        print(f"testing '{file_path}' ...\n")
       # test_file = open(f'{file_path}', "r", encoding="utf-8", errors="ignore")
       # test_data = test_file.read() 
        test_df, n = generate_test_contrct(f'{file_path}', 0.95)
        truth, prompt = truncate_test(test_df, n)
        col = ['Target']
        prompt_df = pd.DataFrame([prompt], columns=col)
        out, runtime = generate_text(
          test_data=prompt_df,
          model=model, 
          tokenizer=tokenizer)
        total_time += runtime
        file_count += 1
        print(f"for{file_path} we have inference runtime: {runtime}\n")           
        if len(sys.argv) > 2:
              output_folder = sys.argv[2]
              with open(f"{output_folder}/test_{file_path}", "w", encoding="utf-8") as file:  
                      file.write(output.strip()+"\n")               
              file.close()  
        else:
              print(f"for{file_path} we have inferred output: {out}\n")   
   avg_time = total_time / file_count
   print(f"Total runtime for {file_count} files is {total_time}\n")
   print(f"Average runtime of each contract is {avg_time}\n")
   print(f"==============end of testing{file_path}===============\n")

if __name__ == "__main__":
   main()     
