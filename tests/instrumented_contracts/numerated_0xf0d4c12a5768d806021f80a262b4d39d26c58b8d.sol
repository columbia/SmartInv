1 # @version 0.3.7
2 
3 """
4 @title CurveRouter v1.0
5 @author Curve.Fi
6 @license Copyright (c) Curve.Fi, 2020-2023 - all rights reserved
7 @notice Performs up to 5 swaps in a single transaction, can do estimations with get_dy and get_dx
8 """
9 
10 from vyper.interfaces import ERC20
11 
12 interface StablePool:
13     def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): payable
14     def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256): payable
15     def get_dy(i: int128, j: int128, amount: uint256) -> uint256: view
16     def get_dy_underlying(i: int128, j: int128, amount: uint256) -> uint256: view
17     def coins(i: uint256) -> address: view
18     def calc_withdraw_one_coin(token_amount: uint256, i: int128) -> uint256: view
19     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
20 
21 interface CryptoPool:
22     def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256): payable
23     def exchange_underlying(i: uint256, j: uint256, dx: uint256, min_dy: uint256): payable
24     def get_dy(i: uint256, j: uint256, amount: uint256) -> uint256: view
25     def get_dy_underlying(i: uint256, j: uint256, amount: uint256) -> uint256: view
26     def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256: view
27     def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256): nonpayable
28 
29 interface CryptoPoolETH:
30     def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool): payable
31 
32 interface LendingBasePoolMetaZap:
33     def exchange_underlying(pool: address, i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable
34 
35 interface CryptoMetaZap:
36     def get_dy(pool: address, i: uint256, j: uint256, dx: uint256) -> uint256: view
37     def exchange(pool: address, i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool): payable
38 
39 interface StablePool2Coins:
40     def add_liquidity(amounts: uint256[2], min_mint_amount: uint256): payable
41     def calc_token_amount(amounts: uint256[2], is_deposit: bool) -> uint256: view
42 
43 interface CryptoPool2Coins:
44     def calc_token_amount(amounts: uint256[2]) -> uint256: view
45 
46 interface StablePool3Coins:
47     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256): payable
48     def calc_token_amount(amounts: uint256[3], is_deposit: bool) -> uint256: view
49 
50 interface CryptoPool3Coins:
51     def calc_token_amount(amounts: uint256[3]) -> uint256: view
52 
53 interface StablePool4Coins:
54     def add_liquidity(amounts: uint256[4], min_mint_amount: uint256): payable
55     def calc_token_amount(amounts: uint256[4], is_deposit: bool) -> uint256: view
56 
57 interface CryptoPool4Coins:
58     def calc_token_amount(amounts: uint256[4]) -> uint256: view
59 
60 interface StablePool5Coins:
61     def add_liquidity(amounts: uint256[5], min_mint_amount: uint256): payable
62     def calc_token_amount(amounts: uint256[5], is_deposit: bool) -> uint256: view
63 
64 interface CryptoPool5Coins:
65     def calc_token_amount(amounts: uint256[5]) -> uint256: view
66 
67 interface LendingStablePool3Coins:
68     def add_liquidity(amounts: uint256[3], min_mint_amount: uint256, use_underlying: bool): payable
69     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256, use_underlying: bool) -> uint256: nonpayable
70 
71 interface Llamma:
72     def get_dx(i: uint256, j: uint256, out_amount: uint256) -> uint256: view
73 
74 interface WETH:
75     def deposit(): payable
76     def withdraw(_amount: uint256): nonpayable
77 
78 interface stETH:
79     def submit(_refferer: address): payable
80 
81 interface frxETHMinter:
82     def submit(): payable
83 
84 interface wstETH:
85     def getWstETHByStETH(_stETHAmount: uint256) -> uint256: view
86     def getStETHByWstETH(_wstETHAmount: uint256) -> uint256: view
87     def wrap(_stETHAmount: uint256) -> uint256: nonpayable
88     def unwrap(_wstETHAmount: uint256) -> uint256: nonpayable
89 
90 interface sfrxETH:
91     def convertToShares(assets: uint256) -> uint256: view
92     def convertToAssets(shares: uint256) -> uint256: view
93     def deposit(assets: uint256, receiver: address) -> uint256: nonpayable
94     def redeem(shares: uint256, receiver: address, owner: address) -> uint256: nonpayable
95 
96 interface wBETH:
97     def deposit(referral: address): payable
98     def exchangeRate() -> uint256: view
99 
100 # SNX
101 interface SnxCoin:
102     def currencyKey() -> bytes32: nonpayable
103 
104 interface Synthetix:
105     def exchangeAtomically(sourceCurrencyKey: bytes32, sourceAmount: uint256, destinationCurrencyKey: bytes32, trackingCode: bytes32, minAmount: uint256) -> uint256: nonpayable
106 
107 interface SynthetixExchanger:
108     def getAmountsForAtomicExchange(sourceAmount: uint256, sourceCurrencyKey: bytes32, destinationCurrencyKey: bytes32) -> AtomicAmountAndFee: view
109 
110 interface SynthetixAddressResolver:
111     def getAddress(name: bytes32) -> address: view
112 
113 # Calc zaps
114 interface StableCalc:
115     def calc_token_amount(pool: address, token: address, amounts: uint256[10], n_coins: uint256, deposit: bool, use_underlying: bool) -> uint256: view
116     def get_dx(pool: address, i: int128, j: int128, dy: uint256, n_coins: uint256) -> uint256: view
117     def get_dx_underlying(pool: address, i: int128, j: int128, dy: uint256, n_coins: uint256) -> uint256: view
118     def get_dx_meta(pool: address, i: int128, j: int128, dy: uint256, n_coins: uint256, base_pool: address) -> uint256: view
119     def get_dx_meta_underlying(pool: address, i: int128, j: int128, dy: uint256, n_coins: uint256, base_pool: address, base_token: address) -> uint256: view
120 
121 interface CryptoCalc:
122     def get_dx(pool: address, i: uint256, j: uint256, dy: uint256, n_coins: uint256) -> uint256: view
123     def get_dx_meta_underlying(pool: address, i: uint256, j: uint256, dy: uint256, n_coins: uint256, base_pool: address, base_token: address) -> uint256: view
124 
125 
126 struct AtomicAmountAndFee:
127     amountReceived: uint256
128     fee: uint256
129     exchangeFeeRate: uint256
130 
131 
132 event Exchange:
133     sender: indexed(address)
134     receiver: indexed(address)
135     route: address[11]
136     swap_params: uint256[5][5]
137     pools: address[5]
138     in_amount: uint256
139     out_amount: uint256
140 
141 
142 ETH_ADDRESS: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
143 STETH_ADDRESS: constant(address) = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84
144 WSTETH_ADDRESS: constant(address) = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0
145 FRXETH_ADDRESS: constant(address) = 0x5E8422345238F34275888049021821E8E08CAa1f
146 SFRXETH_ADDRESS: constant(address) = 0xac3E018457B222d93114458476f3E3416Abbe38F
147 WBETH_ADDRESS: constant(address) = 0xa2E3356610840701BDf5611a53974510Ae27E2e1
148 WETH_ADDRESS: immutable(address)
149 
150 
151 # SNX
152 # https://github.com/Synthetixio/synthetix-docs/blob/master/content/addresses.md
153 SNX_ADDRESS_RESOLVER: constant(address) = 0x823bE81bbF96BEc0e25CA13170F5AaCb5B79ba83
154 SNX_TRACKING_CODE: constant(bytes32) = 0x4355525645000000000000000000000000000000000000000000000000000000  # CURVE
155 SNX_EXCHANGER_NAME: constant(bytes32) = 0x45786368616E6765720000000000000000000000000000000000000000000000  # Exchanger
156 snx_currency_keys: HashMap[address, bytes32]
157 
158 # Calc zaps
159 STABLE_CALC: immutable(StableCalc)
160 CRYPTO_CALC: immutable(CryptoCalc)
161 
162 is_approved: HashMap[address, HashMap[address, bool]]
163 
164 
165 @external
166 @payable
167 def __default__():
168     pass
169 
170 
171 @external
172 def __init__( _weth: address, _stable_calc: address, _crypto_calc: address, _snx_coins: address[4]):
173     self.is_approved[WSTETH_ADDRESS][WSTETH_ADDRESS] = True
174     self.is_approved[SFRXETH_ADDRESS][SFRXETH_ADDRESS] = True
175 
176     WETH_ADDRESS = _weth
177     STABLE_CALC = StableCalc(_stable_calc)
178     CRYPTO_CALC = CryptoCalc(_crypto_calc)
179 
180     for _snx_coin in _snx_coins:
181         self.is_approved[_snx_coin][0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F] = True
182         self.snx_currency_keys[_snx_coin] = SnxCoin(_snx_coin).currencyKey()
183 
184 
185 @external
186 @payable
187 @nonreentrant('lock')
188 def exchange(
189     _route: address[11],
190     _swap_params: uint256[5][5],
191     _amount: uint256,
192     _expected: uint256,
193     _pools: address[5]=empty(address[5]),
194     _receiver: address=msg.sender
195 ) -> uint256:
196     """
197     @notice Performs up to 5 swaps in a single transaction.
198     @dev Routing and swap params must be determined off-chain. This
199          functionality is designed for gas efficiency over ease-of-use.
200     @param _route Array of [initial token, pool or zap, token, pool or zap, token, ...]
201                   The array is iterated until a pool address of 0x00, then the last
202                   given token is transferred to `_receiver`
203     @param _swap_params Multidimensional array of [i, j, swap type, pool_type, n_coins] where
204                         i is the index of input token
205                         j is the index of output token
206 
207                         The swap_type should be:
208                         1. for `exchange`,
209                         2. for `exchange_underlying`,
210                         3. for underlying exchange via zap: factory stable metapools with lending base pool `exchange_underlying`
211                            and factory crypto-meta pools underlying exchange (`exchange` method in zap)
212                         4. for coin -> LP token "exchange" (actually `add_liquidity`),
213                         5. for lending pool underlying coin -> LP token "exchange" (actually `add_liquidity`),
214                         6. for LP token -> coin "exchange" (actually `remove_liquidity_one_coin`)
215                         7. for LP token -> lending or fake pool underlying coin "exchange" (actually `remove_liquidity_one_coin`)
216                         8. for ETH <-> WETH, ETH -> stETH or ETH -> frxETH, stETH <-> wstETH, frxETH <-> sfrxETH, ETH -> wBETH
217                         9. for SNX swaps (sUSD, sEUR, sETH, sBTC)
218 
219                         pool_type: 1 - stable, 2 - crypto, 3 - tricrypto, 4 - llamma
220                         n_coins is the number of coins in pool
221     @param _amount The amount of input token (`_route[0]`) to be sent.
222     @param _expected The minimum amount received after the final swap.
223     @param _pools Array of pools for swaps via zap contracts. This parameter is only needed for swap_type = 3.
224     @param _receiver Address to transfer the final output token to.
225     @return Received amount of the final output token.
226     """
227     input_token: address = _route[0]
228     output_token: address = empty(address)
229     amount: uint256 = _amount
230 
231     # validate / transfer initial token
232     if input_token == ETH_ADDRESS:
233         assert msg.value == amount
234     else:
235         assert msg.value == 0
236         assert ERC20(input_token).transferFrom(msg.sender, self, amount, default_return_value=True)
237 
238     for i in range(1, 6):
239         # 5 rounds of iteration to perform up to 5 swaps
240         swap: address = _route[i*2-1]
241         pool: address = _pools[i-1] # Only for Polygon meta-factories underlying swap (swap_type == 6)
242         output_token = _route[i*2]
243         params: uint256[5] = _swap_params[i-1]  # i, j, swap_type, pool_type, n_coins
244 
245         if not self.is_approved[input_token][swap]:
246             assert ERC20(input_token).approve(swap, max_value(uint256), default_return_value=True, skip_contract_check=True)
247             self.is_approved[input_token][swap] = True
248 
249         eth_amount: uint256 = 0
250         if input_token == ETH_ADDRESS:
251             eth_amount = amount
252         # perform the swap according to the swap type
253         if params[2] == 1:
254             if params[3] == 1:  # stable
255                 StablePool(swap).exchange(convert(params[0], int128), convert(params[1], int128), amount, 0, value=eth_amount)
256             else:  # crypto, tricrypto or llamma
257                 if input_token == ETH_ADDRESS or output_token == ETH_ADDRESS:
258                     CryptoPoolETH(swap).exchange(params[0], params[1], amount, 0, True, value=eth_amount)
259                 else:
260                     CryptoPool(swap).exchange(params[0], params[1], amount, 0)
261         elif params[2] == 2:
262             if params[3] == 1:  # stable
263                 StablePool(swap).exchange_underlying(convert(params[0], int128), convert(params[1], int128), amount, 0, value=eth_amount)
264             else:  # crypto or tricrypto
265                 CryptoPool(swap).exchange_underlying(params[0], params[1], amount, 0, value=eth_amount)
266         elif params[2] == 3:  # SWAP IS ZAP HERE !!!
267             if params[3] == 1:  # stable
268                 LendingBasePoolMetaZap(swap).exchange_underlying(pool, convert(params[0], int128), convert(params[1], int128), amount, 0)
269             else:  # crypto or tricrypto
270                 use_eth: bool = input_token == ETH_ADDRESS or output_token == ETH_ADDRESS
271                 CryptoMetaZap(swap).exchange(pool, params[0], params[1], amount, 0, use_eth, value=eth_amount)
272         elif params[2] == 4:
273             if params[4] == 2:
274                 amounts: uint256[2] = [0, 0]
275                 amounts[params[0]] = amount
276                 StablePool2Coins(swap).add_liquidity(amounts, 0, value=eth_amount)
277             elif params[4] == 3:
278                 amounts: uint256[3] = [0, 0, 0]
279                 amounts[params[0]] = amount
280                 StablePool3Coins(swap).add_liquidity(amounts, 0, value=eth_amount)
281             elif params[4] == 4:
282                 amounts: uint256[4] = [0, 0, 0, 0]
283                 amounts[params[0]] = amount
284                 StablePool4Coins(swap).add_liquidity(amounts, 0, value=eth_amount)
285             elif params[4] == 5:
286                 amounts: uint256[5] = [0, 0, 0, 0, 0]
287                 amounts[params[0]] = amount
288                 StablePool5Coins(swap).add_liquidity(amounts, 0, value=eth_amount)
289         elif params[2] == 5:
290             amounts: uint256[3] = [0, 0, 0]
291             amounts[params[0]] = amount
292             LendingStablePool3Coins(swap).add_liquidity(amounts, 0, True, value=eth_amount) # example: aave on Polygon
293         elif params[2] == 6:
294             if params[3] == 1:  # stable
295                 StablePool(swap).remove_liquidity_one_coin(amount, convert(params[1], int128), 0)
296             else:  # crypto or tricrypto
297                 CryptoPool(swap).remove_liquidity_one_coin(amount, params[1], 0)  # example: atricrypto3 on Polygon
298         elif params[2] == 7:
299             LendingStablePool3Coins(swap).remove_liquidity_one_coin(amount, convert(params[1], int128), 0, True) # example: aave on Polygon
300         elif params[2] == 8:
301             if input_token == ETH_ADDRESS and output_token == WETH_ADDRESS:
302                 WETH(swap).deposit(value=amount)
303             elif input_token == WETH_ADDRESS and output_token == ETH_ADDRESS:
304                 WETH(swap).withdraw(amount)
305             elif input_token == ETH_ADDRESS and output_token == STETH_ADDRESS:
306                 stETH(swap).submit(0x0000000000000000000000000000000000000000, value=amount)
307             elif input_token == ETH_ADDRESS and output_token == FRXETH_ADDRESS:
308                 frxETHMinter(swap).submit(value=amount)
309             elif input_token == STETH_ADDRESS and output_token == WSTETH_ADDRESS:
310                 wstETH(swap).wrap(amount)
311             elif input_token == WSTETH_ADDRESS and output_token == STETH_ADDRESS:
312                 wstETH(swap).unwrap(amount)
313             elif input_token == FRXETH_ADDRESS and output_token == SFRXETH_ADDRESS:
314                 sfrxETH(swap).deposit(amount, self)
315             elif input_token == SFRXETH_ADDRESS and output_token == FRXETH_ADDRESS:
316                 sfrxETH(swap).redeem(amount, self, self)
317             elif input_token == ETH_ADDRESS and output_token == WBETH_ADDRESS:
318                 wBETH(swap).deposit(0xeCb456EA5365865EbAb8a2661B0c503410e9B347, value=amount)
319             else:
320                 raise "Swap type 8 is only for ETH <-> WETH, ETH -> stETH or ETH -> frxETH, stETH <-> wstETH, frxETH <-> sfrxETH, ETH -> wBETH"
321         elif params[2] == 9:
322             Synthetix(swap).exchangeAtomically(self.snx_currency_keys[input_token], amount, self.snx_currency_keys[output_token], SNX_TRACKING_CODE, 0)
323         else:
324             raise "Bad swap type"
325 
326         # update the amount received
327         if output_token == ETH_ADDRESS:
328             amount = self.balance
329         else:
330             amount = ERC20(output_token).balanceOf(self)
331 
332         # sanity check, if the routing data is incorrect we will have a 0 balance and that is bad
333         assert amount != 0, "Received nothing"
334 
335         # check if this was the last swap
336         if i == 5 or _route[i*2+1] == empty(address):
337             break
338         # if there is another swap, the output token becomes the input for the next round
339         input_token = output_token
340 
341     amount -= 1  # Change non-zero -> non-zero costs less gas than zero -> non-zero
342     assert amount >= _expected, "Slippage"
343 
344     # transfer the final token to the receiver
345     if output_token == ETH_ADDRESS:
346         raw_call(_receiver, b"", value=amount)
347     else:
348         assert ERC20(output_token).transfer(_receiver, amount, default_return_value=True)
349 
350     log Exchange(msg.sender, _receiver, _route, _swap_params, _pools, _amount, amount)
351 
352     return amount
353 
354 
355 @view
356 @external
357 def get_dy(
358     _route: address[11],
359     _swap_params: uint256[5][5],
360     _amount: uint256,
361     _pools: address[5]=empty(address[5])
362 ) -> uint256:
363     """
364     @notice Get amount of the final output token received in an exchange
365     @dev Routing and swap params must be determined off-chain. This
366          functionality is designed for gas efficiency over ease-of-use.
367     @param _route Array of [initial token, pool or zap, token, pool or zap, token, ...]
368                   The array is iterated until a pool address of 0x00, then the last
369                   given token is transferred to `_receiver`
370     @param _swap_params Multidimensional array of [i, j, swap type, pool_type, n_coins] where
371                         i is the index of input token
372                         j is the index of output token
373 
374                         The swap_type should be:
375                         1. for `exchange`,
376                         2. for `exchange_underlying`,
377                         3. for underlying exchange via zap: factory stable metapools with lending base pool `exchange_underlying`
378                            and factory crypto-meta pools underlying exchange (`exchange` method in zap)
379                         4. for coin -> LP token "exchange" (actually `add_liquidity`),
380                         5. for lending pool underlying coin -> LP token "exchange" (actually `add_liquidity`),
381                         6. for LP token -> coin "exchange" (actually `remove_liquidity_one_coin`)
382                         7. for LP token -> lending or fake pool underlying coin "exchange" (actually `remove_liquidity_one_coin`)
383                         8. for ETH <-> WETH, ETH -> stETH or ETH -> frxETH, stETH <-> wstETH, frxETH <-> sfrxETH, ETH -> wBETH
384                         9. for SNX swaps (sUSD, sEUR, sETH, sBTC)
385 
386                         pool_type: 1 - stable, 2 - crypto, 3 - tricrypto, 4 - llamma
387                         n_coins is the number of coins in pool
388     @param _amount The amount of input token (`_route[0]`) to be sent.
389     @param _pools Array of pools for swaps via zap contracts. This parameter is needed only for swap_type = 3.
390     @return Expected amount of the final output token.
391     """
392     input_token: address = _route[0]
393     output_token: address = empty(address)
394     amount: uint256 = _amount
395 
396     for i in range(1, 6):
397         # 5 rounds of iteration to perform up to 5 swaps
398         swap: address = _route[i*2-1]
399         pool: address = _pools[i-1] # Only for Polygon meta-factories underlying swap (swap_type == 4)
400         output_token = _route[i * 2]
401         params: uint256[5] = _swap_params[i-1]  # i, j, swap_type, pool_type, n_coins
402 
403         # Calc output amount according to the swap type
404         if params[2] == 1:
405             if params[3] == 1:  # stable
406                 amount = StablePool(swap).get_dy(convert(params[0], int128), convert(params[1], int128), amount)
407             else:  # crypto or llamma
408                 amount = CryptoPool(swap).get_dy(params[0], params[1], amount)
409         elif params[2] == 2:
410             if params[3] == 1:  # stable
411                 amount = StablePool(swap).get_dy_underlying(convert(params[0], int128), convert(params[1], int128), amount)
412             else:  # crypto
413                 amount = CryptoPool(swap).get_dy_underlying(params[0], params[1], amount)
414         elif params[2] == 3:  # SWAP IS ZAP HERE !!!
415             if params[3] == 1:  # stable
416                 amount = StablePool(pool).get_dy_underlying(convert(params[0], int128), convert(params[1], int128), amount)
417             else:  # crypto
418                 amount = CryptoMetaZap(swap).get_dy(pool, params[0], params[1], amount)
419         elif params[2] in [4, 5]:
420             if params[3] == 1: # stable
421                 amounts: uint256[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
422                 amounts[params[0]] = amount
423                 amount = STABLE_CALC.calc_token_amount(swap, output_token, amounts, params[4], True, True)
424             else:
425                 # Tricrypto pools have stablepool interface for calc_token_amount
426                 if params[4] == 2:
427                     amounts: uint256[2] = [0, 0]
428                     amounts[params[0]] = amount
429                     if params[3] == 2:  # crypto
430                         amount = CryptoPool2Coins(swap).calc_token_amount(amounts)
431                     else:  # tricrypto
432                         amount = StablePool2Coins(swap).calc_token_amount(amounts, True)
433                 elif params[4] == 3:
434                     amounts: uint256[3] = [0, 0, 0]
435                     amounts[params[0]] = amount
436                     if params[3] == 2:  # crypto
437                         amount = CryptoPool3Coins(swap).calc_token_amount(amounts)
438                     else:  # tricrypto
439                         amount = StablePool3Coins(swap).calc_token_amount(amounts, True)
440                 elif params[4] == 4:
441                     amounts: uint256[4] = [0, 0, 0, 0]
442                     amounts[params[0]] = amount
443                     if params[3] == 2:  # crypto
444                         amount = CryptoPool4Coins(swap).calc_token_amount(amounts)
445                     else:  # tricrypto
446                         amount = StablePool4Coins(swap).calc_token_amount(amounts, True)
447                 elif params[4] == 5:
448                     amounts: uint256[5] = [0, 0, 0, 0, 0]
449                     amounts[params[0]] = amount
450                     if params[3] == 2:  # crypto
451                         amount = CryptoPool5Coins(swap).calc_token_amount(amounts)
452                     else:  # tricrypto
453                         amount = StablePool5Coins(swap).calc_token_amount(amounts, True)
454         elif params[2] in [6, 7]:
455             if params[3] == 1:  # stable
456                 amount = StablePool(swap).calc_withdraw_one_coin(amount, convert(params[1], int128))
457             else:  # crypto
458                 amount = CryptoPool(swap).calc_withdraw_one_coin(amount, params[1])
459         elif params[2] == 8:
460             if input_token == WETH_ADDRESS or output_token == WETH_ADDRESS or \
461                     (input_token == ETH_ADDRESS and output_token == STETH_ADDRESS) or \
462                     (input_token == ETH_ADDRESS and output_token == FRXETH_ADDRESS):
463                 # ETH <--> WETH rate is 1:1
464                 # ETH ---> stETH rate is 1:1
465                 # ETH ---> frxETH rate is 1:1
466                 pass
467             elif input_token == WSTETH_ADDRESS:
468                 amount = wstETH(swap).getStETHByWstETH(amount)
469             elif output_token == WSTETH_ADDRESS:
470                 amount = wstETH(swap).getWstETHByStETH(amount)
471             elif input_token == SFRXETH_ADDRESS:
472                 amount = sfrxETH(swap).convertToAssets(amount)
473             elif output_token == SFRXETH_ADDRESS:
474                 amount = sfrxETH(swap).convertToShares(amount)
475             elif output_token == WBETH_ADDRESS:
476                 amount = amount * 10**18 / wBETH(swap).exchangeRate()
477             else:
478                 raise "Swap type 8 is only for ETH <-> WETH, ETH -> stETH or ETH -> frxETH, stETH <-> wstETH, frxETH <-> sfrxETH, ETH -> wBETH"
479         elif params[2] == 9:
480             snx_exchanger: address = SynthetixAddressResolver(SNX_ADDRESS_RESOLVER).getAddress(SNX_EXCHANGER_NAME)
481             atomic_amount_and_fee: AtomicAmountAndFee = SynthetixExchanger(snx_exchanger).getAmountsForAtomicExchange(
482                 amount, self.snx_currency_keys[input_token], self.snx_currency_keys[output_token]
483             )
484             amount = atomic_amount_and_fee.amountReceived
485         else:
486             raise "Bad swap type"
487 
488         # check if this was the last swap
489         if i == 5 or _route[i*2+1] == empty(address):
490             break
491         # if there is another swap, the output token becomes the input for the next round
492         input_token = output_token
493 
494     return amount - 1
495 
496 
497 @view
498 @external
499 def get_dx(
500     _route: address[11],
501     _swap_params: uint256[5][5],
502     _out_amount: uint256,
503     _pools: address[5],
504     _base_pools: address[5]=empty(address[5]),
505     _base_tokens: address[5]=empty(address[5]),
506 ) -> uint256:
507     """
508     @notice Calculate the input amount required to receive the desired output amount
509     @dev Routing and swap params must be determined off-chain. This
510          functionality is designed for gas efficiency over ease-of-use.
511     @param _route Array of [initial token, pool or zap, token, pool or zap, token, ...]
512                   The array is iterated until a pool address of 0x00, then the last
513                   given token is transferred to `_receiver`
514     @param _swap_params Multidimensional array of [i, j, swap type, pool_type, n_coins] where
515                         i is the index of input token
516                         j is the index of output token
517 
518                         The swap_type should be:
519                         1. for `exchange`,
520                         2. for `exchange_underlying`,
521                         3. for underlying exchange via zap: factory stable metapools with lending base pool `exchange_underlying`
522                            and factory crypto-meta pools underlying exchange (`exchange` method in zap)
523                         4. for coin -> LP token "exchange" (actually `add_liquidity`),
524                         5. for lending pool underlying coin -> LP token "exchange" (actually `add_liquidity`),
525                         6. for LP token -> coin "exchange" (actually `remove_liquidity_one_coin`)
526                         7. for LP token -> lending or fake pool underlying coin "exchange" (actually `remove_liquidity_one_coin`)
527                         8. for ETH <-> WETH, ETH -> stETH or ETH -> frxETH, stETH <-> wstETH, frxETH <-> sfrxETH, ETH -> wBETH
528                         9. for SNX swaps (sUSD, sEUR, sETH, sBTC)
529 
530                         pool_type: 1 - stable, 2 - crypto, 3 - tricrypto, 4 - llamma
531                         n_coins is the number of coins in pool
532     @param _out_amount The desired amount of output coin to receive.
533     @param _pools Array of pools.
534     @param _base_pools Array of base pools (for meta pools).
535     @param _base_tokens Array of base lp tokens (for meta pools). Should be a zap address for double meta pools.
536     @return Required amount of input token to send.
537     """
538     amount: uint256 = _out_amount
539 
540     for _i in range(1, 6):
541         # 5 rounds of iteration to perform up to 5 swaps
542         i: uint256 = 6 - _i
543         swap: address = _route[i*2-1]
544         if swap == empty(address):
545             continue
546         input_token: address = _route[(i - 1) * 2]
547         output_token: address = _route[i * 2]
548         pool: address = _pools[i-1]
549         base_pool: address = _base_pools[i-1]
550         base_token: address = _base_tokens[i-1]
551         params: uint256[5] = _swap_params[i-1]  # i, j, swap_type, pool_type, n_coins
552         n_coins: uint256 = params[4]
553 
554 
555         # Calc a required input amount according to the swap type
556         if params[2] == 1:
557             if params[3] == 1:  # stable
558                 if base_pool == empty(address):  # non-meta
559                     amount = STABLE_CALC.get_dx(pool, convert(params[0], int128), convert(params[1], int128), amount, n_coins)
560                 else:
561                     amount = STABLE_CALC.get_dx_meta(pool, convert(params[0], int128), convert(params[1], int128), amount, n_coins, base_pool)
562             elif params[3] in [2, 3]:  # crypto or tricrypto
563                 amount = CRYPTO_CALC.get_dx(pool, params[0], params[1], amount, n_coins)
564             else:  # llamma
565                 amount = Llamma(pool).get_dx(params[0], params[1], amount)
566         elif params[2] in [2, 3]:
567             if params[3] == 1:  # stable
568                 if base_pool == empty(address):  # non-meta
569                     amount = STABLE_CALC.get_dx_underlying(pool, convert(params[0], int128), convert(params[1], int128), amount, n_coins)
570                 else:
571                     amount = STABLE_CALC.get_dx_meta_underlying(pool, convert(params[0], int128), convert(params[1], int128), amount, n_coins, base_pool, base_token)
572             else:  # crypto
573                 amount = CRYPTO_CALC.get_dx_meta_underlying(pool, params[0], params[1], amount, n_coins, base_pool, base_token)
574         elif params[2] in [4, 5]:
575             # This is not correct. Should be something like calc_add_one_coin. But tests say that it's precise enough.
576             if params[3] == 1:  # stable
577                 amount = StablePool(swap).calc_withdraw_one_coin(amount, convert(params[0], int128))
578             else:  # crypto
579                 amount = CryptoPool(swap).calc_withdraw_one_coin(amount, params[0])
580         elif params[2] in [6, 7]:
581             if params[3] == 1: # stable
582                 amounts: uint256[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
583                 amounts[params[1]] = amount
584                 amount = STABLE_CALC.calc_token_amount(swap, input_token, amounts, n_coins, False, True)
585             else:
586                 # Tricrypto pools have stablepool interface for calc_token_amount
587                 if n_coins == 2:
588                     amounts: uint256[2] = [0, 0]
589                     amounts[params[1]] = amount
590                     if params[3] == 2:  # crypto
591                         amount = CryptoPool2Coins(swap).calc_token_amount(amounts)  # This is not correct
592                     else:  # tricrypto
593                         amount = StablePool2Coins(swap).calc_token_amount(amounts, False)
594                 elif n_coins == 3:
595                     amounts: uint256[3] = [0, 0, 0]
596                     amounts[params[1]] = amount
597                     if params[3] == 2:  # crypto
598                         amount = CryptoPool3Coins(swap).calc_token_amount(amounts)  # This is not correct
599                     else:  # tricrypto
600                         amount = StablePool3Coins(swap).calc_token_amount(amounts, False)
601                 elif n_coins == 4:
602                     amounts: uint256[4] = [0, 0, 0, 0]
603                     amounts[params[1]] = amount
604                     if params[3] == 2:  # crypto
605                         amount = CryptoPool4Coins(swap).calc_token_amount(amounts)  # This is not correct
606                     else:  # tricrypto
607                         amount = StablePool4Coins(swap).calc_token_amount(amounts, False)
608                 elif n_coins == 5:
609                     amounts: uint256[5] = [0, 0, 0, 0, 0]
610                     amounts[params[1]] = amount
611                     if params[3] == 2:  # crypto
612                         amount = CryptoPool5Coins(swap).calc_token_amount(amounts)  # This is not correct
613                     else:  # tricrypto
614                         amount = StablePool5Coins(swap).calc_token_amount(amounts, False)
615         elif params[2] == 8:
616             if input_token == WETH_ADDRESS or output_token == WETH_ADDRESS or \
617                     (input_token == ETH_ADDRESS and output_token == STETH_ADDRESS) or \
618                     (input_token == ETH_ADDRESS and output_token == FRXETH_ADDRESS):
619                 # ETH <--> WETH rate is 1:1
620                 # ETH ---> stETH rate is 1:1
621                 # ETH ---> frxETH rate is 1:1
622                 pass
623             elif input_token == WSTETH_ADDRESS:
624                 amount = wstETH(swap).getWstETHByStETH(amount)
625             elif output_token == WSTETH_ADDRESS:
626                 amount = wstETH(swap).getStETHByWstETH(amount)
627             elif input_token == SFRXETH_ADDRESS:
628                 amount = sfrxETH(swap).convertToShares(amount)
629             elif output_token == SFRXETH_ADDRESS:
630                 amount = sfrxETH(swap).convertToAssets(amount)
631             elif output_token == WBETH_ADDRESS:
632                 amount = amount * wBETH(swap).exchangeRate() / 10**18
633             else:
634                 raise "Swap type 8 is only for ETH <-> WETH, ETH -> stETH or ETH -> frxETH, stETH <-> wstETH, frxETH <-> sfrxETH, ETH -> wBETH"
635         elif params[2] == 9:
636             snx_exchanger: address = SynthetixAddressResolver(SNX_ADDRESS_RESOLVER).getAddress(SNX_EXCHANGER_NAME)
637             atomic_amount_and_fee: AtomicAmountAndFee = SynthetixExchanger(snx_exchanger).getAmountsForAtomicExchange(
638                 10**18, self.snx_currency_keys[input_token], self.snx_currency_keys[output_token]
639             )
640             amount = amount * 10**18 / atomic_amount_and_fee.amountReceived
641         else:
642             raise "Bad swap type"
643 
644     return amount