1 # @version 0.2.16
2 
3 interface AddressProvider:
4     def get_registry() -> address: view
5     def get_address(_id: uint256) -> address: view
6 
7 interface Registry:
8     def find_pool_for_coins(_from: address, _to: address) -> address: view
9     def get_coin_indices(
10         _pool: address,
11         _from: address,
12         _to: address
13     ) -> (uint256, uint256, uint256): view
14 
15 interface RegistrySwap:
16     def get_best_rate(_from: address, _to: address, _amount: uint256) -> (address, uint256): view
17 
18 interface CurveCryptoSwap:
19     def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256: view
20     def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool): payable
21     def coins(i: uint256) -> address: view
22 
23 interface CurvePool:
24     def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): payable
25     def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256): payable
26 
27 interface ERC20:
28     def approve(spender: address, amount: uint256): nonpayable
29     def transfer(to: address, amount: uint256): nonpayable
30     def transferFrom(sender: address, to: address, amount: uint256): nonpayable
31     def balanceOf(owner: address) -> uint256: view
32 
33 
34 event CommitOwnership:
35     admin: address
36 
37 event ApplyOwnership:
38     admin: address
39 
40 event TrustedForwardershipTransferred:
41     previous_forwarder: address
42     new_forwarder: address
43 
44 
45 ADDRESS_PROVIDER: constant(address) = 0x0000000022D53366457F9d5E68Ec105046FC4383
46 ETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
47 WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
48 
49 swap: public(address)
50 crypto_coins: public(address[3])
51 
52 # token -> spender -> is approved to transfer?
53 is_approved: HashMap[address, HashMap[address, bool]]
54 
55 owner: public(address)
56 trusted_forwarder: public(address)
57 
58 future_owner: public(address)
59 
60 
61 @external
62 def __init__(_swap: address):
63     self.owner = msg.sender
64     self.swap = _swap
65     for i in range(3):
66         coin: address = CurveCryptoSwap(_swap).coins(i)
67         if coin == WETH:
68             self.crypto_coins[i] = ETH
69         else:
70             ERC20(coin).approve(_swap, MAX_UINT256)
71             self.crypto_coins[i] = coin
72 
73 
74 @payable
75 @external
76 def __default__():
77     # required to receive Ether
78     pass
79 
80 
81 @payable
82 @external
83 def exchange(
84     _amount: uint256,
85     _route: address[6],
86     _indices: uint256[8],
87     _min_received: uint256,
88     _receiver: address = msg.sender
89 ):
90     """
91     @notice Perform a cross-asset exchange.
92     @dev `_route` and `_indices` are generated by calling `get_exchange_routing`
93          prior to making a transaction. This reduces gas costs on swaps.
94     @param _amount Amount of the input token being swapped.
95     @param _route Array of token and pool addresses used within the swap.
96     @param _indices Array of `i` and `j` inputs used for individual swaps.
97     @param _min_received Minimum amount of the output token to be received. If
98                          the actual amount received is less the call will revert.
99     @param _receiver An alternate address to which the output of the exchange will be sent
100     """
101     # Meta-tx support
102     msg_sender: address = msg.sender
103     receiver: address = _receiver
104     if msg_sender == self.trusted_forwarder:
105         calldata_len: uint256 = len(msg.data)
106         addr_bytes: Bytes[20] = empty(Bytes[20])
107         # grab the last 20 bytes of calldata which holds the address
108         if calldata_len == 536:
109             addr_bytes = slice(msg.data, 516, 20)
110         elif calldata_len == 568:
111             addr_bytes = slice(msg.data, 548, 20)
112         # convert to an address
113         msg_sender = convert(convert(addr_bytes, uint256), address)
114         if _receiver == msg.sender:
115             # we already know that msg.sender is the trusted forwarder
116             # if _receiver is set to msg.sender change it to be correct
117             receiver = msg_sender
118 
119     eth_value: uint256 = 0
120     amount: uint256 = _amount
121 
122     # perform the first stableswap, if required
123     if _route[1] != ZERO_ADDRESS:
124         ERC20(_route[0]).transferFrom(msg_sender, self, _amount)  # dev: insufficient amount
125 
126         if not self.is_approved[_route[0]][_route[1]]:
127             ERC20(_route[0]).approve(_route[1], MAX_UINT256)  # dev: bad response
128             self.is_approved[_route[0]][_route[1]] = True
129 
130         # `_indices[2]` is a boolean-as-integer indicating if the swap uses `exchange_underlying`
131         if _indices[2] == 0:
132             CurvePool(_route[1]).exchange(
133                 convert(_indices[0], int128),
134                 convert(_indices[1], int128),
135                 _amount,
136                 0,
137                 value=msg.value,
138             )  # dev: bad response
139         else:
140             CurvePool(_route[1]).exchange_underlying(
141                 convert(_indices[0], int128),
142                 convert(_indices[1], int128),
143                 _amount,
144                 0,
145                 value=msg.value,
146             )  # dev: bad response
147 
148         if _route[2] == ETH:
149             amount = self.balance
150             eth_value = self.balance
151         else:
152             amount = ERC20(_route[2]).balanceOf(self)  # dev: bad response
153 
154     # if no initial stableswap, transfer token and validate the amount of ether sent
155     elif _route[2] == ETH:
156         assert _amount == msg.value  # dev: insufficient amount
157         eth_value = msg.value
158     else:
159         assert msg.value == 0
160         ERC20(_route[2]).transferFrom(msg_sender, self, _amount)  # dev: insufficient amount
161 
162     # perform the main crypto swap, if required
163     if _indices[3] != _indices[4]:
164         use_eth: bool = ETH in [_route[2], _route[3]]
165         CurveCryptoSwap(self.swap).exchange(
166             _indices[3],
167             _indices[4],
168             amount,
169             0,
170             use_eth,
171             value=eth_value
172         )  # dev: bad response
173         if _route[3] == ETH:
174             amount = self.balance
175             eth_value = self.balance
176         else:
177             amount = ERC20(_route[3]).balanceOf(self)  # dev: bad response
178             eth_value = 0
179 
180     # perform the second stableswap, if required
181     if _route[4] != ZERO_ADDRESS:
182         if _route[3] != ETH and not self.is_approved[_route[3]][_route[4]]:
183             ERC20(_route[3]).approve(_route[4], MAX_UINT256)  # dev: bad response
184             self.is_approved[_route[3]][_route[4]] = True
185 
186         # `_indices[7]` is a boolean-as-integer indicating if the swap uses `exchange_underlying`
187         if _indices[7] == 0:
188             CurvePool(_route[4]).exchange(
189                 convert(_indices[5], int128),
190                 convert(_indices[6], int128),
191                 amount,
192                 _min_received,
193                 value=eth_value,
194             )  # dev: bad response
195         else:
196             CurvePool(_route[4]).exchange_underlying(
197                 convert(_indices[5], int128),
198                 convert(_indices[6], int128),
199                 amount,
200                 _min_received,
201                 value=eth_value,
202             )  # dev: bad response
203 
204         if _route[5] == ETH:
205             raw_call(receiver, b"", value=self.balance)
206         else:
207             amount = ERC20(_route[5]).balanceOf(self)
208             ERC20(_route[5]).transfer(receiver, amount)
209 
210     # if no final swap, check slippage and transfer to receiver
211     else:
212         assert amount >= _min_received
213         if _route[3] == ETH:
214             raw_call(receiver, b"", value=self.balance)
215         else:
216             ERC20(_route[3]).transfer(receiver, amount)
217 
218 
219 @view
220 @external
221 def get_exchange_routing(
222     _initial: address,
223     _target: address,
224     _amount: uint256
225 ) -> (address[6], uint256[8], uint256):
226     """
227     @notice Get routing data for a cross-asset exchange.
228     @dev Outputs from this function are used as inputs when calling `exchange`.
229     @param _initial Address of the initial token being swapped.
230     @param _target Address of the token to be received in the swap.
231     @param _amount Amount of `_initial` to swap.
232     @return _route Array of token and pool addresses used within the swap,
233                     Array of `i` and `j` inputs used for individual swaps.
234                     Expected amount of the output token to be received.
235     """
236 
237     # route is [initial coin, stableswap, cryptopool input, cryptopool output, stableswap, target coin]
238     route: address[6] = empty(address[6])
239 
240     # indices is [(i, j, is_underlying), (i, j), (i, j, is_underlying)]
241     # tuples indicate first stableswap, crypto swap, second stableswap
242     indices: uint256[8] = empty(uint256[8])
243 
244     crypto_input: address = ZERO_ADDRESS
245     crypto_output: address = ZERO_ADDRESS
246     market: address = ZERO_ADDRESS
247 
248     amount: uint256 = _amount
249     crypto_coins: address[3] = self.crypto_coins
250     swaps: address = AddressProvider(ADDRESS_PROVIDER).get_address(2)
251     registry: address = AddressProvider(ADDRESS_PROVIDER).get_registry()
252 
253     # if initial coin is not in the crypto pool, get info for the first stableswap
254     if _initial in crypto_coins:
255         crypto_input = _initial
256     else:
257         received: uint256 = 0
258         for coin in crypto_coins:
259             market, received = RegistrySwap(swaps).get_best_rate(_initial, coin, amount)
260             if market != ZERO_ADDRESS:
261                 indices[0], indices[1], indices[2] = Registry(registry).get_coin_indices(market, _initial, coin)
262                 route[0] = _initial
263                 route[1] = market
264                 crypto_input = coin
265                 amount = received
266                 break
267         assert market != ZERO_ADDRESS
268 
269     # determine target coin when swapping in the crypto pool
270     if _target in crypto_coins:
271         crypto_output = _target
272     else:
273         for coin in crypto_coins:
274             if Registry(registry).find_pool_for_coins(coin, _target) != ZERO_ADDRESS:
275                 crypto_output = coin
276                 break
277         assert crypto_output != ZERO_ADDRESS
278 
279     route[2] = crypto_input
280     route[3] = crypto_output
281 
282     # get i, j and dy for crypto swap if needed
283     if crypto_input != crypto_output:
284         for x in range(3):
285             coin: address = self.crypto_coins[x]
286             if coin == crypto_input:
287                 indices[3] = x
288             elif coin == crypto_output:
289                 indices[4] = x
290         amount = CurveCryptoSwap(self.swap).get_dy(indices[3], indices[4], amount)
291 
292     # if target coin is not in the crypto pool, get info for the final stableswap
293     if crypto_output != _target:
294         market, amount = RegistrySwap(swaps).get_best_rate(crypto_output, _target, amount)
295         indices[5], indices[6], indices[7] = Registry(registry).get_coin_indices(market, crypto_output, _target)
296         route[4] = market
297         route[5] = _target
298 
299     return route, indices, amount
300 
301 
302 @view
303 @external
304 def can_route(_initial: address, _target: address) -> bool:
305     """
306     @notice Check if a route is available between two tokens.
307     @param _initial Address of the initial token being swapped.
308     @param _target Address of the token to be received in the swap.
309     @return bool Is route available?
310     """
311 
312     crypto_coins: address[3] = self.crypto_coins
313     registry: address = AddressProvider(ADDRESS_PROVIDER).get_registry()
314 
315     crypto_input: address = _initial
316     if _initial not in crypto_coins:
317         market: address = ZERO_ADDRESS
318         for coin in crypto_coins:
319             market = Registry(registry).find_pool_for_coins(_initial, coin)
320             if market != ZERO_ADDRESS:
321                 crypto_input = coin
322                 break
323         if market == ZERO_ADDRESS:
324             return False
325 
326     crypto_output: address = _target
327     if _target not in crypto_coins:
328         market: address = ZERO_ADDRESS
329         for coin in crypto_coins:
330             market = Registry(registry).find_pool_for_coins(coin, _target)
331             if market != ZERO_ADDRESS:
332                 crypto_output = coin
333                 break
334         if market == ZERO_ADDRESS:
335             return False
336 
337     return True
338 
339 
340 @external
341 def commit_transfer_ownership(addr: address):
342     """
343     @notice Transfer ownership of GaugeController to `addr`
344     @param addr Address to have ownership transferred to
345     """
346     assert msg.sender == self.owner  # dev: admin only
347 
348     self.future_owner = addr
349     log CommitOwnership(addr)
350 
351 
352 @external
353 def accept_transfer_ownership():
354     """
355     @notice Accept a pending ownership transfer
356     """
357     _admin: address = self.future_owner
358     assert msg.sender == _admin  # dev: future admin only
359 
360     self.owner = _admin
361     log ApplyOwnership(_admin)
362 
363 
364 @view
365 @external
366 def isTrustedForwarder(_forwarder: address) -> bool:
367     """
368     @notice ERC-2771 meta-txs discovery mechanism
369     @param _forwarder Address to compare against the set trusted forwarder
370     @return bool True if `_forwarder` equals the set trusted forwarder
371     """
372     return _forwarder == self.trusted_forwarder
373 
374 
375 @external
376 def set_trusted_forwarder(_forwarder: address) -> bool:
377     """
378     @notice Set the trusted forwarder address
379     @param _forwarder The address of the trusted forwarder
380     @return bool True on successful execution
381     """
382     assert msg.sender == self.owner
383 
384     prev_forwarder: address = self.trusted_forwarder
385     self.trusted_forwarder = _forwarder
386 
387     log TrustedForwardershipTransferred(prev_forwarder, _forwarder)
388     return True