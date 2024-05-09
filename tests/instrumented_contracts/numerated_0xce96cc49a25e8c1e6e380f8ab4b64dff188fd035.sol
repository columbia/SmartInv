1 # @version ^0.3.9
2 # @title EthXYToken
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
18 name: public(immutable(String[10]))
19 symbol: public(immutable(String[3]))
20 decimals: public(constant(uint256)) = 18
21 totalSupply: public(uint256)
22 
23 balanceOf: public(HashMap[address, uint256])
24 allowance: public(HashMap[address, HashMap[address, uint256]])
25 
26 minter: public(address)
27 burner: public(address)
28 
29 @external
30 def __init__():
31     name = "EthXYToken"
32     symbol = "EXY"
33     self.minter = msg.sender
34     self.burner = msg.sender
35 
36 @external
37 def set_minter(minter: address):
38     assert msg.sender == self.minter
39     self.minter = minter
40 
41 @external
42 def set_burner(burner: address):
43     assert msg.sender == self.burner
44     self.burner = burner
45 
46 @external
47 def approve(spender: address, amount: uint256) -> bool:
48     self.allowance[msg.sender][spender] = amount
49     log Approval(msg.sender, spender, amount)
50     return True
51 
52 @external
53 def increaseAllowance(spender: address, addedValue: uint256) -> bool:
54     self.allowance[msg.sender][spender] += addedValue
55     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
56     return True
57 
58 @external
59 def decreaseAllowance(spender: address, subtractedValue: uint256) -> bool:
60     self.allowance[msg.sender][spender] -= subtractedValue
61     log Approval(msg.sender, spender, self.allowance[msg.sender][spender])
62     return True
63 
64 @external
65 def transfer(_to: address, _value: uint256) -> bool:
66     self.balanceOf[msg.sender] -= _value
67     self.balanceOf[_to] += _value
68     log Transfer(msg.sender, _to, _value)
69     return True
70 
71 @external
72 def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
73     self.allowance[_from][msg.sender] -= _value
74     self.balanceOf[_from] -= _value
75     self.balanceOf[_to] += _value
76     log Transfer(_from, _to, _value)
77     return True
78 
79 @external
80 def mint(_to: address, _value: uint256):
81     assert msg.sender == self.minter
82     self.balanceOf[_to] += _value
83     self.totalSupply += _value
84     log Transfer(ZERO_ADDRESS, _to, _value)
85 
86 @external
87 def burn(_value: uint256):
88     assert msg.sender == self.burner
89     self.balanceOf[msg.sender] -= _value
90     self.totalSupply -= _value
91     log Transfer(msg.sender, ZERO_ADDRESS, _value)
92 
93 ################################################################
94 #                           EIP-2612                           #
95 ################################################################
96 
97 nonces: public(HashMap[address, uint256])
98 
99 _DOMAIN_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
100 _PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
101 
102 
103 @external
104 def permit(owner: address, spender: address, amount: uint256, deadline: uint256, v: uint8, r: bytes32, s: bytes32):
105     assert deadline >= block.timestamp
106     nonce: uint256 = self.nonces[owner]
107     self.nonces[owner] = nonce + 1
108 
109     domain_separator: bytes32 = keccak256(
110         _abi_encode(_DOMAIN_TYPEHASH, name, "1.0", chain.id, self)
111     )
112 
113     struct_hash: bytes32 = keccak256(_abi_encode(_PERMIT_TYPE_HASH, owner, spender, amount, nonce, deadline))
114     hash: bytes32 = keccak256(
115         concat(
116             b"\x19\x01",
117             domain_separator,
118             struct_hash
119         )
120     )
121 
122     assert owner == ecrecover(hash, v, r, s)
123     self.nonces[owner] += 1
124     self.allowance[owner][spender] = amount
125     log Approval(owner, spender, amount)
126 
127 @internal
128 def _mint(_to: address, _value: uint256):
129     self.balanceOf[_to] += _value
130     self.totalSupply += _value
131     log Transfer(ZERO_ADDRESS, _to, _value)
132 
133 @internal
134 def _burn(_from: address, _value: uint256):
135     assert self.balanceOf[_from] >= _value
136     self.balanceOf[_from] -= _value
137     self.totalSupply -= _value
138     log Transfer(_from, ZERO_ADDRESS, _value)