import os
import sys
import argparse
import json
import random
import torch
import transformers
from datasets import Dataset, load_dataset
from accelerate import dispatch_model, infer_auto_device_map
from accelerate.utils import get_balanced_memory
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
    PeftConfig,
    get_peft_model,
    PeftModel,
    get_peft_model_state_dict,
    set_peft_model_state_dict,
)



harfbuzz_sigs = ["struct hb_face_t * hb_subset_preprocess(struct hb_face_t * source)",
                 "void hb_ot_shape_glyphs_closure(struct hb_font_t * font, struct hb_buffer_t * buffer, struct hb_feature_t * features, int num_features, struct hb_set_t * glyphs)",
                 "int hb_shape_justify(struct hb_font_t * font, struct hb_buffer_t * buffer, struct hb_glyph_extents_t * features, int num_features, char ** shaper_list, float min_target_advance, float max_target_advance, float * advance, int * var_tag, float * var_value)",
                 "double solve_itp<hb_shape_justify::$_3>(anon * f, double a, double b, double epsilon, double min_y, double max_y, double * ya, double * yb, double * y)",
                 "double hb_shape_justify::$_3::operator(anon * this, double x)",
                 ]
harfbuzz_count = 1



# HumanEval helper

def generate_one_completion(prompt: str):
    tokenizer.pad_token = tokenizer.eos_token
    inputs = tokenizer(prompt, return_tensors="pt", truncation=True, max_length=4096)

    # Generate
    generate_ids = model.generate(inputs.input_ids.to("cuda"), max_new_tokens=384, do_sample=True, top_p=0.75, top_k=40, temperature=0.1)
    completion = tokenizer.batch_decode(generate_ids, skip_special_tokens=True, clean_up_tokenization_spaces=False)[0]
    completion = completion.replace(prompt, "").split("\n\n\n")[0]

    return completion

# perform HumanEval
#problems = read_problems()

def main():
    model_path = "Phind/Phind-CodeLlama-34B-v2"
    model = LlamaForCausalLM.from_pretrained(model_path)
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
    tokenizer = AutoTokenizer.from_pretrained(model_path)
    if os.path.isdir("../finetuned_results") is False:
      os.mkdir("../finetuned_results")
    if os.path.isdir("../finetuned_results/output_harfbuzz") is False:
      os.mkdir("../finetuned_results/output_harfbuzz")
    for i in harfbuzz_sigs:
      raw_target = open(f"../finetuned_results/output_harfbuzz/0{harfbuzz_count}.rawoutput", "w+")
      generated_target = generate_one_completion(i)
      print(generated_target)
      raw_target.close()
      raw_target.write(generated_target)

if __name__ == "__main__":  
    main()