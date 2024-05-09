1 # @version 0.3.3
2 # */3crv pool where 3crv is _second_, not first
3 
4 from vyper.interfaces import ERC20
5 
6 interface CurveCryptoSwap:
7     def token() -> address: view
8     def coins(i: uint256) -> address: view
9     def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256: view
10     def calc_token_amount(amounts: uint256[N_COINS]) -> uint256: view
11     def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256: view
12     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256) -> uint256: nonpayable
13     def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256) -> uint256: nonpayable
14     def remove_liquidity(amount: uint256, min_amounts: uint256[N_COINS]): nonpayable
15     def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256) -> uint256: nonpayable
16     def price_oracle() -> uint256: view
17     def price_scale() -> uint256: view
18     def lp_price() -> uint256: view
19 
20 interface StableSwap:
21     def coins(i: uint256) -> address: view
22     def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view
23     def calc_token_amount(amounts: uint256[N_STABLECOINS], is_deposit: bool) -> uint256: view
24     def calc_withdraw_one_coin(token_amount: uint256, i: int128) -> uint256: view
25     def add_liquidity(amounts: uint256[N_STABLECOINS], min_mint_amount: uint256): nonpayable
26     def remove_liquidity_one_coin(token_amount: uint256, i: int128, min_amount: uint256): nonpayable
27     def remove_liquidity(amount: uint256, min_amounts: uint256[N_STABLECOINS]): nonpayable
28     def get_virtual_price() -> uint256: view
29 
30 
31 N_COINS: constant(uint256) = 2
32 N_STABLECOINS: constant(int128) = 3
33 N_UL_COINS: constant(int128) = N_COINS + N_STABLECOINS - 1
34 
35 # All the following properties can be replaced with constants for gas efficiency
36 
37 COINS: immutable(address[N_COINS])
38 UNDERLYING_COINS: immutable(address[N_UL_COINS])
39 POOL: immutable(address)
40 BASE_POOL: immutable(address)
41 TOKEN: immutable(address)
42 
43 
44 @external
45 def __init__(pool: address, base_pool: address):
46     coins: address[N_COINS] = empty(address[N_COINS])
47     ul_coins: address[N_UL_COINS] = empty(address[N_UL_COINS])
48     POOL = pool
49     BASE_POOL = base_pool
50     TOKEN = CurveCryptoSwap(pool).token()
51 
52     for i in range(N_COINS):
53         coins[i] = CurveCryptoSwap(pool).coins(i)
54     ul_coins[0] = coins[0]
55     for i in range(N_UL_COINS - 1):
56         ul_coins[i + 1] = StableSwap(base_pool).coins(i)
57 
58     for coin in ul_coins:
59         response: Bytes[32] = raw_call(
60             coin,
61             concat(
62                 method_id("approve(address,uint256)"),
63                 convert(base_pool, bytes32),
64                 convert(MAX_UINT256, bytes32)
65             ),
66             max_outsize=32
67         )
68         if len(response) != 0:
69             assert convert(response, bool)
70 
71     for coin in coins:
72         response: Bytes[32] = raw_call(
73             coin,
74             concat(
75                 method_id("approve(address,uint256)"),
76                 convert(pool, bytes32),
77                 convert(MAX_UINT256, bytes32)
78             ),
79             max_outsize=32
80         )
81         if len(response) != 0:
82             assert convert(response, bool)
83 
84     COINS = coins
85     UNDERLYING_COINS = ul_coins
86 
87 
88 @external
89 @view
90 def coins(i: uint256) -> address:
91     _coins: address[N_COINS] = COINS
92     return _coins[i]
93 
94 
95 @external
96 @view
97 def underlying_coins(i: uint256) -> address:
98     _ucoins: address[N_UL_COINS] = UNDERLYING_COINS
99     return _ucoins[i]
100 
101 
102 @external
103 @view
104 def pool() -> address:
105     return POOL
106 
107 
108 @external
109 @view
110 def base_pool() -> address:
111     return BASE_POOL
112 
113 
114 @external
115 @view
116 def token() -> address:
117     return TOKEN
118 
119 
120 @external
121 @view
122 def price_oracle() -> uint256:
123     usd_tkn: uint256 = CurveCryptoSwap(POOL).price_oracle()
124     vprice: uint256 = StableSwap(BASE_POOL).get_virtual_price()
125     return vprice * 10**18 / usd_tkn
126 
127 
128 @external
129 @view
130 def price_scale() -> uint256:
131     usd_tkn: uint256 = CurveCryptoSwap(POOL).price_scale()
132     vprice: uint256 = StableSwap(BASE_POOL).get_virtual_price()
133     return vprice * 10**18 / usd_tkn
134 
135 
136 @external
137 @view
138 def lp_price() -> uint256:
139     p: uint256 = CurveCryptoSwap(POOL).lp_price()  # price in tkn
140     usd_tkn: uint256 = CurveCryptoSwap(POOL).price_oracle()
141     vprice: uint256 = StableSwap(BASE_POOL).get_virtual_price()
142     return p * vprice / usd_tkn
143 
144 
145 @external
146 def add_liquidity(_amounts: uint256[N_UL_COINS], _min_mint_amount: uint256, _receiver: address = msg.sender):
147     base_deposit_amounts: uint256[N_STABLECOINS] = empty(uint256[N_STABLECOINS])
148     deposit_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
149     is_base_deposit: bool = False
150     coins: address[N_COINS] = COINS
151     underlying_coins: address[N_UL_COINS] = UNDERLYING_COINS
152 
153     # transfer base pool coins from caller and deposit to get LP tokens
154     for i in range(N_UL_COINS - N_STABLECOINS, N_UL_COINS):
155         amount: uint256 = _amounts[i]
156         if amount != 0:
157             coin: address = underlying_coins[i]
158             # transfer underlying coin from msg.sender to self
159             _response: Bytes[32] = raw_call(
160                 coin,
161                 concat(
162                     method_id("transferFrom(address,address,uint256)"),
163                     convert(msg.sender, bytes32),
164                     convert(self, bytes32),
165                     convert(amount, bytes32)
166                 ),
167                 max_outsize=32
168             )
169             if len(_response) != 0:
170                 assert convert(_response, bool)
171             base_deposit_amounts[i - (N_COINS - 1)] = ERC20(coin).balanceOf(self)
172             is_base_deposit = True
173 
174     if is_base_deposit:
175         StableSwap(BASE_POOL).add_liquidity(base_deposit_amounts, 0)
176         deposit_amounts[N_COINS - 1] = ERC20(coins[N_COINS-1]).balanceOf(self)
177 
178     # transfer remaining underlying coins
179     for i in range(N_COINS - 1):
180         amount: uint256 = _amounts[i]
181         if amount != 0:
182             coin: address = underlying_coins[i]
183             # transfer underlying coin from msg.sender to self
184             _response: Bytes[32] = raw_call(
185                 coin,
186                 concat(
187                     method_id("transferFrom(address,address,uint256)"),
188                     convert(msg.sender, bytes32),
189                     convert(self, bytes32),
190                     convert(amount, bytes32)
191                 ),
192                 max_outsize=32
193             )
194             if len(_response) != 0:
195                 assert convert(_response, bool)
196 
197             deposit_amounts[i] = amount
198 
199     amount: uint256 = CurveCryptoSwap(POOL).add_liquidity(deposit_amounts, _min_mint_amount)
200     ERC20(TOKEN).transfer(_receiver, amount)
201 
202 
203 @external
204 def exchange_underlying(i: uint256, j: uint256, _dx: uint256, _min_dy: uint256, _receiver: address = msg.sender) -> uint256:
205     assert i != j  # dev: coins must be different
206     coins: address[N_COINS] = COINS
207     underlying_coins: address[N_UL_COINS] = UNDERLYING_COINS
208 
209     # transfer `i` from caller into the zap
210     response: Bytes[32] = raw_call(
211         underlying_coins[i],
212         concat(
213             method_id("transferFrom(address,address,uint256)"),
214             convert(msg.sender, bytes32),
215             convert(self, bytes32),
216             convert(_dx, bytes32)
217         ),
218         max_outsize=32
219     )
220     if len(response) != 0:
221         assert convert(response, bool)
222 
223     dx: uint256 = _dx
224     outer_i: uint256 = min(i, N_COINS - 1)
225     outer_j: uint256 = min(j, N_COINS - 1)
226 
227     if i >= N_COINS - 1:
228         # if `i` is in the base pool, deposit to get LP tokens
229         base_deposit_amounts: uint256[N_STABLECOINS] = empty(uint256[N_STABLECOINS])
230         base_deposit_amounts[i - (N_COINS - 1)] = dx
231         StableSwap(BASE_POOL).add_liquidity(base_deposit_amounts, 0)
232         dx = ERC20(coins[N_COINS-1]).balanceOf(self)
233 
234     # perform the exchange
235     amount: uint256 = dx
236     if outer_i != outer_j:
237         amount = CurveCryptoSwap(POOL).exchange(outer_i, outer_j, dx, 0)
238 
239     if outer_j == N_COINS - 1:
240         # if `j` is in the base pool, withdraw the desired underlying asset and transfer to caller
241         StableSwap(BASE_POOL).remove_liquidity_one_coin(amount, convert(j - (N_COINS - 1), int128), _min_dy)
242         amount = ERC20(underlying_coins[j]).balanceOf(self)
243     else:
244         # withdraw `j` underlying from lending pool and transfer to caller
245         assert amount >= _min_dy
246 
247     response = raw_call(
248         underlying_coins[j],
249         concat(
250             method_id("transfer(address,uint256)"),
251             convert(_receiver, bytes32),
252             convert(amount, bytes32)
253         ),
254         max_outsize=32
255     )
256     if len(response) != 0:
257         assert convert(response, bool)
258 
259     return amount
260 
261 
262 @external
263 def remove_liquidity(_amount: uint256, _min_amounts: uint256[N_UL_COINS], _receiver: address = msg.sender):
264     underlying_coins: address[N_UL_COINS] = UNDERLYING_COINS
265 
266     # transfer LP token from caller and remove liquidity
267     ERC20(TOKEN).transferFrom(msg.sender, self, _amount)
268     min_amounts: uint256[N_COINS] = [_min_amounts[0], 0]
269     CurveCryptoSwap(POOL).remove_liquidity(_amount, min_amounts)
270 
271     # withdraw from base pool and transfer underlying assets to receiver
272     value: uint256 = ERC20(COINS[1]).balanceOf(self)
273     base_min_amounts: uint256[N_STABLECOINS] = [_min_amounts[1], _min_amounts[2], _min_amounts[3]]
274     StableSwap(BASE_POOL).remove_liquidity(value, base_min_amounts)
275     for i in range(N_UL_COINS):
276         value = ERC20(underlying_coins[i]).balanceOf(self)
277         response: Bytes[32] = raw_call(
278             underlying_coins[i],
279             concat(
280                 method_id("transfer(address,uint256)"),
281                 convert(_receiver, bytes32),
282                 convert(value, bytes32)
283             ),
284             max_outsize=32
285         )
286         if len(response) != 0:
287             assert convert(response, bool)
288 
289 
290 @external
291 def remove_liquidity_one_coin(_token_amount: uint256, i: uint256, _min_amount: uint256, _receiver: address = msg.sender):
292     underlying_coins: address[N_UL_COINS] = UNDERLYING_COINS
293 
294     ERC20(TOKEN).transferFrom(msg.sender, self, _token_amount)
295     outer_i: uint256 = min(i, N_COINS - 1)
296     value: uint256 = CurveCryptoSwap(POOL).remove_liquidity_one_coin(_token_amount, outer_i, 0)
297 
298     if outer_i == N_COINS - 1:
299         StableSwap(BASE_POOL).remove_liquidity_one_coin(value, convert(i - (N_COINS - 1), int128), _min_amount)
300         value = ERC20(underlying_coins[i]).balanceOf(self)
301     else:
302         assert value >= _min_amount
303     response: Bytes[32] = raw_call(
304         underlying_coins[i],
305         concat(
306             method_id("transfer(address,uint256)"),
307             convert(_receiver, bytes32),
308             convert(value, bytes32)
309         ),
310         max_outsize=32
311     )
312     if len(response) != 0:
313         assert convert(response, bool)
314 
315 
316 @view
317 @external
318 def get_dy_underlying(i: uint256, j: uint256, _dx: uint256) -> uint256:
319     if min(i, j) >= N_COINS - 1:
320         return StableSwap(BASE_POOL).get_dy(convert(i - (N_COINS-1), int128), convert(j - (N_COINS-1), int128), _dx)
321 
322     dx: uint256 = _dx
323     outer_i: uint256 = min(i, N_COINS - 1)
324     outer_j: uint256 = min(j, N_COINS - 1)
325 
326     if outer_i == N_COINS-1:
327         amounts: uint256[N_STABLECOINS] = empty(uint256[N_STABLECOINS])
328         amounts[i - (N_COINS-1)] = dx
329         dx = StableSwap(BASE_POOL).calc_token_amount(amounts, True)
330 
331     dy: uint256 = CurveCryptoSwap(POOL).get_dy(outer_i, outer_j, dx)
332     if outer_j == N_COINS-1:
333         return StableSwap(BASE_POOL).calc_withdraw_one_coin(dy, convert(j - (N_COINS-1), int128))
334     else:
335         return dy
336 
337 
338 @view
339 @external
340 def calc_token_amount(_amounts: uint256[N_UL_COINS]) -> uint256:
341     base_amounts: uint256[N_STABLECOINS] = [_amounts[1], _amounts[2], _amounts[3]]
342     base_lp: uint256 = 0
343     if _amounts[1] + _amounts[2] + _amounts[3] > 0:
344         base_lp = StableSwap(BASE_POOL).calc_token_amount(base_amounts, True)
345     amounts: uint256[N_COINS] = [_amounts[0], base_lp]
346     return CurveCryptoSwap(POOL).calc_token_amount(amounts)
347 
348 
349 @view
350 @external
351 def calc_withdraw_one_coin(token_amount: uint256, i: uint256) -> uint256:
352     if i < N_COINS-1:
353         return CurveCryptoSwap(POOL).calc_withdraw_one_coin(token_amount, i)
354 
355     base_amount: uint256 = CurveCryptoSwap(POOL).calc_withdraw_one_coin(token_amount, N_COINS-1)
356     return StableSwap(BASE_POOL).calc_withdraw_one_coin(base_amount, convert(i - (N_COINS-1), int128))