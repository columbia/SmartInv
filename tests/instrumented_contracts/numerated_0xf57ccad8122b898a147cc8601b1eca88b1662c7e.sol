1 # @version 0.3.1
2 """
3 @title Curve LP Token V5
4 @author Curve.Fi
5 @notice Base implementation for an LP token provided for supplying liquidity
6 @dev Follows the ERC-20 token standard as defined at https://eips.ethereum.org/EIPS/eip-20
7 """
8 from vyper.interfaces import ERC20
9 
10 implements: ERC20
11 
12 
13 interface ERC1271:
14     def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view
15 
16 
17 event Approval:
18     _owner: indexed(address)
19     _spender: indexed(address)
20     _value: uint256
21 
22 event Transfer:
23     _from: indexed(address)
24     _to: indexed(address)
25     _value: uint256
26 
27 
28 EIP712_TYPEHASH: constant(bytes32) = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
29 PERMIT_TYPEHASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
30 
31 # keccak256("isValidSignature(bytes32,bytes)")[:4] << 224
32 ERC1271_MAGIC_VAL: constant(bytes32) = 0x1626ba7e00000000000000000000000000000000000000000000000000000000
33 VERSION: constant(String[8]) = "v5.0.0"
34 
35 
36 name: public(String[64])
37 symbol: public(String[32])
38 DOMAIN_SEPARATOR: public(bytes32)
39 
40 balanceOf: public(HashMap[address, uint256])
41 allowance: public(HashMap[address, HashMap[address, uint256]])
42 totalSupply: public(uint256)
43 
44 minter: public(address)
45 nonces: public(HashMap[address, uint256])
46 
47 
48 @external
49 def __init__():
50     self.minter = 0x0000000000000000000000000000000000000001
51 
52 
53 @external
54 def transfer(_to: address, _value: uint256) -> bool:
55     """
56     @dev Transfer token for a specified address
57     @param _to The address to transfer to.
58     @param _value The amount to be transferred.
59     """
60     # NOTE: vyper does not allow underflows
61     #       so the following subtraction would revert on insufficient balance
62     self.balanceOf[msg.sender] -= _value
63     self.balanceOf[_to] += _value
64 
65     log Transfer(msg.sender, _to, _value)
66     return True
67 
68 
69 @external
70 def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
71     """
72      @dev Transfer tokens from one address to another.
73      @param _from address The address which you want to send tokens from
74      @param _to address The address which you want to transfer to
75      @param _value uint256 the amount of tokens to be transferred
76     """
77     self.balanceOf[_from] -= _value
78     self.balanceOf[_to] += _value
79 
80     _allowance: uint256 = self.allowance[_from][msg.sender]
81     if _allowance != MAX_UINT256:
82         self.allowance[_from][msg.sender] = _allowance - _value
83 
84     log Transfer(_from, _to, _value)
85     return True
86 
87 
88 @external
89 def approve(_spender: address, _value: uint256) -> bool:
90     """
91     @notice Approve the passed address to transfer the specified amount of
92             tokens on behalf of msg.sender
93     @dev Beware that changing an allowance via this method brings the risk
94          that someone may use both the old and new allowance by unfortunate
95          transaction ordering. This may be mitigated with the use of
96          {increaseAllowance} and {decreaseAllowance}.
97          https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98     @param _spender The address which will transfer the funds
99     @param _value The amount of tokens that may be transferred
100     @return bool success
101     """
102     self.allowance[msg.sender][_spender] = _value
103 
104     log Approval(msg.sender, _spender, _value)
105     return True
106 
107 
108 @external
109 def permit(
110     _owner: address,
111     _spender: address,
112     _value: uint256,
113     _deadline: uint256,
114     _v: uint8,
115     _r: bytes32,
116     _s: bytes32
117 ) -> bool:
118     """
119     @notice Approves spender by owner's signature to expend owner's tokens.
120         See https://eips.ethereum.org/EIPS/eip-2612.
121     @dev Inspired by https://github.com/yearn/yearn-vaults/blob/main/contracts/Vault.vy#L753-L793
122     @dev Supports smart contract wallets which implement ERC1271
123         https://eips.ethereum.org/EIPS/eip-1271
124     @param _owner The address which is a source of funds and has signed the Permit.
125     @param _spender The address which is allowed to spend the funds.
126     @param _value The amount of tokens to be spent.
127     @param _deadline The timestamp after which the Permit is no longer valid.
128     @param _v The bytes[64] of the valid secp256k1 signature of permit by owner
129     @param _r The bytes[0:32] of the valid secp256k1 signature of permit by owner
130     @param _s The bytes[32:64] of the valid secp256k1 signature of permit by owner
131     @return True, if transaction completes successfully
132     """
133     assert _owner != ZERO_ADDRESS
134     assert block.timestamp <= _deadline
135 
136     nonce: uint256 = self.nonces[_owner]
137     digest: bytes32 = keccak256(
138         concat(
139             b"\x19\x01",
140             self.DOMAIN_SEPARATOR,
141             keccak256(_abi_encode(PERMIT_TYPEHASH, _owner, _spender, _value, nonce, _deadline))
142         )
143     )
144 
145     if _owner.is_contract:
146         sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))
147         # reentrancy not a concern since this is a staticcall
148         assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
149     else:
150         assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
151 
152     self.allowance[_owner][_spender] = _value
153     self.nonces[_owner] = nonce + 1
154 
155     log Approval(_owner, _spender, _value)
156     return True
157 
158 
159 @external
160 def increaseAllowance(_spender: address, _added_value: uint256) -> bool:
161     """
162     @notice Increase the allowance granted to `_spender` by the caller
163     @dev This is alternative to {approve} that can be used as a mitigation for
164          the potential race condition
165     @param _spender The address which will transfer the funds
166     @param _added_value The amount of to increase the allowance
167     @return bool success
168     """
169     allowance: uint256 = self.allowance[msg.sender][_spender] + _added_value
170     self.allowance[msg.sender][_spender] = allowance
171 
172     log Approval(msg.sender, _spender, allowance)
173     return True
174 
175 
176 @external
177 def decreaseAllowance(_spender: address, _subtracted_value: uint256) -> bool:
178     """
179     @notice Decrease the allowance granted to `_spender` by the caller
180     @dev This is alternative to {approve} that can be used as a mitigation for
181          the potential race condition
182     @param _spender The address which will transfer the funds
183     @param _subtracted_value The amount of to decrease the allowance
184     @return bool success
185     """
186     allowance: uint256 = self.allowance[msg.sender][_spender] - _subtracted_value
187     self.allowance[msg.sender][_spender] = allowance
188 
189     log Approval(msg.sender, _spender, allowance)
190     return True
191 
192 
193 @external
194 def mint(_to: address, _value: uint256) -> bool:
195     """
196     @dev Mint an amount of the token and assigns it to an account.
197          This encapsulates the modification of balances such that the
198          proper events are emitted.
199     @param _to The account that will receive the created tokens.
200     @param _value The amount that will be created.
201     """
202     assert msg.sender == self.minter
203 
204     self.totalSupply += _value
205     self.balanceOf[_to] += _value
206 
207     log Transfer(ZERO_ADDRESS, _to, _value)
208     return True
209 
210 
211 @external
212 def mint_relative(_to: address, frac: uint256) -> uint256:
213     """
214     @dev Increases supply by factor of (1 + frac/1e18) and mints it for _to
215     """
216     assert msg.sender == self.minter
217 
218     supply: uint256 = self.totalSupply
219     d_supply: uint256 = supply * frac / 10**18
220     if d_supply > 0:
221         self.totalSupply = supply + d_supply
222         self.balanceOf[_to] += d_supply
223         log Transfer(ZERO_ADDRESS, _to, d_supply)
224 
225     return d_supply
226 
227 
228 @external
229 def burnFrom(_to: address, _value: uint256) -> bool:
230     """
231     @dev Burn an amount of the token from a given account.
232     @param _to The account whose tokens will be burned.
233     @param _value The amount that will be burned.
234     """
235     assert msg.sender == self.minter
236 
237     self.totalSupply -= _value
238     self.balanceOf[_to] -= _value
239 
240     log Transfer(_to, ZERO_ADDRESS, _value)
241     return True
242 
243 
244 @view
245 @external
246 def decimals() -> uint8:
247     """
248     @notice Get the number of decimals for this token
249     @dev Implemented as a view method to reduce gas costs
250     @return uint8 decimal places
251     """
252     return 18
253 
254 
255 @view
256 @external
257 def version() -> String[8]:
258     """
259     @notice Get the version of this token contract
260     """
261     return VERSION
262 
263 
264 @external
265 def initialize(_name: String[64], _symbol: String[32], _pool: address):
266     assert self.minter == ZERO_ADDRESS  # dev: check that we call it from factory
267 
268     self.name = _name
269     self.symbol = _symbol
270     self.minter = _pool
271 
272     self.DOMAIN_SEPARATOR = keccak256(
273         _abi_encode(EIP712_TYPEHASH, keccak256(_name), keccak256(VERSION), chain.id, self)
274     )
275 
276     # fire a transfer event so block explorers identify the contract as an ERC20
277     log Transfer(ZERO_ADDRESS, msg.sender, 0)