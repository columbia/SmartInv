1 # @version 0.3.7
2 
3 from vyper.interfaces import ERC20
4 from vyper.interfaces import ERC20Detailed
5 
6 interface Vault:
7     def deposit(amount: uint256, recipient: address = msg.sender) -> uint256: nonpayable
8     def withdraw(shares: uint256) -> uint256: nonpayable
9     def pricePerShare() -> uint256: view
10 
11 interface IYCRV:
12     def burn_to_mint(amount: uint256, recipient: address = msg.sender) -> uint256: nonpayable
13     def mint(amount: uint256, recipient: address = msg.sender) -> uint256: nonpayable
14 
15 interface Curve:
16     def get_virtual_price() -> uint256: view
17     def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view
18     def exchange(i: int128, j: int128, _dx: uint256, _min_dy: uint256) -> uint256: nonpayable
19     def add_liquidity(amounts: uint256[2], min_mint_amount: uint256) -> uint256: nonpayable
20     def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256) -> uint256: nonpayable
21     def calc_token_amount(amounts: uint256[2], deposit: bool) -> uint256: view
22     def calc_withdraw_one_coin(_burn_amount: uint256, i: int128, _previous: bool = False) -> uint256: view
23 
24 event UpdateSweepRecipient:
25     sweep_recipient: indexed(address)
26 
27 event UpdateMintBuffer:
28     mint_buffer: uint256
29 
30 YVECRV: constant(address) =     0xc5bDdf9843308380375a611c18B50Fb9341f502A # YVECRV
31 CRV: constant(address) =        0xD533a949740bb3306d119CC777fa900bA034cd52 # CRV
32 YVBOOST: constant(address) =    0x9d409a0A012CFbA9B15F6D4B36Ac57A46966Ab9a # YVBOOST
33 YCRV: constant(address) =       0xFCc5c47bE19d06BF83eB04298b026F81069ff65b # YCRV
34 STYCRV: constant(address) =     0x27B5739e22ad9033bcBf192059122d163b60349D # ST-YCRV
35 LPYCRV: constant(address) =     0xc97232527B62eFb0D8ed38CF3EA103A6CcA4037e # LP-YCRV
36 POOL: constant(address) =       0x453D92C7d4263201C69aACfaf589Ed14202d83a4 # POOL
37 CVXCRV: constant(address) =     0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7 # CVXCRV
38 CVXCRVPOOL: constant(address) = 0x9D0464996170c6B9e75eED71c68B99dDEDf279e8 # CVXCRVPOOL
39 
40 name: public(String[32])
41 sweep_recipient: public(address)
42 mint_buffer: public(uint256)
43 
44 legacy_tokens: public(address[2])
45 output_tokens: public(address[3])
46 
47 @external
48 def __init__():
49     self.name = "Zap: YCRV v2"
50     self.sweep_recipient = 0xFEB4acf3df3cDEA7399794D0869ef76A6EfAff52
51     self.mint_buffer = 50
52 
53     assert ERC20(YVECRV).approve(YCRV, max_value(uint256))
54     assert ERC20(YCRV).approve(STYCRV, max_value(uint256))
55     assert ERC20(YCRV).approve(POOL, max_value(uint256))
56     assert ERC20(POOL).approve(LPYCRV, max_value(uint256))
57     assert ERC20(CRV).approve(POOL, max_value(uint256))
58     assert ERC20(CRV).approve(YCRV, max_value(uint256))
59     assert ERC20(CVXCRV).approve(CVXCRVPOOL, max_value(uint256))
60 
61     self.legacy_tokens = [YVECRV, YVBOOST]
62     self.output_tokens = [YCRV, STYCRV, LPYCRV]
63 
64 @internal
65 def _convert_crv(amount: uint256) -> uint256:
66     output_amount: uint256 = Curve(POOL).get_dy(0, 1, amount)
67     buffered_amount: uint256 = amount + (amount * self.mint_buffer / 10_000)
68     if output_amount > buffered_amount:
69         return Curve(POOL).exchange(0, 1, amount, 0)
70     else:
71         return IYCRV(YCRV).mint(amount)
72 
73 @internal
74 def _lp(_amounts: uint256[2]) -> uint256:
75     return Curve(POOL).add_liquidity(_amounts, 0)
76 
77 @internal
78 def _convert_to_output(_output_token: address, amount: uint256, _min_out: uint256, _recipient: address) -> uint256:
79     # dev: output token and amount values have already been validated
80     if _output_token == STYCRV:
81         amount_out: uint256 = Vault(STYCRV).deposit(amount, _recipient)
82         assert amount_out >= _min_out # dev: min out
83         return amount_out
84     assert _output_token == LPYCRV
85     amount_out: uint256 = Vault(LPYCRV).deposit(self._lp([0, amount]), _recipient)
86     assert amount_out >= _min_out # dev: min out
87     return amount_out
88 
89 @internal
90 def _zap_from_legacy(_input_token: address, _output_token: address, _amount: uint256, _min_out: uint256, _recipient: address) -> uint256:
91     # @dev This function handles any inputs that are legacy tokens (yveCRV, yvBOOST)
92     amount: uint256 = _amount
93     assert ERC20(_input_token).transferFrom(msg.sender, self, amount)
94     if _input_token == YVBOOST:
95         amount = Vault(YVBOOST).withdraw(amount)
96 
97     # Mint YCRV
98     if _output_token == YCRV:
99         IYCRV(YCRV).burn_to_mint(amount, _recipient)
100         assert amount >= _min_out # dev: min out
101         return amount
102     IYCRV(YCRV).burn_to_mint(amount)
103     return self._convert_to_output(_output_token, amount, _min_out, _recipient)
104     
105 
106 @external
107 def zap(_input_token: address, _output_token: address, _amount_in: uint256 = max_value(uint256), _min_out: uint256 = 0, _recipient: address = msg.sender) -> uint256:
108     """
109     @notice 
110         This function allows users to zap from any legacy tokens, CRV, or any yCRV tokens as input 
111         into any yCRV token as output.
112     @dev 
113         When zapping between tokens that might incur slippage, it is recommended to supply a _min_out value > 0.
114         You can estimate the expected output amount by making an off-chain call to this contract's 
115         "calc_expected_out" helper.
116         Discount the result by some extra % to allow buffer, and set as _min_out.
117     @param _input_token Can be CRV, yveCRV, yvBOOST, cvxCRV or any yCRV token address that user wishes to migrate from
118     @param _output_token The yCRV token address that user wishes to migrate to
119     @param _amount_in Amount of input token to migrate, defaults to full balance
120     @param _min_out The minimum amount of output token to receive
121     @param _recipient The address where the output token should be sent
122     @return Amount of output token transferred to the _recipient
123     """
124     assert _amount_in > 0
125     assert _input_token != _output_token # dev: input and output token are same
126     assert _output_token in self.output_tokens  # dev: invalid output token address
127 
128     amount: uint256 = _amount_in
129     if amount == max_value(uint256):
130         amount = ERC20(_input_token).balanceOf(msg.sender)
131 
132     if _input_token in self.legacy_tokens:
133         return self._zap_from_legacy(_input_token, _output_token, amount, _min_out, _recipient)
134     elif _input_token == CRV or _input_token == CVXCRV:
135         assert ERC20(_input_token).transferFrom(msg.sender, self, amount)
136         if _input_token == CVXCRV:
137             amount = Curve(CVXCRVPOOL).exchange(1, 0, amount, 0)
138         amount = self._convert_crv(amount)
139     else:
140         assert _input_token in self.output_tokens   # dev: invalid input token address
141         assert ERC20(_input_token).transferFrom(msg.sender, self, amount)
142 
143     if _input_token == STYCRV:
144         amount = Vault(STYCRV).withdraw(amount)
145     elif _input_token == LPYCRV:
146         lp_amount: uint256 = Vault(LPYCRV).withdraw(amount)
147         amount = Curve(POOL).remove_liquidity_one_coin(lp_amount, 1, 0)
148 
149     if _output_token == YCRV:
150         assert amount >= _min_out # dev: min out
151         ERC20(_output_token).transfer(_recipient, amount)
152         return amount
153     return self._convert_to_output(_output_token, amount, _min_out, _recipient)
154 
155 @external
156 def set_sweep_recipient(_proposed_sweep_recipient: address):
157     assert msg.sender == self.sweep_recipient
158     self.sweep_recipient = _proposed_sweep_recipient
159     log UpdateSweepRecipient(_proposed_sweep_recipient)
160 
161 @view
162 @internal
163 def _relative_price_from_legacy(_input_token: address, _output_token: address, _amount_in: uint256) -> uint256:
164     if _amount_in == 0:
165         return 0
166 
167     amount: uint256 = _amount_in
168     if _input_token == YVBOOST:
169         amount = Vault(YVBOOST).pricePerShare() * amount / 10 ** 18
170     
171     if _output_token == YCRV:
172         return amount
173     elif _output_token == STYCRV:
174         return amount * 10 ** 18 / Vault(STYCRV).pricePerShare()
175     assert _output_token == LPYCRV
176     lp_amount: uint256 = amount * 10 ** 18 / Curve(POOL).get_virtual_price()
177     return lp_amount * 10 ** 18 / Vault(LPYCRV).pricePerShare()
178 
179 @view
180 @external
181 def relative_price(_input_token: address, _output_token: address, _amount_in: uint256) -> uint256:
182     """
183     @notice 
184         This returns a rough amount of output assuming there's a balanced liquidity pool.
185         The return value should not be relied upon for an accurate estimate for actual output amount.
186     @dev 
187         This value should only be used to compare against "calc_expected_out_from_legacy" to project price impact.
188     @param _input_token The token to migrate from
189     @param _output_token The yCRV token to migrate to
190     @param _amount_in Amount of input token to migrate, defaults to full balance
191     @return Amount of output token transferred to the _recipient
192     """
193     assert _output_token in self.output_tokens  # dev: invalid output token address
194     if _input_token in self.legacy_tokens:
195         return self._relative_price_from_legacy(_input_token, _output_token, _amount_in)
196     assert _input_token == CRV or _input_token in self.output_tokens or _input_token == CVXCRV # dev: invalid input token address
197     
198     if _amount_in == 0:
199         return 0
200     amount: uint256 = _amount_in
201     if _input_token == _output_token:
202         return _amount_in
203     elif _input_token == STYCRV:
204         amount = Vault(STYCRV).pricePerShare() * amount / 10 ** 18
205     elif _input_token == LPYCRV:
206         lp_amount: uint256 = Vault(LPYCRV).pricePerShare() * amount / 10 ** 18
207         amount = Curve(POOL).get_virtual_price() * lp_amount / 10 ** 18
208 
209     if _output_token == YCRV:
210         return amount
211     elif _output_token == STYCRV:
212         return amount * 10 ** 18 / Vault(STYCRV).pricePerShare()
213     else:
214         assert _output_token == LPYCRV
215         lp_amount: uint256 = amount * 10 ** 18 / Curve(POOL).get_virtual_price()
216         return lp_amount * 10 ** 18 / Vault(LPYCRV).pricePerShare()
217 
218 @view
219 @internal
220 def _calc_expected_out_from_legacy(_input_token: address, _output_token: address, _amount_in: uint256) -> uint256:
221     if _amount_in == 0:
222         return 0
223 
224     amount: uint256 = _amount_in
225     if _input_token == YVBOOST:
226         amount = Vault(YVBOOST).pricePerShare() * amount / 10 ** 18
227     
228     if _output_token == YCRV:
229         return amount
230     elif _output_token == STYCRV:
231         return amount * 10 ** 18 / Vault(STYCRV).pricePerShare()
232     assert _output_token == LPYCRV
233     lp_amount: uint256 = Curve(POOL).calc_token_amount([0, amount], True)
234     return lp_amount * 10 ** 18 / Vault(LPYCRV).pricePerShare()
235 
236 @view
237 @external
238 def calc_expected_out(_input_token: address, _output_token: address, _amount_in: uint256) -> uint256:
239     """
240     @notice 
241         This returns the expected amount of tokens output after conversion.
242     @dev
243         This calculation accounts for slippage, but not fees.
244         Needed to prevent front-running, do not rely on it for precise calculations!
245     @param _input_token A valid input token address to migrate from
246     @param _output_token The yCRV token address to migrate to
247     @param _amount_in Amount of input token to migrate, defaults to full balance
248     @return Amount of output token transferred to the _recipient
249     """
250     assert _output_token in self.output_tokens  # dev: invalid output token address
251     if _input_token in self.legacy_tokens:
252         return self._calc_expected_out_from_legacy(_input_token, _output_token, _amount_in)
253     amount: uint256 = _amount_in
254     if _input_token == CRV or _input_token == CVXCRV:
255         if _input_token == CVXCRV:
256             amount = Curve(CVXCRVPOOL).get_dy(1, 0, amount)
257         output_amount: uint256 = Curve(POOL).get_dy(0, 1, amount)
258         if output_amount > amount:
259             amount = output_amount
260     else:
261         assert _input_token in self.output_tokens   # dev: invalid input token address
262     if amount == 0:
263         return 0
264     if _input_token == _output_token:
265         return amount
266 
267     if _input_token == STYCRV:
268         amount = Vault(STYCRV).pricePerShare() * amount / 10 ** 18
269     elif _input_token == LPYCRV:
270         lp_amount: uint256 = Vault(LPYCRV).pricePerShare() * amount / 10 ** 18
271         amount = Curve(POOL).calc_withdraw_one_coin(lp_amount, 1)
272 
273     if _output_token == YCRV:
274         return amount
275     elif _output_token == STYCRV:
276         return amount * 10 ** 18 / Vault(STYCRV).pricePerShare()
277     assert _output_token == LPYCRV
278     lp_amount: uint256 = Curve(POOL).calc_token_amount([0, amount], True)
279     return lp_amount * 10 ** 18 / Vault(LPYCRV).pricePerShare()
280 
281 @external
282 def sweep(_token: address, _amount: uint256 = max_value(uint256)):
283     assert msg.sender == self.sweep_recipient
284     value: uint256 = _amount
285     if value == max_value(uint256):
286         value = ERC20(_token).balanceOf(self)
287     assert ERC20(_token).transfer(self.sweep_recipient, value, default_return_value=True)
288 
289 @external
290 def set_mint_buffer(_new_buffer: uint256):
291     assert msg.sender == self.sweep_recipient
292     assert _new_buffer < 500 # dev: buffer too high
293     self.mint_buffer = _new_buffer
294     log UpdateMintBuffer(_new_buffer)