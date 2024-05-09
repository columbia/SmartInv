1 # @version 0.2.7
2 """
3 @title "Zap" Depositer for Curve tBTC pool
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
28     def coins(i: int128) -> address: view
29     def fee() -> uint256: view
30 
31 
32 N_COINS: constant(int128) = 2
33 MAX_COIN: constant(int128) = N_COINS-1
34 BASE_N_COINS: constant(int128) = 3
35 N_ALL_COINS: constant(int128) = N_COINS + BASE_N_COINS - 1
36 
37 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
38 FEE_IMPRECISION: constant(uint256) = 100 * 10 ** 8  # % of the fee
39 
40 
41 pool: public(address)
42 token: public(address)
43 base_pool: public(address)
44 
45 coins: public(address[N_COINS])
46 base_coins: public(address[BASE_N_COINS])
47 
48 
49 @external
50 def __init__(_pool: address, _token: address):
51     """
52     @notice Contract constructor
53     @param _pool Metapool address
54     @param _token Pool LP token address
55     """
56     self.pool = _pool
57     self.token = _token
58     _base_pool: address = CurveMeta(_pool).base_pool()
59     self.base_pool = _base_pool
60 
61     for i in range(N_COINS):
62         coin: address = CurveMeta(_pool).coins(i)
63         self.coins[i] = coin
64         # approve coins for infinite transfers
65         _response: Bytes[32] = raw_call(
66             coin,
67             concat(
68                 method_id("approve(address,uint256)"),
69                 convert(_pool, bytes32),
70                 convert(MAX_UINT256, bytes32),
71             ),
72             max_outsize=32,
73         )
74         if len(_response) > 0:
75             assert convert(_response, bool)
76 
77     for i in range(BASE_N_COINS):
78         coin: address = CurveBase(_base_pool).coins(i)
79         self.base_coins[i] = coin
80         # approve underlying coins for infinite transfers
81         _response: Bytes[32] = raw_call(
82             coin,
83             concat(
84                 method_id("approve(address,uint256)"),
85                 convert(_base_pool, bytes32),
86                 convert(MAX_UINT256, bytes32),
87             ),
88             max_outsize=32,
89         )
90         if len(_response) > 0:
91             assert convert(_response, bool)
92 
93 
94 @external
95 def add_liquidity(amounts: uint256[N_ALL_COINS], min_mint_amount: uint256) -> uint256:
96     """
97     @notice Wrap underlying coins and deposit them in the pool
98     @param amounts List of amounts of underlying coins to deposit
99     @param min_mint_amount Minimum amount of LP tokens to mint from the deposit
100     @return Amount of LP tokens received by depositing
101     """
102     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
103     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
104     deposit_base: bool = False
105 
106     # Transfer all coins in
107     for i in range(N_ALL_COINS):
108         amount: uint256 = amounts[i]
109         if amount == 0:
110             continue
111         coin: address = ZERO_ADDRESS
112         if i < MAX_COIN:
113             coin = self.coins[i]
114             meta_amounts[i] = amount
115         else:
116             x: int128 = i - MAX_COIN
117             coin = self.base_coins[x]
118             base_amounts[x] = amount
119             deposit_base = True
120         # "safeTransferFrom" which works for ERC20s which return bool or not
121         _response: Bytes[32] = raw_call(
122             coin,
123             concat(
124                 method_id("transferFrom(address,address,uint256)"),
125                 convert(msg.sender, bytes32),
126                 convert(self, bytes32),
127                 convert(amount, bytes32),
128             ),
129             max_outsize=32,
130         )  # dev: failed transfer
131         if len(_response) > 0:
132             assert convert(_response, bool)  # dev: failed transfer
133         # end "safeTransferFrom"
134 
135     # Deposit to the base pool
136     if deposit_base:
137         CurveBase(self.base_pool).add_liquidity(base_amounts, 0)
138         meta_amounts[MAX_COIN] = ERC20(self.coins[MAX_COIN]).balanceOf(self)
139 
140     # Deposit to the meta pool
141     CurveMeta(self.pool).add_liquidity(meta_amounts, min_mint_amount)
142 
143     # Transfer meta token back
144     _lp_token: address = self.token
145     _lp_amount: uint256 = ERC20(_lp_token).balanceOf(self)
146     assert ERC20(_lp_token).transfer(msg.sender, _lp_amount)
147 
148     return _lp_amount
149 
150 
151 @external
152 def remove_liquidity(_amount: uint256, min_amounts: uint256[N_ALL_COINS]) -> uint256[N_ALL_COINS]:
153     """
154     @notice Withdraw and unwrap coins from the pool
155     @dev Withdrawal amounts are based on current deposit ratios
156     @param _amount Quantity of LP tokens to burn in the withdrawal
157     @param min_amounts Minimum amounts of underlying coins to receive
158     @return List of amounts of underlying coins that were withdrawn
159     """
160     _token: address = self.token
161     assert ERC20(_token).transferFrom(msg.sender, self, _amount)
162 
163     min_amounts_meta: uint256[N_COINS] = empty(uint256[N_COINS])
164     min_amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
165     amounts: uint256[N_ALL_COINS] = empty(uint256[N_ALL_COINS])
166 
167     # Withdraw from meta
168     for i in range(MAX_COIN):
169         min_amounts_meta[i] = min_amounts[i]
170     CurveMeta(self.pool).remove_liquidity(_amount, min_amounts_meta)
171 
172     # Withdraw from base
173     _base_amount: uint256 = ERC20(self.coins[MAX_COIN]).balanceOf(self)
174     for i in range(BASE_N_COINS):
175         min_amounts_base[i] = min_amounts[MAX_COIN+i]
176     CurveBase(self.base_pool).remove_liquidity(_base_amount, min_amounts_base)
177 
178     # Transfer all coins out
179     for i in range(N_ALL_COINS):
180         coin: address = ZERO_ADDRESS
181         if i < MAX_COIN:
182             coin = self.coins[i]
183         else:
184             coin = self.base_coins[i - MAX_COIN]
185         amounts[i] = ERC20(coin).balanceOf(self)
186         # "safeTransfer" which works for ERC20s which return bool or not
187         _response: Bytes[32] = raw_call(
188             coin,
189             concat(
190                 method_id("transfer(address,uint256)"),
191                 convert(msg.sender, bytes32),
192                 convert(amounts[i], bytes32),
193             ),
194             max_outsize=32,
195         )  # dev: failed transfer
196         if len(_response) > 0:
197             assert convert(_response, bool)  # dev: failed transfer
198         # end "safeTransfer"
199 
200     return amounts
201 
202 
203 @external
204 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, _min_amount: uint256) -> uint256:
205     """
206     @notice Withdraw and unwrap a single coin from the pool
207     @param _token_amount Amount of LP tokens to burn in the withdrawal
208     @param i Index value of the coin to withdraw
209     @param _min_amount Minimum amount of underlying coin to receive
210     @return Amount of underlying coin received
211     """
212     assert ERC20(self.token).transferFrom(msg.sender, self, _token_amount)
213 
214     coin: address = ZERO_ADDRESS
215     if i < MAX_COIN:
216         coin = self.coins[i]
217         # Withdraw a metapool coin
218         CurveMeta(self.pool).remove_liquidity_one_coin(_token_amount, i, _min_amount)
219     else:
220         coin = self.base_coins[i - MAX_COIN]
221         # Withdraw a base pool coin
222         CurveMeta(self.pool).remove_liquidity_one_coin(_token_amount, MAX_COIN, 0)
223         CurveBase(self.base_pool).remove_liquidity_one_coin(
224             ERC20(self.coins[MAX_COIN]).balanceOf(self), i-MAX_COIN, _min_amount
225         )
226 
227     # Tranfer the coin out
228     coin_amount: uint256 = ERC20(coin).balanceOf(self)
229     # "safeTransfer" which works for ERC20s which return bool or not
230     _response: Bytes[32] = raw_call(
231         coin,
232         concat(
233             method_id("transfer(address,uint256)"),
234             convert(msg.sender, bytes32),
235             convert(coin_amount, bytes32),
236         ),
237         max_outsize=32,
238     )  # dev: failed transfer
239     if len(_response) > 0:
240         assert convert(_response, bool)  # dev: failed transfer
241     # end "safeTransfer"
242 
243     return coin_amount
244 
245 
246 @external
247 def remove_liquidity_imbalance(amounts: uint256[N_ALL_COINS], max_burn_amount: uint256) -> uint256:
248     """
249     @notice Withdraw coins from the pool in an imbalanced amount
250     @param amounts List of amounts of underlying coins to withdraw
251     @param max_burn_amount Maximum amount of LP token to burn in the withdrawal.
252                            This value cannot exceed the caller's LP token balance.
253     @return Actual amount of the LP token burned in the withdrawal
254     """
255     _base_pool: address = self.base_pool
256     _meta_pool: address = self.pool
257     _base_coins: address[BASE_N_COINS] = self.base_coins
258     _meta_coins: address[N_COINS] = self.coins
259     _lp_token: address = self.token
260 
261     fee: uint256 = CurveBase(_base_pool).fee() * BASE_N_COINS / (4 * (BASE_N_COINS - 1))
262     fee += fee * FEE_IMPRECISION / FEE_DENOMINATOR  # Overcharge to account for imprecision
263 
264     # Transfer the LP token in
265     assert ERC20(_lp_token).transferFrom(msg.sender, self, max_burn_amount)
266 
267     withdraw_base: bool = False
268     amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
269     amounts_meta: uint256[N_COINS] = empty(uint256[N_COINS])
270     leftover_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
271 
272     # Prepare quantities
273     for i in range(MAX_COIN):
274         amounts_meta[i] = amounts[i]
275 
276     for i in range(BASE_N_COINS):
277         amount: uint256 = amounts[MAX_COIN + i]
278         if amount != 0:
279             amounts_base[i] = amount
280             withdraw_base = True
281 
282     if withdraw_base:
283         amounts_meta[MAX_COIN] = CurveBase(self.base_pool).calc_token_amount(amounts_base, False)
284         amounts_meta[MAX_COIN] += amounts_meta[MAX_COIN] * fee / FEE_DENOMINATOR + 1
285 
286     # Remove liquidity and deposit leftovers back
287     CurveMeta(_meta_pool).remove_liquidity_imbalance(amounts_meta, max_burn_amount)
288     if withdraw_base:
289         CurveBase(_base_pool).remove_liquidity_imbalance(amounts_base, amounts_meta[MAX_COIN])
290         leftover_amounts[MAX_COIN] = ERC20(_meta_coins[MAX_COIN]).balanceOf(self)
291         if leftover_amounts[MAX_COIN] > 0:
292             CurveMeta(_meta_pool).add_liquidity(leftover_amounts, 0)
293 
294     # Transfer all coins out
295     for i in range(N_ALL_COINS):
296         coin: address = ZERO_ADDRESS
297         amount: uint256 = 0
298         if i < MAX_COIN:
299             coin = _meta_coins[i]
300             amount = amounts_meta[i]
301         else:
302             coin = _base_coins[i - MAX_COIN]
303             amount = amounts_base[i - MAX_COIN]
304         # "safeTransfer" which works for ERC20s which return bool or not
305         if amount > 0:
306             _response: Bytes[32] = raw_call(
307                 coin,
308                 concat(
309                     method_id("transfer(address,uint256)"),
310                     convert(msg.sender, bytes32),
311                     convert(amount, bytes32),
312                 ),
313                 max_outsize=32,
314             )  # dev: failed transfer
315             if len(_response) > 0:
316                 assert convert(_response, bool)  # dev: failed transfer
317             # end "safeTransfer"
318 
319     # Transfer the leftover LP token out
320     leftover: uint256 = ERC20(_lp_token).balanceOf(self)
321     if leftover > 0:
322         assert ERC20(_lp_token).transfer(msg.sender, leftover)
323 
324     return max_burn_amount - leftover
325 
326 
327 @view
328 @external
329 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
330     """
331     @notice Calculate the amount received when withdrawing and unwrapping a single coin
332     @param _token_amount Amount of LP tokens to burn in the withdrawal
333     @param i Index value of the underlying coin to withdraw
334     @return Amount of coin received
335     """
336     if i < MAX_COIN:
337         return CurveMeta(self.pool).calc_withdraw_one_coin(_token_amount, i)
338     else:
339         _base_tokens: uint256 = CurveMeta(self.pool).calc_withdraw_one_coin(_token_amount, MAX_COIN)
340         return CurveBase(self.base_pool).calc_withdraw_one_coin(_base_tokens, i-MAX_COIN)
341 
342 
343 @view
344 @external
345 def calc_token_amount(amounts: uint256[N_ALL_COINS], is_deposit: bool) -> uint256:
346     """
347     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
348     @dev This calculation accounts for slippage, but not fees.
349          Needed to prevent front-running, not for precise calculations!
350     @param amounts Amount of each underlying coin being deposited
351     @param is_deposit set True for deposits, False for withdrawals
352     @return Expected amount of LP tokens received
353     """
354     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
355     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
356 
357     for i in range(MAX_COIN):
358         meta_amounts[i] = amounts[i]
359 
360     for i in range(BASE_N_COINS):
361         base_amounts[i] = amounts[i + MAX_COIN]
362 
363     _base_tokens: uint256 = CurveBase(self.base_pool).calc_token_amount(base_amounts, is_deposit)
364     meta_amounts[MAX_COIN] = _base_tokens
365 
366     return CurveMeta(self.pool).calc_token_amount(meta_amounts, is_deposit)