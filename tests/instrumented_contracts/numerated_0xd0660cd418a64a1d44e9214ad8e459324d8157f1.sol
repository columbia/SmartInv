1 # @version 0.2.12
2 from vyper.interfaces import ERC20
3 
4 implements: ERC20
5 
6 event Transfer:
7     sender: indexed(address)
8     receiver: indexed(address)
9     value: uint256
10 
11 
12 event Approval:
13     owner: indexed(address)
14     spender: indexed(address)
15     value: uint256
16 
17 
18 allowance: public(HashMap[address, HashMap[address, uint256]])
19 balanceOf: public(HashMap[address, uint256])
20 totalSupply: public(uint256)
21 nonces: public(HashMap[address, uint256])
22 DOMAIN_SEPARATOR: public(bytes32)
23 DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
24 PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
25 
26 YFI: constant(address) = 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e
27 
28 
29 @external
30 def __init__():
31     self.DOMAIN_SEPARATOR = keccak256(
32         concat(
33             DOMAIN_TYPE_HASH,
34             keccak256(convert("Woofy", Bytes[5])),
35             keccak256(convert("1", Bytes[1])),
36             convert(chain.id, bytes32),
37             convert(self, bytes32)
38         )
39     )
40 
41 
42 @view
43 @external
44 def name() -> String[5]:
45     return "Woofy"
46 
47 
48 @view
49 @external
50 def symbol() -> String[5]:
51     return "WOOFY"
52 
53 
54 @view
55 @external
56 def decimals() -> uint256:
57     return 12
58 
59 
60 @internal
61 def _mint(receiver: address, amount: uint256):
62     assert not receiver in [self, ZERO_ADDRESS]
63 
64     self.balanceOf[receiver] += amount
65     self.totalSupply += amount
66 
67     log Transfer(ZERO_ADDRESS, receiver, amount)
68 
69 
70 @internal
71 def _burn(sender: address, amount: uint256):
72     self.balanceOf[sender] -= amount
73     self.totalSupply -= amount
74 
75     log Transfer(sender, ZERO_ADDRESS, amount)
76 
77 
78 @internal
79 def _transfer(sender: address, receiver: address, amount: uint256):
80     assert not receiver in [self, ZERO_ADDRESS]
81 
82     self.balanceOf[sender] -= amount
83     self.balanceOf[receiver] += amount
84 
85     log Transfer(sender, receiver, amount)
86 
87 
88 @external
89 def transfer(receiver: address, amount: uint256) -> bool:
90     self._transfer(msg.sender, receiver, amount)
91     return True
92 
93 
94 @external
95 def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:
96     self.allowance[sender][msg.sender] -= amount
97     self._transfer(sender, receiver, amount)
98     return True
99 
100 
101 @external
102 def approve(spender: address, amount: uint256) -> bool:
103     self.allowance[msg.sender][spender] = amount
104     log Approval(msg.sender, spender, amount)
105     return True
106 
107 
108 @external
109 def woof(amount: uint256 = MAX_UINT256, receiver: address = msg.sender) -> bool:
110     mint_amount: uint256 = min(amount, ERC20(YFI).balanceOf(msg.sender))
111     assert ERC20(YFI).transferFrom(msg.sender, self, mint_amount)
112     self._mint(receiver, mint_amount)
113     return True
114 
115 
116 @external
117 def unwoof(amount: uint256 = MAX_UINT256, receiver: address = msg.sender) -> bool:
118     burn_amount: uint256 = min(amount, self.balanceOf[msg.sender])
119     self._burn(msg.sender, burn_amount)
120     assert ERC20(YFI).transfer(receiver, burn_amount)
121     return True
122 
123 
124 @external
125 def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:
126     assert owner != ZERO_ADDRESS  # dev: invalid owner
127     assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired
128     nonce: uint256 = self.nonces[owner]
129     digest: bytes32 = keccak256(
130         concat(
131             b'\x19\x01',
132             self.DOMAIN_SEPARATOR,
133             keccak256(
134                 concat(
135                     PERMIT_TYPE_HASH,
136                     convert(owner, bytes32),
137                     convert(spender, bytes32),
138                     convert(amount, bytes32),
139                     convert(nonce, bytes32),
140                     convert(expiry, bytes32),
141                 )
142             )
143         )
144     )
145     # NOTE: signature is packed as r, s, v
146     r: uint256 = convert(slice(signature, 0, 32), uint256)
147     s: uint256 = convert(slice(signature, 32, 32), uint256)
148     v: uint256 = convert(slice(signature, 64, 1), uint256)
149     assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature
150     self.allowance[owner][spender] = amount
151     self.nonces[owner] = nonce + 1
152     log Approval(owner, spender, amount)
153     return True