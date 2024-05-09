1 # @version 0.3.3
2 """
3 @title Zap for Curve Factory
4 @license MIT
5 @author Curve.Fi
6 @notice Zap for 3pool metapools created via factory
7 """
8 
9 
10 interface ERC20:  # Custom ERC20 which works for USDT, WETH, WBTC and Curve LP Tokens
11     def transfer(_receiver: address, _amount: uint256): nonpayable
12     def transferFrom(_sender: address, _receiver: address, _amount: uint256): nonpayable
13     def approve(_spender: address, _amount: uint256): nonpayable
14     def balanceOf(_owner: address) -> uint256: view
15 
16 
17 interface wETH:
18     def deposit(): payable
19     def withdraw(_amount: uint256): nonpayable
20 
21 
22 # CurveCryptoSwap2ETH from Crypto Factory
23 interface CurveMeta:
24     def coins(i: uint256) -> address: view
25     def token() -> address: view
26     def lp_price() -> uint256: view
27     def price_scale() -> uint256: view
28     def price_oracle() -> uint256: view
29     def virtual_price() -> uint256: view
30     def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256: view
31     def calc_token_amount(amounts: uint256[N_COINS]) -> uint256: view
32     def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256: view
33     def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool = False, receiver: address = msg.sender) -> uint256: payable
34     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256, use_eth: bool = False, receiver: address = msg.sender) -> uint256: payable
35     def remove_liquidity(_amount: uint256, min_amounts: uint256[2], use_eth: bool = False, receiver: address = msg.sender): nonpayable
36     def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256, use_eth: bool = False, receiver: address = msg.sender) -> uint256: nonpayable
37 
38 
39 # TriCrypto pool
40 interface CurveBase:
41     def coins(i: uint256) -> address: view
42     def token() -> address: view
43     def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view
44     def calc_token_amount(amounts: uint256[BASE_N_COINS], is_deposit: bool) -> uint256: view
45     def calc_withdraw_one_coin(token_amount: uint256, i: int128) -> uint256: view
46     def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
47     def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable
48     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
49     def remove_liquidity(amount: uint256, min_amounts: uint256[BASE_N_COINS]): nonpayable
50     def get_virtual_price() -> uint256: view
51 
52 
53 N_COINS: constant(uint256) = 2
54 MAX_COIN: constant(uint256) = N_COINS - 1
55 BASE_N_COINS: constant(uint256) = 3
56 N_ALL_COINS: constant(uint256) = N_COINS + BASE_N_COINS - 1
57 
58 WETH: immutable(wETH)
59 
60 BASE_POOL: immutable(CurveBase)
61 BASE_LP_TOKEN: immutable(address)
62 BASE_COINS: immutable(address[BASE_N_COINS])
63 # coin -> pool -> is approved to transfer?
64 is_approved: HashMap[address, HashMap[address, bool]]
65 
66 
67 @external
68 def __init__(_base_pool: address, _base_lp_token: address, _weth: address, _base_coins: address[BASE_N_COINS]):
69     """
70     @notice Contract constructor
71     """
72     BASE_POOL = CurveBase(_base_pool)
73     BASE_LP_TOKEN = _base_lp_token
74     BASE_COINS = _base_coins
75     WETH = wETH(_weth)
76 
77     for coin in _base_coins:
78         ERC20(coin).approve(_base_pool, MAX_UINT256)
79         self.is_approved[coin][_base_pool] = True
80 
81 
82 @payable
83 @external
84 def __default__():
85     assert msg.sender.is_contract  # dev: receive only from pools and WETH
86 
87 
88 @pure
89 @external
90 def base_pool() -> address:
91     return BASE_POOL.address
92 
93 
94 @pure
95 @external
96 def base_token() -> address:
97     return BASE_LP_TOKEN
98 
99 
100 @external
101 @view
102 def price_oracle(_pool: address) -> uint256:
103     usd_tkn: uint256 = CurveMeta(_pool).price_oracle()
104     vprice: uint256 = BASE_POOL.get_virtual_price()
105     return vprice * 10**18 / usd_tkn
106 
107 
108 @external
109 @view
110 def price_scale(_pool: address) -> uint256:
111     usd_tkn: uint256 = CurveMeta(_pool).price_scale()
112     vprice: uint256 = BASE_POOL.get_virtual_price()
113     return vprice * 10**18 / usd_tkn
114 
115 
116 @external
117 @view
118 def lp_price(_pool: address) -> uint256:
119     p: uint256 = CurveMeta(_pool).lp_price()  # price in tkn
120     usd_tkn: uint256 = CurveMeta(_pool).price_oracle()
121     vprice: uint256 = BASE_POOL.get_virtual_price()
122     return p * vprice / usd_tkn
123 
124 
125 @internal
126 def _receive(_coin: address, _amount: uint256, _from: address,
127              _eth_value: uint256, _use_eth: bool, _wrap_eth: bool=False) -> uint256:
128     """
129     Transfer coin to zap
130     @param _coin Address of the coin
131     @param _amount Amount of coin
132     @param _from Sender of the coin
133     @param _eth_value Eth value sent
134     @param _use_eth Use raw ETH
135     @param _wrap_eth Wrap raw ETH
136     @return Received ETH amount
137     """
138     if _use_eth and _coin == WETH.address:
139         assert _eth_value == _amount  # dev: incorrect ETH amount
140         if _wrap_eth:
141             WETH.deposit(value=_amount)
142         else:
143             return _amount
144     else:
145         response: Bytes[32] = raw_call(
146             _coin,
147             _abi_encode(
148                 _from,
149                 self,
150                 _amount,
151                 method_id=method_id("transferFrom(address,address,uint256)"),
152             ),
153             max_outsize=32,
154         )
155         if len(response) != 0:
156             assert convert(response, bool)  # dev: failed transfer
157     return 0
158 
159 
160 @internal
161 def _send(_coin: address, _to: address, _use_eth: bool, _withdraw_eth: bool=False) -> uint256:
162     """
163     Send coin from zap
164     @dev Sends all available amount
165     @param _coin Address of the coin
166     @param _to Sender of the coin
167     @param _use_eth Use raw ETH
168     @param _withdraw_eth Withdraw raw ETH from wETH
169     @return Amount of coin sent
170     """
171     amount: uint256 = 0
172     if _use_eth and _coin == WETH.address:
173         if _withdraw_eth:
174             amount = ERC20(_coin).balanceOf(self)
175             WETH.withdraw(amount)
176         amount = self.balance
177         raw_call(_to, b"", value=amount)
178     else:
179         amount = ERC20(_coin).balanceOf(self)
180         response: Bytes[32] = raw_call(
181             _coin,
182             _abi_encode(_to, amount, method_id=method_id("transfer(address,uint256)")),
183             max_outsize=32,
184         )
185         if len(response) != 0:
186             assert convert(response, bool)  # dev: failed transfer
187     return amount
188 
189 
190 @payable
191 @external
192 def exchange(_pool: address, i: uint256, j: uint256, _dx: uint256, _min_dy: uint256,
193              _use_eth: bool = False, _receiver: address = msg.sender) -> uint256:
194     """
195     @notice Exchange using wETH by default
196     @dev Index values can be found via the `coins` public getter method
197     @param _pool Address of the pool for the exchange
198     @param i Index value for the coin to send
199     @param j Index value of the coin to receive
200     @param _dx Amount of `i` being exchanged
201     @param _min_dy Minimum amount of `j` to receive
202     @param _use_eth Use raw ETH
203     @param _receiver Address that will receive `j`
204     @return Actual amount of `j` received
205     """
206     assert i != j  # dev: indexes are similar
207     if not _use_eth:
208         assert msg.value == 0  # dev: nonzero ETH amount
209 
210     base_coins: address[BASE_N_COINS] = BASE_COINS
211     if i < MAX_COIN:  # Swap to LP token and remove from base
212         # Receive and swap to LP Token
213         coin: address = CurveMeta(_pool).coins(i)
214         eth_amount: uint256 = self._receive(coin, _dx, msg.sender, msg.value, _use_eth)
215         if not self.is_approved[coin][_pool]:
216             ERC20(coin).approve(_pool, MAX_UINT256)
217             self.is_approved[coin][_pool] = True
218         lp_amount: uint256 = CurveMeta(_pool).exchange(i, MAX_COIN, _dx, 0, _use_eth, value=eth_amount)
219 
220         # Remove and send to _receiver
221         BASE_POOL.remove_liquidity_one_coin(lp_amount, convert(j - MAX_COIN, int128), _min_dy)
222 
223         coin = base_coins[j - MAX_COIN]
224         return self._send(coin, _receiver, _use_eth, True)
225 
226     # Receive coin i
227     base_i: int128 = convert(i - MAX_COIN, int128)
228     self._receive(base_coins[base_i], _dx, msg.sender, msg.value, _use_eth, True)
229 
230     # Add in base and exchange LP token
231     if j < MAX_COIN:
232         amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
233         amounts[base_i] = _dx
234 
235         BASE_POOL.add_liquidity(amounts, 0)
236 
237         if not self.is_approved[BASE_LP_TOKEN][_pool]:
238             ERC20(BASE_LP_TOKEN).approve(_pool, MAX_UINT256)
239             self.is_approved[BASE_LP_TOKEN][_pool] = True
240 
241         lp_amount: uint256 = ERC20(BASE_LP_TOKEN).balanceOf(self)
242         return CurveMeta(_pool).exchange(MAX_COIN, j, lp_amount, _min_dy, _use_eth, _receiver)
243 
244     base_j: int128 = convert(j - MAX_COIN, int128)
245 
246     BASE_POOL.exchange(base_i, base_j, _dx, _min_dy)
247 
248     coin: address = base_coins[base_j]
249     return self._send(coin, _receiver, _use_eth, True)
250 
251 
252 @view
253 @external
254 def get_dy(_pool: address, i: uint256, j: uint256, _dx: uint256) -> uint256:
255     """
256     @notice Calculate the amount received in exchange
257     @dev Index values can be found via the `coins` public getter method
258     @param _pool Address of the pool for the exchange
259     @param i Index value for the coin to send
260     @param j Index value of the coin to receive
261     @param _dx Amount of `i` being exchanged
262     @return Expected amount of `j` to receive
263     """
264     assert i != j  # dev: indexes are similar
265 
266     if i < MAX_COIN:  # Swap to LP token and remove from base
267         lp_amount: uint256 = CurveMeta(_pool).get_dy(i, MAX_COIN, _dx)
268 
269         return BASE_POOL.calc_withdraw_one_coin(lp_amount, convert(j - MAX_COIN, int128))
270 
271     # Add in base and exchange LP token
272     if j < MAX_COIN:
273         amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
274         amounts[i - MAX_COIN] = _dx
275         lp_amount: uint256 = BASE_POOL.calc_token_amount(amounts, True)
276 
277         return CurveMeta(_pool).get_dy(MAX_COIN, j, lp_amount)
278 
279     # Exchange in base
280     return BASE_POOL.get_dy(convert(i - MAX_COIN, int128), convert(j - MAX_COIN, int128), _dx)
281 
282 
283 @payable
284 @external
285 def add_liquidity(
286     _pool: address,
287     _deposit_amounts: uint256[N_ALL_COINS],
288     _min_mint_amount: uint256,
289     _use_eth: bool = False,
290     _receiver: address = msg.sender,
291 ) -> uint256:
292     """
293     @notice Deposit tokens to base and meta pools
294     @param _pool Address of the metapool to deposit into
295     @param _deposit_amounts List of amounts of underlying coins to deposit
296     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
297     @param _use_eth Use raw ETH
298     @param _receiver Address that receives the LP tokens
299     @return Amount of LP tokens received by depositing
300     """
301     if not _use_eth:
302         assert msg.value == 0  # dev: nonzero ETH amount
303     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
304     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
305     deposit_base: bool = False
306     base_coins: address[BASE_N_COINS] = BASE_COINS
307     eth_amount: uint256 = 0
308 
309     if _deposit_amounts[0] != 0:
310         coin: address = CurveMeta(_pool).coins(0)
311         eth_amount = self._receive(coin, _deposit_amounts[0], msg.sender, msg.value, _use_eth)
312         if not self.is_approved[coin][_pool]:
313             ERC20(coin).approve(_pool, MAX_UINT256)
314             self.is_approved[coin][_pool] = True
315         meta_amounts[0] = _deposit_amounts[0]
316 
317     for i in range(MAX_COIN, N_ALL_COINS):
318         amount: uint256 = _deposit_amounts[i]
319         if amount == 0:
320             continue
321         deposit_base = True
322 
323         base_idx: uint256 = i - MAX_COIN
324 
325         coin: address = base_coins[base_idx]
326         self._receive(coin, amount, msg.sender, msg.value, _use_eth, True)
327         base_amounts[base_idx] = amount
328 
329     # Deposit to the base pool
330     if deposit_base:
331         BASE_POOL.add_liquidity(base_amounts, 0)
332         meta_amounts[MAX_COIN] = ERC20(BASE_LP_TOKEN).balanceOf(self)
333         if not self.is_approved[BASE_LP_TOKEN][_pool]:
334             ERC20(BASE_LP_TOKEN).approve(_pool, MAX_UINT256)
335             self.is_approved[BASE_LP_TOKEN][_pool] = True
336 
337     # Deposit to the meta pool
338     return CurveMeta(_pool).add_liquidity(meta_amounts, _min_mint_amount, _use_eth, _receiver, value=eth_amount)
339 
340 
341 @view
342 @external
343 def calc_token_amount(_pool: address, _amounts: uint256[N_ALL_COINS]) -> uint256:
344     """
345     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
346     @dev This calculation accounts for slippage, but not fees.
347          Needed to prevent front-running, not for precise calculations!
348     @param _pool Address of the pool to deposit into
349     @param _amounts Amount of each underlying coin being deposited
350     @return Expected amount of LP tokens received
351     """
352     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
353     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
354     deposit_base: bool = False
355 
356     meta_amounts[0] = _amounts[0]
357     for i in range(BASE_N_COINS):
358         base_amounts[i] = _amounts[i + MAX_COIN]
359         if base_amounts[i] > 0:
360             deposit_base = True
361 
362     if deposit_base:
363         base_tokens: uint256 = BASE_POOL.calc_token_amount(base_amounts, True)
364         meta_amounts[MAX_COIN] = base_tokens
365 
366     return CurveMeta(_pool).calc_token_amount(meta_amounts)
367 
368 
369 @external
370 def remove_liquidity(
371     _pool: address,
372     _burn_amount: uint256,
373     _min_amounts: uint256[N_ALL_COINS],
374     _use_eth: bool = False,
375     _receiver: address = msg.sender,
376 ) -> uint256[N_ALL_COINS]:
377     """
378     @notice Withdraw and unwrap coins from the pool
379     @dev Withdrawal amounts are based on current deposit ratios
380     @param _pool Address of the pool to withdraw from
381     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
382     @param _min_amounts Minimum amounts of underlying coins to receive
383     @param _use_eth Use raw ETH
384     @param _receiver Address that receives the LP tokens
385     @return List of amounts of underlying coins that were withdrawn
386     """
387     lp_token: address = CurveMeta(_pool).token()
388     ERC20(lp_token).transferFrom(msg.sender, self, _burn_amount)
389 
390     min_amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
391     amounts: uint256[N_ALL_COINS] = empty(uint256[N_ALL_COINS])
392 
393     # Withdraw from meta
394     CurveMeta(_pool).remove_liquidity(
395         _burn_amount,
396         [_min_amounts[0], 0],
397         _use_eth,
398     )
399     lp_amount: uint256 = ERC20(BASE_LP_TOKEN).balanceOf(self)
400 
401     # Withdraw from base
402     for i in range(BASE_N_COINS):
403         min_amounts_base[i] = _min_amounts[MAX_COIN + i]
404     BASE_POOL.remove_liquidity(lp_amount, min_amounts_base)
405 
406     # Transfer all coins out
407     coin: address = CurveMeta(_pool).coins(0)
408     amounts[0] = self._send(coin, _receiver, _use_eth)
409 
410     base_coins: address[BASE_N_COINS] = BASE_COINS
411     for i in range(MAX_COIN, N_ALL_COINS):
412         coin = base_coins[i - MAX_COIN]
413         amounts[i] = self._send(coin, _receiver, _use_eth, True)
414 
415     return amounts
416 
417 
418 @external
419 def remove_liquidity_one_coin(
420     _pool: address,
421     _burn_amount: uint256,
422     i: uint256,
423     _min_amount: uint256,
424     _use_eth: bool = False,
425     _receiver: address=msg.sender
426 ) -> uint256:
427     """
428     @notice Withdraw and unwrap a single coin from the pool
429     @param _pool Address of the pool to withdraw from
430     @param _burn_amount Amount of LP tokens to burn in the withdrawal
431     @param i Index value of the coin to withdraw
432     @param _min_amount Minimum amount of underlying coin to receive
433     @param _use_eth Use raw ETH
434     @param _receiver Address that receives the LP tokens
435     @return Amount of underlying coin received
436     """
437     lp_token: address = CurveMeta(_pool).token()
438     ERC20(lp_token).transferFrom(msg.sender, self, _burn_amount)
439 
440     if i < MAX_COIN:
441         return CurveMeta(_pool).remove_liquidity_one_coin(_burn_amount, i, _min_amount, _use_eth, _receiver)
442 
443     # Withdraw a base pool coin
444     coin_amount: uint256 = CurveMeta(_pool).remove_liquidity_one_coin(_burn_amount, MAX_COIN, 0)
445 
446     BASE_POOL.remove_liquidity_one_coin(coin_amount, convert(i - MAX_COIN, int128), _min_amount)
447 
448     coin: address = BASE_COINS[i - MAX_COIN]
449     return self._send(coin, _receiver, _use_eth, True)
450 
451 
452 @view
453 @external
454 def calc_withdraw_one_coin(_pool: address, _token_amount: uint256, i: uint256) -> uint256:
455     """
456     @notice Calculate the amount received when withdrawing and unwrapping a single coin
457     @param _pool Address of the pool to withdraw from
458     @param _token_amount Amount of LP tokens to burn in the withdrawal
459     @param i Index value of the underlying coin to withdraw
460     @return Amount of coin received
461     """
462     if i < MAX_COIN:
463         return CurveMeta(_pool).calc_withdraw_one_coin(_token_amount, i)
464 
465     _base_tokens: uint256 = CurveMeta(_pool).calc_withdraw_one_coin(_token_amount, MAX_COIN)
466     return BASE_POOL.calc_withdraw_one_coin(_base_tokens, convert(i - MAX_COIN, int128))