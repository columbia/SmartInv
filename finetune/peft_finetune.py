import os
import sys
import argparse
import json
import random
import torch
import transformers
import accelerate
from datasets import Dataset, load_dataset
from accelerate import dispatch_model, infer_auto_device_map
from accelerate.utils import get_balanced_memory
from finetune_data import jdump
from itertools import islice
from torch.cuda.amp import autocast
from transformers import (
    LlamaForCausalLM, 
    LlamaTokenizer, 
    GenerationConfig, 
    BitsAndBytesConfig,
    AutoTokenizer, 
    AutoModelForCausalLM, 
    TrainingArguments, 
    Trainer, 
    DataCollatorForSeq2Seq,
) 
from peft import (
    prepare_model_for_int8_training, 
    LoraConfig, 
    get_peft_model, 
    PeftModel,
    get_peft_model_state_dict,
    set_peft_model_state_dict,
)


model = None
tokenizer = None
peft_model = None

torch.cuda.empty_cache()
#torch.cuda.synchronize()

def parse_args():
    """Parses command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('-s',
                      type=int,
                      required=False,
                      help='Specify desired training dataset size.')    
    parser.add_argument('-model',
                      type=str,
                      required=False,
                      help='Specify a model that you want to finetune: llama, codellama,falcon, or starCoder.')
    parser.add_argument('-method',
                      type=str,
                      required=False,
                      help='Specify a fine-tuning method: context or onestep.')
    parser.add_argument('-json',
                      type=bool,
                      required=False,
                      help='Specify if the model is to be fine-tuned only on json data.')
    args = parser.parse_args()

    return args


def load_llama():
    global model
    global tokenizer
    model = LlamaForCausalLM.from_pretrained(
            "baffo32/decapoda-research-llama-7B-hf",
            load_in_8bit=True,
            torch_dtype=torch.float16,
            device_map= "auto", #comment this line out if encountering cuda OOM or wrong distribution
                                #across GPU and CPU. 
        )
    max_memory = get_balanced_memory(
        model,
        max_memory=None,
        no_split_module_classes=["DecoderLayer", "Attention", "MLP", "LayerNorm", "Linear"],
        dtype='float16',
        low_zero=False,
        )

    device_map = infer_auto_device_map(
        model,
        max_memory=max_memory,
        no_split_module_classes=["DecoderLayer", "Attention", "MLP", "LayerNorm", "Linear"],
        dtype='float16'
        )

    if tokenizer is None:
        tokenizer = LlamaTokenizer.from_pretrained(
            "baffo32/decapoda-research-llama-7B-hf",
        )


def reset_models():
    global model
    global tokenizer

    del model
    del tokenizer

    model = None
    tokenizer = None


def load_codellama():
    global model
    global tokenizer

    base_model = "codellama/CodeLlama-7b-hf"
    model = AutoModelForCausalLM.from_pretrained(
    base_model,
    load_in_8bit=True,
    torch_dtype=torch.float16,
    device_map="auto", #might require commenting out 
    )   
    max_memory = get_balanced_memory(
        model,
        max_memory=None,
        no_split_module_classes=["DecoderLayer", "Attention", "MLP", "LayerNorm", "Linear"],
        dtype='float16',
        low_zero=False,
        )

    device_map = infer_auto_device_map(
        model,
        max_memory=max_memory,
        no_split_module_classes=["DecoderLayer", "Attention", "MLP", "LayerNorm", "Linear"],
        dtype='float16'
        )
    tokenizer = AutoTokenizer.from_pretrained("codellama/CodeLlama-7b-hf")
    return model, tokenizer

def load_falcon():
    global model
    global tokenizer

    base_model = "tiiuae/falcon-7b"

    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        load_4bit_use_double_quant=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.bfloat16,
    )

    model =AutoModelForCausalLM.from_pretrained(
        base_model,
        device_map="auto",
        trust_remote_code=True,
        quantization_config=bnb_config,
    )
    model.config.use_cache = False

    tokenizer = AutoTokenizer.from_pretrained(base_model)
    tokenizer.pad_token = tokenizer.eos_token
    max_memory = get_balanced_memory(
        model,
        max_memory=None,
        no_split_module_classes=["DecoderLayer", "Attention", "MLP", "LayerNorm", "Linear"],
        dtype='float16',
        low_zero=False,
        )

    device_map = infer_auto_device_map(
        model,
        max_memory=max_memory,
        no_split_module_classes=["DecoderLayer", "Attention", "MLP", "LayerNorm", "Linear"],
        dtype='float16'
        )
    return model, tokenizer

def load_starcoder():
    global model
    global tokenizer

    base_model = "bigcode/starcoder"
    model =AutoModelForCausalLM.from_pretrained(
        base_model,
        device_map="auto",
        load_in_8bit=True,
        trust_remote_code=True,
        torch_dtype=torch.float16,
    )

    tokenizer = AutoTokenizer.from_pretrained(base_model)
    tokenizer.pad_token = tokenizer.eos_token
    max_memory = get_balanced_memory(
        model,
        max_memory=None,
        no_split_module_classes=["DecoderLayer", "Attention", "MLP", "LayerNorm", "Linear"],
        dtype='float16',
        low_zero=False,
        )

    device_map = infer_auto_device_map(
        model,
        max_memory=max_memory,
        no_split_module_classes=["DecoderLayer", "Attention", "MLP", "LayerNorm", "Linear"],
        dtype='float16'
        )
    return model, tokenizer

def load_Phind():
    global model
    global tokenizer


def load_datasets(data_path, file_name, size=None):

    train_data = []  
    eval_data = []
    original_path = os.path.join(data_path, file_name + ".json")
    train_path = os.path.join(data_path, file_name + "_"+ "train" + ".json")
    eval_path = os.path.join(data_path, file_name + "_"+ "eval" + ".json")
    dataset = load_dataset('json', data_files=original_path, split='train')
    full_size = len(dataset)
    print(f"the size of dataset you use for fine-tuning is {full_size}\n")

    if size is None: 
        default_size = int(full_size*0.8)
        eval_size = int(full_size - full_size *0.8)
        for i in range(default_size):
            train_data.append(dataset[i])
        jdump(train_data, train_path)
        for i in range(eval_size):
            eval_data.append(dataset[default_size+i])
        jdump(eval_data, eval_path) 
    else:    
        remain = full_size - size
        for i in range(size):
            train_data.append(dataset[i])
        jdump(train_data, train_path)  
        for i in range(remain):
            eval_data.append(dataset[size+i])
        jdump(eval_data, eval_path)          
    train_set = load_dataset('json', data_files=train_path, split='train')
    eval_set = load_dataset('json', data_files=eval_path, split='train')
    print(f"this is an example of {len(train_set)} training samples: \n")
    print(train_set[0])
    if len(eval_set) >= 1: 
        print(f"this is an example of  {len(eval_set)} evaluation samples: \n")
        print(eval_set[0])    
    return train_set, eval_set 


def tokenize(prompt):
    tokenizer.add_eos_token = True
    tokenizer.pad_token_id = 0
    tokenizer.padding_side = "left"
    result = tokenizer(
        prompt,
        truncation=True,
        max_length=512,
        padding=False,
        return_tensors=None,
    )
    # "self-supervised learning" means the labels are also the inputs:
    result["labels"] = result["input_ids"].copy()
    return result


def tokenize_json_prompt(data_point):
    full_prompt =f"""
    {data_point["prompt"]}

    {data_point["completion"]}
    """
    return tokenize(full_prompt)


def generate_and_tokenize_prompt(data_point):
    full_prompt =f"""You are a security testing engineer who wants to write a C++ program to execute all lines in a given function by defining and initializing its parameters in a suitable way before fuzzing the function through <code>LLVMFuzzerTestOneInput</code>.
    Carefully study the function signature and its parameters, then generate a fuzz targets by the following instructions. YOU MUST call the function to fuzz in the solution.
    Try as many variations of possible inputs as possible. Do not use a random number generator such as <code>rand()</code>.
    Your goal is to write a fuzzing harness for the provided function header using <code>LLVMFuzzerTestOneInput</code>.
    All variables used MUST be declared and initialized. Carefully make sure that the variable and argument types in your code match and compiles successfully. Add type casts to make types match.
    Do not create new variables with the same names as existing variables. If you write code using <code>goto</code>, you MUST MUST also declare all variables BEFORE the <code>goto</code>. Never introduce new variables after the <code>goto</code>.
    It is important that the provided solution compiles and actually calls the function specified by the function signature:

    ### Input:
    {data_point["prompt"]}

    ### Response:
    {data_point["completion"]}
    """
    #print(f"to be tokeninzed full data point for training:{full_prompt}\n")
    return tokenize(full_prompt)

def tokenize_dataset():
    args = parse_args()
    if args.json is True:
        train_dataset, eval_dataset = load_datasets("../train_data", "onestep")
        tokenized_train_dataset = train_dataset.map(tokenize_json_prompt)
        tokenized_val_dataset = eval_dataset.map(tokenize_json_prompt)
        print("we are using json data for finetuning!")
    else: 
        train_dataset, eval_dataset = load_datasets("../train_data", "onestep")
        tokenized_train_dataset = train_dataset.map(generate_and_tokenize_prompt)
        tokenized_val_dataset = eval_dataset.map(generate_and_tokenize_prompt)
    return tokenized_train_dataset, tokenized_val_dataset

def onestep_tokenize_and_train_codellama():
    model, tokenizer = load_codellama()
    tokenized_train_dataset, tokenized_val_dataset = tokenize_dataset()
    model.train() # put model back into training mode
    model = prepare_model_for_int8_training(model)
    output_dir = f"onestep-codellama"

    config = LoraConfig(
        r=16,
        lora_alpha=16,
        target_modules=[
        "q_proj",
        "k_proj",
        "v_proj",
        "o_proj",
    ],
        lora_dropout=0.05,
        bias="none",
        task_type="CAUSAL_LM",
    )
    model = get_peft_model(model, config)
    if torch.cuda.device_count() > 1:
        # keeps Trainer from trying its own DataParallelism when more than 1 gpu is available
        model.is_parallelizable = True
        model.model_parallel = True
    batch_size = 128
    per_device_train_batch_size = 32
    gradient_accumulation_steps = batch_size // per_device_train_batch_size
   
    training_args = TrainingArguments(
            per_device_train_batch_size=per_device_train_batch_size,
            gradient_accumulation_steps=gradient_accumulation_steps,
            warmup_steps=100,
            max_steps=400,
            num_train_epochs=30,  
            learning_rate=3e-4,
            fp16=True,
            logging_steps=10,
            optim="adamw_torch",
            evaluation_strategy="steps", # if val_set_size > 0 else "no",
            save_strategy="steps",
            eval_steps=20,
            save_steps=20,
            output_dir=output_dir,
            load_best_model_at_end=False,
            group_by_length=True, # group sequences of roughly the same length together to speed up training
            #report_to="wandb", # if use_wandb else "none",
            #run_name=f"codellama-{datetime.now().strftime('%Y-%m-%d-%H-%M')}", # if use_wandb else None,
        )

    trainer = Trainer(
        model=model,
        train_dataset=tokenized_train_dataset,
        eval_dataset=tokenized_val_dataset,
        args=training_args,
        data_collator=DataCollatorForSeq2Seq(
            tokenizer, pad_to_multiple_of=8, return_tensors="pt", padding=True
            ),
        )
    '''
    model.config.use_cache = False
    old_state_dict = model.state_dict
    model.state_dict = (lambda self, *_, **__: get_peft_model_state_dict(self, old_state_dict())).__get__(
        model, type(model)
    )
    if torch.__version__ >= "2" and sys.platform != "win32":
        print("compiling the model")
        model = torch.compile(model)
    '''
    print("Training...")

    result = trainer.train(resume_from_checkpoint=False)

    model.save_pretrained(output_dir) 
    reset_models()
    return result

def contextual_tokenize_and_train_codellama(training_data, size=None):
    global model
    global tokenizer
    reset_models()
    model, tokenizer = load_codellama()
    tokenizer.pad_token_id = 0           
    def tokenize(item):
        result = tokenizer(
            item["text"],
            truncation=True,
            max_length=4096,
            padding="max_length",
        )
        return {
            "input_ids": result["input_ids"][:-1],
            "attention_mask": result["attention_mask"][:-1],
        }

    def to_dict(text):
        return {"text": text}

    if size is None: 
        paragraphs = training_data.split("<end of text>")
    else: 
        paragraphs = training_data.split("<end of text>")
        assert(len(paragraphs)>=size)
        paragraphs = paragraphs[:size]
        test_paragraphs = paragraphs[size+1:int(size+size*0.2)]
        test_paragraphs = [to_dict(y) for y in test_paragraphs]
        tokenized_val_dataset = test_data.shuffle().map(lambda y: tokenize(y))
        test_data = Dataset.from_list(test_paragraphs) 
    print("Number of train samples: " + str(len(paragraphs)))
    paragraphs = [to_dict(x) for x in paragraphs]
    data = Dataset.from_list(paragraphs)                 
    tokenized_train_dataset = data.shuffle().map(lambda x: tokenize(x))
    model.train() # put model back into training mode
    model = prepare_model_for_int8_training(model)

    config = LoraConfig(
        r=16,
        lora_alpha=16,
        target_modules=[
        "q_proj",
        "k_proj",
        "v_proj",
        "o_proj",
    ],
        lora_dropout=0.05,
        bias="none",
        task_type="CAUSAL_LM",
    )
    model = get_peft_model(model, config)
    if torch.cuda.device_count() > 1:
        # keeps Trainer from trying its own DataParallelism when more than 1 gpu is available
        model.is_parallelizable = True
        model.model_parallel = True
    batch_size = 128
    per_device_train_batch_size = 32
    gradient_accumulation_steps = batch_size // per_device_train_batch_size
    output_dir = "context-code-llama"

    training_args = TrainingArguments(
            per_device_train_batch_size=per_device_train_batch_size,
            gradient_accumulation_steps=gradient_accumulation_steps,
            warmup_steps=100,
            max_steps=400,
            num_train_epochs=30,  
            learning_rate=3e-4,
            fp16=True,
            logging_steps=10,
            optim="adamw_torch",
            evaluation_strategy="steps", # if val_set_size > 0 else "no",
            save_strategy="steps",
            eval_steps=20,
            save_steps=20,
            output_dir=output_dir,
            load_best_model_at_end=False,
            group_by_length=True, # group sequences of roughly the same length together to speed up training
            #report_to="wandb", # if use_wandb else "none",
            #run_name=f"codellama-{datetime.now().strftime('%Y-%m-%d-%H-%M')}", # if use_wandb else None,
        )

    trainer = Trainer(
        model=model,
        train_dataset=tokenized_train_dataset,
        #eval_dataset=tokenized_val_dataset,
        args=training_args,
        data_collator=DataCollatorForSeq2Seq(
            tokenizer, pad_to_multiple_of=8, return_tensors="pt", padding=True
            ),
        )

    model.config.use_cache = False
    old_state_dict = model.state_dict
    model.state_dict = (lambda self, *_, **__: get_peft_model_state_dict(self, old_state_dict())).__get__(
        model, type(model)
    )
    if torch.__version__ >= "2" and sys.platform != "win32":
        print("compiling the model")
        model = torch.compile(model)

    output_dir = f"context-codellama"
    print("Training...")

    result = trainer.train(resume_from_checkpoint=False)

    model.save_pretrained(output_dir) 
    reset_models()
    return result
    

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

    load_llama()

    tokenizer.pad_token_id = 0

    if model_name and model_name != "None":
        model = PeftModel.from_pretrained(
            model, model_name,
            torch_dtype=torch.float16
        )
    inputs = tokenizer(text, return_tensors="pt")
    input_ids = inputs["input_ids"].to(model.device)

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

def context_tokenize_and_train_llama(
    training_data,
    max_seq_length,
    micro_batch_size,
    gradient_accumulation_steps,
    epochs,
    learning_rate,
    lora_r,
    lora_alpha,
    lora_dropout,
    model_name,
    size=None):
    global model
    global tokenizer
    reset_models()
    load_llama()
    tokenizer.pad_token_id = 0
    if size is None: 
        paragraphs = training_data.split("<end of text>")
    else: 
        paragraphs = training_data.split("<end of text>")
        assert(len(paragraphs)>=size)
        paragraphs = paragraphs[:size]
        test_paragraphs = paragraphs[size+1:int(size+size*0.2)]
    print("Number of samples: " + str(len(paragraphs)))
        
    def tokenize(item):
        result = tokenizer(
            item["text"],
            truncation=True,
            max_length=max_seq_length,
            padding="max_length",
        )
        return {
            "input_ids": result["input_ids"][:-1],
            "attention_mask": result["attention_mask"][:-1],
        }

    def to_dict(text):
        return {"text": text}

    paragraphs = [to_dict(x) for x in paragraphs]
    test_paragraphs = [to_dict(y) for y in test_paragraphs]   
    data = Dataset.from_list(paragraphs) 
    test_data = Dataset.from_list(test_paragraphs)          
    tokenized_train_dataset = data.shuffle().map(lambda x: tokenize(x))
    tokenized_val_dataset = test_data.shuffle().map(lambda y: tokenize(y))
    data = Dataset.from_list(paragraphs)            
    data = data.shuffle().map(lambda x: tokenize(x))
    model = prepare_model_for_int8_training(model)
    model = get_peft_model(model, LoraConfig(
        r=lora_r,
        lora_alpha=lora_alpha,
        target_modules=["q_proj", "v_proj"],
        lora_dropout=lora_dropout,
        bias="none",
        task_type="CAUSAL_LM",
    ))
    model = model.to("cuda")
    output_dir = f"context-lora-{model_name}"
    #we may or may not need the line below, depending on the device
    #model = model.to(torch.device('cuda'))
    print("Training...")

    training_args = transformers.TrainingArguments(
        # Set the batch size for training on each device (GPU, CPU, or TPU).
        per_device_train_batch_size=micro_batch_size, 

        # Number of steps for gradient accumulation. This is useful when the total 
        # batch size is too large to fit in GPU memory. The effective batch size 
        # will be the product of 'per_device_train_batch_size' and 'gradient_accumulation_steps'.
        gradient_accumulation_steps=gradient_accumulation_steps,  

        # Number of warmup steps for the learning rate scheduler. During these steps, 
        # the learning rate increases linearly from 0 to its initial value. Warmup helps
        #  to reduce the risk of very large gradients at the beginning of training, 
        # which could destabilize the model.
        # warmup_steps=100, 

        # The total number of training steps. The training process will end once this 
        # number is reached, even if not all the training epochs are completed.
        # max_steps=1500, 

        # The total number of epochs (complete passes through the training data) 
        # to perform during the training process.
        num_train_epochs=epochs,  

        # The initial learning rate to be used during training.
        learning_rate=learning_rate, 

        # Enables mixed precision training using 16-bit floating point numbers (FP16). 
        # This can speed up training and reduce GPU memory consumption without 
        # sacrificing too much model accuracy.
        fp16=True,  

        # The frequency (in terms of steps) of logging training metrics and statistics 
        # like loss, learning rate, etc. In this case, it logs after every 20 steps.
        logging_steps=20, 

        # The output directory where the trained model, checkpoints, 
        # and other training artifacts will be saved.
        output_dir=output_dir, 

        # The maximum number of checkpoints to keep. When this limit is reached, 
        # the oldest checkpoint will be deleted to save a new one. In this case, 
        # a maximum of 3 checkpoints will be kept.
        save_total_limit=100,  
    )


    trainer = transformers.Trainer(
        # The pre-trained model that you want to fine-tune or train from scratch. 
        # 'model' should be an instance of a Hugging Face Transformer model, such as BERT, GPT-2, T5, etc.
        model=model, 

        # The dataset to be used for training. 'data' should be a PyTorch Dataset or 
        # a compatible format, containing the input samples and labels or masks (if required).
        train_dataset=tokenized_train_dataset,
        eval_dataset=tokenized_val_dataset,
  
        # The TrainingArguments instance created earlier, which contains various 
        # hyperparameters and configurations for the training process.
        args=training_args, 

        # A callable that takes a batch of samples and returns a batch of inputs for the model. 
        # This is used to prepare the input samples for training by batching, padding, and possibly masking.
        data_collator=transformers.DataCollatorForLanguageModeling( 
            tokenizer,  
            # Whether to use masked language modeling (MLM) during training. 
            # MLM is a training technique used in models like BERT, where some tokens in the 
            # input are replaced by a mask token, and the model tries to predict the 
            # original tokens. In this case, MLM is set to False, indicating that it will not be used.
            mlm=False, 
        ),
    )
    result = trainer.train(resume_from_checkpoint=False)

    model.save_pretrained(output_dir)
    
    reset_models()

    return result

def onestep_tokenize_and_train_llama(
    max_seq_length,
    micro_batch_size,
    gradient_accumulation_steps,
    epochs,
    learning_rate,
    lora_r,
    lora_alpha,
    lora_dropout,
    model_name,
    size=None):
    global model
    global tokenizer
    reset_models()
    load_llama()
    tokenized_train_dataset, tokenized_val_dataset = tokenize_dataset()
    tokenizer.pad_token_id = 0
    model = prepare_model_for_int8_training(model)
    model = get_peft_model(model, LoraConfig(
        r=lora_r,
        lora_alpha=lora_alpha,
        target_modules=["q_proj", "v_proj"],
        lora_dropout=lora_dropout,
        bias="none",
        task_type="CAUSAL_LM",
    ))
    output_dir = f"onestep-lora-{model_name}"
    #we may or may not need the line below, depending on the device
    #model = model.to(torch.device('cuda'))
    print("Training...")

    training_args = transformers.TrainingArguments(
        # Set the batch size for training on each device (GPU, CPU, or TPU).
        per_device_train_batch_size=micro_batch_size, 
        gradient_accumulation_steps=gradient_accumulation_steps,  
        num_train_epochs=epochs,  
        learning_rate=learning_rate, 
        fp16=True,  
        logging_steps=20, 
        output_dir=output_dir, 
        save_total_limit=100,  
    )


    trainer = transformers.Trainer(
        model=model, 
        train_dataset=tokenized_train_dataset,
        eval_dataset=tokenized_val_dataset,
        args=training_args, 
        data_collator=transformers.DataCollatorForLanguageModeling( 
            tokenizer,  
            mlm=False, 
        ),
    )
    result = trainer.train(resume_from_checkpoint=False)
    model.save_pretrained(output_dir)  
    reset_models()
    return result

def onestep_tokenize_and_train_falcon():
    model, tokenizer = load_falcon()
    tokenized_train_dataset, tokenized_val_dataset = tokenize_dataset()
    model.train() # put model back into training mode
    model = prepare_model_for_int8_training(model)
    output_dir = f"onestep-falcon"

    config = LoraConfig(
        r=16,
        lora_alpha=32,
        target_modules=["query_key_value"],
        lora_dropout=0.05,
        bias="none",
        task_type="CAUSAL_LM"
    )
    model = get_peft_model(model, config)
    if torch.cuda.device_count() > 1:
        # keeps Trainer from trying its own DataParallelism when more than 1 gpu is available
        model.is_parallelizable = True
        model.model_parallel = True
    batch_size = 128
    per_device_train_batch_size = 32
    gradient_accumulation_steps = batch_size // per_device_train_batch_size
   
    training_args = TrainingArguments(
            per_device_train_batch_size=per_device_train_batch_size,
            gradient_accumulation_steps=gradient_accumulation_steps,
            warmup_steps=100,
            max_steps=400,
            num_train_epochs=30,  
            learning_rate=3e-4,
            fp16=True,
            logging_steps=10,
            optim="adamw_torch",
            evaluation_strategy="steps", # if val_set_size > 0 else "no",
            save_strategy="steps",
            eval_steps=20,
            save_steps=20,
            output_dir=output_dir,
            load_best_model_at_end=False,
            group_by_length=True, # group sequences of roughly the same length together to speed up training
            #report_to="wandb", # if use_wandb else "none",
            #run_name=f"codellama-{datetime.now().strftime('%Y-%m-%d-%H-%M')}", # if use_wandb else None,
        )

    trainer = Trainer(
        model=model,
        train_dataset=tokenized_train_dataset,
        eval_dataset=tokenized_val_dataset,
        args=training_args,
        data_collator=DataCollatorForSeq2Seq(
            tokenizer, pad_to_multiple_of=8, return_tensors="pt", padding=True
            ),
        )

    model.config.use_cache = False
    old_state_dict = model.state_dict
    model.state_dict = (lambda self, *_, **__: get_peft_model_state_dict(self, old_state_dict())).__get__(
        model, type(model)
    )
    if torch.__version__ >= "2" and sys.platform != "win32":
        print("compiling the model")
        model = torch.compile(model)

    print("Training...")

    result = trainer.train(resume_from_checkpoint=False)

    model.save_pretrained(output_dir) 
    reset_models()
    return result


def contextual_tokenize_and_train_falcon(training_data, size=None):
    global model
    global tokenizer
    reset_models()
    model, tokenizer = load_falcon()
    tokenizer.pad_token_id = 0
    if size is None: 
        paragraphs = training_data.split("<end of text>")
    else: 
        paragraphs = training_data.split("<end of text>")
        assert(len(paragraphs)>=size)
        paragraphs = paragraphs[:size]
        test_paragraphs = paragraphs[size+1:int(size+size*0.2)]
    print("Number of train samples: " + str(len(paragraphs)))
        
    def tokenize(item):
        result = tokenizer(
            item["text"],
            truncation=True,
            max_length=4096,
            padding="max_length",
        )
        return {
            "input_ids": result["input_ids"][:-1],
            "attention_mask": result["attention_mask"][:-1],
        }

    def to_dict(text):
        return {"text": text}

    paragraphs = [to_dict(x) for x in paragraphs]
    test_paragraphs = [to_dict(y) for y in test_paragraphs]
    data = Dataset.from_list(paragraphs) 
    test_data = Dataset.from_list(test_paragraphs)              
    tokenized_train_dataset = data.shuffle().map(lambda x: tokenize(x))
    tokenized_val_dataset = test_data.shuffle().map(lambda y: tokenize(y))
    model.train() # put model back into training mode
    model = prepare_model_for_int8_training(model)

    config = LoraConfig(
        r=16,
        lora_alpha=32,
        target_modules=["query_key_value"],
        lora_dropout=0.05,
        bias="none",
        task_type="CAUSAL_LM"
    )
    model = get_peft_model(model, config)
    if torch.cuda.device_count() > 1:
        # keeps Trainer from trying its own DataParallelism when more than 1 gpu is available
        model.is_parallelizable = True
        model.model_parallel = True
    batch_size = 128
    per_device_train_batch_size = 32
    gradient_accumulation_steps = batch_size // per_device_train_batch_size
    output_dir = "context-code-falcon"

    training_args = TrainingArguments(
            per_device_train_batch_size=per_device_train_batch_size,
            gradient_accumulation_steps=gradient_accumulation_steps,
            warmup_steps=100,
            max_steps=400,
            num_train_epochs=30,  
            learning_rate=3e-4,
            fp16=True,
            logging_steps=10,
            optim="adamw_torch",
            evaluation_strategy="steps", # if val_set_size > 0 else "no",
            save_strategy="steps",
            eval_steps=20,
            save_steps=20,
            output_dir=output_dir,
            load_best_model_at_end=False,
            group_by_length=True, # group sequences of roughly the same length together to speed up training
            #report_to="wandb", # if use_wandb else "none",
            #run_name=f"codellama-{datetime.now().strftime('%Y-%m-%d-%H-%M')}", # if use_wandb else None,
        )

    trainer = Trainer(
        model=model,
        train_dataset=tokenized_train_dataset,
        eval_dataset=tokenized_val_dataset,
        args=training_args,
        data_collator=DataCollatorForSeq2Seq(
            tokenizer, pad_to_multiple_of=8, return_tensors="pt", padding=True
            ),
        )

    model.config.use_cache = False
    old_state_dict = model.state_dict
    model.state_dict = (lambda self, *_, **__: get_peft_model_state_dict(self, old_state_dict())).__get__(
        model, type(model)
    )
    if torch.__version__ >= "2" and sys.platform != "win32":
        print("compiling the model")
        model = torch.compile(model)

    print("Training...")

    result = trainer.train(resume_from_checkpoint=False)

    model.save_pretrained(output_dir) 
    reset_models()
    return result


def onestep_tokenize_and_train_starcoder():
    model, tokenizer = load_starcoder()
    tokenized_train_dataset, tokenized_val_dataset = tokenize_dataset()
    model.train() # put model back into training mode
    model = prepare_model_for_int8_training(model)
    output_dir = f"onestep-starcoder"

    config = LoraConfig(
        r=16,
        lora_alpha=32,
        target_modules = ["c_proj", "c_attn", "q_attn"],
        lora_dropout=0.05,
        bias="none",
        task_type="CAUSAL_LM"
    )
    model = get_peft_model(model, config)
    if torch.cuda.device_count() > 1:
        # keeps Trainer from trying its own DataParallelism when more than 1 gpu is available
        model.is_parallelizable = True
        model.model_parallel = True
    batch_size = 128
    per_device_train_batch_size = 32
    gradient_accumulation_steps = batch_size // per_device_train_batch_size
   
    training_args = TrainingArguments(
            per_device_train_batch_size=per_device_train_batch_size,
            gradient_accumulation_steps=gradient_accumulation_steps,
            warmup_steps=100,
            max_steps=400,
            num_train_epochs=30,  
            learning_rate=3e-4,
            fp16=True,
            logging_steps=10,
            optim="adamw_torch",
            evaluation_strategy="steps", # if val_set_size > 0 else "no",
            save_strategy="steps",
            eval_steps=20,
            save_steps=20,
            output_dir=output_dir,
            load_best_model_at_end=False,
            group_by_length=True, # group sequences of roughly the same length together to speed up training
            #report_to="wandb", # if use_wandb else "none",
            #run_name=f"codellama-{datetime.now().strftime('%Y-%m-%d-%H-%M')}", # if use_wandb else None,
        )

    trainer = Trainer(
        model=model,
        train_dataset=tokenized_train_dataset,
        eval_dataset=tokenized_val_dataset,
        args=training_args,
        data_collator=DataCollatorForSeq2Seq(
            tokenizer, pad_to_multiple_of=8, return_tensors="pt", padding=True
            ),
        )

    model.config.use_cache = False
    old_state_dict = model.state_dict
    model.state_dict = (lambda self, *_, **__: get_peft_model_state_dict(self, old_state_dict())).__get__(
        model, type(model)
    )
    if torch.__version__ >= "2" and sys.platform != "win32":
        print("compiling the model")
        model = torch.compile(model)

    print("Training...")

    result = trainer.train(resume_from_checkpoint=False)

    model.save_pretrained(output_dir) 
    reset_models()
    return result


def contextual_tokenize_and_train_starcoder(training_data, size=None):
    global model
    global tokenizer
    reset_models()
    model, tokenizer = load_starcoder()
    tokenizer.pad_token_id = 0
    if size is None: 
        paragraphs = training_data.split("<end of text>")
    else: 
        paragraphs = training_data.split("<end of text>")
        assert(len(paragraphs)>=size)
        paragraphs = paragraphs[:size]
        test_paragraphs = paragraphs[size+1:int(size+size*0.2)]
    print("Number of train samples: " + str(len(paragraphs)))
        
    def tokenize(item):
        result = tokenizer(
            item["text"],
            truncation=True,
            max_length=4096,
            padding="max_length",
        )
        return {
            "input_ids": result["input_ids"][:-1],
            "attention_mask": result["attention_mask"][:-1],
        }

    def to_dict(text):
        return {"text": text}

    paragraphs = [to_dict(x) for x in paragraphs]
    test_paragraphs = [to_dict(y) for y in test_paragraphs]
    data = Dataset.from_list(paragraphs) 
    test_data = Dataset.from_list(test_paragraphs)              
    tokenized_train_dataset = data.shuffle().map(lambda x: tokenize(x))
    tokenized_val_dataset = test_data.shuffle().map(lambda y: tokenize(y))
    model.train() # put model back into training mode
    model = prepare_model_for_int8_training(model)

    config = LoraConfig(
        r=16,
        lora_alpha=32,
        target_modules = ["c_proj", "c_attn", "q_attn"],
        lora_dropout=0.05,
        bias="none",
        task_type="CAUSAL_LM"
    )
    model = get_peft_model(model, config)
    if torch.cuda.device_count() > 1:
        # keeps Trainer from trying its own DataParallelism when more than 1 gpu is available
        model.is_parallelizable = True
        model.model_parallel = True
    batch_size = 128
    per_device_train_batch_size = 32
    gradient_accumulation_steps = batch_size // per_device_train_batch_size
    output_dir = "context-starcoder"

    training_args = TrainingArguments(
            per_device_train_batch_size=per_device_train_batch_size,
            gradient_accumulation_steps=gradient_accumulation_steps,
            warmup_steps=100,
            max_steps=400,
            num_train_epochs=30,  
            learning_rate=3e-4,
            fp16=True,
            logging_steps=10,
            optim="adamw_torch",
            evaluation_strategy="steps", # if val_set_size > 0 else "no",
            save_strategy="steps",
            eval_steps=20,
            save_steps=20,
            output_dir=output_dir,
            load_best_model_at_end=False,
            group_by_length=True, # group sequences of roughly the same length together to speed up training
            #report_to="wandb", # if use_wandb else "none",
            #run_name=f"codellama-{datetime.now().strftime('%Y-%m-%d-%H-%M')}", # if use_wandb else None,
        )

    trainer = Trainer(
        model=model,
        train_dataset=tokenized_train_dataset,
        eval_dataset=tokenized_val_dataset,
        args=training_args,
        data_collator=DataCollatorForSeq2Seq(
            tokenizer, pad_to_multiple_of=8, return_tensors="pt", padding=True
            ),
        )

    model.config.use_cache = False
    old_state_dict = model.state_dict
    model.state_dict = (lambda self, *_, **__: get_peft_model_state_dict(self, old_state_dict())).__get__(
        model, type(model)
    )
    if torch.__version__ >= "2" and sys.platform != "win32":
        print("compiling the model")
        model = torch.compile(model)

    print("Training...")

    result = trainer.train(resume_from_checkpoint=False)

    model.save_pretrained(output_dir) 
    reset_models()
    return result

def choose_model(context_train_data, model=None, method=None, size=None):
    if model=="llama":
        if method=="context":    
            context_tokenize_and_train_llama(
                context_train_data,
                max_seq_length=4096,
                micro_batch_size=1,
                gradient_accumulation_steps=16,
                epochs=30,
                learning_rate=2e-5,
                lora_r=8,
                lora_alpha=32,
                lora_dropout=0.1,
                model_name='context_llama_7B',
                size=size) #pass on lora model name 
        if method=="onestep" or method is None:    
            onestep_tokenize_and_train_llama(
                max_seq_length=4096,
                micro_batch_size=1,
                gradient_accumulation_steps=16,
                epochs=30,
                learning_rate=2e-5,
                lora_r=8,
                lora_alpha=32,
                lora_dropout=0.1,
                model_name='onestep_llama_7B',
                size=size) #pass on lora model name 
    elif model=="codellama":
        if method=="context": 
            contextual_tokenize_and_train_codellama(context_train_data, size) 
        if method=="onestep" or method is None: 
            onestep_tokenize_and_train_codellama()
    elif model=="falcon":
        if method=="context": 
            contextual_tokenize_and_train_falcon(context_train_data, size) 
        if method=="onestep" or method is None: 
            onestep_tokenize_and_train_falcon()
    elif model=="starcoder":
        if method=="context": 
            contextual_tokenize_and_train_starcoder(context_train_data, size) 
        if method=="onestep" or method is None: 
            onestep_tokenize_and_train_starcoder() 
    elif model is None: 
            onestep_tokenize_and_train_codellama()

def main():
    args = parse_args()
    context_train_file = open('../dataset_gen/datasets/tot_pp2invariants.txt', "r")
    context_train_data = context_train_file.read()
    choose_model(context_train_data, args.model, args.method, args.s)

   
 #lora hyperparameters from this paper: https://github.com/microsoft/LoRA/tree/main/examples/NLG      
if __name__ == "__main__":  
    main()
