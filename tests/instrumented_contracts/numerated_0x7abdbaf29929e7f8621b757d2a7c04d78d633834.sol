1 # @version 0.2.8
2 """
3 @title "Zap" Depositer for permissionless BTC metapools
4 @author Curve.Fi
5 @license Copyright (c) Curve.Fi, 2021 - all rights reserved
6 """
7 
8 interface ERC20:
9     def transfer(_receiver: address, _amount: uint256): nonpayable
10     def transferFrom(_sender: address, _receiver: address, _amount: uint256): nonpayable
11     def approve(_spender: address, _amount: uint256): nonpayable
12     def decimals() -> uint256: view
13     def balanceOf(_owner: address) -> uint256: view
14 
15 interface CurveMeta:
16     def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256, _receiver: address) -> uint256: nonpayable
17     def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]) -> uint256[N_COINS]: nonpayable
18     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256, _receiver: address) -> uint256: nonpayable
19     def remove_liquidity_imbalance(amounts: uint256[N_COINS], max_burn_amount: uint256) -> uint256: nonpayable
20     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
21     def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256: view
22     def coins(i: uint256) -> address: view
23 
24 interface CurveBase:
25     def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable
26     def remove_liquidity(_amount: uint256, min_amounts: uint256[BASE_N_COINS]): nonpayable
27     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256): nonpayable
28     def remove_liquidity_imbalance(amounts: uint256[BASE_N_COINS], max_burn_amount: uint256): nonpayable
29     def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view
30     def calc_token_amount(amounts: uint256[BASE_N_COINS], deposit: bool) -> uint256: view
31     def coins(i: int128) -> address: view
32     def fee() -> uint256: view
33 
34 
35 N_COINS: constant(int128) = 2
36 MAX_COIN: constant(int128) = N_COINS-1
37 BASE_N_COINS: constant(int128) = 3
38 N_ALL_COINS: constant(int128) = N_COINS + BASE_N_COINS - 1
39 
40 FEE_DENOMINATOR: constant(uint256) = 10 ** 10
41 FEE_IMPRECISION: constant(uint256) = 100 * 10 ** 8  # % of the fee
42 
43 BASE_POOL: constant(address) = 0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714
44 BASE_LP_TOKEN: constant(address) = 0x075b1bb99792c9E1041bA13afEf80C91a1e70fB3
45 BASE_COINS: constant(address[3]) = [
46     0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D,  # renBTC
47     0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,  # wBTC
48     0xfE18be6b3Bd88A2D2A7f928d00292E7a9963CfC6,  # sBTC
49 ]
50 
51 # coin -> pool -> is approved to transfer?
52 is_approved: HashMap[address, HashMap[address, bool]]
53 
54 
55 @external
56 def __init__():
57     """
58     @notice Contract constructor
59     """
60     base_coins: address[3] = BASE_COINS
61     for coin in base_coins:
62         ERC20(coin).approve(BASE_POOL, MAX_UINT256)
63 
64 
65 @external
66 def add_liquidity(
67     _pool: address,
68     _deposit_amounts: uint256[N_ALL_COINS],
69     _min_mint_amount: uint256,
70     _receiver: address = msg.sender,
71 ) -> uint256:
72     """
73     @notice Wrap underlying coins and deposit them into `_pool`
74     @param _pool Address of the pool to deposit into
75     @param _deposit_amounts List of amounts of underlying coins to deposit
76     @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
77     @param _receiver Address that receives the LP tokens
78     @return Amount of LP tokens received by depositing
79     """
80     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
81     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
82     deposit_base: bool = False
83     base_coins: address[3] = BASE_COINS
84 
85     if _deposit_amounts[0] != 0:
86         coin: address = CurveMeta(_pool).coins(0)
87         if not self.is_approved[coin][_pool]:
88             ERC20(coin).approve(_pool, MAX_UINT256)
89             self.is_approved[coin][_pool] = True
90         ERC20(coin).transferFrom(msg.sender, self, _deposit_amounts[0])
91         meta_amounts[0] = _deposit_amounts[0]
92 
93     for i in range(1, N_ALL_COINS):
94         amount: uint256 = _deposit_amounts[i]
95         if amount == 0:
96             continue
97         deposit_base = True
98         base_idx: uint256 = i - 1
99         coin: address = base_coins[base_idx]
100 
101         ERC20(coin).transferFrom(msg.sender, self, amount)
102         # Handle potential Tether fees
103         if i == N_ALL_COINS - 1:
104             base_amounts[base_idx] = ERC20(coin).balanceOf(self)
105         else:
106             base_amounts[base_idx] = amount
107 
108     # Deposit to the base pool
109     if deposit_base:
110         coin: address = BASE_LP_TOKEN
111         CurveBase(BASE_POOL).add_liquidity(base_amounts, 0)
112         meta_amounts[MAX_COIN] = ERC20(coin).balanceOf(self)
113         if not self.is_approved[coin][_pool]:
114             ERC20(coin).approve(_pool, MAX_UINT256)
115             self.is_approved[coin][_pool] = True
116 
117     # Deposit to the meta pool
118     return CurveMeta(_pool).add_liquidity(meta_amounts, _min_mint_amount, _receiver)
119 
120 
121 @external
122 def remove_liquidity(
123     _pool: address,
124     _burn_amount: uint256,
125     _min_amounts: uint256[N_ALL_COINS],
126     _receiver: address = msg.sender
127 ) -> uint256[N_ALL_COINS]:
128     """
129     @notice Withdraw and unwrap coins from the pool
130     @dev Withdrawal amounts are based on current deposit ratios
131     @param _pool Address of the pool to deposit into
132     @param _burn_amount Quantity of LP tokens to burn in the withdrawal
133     @param _min_amounts Minimum amounts of underlying coins to receive
134     @param _receiver Address that receives the LP tokens
135     @return List of amounts of underlying coins that were withdrawn
136     """
137     ERC20(_pool).transferFrom(msg.sender, self, _burn_amount)
138 
139     min_amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
140     amounts: uint256[N_ALL_COINS] = empty(uint256[N_ALL_COINS])
141 
142     # Withdraw from meta
143     meta_received: uint256[N_COINS] = CurveMeta(_pool).remove_liquidity(
144         _burn_amount,
145         [_min_amounts[0], convert(0, uint256)]
146     )
147 
148     # Withdraw from base
149     for i in range(BASE_N_COINS):
150         min_amounts_base[i] = _min_amounts[MAX_COIN+i]
151     CurveBase(BASE_POOL).remove_liquidity(meta_received[1], min_amounts_base)
152 
153     # Transfer all coins out
154     coin: address = CurveMeta(_pool).coins(0)
155     ERC20(coin).transfer(_receiver, meta_received[0])
156     amounts[0] = meta_received[0]
157 
158     base_coins: address[BASE_N_COINS] = BASE_COINS
159     for i in range(1, N_ALL_COINS):
160         coin = base_coins[i-1]
161         amounts[i] = ERC20(coin).balanceOf(self)
162         ERC20(coin).transfer(_receiver, amounts[i])
163 
164     return amounts
165 
166 
167 @external
168 def remove_liquidity_one_coin(
169     _pool: address,
170     _burn_amount: uint256,
171     i: int128,
172     _min_amount: uint256,
173     _receiver: address=msg.sender
174 ) -> uint256:
175     """
176     @notice Withdraw and unwrap a single coin from the pool
177     @param _pool Address of the pool to deposit into
178     @param _burn_amount Amount of LP tokens to burn in the withdrawal
179     @param i Index value of the coin to withdraw
180     @param _min_amount Minimum amount of underlying coin to receive
181     @param _receiver Address that receives the LP tokens
182     @return Amount of underlying coin received
183     """
184     ERC20(_pool).transferFrom(msg.sender, self, _burn_amount)
185 
186     coin_amount: uint256 = 0
187     if i == 0:
188         coin_amount = CurveMeta(_pool).remove_liquidity_one_coin(_burn_amount, i, _min_amount, _receiver)
189     else:
190         base_coins: address[BASE_N_COINS] = BASE_COINS
191         coin: address = base_coins[i - MAX_COIN]
192         # Withdraw a base pool coin
193         coin_amount = CurveMeta(_pool).remove_liquidity_one_coin(_burn_amount, MAX_COIN, 0, self)
194         CurveBase(BASE_POOL).remove_liquidity_one_coin(coin_amount, i-MAX_COIN, _min_amount)
195         coin_amount = ERC20(coin).balanceOf(self)
196         ERC20(coin).transfer(_receiver, coin_amount)
197 
198     return coin_amount
199 
200 
201 @external
202 def remove_liquidity_imbalance(
203     _pool: address,
204     _amounts: uint256[N_ALL_COINS],
205     _max_burn_amount: uint256,
206     _receiver: address=msg.sender
207 ) -> uint256:
208     """
209     @notice Withdraw coins from the pool in an imbalanced amount
210     @param _pool Address of the pool to deposit into
211     @param _amounts List of amounts of underlying coins to withdraw
212     @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
213     @param _receiver Address that receives the LP tokens
214     @return Actual amount of the LP token burned in the withdrawal
215     """
216     fee: uint256 = CurveBase(BASE_POOL).fee() * BASE_N_COINS / (4 * (BASE_N_COINS - 1))
217     fee += fee * FEE_IMPRECISION / FEE_DENOMINATOR  # Overcharge to account for imprecision
218 
219     # Transfer the LP token in
220     ERC20(_pool).transferFrom(msg.sender, self, _max_burn_amount)
221 
222     withdraw_base: bool = False
223     amounts_base: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
224     amounts_meta: uint256[N_COINS] = empty(uint256[N_COINS])
225 
226     # determine amounts to withdraw from base pool
227     for i in range(BASE_N_COINS):
228         amount: uint256 = _amounts[MAX_COIN + i]
229         if amount != 0:
230             amounts_base[i] = amount
231             withdraw_base = True
232 
233     # determine amounts to withdraw from metapool
234     amounts_meta[0] = _amounts[0]
235     if withdraw_base:
236         amounts_meta[MAX_COIN] = CurveBase(BASE_POOL).calc_token_amount(amounts_base, False)
237         amounts_meta[MAX_COIN] += amounts_meta[MAX_COIN] * fee / FEE_DENOMINATOR + 1
238 
239     # withdraw from metapool and return the remaining LP tokens
240     burn_amount: uint256 = CurveMeta(_pool).remove_liquidity_imbalance(amounts_meta, _max_burn_amount)
241     ERC20(_pool).transfer(msg.sender, _max_burn_amount - burn_amount)
242 
243     # withdraw from base pool
244     if withdraw_base:
245         CurveBase(BASE_POOL).remove_liquidity_imbalance(amounts_base, amounts_meta[MAX_COIN])
246         coin: address = BASE_LP_TOKEN
247         leftover: uint256 = ERC20(coin).balanceOf(self)
248 
249         if leftover > 0:
250             # if some base pool LP tokens remain, re-deposit them for the caller
251             if not self.is_approved[coin][_pool]:
252                 ERC20(coin).approve(_pool, MAX_UINT256)
253                 self.is_approved[coin][_pool] = True
254             burn_amount -= CurveMeta(_pool).add_liquidity([convert(0, uint256), leftover], 0, msg.sender)
255 
256         # transfer withdrawn base pool tokens to caller
257         base_coins: address[BASE_N_COINS] = BASE_COINS
258         for i in range(BASE_N_COINS):
259             ERC20(base_coins[i]).transfer(_receiver, amounts_base[i])
260 
261     # transfer withdrawn metapool tokens to caller
262     if _amounts[0] > 0:
263         coin: address = CurveMeta(_pool).coins(0)
264         ERC20(coin).transfer(_receiver, _amounts[0])
265 
266     return burn_amount
267 
268 
269 @view
270 @external
271 def calc_withdraw_one_coin(_pool: address, _token_amount: uint256, i: int128) -> uint256:
272     """
273     @notice Calculate the amount received when withdrawing and unwrapping a single coin
274     @param _pool Address of the pool to deposit into
275     @param _token_amount Amount of LP tokens to burn in the withdrawal
276     @param i Index value of the underlying coin to withdraw
277     @return Amount of coin received
278     """
279     if i < MAX_COIN:
280         return CurveMeta(_pool).calc_withdraw_one_coin(_token_amount, i)
281     else:
282         _base_tokens: uint256 = CurveMeta(_pool).calc_withdraw_one_coin(_token_amount, MAX_COIN)
283         return CurveBase(BASE_POOL).calc_withdraw_one_coin(_base_tokens, i-MAX_COIN)
284 
285 
286 @view
287 @external
288 def calc_token_amount(_pool: address, _amounts: uint256[N_ALL_COINS], _is_deposit: bool) -> uint256:
289     """
290     @notice Calculate addition or reduction in token supply from a deposit or withdrawal
291     @dev This calculation accounts for slippage, but not fees.
292          Needed to prevent front-running, not for precise calculations!
293     @param _pool Address of the pool to deposit into
294     @param _amounts Amount of each underlying coin being deposited
295     @param _is_deposit set True for deposits, False for withdrawals
296     @return Expected amount of LP tokens received
297     """
298     meta_amounts: uint256[N_COINS] = empty(uint256[N_COINS])
299     base_amounts: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])
300 
301     meta_amounts[0] = _amounts[0]
302     for i in range(BASE_N_COINS):
303         base_amounts[i] = _amounts[i + MAX_COIN]
304 
305     base_tokens: uint256 = CurveBase(BASE_POOL).calc_token_amount(base_amounts, _is_deposit)
306     meta_amounts[MAX_COIN] = base_tokens
307 
308     return CurveMeta(_pool).calc_token_amount(meta_amounts, _is_deposit)