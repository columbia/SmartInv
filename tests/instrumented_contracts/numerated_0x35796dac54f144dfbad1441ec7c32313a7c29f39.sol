1 # @version 0.2.5
2 """
3 @title "Zap" Depositer for Curve GUSD pool
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2020 - all rights reserved
6 """
7 
8 from vyper.interfaces import ERC20
9 
10 
11 interface CurveMeta:
12     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256: nonpayable
13     def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]: nonpayable
14     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256) -> uint256: nonpayable
15     def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256: nonpayable
16     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
17     def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256: view
18     def base_pool() -> address: view
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
32 N_COINS: constant(int128) = 2
33 MAX_COIN: constant(int128) = N_COINS-1
34 BASE_N_COINS: constant(int128) = 3
35 N_ALL_COINS: constant(int128) = N_COINS + BASE_N_COINS - 1
36 
37 # An asset shich may have a transfer fee (USDT)
38 FEE_ASSET: constant(address) = 0xdAC17F958D2ee523a2206206994597C13D831ec7
39 
40 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
41 FEE_IMPRECISION: constant(uint256) = 25 * 10 ** 8  # % of the fee
42 
43 
44 pool: public(address)
45 token: public(address)
46 base_pool: public(address)
47 
48 coins: public(address[N_COINS])
49 base_coins: public(address[BASE_N_COINS])
50 
51 
52 @external
53 def __init__(_pool: address, _token: address):
54     """
55     @notice Contract constructor
56     @param _pool Metapool address
57     @param _token Pool LP token address
58     """
59     self.pool = _pool
60     self.token = _token
61     _base_pool: address = CurveMeta(_pool).base_pool()
62     self.base_pool = _base_pool
63 
64     for i in range(N_COINS):
65         coin: address = CurveMeta(_pool).coins(convert(i, uint256))
66         self.coins[i] = coin
67         # approve coins for infinite transfers
68         _response: Bytes[32] = raw_call(
69             coin,
70             concat(
71                 method_id("approve(address,uint256)"),
72                 convert(_pool, bytes32),
73                 convert(MAX_UINT256, bytes32),
74             ),
75             max_outsize=32,
76         )
77         if len(_response) > 0:
78             assert convert(_response, bool)
79 
80     for i in range(BASE_N_COINS):
81         coin: address = CurveBase(_base_pool).coins(convert(i, uint256))
82         self.base_coins[i] = coin
83         # approve underlying coins for infinite transfers
84         _response: Bytes[32] = raw_call(
85             coin,
86             concat(
87                 method_id("approve(address,uint256)"),
88                 convert(_base_pool, bytes32),
89                 convert(MAX_UINT256, bytes32),
90             ),
91             max_outsize=32,
92         )
93         if len(_response) > 0:
94             assert convert(_response, bool)
95 
96 
97 @external
98 def add_liquidity(amounts: uint256[N_ALL_COINS], min_mint_amount: uint256) -> uint256:
99     """
100     @notice Wrap underlying coins and deposit them in the pool
101     @param amounts List of amounts of underlying coins to deposit
102     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
103     @return Amount of LP tokens received by depositing
104     """
105     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
106     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
107     deposit_base: bool = False
108 
109     # Transfer all coins in
110     for i in range(N_ALL_COINS):
111         amount: uint256 = amounts[i]
112         if amount == 0:
113             continue
114         coin: address = ZERO_ADDRESS
115         if i < MAX_COIN:
116             coin = self.coins[i]
117             meta_amounts[i] = amount
118         else:
119             x: int128 = i - MAX_COIN
120             coin = self.base_coins[x]
121             base_amounts[x] = amount
122             deposit_base = True
123         # "safeTransferFrom" which works for ERC20s which return bool or not
124         _response: Bytes[32] = raw_call(
125             coin,
126             concat(
127                 method_id("transferFrom(address,address,uint256)"),
128                 convert(msg.sender, bytes32),
129                 convert(self, bytes32),
130                 convert(amount, bytes32),
131             ),
132             max_outsize=32,
133         )  # dev: failed transfer
134         if len(_response) > 0:
135             assert convert(_response, bool)  # dev: failed transfer
136         # end "safeTransferFrom"
137         # Handle potential Tether fees
138         if coin == FEE_ASSET:
139             amount = ERC20(FEE_ASSET).balanceOf(self)
140             if i < MAX_COIN:
141                 meta_amounts[i] = amount
142             else:
143                 base_amounts[i - MAX_COIN] = amount
144 
145     # Deposit to the base pool
146     if deposit_base:
147         CurveBase(self.base_pool).add_liquidity(base_amounts, 0)
148         meta_amounts[MAX_COIN] = ERC20(self.coins[MAX_COIN]).balanceOf(self)
149 
150     # Deposit to the meta pool
151     CurveMeta(self.pool).add_liquidity(meta_amounts, min_mint_amount)
152 
153     # Transfer meta token back
154     _lp_token: address = self.token
155     _lp_amount: uint256 = ERC20(_lp_token).balanceOf(self)
156     assert ERC20(_lp_token).transfer(msg.sender, _lp_amount)
157 
158     return _lp_amount
159 
160 
161 @external
162 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_ALL_COINS]) -> uint256[N_ALL_COINS]:
163     """
164     @notice Withdraw and unwrap coins from the pool
165     @dev Withdrawal amounts are based on current deposit ratios
166     @param _amount Quantity of LP tokens to burn in the withdrawal
167     @param min_amounts Minimum amounts of underlying coins to receive
168     @return List of amounts of underlying coins that were withdrawn
169     """
170     _token: address = self.token
171     assert ERC20(_token).transferFrom(msg.sender, self, _amount)
172 
173     min_amounts_meta: uint256[N_COINS] = empty(uint256[N_COINS])
174     min_amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
175     amounts: uint256[N_ALL_COINS] = empty(uint256[N_ALL_COINS])
176 
177     # Withdraw from meta
178     for i in range(MAX_COIN):
179         min_amounts_meta[i] = min_amounts[i]
180     CurveMeta(self.pool).remove_liquidity(_amount, min_amounts_meta)
181 
182     # Withdraw from base
183     _base_amount: uint256 = ERC20(self.coins[MAX_COIN]).balanceOf(self)
184     for i in range(BASE_N_COINS):
185         min_amounts_base[i] = min_amounts[MAX_COIN+i]
186     CurveBase(self.base_pool).remove_liquidity(_base_amount, min_amounts_base)
187 
188     # Transfer all coins out
189     for i in range(N_ALL_COINS):
190         coin: address = ZERO_ADDRESS
191         if i < MAX_COIN:
192             coin = self.coins[i]
193         else:
194             coin = self.base_coins[i - MAX_COIN]
195         amounts[i] = ERC20(coin).balanceOf(self)
196         # "safeTransfer" which works for ERC20s which return bool or not
197         _response: Bytes[32] = raw_call(
198             coin,
199             concat(
200                 method_id("transfer(address,uint256)"),
201                 convert(msg.sender, bytes32),
202                 convert(amounts[i], bytes32),
203             ),
204             max_outsize=32,
205         )  # dev: failed transfer
206         if len(_response) > 0:
207             assert convert(_response, bool)  # dev: failed transfer
208         # end "safeTransfer"
209 
210     return amounts
211 
212 
213 @external
214 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
215     """
216     @notice Withdraw and unwrap a single coin from the pool
217     @param _token_amount Amount of LP tokens to burn in the withdrawal
218     @param i Index value of the coin to withdraw
219     @param _min_amount Minimum amount of underlying coin to receive
220     @return Amount of underlying coin received
221     """
222     assert ERC20(self.token).transferFrom(msg.sender, self, _token_amount)
223 
224     coin: address = ZERO_ADDRESS
225     if i < MAX_COIN:
226         coin = self.coins[i]
227         # Withdraw a metapool coin
228         CurveMeta(self.pool).remove_liquidity_one_coin(_token_amount, i, _min_amount)
229     else:
230         coin = self.base_coins[i - MAX_COIN]
231         # Withdraw a base pool coin
232         CurveMeta(self.pool).remove_liquidity_one_coin(_token_amount, MAX_COIN, 0)
233         CurveBase(self.base_pool).remove_liquidity_one_coin(
234             ERC20(self.coins[MAX_COIN]).balanceOf(self), i-MAX_COIN, _min_amount
235         )
236 
237     # Tranfer the coin out
238     coin_amount: uint256 = ERC20(coin).balanceOf(self)
239     # "safeTransfer" which works for ERC20s which return bool or not
240     _response: Bytes[32] = raw_call(
241         coin,
242         concat(
243             method_id("transfer(address,uint256)"),
244             convert(msg.sender, bytes32),
245             convert(coin_amount, bytes32),
246         ),
247         max_outsize=32,
248     )  # dev: failed transfer
249     if len(_response) > 0:
250         assert convert(_response, bool)  # dev: failed transfer
251     # end "safeTransfer"
252 
253     return coin_amount
254 
255 
256 @external
257 def remove_liquidity_imbalance(amounts: uint256[N_ALL_COINS], max_burn_amount: uint256) -> uint256:
258     """
259     @notice Withdraw coins from the pool in an imbalanced amount
260     @param amounts List of amounts of underlying coins to withdraw
261     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal
262     @return Actual amount of the LP token burned in the withdrawal
263     """
264     _base_pool: address = self.base_pool
265     _meta_pool: address = self.pool
266     _base_coins: address[BASE_N_COINS] = self.base_coins
267     _meta_coins: address[N_COINS] = self.coins
268     _lp_token: address = self.token
269 
270     fee: uint256 = CurveBase(_base_pool).fee() * BASE_N_COINS / (4 * (BASE_N_COINS - 1))
271     fee += fee * FEE_IMPRECISION / FEE_DENOMINATOR  # Overcharge to account for imprecision
272 
273     # Transfer the LP token in
274     assert ERC20(_lp_token).transferFrom(msg.sender, self, max_burn_amount)
275 
276     withdraw_base: bool = False
277     amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
278     amounts_meta: uint256[N_COINS] = empty(uint256[N_COINS])
279     leftover_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
280 
281     # Prepare quantities
282     for i in range(MAX_COIN):
283         amounts_meta[i] = amounts[i]
284 
285     for i in range(BASE_N_COINS):
286         amount: uint256 = amounts[MAX_COIN + i]
287         if amount != 0:
288             amounts_base[i] = amount
289             withdraw_base = True
290 
291     if withdraw_base:
292         amounts_meta[MAX_COIN] = CurveBase(self.base_pool).calc_token_amount(amounts_base, False)
293         amounts_meta[MAX_COIN] += amounts_meta[MAX_COIN] * fee / FEE_DENOMINATOR + 1
294 
295     # Remove liquidity and deposit leftovers back
296     CurveMeta(_meta_pool).remove_liquidity_imbalance(amounts_meta, max_burn_amount)
297     if withdraw_base:
298         CurveBase(_base_pool).remove_liquidity_imbalance(amounts_base, amounts_meta[MAX_COIN])
299         leftover_amounts[MAX_COIN] = ERC20(_meta_coins[MAX_COIN]).balanceOf(self)
300         if leftover_amounts[MAX_COIN] > 0:
301             CurveMeta(_meta_pool).add_liquidity(leftover_amounts, 0)
302 
303     # Transfer all coins out
304     for i in range(N_ALL_COINS):
305         coin: address = ZERO_ADDRESS
306         amount: uint256 = 0
307         if i < MAX_COIN:
308             coin = _meta_coins[i]
309             amount = amounts_meta[i]
310         else:
311             coin = _base_coins[i - MAX_COIN]
312             amount = amounts_base[i - MAX_COIN]
313         # "safeTransfer" which works for ERC20s which return bool or not
314         if amount > 0:
315             _response: Bytes[32] = raw_call(
316                 coin,
317                 concat(
318                     method_id("transfer(address,uint256)"),
319                     convert(msg.sender, bytes32),
320                     convert(amount, bytes32),
321                 ),
322                 max_outsize=32,
323             )  # dev: failed transfer
324             if len(_response) > 0:
325                 assert convert(_response, bool)  # dev: failed transfer
326             # end "safeTransfer"
327 
328     # Transfer the leftover LP token out
329     leftover: uint256 = ERC20(_lp_token).balanceOf(self)
330     if leftover > 0:
331         assert ERC20(_lp_token).transfer(msg.sender, leftover)
332 
333     return max_burn_amount - leftover
334 
335 
336 @view
337 @external
338 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
339     """
340     @notice Calculate the amount received when withdrawing and unwrapping a single coin
341     @param _token_amount Amount of LP tokens to burn in the withdrawal
342     @param i Index value of the underlying coin to withdraw
343     @return Amount of coin received
344     """
345     if i < MAX_COIN:
346         return CurveMeta(self.pool).calc_withdraw_one_coin(_token_amount, i)
347     else:
348         _base_tokens: uint256 = CurveMeta(self.pool).calc_withdraw_one_coin(_token_amount, MAX_COIN)
349         return CurveBase(self.base_pool).calc_withdraw_one_coin(_base_tokens, i-MAX_COIN)
350 
351 
352 @view
353 @external
354 def calc_token_amount(amounts: uint256[N_ALL_COINS], is_deposit: bool) -> uint256:
355     """
356     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
357     @dev This calculation accounts for slippage, but not fees.
358          Needed to prevent front-running, not for precise calculations!
359     @param amounts Amount of each underlying coin being deposited
360     @param is_deposit set True for deposits, False for withdrawals
361     @return Expected amount of LP tokens received
362     """
363     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
364     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
365 
366     for i in range(MAX_COIN):
367         meta_amounts[i] = amounts[i]
368 
369     for i in range(BASE_N_COINS):
370         base_amounts[i] = amounts[i + MAX_COIN]
371 
372     _base_tokens: uint256 = CurveBase(self.base_pool).calc_token_amount(base_amounts, is_deposit)
373     meta_amounts[MAX_COIN] = _base_tokens
374 
375     return CurveMeta(self.pool).calc_token_amount(meta_amounts, is_deposit)