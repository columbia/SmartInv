import os
import numpy as np
import accelerate
import bitsandbytes
import transformers
import pandas as pd
import torch
import torch.nn.functional as F
from torch.utils.data import Dataset, DataLoader, RandomSampler, SequentialSampler
from transformers import AutoTokenizer, LlamaTokenizer, LlamaForCausalLM

model = None
tokenizer = None

def load_saved_model():
        global model
        global tokenizer

        
        model = LlamaForCausalLM.from_pretrained(
                "sallywww/trained_llama_stanford_format")

        tokenizer = LlamaTokenizer.from_pretrained(
                "sallywww/trained_llama_stanford_format")
        model.cuda()
        return model, tokenizer

def generate_text(model, tokenizer, test_data, max_new_tokens):
        start_time = time.time()
        print("inference runtime starts counting...")
        model.eval()
        inputs = tokenizer(test_data, return_tensors="pt")
        with torch.no_grad():
                outputs = model.generate(input_ids=inputs["input_ids"].cuda(), \
                max_new_tokens=max_new_tokens)
                invariants = tokenizer.batch_decode(outputs.detach().cpu().numpy(), skip_special_tokens=True)[0]
        runtime = time.time() - start_time
        return invariants, runtime

def main(): 
      model, tokenizer = load_saved_model()   
      if len(sys.argv) < 1:  
                print("Error: please specify a test contract folder.")
      path = Path(sys.argv[1])
      glob_path = path.glob('*.sol') 
      total_time = 0.00
      file_count = 0
      for file_path in glob_path:
                print(f"testing '{file_path}' ...\n")
                test_file = open(f'{file_path}', "r", encoding="utf-8", errors="ignore")
                test_data = test_file.read() 
                out, runtime = generate_text(
                                        model=model, 
                                        tokenizer=tokenizer,
                                        test_data=test_data, 
                                        max_new_tokens=512,
                                )
                total_time += runtime
                file_count += 1
                print(f"for{file_path} we have inference runtime: {runtime}\n")
               
                print(f"==============end of testing{file_path}===============\n")
                if len(sys.argv) > 2:
                        output_folder = sys.argv[2]
                        with open(f"{output_folder}/test_{file_path}", "a", encoding="utf-8") as file:  
                                file.write(output.strip()+"\n")
                        file.close()
                else:
                         print(f"for{file_path} we have inferred output: {out.strip()}\n")
      avg_time = total_time / file_count
      print(f"Total runtime for {file_count} files is {total_time}\n")
      print(f"Average runtime of each contract is {avg_time}\n")

if __name__ == "__main__":
       main()      