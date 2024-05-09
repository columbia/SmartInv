1 # @version 0.2.12
2 """
3 @title "Zap" Depositer for metapool
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 @notice deposit/withdraw to Curve pool without too many transactions
7 """
8 
9 from vyper.interfaces import ERC20
10 
11 
12 interface CurveMeta:
13     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256: nonpayable
14     def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]: nonpayable
15     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256) -> uint256: nonpayable
16     def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256: nonpayable
17     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
18     def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256: view
19     def base_pool() -> address: view
20     def coins(i: uint256) -> address: view
21 
22 interface CurveBase:
23     def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable
24     def remove_liquidity(_amount: uint256, min_amounts: uint256[BASE_N_COINS]): nonpayable
25     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256): nonpayable
26     def remove_liquidity_imbalance(amounts: uint256[BASE_N_COINS], max_burn_amount: uint256): nonpayable
27     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
28     def calc_token_amount(amounts: uint256[BASE_N_COINS], deposit: bool) -> uint256: view
29     def coins(i: uint256) -> address: view
30     def fee() -> uint256: view
31 
32 
33 N_COINS: constant(int128) = 2
34 MAX_COIN: constant(int128) = N_COINS-1
35 BASE_N_COINS: constant(int128) = 3
36 N_ALL_COINS: constant(int128) = N_COINS + BASE_N_COINS - 1
37 
38 # An asset which may have a transfer fee (USDT)
39 FEE_ASSET: constant(address) = 0xdAC17F958D2ee523a2206206994597C13D831ec7
40 
41 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
42 FEE_IMPRECISION: constant(uint256) = 100 * 10 ** 8  # % of the fee
43 
44 
45 pool: public(address)
46 token: public(address)
47 base_pool: public(address)
48 
49 coins: public(address[N_COINS])
50 base_coins: public(address[BASE_N_COINS])
51 
52 
53 @external
54 def __init__(_pool: address, _token: address):
55     """
56     @notice Contract constructor
57     @param _pool Metapool address
58     @param _token Pool LP token address
59     """
60     self.pool = _pool
61     self.token = _token
62     base_pool: address = CurveMeta(_pool).base_pool()
63     self.base_pool = base_pool
64 
65     for i in range(N_COINS):
66         coin: address = CurveMeta(_pool).coins(i)
67         self.coins[i] = coin
68         # approve coins for infinite transfers
69         _response: Bytes[32] = raw_call(
70             coin,
71             concat(
72                 method_id("approve(address,uint256)"),
73                 convert(_pool, bytes32),
74                 convert(MAX_UINT256, bytes32),
75             ),
76             max_outsize=32,
77         )
78         if len(_response) > 0:
79             assert convert(_response, bool)
80 
81     for i in range(BASE_N_COINS):
82         coin: address = CurveBase(base_pool).coins(i)
83         self.base_coins[i] = coin
84         # approve underlying coins for infinite transfers
85         _response: Bytes[32] = raw_call(
86             coin,
87             concat(
88                 method_id("approve(address,uint256)"),
89                 convert(base_pool, bytes32),
90                 convert(MAX_UINT256, bytes32),
91             ),
92             max_outsize=32,
93         )
94         if len(_response) > 0:
95             assert convert(_response, bool)
96 
97 
98 @external
99 def add_liquidity(_amounts: uint256[N_ALL_COINS], _min_mint_amount: uint256) -> uint256:
100     """
101     @notice Wrap underlying coins and deposit them in the pool
102     @param _amounts List of amounts of underlying coins to deposit
103     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
104     @return Amount of LP tokens received by depositing
105     """
106     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
107     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
108     deposit_base: bool = False
109 
110     # Transfer all coins in
111     for i in range(N_ALL_COINS):
112         amount: uint256 = _amounts[i]
113         if amount == 0:
114             continue
115         coin: address = ZERO_ADDRESS
116         if i < MAX_COIN:
117             coin = self.coins[i]
118             meta_amounts[i] = amount
119         else:
120             x: int128 = i - MAX_COIN
121             coin = self.base_coins[x]
122             base_amounts[x] = amount
123             deposit_base = True
124         # "safeTransferFrom" which works for ERC20s which return bool or not
125         _response: Bytes[32] = raw_call(
126             coin,
127             concat(
128                 method_id("transferFrom(address,address,uint256)"),
129                 convert(msg.sender, bytes32),
130                 convert(self, bytes32),
131                 convert(amount, bytes32),
132             ),
133             max_outsize=32,
134         )  # dev: failed transfer
135         if len(_response) > 0:
136             assert convert(_response, bool)  # dev: failed transfer
137         # end "safeTransferFrom"
138         # Handle potential Tether fees
139         if coin == FEE_ASSET:
140             amount = ERC20(FEE_ASSET).balanceOf(self)
141             if i < MAX_COIN:
142                 meta_amounts[i] = amount
143             else:
144                 base_amounts[i - MAX_COIN] = amount
145 
146     # Deposit to the base pool
147     if deposit_base:
148         CurveBase(self.base_pool).add_liquidity(base_amounts, 0)
149         meta_amounts[MAX_COIN] = ERC20(self.coins[MAX_COIN]).balanceOf(self)
150 
151     # Deposit to the meta pool
152     CurveMeta(self.pool).add_liquidity(meta_amounts, _min_mint_amount)
153 
154     # Transfer meta token back
155     lp_token: address = self.token
156     lp_amount: uint256 = ERC20(lp_token).balanceOf(self)
157     assert ERC20(lp_token).transfer(msg.sender, lp_amount)
158 
159     return lp_amount
160 
161 
162 @external
163 def remove_liquidity(_amount: uint256, _min_amounts: uint256[N_ALL_COINS]) -> uint256[N_ALL_COINS]:
164     """
165     @notice Withdraw and unwrap coins from the pool
166     @dev Withdrawal amounts are based on current deposit ratios
167     @param _amount Quantity of LP tokens to burn in the withdrawal
168     @param _min_amounts Minimum amounts of underlying coins to receive
169     @return List of amounts of underlying coins that were withdrawn
170     """
171     _token: address = self.token
172     assert ERC20(_token).transferFrom(msg.sender, self, _amount)
173 
174     min_amounts_meta: uint256[N_COINS] = empty(uint256[N_COINS])
175     min_amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
176     amounts: uint256[N_ALL_COINS] = empty(uint256[N_ALL_COINS])
177 
178     # Withdraw from meta
179     for i in range(MAX_COIN):
180         min_amounts_meta[i] = _min_amounts[i]
181     CurveMeta(self.pool).remove_liquidity(_amount, min_amounts_meta)
182 
183     # Withdraw from base
184     _base_amount: uint256 = ERC20(self.coins[MAX_COIN]).balanceOf(self)
185     for i in range(BASE_N_COINS):
186         min_amounts_base[i] = _min_amounts[MAX_COIN+i]
187     CurveBase(self.base_pool).remove_liquidity(_base_amount, min_amounts_base)
188 
189     # Transfer all coins out
190     for i in range(N_ALL_COINS):
191         coin: address = ZERO_ADDRESS
192         if i < MAX_COIN:
193             coin = self.coins[i]
194         else:
195             coin = self.base_coins[i - MAX_COIN]
196         amounts[i] = ERC20(coin).balanceOf(self)
197         # "safeTransfer" which works for ERC20s which return bool or not
198         _response: Bytes[32] = raw_call(
199             coin,
200             concat(
201                 method_id("transfer(address,uint256)"),
202                 convert(msg.sender, bytes32),
203                 convert(amounts[i], bytes32),
204             ),
205             max_outsize=32,
206         )  # dev: failed transfer
207         if len(_response) > 0:
208             assert convert(_response, bool)  # dev: failed transfer
209         # end "safeTransfer"
210 
211     return amounts
212 
213 
214 @external
215 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
216     """
217     @notice Withdraw and unwrap a single coin from the pool
218     @param _token_amount Amount of LP tokens to burn in the withdrawal
219     @param i Index value of the coin to withdraw
220     @param _min_amount Minimum amount of underlying coin to receive
221     @return Amount of underlying coin received
222     """
223     assert ERC20(self.token).transferFrom(msg.sender, self, _token_amount)
224 
225     coin: address = ZERO_ADDRESS
226     if i < MAX_COIN:
227         coin = self.coins[i]
228         # Withdraw a metapool coin
229         CurveMeta(self.pool).remove_liquidity_one_coin(_token_amount, i, _min_amount)
230     else:
231         coin = self.base_coins[i - MAX_COIN]
232         # Withdraw a base pool coin
233         CurveMeta(self.pool).remove_liquidity_one_coin(_token_amount, MAX_COIN, 0)
234         CurveBase(self.base_pool).remove_liquidity_one_coin(
235             ERC20(self.coins[MAX_COIN]).balanceOf(self), i-MAX_COIN, _min_amount
236         )
237 
238     # Tranfer the coin out
239     coin_amount: uint256 = ERC20(coin).balanceOf(self)
240     # "safeTransfer" which works for ERC20s which return bool or not
241     _response: Bytes[32] = raw_call(
242         coin,
243         concat(
244             method_id("transfer(address,uint256)"),
245             convert(msg.sender, bytes32),
246             convert(coin_amount, bytes32),
247         ),
248         max_outsize=32,
249     )  # dev: failed transfer
250     if len(_response) > 0:
251         assert convert(_response, bool)  # dev: failed transfer
252     # end "safeTransfer"
253 
254     return coin_amount
255 
256 
257 @external
258 def remove_liquidity_imbalance(_amounts: uint256[N_ALL_COINS], _max_burn_amount: uint256) -> uint256:
259     """
260     @notice Withdraw coins from the pool in an imbalanced amount
261     @param _amounts List of amounts of underlying coins to withdraw
262     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
263     @return Actual amount of the LP token burned in the withdrawal
264     """
265     base_pool: address = self.base_pool
266     meta_pool: address = self.pool
267     base_coins: address[BASE_N_COINS] = self.base_coins
268     meta_coins: address[N_COINS] = self.coins
269     lp_token: address = self.token
270 
271     fee: uint256 = CurveBase(base_pool).fee() * BASE_N_COINS / (4 * (BASE_N_COINS - 1))
272     fee += fee * FEE_IMPRECISION / FEE_DENOMINATOR  # Overcharge to account for imprecision
273 
274     # Transfer the LP token in
275     assert ERC20(lp_token).transferFrom(msg.sender, self, _max_burn_amount)
276 
277     withdraw_base: bool = False
278     amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
279     amounts_meta: uint256[N_COINS] = empty(uint256[N_COINS])
280     leftover_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
281 
282     # Prepare quantities
283     for i in range(MAX_COIN):
284         amounts_meta[i] = _amounts[i]
285 
286     for i in range(BASE_N_COINS):
287         amount: uint256 = _amounts[MAX_COIN + i]
288         if amount != 0:
289             amounts_base[i] = amount
290             withdraw_base = True
291 
292     if withdraw_base:
293         amounts_meta[MAX_COIN] = CurveBase(self.base_pool).calc_token_amount(amounts_base, False)
294         amounts_meta[MAX_COIN] += amounts_meta[MAX_COIN] * fee / FEE_DENOMINATOR + 1
295 
296     # Remove liquidity and deposit leftovers back
297     CurveMeta(meta_pool).remove_liquidity_imbalance(amounts_meta, _max_burn_amount)
298     if withdraw_base:
299         CurveBase(base_pool).remove_liquidity_imbalance(amounts_base, amounts_meta[MAX_COIN])
300         leftover_amounts[MAX_COIN] = ERC20(meta_coins[MAX_COIN]).balanceOf(self)
301         if leftover_amounts[MAX_COIN] > 0:
302             CurveMeta(meta_pool).add_liquidity(leftover_amounts, 0)
303 
304     # Transfer all coins out
305     for i in range(N_ALL_COINS):
306         coin: address = ZERO_ADDRESS
307         amount: uint256 = 0
308         if i < MAX_COIN:
309             coin = meta_coins[i]
310             amount = amounts_meta[i]
311         else:
312             coin = base_coins[i - MAX_COIN]
313             amount = amounts_base[i - MAX_COIN]
314         # "safeTransfer" which works for ERC20s which return bool or not
315         if amount > 0:
316             _response: Bytes[32] = raw_call(
317                 coin,
318                 concat(
319                     method_id("transfer(address,uint256)"),
320                     convert(msg.sender, bytes32),
321                     convert(amount, bytes32),
322                 ),
323                 max_outsize=32,
324             )  # dev: failed transfer
325             if len(_response) > 0:
326                 assert convert(_response, bool)  # dev: failed transfer
327             # end "safeTransfer"
328 
329     # Transfer the leftover LP token out
330     leftover: uint256 = ERC20(lp_token).balanceOf(self)
331     if leftover > 0:
332         assert ERC20(lp_token).transfer(msg.sender, leftover)
333 
334     return _max_burn_amount - leftover
335 
336 
337 @view
338 @external
339 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
340     """
341     @notice Calculate the amount received when withdrawing and unwrapping a single coin
342     @param _token_amount Amount of LP tokens to burn in the withdrawal
343     @param i Index value of the underlying coin to withdraw
344     @return Amount of coin received
345     """
346     if i < MAX_COIN:
347         return CurveMeta(self.pool).calc_withdraw_one_coin(_token_amount, i)
348     else:
349         base_tokens: uint256 = CurveMeta(self.pool).calc_withdraw_one_coin(_token_amount, MAX_COIN)
350         return CurveBase(self.base_pool).calc_withdraw_one_coin(base_tokens, i-MAX_COIN)
351 
352 
353 @view
354 @external
355 def calc_token_amount(_amounts: uint256[N_ALL_COINS], _is_deposit: bool) -> uint256:
356     """
357     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
358     @dev This calculation accounts for slippage, but not fees.
359          Needed to prevent front-running, not for precise calculations!
360     @param _amounts Amount of each underlying coin being deposited
361     @param _is_deposit set True for deposits, False for withdrawals
362     @return Expected amount of LP tokens received
363     """
364     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
365     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
366 
367     for i in range(MAX_COIN):
368         meta_amounts[i] = _amounts[i]
369 
370     for i in range(BASE_N_COINS):
371         base_amounts[i] = _amounts[i + MAX_COIN]
372 
373     base_tokens: uint256 = CurveBase(self.base_pool).calc_token_amount(base_amounts, _is_deposit)
374     meta_amounts[MAX_COIN] = base_tokens
375 
376     return CurveMeta(self.pool).calc_token_amount(meta_amounts, _is_deposit)