1 # @version 0.2.7
2 from vyper.interfaces import ERC20
3 
4 implements: ERC20
5 
6 event Transfer:
7     sender: indexed(address)
8     receiver: indexed(address)
9     value: uint256
10 
11 event Approval:
12     owner: indexed(address)
13     spender: indexed(address)
14     value: uint256
15 
16 event Pickled:
17     receiver: indexed(address)
18     corn: uint256
19     dai: uint256
20 
21 struct Permit:
22     owner: address
23     spender: address
24     amount: uint256
25     nonce: uint256
26     expiry: uint256
27 
28 
29 name: public(String[64])
30 symbol: public(String[32])
31 decimals: public(uint256)
32 balanceOf: public(HashMap[address, uint256])
33 nonces: public(HashMap[address, uint256])
34 allowances: HashMap[address, HashMap[address, uint256]]
35 total_supply: uint256
36 dai: ERC20
37 DOMAIN_SEPARATOR: public(bytes32)
38 contract_version: constant(String[32]) = "1"
39 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
40 PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 amount,uint256 nonce,uint256 expiry)")
41 
42 
43 @external
44 def __init__(_name: String[64], _symbol: String[32], _supply: uint256):
45     self.name = _name
46     self.symbol = _symbol
47     self.decimals = 18
48     self.dai = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F)
49     self.balanceOf[msg.sender] = _supply
50     self.total_supply = _supply
51     log Transfer(ZERO_ADDRESS, msg.sender, _supply)
52 
53     self.DOMAIN_SEPARATOR = keccak256(
54         concat(
55             DOMAIN_TYPE_HASH,
56             keccak256(convert(self.name, Bytes[64])),
57             keccak256(convert(contract_version, Bytes[32])),
58             convert(chain.id, bytes32),
59             convert(self, bytes32)
60         )
61     )
62 
63 
64 @view
65 @external
66 def totalSupply() -> uint256:
67     return self.total_supply
68 
69 
70 @view
71 @external
72 def version() -> String[32]:
73     return contract_version
74 
75 
76 @view
77 @external
78 def allowance(owner: address, spender: address) -> uint256:
79     return self.allowances[owner][spender]
80 
81 
82 @internal
83 def _transfer(sender: address, source: address, receiver: address, amount: uint256) -> bool:
84     assert not receiver in [self, ZERO_ADDRESS]
85     self.balanceOf[source] -= amount
86     self.balanceOf[receiver] += amount
87     if source != sender and self.allowances[source][sender] != MAX_UINT256:
88         self.allowances[source][sender] -= amount
89         log Approval(source, sender, amount)
90     log Transfer(source, receiver, amount)
91     return True
92 
93 
94 @external
95 def transfer(receiver: address, amount: uint256) -> bool:
96     return self._transfer(msg.sender, msg.sender, receiver, amount)
97 
98 
99 @external
100 def transferFrom(source: address, receiver: address, amount: uint256) -> bool:
101     return self._transfer(msg.sender, source, receiver, amount)
102 
103 
104 @external
105 def approve(spender: address, amount: uint256) -> bool:
106     self.allowances[msg.sender][spender] = amount
107     log Approval(msg.sender, spender, amount)
108     return True
109 
110 
111 @view
112 @internal
113 def _rate(amount: uint256) -> uint256:
114     if self.total_supply == 0:
115         return 0
116     return amount * self.dai.balanceOf(self) / self.total_supply
117 
118 
119 @view
120 @external
121 def rate() -> uint256:
122     return self._rate(10 ** self.decimals)
123 
124 
125 @internal
126 def _burn(sender: address, source: address, amount: uint256):
127     assert source != ZERO_ADDRESS
128     redeemed: uint256 = self._rate(amount)
129     self.dai.transfer(source, redeemed)
130     log Pickled(source, amount, redeemed)
131     self.total_supply -= amount
132     self.balanceOf[source] -= amount
133     if source != sender and self.allowances[source][sender] != MAX_UINT256:
134         self.allowances[source][sender] -= amount
135         log Approval(source, sender, amount)
136     log Transfer(source, ZERO_ADDRESS, amount)
137 
138 
139 @external
140 def burn(_amount: uint256 = MAX_UINT256):
141     """
142     Burn CORN for DAI at a rate of (DAI in contract / CORN supply)
143     """
144     amount: uint256 = min(_amount, self.balanceOf[msg.sender])
145     self._burn(msg.sender, msg.sender, amount)
146 
147 
148 @external
149 def burnFrom(source: address, amount: uint256):
150     self._burn(msg.sender, source, amount)
151 
152 
153 @view
154 @internal
155 def message_digest(owner: address, spender: address, amount: uint256, nonce: uint256, expiry: uint256) -> bytes32:
156     return keccak256(
157         concat(
158             b'\x19\x01',
159             self.DOMAIN_SEPARATOR,
160             keccak256(
161                 concat(
162                     PERMIT_TYPE_HASH,
163                     convert(owner, bytes32),
164                     convert(spender, bytes32),
165                     convert(amount, bytes32),
166                     convert(nonce, bytes32),
167                     convert(expiry, bytes32),
168                 )
169             )
170         )
171     )
172 
173 
174 @external
175 def permit(owner: address, spender: address, amount: uint256, nonce: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
176     assert expiry >= block.timestamp  # dev: permit expired
177     assert owner != ZERO_ADDRESS  # dev: invalid owner
178     assert nonce == self.nonces[owner]  # dev: invalid nonce
179     digest: bytes32 = self.message_digest(owner, spender, amount, nonce, expiry)
180     # NOTE: signature is packed as r, s, v
181     r: uint256 = convert(slice(signature, 0, 32), uint256)
182     s: uint256 = convert(slice(signature, 32, 32), uint256)
183     v: uint256 = convert(slice(signature, 64, 1), uint256)
184     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
185 
186     self.allowances[owner][spender] = amount
187     self.nonces[owner] += 1
188     log Approval(owner, spender, amount)
189     return True