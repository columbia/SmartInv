1 # @version 0.3.9
2 """
3 @title YCRV Zap v3
4 @license GNU AGPLv3
5 @author Yearn Finance
6 @notice Zap into yCRV ecosystem positions in a single transaction
7 @dev To use safely, supply a reasonable min_out value during your zap.
8 """
9 
10 from vyper.interfaces import ERC20
11 from vyper.interfaces import ERC20Detailed
12 
13 interface Vault:
14     def deposit(amount: uint256, recipient: address = msg.sender) -> uint256: nonpayable
15     def withdraw(shares: uint256) -> uint256: nonpayable
16     def pricePerShare() -> uint256: view
17 
18 interface IYCRV:
19     def burn_to_mint(amount: uint256, recipient: address = msg.sender) -> uint256: nonpayable
20     def mint(amount: uint256, recipient: address = msg.sender) -> uint256: nonpayable
21 
22 interface Curve:
23     def get_virtual_price() -> uint256: view
24     def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view
25     def exchange(i: int128, j: int128, _dx: uint256, _min_dy: uint256) -> uint256: nonpayable
26     def add_liquidity(amounts: uint256[2], min_mint_amount: uint256) -> uint256: nonpayable
27     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256) -> uint256: nonpayable
28     def remove_liquidity(_burn_amount: uint256, _min_amounts: uint256[2]) -> uint256[2]: nonpayable
29     def calc_token_amount(amounts: uint256[2], deposit: bool) -> uint256: view
30     def calc_withdraw_one_coin(_burn_amount: uint256, i: int128, _previous: bool = False) -> uint256: view
31     def totalSupply() -> uint256: view
32     def balances(index: uint256) -> uint256: view
33 
34 event UpdateSweepRecipient:
35     sweep_recipient: indexed(address)
36 
37 event UpdateMintBuffer:
38     mint_buffer: uint256
39 
40 YVECRV: constant(address) =     0xc5bDdf9843308380375a611c18B50Fb9341f502A # YVECRV
41 CRV: constant(address) =        0xD533a949740bb3306d119CC777fa900bA034cd52 # CRV
42 YVBOOST: constant(address) =    0x9d409a0A012CFbA9B15F6D4B36Ac57A46966Ab9a # YVBOOST
43 YCRV: constant(address) =       0xFCc5c47bE19d06BF83eB04298b026F81069ff65b # YCRV
44 STYCRV: constant(address) =     0x27B5739e22ad9033bcBf192059122d163b60349D # ST-YCRV
45 LPYCRV_V1: constant(address) =  0xc97232527B62eFb0D8ed38CF3EA103A6CcA4037e # LP-YCRV Deprecated
46 LPYCRV_V2: constant(address) =  0x6E9455D109202b426169F0d8f01A3332DAE160f3 # LP-YCRV
47 POOL_V1: constant(address) =    0x453D92C7d4263201C69aACfaf589Ed14202d83a4 # OLD POOL
48 POOL_V2: constant(address) =    0x99f5aCc8EC2Da2BC0771c32814EFF52b712de1E5 # NEW POOL
49 CVXCRV: constant(address) =     0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7 # CVXCRV
50 CVXCRVPOOL: constant(address) = 0x9D0464996170c6B9e75eED71c68B99dDEDf279e8 # CVXCRVPOOL
51 LEGACY_TOKENS: public(immutable(address[2]))
52 OUTPUT_TOKENS: public(immutable(address[3]))
53 
54 sweep_recipient: public(address)
55 mint_buffer: public(uint256)
56 
57 @external
58 @view
59 def name() -> String[32]:
60     return "YCRV Zap v3"
61 
62 @external
63 def __init__():
64     self.sweep_recipient = 0xFEB4acf3df3cDEA7399794D0869ef76A6EfAff52
65     self.mint_buffer = 15
66 
67     assert ERC20(YVECRV).approve(YCRV, max_value(uint256))
68     assert ERC20(YCRV).approve(STYCRV, max_value(uint256))
69     assert ERC20(YCRV).approve(POOL_V2, max_value(uint256))
70     assert ERC20(POOL_V2).approve(LPYCRV_V2, max_value(uint256))
71     assert ERC20(CRV).approve(POOL_V2, max_value(uint256))
72     assert ERC20(CRV).approve(YCRV, max_value(uint256))
73     assert ERC20(CVXCRV).approve(CVXCRVPOOL, max_value(uint256))
74 
75     LEGACY_TOKENS = [YVECRV, YVBOOST]
76     OUTPUT_TOKENS = [YCRV, STYCRV, LPYCRV_V2]
77 
78 @external
79 def zap(_input_token: address, _output_token: address, _amount_in: uint256 = max_value(uint256), _min_out: uint256 = 0, _recipient: address = msg.sender) -> uint256:
80     """
81     @notice 
82         This function allows users to zap from any legacy tokens, CRV, or any yCRV tokens as input 
83         into any yCRV token as output.
84     @dev 
85         When zapping between tokens that might incur slippage, it is recommended to supply a _min_out value > 0.
86         You can estimate the expected output amount by making an off-chain call to this contract's 
87         "calc_expected_out" helper.
88         Discount the result by some extra % to allow buffer, and set as _min_out.
89     @param _input_token Can be CRV, yveCRV, yvBOOST, cvxCRV or any yCRV token address that user wishes to migrate from
90     @param _output_token The yCRV token address that user wishes to migrate to
91     @param _amount_in Amount of input token to migrate, defaults to full balance
92     @param _min_out The minimum amount of output token to receive
93     @param _recipient The address where the output token should be sent
94     @return Amount of output token transferred to the _recipient
95     """
96     assert _amount_in > 0
97     assert _input_token != _output_token # dev: input and output token are same
98     assert _output_token in OUTPUT_TOKENS  # dev: invalid output token address
99 
100     amount: uint256 = _amount_in
101     if amount == max_value(uint256):
102         amount = ERC20(_input_token).balanceOf(msg.sender)
103 
104     if _input_token in LEGACY_TOKENS:
105         return self._zap_from_legacy(_input_token, _output_token, amount, _min_out, _recipient)
106     elif _input_token == CRV or _input_token == CVXCRV:
107         assert ERC20(_input_token).transferFrom(msg.sender, self, amount)
108         if _input_token == CVXCRV:
109             amount = Curve(CVXCRVPOOL).exchange(1, 0, amount, 0)
110         amount = self._convert_crv(amount)
111     elif _input_token in [LPYCRV_V1, POOL_V1]:
112         # If this input token path is chosen, we assume it is a migration. 
113         # This allows us to hardcode a single route, 
114         # no need for many permutations to all possible outputs.
115         assert _output_token == LPYCRV_V2
116         assert ERC20(_input_token).transferFrom(msg.sender, self, amount)
117         if _input_token == LPYCRV_V1:
118             amount = Vault(LPYCRV_V1).withdraw(amount)
119         amounts: uint256[2] = Curve(POOL_V1).remove_liquidity(amount, [0,0])
120         amount = Curve(POOL_V2).add_liquidity(amounts, 0)
121         amount = Vault(LPYCRV_V2).deposit(amount, _recipient)
122         assert amount >= _min_out
123         return amount
124     else:
125         assert _input_token in OUTPUT_TOKENS or _input_token == POOL_V2 # dev: invalid input token address
126         assert ERC20(_input_token).transferFrom(msg.sender, self, amount)
127 
128     if _input_token == STYCRV:
129         amount = Vault(STYCRV).withdraw(amount)
130     elif _input_token in [LPYCRV_V2, POOL_V2]:
131         if _input_token == LPYCRV_V2:
132             amount = Vault(LPYCRV_V2).withdraw(amount)
133         amount = Curve(POOL_V2).remove_liquidity_one_coin(amount, 1, 0)
134 
135     if _output_token == YCRV:
136         assert amount >= _min_out # dev: min out
137         ERC20(_output_token).transfer(_recipient, amount)
138         return amount
139     return self._convert_to_output(_output_token, amount, _min_out, _recipient)
140 
141 @internal
142 def _zap_from_legacy(_input_token: address, _output_token: address, _amount: uint256, _min_out: uint256, _recipient: address) -> uint256:
143     # @dev This function handles any inputs that are legacy tokens (yveCRV, yvBOOST)
144     amount: uint256 = _amount
145     assert ERC20(_input_token).transferFrom(msg.sender, self, amount)
146     if _input_token == YVBOOST:
147         amount = Vault(YVBOOST).withdraw(amount)
148 
149     # Mint YCRV
150     if _output_token == YCRV:
151         IYCRV(YCRV).burn_to_mint(amount, _recipient)
152         assert amount >= _min_out # dev: min out
153         return amount
154     IYCRV(YCRV).burn_to_mint(amount)
155     return self._convert_to_output(_output_token, amount, _min_out, _recipient)
156     
157 @internal
158 def _convert_crv(amount: uint256) -> uint256:
159     output_amount: uint256 = Curve(POOL_V2).get_dy(0, 1, amount)
160     buffered_amount: uint256 = amount + (amount * self.mint_buffer / 10_000)
161     if output_amount > buffered_amount:
162         return Curve(POOL_V2).exchange(0, 1, amount, 0)
163     else:
164         return IYCRV(YCRV).mint(amount)
165 
166 @internal
167 def _lp(_amounts: uint256[2]) -> uint256:
168     return Curve(POOL_V2).add_liquidity(_amounts, 0)
169 
170 @internal
171 def _convert_to_output(_output_token: address, amount: uint256, _min_out: uint256, _recipient: address) -> uint256:
172     # dev: output token and amount values have already been validated
173     if _output_token == STYCRV:
174         amount_out: uint256 = Vault(STYCRV).deposit(amount, _recipient)
175         assert amount_out >= _min_out # dev: min out
176         return amount_out
177     assert _output_token == LPYCRV_V2
178     amount_out: uint256 = Vault(LPYCRV_V2).deposit(self._lp([0, amount]), _recipient)
179     assert amount_out >= _min_out # dev: min out
180     return amount_out
181 
182 @view
183 @internal
184 def _relative_price_from_legacy(_input_token: address, _output_token: address, _amount_in: uint256) -> uint256:
185     if _amount_in == 0:
186         return 0
187 
188     amount: uint256 = _amount_in
189     if _input_token == YVBOOST:
190         amount = Vault(YVBOOST).pricePerShare() * amount / 10 ** 18
191     
192     if _output_token == YCRV:
193         return amount
194     elif _output_token == STYCRV:
195         return amount * 10 ** 18 / Vault(STYCRV).pricePerShare()
196     assert _output_token == LPYCRV_V2
197     lp_amount: uint256 = amount * 10 ** 18 / Curve(POOL_V2).get_virtual_price()
198     return lp_amount * 10 ** 18 / Vault(LPYCRV_V2).pricePerShare()
199 
200 @view
201 @external
202 def relative_price(_input_token: address, _output_token: address, _amount_in: uint256) -> uint256:
203     """
204     @notice 
205         This returns a rough amount of output assuming there's a balanced liquidity pool.
206         The return value should not be relied upon for an accurate estimate for actual output amount.
207     @dev 
208         This value should only be used to compare against "calc_expected_out_from_legacy" to project price impact.
209     @param _input_token The token to migrate from
210     @param _output_token The yCRV token to migrate to
211     @param _amount_in Amount of input token to migrate, defaults to full balance
212     @return Amount of output token transferred to the _recipient
213     """
214     assert _output_token in OUTPUT_TOKENS  # dev: invalid output token address
215     if _input_token in LEGACY_TOKENS:
216         return self._relative_price_from_legacy(_input_token, _output_token, _amount_in)
217     assert  (
218         _input_token in [CRV , CVXCRV , LPYCRV_V1 , POOL_V1, POOL_V2]
219         or _input_token in OUTPUT_TOKENS
220     ) # dev: invalid input token address
221 
222     if _amount_in == 0:
223         return 0
224     amount: uint256 = _amount_in
225     if _input_token == _output_token:
226         return _amount_in
227     elif _input_token == STYCRV:
228         amount = Vault(STYCRV).pricePerShare() * amount / 10 ** 18
229     elif _input_token in [LPYCRV_V2, POOL_V2]:
230         if _input_token == LPYCRV_V2:
231             amount = Vault(LPYCRV_V2).pricePerShare() * amount / 10 ** 18
232         amount = Curve(POOL_V2).get_virtual_price() * amount / 10 ** 18
233     elif _input_token in [LPYCRV_V1, POOL_V1]:
234         assert _output_token == LPYCRV_V2
235         if _input_token == LPYCRV_V1:
236             amount = Vault(LPYCRV_V1).pricePerShare() * amount / 10 ** 18
237         amount = Curve(POOL_V1).get_virtual_price() * amount / 10 ** 18
238 
239     if _output_token == YCRV:
240         return amount
241     elif _output_token == STYCRV:
242         return amount * 10 ** 18 / Vault(STYCRV).pricePerShare()
243 
244     assert _output_token == LPYCRV_V2
245     lp_amount: uint256 = amount * 10 ** 18 / Curve(POOL_V2).get_virtual_price()
246     return lp_amount * 10 ** 18 / Vault(LPYCRV_V2).pricePerShare()
247 
248 @view
249 @internal
250 def _calc_expected_out_from_legacy(_input_token: address, _output_token: address, _amount_in: uint256) -> uint256:
251     if _amount_in == 0:
252         return 0
253     amount: uint256 = _amount_in
254     if _input_token == YVBOOST:
255         amount = Vault(YVBOOST).pricePerShare() * amount / 10 ** 18
256     
257     if _output_token == YCRV:
258         return amount
259     elif _output_token == STYCRV:
260         return amount * 10 ** 18 / Vault(STYCRV).pricePerShare()
261     assert _output_token == LPYCRV_V2
262     lp_amount: uint256 = Curve(POOL_V2).calc_token_amount([0, amount], True)
263     return lp_amount * 10 ** 18 / Vault(LPYCRV_V2).pricePerShare()
264 
265 @view
266 @external
267 def calc_expected_out(_input_token: address, _output_token: address, _amount_in: uint256) -> uint256:
268     """
269     @notice 
270         This returns the expected amount of tokens output after conversion.
271     @dev
272         This calculation accounts for slippage, but not fees.
273         Needed to prevent front-running, do not rely on it for precise calculations!
274     @param _input_token A valid input token address to migrate from
275     @param _output_token The yCRV token address to migrate to
276     @param _amount_in Amount of input token to migrate, defaults to full balance
277     @return Amount of output token transferred to the _recipient
278     """
279     assert _output_token in OUTPUT_TOKENS  # dev: invalid output token address
280     assert _input_token != _output_token
281     if _input_token in LEGACY_TOKENS:
282         return self._calc_expected_out_from_legacy(_input_token, _output_token, _amount_in)
283     amount: uint256 = _amount_in
284 
285     if _input_token == CRV or _input_token == CVXCRV:
286         if _input_token == CVXCRV:
287             amount = Curve(CVXCRVPOOL).get_dy(1, 0, amount)
288         output_amount: uint256 = Curve(POOL_V2).get_dy(0, 1, amount)
289         buffered_amount: uint256 = amount + (amount * self.mint_buffer / 10_000)
290         if output_amount > buffered_amount: # dev: ensure calculation uses buffer
291             amount = output_amount
292     elif _input_token in [LPYCRV_V1, POOL_V1]:
293         assert _output_token == LPYCRV_V2
294         if _input_token == LPYCRV_V1:
295             amount = Vault(LPYCRV_V1).pricePerShare() * amount / 10 ** 18
296         amounts: uint256[2] = self.assets_amounts_from_lp(POOL_V1, amount)
297         amount = Curve(POOL_V2).calc_token_amount(amounts, True) # Deposit
298         return amount * 10 ** 18 / Vault(LPYCRV_V2).pricePerShare()
299     else:
300         assert _input_token in OUTPUT_TOKENS or _input_token == POOL_V2   # dev: invalid input token address
301     
302     if amount == 0:
303         return 0
304 
305     if _input_token == STYCRV:
306         amount = Vault(STYCRV).pricePerShare() * amount / 10 ** 18
307     elif _input_token in [LPYCRV_V2, POOL_V2]:
308         if _input_token == LPYCRV_V2:
309             amount = Vault(LPYCRV_V2).pricePerShare() * amount / 10 ** 18
310         amount = Curve(POOL_V2).calc_withdraw_one_coin(amount, 1)
311 
312     if _output_token == YCRV:
313         return amount
314     elif _output_token == STYCRV:
315         return amount * 10 ** 18 / Vault(STYCRV).pricePerShare()
316     
317     assert _output_token == LPYCRV_V2
318     lp_amount: uint256 = Curve(POOL_V2).calc_token_amount([0, amount], True)
319     return lp_amount * 10 ** 18 / Vault(LPYCRV_V2).pricePerShare()
320 
321 @view
322 @internal
323 def assets_amounts_from_lp(pool: address, _lp_amount: uint256) -> uint256[2]:
324     supply: uint256 = Curve(pool).totalSupply()
325     ratio: uint256 = _lp_amount * 10 ** 18 / supply
326     balance0: uint256 = Curve(pool).balances(0) * ratio / 10 ** 18
327     balance1: uint256 = Curve(pool).balances(1) * ratio / 10 ** 18
328     return [balance0, balance1]
329 
330 @external
331 def sweep(_token: address, _amount: uint256 = max_value(uint256)):
332     assert msg.sender == self.sweep_recipient
333     value: uint256 = _amount
334     if value == max_value(uint256):
335         value = ERC20(_token).balanceOf(self)
336     assert ERC20(_token).transfer(self.sweep_recipient, value, default_return_value=True)
337 
338 @external
339 def set_mint_buffer(_new_buffer: uint256):
340     """
341     @notice 
342         Allow SWEEP_RECIPIENT to express a preference towards minting over swapping 
343         to save gas and improve overall locked position
344     @param _new_buffer New percentage (expressed in BPS) to nudge zaps towards minting
345     """
346     assert msg.sender == self.sweep_recipient
347     assert _new_buffer < 500 # dev: buffer too high
348     self.mint_buffer = _new_buffer
349     log UpdateMintBuffer(_new_buffer)
350 
351 @external
352 def set_sweep_recipient(_proposed_sweep_recipient: address):
353     assert msg.sender == self.sweep_recipient
354     self.sweep_recipient = _proposed_sweep_recipient
355     log UpdateSweepRecipient(_proposed_sweep_recipient)