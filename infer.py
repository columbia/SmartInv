import os
import argparse
import random
import torch
import transformers
from datasets import Dataset
from transformers import LlamaForCausalLM, LlamaTokenizer, GenerationConfig
from peft import prepare_model_for_int8_training, PeftConfig, LoraConfig, get_peft_model, PeftModel

model = None
tokenizer = None

def load_saved_model(model_name):
  global model
  global tokenizer

  peft_model_id = model_name
  config = PeftConfig.from_pretrained(peft_model_id)
  model = LlamaForCausalLM.from_pretrained(config.base_model_name_or_path)
  model = PeftModel.from_pretrained(model, peft_model_id)
  tokenizer = LlamaTokenizer.from_pretrained(config.base_model_name_or_path)
  model.cuda()
  return model, tokenizer

def generate_text(model, tokenizer, test_data, max_new_tokens):
        model.eval()
        inputs = tokenizer(test_data, return_tensors="pt")
        with torch.no_grad():
                outputs = model.generate(input_ids=inputs["input_ids"].cuda(), \
                max_new_tokens=max_new_tokens)
                invariants = tokenizer.batch_decode(outputs.detach().cpu().numpy(), skip_special_tokens=True)[0]
        return invariants
'''
model = None
tokenizer = None
peft_model = None

def load_original_model():
        global model
        global tokenizer
        model = LlamaForCausalLM.from_pretrained(
            "decapoda-research/llama-7b-hf",
            load_in_8bit=True,
            torch_dtype=torch.float16,
            device_map= "auto",
        )

        tokenizer = LlamaTokenizer.from_pretrained(
            "decapoda-research/llama-7b-hf",
        )

def generate_text(
    model_name, 
    text, 
    temperature, 
    top_p, 
    top_k, 
    repeat_penalty,
    max_new_tokens,
):
    global model
    global tokenizer

    load_original_model()    
    tokenizer.pad_token_id = 0
    if model_name and model_name != "None":
        model = prepare_model_for_int8_training(model)
        model = PeftModel.from_pretrained(
            model, model_name,
            torch_dtype=torch.float16
        )
   # model.cuda()
    inputs = tokenizer(text, return_tensors="pt")
    print('model.device: ', model.device)
    input_ids = inputs["input_ids"].cuda()

    # llama_config = transformers.LlamaConfig()
    # print(llama_config)

    stopping_criteria_list = transformers.StoppingCriteriaList()
    generation_config = GenerationConfig(
        # Whether to use greedy decoding. If set to False,
        do_sample=True,

        # Controls the 'temperature' of the softmax distribution during sampling.
        # Higher values (e.g., 1.0) make the model generate more diverse and random outputs, 
        # while lower values (e.g., 0.1) make it more deterministic and 
        # focused on the highest probability tokens.
        temperature=temperature,  

        # Sets the nucleus sampling threshold. In nucleus sampling, 
        # only the tokens whose cumulative probability exceeds 'top_p' are considered 
        # for sampling. This technique helps to reduce the number of low probability 
        # tokens considered during sampling, which can lead to more diverse and coherent outputs.
        top_p=top_p,  

        # Sets the number of top tokens to consider during sampling. 
        # In top-k sampling, only the 'top_k' tokens with the highest probabilities 
        # are considered for sampling. This method can lead to more focused and coherent 
        # outputs by reducing the impact of low probability tokens.
        top_k=top_k,  

        # Applies a penalty to the probability of tokens that have already been generated, 
        # discouraging the model from repeating the same words or phrases. The penalty is
        # applied by dividing the token probability by a factor based on the number of times 
        # the token has appeared in the generated text.
        repeat_penalty=repeat_penalty,

        # Limits the maximum number of tokens generated in a single iteration. 
        # This can be useful to control the length of generated text, especially in tasks 
        # like text summarization or translation, where the output should not be excessively long.
        max_new_tokens=max_new_tokens,  

        # typical_p=1,
        # stopping_criteria=stopping_criteria_list,
        # eos_token_id=llama_config.eos_token_id,
        # pad_token_id=llama_config.eos_token_id
    )
 

    with torch.no_grad():
        generation_output = model.generate(
            input_ids=input_ids,
            attention_mask=torch.ones_like(input_ids),
            generation_config=generation_config,
            use_cache=True,
        )[0].cuda()

    output_text = tokenizer.decode(generation_output)
    return output_text.strip()
'''
if __name__ == "__main__":
      for d in os.listdir(): 
         if os.path.isdir(d) and d.startswith('lora-'):
              if '7B' in d and 'insft' in d: 
                print("this is lora parameters: ", d)
                lora_param = d
      test_file = open('./tests/Replica.sol', "r")
      test_data = "This is contract:" + "\n" + test_file.read() + \
                 "All invariants are:"
      model, tokenizer = load_saved_model(model_name=lora_param)
      out = generate_text(
                model=model, 
                tokenizer=tokenizer,
                test_data=test_data, 
                #temperature=0.8, 
                #top_p=0.95, 
                #top_k=None, 
                #repeat_penalty=None,
                max_new_tokens=512,
        )
      print(out.strip())
