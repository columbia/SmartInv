1 # @version 0.2.12
2 # @author banteg
3 # @license MIT
4 from vyper.interfaces import ERC20
5 
6 implements: ERC20
7 
8 
9 event Transfer:
10     sender: indexed(address)
11     receiver: indexed(address)
12     value: uint256
13 
14 
15 event Approval:
16     owner: indexed(address)
17     spender: indexed(address)
18     value: uint256
19 
20 
21 event AdminChanged:
22     new_admin: address
23 
24 
25 event MinterChanged:
26     new_minter: address
27 
28 
29 name: public(String[26])
30 symbol: public(String[7])
31 decimals: public(uint256)
32 version: public(String[1])
33 
34 balanceOf: public(HashMap[address, uint256])
35 allowance: public(HashMap[address, HashMap[address, uint256]])
36 totalSupply: public(uint256)
37 
38 nonces: public(HashMap[address, uint256])
39 DOMAIN_SEPARATOR: public(bytes32)
40 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
41 PERMIT_TYPE_HASH: constant(bytes32) = keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)')
42 
43 admin: public(address)
44 minter: public(address)
45 
46 
47 @external
48 def __init__(_symbol: String[7], _minter: address, _admin: address):
49     self.name = 'bETH'
50     self.symbol = _symbol
51     self.decimals = 18
52     self.version = '1'
53     self.DOMAIN_SEPARATOR = keccak256(
54         concat(
55             DOMAIN_TYPE_HASH,
56             keccak256(convert(self.name, Bytes[26])),
57             keccak256(convert(self.version, Bytes[1])),
58             convert(chain.id, bytes32),
59             convert(self, bytes32)
60         )
61     )
62     self.minter = _minter
63     self.admin = _admin
64     log AdminChanged(_admin)
65     log MinterChanged(_minter)
66 
67 
68 @external
69 def change_admin(new_admin: address):
70     assert msg.sender == self.admin
71     self.admin = new_admin
72     log AdminChanged(new_admin)
73 
74 
75 @external
76 def set_minter(new_minter: address):
77     assert msg.sender == self.admin
78     self.minter = new_minter
79     log MinterChanged(new_minter)
80 
81 
82 @external
83 def mint(owner: address, amount: uint256):
84     assert msg.sender == self.minter
85     self.totalSupply += amount
86     self.balanceOf[owner] += amount
87     log Transfer(ZERO_ADDRESS, owner, amount)
88 
89 
90 @external
91 def burn(owner: address, amount: uint256):
92     assert msg.sender == self.minter
93     self.totalSupply -= amount
94     self.balanceOf[owner] -= amount
95     log Transfer(owner, ZERO_ADDRESS, amount)
96 
97 
98 @internal
99 def _transfer(sender: address, receiver: address, amount: uint256):
100     assert receiver not in [self, ZERO_ADDRESS]
101     self.balanceOf[sender] -= amount
102     self.balanceOf[receiver] += amount
103     log Transfer(sender, receiver, amount)
104 
105 
106 @external
107 def transfer(receiver: address, amount: uint256) -> bool:
108     self._transfer(msg.sender, receiver, amount)
109     return True
110 
111 
112 @external
113 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
114     if msg.sender != sender and self.allowance[sender][msg.sender] != MAX_UINT256:
115         self.allowance[sender][msg.sender] -= amount
116         log Approval(sender, msg.sender, self.allowance[sender][msg.sender])
117     self._transfer(sender, receiver, amount)
118     return True
119 
120 
121 @external
122 def approve(spender: address, amount: uint256) -> bool:
123     self.allowance[msg.sender][spender] = amount
124     log Approval(msg.sender, spender, amount)
125     return True
126 
127 
128 @external
129 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
130     assert owner != ZERO_ADDRESS  # dev: invalid owner
131     assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired
132     nonce: uint256 = self.nonces[owner]
133     digest: bytes32 = keccak256(
134         concat(
135             b'\x19\x01',
136             self.DOMAIN_SEPARATOR,
137             keccak256(
138                 concat(
139                     PERMIT_TYPE_HASH,
140                     convert(owner, bytes32),
141                     convert(spender, bytes32),
142                     convert(amount, bytes32),
143                     convert(nonce, bytes32),
144                     convert(expiry, bytes32),
145                 )
146             )
147         )
148     )
149     # NOTE: the signature is packed as r, s, v
150     r: uint256 = convert(slice(signature, 0, 32), uint256)
151     s: uint256 = convert(slice(signature, 32, 32), uint256)
152     v: uint256 = convert(slice(signature, 64, 1), uint256)
153     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
154     self.allowance[owner][spender] = amount
155     self.nonces[owner] = nonce + 1
156     log Approval(owner, spender, amount)
157     return True