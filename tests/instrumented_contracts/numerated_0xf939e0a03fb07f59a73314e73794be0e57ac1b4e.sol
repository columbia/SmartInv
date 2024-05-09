1 # @version 0.3.7
2 """
3 @title crvUSD Stablecoin
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020-2023 - all rights reserved
6 """
7 from vyper.interfaces import ERC20
8 
9 implements: ERC20
10 
11 
12 interface ERC1271:
13     def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes4: view
14 
15 
16 event Approval:
17     owner: indexed(address)
18     spender: indexed(address)
19     value: uint256
20 
21 event Transfer:
22     sender: indexed(address)
23     receiver: indexed(address)
24     value: uint256
25 
26 event SetMinter:
27     minter: indexed(address)
28 
29 
30 decimals: public(constant(uint8)) = 18
31 version: public(constant(String[8])) = "v1.0.0"
32 
33 ERC1271_MAGIC_VAL: constant(bytes4) = 0x1626ba7e
34 EIP712_TYPEHASH: constant(bytes32) = keccak256(
35     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)"
36 )
37 EIP2612_TYPEHASH: constant(bytes32) = keccak256(
38     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
39 )
40 VERSION_HASH: constant(bytes32) = keccak256(version)
41 
42 
43 name: public(immutable(String[64]))
44 symbol: public(immutable(String[32]))
45 salt: public(immutable(bytes32))
46 
47 NAME_HASH: immutable(bytes32)
48 CACHED_CHAIN_ID: immutable(uint256)
49 CACHED_DOMAIN_SEPARATOR: immutable(bytes32)
50 
51 
52 allowance: public(HashMap[address, HashMap[address, uint256]])
53 balanceOf: public(HashMap[address, uint256])
54 totalSupply: public(uint256)
55 
56 nonces: public(HashMap[address, uint256])
57 minter: public(address)
58 
59 
60 @external
61 def __init__(_name: String[64], _symbol: String[32]):
62     name = _name
63     symbol = _symbol
64 
65     NAME_HASH = keccak256(_name)
66     CACHED_CHAIN_ID = chain.id
67     salt = block.prevhash
68     CACHED_DOMAIN_SEPARATOR = keccak256(
69         _abi_encode(
70             EIP712_TYPEHASH,
71             keccak256(_name),
72             VERSION_HASH,
73             chain.id,
74             self,
75             block.prevhash,
76         )
77     )
78 
79     self.minter = msg.sender
80     log SetMinter(msg.sender)
81 
82 
83 @internal
84 def _approve(_owner: address, _spender: address, _value: uint256):
85     self.allowance[_owner][_spender] = _value
86 
87     log Approval(_owner, _spender, _value)
88 
89 
90 @internal
91 def _burn(_from: address, _value: uint256):
92     self.balanceOf[_from] -= _value
93     self.totalSupply -= _value
94 
95     log Transfer(_from, empty(address), _value)
96 
97 
98 @internal
99 def _transfer(_from: address, _to: address, _value: uint256):
100     assert _to not in [self, empty(address)]
101 
102     self.balanceOf[_from] -= _value
103     self.balanceOf[_to] += _value
104 
105     log Transfer(_from, _to, _value)
106 
107 
108 @view
109 @internal
110 def _domain_separator() -> bytes32:
111     if chain.id != CACHED_CHAIN_ID:
112         return keccak256(
113             _abi_encode(
114                 EIP712_TYPEHASH,
115                 NAME_HASH,
116                 VERSION_HASH,
117                 chain.id,
118                 self,
119                 salt,
120             )
121         )
122     return CACHED_DOMAIN_SEPARATOR
123 
124 
125 @external
126 def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
127     """
128     @notice Transfer tokens from one account to another.
129     @dev The caller needs to have an allowance from account `_from` greater than or
130         equal to the value being transferred. An allowance equal to the uint256 type's
131         maximum, is considered infinite and does not decrease.
132     @param _from The account which tokens will be spent from.
133     @param _to The account which tokens will be sent to.
134     @param _value The amount of tokens to be transferred.
135     """
136     allowance: uint256 = self.allowance[_from][msg.sender]
137     if allowance != max_value(uint256):
138         self._approve(_from, msg.sender, allowance - _value)
139 
140     self._transfer(_from, _to, _value)
141     return True
142 
143 
144 @external
145 def transfer(_to: address, _value: uint256) -> bool:
146     """
147     @notice Transfer tokens to `_to`.
148     @param _to The account to transfer tokens to.
149     @param _value The amount of tokens to transfer.
150     """
151     self._transfer(msg.sender, _to, _value)
152     return True
153 
154 
155 @external
156 def approve(_spender: address, _value: uint256) -> bool:
157     """
158     @notice Allow `_spender` to transfer up to `_value` amount of tokens from the caller's account.
159     @dev Non-zero to non-zero approvals are allowed, but should be used cautiously. The methods
160         increaseAllowance + decreaseAllowance are available to prevent any front-running that
161         may occur.
162     @param _spender The account permitted to spend up to `_value` amount of caller's funds.
163     @param _value The amount of tokens `_spender` is allowed to spend.
164     """
165     self._approve(msg.sender, _spender, _value)
166     return True
167 
168 
169 @external
170 def permit(
171     _owner: address,
172     _spender: address,
173     _value: uint256,
174     _deadline: uint256,
175     _v: uint8,
176     _r: bytes32,
177     _s: bytes32,
178 ) -> bool:
179     """
180     @notice Permit `_spender` to spend up to `_value` amount of `_owner`'s tokens via a signature.
181     @dev In the event of a chain fork, replay attacks are prevented as domain separator is recalculated.
182         However, this is only if the resulting chains update their chainId.
183     @param _owner The account which generated the signature and is granting an allowance.
184     @param _spender The account which will be granted an allowance.
185     @param _value The approval amount.
186     @param _deadline The deadline by which the signature must be submitted.
187     @param _v The last byte of the ECDSA signature.
188     @param _r The first 32 bytes of the ECDSA signature.
189     @param _s The second 32 bytes of the ECDSA signature.
190     """
191     assert _owner != empty(address) and block.timestamp <= _deadline
192 
193     nonce: uint256 = self.nonces[_owner]
194     digest: bytes32 = keccak256(
195         concat(
196             b"\x19\x01",
197             self._domain_separator(),
198             keccak256(_abi_encode(EIP2612_TYPEHASH, _owner, _spender, _value, nonce, _deadline)),
199         )
200     )
201 
202     if _owner.is_contract:
203         sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
204         assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
205     else:
206         assert ecrecover(digest, _v, _r, _s) == _owner
207 
208     self.nonces[_owner] = nonce + 1
209     self._approve(_owner, _spender, _value)
210     return True
211 
212 
213 @external
214 def increaseAllowance(_spender: address, _add_value: uint256) -> bool:
215     """
216     @notice Increase the allowance granted to `_spender`.
217     @dev This function will never overflow, and instead will bound
218         allowance to MAX_UINT256. This has the potential to grant an
219         infinite approval.
220     @param _spender The account to increase the allowance of.
221     @param _add_value The amount to increase the allowance by.
222     """
223     cached_allowance: uint256 = self.allowance[msg.sender][_spender]
224     allowance: uint256 = unsafe_add(cached_allowance, _add_value)
225 
226     # check for an overflow
227     if allowance < cached_allowance:
228         allowance = max_value(uint256)
229 
230     if allowance != cached_allowance:
231         self._approve(msg.sender, _spender, allowance)
232 
233     return True
234 
235 
236 @external
237 def decreaseAllowance(_spender: address, _sub_value: uint256) -> bool:
238     """
239     @notice Decrease the allowance granted to `_spender`.
240     @dev This function will never underflow, and instead will bound
241         allowance to 0.
242     @param _spender The account to decrease the allowance of.
243     @param _sub_value The amount to decrease the allowance by.
244     """
245     cached_allowance: uint256 = self.allowance[msg.sender][_spender]
246     allowance: uint256 = unsafe_sub(cached_allowance, _sub_value)
247 
248     # check for an underflow
249     if cached_allowance < allowance:
250         allowance = 0
251 
252     if allowance != cached_allowance:
253         self._approve(msg.sender, _spender, allowance)
254 
255     return True
256 
257 
258 @external
259 def burnFrom(_from: address, _value: uint256) -> bool:
260     """
261     @notice Burn `_value` amount of tokens from `_from`.
262     @dev The caller must have previously been given an allowance by `_from`.
263     @param _from The account to burn the tokens from.
264     @param _value The amount of tokens to burn.
265     """
266     allowance: uint256 = self.allowance[_from][msg.sender]
267     if allowance != max_value(uint256):
268         self._approve(_from, msg.sender, allowance - _value)
269 
270     self._burn(_from, _value)
271     return True
272 
273 
274 @external
275 def burn(_value: uint256) -> bool:
276     """
277     @notice Burn `_value` amount of tokens.
278     @param _value The amount of tokens to burn.
279     """
280     self._burn(msg.sender, _value)
281     return True
282 
283 
284 @external
285 def mint(_to: address, _value: uint256) -> bool:
286     """
287     @notice Mint `_value` amount of tokens to `_to`.
288     @dev Only callable by an account with minter privileges.
289     @param _to The account newly minted tokens are credited to.
290     @param _value The amount of tokens to mint.
291     """
292     assert msg.sender == self.minter
293     assert _to not in [self, empty(address)]
294 
295     self.balanceOf[_to] += _value
296     self.totalSupply += _value
297 
298     log Transfer(empty(address), _to, _value)
299     return True
300 
301 
302 @external
303 def set_minter(_minter: address):
304     assert msg.sender == self.minter
305 
306     self.minter = _minter
307     log SetMinter(_minter)
308 
309 
310 @view
311 @external
312 def DOMAIN_SEPARATOR() -> bytes32:
313     """
314     @notice EIP712 domain separator.
315     """
316     return self._domain_separator()