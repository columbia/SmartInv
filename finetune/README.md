

# Fine-tuning Usage Guide 

| Ssupported Models  | Fine-tuning Methods |Train Time by Methods (hours)|Total Train Time (days)|Quantization|LoRA|
| ------------- | ------------- | ------------- | ------------- |------------- |------------- |
| LLaMA  | contextualized; one-step  |contextualized: 212; one-step: 12 | 10 |8 bits|yes|
| CodeLLaMA  | contextualized; one-step| contextualized: 96.71; one-step:6.57| 4.3|8 bits|yes|
| Falcon  | contextualized; one-step  |contextualized: 89;  one-step: 4.56|4|4bits|yes|
| StarCoder  | contextualized; one-step|contextualized:131; one-step: 5.61|5.6 |8 bits|yes|
| GPT4  |  one-step |contextualized:N/A; one-step: 0.05|negligible|N/A|N/A|

Train Time and Total Time: we provide the expected train time based on the following hyperparameters of PEFT models and on the parallel usage of at least two A100 GPUs. In our case, we use the 2xA100 commercial GPUs from [Paperspace](https://www.paperspace.com/) for all fine-tuning and evaluation. 

GPT4: due to the limitation of [tiered users](https://platform.openai.com/docs/guides/rate-limits/usage-tiers?context=tier-four), we were only able to fine-tune GPT4 davinci-002 with 5 epochs and 40 traininng samples. 

Falcon 4-bit quanntizaion: we did not use 8 bits like the other models, because 4bits is [recommended practice](https://www.labellerr.com/blog/hands-on-with-fine-tuning-llm/) by ML researchers for Falcon in this case. 

| Hyperparameters  | Values|
| ------------- | ------------- |
| Epochs  | 30 | 
| Learning Rate  |2e-5 for LLaMA; 3e-4 for the rest |
| Lora-r  | 16  |
| Lora-alpha  | 32  |
| Lora-dropout | 0.05 |


|  Fine-tuning Methods |Total Dataset Size|Training Dataset Size|Eval. Dataset Size|
| ------------- | ------------- |------------- |------------- |
| contextualized  |  12,261|2,000|400|
| one-step  |1,937 |1,549 |387 |



_Caution for users: this fine-tuning section is under active development and fine-tuning code has not been reviewed. It likely contains errors, ommissions, and hidden bugs._

## Fine-tuning Methods and Datasets Generation
We detail our fine-tuning methods and associated dataset generation approaches below. The reported results are all based on 7B models. However, if your computation resources
permit fine-tuning on bigger models (such as the 70B family), we expect you will see even better results that what we've obtained below. 

### Fine-tuning Methods

Assuming you have all relevant datasets in ``../train_data`` directory (if not, please see the ''Datasets Generation'' subsection to generate relevant datasets first. 

1. **contextualized fine-tuning**: this method provides more detailed examples and instructions to the model before prompting it for a fuzz target. To train a model this way,
you can use the following script:
 ```
   cd finetune
   pip install -r requirements.txt -U
   python peft_finetune.py -model [model_name] -method context -s [optional: dataset size]
  ```
All parameters should be lower case. For example, ``python peft_finetune.py -model codellama -method context -s 50`` or simply ``python peft_finetune.py -model codellama -method context``
  
2. **One-step ine-tuning**: this method provides limited information in the prompt. Basically, it finetunes the model directly from function signatures to fuzz targets. You can use the following scripts:

 ```
   cd finetune
   pip install -r requirements.txt -U
   python peft_finetune.py -model [model_name] -method onestep -s [optional: dataset size]
  ```
The default setting would split the dataset into 80:20 for training and evaluation.

### Datasets Generation
In the finetune directory, please run the following command:
`python finetune_data.py --results <results_dir>`

 `<results_dir>` is the directory, where prompting only results are obtained. Please see [user guide](https://github.com/sallywang147/llmfz/blob/main/USAGE.md) on
 how to obtain prompting only based results. 

 The script will prepare three types of datasets and store the datasets in  `<results_dir>`  in response to different models: 

 1. [contextualized dataset](https://github.com/sallywang147/llmfz/blob/main/train_data/context.txt) (a .txt file particularly suitable for PEFT finetuning):

```
This is function signature: <function header>
prompt.txt in <results_dir>
function fuzz target(s) are: <target_1> <target_2>...
<end of text>
```
The comparison benchmark generates 203 training samples for contextualized finetuning.

 2. [one-step dataset w/out contexts](https://github.com/sallywang147/llmfz/blob/main/train_data/onestep.json) (a .json file without contextual information, particularly suited for GPT-3.5 and T5 models):

 ```
{"prompt": "You are a security engineer <some background info> function signature_1",
"completion":  "<target_1> "
}
{"prompt": "function signature_2",
"completion":  "<target_2> "
}
{"prompt": "function signature_3",
"completion":  "<target_3> "
}
```

3. GPT fine-tuning dataset: we minimized background info in prompts, due to highly limited token lengths. 
```
{"prompt": "function signature_1",
"completion":  "<target_1> "
}
{"prompt": "function signature_2",
"completion":  "<target_2> "
}
{"prompt": "function signature_3",
"completion":  "<target_3> "
}
```

### GPT4 Fine-tuning 

Note: I actually don't recommend fine-tuning GPT4. It requires a very rigid dataset format, which the raw data might not satisfy. 

 GPT4 fine-tuning dataset has strict requirements. So it requires further processing to get the format right. See [dataset formatting](https://platform.openai.com/docs/guides/fine-tuning/preparing-your-dataset)

 1. After generating training data (assuming your results are stored in the `train_data` directory, run `python reformmat.py` to generate openAI supported dataset
 2. run ``python gpt_finetune.py -s [optional: training data size]``. For example, ``python gpt_finetune.py -s 5``. We do not recommend supplying large training data size unless you are on OpenAI's high user tiers. 
 4. you are done!

 ## Fine-tuned Models Ready for Use 

 ### One-step Fine-tuning
 [deployed LLaMA](https://huggingface.co/sallywww/LLaMA_oneStep_fuzzTragets/tree/main); 
 [deployed codeLLaMA](https://huggingface.co/sallywww/codeLLaMA_oneStep_fuzzTargets/tree/main); 
 [deployed Falcon](https://huggingface.co/sallywww/Falcon_oneStep_fuzzTargets/tree/main); 
 [deployed StarCoder](https://huggingface.co/sallywww/StarCoder_oneStep_FuzzTargets/tree/main);
 [deployed GPT4](https://platform.openai.com/finetune/ftjob-F9QcCnzaLzvbhYxtGaM2gSzs?filter=successful)
 

  ### Contextualized Fine-tuning

 ## Results
We evaluate the fine-tuned models on two questions: 
1. Using human-writen fuzz targets as ground truths, how do fine-tuned models compare to pre-trained models? (a.k.a. How much does fine-tuning help, if at all?)
2. On previously unseen under-covered function signatures, can fine-tuned models generate fuzz targets compile successful and improve coverage? (a.k.a. the good, old coverage question)

### Q1. How do fine-tuned models compare to pre-trained models?

 #### One-step Fine-tuning 

 | Models  | Training Loss|Eval Loss|
| ------------- | ------------- |------------- |
| CodeLLaMa  | 0.22 | 0.34 | 
| LLaMA  | 0.167 | 0.312|
|  Falcon |7.175 |NaN |
| StarCoder |0.1998  |0.338 |
| GPT4(Note) |0.07 |N/A |

Note: GPT4 fine-tuning was completed on super limited data and 5 epochs only. 

 **CodeLLama**
 
<img width="566" alt="Screen Shot 2024-02-21 at 6 40 01 AM" src="https://github.com/sallywang147/llmfz/assets/60257613/c5688662-2236-44de-9774-1c33219f48bd">

 **LLama**

<img width="482" alt="Screen Shot 2024-02-21 at 9 49 24 PM" src="https://github.com/sallywang147/llmfz/assets/60257613/8ecf94b0-6ced-4528-8ca9-9fa317ab356f">


 **Falcon**
 
<img width="483" alt="Screen Shot 2024-02-21 at 7 36 00 AM" src="https://github.com/sallywang147/llmfz/assets/60257613/ad97346c-7d26-4b26-ad49-4a2875167fb7">

 **StarCoder**

 <img width="492" alt="Screen Shot 2024-02-22 at 2 17 58 AM" src="https://github.com/sallywang147/llmfz/assets/60257613/8c82f5cc-3cb0-40fd-843c-f10c8148ab1b">

 **GPT4**
<img width="1037" alt="Screen Shot 2024-02-21 at 9 35 47 AM" src="https://github.com/sallywang147/llmfz/assets/60257613/be3d89a6-583a-4a3e-aeec-96e2ce486d79">

 ####  Contextualized Fine-tuning 

 
 | Models  | Training Loss|Eval Loss|
| ------------- | ------------- |------------- |
| CodeLLaMa  |  |  | 
| LLaMA  | 0.42| |
|  Falcon | | |
| StarCoder |  | |

LLaMA

<img width="459" alt="Screen Shot 2024-02-23 at 5 10 02 PM" src="https://github.com/sallywang147/llmfz/assets/60257613/572430d1-a08b-41ae-b9ee-b0500cdc7f8a">

 ### Q2. The good, old coverage question (on previously unseen programs)

remember to run ``sudo apt install clang-format`` before starting. 

Sample script used to reproduce a single benchmark results: ``python3.11 ./run_all_experiments.py --model ftpeft_llama -y './benchmark-sets/all/harfbuzz.yaml' --work-dir=harfbuzz_finetune_results -to 180``

  | Benchmarks  | Fuzz Targets |Cov. Improvement|Model |Prompt history|
| ------------- | ------------- |------------- |------------- |------------- |
|   |  |  | | |
 
