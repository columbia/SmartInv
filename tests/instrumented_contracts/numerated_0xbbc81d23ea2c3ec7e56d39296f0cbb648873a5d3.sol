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
41 ZERO256: constant(uint256) = 0  # This hack is really bad XXX
42 ZEROS: constant(uint256[N_COINS]) = [ZERO256, ZERO256, ZERO256, ZERO256]  # <- change
43 LENDING_PRECISION: constant(uint256) = 10 ** 18
44 PRECISION: constant(uint256) = 10 ** 18
45 PRECISION_MUL: constant(uint256[N_COINS]) = [convert(1, uint256), convert(1000000000000, uint256), convert(1000000000000, uint256), convert(1, uint256)]
46 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
47 FEE_IMPRECISION: constant(uint256) = 25 * 10 ** 8  # % of the fee
48 
49 coins: public(address[N_COINS])
50 underlying_coins: public(address[N_COINS])
51 curve: public(address)
52 token: public(address)
53 
54 
55 @public
56 def __init__(_coins: address[N_COINS], _underlying_coins: address[N_COINS],
57              _curve: address, _token: address):
58     self.coins = _coins
59     self.underlying_coins = _underlying_coins
60     self.curve = _curve
61     self.token = _token
62 
63 
64 @public
65 @nonreentrant('lock')
66 def add_liquidity(uamounts: uint256[N_COINS], min_mint_amount: uint256):
67     tethered: bool[N_COINS] = TETHERED
68     amounts: uint256[N_COINS] = ZEROS
69 
70     for i in range(N_COINS):
71         uamount: uint256 = uamounts[i]
72 
73         if uamount > 0:
74             # Transfer the underlying coin from owner
75             if tethered[i]:
76                 USDT(self.underlying_coins[i]).transferFrom(
77                     msg.sender, self, uamount)
78             else:
79                 assert_modifiable(ERC20(self.underlying_coins[i])\
80                     .transferFrom(msg.sender, self, uamount))
81 
82             # Mint if needed
83             ERC20(self.underlying_coins[i]).approve(self.coins[i], uamount)
84             yERC20(self.coins[i]).deposit(uamount)
85             amounts[i] = yERC20(self.coins[i]).balanceOf(self)
86             ERC20(self.coins[i]).approve(self.curve, amounts[i])
87 
88     Curve(self.curve).add_liquidity(amounts, min_mint_amount)
89 
90     tokens: uint256 = ERC20(self.token).balanceOf(self)
91     assert_modifiable(ERC20(self.token).transfer(msg.sender, tokens))
92 
93 
94 @private
95 def _send_all(_addr: address, min_uamounts: uint256[N_COINS], one: int128):
96     tethered: bool[N_COINS] = TETHERED
97 
98     for i in range(N_COINS):
99         if (one < 0) or (i == one):
100             _coin: address = self.coins[i]
101             _balance: uint256 = yERC20(_coin).balanceOf(self)
102             if _balance == 0:  # Do nothing for 0 coins
103                 continue
104             yERC20(_coin).withdraw(_balance)
105 
106             _ucoin: address = self.underlying_coins[i]
107             _uamount: uint256 = ERC20(_ucoin).balanceOf(self)
108             assert _uamount >= min_uamounts[i], "Not enough coins withdrawn"
109 
110             if tethered[i]:
111                 USDT(_ucoin).transfer(_addr, _uamount)
112             else:
113                 assert_modifiable(ERC20(_ucoin).transfer(_addr, _uamount))
114 
115 
116 @public
117 @nonreentrant('lock')
118 def remove_liquidity(_amount: uint256, min_uamounts: uint256[N_COINS]):
119     zeros: uint256[N_COINS] = ZEROS
120 
121     assert_modifiable(ERC20(self.token).transferFrom(msg.sender, self, _amount))
122     Curve(self.curve).remove_liquidity(_amount, zeros)
123 
124     self._send_all(msg.sender, min_uamounts, -1)
125 
126 
127 @public
128 @nonreentrant('lock')
129 def remove_liquidity_imbalance(uamounts: uint256[N_COINS], max_burn_amount: uint256):
130     """
131     Get max_burn_amount in, remove requested liquidity and transfer back what is left
132     """
133     tethered: bool[N_COINS] = TETHERED
134     _token: address = self.token
135 
136     amounts: uint256[N_COINS] = uamounts
137     for i in range(N_COINS):
138         if amounts[i] > 0:
139             rate: uint256 = yERC20(self.coins[i]).getPricePerFullShare()
140             amounts[i] = amounts[i] * LENDING_PRECISION / rate
141 
142     # Transfrer max tokens in
143     _tokens: uint256 = ERC20(_token).balanceOf(msg.sender)
144     if _tokens > max_burn_amount:
145         _tokens = max_burn_amount
146     assert_modifiable(ERC20(_token).transferFrom(msg.sender, self, _tokens))
147 
148     Curve(self.curve).remove_liquidity_imbalance(amounts, max_burn_amount)
149 
150     # Transfer unused tokens back
151     _tokens = ERC20(_token).balanceOf(self)
152     assert_modifiable(ERC20(_token).transfer(msg.sender, _tokens))
153 
154     # Unwrap and transfer all the coins we've got
155     self._send_all(msg.sender, ZEROS, -1)
156 
157 
158 @private
159 @constant
160 def _xp_mem(rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:
161     result: uint256[N_COINS] = rates
162     for i in range(N_COINS):
163         result[i] = result[i] * _balances[i] / PRECISION
164     return result
165 
166 
167 @private
168 @constant
169 def get_D(A: uint256, xp: uint256[N_COINS]) -> uint256:
170     S: uint256 = 0
171     for _x in xp:
172         S += _x
173     if S == 0:
174         return 0
175 
176     Dprev: uint256 = 0
177     D: uint256 = S
178     Ann: uint256 = A * N_COINS
179     for _i in range(255):
180         D_P: uint256 = D
181         for _x in xp:
182             D_P = D_P * D / (_x * N_COINS + 1)  # +1 is to prevent /0
183         Dprev = D
184         D = (Ann * S + D_P * N_COINS) * D / ((Ann - 1) * D + (N_COINS + 1) * D_P)
185         # Equality with the precision of 1
186         if D > Dprev:
187             if D - Dprev <= 1:
188                 break
189         else:
190             if Dprev - D <= 1:
191                 break
192     return D
193 
194 
195 @private
196 @constant
197 def get_y(A: uint256, i: int128, _xp: uint256[N_COINS], D: uint256) -> uint256:
198     """
199     Calculate x[i] if one reduces D from being calculated for _xp to D
200 
201     Done by solving quadratic equation iteratively.
202     x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
203     x_1**2 + b*x_1 = c
204 
205     x_1 = (x_1**2 + c) / (2*x_1 + b)
206     """
207     # x in the input is converted to the same price/precision
208 
209     assert (i >= 0) and (i < N_COINS)
210 
211     c: uint256 = D
212     S_: uint256 = 0
213     Ann: uint256 = A * N_COINS
214 
215     _x: uint256 = 0
216     for _i in range(N_COINS):
217         if _i != i:
218             _x = _xp[_i]
219         else:
220             continue
221         S_ += _x
222         c = c * D / (_x * N_COINS)
223     c = c * D / (Ann * N_COINS)
224     b: uint256 = S_ + D / Ann
225     y_prev: uint256 = 0
226     y: uint256 = D
227     for _i in range(255):
228         y_prev = y
229         y = (y*y + c) / (2 * y + b - D)
230         # Equality with the precision of 1
231         if y > y_prev:
232             if y - y_prev <= 1:
233                 break
234         else:
235             if y_prev - y <= 1:
236                 break
237     return y
238 
239 
240 @private
241 @constant
242 def _calc_withdraw_one_coin(_token_amount: uint256, i: int128, rates: uint256[N_COINS]) -> uint256:
243     # First, need to calculate
244     # * Get current D
245     # * Solve Eqn against y_i for D - _token_amount
246     crv: address = self.curve
247     A: uint256 = Curve(crv).A()
248     fee: uint256 = Curve(crv).fee() * N_COINS / (4 * (N_COINS - 1))
249     fee += fee * FEE_IMPRECISION / FEE_DENOMINATOR  # Overcharge to account for imprecision
250     precisions: uint256[N_COINS] = PRECISION_MUL
251     total_supply: uint256 = ERC20(self.token).totalSupply()
252 
253     xp: uint256[N_COINS] = PRECISION_MUL
254     S: uint256 = 0
255     for j in range(N_COINS):
256         xp[j] *= Curve(crv).balances(j)
257         xp[j] = xp[j] * rates[j] / LENDING_PRECISION
258         S += xp[j]
259 
260     D0: uint256 = self.get_D(A, xp)
261     D1: uint256 = D0 - _token_amount * D0 / total_supply
262     xp_reduced: uint256[N_COINS] = xp
263 
264     # xp = xp - fee * | xp * D1 / D0 - (xp - S * dD / D0 * (0, ... 1, ..0))|
265     for j in range(N_COINS):
266         dx_expected: uint256 = 0
267         b_ideal: uint256 = xp[j] * D1 / D0
268         b_expected: uint256 = xp[j]
269         if j == i:
270             b_expected -= S * (D0 - D1) / D0
271         if b_ideal >= b_expected:
272             dx_expected += (b_ideal - b_expected)
273         else:
274             dx_expected += (b_expected - b_ideal)
275         xp_reduced[j] -= fee * dx_expected / FEE_DENOMINATOR
276 
277     dy: uint256 = xp_reduced[i] - self.get_y(A, i, xp_reduced, D1)
278     dy = dy / precisions[i]
279 
280     return dy
281 
282 
283 @public
284 @constant
285 def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256:
286     rates: uint256[N_COINS] = ZEROS
287 
288     for j in range(N_COINS):
289         rates[j] = yERC20(self.coins[j]).getPricePerFullShare()
290 
291     return self._calc_withdraw_one_coin(_token_amount, i, rates)
292 
293 
294 @public
295 @nonreentrant('lock')
296 def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_uamount: uint256, donate_dust: bool = False):
297     """
298     Remove _amount of liquidity all in a form of coin i
299     """
300     rates: uint256[N_COINS] = ZEROS
301     _token: address = self.token
302 
303     for j in range(N_COINS):
304         rates[j] = yERC20(self.coins[j]).getPricePerFullShare()
305 
306     dy: uint256 = self._calc_withdraw_one_coin(_token_amount, i, rates)
307     assert dy >= min_uamount, "Not enough coins removed"
308 
309     assert_modifiable(
310         ERC20(self.token).transferFrom(msg.sender, self, _token_amount))
311 
312     amounts: uint256[N_COINS] = ZEROS
313     amounts[i] = dy * LENDING_PRECISION / rates[i]
314     token_amount_before: uint256 = ERC20(_token).balanceOf(self)
315     Curve(self.curve).remove_liquidity_imbalance(amounts, _token_amount)
316 
317     # Unwrap and transfer all the coins we've got
318     self._send_all(msg.sender, ZEROS, i)
319 
320     if not donate_dust:
321         # Transfer unused tokens back
322         token_amount_after: uint256 = ERC20(_token).balanceOf(self)
323         if token_amount_after > token_amount_before:
324             assert_modifiable(ERC20(_token).transfer(
325                 msg.sender, token_amount_after - token_amount_before)
326             )
327 
328 
329 @public
330 @nonreentrant('lock')
331 def withdraw_donated_dust():
332     owner: address = Curve(self.curve).owner()
333     assert msg.sender == owner
334 
335     _token: address = self.token
336     assert_modifiable(
337         ERC20(_token).transfer(owner, ERC20(_token).balanceOf(self)))