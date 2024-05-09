1 # @version 0.2.16
2 """
3 @title "Zap" Depositer for permissionless factory metapools
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2021 - all rights reserved
6 """
7 
8 interface ERC20:
9     def approve(_spender: address, _amount: uint256): nonpayable
10     def balanceOf(_owner: address) -> uint256: view
11 
12 interface CurveMeta:
13     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256, _receiver: address) -> uint256: nonpayable
14     def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]): nonpayable
15     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256, _receiver: address) -> uint256: nonpayable
16     def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256: nonpayable
17     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
18     def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256: view
19     def coins(i: uint256) -> address: view
20 
21 interface CurveBase:
22     def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable
23     def remove_liquidity(_amount: uint256, min_amounts: uint256[BASE_N_COINS]): nonpayable
24     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256): nonpayable
25     def remove_liquidity_imbalance(amounts: uint256[BASE_N_COINS], max_burn_amount: uint256): nonpayable
26     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
27     def calc_token_amount(amounts: uint256[BASE_N_COINS], deposit: bool) -> uint256: view
28     def coins(i: uint256) -> address: view
29     def fee() -> uint256: view
30 
31 
32 BASE_N_COINS: constant(int128) = 2
33 BASE_POOL: constant(address) = 0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2
34 BASE_LP_TOKEN: constant(address) = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC
35 BASE_COINS: constant(address[BASE_N_COINS]) = [
36      0x853d955aCEf822Db058eb8505911ED77F175b99e,
37      0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
38 ]
39 
40 N_COINS: constant(int128) = 2
41 MAX_COIN: constant(int128) = N_COINS-1
42 N_ALL_COINS: constant(int128) = N_COINS + BASE_N_COINS - 1
43 
44 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
45 FEE_IMPRECISION: constant(uint256) = 100 * 10 ** 8  # % of the fee
46 
47 
48 # coin -> pool -> is approved to transfer?
49 is_approved: HashMap[address, HashMap[address, bool]]
50 
51 
52 @external
53 def __init__():
54     """
55     @notice Contract constructor
56     """
57     for coin in BASE_COINS:
58         ERC20(coin).approve(BASE_POOL, MAX_UINT256)
59 
60 
61 @external
62 def add_liquidity(
63     _pool: address,
64     _deposit_amounts: uint256[N_ALL_COINS],
65     _min_mint_amount: uint256,
66     _receiver: address = msg.sender,
67 ) -> uint256:
68     """
69     @notice Wrap underlying coins and deposit them into `_pool`
70     @param _pool Address of the pool to deposit into
71     @param _deposit_amounts List of amounts of underlying coins to deposit
72     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
73     @param _receiver Address that receives the LP tokens
74     @return Amount of LP tokens received by depositing
75     """
76     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
77     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
78     deposit_base: bool = False
79     base_coins: address[BASE_N_COINS] = BASE_COINS
80 
81     if _deposit_amounts[0] != 0:
82         coin: address = CurveMeta(_pool).coins(0)
83         if not self.is_approved[coin][_pool]:
84             ERC20(coin).approve(_pool, MAX_UINT256)
85             self.is_approved[coin][_pool] = True
86         response: Bytes[32] = raw_call(
87             coin,
88             _abi_encode(
89                 msg.sender,
90                 self,
91                 _deposit_amounts[0],
92                 method_id=method_id("transferFrom(address,address,uint256)"),
93             ),
94             max_outsize=32
95         )
96         if len(response) != 0:
97             assert convert(response, bool)
98         # hand fee on transfer
99         meta_amounts[0] = ERC20(coin).balanceOf(self)
100 
101     for i in range(1, N_ALL_COINS):
102         amount: uint256 = _deposit_amounts[i]
103         if amount == 0:
104             continue
105         deposit_base = True
106         base_idx: uint256 = i - 1
107         coin: address = base_coins[base_idx]
108 
109         response: Bytes[32] = raw_call(
110             coin,
111             _abi_encode(
112                 msg.sender,
113                 self,
114                 amount,
115                 method_id=method_id("transferFrom(address,address,uint256)"),
116             ),
117             max_outsize=32
118         )
119         if len(response) != 0:
120             assert convert(response, bool)
121 
122         # Handle potential transfer fees (i.e. Tether/renBTC)
123         base_amounts[base_idx] = ERC20(coin).balanceOf(self)
124 
125     # Deposit to the base pool
126     if deposit_base:
127         coin: address = BASE_LP_TOKEN
128         CurveBase(BASE_POOL).add_liquidity(base_amounts, 0)
129         meta_amounts[MAX_COIN] = ERC20(coin).balanceOf(self)
130         if not self.is_approved[coin][_pool]:
131             ERC20(coin).approve(_pool, MAX_UINT256)
132             self.is_approved[coin][_pool] = True
133 
134     # Deposit to the meta pool
135     return CurveMeta(_pool).add_liquidity(meta_amounts, _min_mint_amount, _receiver)
136 
137 
138 @external
139 def remove_liquidity(
140     _pool: address,
141     _burn_amount: uint256,
142     _min_amounts: uint256[N_ALL_COINS],
143     _receiver: address = msg.sender
144 ) -> uint256[N_ALL_COINS]:
145     """
146     @notice Withdraw and unwrap coins from the pool
147     @dev Withdrawal amounts are based on current deposit ratios
148     @param _pool Address of the pool to deposit into
149     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
150     @param _min_amounts Minimum amounts of underlying coins to receive
151     @param _receiver Address that receives the LP tokens
152     @return List of amounts of underlying coins that were withdrawn
153     """
154     response: Bytes[32] = raw_call(
155         _pool,
156         _abi_encode(
157             msg.sender,
158             self,
159             _burn_amount,
160             method_id=method_id("transferFrom(address,address,uint256)"),
161         ),
162         max_outsize=32
163     )
164     if len(response) != 0:
165         assert convert(response, bool)
166 
167     min_amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
168     amounts: uint256[N_ALL_COINS] = empty(uint256[N_ALL_COINS])
169 
170     # Withdraw from meta
171     meta_received: uint256[N_COINS] = empty(uint256[N_COINS])
172     CurveMeta(_pool).remove_liquidity(_burn_amount, [_min_amounts[0], convert(0, uint256)])
173 
174     coins: address[N_COINS] = empty(address[N_COINS])
175     for i in range(N_COINS):
176         coin: address = CurveMeta(_pool).coins(i)
177         coins[i] = coin
178         # Handle fee on transfer for the first coin
179         meta_received[i] = ERC20(coin).balanceOf(self)
180 
181     # Withdraw from base
182     for i in range(BASE_N_COINS):
183         min_amounts_base[i] = _min_amounts[MAX_COIN+i]
184     CurveBase(BASE_POOL).remove_liquidity(meta_received[MAX_COIN], min_amounts_base)
185 
186     # Transfer all coins out
187     response = raw_call(
188         coins[0],  # metapool coin 0
189         _abi_encode(
190             _receiver,
191             meta_received[0],
192             method_id=method_id("transfer(address,uint256)"),
193         ),
194         max_outsize=32
195     )
196     if len(response) != 0:
197         assert convert(response, bool)
198 
199     amounts[0] = meta_received[0]
200 
201     base_coins: address[BASE_N_COINS] = BASE_COINS
202     for i in range(1, N_ALL_COINS):
203         coin: address = base_coins[i-1]
204         # handle potential fee on transfer
205         amounts[i] = ERC20(coin).balanceOf(self)
206         response = raw_call(
207             coin,
208             _abi_encode(
209                 _receiver,
210                 amounts[i],
211                 method_id=method_id("transfer(address,uint256)"),
212             ),
213             max_outsize=32
214         )
215         if len(response) != 0:
216             assert convert(response, bool)
217 
218 
219     return amounts
220 
221 
222 @external
223 def remove_liquidity_one_coin(
224     _pool: address,
225     _burn_amount: uint256,
226     i: int128,
227     _min_amount: uint256,
228     _receiver: address=msg.sender
229 ) -> uint256:
230     """
231     @notice Withdraw and unwrap a single coin from the pool
232     @param _pool Address of the pool to deposit into
233     @param _burn_amount Amount of LP tokens to burn in the withdrawal
234     @param i Index value of the coin to withdraw
235     @param _min_amount Minimum amount of underlying coin to receive
236     @param _receiver Address that receives the LP tokens
237     @return Amount of underlying coin received
238     """
239     response: Bytes[32] = raw_call(
240         _pool,
241         _abi_encode(
242             msg.sender,
243             self,
244             _burn_amount,
245             method_id=method_id("transferFrom(address,address,uint256)"),
246         ),
247         max_outsize=32
248     )
249     if len(response) != 0:
250         assert convert(response, bool)
251 
252 
253     coin_amount: uint256 = 0
254     if i == 0:
255         coin_amount = CurveMeta(_pool).remove_liquidity_one_coin(_burn_amount, i, _min_amount, _receiver)
256     else:
257         base_coins: address[BASE_N_COINS] = BASE_COINS
258         coin: address = base_coins[i - MAX_COIN]
259         # Withdraw a base pool coin
260         coin_amount = CurveMeta(_pool).remove_liquidity_one_coin(_burn_amount, MAX_COIN, 0, self)
261         CurveBase(BASE_POOL).remove_liquidity_one_coin(coin_amount, i-MAX_COIN, _min_amount)
262         coin_amount = ERC20(coin).balanceOf(self)
263         response = raw_call(
264             coin,
265             _abi_encode(
266                 _receiver,
267                 coin_amount,
268                 method_id=method_id("transfer(address,uint256)"),
269             ),
270             max_outsize=32
271         )
272         if len(response) != 0:
273             assert convert(response, bool)
274 
275 
276     return coin_amount
277 
278 
279 @external
280 def remove_liquidity_imbalance(
281     _pool: address,
282     _amounts: uint256[N_ALL_COINS],
283     _max_burn_amount: uint256,
284     _receiver: address=msg.sender
285 ) -> uint256:
286     """
287     @notice Withdraw coins from the pool in an imbalanced amount
288     @param _pool Address of the pool to deposit into
289     @param _amounts List of amounts of underlying coins to withdraw
290     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
291     @param _receiver Address that receives the LP tokens
292     @return Actual amount of the LP token burned in the withdrawal
293     """
294     fee: uint256 = CurveBase(BASE_POOL).fee() * BASE_N_COINS / (4 * (BASE_N_COINS - 1))
295     fee += fee * FEE_IMPRECISION / FEE_DENOMINATOR  # Overcharge to account for imprecision
296 
297     # Transfer the LP token in
298     response: Bytes[32] = raw_call(
299         _pool,
300         _abi_encode(
301             msg.sender,
302             self,
303             _max_burn_amount,
304             method_id=method_id("transferFrom(address,address,uint256)"),
305         ),
306         max_outsize=32
307     )
308     if len(response) != 0:
309         assert convert(response, bool)
310 
311     withdraw_base: bool = False
312     amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
313     amounts_meta: uint256[N_COINS] = empty(uint256[N_COINS])
314 
315     # determine amounts to withdraw from base pool
316     for i in range(BASE_N_COINS):
317         amount: uint256 = _amounts[MAX_COIN + i]
318         if amount != 0:
319             amounts_base[i] = amount
320             withdraw_base = True
321 
322     # determine amounts to withdraw from metapool
323     amounts_meta[0] = _amounts[0]
324     if withdraw_base:
325         amounts_meta[MAX_COIN] = CurveBase(BASE_POOL).calc_token_amount(amounts_base, False)
326         amounts_meta[MAX_COIN] += amounts_meta[MAX_COIN] * fee / FEE_DENOMINATOR + 1
327 
328     # withdraw from metapool and return the remaining LP tokens
329     burn_amount: uint256 = CurveMeta(_pool).remove_liquidity_imbalance(amounts_meta, _max_burn_amount)
330     response = raw_call(
331         _pool,
332         _abi_encode(
333             msg.sender,
334             _max_burn_amount - burn_amount,
335             method_id=method_id("transfer(address,uint256)"),
336         ),
337         max_outsize=32
338     )
339     if len(response) != 0:
340         assert convert(response, bool)
341 
342 
343     # withdraw from base pool
344     if withdraw_base:
345         CurveBase(BASE_POOL).remove_liquidity_imbalance(amounts_base, amounts_meta[MAX_COIN])
346         coin: address = BASE_LP_TOKEN
347         leftover: uint256 = ERC20(coin).balanceOf(self)
348 
349         if leftover > 0:
350             # if some base pool LP tokens remain, re-deposit them for the caller
351             if not self.is_approved[coin][_pool]:
352                 ERC20(coin).approve(_pool, MAX_UINT256)
353                 self.is_approved[coin][_pool] = True
354             burn_amount -= CurveMeta(_pool).add_liquidity([convert(0, uint256), leftover], 0, msg.sender)
355 
356         # transfer withdrawn base pool tokens to caller
357         base_coins: address[BASE_N_COINS] = BASE_COINS
358         for i in range(BASE_N_COINS):
359             response = raw_call(
360                 base_coins[i],
361                 _abi_encode(
362                     _receiver,
363                     ERC20(base_coins[i]).balanceOf(self),  # handle potential transfer fees
364                     method_id=method_id("transfer(address,uint256)"),
365                 ),
366                 max_outsize=32
367             )
368             if len(response) != 0:
369                 assert convert(response, bool)
370 
371 
372     # transfer withdrawn metapool tokens to caller
373     if _amounts[0] > 0:
374         coin: address = CurveMeta(_pool).coins(0)
375         response = raw_call(
376             coin,
377             _abi_encode(
378                 _receiver,
379                 ERC20(coin).balanceOf(self),  # handle potential fees
380                 method_id=method_id("transfer(address,uint256)"),
381             ),
382             max_outsize=32
383         )
384         if len(response) != 0:
385             assert convert(response, bool)
386 
387 
388     return burn_amount
389 
390 
391 @view
392 @external
393 def calc_withdraw_one_coin(_pool: address, _token_amount: uint256, i: int128) -> uint256:
394     """
395     @notice Calculate the amount received when withdrawing and unwrapping a single coin
396     @param _pool Address of the pool to deposit into
397     @param _token_amount Amount of LP tokens to burn in the withdrawal
398     @param i Index value of the underlying coin to withdraw
399     @return Amount of coin received
400     """
401     if i < MAX_COIN:
402         return CurveMeta(_pool).calc_withdraw_one_coin(_token_amount, i)
403     else:
404         _base_tokens: uint256 = CurveMeta(_pool).calc_withdraw_one_coin(_token_amount, MAX_COIN)
405         return CurveBase(BASE_POOL).calc_withdraw_one_coin(_base_tokens, i-MAX_COIN)
406 
407 
408 @view
409 @external
410 def calc_token_amount(_pool: address, _amounts: uint256[N_ALL_COINS], _is_deposit: bool) -> uint256:
411     """
412     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
413     @dev This calculation accounts for slippage, but not fees.
414          Needed to prevent front-running, not for precise calculations!
415     @param _pool Address of the pool to deposit into
416     @param _amounts Amount of each underlying coin being deposited
417     @param _is_deposit set True for deposits, False for withdrawals
418     @return Expected amount of LP tokens received
419     """
420     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
421     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
422 
423     meta_amounts[0] = _amounts[0]
424     for i in range(BASE_N_COINS):
425         base_amounts[i] = _amounts[i + MAX_COIN]
426 
427     base_tokens: uint256 = CurveBase(BASE_POOL).calc_token_amount(base_amounts, _is_deposit)
428     meta_amounts[MAX_COIN] = base_tokens
429 
430     return CurveMeta(_pool).calc_token_amount(meta_amounts, _is_deposit)