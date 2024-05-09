from openai import OpenAI
client = OpenAI()
'''
completion = client.chat.completions.create(
  model="ft:davinci-002:personal::8s2do7Ym",
  messages=["prompt: struct hb_face_t * hb_subset_preprocess(struct hb_face_t * source)"]
  )
'''


completion = client.chat.completions.create(
  model="ft:davinci-002:personal::8s2do7Ym",
  messages=[
    {"prompt": "system", "completion": "You are a helpful assistant."}
  ]
)
print(completion.choices[0].message)