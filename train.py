import os
import argparse
import random
import torch
import transformers
from datasets import Dataset
from transformers import LlamaForCausalLM, LlamaTokenizer, GenerationConfig
from peft import prepare_model_for_int8_training, LoraConfig, get_peft_model, PeftModel

model = None
tokenizer = None
peft_model = None

def maybe_load_models():
    global model
    global tokenizer

    if model is None:
        model = LlamaForCausalLM.from_pretrained(
            "sallywww/Llama-7B",
            load_in_8bit=True,
            torch_dtype=torch.float16,
            device_map= "auto",
        )

    if tokenizer is None:
        tokenizer = LlamaTokenizer.from_pretrained(
            "sallywww/Llama-7B",
        )

def reset_models():
    global model
    global tokenizer

    del model
    del tokenizer

    model = None
    tokenizer = None

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

    maybe_load_models()

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

def tokenize_and_train(
    training_data,
    max_seq_length,
    micro_batch_size,
    gradient_accumulation_steps,
    epochs,
    learning_rate,
    lora_r,
    lora_alpha,
    lora_dropout,
    model_name):
    global model
    global tokenizer
    reset_models()
    maybe_load_models()
    tokenizer.pad_token_id = 0
    paragraphs = training_data.split("<end of text>")
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
    output_dir = f"lora-{model_name}"
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
        train_dataset=data, 

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

 #lora hyperparameters from this paper: https://github.com/microsoft/LoRA/tree/main/examples/NLG      
if __name__ == "__main__":  
        train_file = open('./dataset_gen/datasets/tot_train_data.txt', "r")
        train_data = train_file.read()   
        tokenize_and_train(train_data,
        max_seq_length=4096,
        micro_batch_size=1,
        gradient_accumulation_steps=16,
        epochs=30,
        learning_rate=2e-5,
        lora_r=8,
        lora_alpha=32,
        lora_dropout=0.1,
        model_name='llama_7B_tot') #pass on lora model name 