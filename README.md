# SmartInv Overview
This Repo contains the tool chain, documented results, and reproducing scripts of our S&P'24 [paper](https://www.computer.org/csdl/proceedings-article/sp/2024/313000a126/1Ub23GNTAeQ) and [corrected copy]() that fixes presentation errors. We provide artifacts and reproducing scripts for main contributions and results reported in the paper. 

## Annotated Fine-tuning Datasets 
All datasets used for training are available in dataset_gen and the linked google files. 

[Raw dataset 1](https://docs.google.com/spreadsheets/d/1VRI2ej4l4OsClfaFeHEzgKyjtmiDgAyqxLaJ7w9z0Y4/edit?usp=sharing): we manually collected this data set. this data set is used for both data set finetuning and ToT Finetuning. It's also saved in the 'datasets' subfolder of 'dataset_gen' folder.  The format is as following:

| Contracts     | All Invariants | Critical Program Points  | Critical Invariants |Inferred conditions |Invariant based on conditions |
| ------------- |--------------:| -------------------------:| --------------------|--------------------|--------------------|
| contract #1.  | invariant 1, 2, 3... |1+, 2+, 3+ ...      | invariant 3+ |4+ Old(a) = a|27+ assert(Old(a) <= a) |
                

[Raw dataset 2](https://docs.google.com/spreadsheets/d/1Nhz6hK46CsttVFXj7wAyBXz7Xu4kQ9r-n-jmMKaZ0dg/edit?usp=sharing): we manually collected this data set. This data set is mainly used for Tier of Thought Finetuning. It's also saved in the 'datasets' subfolder of 'dataset_gen' folder. The format is as following:

| Contracts     | All Invariants | Program Point | Invariant  |
| ------------- |--------------:| -------------------------:| --------------------|
| contract #1.  | invariant 1, 2, 3... |1+      | invariant 1 |
| contract #1.  | invariant 1, 2, 3... |2+      | invariant 2 |
| contract #1.  | invariant 1, 2, 3... |3+      | invariant 3 |

To generate all json files and txt files for finetuning, please run the following command: 

```
cd dataset_gen
python generator.py
```

We include datasets in many formats, including fine-tuning GPT-style model and PEFT-style models. After prompting related augumentaation, the [largest fine-tuning dataset](https://github.com/columbia/SmartInv/blob/main/dataset_gen/datasets/complex_tot_train_data.txt) consists 3000+ training samples. Please go to the [dataset overview](https://github.com/columbia/SmartInv/tree/main/dataset_gen) for further details. All generated datasets will be automatically saved in the 'datasets' subfolder. If you want to clean the datasets folder and re-generate the datasets, you can simply run `python clean.py' in the 'datasets' subfolder. Alternatively, you can also use the data_gen.ipynb file provided in the folder to generate all training datasets on coLab. 

## Benchmarks
**[Large scale benchmarks of 80k+ contracts](https://github.com/columbia/SmartInv/blob/main/tests/contracts)**: this file contains the 80k+ contracts crawed from etherscan that are used for large scale experiments as reported in Table 6 and Table 7 of our paaper. If you are interested in crawling more, newer contracts from etherscan, please refer to the [manual here](https://github.com/columbia/SmartInv/tree/main/tests/scripts). 

**[Refined benchmarks of1200+ contracts with ground truths](https://github.com/columbia/SmartInv/tree/main/tests/refined_analysis)**: this benchmark is collected from the author's own auditing, other auditing reports, and [Web3Bugs](https://github.com/ZhangZhuoSJTU/Web3Bugs/tree/main/contracts). In the ``natural bugs`` folder, the ground truths are in [this json file](https://github.com/columbia/SmartInv/blob/main/tests/refined_analysis/natural_bugs/refined_analysis_truths.json). Note the corresponding ground truths of a given contract is separated by comma. For example, it contains \{contract_1, contract_2..., contract_1_truth\ncontract_1_truth\ncontract_1_truth, contract_2_truth\ncontract_2_truth\ncontract_2_truth...\}. We alsso confirmed these hacks in a sandboxed Foundry environment, documented in a former repo [attackDB](https://github.com/sallywang147/attackDB). 

For future users, we must caution that the ground truths and fine-tuning datasets are obtained from manual review. Despite the author's best efforts, the bug classifications can be inherently subjective and may contain errors. So please use with caution. 

## Reproducing Motivating Examples and Experiments in Evaluation (or See Documented Results)
We conducted experiments on A100 GPU (sometimes a coLab account with plus access), 5.10.0-28-cloud-amd64 gcloud engine (the kernel version is important, because the verifier installation is very tricky and requires a particular linux version), and an old MacAir (some tools, e.g. VeriSmart and SmarTest can be reproduced on Mac, but not on our gcloud engine). 

First, let's install the requirements of SmartInv: 
1. git clone this repo
2. `cd SmartInv` and copy paste below: 
```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt -U
```
3. `export OPENAI_API_KEY='<your-api-key>`

Before you start the experiment, you might want to replace the specific file paths in [smartinv.py](https://github.com/columbia/SmartInv/blob/1b5e94e5cc81dfaf459eb6c2ae146b4f043328bd/smartinv.py#L262C1-L262C62), directory paths at the beginning of [infer.py](https://github.com/columbia/SmartInv/blob/main/verifier/infer.py), [sub_smartinv.py](https://github.com/columbia/SmartInv/tree/main/tests), and [infer_upgrade.py](https://github.com/columbia/SmartInv/blob/main/verifier/infer_upgrade.py). You will need to replace any paths starting with "/home/sallyjunsongwang" to your own home directory. Sincere apologies for the inconvenience. I thought of developing docker, but the use of several fine-tuned foundation models prevented that. So I built separate [applications](#Applications) for inference and verifation instead. 
   
### Reproducing Motivating Example 1 (Listing 2)
```
cd ~/SmartInv
python smartinv.py --exp1 True
```
Verification result and traces will be automatically saved at specified [verified_results_dir](https://github.com/columbia/SmartInv/blob/decc5896629da422161945224296d0b51bb6096f/smartinv.py#L56C1-L56C36). The documented experiment result is in [verified_results](https://github.com/columbia/SmartInv/tree/main/verified_results/simplifiedVisor). 

### Reproducing Motivating Example 2 (Listing 3)
```
cd ~/SmartInv
python smartinv.py --exp2 True
```
Verification result and traces will be automatically saved at specified [verified_results_dir](https://github.com/columbia/SmartInv/blob/decc5896629da422161945224296d0b51bb6096f/smartinv.py#L56C1-L56C36). The documented experiment result is in [verified_results](https://github.com/columbia/SmartInv/tree/main/verified_results/TimelockController). Because I(Sally) love this example quite a bit, so there are different variations of the example and results ([v1](https://github.com/columbia/SmartInv/blob/main/verifier/timecontroller_fix_inv.sol), [v1_result](https://github.com/columbia/SmartInv/blob/main/verifier/timecontroller_fix_inv_corral.txt), [v2](https://github.com/columbia/SmartInv/blob/main/verifier/raw_timecontroller_v2_inv.sol), [v2_result](https://github.com/columbia/SmartInv/blob/main/verifier/corral_inv2.txt))

### Reproducing Large Scale Experiment (Table 6 and 7 on p.g. 10) - Expected Completion Time: 2 weeks

We first need to install the other tools - veriSmart, SmarTest, Slither, Mythril, Manticore. The author installed VeriSmart and SmarTest from their github page and ran the tool on Mac, installed Slither by ``pip insall``, and used the dockers of Mythril and Manticore. Basically, to reproduce this epxeriment, please run the following commands first to install the other tools: 

for SmarTest and VeriSmart, please run the following: 
```
git clone https://github.com/kupl/VeriSmart-public.git
cd VeriSmart-public
```
```
opam install -y conf-m4.1 ocamlfind ocamlbuild num yojson batteries ocamlgraph zarith
wget https://github.com/Z3Prover/z3/releases/download/z3-4.7.1/z3-4.7.1.tar.gz
tar -xvzf z3-4.7.1.tar.gz
cd z3-z3-4.7.1
python3 scripts/mk_make.py --ml
cd build
make -j 4
sudo make install
chmod +x build
./build
```
for Slither, please run the following: 
```
python3 -m pip install slither-analyzer
```
for Mythril, please run the following: 
```
docker pull mythril/myth
```
for Manticore, please run the following: 
```
pip install manticore
```
Once you have them installed, you are ready to run the experiment by the following command: 

```
cd ~/SmartInv
python smartinv.py --large_exp True
```
The reproduced results will be automatically saved in large_exp_results directory that is specified in [this line](https://github.com/columbia/SmartInv/blob/decc5896629da422161945224296d0b51bb6096f/smartinv.py#L57) of the smartinv.py file. 

However, if you, like me using a gcloud engine mostly, cannot properly install SmarTest, VeriSmart, and Mantiore for some weird opam and linux compatitability reasons, a salvation path is to run SmarTest, VeriSmart, and Mantiore on Mac and run Slither, SmartInv, and VeriSol on Linux machine. The following scripts are provided to run SmarTest, VeriSmart, and Mantiore on Mac. You can comment out the corresponding lines in ``smartinv.py`` [here](https://github.com/columbia/SmartInv/blob/decc5896629da422161945224296d0b51bb6096f/smartinv.py#L309). 

```
cd ~/SmartInv/tests
python sub_smartinv.py --large_exp True
```
If you do not like going through all these steps, another salvation path is to check out saved [large scale experiment results dcoumented here](https://github.com/columbia/SmartInv/tree/main/large_exp_results).

### Reproducing Refined Analysis Experiment (Table 8) - Expected Completion Time: 3-5 hours

The hurdles are similar to the large scale experiment above, GPTT4except we run the tools on fewer contracts. Please run the following script: 

```
cd ~/SmartInv
python smartinv.py --refined_exp True
```
Or you can cehck out the saved [refined experiment results documented here](https://github.com/columbia/SmartInv/tree/main/refined_exp_results)


### Reproducing Prompting Experiment (Fig. 2)  - Expected Completion Time: 2 hours

```
cd ~/SmartInv
python smartinv.py --prompt_exp True
```

Or you can cehck out the saved [prompting experiment results documented here](https://github.com/columbia/SmartInv/tree/main/all_results/prompting_results)



### Reproducing Runtime Experiment (Table 10) - Expected Completion Time: 30min - 1 hour

```
cd ~/SmartInv
python smartinv.py --runtime_exp True
```
The output will be print out to terminal. More code related to this experiment will be pushed in the coming days. 

### Reproducing Invariants Inspection and Ablation Experiment (Table 9 and 11) - Expected Completion Time: negligible (assuming the use of documented resullts)
There are two ways to run evaluations and reproduce the results presented in our paper. Let's take peft_llama as an example: 

**First way**
1. reproducing results by python scripts: for full batch evaluation of all benchmark contracts discussed in our paper, you can run the following command for contracts at the root of 'tests' folder. If you want to run evaluation scripts of our other finetuned model such as T5 and/or GPT2, you only need to cd into the corresponding model folder and replace the .py file accordingly. 
              
      `cd ./evaluation/peft_llama`.
      `python peft_llama_eval.py ../../tests`.
      
 If you want to save the evaluation in a separate folder, you can run:
      
      `python peft_llama_eval.py ../../tests [your selected folder]` 
      
 For contracts in the subfolders, you can run:
      
      `python peft_llama_eval.py ../../tests/[subfolder]`
      
 For example, 
      
      `python peft_llama_eval.py ../../tests/contextual_bugs_test`

2. reproducing results by coLab cloud: in each model folder, we also provide a coLab file that allows you to run evaluation on coLab directory. 

3. reproducing on our frontend web UIs. Please see details in the Applications Section.

**Second way**

```
cd ~/SmartInv
python smartinv.py --ablation_exp True
```
The output will be print out to terminal.  More code related to this experiment will be pushed in the coming days. 

### Zero-day bugs (Section 7)

We pushed the confirmed and unexploitable zero-day bugs discovered by SmartInv [here](https://github.com/columbia/SmartInv/tree/main/all_results/zero_days). We will provide more information in future after developers' confirmation and fixes. 


## Reproducing Methodology (Model Fine-tuning and Results)
![model_loss_update (1)](https://github.com/columbia/SmartInv/assets/60257613/7121c305-a4fc-4fea-90bc-046445b653f1)

**First Way**
Please refer to our [fine-tuning README](https://github.com/columbia/SmartInv/tree/main/finetune) for specific instructions.

1. Hardware: to finetune alpca-llama, we recommend 4 x A6000 GPUs; to finetune OPT2-350M, we recommend 2 x A100 GPUs. To finetune GPT2, T5, and PEFT-LLaMA, a single single NVIDIA V100 or A100 Tensor Core GPU is sufficient. 

2. torch and transformers version matter for successful finetuning. Take alpaca-llama as an example, it requires torch==1.13.1. All llama-based models require transformers >= 4.27.0.dev0. 

First, please git clone this repo and install all requirements. Then please follow the following steps: 

```
cd models_train
```

```
pip install -r requirements.txt
```

Assuming you already have all the datasets as mentioned in the dataset generation section above, to finetune alpca-llama based model, you can run:

```
sh train_llama.sh
``` 

To CoT finetune regular LLaMA, you can run the following command in the same directory (Note: we assume that you have already run the proper commands in dataset_gen directory and you already generated the training dataset named "cot_train_data.json". Since this command is to finetune regular LLaMA, it's imperative that your hardware supports distributed training and has at least 4 GPUs (in our case, we use 4 x A6000): 

```
cd models_train
sh train_cot.sh
``` 

To finetune facebook's opt-family model, you can run:

```
sh train_opt.sh
```

To finetune T5 and GPT2, you can run the .ipynb files directly on coLab.

To finetune PEFT-LLaMA, please cd back to the root of the this git directory by running the following:

```
cd ../../SmartInv
python train.py
```

## Applications 

### Deployed Models

All finetuned models below as presented in our paper are also deployed on huggingface and can be directly imported for invariants inference. 
 
[data set finetuned T5](https://huggingface.co/sallywww/T5-invariants): this model doesn't include ToT. Just conracts and invariants. 

[data set finetuned GPT2](https://huggingface.co/sallywww/GTP2-invariants): this model doesn't include ToT. Just conracts and invariants.

[data set finetuned OPT-350M](https://huggingface.co/sallywww/opt-invariants): this model doesn't include ToT. Just conracts and invariants.

[data set finetuned  PEFT-LLaMA](https://huggingface.co/sallywww/insft50e_llama7b): this model doesn't include ToT. Just conracts and invariants.

[data set and chain of thought finetuned PEFT-LLaMA](https://huggingface.co/sallywww/CoT_llama): this model tries to mimic Chain of Thought, not Tier of Thought

[data set finetuned Alpaca-LLaMA](https://huggingface.co/sallywww/trained_llama_stanford_format), this model doesn't include ToT. Just conracts and invariants.

[data set and chain of thought finetuned Original LLaMA](https://huggingface.co/sallywww/cot_full_llama),this model doesn't include ToT. Just conracts and invariants, nor is it optimized for PEFT

[ToT Peft LLaMA](https://huggingface.co/sallywww/tot_llama_update): this model is fine-tuned on [ToT data](https://github.com/columbia/SmartInv/blob/main/dataset_gen/datasets/complex_tot_train_data.txt)

[inv Peft LLaMA](https://huggingface.co/sallywww/invonly): this model is fine-tuned on [a small invariant data](https://github.com/columbia/SmartInv/blob/main/dataset_gen/datasets/tot_invaraiants_only.txt) and answers only one question ``What are the invariants in the questions?"

[bug Peft LLaMA](https://huggingface.co/sallywww/tier3b_bug): this model is fine-tuned on [a small bug data](https://github.com/columbia/SmartInv/blob/main/dataset_gen/datasets/tot_bug.txt) and answers only one question ``What are the vulnerabilities in the questions?"

As you can tell in our smartinv.py, we tried multiple model outputs and reported the best performing in documented results. 

### User Interface

[PEFT-LLaMA Finetuner](https://huggingface.co/spaces/sallywww/peft_llama_finetuner/blob/main/app.py): we deploy our finetuned PEFT-LLaMA in this application, It can also be easily adapted for other downstream tasks. 

[Automated Inference-to-Verification Pipeline](https://automatedcontractnvariantverificationpipeline.anvil.app): we verify inferred invariants by pipelining our inferred invariants to a bounded model checker in this app. In case you'd like to adapt our verifier tool for other tasks, please refer to our [deployed verifier backend here](https://deepnote.com/workspace/columbia-220d-6d06653a-9da8-4600-abe5-788764e7a1dd/project/innvariantpipeline-d0de821e-6b37-422f-9bbc-a2df12491510/notebook/Fine_tuned_T5_VeriSol_Pipeline-61aba64c09654268b351c336e9450a71).

[Proof of Bugs](https://github.com/sallywang147/attackDB/tree/webpage): as presented in our paper, in the event that the solidity compiler of a contract is not compatible with our verifier, we also provide proof of bugs by reproducing the hack on forked mainnet environment in the linked database. 

## Standalone Tool Usage

SmartInv has two modes:  ``--heavy`` and ``--light``. They refer to the intensity of GPU resources requirement. We observe that finetuned PEFT model (heavy mode) is far more resources intensive than GPT-4 (light mode). So we provide two usages of SmartInv, backed by different models. We recommend heavy mode only if you have abundant GPU resources. Otherwise, you might run into CUDA OOM. 
**light mode**:

```
cd ~/SmartInv
python smartinv.py --light True --file [folder/subfolder/myCoolConntract.sol] --contract [myCoolContract.sol] 
```

**heavy mode**:

```
cd ~/SmartInv
python smartinv.py --heavy True --file [folder/subfolder/myCoolConntract.sol] --contract [myCoolContract.sol] 
```

This is [sampled raw model outputs](https://github.com/columbia/SmartInv/tree/main/all_results/sampled_results) from the heavy mode

## Limitations (a.k.a. How You Can Significantly Beat SmartInv in Your Next Paper Easily)

In addition to the limitations we've acknowledge in paper, there are quite a few other significant limitations that can help other ressearchers who are in this space and try to improve the State-of-the-art: 

1. **model underterministic output**: models, especially GPT4 (light-mode SmartInv as a result), cannot generate deterministic output on the same input. This leaves the performance unstable and un-principled.


2. **the lack of a uniform benchmark on functional bugs**: current benchmarks largely rely on human auditing. Different papers on similar topicss use drastically different benchmarks. If we have a uniform benchmark, that can be a step forward. 
   
3. **heavy manual work and lack of automation**: first of all, the lack of dataset in smart contract invariants means that we have to resort to manual work before doing anything interesting. SmartInv somtimes still require human intervention after inference to fix compilation errors. 

## Acknowledgements
In addition to the long citation list in the paper, our work is indebted to many other forebearers in this space. This repo is only possible, because of the wonderful work performed by other researchers coming before us. We are very grateful for the industrial tools, vanilla models, and prompting approaches used in our experiments. Their extraordinary efforts and tool-building made this work and the insights possible. We would like extend our appreciation to [SunWeb3Sec](https://github.com/ZhangZhuoSJTU/Web3Bugs?tab=readme-ov-file#valuable-resources-for-web3-security), [Web3Bugs](https://github.com/ZhangZhuoSJTU/Web3Bugs?tab=readme-ov-file#valuable-resources-for-web3-security), and [SmartWild Dataset](https://github.com/smartbugs/smartbugs-wild). These prior benchmarks made SmartInv author's life so much easier. 

## Soon To Be Updated Items in the Coming Days

1. ablation scripts and light mode scripts
2. more sampled raw model outputs to be pushed
3. more zero-day to be uploaded
4. more results from large-scale and refined experiments to be pushed 


