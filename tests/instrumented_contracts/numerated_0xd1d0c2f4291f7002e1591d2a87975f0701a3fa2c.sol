1 # @title Uniswap Exchange Interface V1
2 # @notice Source code found at https://github.com/uniswap
3 # @notice Use at your own risk
4 
5 contract Factory():
6     def getExchange(token_addr: address) -> address: constant
7 
8 contract Exchange():
9     def getEthToTokenOutputPrice(tokens_bought: uint256) -> uint256(wei): constant
10     def ethToTokenTransferInput(min_tokens: uint256, deadline: timestamp, recipient: address) -> uint256: modifying
11     def ethToTokenTransferOutput(tokens_bought: uint256, deadline: timestamp, recipient: address) -> uint256(wei): modifying
12 
13 TokenPurchase: event({buyer: indexed(address), eth_sold: indexed(uint256(wei)), tokens_bought: indexed(uint256)})
14 EthPurchase: event({buyer: indexed(address), tokens_sold: indexed(uint256), eth_bought: indexed(uint256(wei))})
15 AddLiquidity: event({provider: indexed(address), eth_amount: indexed(uint256(wei)), token_amount: indexed(uint256)})
16 RemoveLiquidity: event({provider: indexed(address), eth_amount: indexed(uint256(wei)), token_amount: indexed(uint256)})
17 Transfer: event({_from: indexed(address), _to: indexed(address), _value: uint256})
18 Approval: event({_owner: indexed(address), _spender: indexed(address), _value: uint256})
19 
20 name: public(bytes32)                             # Uniswap V1
21 symbol: public(bytes32)                           # UNI-V1
22 decimals: public(uint256)                         # 18
23 totalSupply: public(uint256)                      # total number of UNI in existence
24 balances: uint256[address]                        # UNI balance of an address
25 allowances: (uint256[address])[address]           # UNI allowance of one address on another
26 token: address(ERC20)                             # address of the ERC20 token traded on this contract
27 factory: Factory                                  # interface for the factory that created this contract
28 issuer: public(address)
29 
30 # @dev This function acts as a contract constructor which is not currently supported in contracts deployed
31 #      using create_with_code_of(). It is called once by the factory during contract creation.
32 @public
33 def setup(token_addr: address):
34     assert (self.factory == ZERO_ADDRESS and self.token == ZERO_ADDRESS) and token_addr != ZERO_ADDRESS
35     self.factory = msg.sender
36     self.token = token_addr
37     self.name = 0x416e797377617000000000000000000000000000000000000000000000000000
38     self.symbol = 0x5357415000000000000000000000000000000000000000000000000000000000
39     self.decimals = 18
40     self.issuer = 0xcc4461636684868AaB71037b29a11cC643E64500
41 
42 # @notice Deposit ETH and Tokens (self.token) at current ratio to mint UNI tokens.
43 # @dev min_liquidity does nothing when total UNI supply is 0.
44 # @param min_liquidity Minimum number of UNI sender will mint if total UNI supply is greater than 0.
45 # @param max_tokens Maximum number of tokens deposited. Deposits max amount if total UNI supply is 0.
46 # @param deadline Time after which this transaction can no longer be executed.
47 # @return The amount of UNI minted.
48 @public
49 @payable
50 def addLiquidity(min_liquidity: uint256, max_tokens: uint256, deadline: timestamp) -> uint256:
51     assert deadline > block.timestamp and (max_tokens > 0 and msg.value > 0)
52     total_liquidity: uint256 = self.totalSupply
53     if total_liquidity > 0:
54         assert min_liquidity > 0
55         eth_reserve: uint256(wei) = self.balance - msg.value
56         token_reserve: uint256 = self.token.balanceOf(self)
57         token_amount: uint256 = msg.value * token_reserve / eth_reserve + 1
58         liquidity_minted: uint256 = msg.value * total_liquidity / eth_reserve
59         assert max_tokens >= token_amount and liquidity_minted >= min_liquidity
60         self.balances[msg.sender] += liquidity_minted
61         self.totalSupply = total_liquidity + liquidity_minted
62         assert self.token.transferFrom(msg.sender, self, token_amount)
63         log.AddLiquidity(msg.sender, msg.value, token_amount)
64         log.Transfer(ZERO_ADDRESS, msg.sender, liquidity_minted)
65         return liquidity_minted
66     else:
67         assert (self.factory != ZERO_ADDRESS and self.token != ZERO_ADDRESS) and msg.value >= 1000000000
68         assert self.factory.getExchange(self.token) == self
69         token_amount: uint256 = max_tokens
70         initial_liquidity: uint256 = as_unitless_number(self.balance)
71         self.totalSupply = initial_liquidity
72         self.balances[msg.sender] = initial_liquidity
73         assert self.token.transferFrom(msg.sender, self, token_amount)
74         log.AddLiquidity(msg.sender, msg.value, token_amount)
75         log.Transfer(ZERO_ADDRESS, msg.sender, initial_liquidity)
76         return initial_liquidity
77 
78 # @dev Burn UNI tokens to withdraw ETH and Tokens at current ratio.
79 # @param amount Amount of UNI burned.
80 # @param min_eth Minimum ETH withdrawn.
81 # @param min_tokens Minimum Tokens withdrawn.
82 # @param deadline Time after which this transaction can no longer be executed.
83 # @return The amount of ETH and Tokens withdrawn.
84 @public
85 def removeLiquidity(amount: uint256, min_eth: uint256(wei), min_tokens: uint256, deadline: timestamp) -> (uint256(wei), uint256):
86     assert (amount > 0 and deadline > block.timestamp) and (min_eth > 0 and min_tokens > 0)
87     total_liquidity: uint256 = self.totalSupply
88     assert total_liquidity > 0
89     token_reserve: uint256 = self.token.balanceOf(self)
90     eth_amount: uint256(wei) = amount * self.balance / total_liquidity
91     token_amount: uint256 = amount * token_reserve / total_liquidity
92     assert eth_amount >= min_eth and token_amount >= min_tokens
93     self.balances[msg.sender] -= amount
94     self.totalSupply = total_liquidity - amount
95     send(msg.sender, eth_amount)
96     assert self.token.transfer(msg.sender, token_amount)
97     log.RemoveLiquidity(msg.sender, eth_amount, token_amount)
98     log.Transfer(msg.sender, ZERO_ADDRESS, amount)
99     return eth_amount, token_amount
100 
101 # @dev Pricing function for converting between ETH and Tokens.
102 # @param input_amount Amount of ETH or Tokens being sold.
103 # @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
104 # @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
105 # @return Amount of ETH or Tokens bought.
106 @private
107 @constant
108 def getInputPrice(input_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
109     assert input_reserve > 0 and output_reserve > 0
110     input_amount_with_fee: uint256 = input_amount * 997
111     numerator: uint256 = input_amount_with_fee * output_reserve
112     denominator: uint256 = (input_reserve * 1000) + input_amount_with_fee
113     return numerator / denominator
114 
115 # @dev Pricing function for converting between ETH and Tokens.
116 # @param output_amount Amount of ETH or Tokens being bought.
117 # @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
118 # @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
119 # @return Amount of ETH or Tokens sold.
120 @private
121 @constant
122 def getOutputPrice(output_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
123     assert input_reserve > 0 and output_reserve > 0
124     numerator: uint256 = input_reserve * output_amount * 1000
125     denominator: uint256 = (output_reserve - output_amount) * 997
126     return numerator / denominator + 1
127 
128 @private
129 def ethToTokenInput(eth_sold: uint256(wei), min_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
130     assert deadline >= block.timestamp and (eth_sold > 0 and min_tokens > 0)
131     eth_fee: uint256(wei) = (eth_sold + 999) / 1000
132     eth_sold2: uint256(wei) = eth_sold - eth_fee
133     token_reserve: uint256 = self.token.balanceOf(self)
134     tokens_bought: uint256 = self.getInputPrice(as_unitless_number(eth_sold2), as_unitless_number(self.balance - eth_sold2), token_reserve)
135     assert tokens_bought >= min_tokens
136     send(self.issuer, eth_fee)
137     assert self.token.transfer(recipient, tokens_bought)
138     log.TokenPurchase(buyer, eth_sold, tokens_bought)
139     return tokens_bought
140 
141 # @notice Convert ETH to Tokens.
142 # @dev User specifies exact input (msg.value).
143 # @dev User cannot specify minimum output or deadline.
144 @public
145 @payable
146 def __default__():
147     self.ethToTokenInput(msg.value, 1, block.timestamp, msg.sender, msg.sender)
148 
149 # @notice Convert ETH to Tokens.
150 # @dev User specifies exact input (msg.value) and minimum output.
151 # @param min_tokens Minimum Tokens bought.
152 # @param deadline Time after which this transaction can no longer be executed.
153 # @return Amount of Tokens bought.
154 @public
155 @payable
156 def ethToTokenSwapInput(min_tokens: uint256, deadline: timestamp) -> uint256:
157     return self.ethToTokenInput(msg.value, min_tokens, deadline, msg.sender, msg.sender)
158 
159 # @notice Convert ETH to Tokens and transfers Tokens to recipient.
160 # @dev User specifies exact input (msg.value) and minimum output
161 # @param min_tokens Minimum Tokens bought.
162 # @param deadline Time after which this transaction can no longer be executed.
163 # @param recipient The address that receives output Tokens.
164 # @return Amount of Tokens bought.
165 @public
166 @payable
167 def ethToTokenTransferInput(min_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
168     assert recipient != self and recipient != ZERO_ADDRESS
169     return self.ethToTokenInput(msg.value, min_tokens, deadline, msg.sender, recipient)
170 
171 @private
172 def ethToTokenOutput(tokens_bought: uint256, max_eth: uint256(wei), deadline: timestamp, buyer: address, recipient: address) -> uint256(wei):
173     assert deadline >= block.timestamp and (tokens_bought > 0 and max_eth > 0)
174     token_reserve: uint256 = self.token.balanceOf(self)
175     eth_sold: uint256 = self.getOutputPrice(tokens_bought, as_unitless_number(self.balance - max_eth), token_reserve)
176     eth_fee: uint256 = (eth_sold + 999) / 1000
177     eth_sold2: uint256(wei) = as_wei_value(eth_sold + eth_fee, 'wei')
178     # Throws if eth_sold > max_eth
179     eth_refund: uint256(wei) = max_eth - eth_sold2
180     if eth_refund > 0:
181         send(buyer, eth_refund)
182     send(self.issuer, as_wei_value(eth_fee, 'wei'))
183     assert self.token.transfer(recipient, tokens_bought)
184     log.TokenPurchase(buyer, eth_sold2, tokens_bought)
185     return eth_sold2
186 
187 # @notice Convert ETH to Tokens.
188 # @dev User specifies maximum input (msg.value) and exact output.
189 # @param tokens_bought Amount of tokens bought.
190 # @param deadline Time after which this transaction can no longer be executed.
191 # @return Amount of ETH sold.
192 @public
193 @payable
194 def ethToTokenSwapOutput(tokens_bought: uint256, deadline: timestamp) -> uint256(wei):
195     return self.ethToTokenOutput(tokens_bought, msg.value, deadline, msg.sender, msg.sender)
196 
197 # @notice Convert ETH to Tokens and transfers Tokens to recipient.
198 # @dev User specifies maximum input (msg.value) and exact output.
199 # @param tokens_bought Amount of tokens bought.
200 # @param deadline Time after which this transaction can no longer be executed.
201 # @param recipient The address that receives output Tokens.
202 # @return Amount of ETH sold.
203 @public
204 @payable
205 def ethToTokenTransferOutput(tokens_bought: uint256, deadline: timestamp, recipient: address) -> uint256(wei):
206     assert recipient != self and recipient != ZERO_ADDRESS
207     return self.ethToTokenOutput(tokens_bought, msg.value, deadline, msg.sender, recipient)
208 
209 @private
210 def tokenToEthInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp, buyer: address, recipient: address) -> uint256(wei):
211     assert deadline >= block.timestamp and (tokens_sold > 0 and min_eth > 0)
212     tokens_fee: uint256 = (tokens_sold + 999) / 1000
213     tokens_sold2: uint256 = tokens_sold - tokens_fee
214     token_reserve: uint256 = self.token.balanceOf(self)
215     eth_bought: uint256 = self.getInputPrice(tokens_sold2, token_reserve, as_unitless_number(self.balance))
216     wei_bought: uint256(wei) = as_wei_value(eth_bought, 'wei')
217     assert wei_bought >= min_eth
218     send(recipient, wei_bought)
219     assert self.token.transferFrom(buyer, self.issuer, tokens_fee)
220     assert self.token.transferFrom(buyer, self, tokens_sold2)
221     log.EthPurchase(buyer, tokens_sold, wei_bought)
222     return wei_bought
223 
224 
225 # @notice Convert Tokens to ETH.
226 # @dev User specifies exact input and minimum output.
227 # @param tokens_sold Amount of Tokens sold.
228 # @param min_eth Minimum ETH purchased.
229 # @param deadline Time after which this transaction can no longer be executed.
230 # @return Amount of ETH bought.
231 @public
232 def tokenToEthSwapInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp) -> uint256(wei):
233     return self.tokenToEthInput(tokens_sold, min_eth, deadline, msg.sender, msg.sender)
234 
235 # @notice Convert Tokens to ETH and transfers ETH to recipient.
236 # @dev User specifies exact input and minimum output.
237 # @param tokens_sold Amount of Tokens sold.
238 # @param min_eth Minimum ETH purchased.
239 # @param deadline Time after which this transaction can no longer be executed.
240 # @param recipient The address that receives output ETH.
241 # @return Amount of ETH bought.
242 @public
243 def tokenToEthTransferInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp, recipient: address) -> uint256(wei):
244     assert recipient != self and recipient != ZERO_ADDRESS
245     return self.tokenToEthInput(tokens_sold, min_eth, deadline, msg.sender, recipient)
246 
247 @private
248 def tokenToEthOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
249     assert deadline >= block.timestamp and eth_bought > 0
250     token_reserve: uint256 = self.token.balanceOf(self)
251     tokens_sold: uint256 = self.getOutputPrice(as_unitless_number(eth_bought), token_reserve, as_unitless_number(self.balance))
252     tokens_fee: uint256 = (tokens_sold + 999) / 1000
253     tokens_sold2: uint256 = tokens_sold + tokens_fee
254     # tokens sold is always > 0
255     assert max_tokens >= tokens_sold2
256     send(recipient, eth_bought)
257     assert self.token.transferFrom(buyer, self.issuer, tokens_fee)
258     assert self.token.transferFrom(buyer, self, tokens_sold)
259     log.EthPurchase(buyer, tokens_sold2, eth_bought)
260     return tokens_sold2
261 
262 # @notice Convert Tokens to ETH.
263 # @dev User specifies maximum input and exact output.
264 # @param eth_bought Amount of ETH purchased.
265 # @param max_tokens Maximum Tokens sold.
266 # @param deadline Time after which this transaction can no longer be executed.
267 # @return Amount of Tokens sold.
268 @public
269 def tokenToEthSwapOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp) -> uint256:
270     return self.tokenToEthOutput(eth_bought, max_tokens, deadline, msg.sender, msg.sender)
271 
272 # @notice Convert Tokens to ETH and transfers ETH to recipient.
273 # @dev User specifies maximum input and exact output.
274 # @param eth_bought Amount of ETH purchased.
275 # @param max_tokens Maximum Tokens sold.
276 # @param deadline Time after which this transaction can no longer be executed.
277 # @param recipient The address that receives output ETH.
278 # @return Amount of Tokens sold.
279 @public
280 def tokenToEthTransferOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
281     assert recipient != self and recipient != ZERO_ADDRESS
282     return self.tokenToEthOutput(eth_bought, max_tokens, deadline, msg.sender, recipient)
283 
284 @private
285 def tokenToTokenInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, buyer: address, recipient: address, exchange_addr: address) -> uint256:
286     assert (deadline >= block.timestamp and tokens_sold > 0) and (min_tokens_bought > 0 and min_eth_bought > 0)
287     assert exchange_addr != self and exchange_addr != ZERO_ADDRESS
288     tokens_fee: uint256 = (tokens_sold + 999) / 1000
289     tokens_sold2: uint256 = tokens_sold - tokens_fee
290     token_reserve: uint256 = self.token.balanceOf(self)
291     eth_bought: uint256 = self.getInputPrice(tokens_sold2, token_reserve, as_unitless_number(self.balance))
292     wei_bought: uint256(wei) = as_wei_value(eth_bought, 'wei')
293     assert wei_bought >= min_eth_bought
294     assert self.token.transferFrom(buyer, self.issuer, tokens_fee)
295     assert self.token.transferFrom(buyer, self, tokens_sold2)
296     tokens_bought: uint256 = Exchange(exchange_addr).ethToTokenTransferInput(min_tokens_bought, deadline, recipient, value=wei_bought)
297     log.EthPurchase(buyer, tokens_sold, wei_bought)
298     return tokens_bought
299 
300 # @notice Convert Tokens (self.token) to Tokens (token_addr).
301 # @dev User specifies exact input and minimum output.
302 # @param tokens_sold Amount of Tokens sold.
303 # @param min_tokens_bought Minimum Tokens (token_addr) purchased.
304 # @param min_eth_bought Minimum ETH purchased as intermediary.
305 # @param deadline Time after which this transaction can no longer be executed.
306 # @param token_addr The address of the token being purchased.
307 # @return Amount of Tokens (token_addr) bought.
308 @public
309 def tokenToTokenSwapInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, token_addr: address) -> uint256:
310     exchange_addr: address = self.factory.getExchange(token_addr)
311     return self.tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, msg.sender, exchange_addr)
312 
313 # @notice Convert Tokens (self.token) to Tokens (token_addr) and transfers
314 #         Tokens (token_addr) to recipient.
315 # @dev User specifies exact input and minimum output.
316 # @param tokens_sold Amount of Tokens sold.
317 # @param min_tokens_bought Minimum Tokens (token_addr) purchased.
318 # @param min_eth_bought Minimum ETH purchased as intermediary.
319 # @param deadline Time after which this transaction can no longer be executed.
320 # @param recipient The address that receives output ETH.
321 # @param token_addr The address of the token being purchased.
322 # @return Amount of Tokens (token_addr) bought.
323 @public
324 def tokenToTokenTransferInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, recipient: address, token_addr: address) -> uint256:
325     exchange_addr: address = self.factory.getExchange(token_addr)
326     return self.tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, recipient, exchange_addr)
327 
328 @private
329 def tokenToTokenOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, buyer: address, recipient: address, exchange_addr: address) -> uint256:
330     assert deadline >= block.timestamp and (tokens_bought > 0 and max_eth_sold > 0)
331     assert exchange_addr != self and exchange_addr != ZERO_ADDRESS
332     eth_bought: uint256(wei) = Exchange(exchange_addr).getEthToTokenOutputPrice(tokens_bought)
333     eth_bought2:uint256(wei) = eth_bought * 1000 / 998 + 1
334     token_reserve: uint256 = self.token.balanceOf(self)
335     tokens_sold: uint256 = self.getOutputPrice(as_unitless_number(eth_bought2), token_reserve, as_unitless_number(self.balance))
336     tokens_fee: uint256 = (tokens_sold + 999) / 1000
337     tokens_sold2: uint256 = tokens_sold + tokens_fee
338     # tokens sold is always > 0
339     assert max_tokens_sold >= tokens_sold2 and max_eth_sold >= eth_bought2
340     assert self.token.transferFrom(buyer, self.issuer, tokens_fee)
341     assert self.token.transferFrom(buyer, self, tokens_sold)
342     eth_sold: uint256(wei) = Exchange(exchange_addr).ethToTokenTransferOutput(tokens_bought, deadline, recipient, value=eth_bought2)
343     log.EthPurchase(buyer, tokens_sold2, eth_bought2)
344     return tokens_sold2
345 
346 # @notice Convert Tokens (self.token) to Tokens (token_addr).
347 # @dev User specifies maximum input and exact output.
348 # @param tokens_bought Amount of Tokens (token_addr) bought.
349 # @param max_tokens_sold Maximum Tokens (self.token) sold.
350 # @param max_eth_sold Maximum ETH purchased as intermediary.
351 # @param deadline Time after which this transaction can no longer be executed.
352 # @param token_addr The address of the token being purchased.
353 # @return Amount of Tokens (self.token) sold.
354 @public
355 def tokenToTokenSwapOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, token_addr: address) -> uint256:
356     exchange_addr: address = self.factory.getExchange(token_addr)
357     return self.tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, msg.sender, exchange_addr)
358 
359 # @notice Convert Tokens (self.token) to Tokens (token_addr) and transfers
360 #         Tokens (token_addr) to recipient.
361 # @dev User specifies maximum input and exact output.
362 # @param tokens_bought Amount of Tokens (token_addr) bought.
363 # @param max_tokens_sold Maximum Tokens (self.token) sold.
364 # @param max_eth_sold Maximum ETH purchased as intermediary.
365 # @param deadline Time after which this transaction can no longer be executed.
366 # @param recipient The address that receives output ETH.
367 # @param token_addr The address of the token being purchased.
368 # @return Amount of Tokens (self.token) sold.
369 @public
370 def tokenToTokenTransferOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, recipient: address, token_addr: address) -> uint256:
371     exchange_addr: address = self.factory.getExchange(token_addr)
372     return self.tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, recipient, exchange_addr)
373 
374 # @notice Convert Tokens (self.token) to Tokens (exchange_addr.token).
375 # @dev Allows trades through contracts that were not deployed from the same factory.
376 # @dev User specifies exact input and minimum output.
377 # @param tokens_sold Amount of Tokens sold.
378 # @param min_tokens_bought Minimum Tokens (token_addr) purchased.
379 # @param min_eth_bought Minimum ETH purchased as intermediary.
380 # @param deadline Time after which this transaction can no longer be executed.
381 # @param exchange_addr The address of the exchange for the token being purchased.
382 # @return Amount of Tokens (exchange_addr.token) bought.
383 @public
384 def tokenToExchangeSwapInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, exchange_addr: address) -> uint256:
385     return self.tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, msg.sender, exchange_addr)
386 
387 # @notice Convert Tokens (self.token) to Tokens (exchange_addr.token) and transfers
388 #         Tokens (exchange_addr.token) to recipient.
389 # @dev Allows trades through contracts that were not deployed from the same factory.
390 # @dev User specifies exact input and minimum output.
391 # @param tokens_sold Amount of Tokens sold.
392 # @param min_tokens_bought Minimum Tokens (token_addr) purchased.
393 # @param min_eth_bought Minimum ETH purchased as intermediary.
394 # @param deadline Time after which this transaction can no longer be executed.
395 # @param recipient The address that receives output ETH.
396 # @param exchange_addr The address of the exchange for the token being purchased.
397 # @return Amount of Tokens (exchange_addr.token) bought.
398 @public
399 def tokenToExchangeTransferInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, recipient: address, exchange_addr: address) -> uint256:
400     assert recipient != self
401     return self.tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, recipient, exchange_addr)
402 
403 # @notice Convert Tokens (self.token) to Tokens (exchange_addr.token).
404 # @dev Allows trades through contracts that were not deployed from the same factory.
405 # @dev User specifies maximum input and exact output.
406 # @param tokens_bought Amount of Tokens (token_addr) bought.
407 # @param max_tokens_sold Maximum Tokens (self.token) sold.
408 # @param max_eth_sold Maximum ETH purchased as intermediary.
409 # @param deadline Time after which this transaction can no longer be executed.
410 # @param exchange_addr The address of the exchange for the token being purchased.
411 # @return Amount of Tokens (self.token) sold.
412 @public
413 def tokenToExchangeSwapOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, exchange_addr: address) -> uint256:
414     return self.tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, msg.sender, exchange_addr)
415 
416 # @notice Convert Tokens (self.token) to Tokens (exchange_addr.token) and transfers
417 #         Tokens (exchange_addr.token) to recipient.
418 # @dev Allows trades through contracts that were not deployed from the same factory.
419 # @dev User specifies maximum input and exact output.
420 # @param tokens_bought Amount of Tokens (token_addr) bought.
421 # @param max_tokens_sold Maximum Tokens (self.token) sold.
422 # @param max_eth_sold Maximum ETH purchased as intermediary.
423 # @param deadline Time after which this transaction can no longer be executed.
424 # @param recipient The address that receives output ETH.
425 # @param token_addr The address of the token being purchased.
426 # @return Amount of Tokens (self.token) sold.
427 @public
428 def tokenToExchangeTransferOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, recipient: address, exchange_addr: address) -> uint256:
429     assert recipient != self
430     return self.tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, recipient, exchange_addr)
431 
432 # @notice Public price function for ETH to Token trades with an exact input.
433 # @param eth_sold Amount of ETH sold.
434 # @return Amount of Tokens that can be bought with input ETH.
435 @public
436 @constant
437 def getEthToTokenInputPrice(eth_sold: uint256(wei)) -> uint256:
438     assert eth_sold > 0
439     token_reserve: uint256 = self.token.balanceOf(self)
440     return self.getInputPrice(as_unitless_number(eth_sold), as_unitless_number(self.balance), token_reserve)
441 
442 # @notice Public price function for ETH to Token trades with an exact output.
443 # @param tokens_bought Amount of Tokens bought.
444 # @return Amount of ETH needed to buy output Tokens.
445 @public
446 @constant
447 def getEthToTokenOutputPrice(tokens_bought: uint256) -> uint256(wei):
448     assert tokens_bought > 0
449     token_reserve: uint256 = self.token.balanceOf(self)
450     eth_sold: uint256 = self.getOutputPrice(tokens_bought, as_unitless_number(self.balance), token_reserve)
451     return as_wei_value(eth_sold, 'wei')
452 
453 # @notice Public price function for Token to ETH trades with an exact input.
454 # @param tokens_sold Amount of Tokens sold.
455 # @return Amount of ETH that can be bought with input Tokens.
456 @public
457 @constant
458 def getTokenToEthInputPrice(tokens_sold: uint256) -> uint256(wei):
459     assert tokens_sold > 0
460     token_reserve: uint256 = self.token.balanceOf(self)
461     eth_bought: uint256 = self.getInputPrice(tokens_sold, token_reserve, as_unitless_number(self.balance))
462     return as_wei_value(eth_bought, 'wei')
463 
464 # @notice Public price function for Token to ETH trades with an exact output.
465 # @param eth_bought Amount of output ETH.
466 # @return Amount of Tokens needed to buy output ETH.
467 @public
468 @constant
469 def getTokenToEthOutputPrice(eth_bought: uint256(wei)) -> uint256:
470     assert eth_bought > 0
471     token_reserve: uint256 = self.token.balanceOf(self)
472     return self.getOutputPrice(as_unitless_number(eth_bought), token_reserve, as_unitless_number(self.balance))
473 
474 # @return Address of Token that is sold on this exchange.
475 @public
476 @constant
477 def tokenAddress() -> address:
478     return self.token
479 
480 # @return Address of factory that created this exchange.
481 @public
482 @constant
483 def factoryAddress() -> address(Factory):
484     return self.factory
485 
486 # ERC20 compatibility for exchange liquidity modified from
487 # https://github.com/ethereum/vyper/blob/master/examples/tokens/ERC20.vy
488 @public
489 @constant
490 def balanceOf(_owner : address) -> uint256:
491     return self.balances[_owner]
492 
493 @public
494 def transfer(_to : address, _value : uint256) -> bool:
495     self.balances[msg.sender] -= _value
496     self.balances[_to] += _value
497     log.Transfer(msg.sender, _to, _value)
498     return True
499 
500 @public
501 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
502     self.balances[_from] -= _value
503     self.balances[_to] += _value
504     self.allowances[_from][msg.sender] -= _value
505     log.Transfer(_from, _to, _value)
506     return True
507 
508 @public
509 def approve(_spender : address, _value : uint256) -> bool:
510     self.allowances[msg.sender][_spender] = _value
511     log.Approval(msg.sender, _spender, _value)
512     return True
513 
514 @public
515 @constant
516 def allowance(_owner : address, _spender : address) -> uint256:
517     return self.allowances[_owner][_spender]