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
from torch.utils.data import Dataset, DataLoader, RandomSampler, SequentialSampler
from transformers import T5Tokenizer, T5ForConditionalGeneration

model = None
tokenizer = None

class TestDataSetClass(Dataset):
  """
  Creating a custom dataset for reading the dataset and 
  loading it into the dataloader to pass it to the neural network for finetuning the model

  """
  def __init__(self, dataframe, tokenizer, source_len, source_text):
    self.tokenizer = tokenizer
    self.data = dataframe
    self.source_len = source_len
    self.source_text = self.data[source_text]

  def __len__(self):
    return len(self.source_text)

  def __getitem__(self, index):
    source_text = str(self.source_text[index])

    #cleaning data so as to ensure data is in string type
    source_text = ' '.join(source_text.split())
    source = self.tokenizer.batch_encode_plus([source_text], \
                                              max_length=self.source_len, \
                                              pad_to_max_length=True, \
                                              truncation=True, \
                                              padding="max_length",\
                                              return_tensors='pt')

    source_ids = source['input_ids'].squeeze()
    source_mask = source['attention_mask'].squeeze()

    return {
        'source_ids': source_ids.to(dtype=torch.long), 
        'source_mask': source_mask.to(dtype=torch.long), 
    }


def initialize():
  global model
  global tokenizer
  model = T5ForConditionalGeneration.from_pretrained("sallywww/T5-invariants")
  tokenizer = T5Tokenizer.from_pretrained("t5-small")
  return model, tokenizer

def generate_text(df, model, tokenizer):
   start_time = time.time()
   model.eval()
   test_params = {
      'batch_size': 8,
      'shuffle': False,
      'num_workers': 0
      }
   test_val = TestDataSetClass(df, tokenizer, source_len=512, source_text="Test")
   test_loader = DataLoader(test_val, **test_params)
   predictions = []
   with torch.no_grad():
      for _, data in enumerate(test_loader, 0):
          ids = data['source_ids']
          mask = data['source_mask'] #.to(device, dtype = torch.long)
          generated_ids = model.generate(
              input_ids = ids,
              attention_mask = mask, 
              max_length=150, 
              num_beams=2,
              repetition_penalty=2.5, 
              length_penalty=1.0, 
              early_stopping=True
              )
          preds = [tokenizer.decode(g, skip_special_tokens=True, \
                                    clean_up_tokenization_spaces=True) for g in generated_ids]

          predictions.extend(preds)
          runtime = time.time() - start_time
   return predictions, runtime

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
        test_file = open(f'{file_path}', "r", encoding="utf-8", errors="ignore")
        test_data = test_file.read() 
        col = ['Test']
        test_df = pd.DataFrame([test_data], columns=col)
        out, runtime = generate_text(
          df=test_df,
          model=model, 
          tokenizer=tokenizer)
        total_time += runtime
        file_count += 1
        print(f"for{file_path} we have inference runtime: {runtime}\n") 
       # print(f"for{file_path} we have inferred output: {out}\n")              
        if len(sys.argv) > 2:
              output_folder = sys.argv[2]
              with open(f"{output_folder}/test_{file_path}", "a", encoding="utf-8") as file:  
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
  
