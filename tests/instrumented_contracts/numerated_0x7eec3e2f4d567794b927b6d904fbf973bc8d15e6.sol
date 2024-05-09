1 # @version 0.3.7
2 """
3 @title Compass-EVM
4 @author Volume.Finance
5 """
6 
7 MAX_VALIDATORS: constant(uint256) = 320
8 MAX_PAYLOAD: constant(uint256) = 20480
9 MAX_BATCH: constant(uint256) = 64
10 
11 POWER_THRESHOLD: constant(uint256) = 2_863_311_530 # 2/3 of 2^32, Validator powers will be normalized to sum to 2 ^ 32 in every valset update.
12 TURNSTONE_ID: immutable(bytes32)
13 
14 interface ERC20:
15     def balanceOf(_owner: address) -> uint256: view
16 
17 struct Valset:
18     validators: DynArray[address, MAX_VALIDATORS] # Validator addresses
19     powers: DynArray[uint256, MAX_VALIDATORS] # Powers of given validators, in the same order as validators array
20     valset_id: uint256 # nonce of this validator set
21 
22 struct Signature:
23     v: uint256
24     r: uint256
25     s: uint256
26 
27 struct Consensus:
28     valset: Valset # Valset data
29     signatures: DynArray[Signature, MAX_VALIDATORS] # signatures in the same order as validator array in valset
30 
31 struct LogicCallArgs:
32     logic_contract_address: address # the arbitrary contract address to external call
33     payload: Bytes[MAX_PAYLOAD] # payloads
34 
35 struct TokenSendArgs:
36     receiver: DynArray[address, MAX_BATCH]
37     amount: DynArray[uint256, MAX_BATCH]
38 
39 event ValsetUpdated:
40     checkpoint: bytes32
41     valset_id: uint256
42 
43 event LogicCallEvent:
44     logic_contract_address: address
45     payload: Bytes[MAX_PAYLOAD]
46     message_id: uint256
47 
48 event SendToPalomaEvent:
49     token: address
50     sender: address
51     receiver: String[64]
52     amount: uint256
53 
54 event BatchSendEvent:
55     token: address
56     message_id: uint256
57 
58 event ERC20DeployedEvent:
59     paloma_denom: String[64]
60     token_contract: address
61     name: String[64]
62     symbol: String[32]
63     decimals: uint8
64 
65 last_checkpoint: public(bytes32)
66 last_valset_id: public(uint256)
67 message_id_used: public(HashMap[uint256, bool])
68 
69 # turnstone_id: unique identifier for turnstone instance
70 # valset: initial validator set
71 @external
72 def __init__(turnstone_id: bytes32, valset: Valset):
73     TURNSTONE_ID = turnstone_id
74     cumulative_power: uint256 = 0
75     i: uint256 = 0
76     # check cumulative power is enough
77     for validator in valset.validators:
78         cumulative_power += valset.powers[i]
79         if cumulative_power >= POWER_THRESHOLD:
80             break
81         i += 1
82     assert cumulative_power >= POWER_THRESHOLD, "Insufficient Power"
83     new_checkpoint: bytes32 = keccak256(_abi_encode(valset.validators, valset.powers, valset.valset_id, turnstone_id, method_id=method_id("checkpoint(address[],uint256[],uint256,bytes32)")))
84     self.last_checkpoint = new_checkpoint
85     self.last_valset_id = valset.valset_id
86     log ValsetUpdated(new_checkpoint, valset.valset_id)
87 
88 @external
89 @pure
90 def turnstone_id() -> bytes32:
91     return TURNSTONE_ID
92 
93 # utility function to verify EIP712 signature
94 @internal
95 @pure
96 def verify_signature(signer: address, hash: bytes32, sig: Signature) -> bool:
97     message_digest: bytes32 = keccak256(concat(convert("\x19Ethereum Signed Message:\n32", Bytes[28]), hash))
98     return signer == ecrecover(message_digest, sig.v, sig.r, sig.s)
99 
100 # consensus: validator set and signatures
101 # hash: what we are checking they have signed
102 @internal
103 def check_validator_signatures(consensus: Consensus, hash: bytes32):
104     i: uint256 = 0
105     cumulative_power: uint256 = 0
106     for sig in consensus.signatures:
107         if sig.v != 0:
108             assert self.verify_signature(consensus.valset.validators[i], hash, sig), "Invalid Signature"
109             cumulative_power += consensus.valset.powers[i]
110             if cumulative_power >= POWER_THRESHOLD:
111                 break
112         i += 1
113     assert cumulative_power >= POWER_THRESHOLD, "Insufficient Power"
114 
115 # Make a new checkpoint from the supplied validator set
116 # A checkpoint is a hash of all relevant information about the valset. This is stored by the contract,
117 # instead of storing the information directly. This saves on storage and gas.
118 # The format of the checkpoint is:
119 # keccak256 hash of abi_encoded checkpoint(validators[], powers[], valset_id, turnstone_id)
120 # The validator powers must be decreasing or equal. This is important for checking the signatures on the
121 # next valset, since it allows the caller to stop verifying signatures once a quorum of signatures have been verified.
122 @internal
123 @view
124 def make_checkpoint(valset: Valset) -> bytes32:
125     return keccak256(_abi_encode(valset.validators, valset.powers, valset.valset_id, TURNSTONE_ID, method_id=method_id("checkpoint(address[],uint256[],uint256,bytes32)")))
126 
127 # This updates the valset by checking that the validators in the current valset have signed off on the
128 # new valset. The signatures supplied are the signatures of the current valset over the checkpoint hash
129 # generated from the new valset.
130 # Anyone can call this function, but they must supply valid signatures of constant_powerThreshold of the current valset over
131 # the new valset.
132 # valset: new validator set to update with
133 # consensus: current validator set and signatures
134 @external
135 def update_valset(consensus: Consensus, new_valset: Valset):
136     # check if new valset_id is greater than current valset_id
137     assert new_valset.valset_id > consensus.valset.valset_id, "Invalid Valset ID"
138     cumulative_power: uint256 = 0
139     i: uint256 = 0
140     # check cumulative power is enough
141     for validator in new_valset.validators:
142         cumulative_power += new_valset.powers[i]
143         if cumulative_power >= POWER_THRESHOLD:
144             break
145         i += 1
146     assert cumulative_power >= POWER_THRESHOLD, "Insufficient Power"
147     # check if the supplied current validator set matches the saved checkpoint
148     assert self.last_checkpoint == self.make_checkpoint(consensus.valset), "Incorrect Checkpoint"
149     # calculate the new checkpoint
150     new_checkpoint: bytes32 = self.make_checkpoint(new_valset)
151     # check if enough validators signed new validator set (new checkpoint)
152     self.check_validator_signatures(consensus, new_checkpoint)
153     self.last_checkpoint = new_checkpoint
154     self.last_valset_id = new_valset.valset_id
155     log ValsetUpdated(new_checkpoint, new_valset.valset_id)
156 
157 # This makes calls to contracts that execute arbitrary logic
158 # message_id is to prevent replay attack and every message_id can be used only once
159 @external
160 def submit_logic_call(consensus: Consensus, args: LogicCallArgs, message_id: uint256, deadline: uint256):
161     assert block.timestamp <= deadline, "Timeout"
162     assert not self.message_id_used[message_id], "Used Message_ID"
163     self.message_id_used[message_id] = True
164     # check if the supplied current validator set matches the saved checkpoint
165     assert self.last_checkpoint == self.make_checkpoint(consensus.valset), "Incorrect Checkpoint"
166     # signing data is keccak256 hash of abi_encoded logic_call(args, message_id, turnstone_id, deadline)
167     args_hash: bytes32 = keccak256(_abi_encode(args, message_id, TURNSTONE_ID, deadline, method_id=method_id("logic_call((address,bytes),uint256,bytes32,uint256)")))
168     # check if enough validators signed args_hash
169     self.check_validator_signatures(consensus, args_hash)
170     # make call to logic contract
171     raw_call(args.logic_contract_address, args.payload)
172     log LogicCallEvent(args.logic_contract_address, args.payload, message_id)
173 
174 @internal
175 def _safe_transfer_from(_token: address, _from: address, _to: address, _value: uint256):
176     _response: Bytes[32] = raw_call(
177         _token,
178         _abi_encode(
179             _from, _to, _value,
180             method_id=method_id("transferFrom(address,address,uint256)")),
181         max_outsize=32
182     )  # dev: failed transferFrom
183     if len(_response) > 0:
184         assert convert(_response, bool), "TransferFrom failed"
185 
186 @external
187 def send_token_to_paloma(token: address, receiver: String[64], amount: uint256):
188     _balance: uint256 = ERC20(token).balanceOf(self)
189     self._safe_transfer_from(token, msg.sender, self, amount)
190     _balance -= ERC20(token).balanceOf(self)
191     assert _balance > 0
192     log SendToPalomaEvent(token, msg.sender, receiver, amount)
193 
194 @internal
195 def _safe_transfer(_token: address, _to: address, _value: uint256):
196     _response: Bytes[32] = raw_call(
197         _token,
198         _abi_encode(
199             _to, _value,
200             method_id=method_id("transfer(address,uint256)")),
201         max_outsize=32
202     )  # dev: failed transferFrom
203     if len(_response) > 0:
204         assert convert(_response, bool), "TransferFrom failed"
205 
206 @external
207 def submit_batch(consensus: Consensus, token: address, args: TokenSendArgs, message_id: uint256, deadline: uint256):
208     assert block.timestamp <= deadline, "Timeout"
209     assert not self.message_id_used[message_id], "Used Message_ID"
210     length: uint256 = len(args.receiver)
211     assert length == len(args.amount)
212     self.message_id_used[message_id] = True
213     # check if the supplied current validator set matches the saved checkpoint
214     assert self.last_checkpoint == self.make_checkpoint(consensus.valset), "Incorrect Checkpoint"
215     # signing data is keccak256 hash of abi_encoded logic_call(args, message_id, turnstone_id, deadline)
216     args_hash: bytes32 = keccak256(_abi_encode(token, args, message_id, TURNSTONE_ID, deadline, method_id=method_id("batch_call(address,(address[],uint256[]),uint256,bytes32,uint256)")))
217     # check if enough validators signed args_hash
218     self.check_validator_signatures(consensus, args_hash)
219     # make call to logic contract
220     for i in range(MAX_BATCH):
221         if  i >= length:
222             break
223         self._safe_transfer(token, args.receiver[i], args.amount[i])
224     log BatchSendEvent(token, message_id)
225 
226 @external
227 def deploy_erc20(_paloma_denom: String[64], _name: String[64], _symbol: String[32], _decimals: uint8, _blueprint: address):
228     assert msg.sender == self, "Invalid"
229     erc20: address = create_from_blueprint(_blueprint, self, _name, _symbol, _decimals, code_offset=3)
230     log ERC20DeployedEvent(_paloma_denom, erc20, _name, _symbol, _decimals)