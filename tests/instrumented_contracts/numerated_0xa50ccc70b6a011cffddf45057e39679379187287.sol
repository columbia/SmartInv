1 # A "zap" to deposit/withdraw Curve contract without too many transactions
2 # (c) Curve.Fi, 2020
3 from vyper.interfaces import ERC20
4 
5 # External Contracts
6 contract yERC20:
7     def totalSupply() -> uint256: constant
8     def allowance(_owner: address, _spender: address) -> uint256: constant
9     def transfer(_to: address, _value: uint256) -> bool: modifying
10     def transferFrom(_from: address, _to: address, _value: uint256) -> bool: modifying
11     def approve(_spender: address, _value: uint256) -> bool: modifying
12     def name() -> string[64]: constant
13     def symbol() -> string[32]: constant
14     def decimals() -> uint256: constant
15     def balanceOf(arg0: address) -> uint256: constant
16     def deposit(depositAmount: uint256): modifying
17     def withdraw(withdrawTokens: uint256): modifying
18     def getPricePerFullShare() -> uint256: constant
19 
20 
21 
22 
23 # Tether transfer-only ABI
24 contract USDT:
25     def transfer(_to: address, _value: uint256): modifying
26     def transferFrom(_from: address, _to: address, _value: uint256): modifying
27 
28 
29 contract Curve:
30     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256): modifying
31     def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]): modifying
32     def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256): modifying
33     def balances(i: int128) -> uint256: constant
34     def A() -> uint256: constant
35     def fee() -> uint256: constant
36     def owner() -> address: constant
37 
38 
39 N_COINS: constant(int128) = 4
40 TETHERED: constant(bool[N_COINS]) = [False, False, True, False]
41 USE_LENDING: constant(bool[N_COINS]) = [True, True, True, False]
42 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
43 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256, ZERO256, ZERO256]  # <- change
44 LENDING_PRECISION: constant(uint256) = 10 ** 18
45 PRECISION: constant(uint256) = 10 ** 18
46 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(1, uint256), convert(1000000000000, uint256), convert(1000000000000, uint256), convert(1, uint256)]
47 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
48 FEE_IMPRECISION: constant(uint256) = 25 * 10 ** 8  # % of the fee
49 
50 coins: public(address[N_COINS])
51 underlying_coins: public(address[N_COINS])
52 curve: public(address)
53 token: public(address)
54 
55 
56 @public
57 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
58              _curve: address, _token: address):
59     self.coins = _coins
60     self.underlying_coins = _underlying_coins
61     self.curve = _curve
62     self.token = _token
63 
64 
65 @public
66 @nonreentrant('lock')
67 def add_liquidity(uamounts: uint256[N_COINS], min_mint_amount: uint256):
68     use_lending: bool[N_COINS] = USE_LENDING
69     tethered: bool[N_COINS] = TETHERED
70     amounts: uint256[N_COINS] = ZEROS
71 
72     for i in range(N_COINS):
73         uamount: uint256 = uamounts[i]
74 
75         if uamount > 0:
76             # Transfer the underlying coin from owner
77             if tethered[i]:
78                 USDT(self.underlying_coins[i]).transferFrom(
79                     msg.sender, self, uamount)
80             else:
81                 assert_modifiable(ERC20(self.underlying_coins[i])\
82                     .transferFrom(msg.sender, self, uamount))
83 
84             # Mint if needed
85             if use_lending[i]:
86                 ERC20(self.underlying_coins[i]).approve(self.coins[i], uamount)
87                 yERC20(self.coins[i]).deposit(uamount)
88                 amounts[i] = yERC20(self.coins[i]).balanceOf(self)
89                 ERC20(self.coins[i]).approve(self.curve, amounts[i])
90             else:
91                 amounts[i] = uamount
92                 ERC20(self.underlying_coins[i]).approve(self.curve, uamount)
93 
94     Curve(self.curve).add_liquidity(amounts, min_mint_amount)
95 
96     tokens: uint256 = ERC20(self.token).balanceOf(self)
97     assert_modifiable(ERC20(self.token).transfer(msg.sender, tokens))
98 
99 
100 @private
101 def _send_all(_addr: address, min_uamounts: uint256[N_COINS], one: int128):
102     use_lending: bool[N_COINS] = USE_LENDING
103     tethered: bool[N_COINS] = TETHERED
104 
105     for i in range(N_COINS):
106         if (one < 0) or (i == one):
107             if use_lending[i]:
108                 _coin: address = self.coins[i]
109                 _balance: uint256 = yERC20(_coin).balanceOf(self)
110                 if _balance == 0:  # Do nothing if there are 0 coins
111                     continue
112                 yERC20(_coin).withdraw(_balance)
113 
114             _ucoin: address = self.underlying_coins[i]
115             _uamount: uint256 = ERC20(_ucoin).balanceOf(self)
116             assert _uamount >= min_uamounts[i], "Not enough coins withdrawn"
117 
118             # Send only if we have something to send
119             if _uamount >= 0:
120                 if tethered[i]:
121                     USDT(_ucoin).transfer(_addr, _uamount)
122                 else:
123                     assert_modifiable(ERC20(_ucoin).transfer(_addr, _uamount))
124 
125 
126 @public
127 @nonreentrant('lock')
128 def remove_liquidity(_amount: uint256, min_uamounts: uint256[N_COINS]):
129     zeros: uint256[N_COINS] = ZEROS
130 
131     assert_modifiable(ERC20(self.token).transferFrom(msg.sender, self, _amount))
132     Curve(self.curve).remove_liquidity(_amount, zeros)
133 
134     self._send_all(msg.sender, min_uamounts, -1)
135 
136 
137 @public
138 @nonreentrant('lock')
139 def remove_liquidity_imbalance(uamounts: uint256[N_COINS], max_burn_amount: uint256):
140     """
141     Get max_burn_amount in, remove requested liquidity and transfer back what is left
142     """
143     use_lending: bool[N_COINS] = USE_LENDING
144     tethered: bool[N_COINS] = TETHERED
145     _token: address = self.token
146 
147     amounts: uint256[N_COINS] = uamounts
148     for i in range(N_COINS):
149         if use_lending[i] and amounts[i] > 0:
150             rate: uint256 = yERC20(self.coins[i]).getPricePerFullShare()
151             amounts[i] = amounts[i] * LENDING_PRECISION / rate
152         # if not use_lending - all good already
153 
154     # Transfrer max tokens in
155     _tokens: uint256 = ERC20(_token).balanceOf(msg.sender)
156     if _tokens > max_burn_amount:
157         _tokens = max_burn_amount
158     assert_modifiable(ERC20(_token).transferFrom(msg.sender, self, _tokens))
159 
160     Curve(self.curve).remove_liquidity_imbalance(amounts, max_burn_amount)
161 
162     # Transfer unused tokens back
163     _tokens = ERC20(_token).balanceOf(self)
164     assert_modifiable(ERC20(_token).transfer(msg.sender, _tokens))
165 
166     # Unwrap and transfer all the coins we've got
167     self._send_all(msg.sender, ZEROS, -1)
168 
169 
170 @private
171 @constant
172 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
173     result: uint256[N_COINS] = rates
174     for i in range(N_COINS):
175         result[i] = result[i] * _balances[i] / PRECISION
176     return result
177 
178 
179 @private
180 @constant
181 def get_D(A: uint256, xp: uint256[N_COINS]) -> uint256:
182     S: uint256 = 0
183     for _x in xp:
184         S += _x
185     if S == 0:
186         return 0
187 
188     Dprev: uint256 = 0
189     D: uint256 = S
190     Ann: uint256 = A * N_COINS
191     for _i in range(255):
192         D_P: uint256 = D
193         for _x in xp:
194             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
195         Dprev = D
196         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
197         # Equality with the precision of 1
198         if D > Dprev:
199             if D - Dprev <= 1:
200                 break
201         else:
202             if Dprev - D <= 1:
203                 break
204     return D
205 
206 
207 @private
208 @constant
209 def get_y(A: uint256, i: int128, _xp: uint256[N_COINS], D: uint256) -> uint256:
210     """
211     Calculate x[i] if one reduces D from being calculated for _xp to D
212 
213     Done by solving quadratic equation iteratively.
214     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
215     x_1**2 + b*x_1 = c
216 
217     x_1 = (x_1**2 + c) / (2*x_1 + b)
218     """
219     # x in the input is converted to the same price/precision
220 
221     assert (i >= 0) and (i < N_COINS)
222 
223     c: uint256 = D
224     S_: uint256 = 0
225     Ann: uint256 = A * N_COINS
226 
227     _x: uint256 = 0
228     for _i in range(N_COINS):
229         if _i != i:
230             _x = _xp[_i]
231         else:
232             continue
233         S_ += _x
234         c = c * D / (_x * N_COINS)
235     c = c * D / (Ann * N_COINS)
236     b: uint256 = S_ + D / Ann
237     y_prev: uint256 = 0
238     y: uint256 = D
239     for _i in range(255):
240         y_prev = y
241         y = (y*y + c) / (2 * y + b - D)
242         # Equality with the precision of 1
243         if y > y_prev:
244             if y - y_prev <= 1:
245                 break
246         else:
247             if y_prev - y <= 1:
248                 break
249     return y
250 
251 
252 @private
253 @constant
254 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, rates: uint256[N_COINS]) -> uint256:
255     # First, need to calculate
256     # * Get current D
257     # * Solve Eqn against y_i for D - _token_amount
258     use_lending: bool[N_COINS] = USE_LENDING
259     # tethered: bool[N_COINS] = TETHERED
260     crv: address = self.curve
261     A: uint256 = Curve(crv).A()
262     fee: uint256 = Curve(crv).fee() * N_COINS / (4 * (N_COINS - 1))
263     fee += fee * FEE_IMPRECISION / FEE_DENOMINATOR  # Overcharge to account for imprecision
264     precisions: uint256[N_COINS] = PRECISION_MUL
265     total_supply: uint256 = ERC20(self.token).totalSupply()
266 
267     xp: uint256[N_COINS] = PRECISION_MUL
268     S: uint256 = 0
269     for j in range(N_COINS):
270         xp[j] *= Curve(crv).balances(j)
271         if use_lending[j]:
272             # Use stored rate b/c we have imprecision anyway
273             xp[j] = xp[j] * rates[j] / LENDING_PRECISION
274         S += xp[j]
275         # if not use_lending - all good already
276 
277     D0: uint256 = self.get_D(A, xp)
278     D1: uint256 = D0 - _token_amount * D0 / total_supply
279     xp_reduced: uint256[N_COINS] = xp
280 
281     # xp = xp - fee * | xp * D1 / D0 - (xp - S * dD / D0 * (0, ... 1, ..0))|
282     for j in range(N_COINS):
283         dx_expected: uint256 = 0
284         b_ideal: uint256 = xp[j] * D1 / D0
285         b_expected: uint256 = xp[j]
286         if j == i:
287             b_expected -= S * (D0 - D1) / D0
288         if b_ideal >= b_expected:
289             dx_expected = (b_ideal - b_expected)
290         else:
291             dx_expected = (b_expected - b_ideal)
292         xp_reduced[j] -= fee * dx_expected / FEE_DENOMINATOR
293 
294     dy: uint256 = xp_reduced[i] - self.get_y(A, i, xp_reduced, D1)
295     dy = dy / precisions[i]
296 
297     return dy
298 
299 
300 @public
301 @constant
302 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
303     rates: uint256[N_COINS] = ZEROS
304     use_lending: bool[N_COINS] = USE_LENDING
305 
306     for j in range(N_COINS):
307         if use_lending[j]:
308             rates[j] = yERC20(self.coins[j]).getPricePerFullShare()
309         else:
310             rates[j] = 10 ** 18
311 
312     return self._calc_withdraw_one_coin(_token_amount, i, rates)
313 
314 
315 @public
316 @nonreentrant('lock')
317 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_uamount: uint256, donate_dust: bool = False):
318     """
319     Remove _amount of liquidity all in a form of coin i
320     """
321     use_lending: bool[N_COINS] = USE_LENDING
322     rates: uint256[N_COINS] = ZEROS
323     _token: address = self.token
324 
325     for j in range(N_COINS):
326         if use_lending[j]:
327             rates[j] = yERC20(self.coins[j]).getPricePerFullShare()
328         else:
329             rates[j] = LENDING_PRECISION
330 
331     dy: uint256 = self._calc_withdraw_one_coin(_token_amount, i, rates)
332     assert dy >= min_uamount, "Not enough coins removed"
333 
334     assert_modifiable(
335         ERC20(self.token).transferFrom(msg.sender, self, _token_amount))
336 
337     amounts: uint256[N_COINS] = ZEROS
338     amounts[i] = dy * LENDING_PRECISION / rates[i]
339     token_amount_before: uint256 = ERC20(_token).balanceOf(self)
340     Curve(self.curve).remove_liquidity_imbalance(amounts, _token_amount)
341 
342     # Unwrap and transfer all the coins we've got
343     self._send_all(msg.sender, ZEROS, i)
344 
345     if not donate_dust:
346         # Transfer unused tokens back
347         token_amount_after: uint256 = ERC20(_token).balanceOf(self)
348         if token_amount_after > token_amount_before:
349             assert_modifiable(ERC20(_token).transfer(
350                 msg.sender, token_amount_after - token_amount_before)
351             )
352 
353 
354 @public
355 @nonreentrant('lock')
356 def withdraw_donated_dust():
357     owner: address = Curve(self.curve).owner()
358     assert msg.sender == owner
359 
360     _token: address = self.token
361     assert_modifiable(
362         ERC20(_token).transfer(owner, ERC20(_token).balanceOf(self)))