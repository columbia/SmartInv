1 # @version ^0.3.9
2 # @title Settled EthXYToken
3 
4 from vyper.interfaces import ERC20
5 
6 implements: ERC20
7 
8 event Transfer:
9     _from: indexed(address)
10     _to: indexed(address)
11     _value: uint256
12 
13 event Approval:
14     _owner: indexed(address)
15     _spender: indexed(address)
16     _value: uint256
17 
18 _name: constant(String[24]) = "Settled ETHXY Token"
19 _symbol: constant(String[5]) = "SEXY"
20 decimals: public(constant(uint256)) = 18
21 totalSupply: public(uint256)
22 
23 balanceOf: public(HashMap[address, uint256])
24 allowance: public(HashMap[address, HashMap[address, uint256]])
25 
26 minter: public(address)
27 
28 @view
29 @external
30 def name() -> String[24]:
31     return _name
32 
33 @view
34 @external
35 def symbol() -> String[5]:
36     return _symbol
37 
38 @external
39 def __init__():
40     self.minter = msg.sender
41 
42 @external
43 def set_minter(minter: address):
44     assert msg.sender == self.minter
45     self.minter = minter
46 
47 @external
48 def approve(spender: address, amount: uint256) -> bool:
49     self.allowance[msg.sender][spender] = amount
50     log Approval(msg.sender, spender, amount)
51     return True
52 
53 @external
54 def increaseAllowance(spender: address, addedValue: uint256) -> bool:
55     self.allowance[msg.sender][spender] += addedValue
56     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
57     return True
58 
59 @external
60 def decreaseAllowance(spender: address, subtractedValue: uint256) -> bool:
61     self.allowance[msg.sender][spender] -= subtractedValue
62     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
63     return True
64 
65 @external
66 def transfer(_to: address, _value: uint256) -> bool:
67     self.balanceOf[msg.sender] -= _value
68     self.balanceOf[_to] += _value
69     log Transfer(msg.sender, _to, _value)
70     return True
71 
72 @external
73 def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
74     self.allowance[_from][msg.sender] -= _value
75     self.balanceOf[_from] -= _value
76     self.balanceOf[_to] += _value
77     log Transfer(_from, _to, _value)
78     return True
79 
80 @external
81 def mint(_to: address, _value: uint256):
82     assert msg.sender == self.minter
83     self.balanceOf[_to] += _value
84     self.totalSupply += _value
85     log Transfer(ZERO_ADDRESS, _to, _value)
86 
87 @external
88 def burn(_value: uint256) -> uint256:
89     self.balanceOf[msg.sender] -= _value
90     self.totalSupply -= _value
91     log Transfer(msg.sender, ZERO_ADDRESS, _value)
92     return _value
93 
94 ################################################################
95 #                           EIP-2612                           #
96 ################################################################
97 
98 nonces: public(HashMap[address, uint256])
99 
100 _DOMAIN_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
101 _PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
102 _MINT_TYPE_HASH: constant(bytes32) = keccak256("Mint(address to,uint256 value,uint256 amountMinted)")
103 
104 
105 @external
106 def permit(owner: address, spender: address, amount: uint256, deadline: uint256, v: uint8, r: bytes32, s: bytes32):
107     assert deadline >= block.timestamp
108     nonce: uint256 = self.nonces[owner]
109     self.nonces[owner] = nonce + 1
110 
111     domain_separator: bytes32 = keccak256(
112         _abi_encode(_DOMAIN_TYPEHASH, keccak256(_name), keccak256("1.0"), chain.id, self)
113     )
114 
115     struct_hash: bytes32 = keccak256(_abi_encode(_PERMIT_TYPE_HASH, owner, spender, amount, nonce, deadline))
116     hash: bytes32 = keccak256(
117         concat(
118             b"\x19\x01",
119             domain_separator,
120             struct_hash
121         )
122     )
123 
124     assert owner == ecrecover(hash, v, r, s)
125     self.nonces[owner] += 1
126     self.allowance[owner][spender] = amount
127     log Approval(owner, spender, amount)
128 
129 amount_minted: public(HashMap[address, uint256])
130 
131 @external
132 def mint_by_sig(to: address, amount: uint256, v: uint8, r: bytes32, s: bytes32):
133     domain_separator: bytes32 = keccak256(
134         _abi_encode(_DOMAIN_TYPEHASH, keccak256(_name), keccak256("1.0"), chain.id, self)
135     )
136 
137     struct_hash: bytes32 = keccak256(_abi_encode(_MINT_TYPE_HASH, to, amount, self.amount_minted[to]))
138     hash: bytes32 = keccak256(
139         concat(
140             b"\x19\x01",
141             domain_separator,
142             struct_hash
143         )
144     )
145 
146     assert self.minter == ecrecover(hash, v, r, s)
147 
148     self.amount_minted[to] += amount
149     self._mint(to, amount)
150 
151 @internal
152 def _mint(_to: address, _value: uint256):
153     self.balanceOf[_to] += _value
154     self.totalSupply += _value
155     log Transfer(ZERO_ADDRESS, _to, _value)
156 
157 @internal
158 def _burn(_from: address, _value: uint256):
159     assert self.balanceOf[_from] >= _value
160     self.balanceOf[_from] -= _value
161     self.totalSupply -= _value
162     log Transfer(_from, ZERO_ADDRESS, _value)