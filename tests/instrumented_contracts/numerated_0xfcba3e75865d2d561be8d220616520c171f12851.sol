1 # A "zap" to deposit/withdraw Curve contract without too many transactions
2 # (c) Curve.Fi, 2020
3 from vyper.interfaces import ERC20
4 
5 # External Contracts
6 contract cERC20:
7     def totalSupply() -> uint256: constant
8     def allowance(_owner: address, _spender: address) -> uint256: constant
9     def transfer(_to: address, _value: uint256) -> bool: modifying
10     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
11     def approve(_spender: address, _value: uint256) -> bool: modifying
12     def burn(_value: uint256): modifying
13     def burnFrom(_to: address, _value: uint256): modifying
14     def name() -> string[64]: constant
15     def symbol() -> string[32]: constant
16     def decimals() -> uint256: constant
17     def balanceOf(arg0: address) -> uint256: constant
18     def mint(mintAmount: uint256) -> uint256: modifying
19     def redeem(redeemTokens: uint256) -> uint256: modifying
20     def redeemUnderlying(redeemAmount: uint256) -> uint256: modifying
21     def exchangeRateStored() -> uint256: constant
22     def exchangeRateCurrent() -> uint256: modifying
23     def supplyRatePerBlock() -> uint256: constant
24     def accrualBlockNumber() -> uint256: constant
25 
26 
27 
28 
29 # Tether transfer-only ABI
30 contract USDT:
31     def transfer(_to: address, _value: uint256): modifying
32     def transferFrom(_from: address, _to: address, _value: uint256): modifying
33 
34 
35 contract Curve:
36     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256): modifying
37     def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]): modifying
38     def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256): modifying
39     def balances(i: int128) -> uint256: constant
40     def A() -> uint256: constant
41     def fee() -> uint256: constant
42     def owner() -> address: constant
43 
44 
45 N_COINS: constant(int128) = 4
46 TETHERED: constant(bool[N_COINS]) = [False, False, True, False]
47 USE_LENDING: constant(bool[N_COINS]) = [False, False, False, False]
48 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
49 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256, ZERO256, ZERO256]  # <- change
50 LENDING_PRECISION: constant(uint256) = 10 ** 18
51 PRECISION: constant(uint256) = 10 ** 18
52 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(1, uint256), convert(1000000000000, uint256), convert(1000000000000, uint256), convert(1, uint256)]
53 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
54 FEE_IMPRECISION: constant(uint256) = 25 * 10 ** 8  # % of the fee
55 
56 coins: public(address[N_COINS])
57 underlying_coins: public(address[N_COINS])
58 curve: public(address)
59 token: public(address)
60 
61 
62 @public
63 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
64              _curve: address, _token: address):
65     self.coins = _coins
66     self.underlying_coins = _underlying_coins
67     self.curve = _curve
68     self.token = _token
69 
70 
71 @public
72 @nonreentrant('lock')
73 def add_liquidity(uamounts: uint256[N_COINS], min_mint_amount: uint256):
74     use_lending: bool[N_COINS] = USE_LENDING
75     tethered: bool[N_COINS] = TETHERED
76     amounts: uint256[N_COINS] = ZEROS
77 
78     for i in range(N_COINS):
79         uamount: uint256 = uamounts[i]
80 
81         if uamount > 0:
82             # Transfer the underlying coin from owner
83             if tethered[i]:
84                 USDT(self.underlying_coins[i]).transferFrom(
85                     msg.sender, self, uamount)
86             else:
87                 assert_modifiable(ERC20(self.underlying_coins[i])\
88                     .transferFrom(msg.sender, self, uamount))
89 
90             # Mint if needed
91             if use_lending[i]:
92                 ERC20(self.underlying_coins[i]).approve(self.coins[i], uamount)
93                 ok: uint256 = cERC20(self.coins[i]).mint(uamount)
94                 if ok > 0:
95                     raise "Could not mint coin"
96                 amounts[i] = cERC20(self.coins[i]).balanceOf(self)
97                 ERC20(self.coins[i]).approve(self.curve, amounts[i])
98             else:
99                 amounts[i] = uamount
100                 ERC20(self.underlying_coins[i]).approve(self.curve, uamount)
101 
102     Curve(self.curve).add_liquidity(amounts, min_mint_amount)
103 
104     tokens: uint256 = ERC20(self.token).balanceOf(self)
105     assert_modifiable(ERC20(self.token).transfer(msg.sender, tokens))
106 
107 
108 @private
109 def _send_all(_addr: address, min_uamounts: uint256[N_COINS], one: int128):
110     use_lending: bool[N_COINS] = USE_LENDING
111     tethered: bool[N_COINS] = TETHERED
112 
113     for i in range(N_COINS):
114         if (one < 0) or (i == one):
115             if use_lending[i]:
116                 _coin: address = self.coins[i]
117                 _balance: uint256 = cERC20(_coin).balanceOf(self)
118                 if _balance == 0:  # Do nothing if there are 0 coins
119                     continue
120                 ok: uint256 = cERC20(_coin).redeem(_balance)
121                 if ok > 0:
122                     raise "Could not redeem coin"
123 
124             _ucoin: address = self.underlying_coins[i]
125             _uamount: uint256 = ERC20(_ucoin).balanceOf(self)
126             assert _uamount >= min_uamounts[i], "Not enough coins withdrawn"
127 
128             # Send only if we have something to send
129             if _uamount >= 0:
130                 if tethered[i]:
131                     USDT(_ucoin).transfer(_addr, _uamount)
132                 else:
133                     assert_modifiable(ERC20(_ucoin).transfer(_addr, _uamount))
134 
135 
136 @public
137 @nonreentrant('lock')
138 def remove_liquidity(_amount: uint256, min_uamounts: uint256[N_COINS]):
139     zeros: uint256[N_COINS] = ZEROS
140 
141     assert_modifiable(ERC20(self.token).transferFrom(msg.sender, self, _amount))
142     Curve(self.curve).remove_liquidity(_amount, zeros)
143 
144     self._send_all(msg.sender, min_uamounts, -1)
145 
146 
147 @public
148 @nonreentrant('lock')
149 def remove_liquidity_imbalance(uamounts: uint256[N_COINS], max_burn_amount: uint256):
150     """
151     Get max_burn_amount in, remove requested liquidity and transfer back what is left
152     """
153     use_lending: bool[N_COINS] = USE_LENDING
154     tethered: bool[N_COINS] = TETHERED
155     _token: address = self.token
156 
157     amounts: uint256[N_COINS] = uamounts
158     for i in range(N_COINS):
159         if use_lending[i] and amounts[i] > 0:
160             rate: uint256 = cERC20(self.coins[i]).exchangeRateCurrent()
161             amounts[i] = amounts[i] * LENDING_PRECISION / rate
162         # if not use_lending - all good already
163 
164     # Transfrer max tokens in
165     _tokens: uint256 = ERC20(_token).balanceOf(msg.sender)
166     if _tokens > max_burn_amount:
167         _tokens = max_burn_amount
168     assert_modifiable(ERC20(_token).transferFrom(msg.sender, self, _tokens))
169 
170     Curve(self.curve).remove_liquidity_imbalance(amounts, max_burn_amount)
171 
172     # Transfer unused tokens back
173     _tokens = ERC20(_token).balanceOf(self)
174     assert_modifiable(ERC20(_token).transfer(msg.sender, _tokens))
175 
176     # Unwrap and transfer all the coins we've got
177     self._send_all(msg.sender, ZEROS, -1)
178 
179 
180 @private
181 @constant
182 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
183     result: uint256[N_COINS] = rates
184     for i in range(N_COINS):
185         result[i] = result[i] * _balances[i] / PRECISION
186     return result
187 
188 
189 @private
190 @constant
191 def get_D(A: uint256, xp: uint256[N_COINS]) -> uint256:
192     S: uint256 = 0
193     for _x in xp:
194         S += _x
195     if S == 0:
196         return 0
197 
198     Dprev: uint256 = 0
199     D: uint256 = S
200     Ann: uint256 = A * N_COINS
201     for _i in range(255):
202         D_P: uint256 = D
203         for _x in xp:
204             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
205         Dprev = D
206         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
207         # Equality with the precision of 1
208         if D > Dprev:
209             if D - Dprev <= 1:
210                 break
211         else:
212             if Dprev - D <= 1:
213                 break
214     return D
215 
216 
217 @private
218 @constant
219 def get_y(A: uint256, i: int128, _xp: uint256[N_COINS], D: uint256) -> uint256:
220     """
221     Calculate x[i] if one reduces D from being calculated for _xp to D
222 
223     Done by solving quadratic equation iteratively.
224     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
225     x_1**2 + b*x_1 = c
226 
227     x_1 = (x_1**2 + c) / (2*x_1 + b)
228     """
229     # x in the input is converted to the same price/precision
230 
231     assert (i >= 0) and (i < N_COINS)
232 
233     c: uint256 = D
234     S_: uint256 = 0
235     Ann: uint256 = A * N_COINS
236 
237     _x: uint256 = 0
238     for _i in range(N_COINS):
239         if _i != i:
240             _x = _xp[_i]
241         else:
242             continue
243         S_ += _x
244         c = c * D / (_x * N_COINS)
245     c = c * D / (Ann * N_COINS)
246     b: uint256 = S_ + D / Ann
247     y_prev: uint256 = 0
248     y: uint256 = D
249     for _i in range(255):
250         y_prev = y
251         y = (y*y + c) / (2 * y + b - D)
252         # Equality with the precision of 1
253         if y > y_prev:
254             if y - y_prev <= 1:
255                 break
256         else:
257             if y_prev - y <= 1:
258                 break
259     return y
260 
261 
262 @private
263 @constant
264 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, rates: uint256[N_COINS]) -> uint256:
265     # First, need to calculate
266     # * Get current D
267     # * Solve Eqn against y_i for D - _token_amount
268     use_lending: bool[N_COINS] = USE_LENDING
269     # tethered: bool[N_COINS] = TETHERED
270     crv: address = self.curve
271     A: uint256 = Curve(crv).A()
272     fee: uint256 = Curve(crv).fee() * N_COINS / (4 * (N_COINS - 1))
273     fee += fee * FEE_IMPRECISION / FEE_DENOMINATOR  # Overcharge to account for imprecision
274     precisions: uint256[N_COINS] = PRECISION_MUL
275     total_supply: uint256 = ERC20(self.token).totalSupply()
276 
277     xp: uint256[N_COINS] = PRECISION_MUL
278     S: uint256 = 0
279     for j in range(N_COINS):
280         xp[j] *= Curve(crv).balances(j)
281         if use_lending[j]:
282             # Use stored rate b/c we have imprecision anyway
283             xp[j] = xp[j] * rates[j] / LENDING_PRECISION
284         S += xp[j]
285         # if not use_lending - all good already
286 
287     D0: uint256 = self.get_D(A, xp)
288     D1: uint256 = D0 - _token_amount * D0 / total_supply
289     xp_reduced: uint256[N_COINS] = xp
290 
291     # xp = xp - fee * | xp * D1 / D0 - (xp - S * dD / D0 * (0, ... 1, ..0))|
292     for j in range(N_COINS):
293         dx_expected: uint256 = 0
294         b_ideal: uint256 = xp[j] * D1 / D0
295         b_expected: uint256 = xp[j]
296         if j == i:
297             b_expected -= S * (D0 - D1) / D0
298         if b_ideal >= b_expected:
299             dx_expected = (b_ideal - b_expected)
300         else:
301             dx_expected = (b_expected - b_ideal)
302         xp_reduced[j] -= fee * dx_expected / FEE_DENOMINATOR
303 
304     dy: uint256 = xp_reduced[i] - self.get_y(A, i, xp_reduced, D1)
305     dy = dy / precisions[i]
306 
307     return dy
308 
309 
310 @public
311 @constant
312 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
313     rates: uint256[N_COINS] = ZEROS
314     use_lending: bool[N_COINS] = USE_LENDING
315 
316     for j in range(N_COINS):
317         if use_lending[j]:
318             rates[j] = cERC20(self.coins[j]).exchangeRateStored()
319         else:
320             rates[j] = 10 ** 18
321 
322     return self._calc_withdraw_one_coin(_token_amount, i, rates)
323 
324 
325 @public
326 @nonreentrant('lock')
327 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_uamount: uint256, donate_dust: bool = False):
328     """
329     Remove _amount of liquidity all in a form of coin i
330     """
331     use_lending: bool[N_COINS] = USE_LENDING
332     rates: uint256[N_COINS] = ZEROS
333     _token: address = self.token
334 
335     for j in range(N_COINS):
336         if use_lending[j]:
337             rates[j] = cERC20(self.coins[j]).exchangeRateCurrent()
338         else:
339             rates[j] = LENDING_PRECISION
340 
341     dy: uint256 = self._calc_withdraw_one_coin(_token_amount, i, rates)
342     assert dy >= min_uamount, "Not enough coins removed"
343 
344     assert_modifiable(
345         ERC20(self.token).transferFrom(msg.sender, self, _token_amount))
346 
347     amounts: uint256[N_COINS] = ZEROS
348     amounts[i] = dy * LENDING_PRECISION / rates[i]
349     token_amount_before: uint256 = ERC20(_token).balanceOf(self)
350     Curve(self.curve).remove_liquidity_imbalance(amounts, _token_amount)
351 
352     # Unwrap and transfer all the coins we've got
353     self._send_all(msg.sender, ZEROS, i)
354 
355     if not donate_dust:
356         # Transfer unused tokens back
357         token_amount_after: uint256 = ERC20(_token).balanceOf(self)
358         if token_amount_after > token_amount_before:
359             assert_modifiable(ERC20(_token).transfer(
360                 msg.sender, token_amount_after - token_amount_before)
361             )
362 
363 
364 @public
365 @nonreentrant('lock')
366 def withdraw_donated_dust():
367     owner: address = Curve(self.curve).owner()
368     assert msg.sender == owner
369 
370     _token: address = self.token
371     assert_modifiable(
372         ERC20(_token).transfer(owner, ERC20(_token).balanceOf(self)))