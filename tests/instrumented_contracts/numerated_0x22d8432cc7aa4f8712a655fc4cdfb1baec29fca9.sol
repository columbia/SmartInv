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
28 
29 # @dev This function acts as a contract constructor which is not currently supported in contracts deployed
30 #      using create_with_code_of(). It is called once by the factory during contract creation.
31 @public
32 def setup(token_addr: address):
33     assert (self.factory == ZERO_ADDRESS and self.token == ZERO_ADDRESS) and token_addr != ZERO_ADDRESS
34     self.factory = msg.sender
35     self.token = token_addr
36     self.name = 0x556e697377617020563100000000000000000000000000000000000000000000
37     self.symbol = 0x554e492d56310000000000000000000000000000000000000000000000000000
38     self.decimals = 18
39 
40 # @notice Deposit ETH and Tokens (self.token) at current ratio to mint UNI tokens.
41 # @dev min_liquidity does nothing when total UNI supply is 0.
42 # @param min_liquidity Minimum number of UNI sender will mint if total UNI supply is greater than 0.
43 # @param max_tokens Maximum number of tokens deposited. Deposits max amount if total UNI supply is 0.
44 # @param deadline Time after which this transaction can no longer be executed.
45 # @return The amount of UNI minted.
46 @public
47 @payable
48 def addLiquidity(min_liquidity: uint256, max_tokens: uint256, deadline: timestamp) -> uint256:
49     assert deadline > block.timestamp and (max_tokens > 0 and msg.value > 0)
50     total_liquidity: uint256 = self.totalSupply
51     if total_liquidity > 0:
52         assert min_liquidity > 0
53         eth_reserve: uint256(wei) = self.balance - msg.value
54         token_reserve: uint256 = self.token.balanceOf(self)
55         token_amount: uint256 = msg.value * token_reserve / eth_reserve + 1
56         liquidity_minted: uint256 = msg.value * total_liquidity / eth_reserve
57         assert max_tokens >= token_amount and liquidity_minted >= min_liquidity
58         self.balances[msg.sender] += liquidity_minted
59         self.totalSupply = total_liquidity + liquidity_minted
60         assert self.token.transferFrom(msg.sender, self, token_amount)
61         log.AddLiquidity(msg.sender, msg.value, token_amount)
62         log.Transfer(ZERO_ADDRESS, msg.sender, liquidity_minted)
63         return liquidity_minted
64     else:
65         assert (self.factory != ZERO_ADDRESS and self.token != ZERO_ADDRESS) and msg.value >= 1000000000
66         assert self.factory.getExchange(self.token) == self
67         token_amount: uint256 = max_tokens
68         initial_liquidity: uint256 = as_unitless_number(self.balance)
69         self.totalSupply = initial_liquidity
70         self.balances[msg.sender] = initial_liquidity
71         assert self.token.transferFrom(msg.sender, self, token_amount)
72         log.AddLiquidity(msg.sender, msg.value, token_amount)
73         log.Transfer(ZERO_ADDRESS, msg.sender, initial_liquidity)
74         return initial_liquidity
75 
76 # @dev Burn UNI tokens to withdraw ETH and Tokens at current ratio.
77 # @param amount Amount of UNI burned.
78 # @param min_eth Minimum ETH withdrawn.
79 # @param min_tokens Minimum Tokens withdrawn.
80 # @param deadline Time after which this transaction can no longer be executed.
81 # @return The amount of ETH and Tokens withdrawn.
82 @public
83 def removeLiquidity(amount: uint256, min_eth: uint256(wei), min_tokens: uint256, deadline: timestamp) -> (uint256(wei), uint256):
84     assert (amount > 0 and deadline > block.timestamp) and (min_eth > 0 and min_tokens > 0)
85     total_liquidity: uint256 = self.totalSupply
86     assert total_liquidity > 0
87     token_reserve: uint256 = self.token.balanceOf(self)
88     eth_amount: uint256(wei) = amount * self.balance / total_liquidity
89     token_amount: uint256 = amount * token_reserve / total_liquidity
90     assert eth_amount >= min_eth and token_amount >= min_tokens
91     self.balances[msg.sender] -= amount
92     self.totalSupply = total_liquidity - amount
93     send(msg.sender, eth_amount)
94     assert self.token.transfer(msg.sender, token_amount)
95     log.RemoveLiquidity(msg.sender, eth_amount, token_amount)
96     log.Transfer(msg.sender, ZERO_ADDRESS, amount)
97     return eth_amount, token_amount
98 
99 # @dev Pricing function for converting between ETH and Tokens.
100 # @param input_amount Amount of ETH or Tokens being sold.
101 # @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
102 # @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
103 # @return Amount of ETH or Tokens bought.
104 @private
105 @constant
106 def getInputPrice(input_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
107     assert input_reserve > 0 and output_reserve > 0
108     input_amount_with_fee: uint256 = input_amount * 997
109     numerator: uint256 = input_amount_with_fee * output_reserve
110     denominator: uint256 = (input_reserve * 1000) + input_amount_with_fee
111     return numerator / denominator
112 
113 # @dev Pricing function for converting between ETH and Tokens.
114 # @param output_amount Amount of ETH or Tokens being bought.
115 # @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
116 # @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
117 # @return Amount of ETH or Tokens sold.
118 @private
119 @constant
120 def getOutputPrice(output_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
121     assert input_reserve > 0 and output_reserve > 0
122     numerator: uint256 = input_reserve * output_amount * 1000
123     denominator: uint256 = (output_reserve - output_amount) * 997
124     return numerator / denominator + 1
125 
126 @private
127 def ethToTokenInput(eth_sold: uint256(wei), min_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
128     assert deadline >= block.timestamp and (eth_sold > 0 and min_tokens > 0)
129     token_reserve: uint256 = self.token.balanceOf(self)
130     tokens_bought: uint256 = self.getInputPrice(as_unitless_number(eth_sold), as_unitless_number(self.balance - eth_sold), token_reserve)
131     assert tokens_bought >= min_tokens
132     assert self.token.transfer(recipient, tokens_bought)
133     log.TokenPurchase(buyer, eth_sold, tokens_bought)
134     return tokens_bought
135 
136 # @notice Convert ETH to Tokens.
137 # @dev User specifies exact input (msg.value).
138 # @dev User cannot specify minimum output or deadline.
139 @public
140 @payable
141 def __default__():
142     self.ethToTokenInput(msg.value, 1, block.timestamp, msg.sender, msg.sender)
143 
144 # @notice Convert ETH to Tokens.
145 # @dev User specifies exact input (msg.value) and minimum output.
146 # @param min_tokens Minimum Tokens bought.
147 # @param deadline Time after which this transaction can no longer be executed.
148 # @return Amount of Tokens bought.
149 @public
150 @payable
151 def ethToTokenSwapInput(min_tokens: uint256, deadline: timestamp) -> uint256:
152     return self.ethToTokenInput(msg.value, min_tokens, deadline, msg.sender, msg.sender)
153 
154 # @notice Convert ETH to Tokens and transfers Tokens to recipient.
155 # @dev User specifies exact input (msg.value) and minimum output
156 # @param min_tokens Minimum Tokens bought.
157 # @param deadline Time after which this transaction can no longer be executed.
158 # @param recipient The address that receives output Tokens.
159 # @return Amount of Tokens bought.
160 @public
161 @payable
162 def ethToTokenTransferInput(min_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
163     assert recipient != self and recipient != ZERO_ADDRESS
164     return self.ethToTokenInput(msg.value, min_tokens, deadline, msg.sender, recipient)
165 
166 @private
167 def ethToTokenOutput(tokens_bought: uint256, max_eth: uint256(wei), deadline: timestamp, buyer: address, recipient: address) -> uint256(wei):
168     assert deadline >= block.timestamp and (tokens_bought > 0 and max_eth > 0)
169     token_reserve: uint256 = self.token.balanceOf(self)
170     eth_sold: uint256 = self.getOutputPrice(tokens_bought, as_unitless_number(self.balance - max_eth), token_reserve)
171     # Throws if eth_sold > max_eth
172     eth_refund: uint256(wei) = max_eth - as_wei_value(eth_sold, 'wei')
173     if eth_refund > 0:
174         send(buyer, eth_refund)
175     assert self.token.transfer(recipient, tokens_bought)
176     log.TokenPurchase(buyer, as_wei_value(eth_sold, 'wei'), tokens_bought)
177     return as_wei_value(eth_sold, 'wei')
178 
179 # @notice Convert ETH to Tokens.
180 # @dev User specifies maximum input (msg.value) and exact output.
181 # @param tokens_bought Amount of tokens bought.
182 # @param deadline Time after which this transaction can no longer be executed.
183 # @return Amount of ETH sold.
184 @public
185 @payable
186 def ethToTokenSwapOutput(tokens_bought: uint256, deadline: timestamp) -> uint256(wei):
187     return self.ethToTokenOutput(tokens_bought, msg.value, deadline, msg.sender, msg.sender)
188 
189 # @notice Convert ETH to Tokens and transfers Tokens to recipient.
190 # @dev User specifies maximum input (msg.value) and exact output.
191 # @param tokens_bought Amount of tokens bought.
192 # @param deadline Time after which this transaction can no longer be executed.
193 # @param recipient The address that receives output Tokens.
194 # @return Amount of ETH sold.
195 @public
196 @payable
197 def ethToTokenTransferOutput(tokens_bought: uint256, deadline: timestamp, recipient: address) -> uint256(wei):
198     assert recipient != self and recipient != ZERO_ADDRESS
199     return self.ethToTokenOutput(tokens_bought, msg.value, deadline, msg.sender, recipient)
200 
201 @private
202 def tokenToEthInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp, buyer: address, recipient: address) -> uint256(wei):
203     assert deadline >= block.timestamp and (tokens_sold > 0 and min_eth > 0)
204     token_reserve: uint256 = self.token.balanceOf(self)
205     eth_bought: uint256 = self.getInputPrice(tokens_sold, token_reserve, as_unitless_number(self.balance))
206     wei_bought: uint256(wei) = as_wei_value(eth_bought, 'wei')
207     assert wei_bought >= min_eth
208     send(recipient, wei_bought)
209     assert self.token.transferFrom(buyer, self, tokens_sold)
210     log.EthPurchase(buyer, tokens_sold, wei_bought)
211     return wei_bought
212 
213 
214 # @notice Convert Tokens to ETH.
215 # @dev User specifies exact input and minimum output.
216 # @param tokens_sold Amount of Tokens sold.
217 # @param min_eth Minimum ETH purchased.
218 # @param deadline Time after which this transaction can no longer be executed.
219 # @return Amount of ETH bought.
220 @public
221 def tokenToEthSwapInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp) -> uint256(wei):
222     return self.tokenToEthInput(tokens_sold, min_eth, deadline, msg.sender, msg.sender)
223 
224 # @notice Convert Tokens to ETH and transfers ETH to recipient.
225 # @dev User specifies exact input and minimum output.
226 # @param tokens_sold Amount of Tokens sold.
227 # @param min_eth Minimum ETH purchased.
228 # @param deadline Time after which this transaction can no longer be executed.
229 # @param recipient The address that receives output ETH.
230 # @return Amount of ETH bought.
231 @public
232 def tokenToEthTransferInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp, recipient: address) -> uint256(wei):
233     assert recipient != self and recipient != ZERO_ADDRESS
234     return self.tokenToEthInput(tokens_sold, min_eth, deadline, msg.sender, recipient)
235 
236 @private
237 def tokenToEthOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
238     assert deadline >= block.timestamp and eth_bought > 0
239     token_reserve: uint256 = self.token.balanceOf(self)
240     tokens_sold: uint256 = self.getOutputPrice(as_unitless_number(eth_bought), token_reserve, as_unitless_number(self.balance))
241     # tokens sold is always > 0
242     assert max_tokens >= tokens_sold
243     send(recipient, eth_bought)
244     assert self.token.transferFrom(buyer, self, tokens_sold)
245     log.EthPurchase(buyer, tokens_sold, eth_bought)
246     return tokens_sold
247 
248 # @notice Convert Tokens to ETH.
249 # @dev User specifies maximum input and exact output.
250 # @param eth_bought Amount of ETH purchased.
251 # @param max_tokens Maximum Tokens sold.
252 # @param deadline Time after which this transaction can no longer be executed.
253 # @return Amount of Tokens sold.
254 @public
255 def tokenToEthSwapOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp) -> uint256:
256     return self.tokenToEthOutput(eth_bought, max_tokens, deadline, msg.sender, msg.sender)
257 
258 # @notice Convert Tokens to ETH and transfers ETH to recipient.
259 # @dev User specifies maximum input and exact output.
260 # @param eth_bought Amount of ETH purchased.
261 # @param max_tokens Maximum Tokens sold.
262 # @param deadline Time after which this transaction can no longer be executed.
263 # @param recipient The address that receives output ETH.
264 # @return Amount of Tokens sold.
265 @public
266 def tokenToEthTransferOutput(eth_bought: uint256(wei), max_tokens: uint256, deadline: timestamp, recipient: address) -> uint256:
267     assert recipient != self and recipient != ZERO_ADDRESS
268     return self.tokenToEthOutput(eth_bought, max_tokens, deadline, msg.sender, recipient)
269 
270 @private
271 def tokenToTokenInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, buyer: address, recipient: address, exchange_addr: address) -> uint256:
272     assert (deadline >= block.timestamp and tokens_sold > 0) and (min_tokens_bought > 0 and min_eth_bought > 0)
273     assert exchange_addr != self and exchange_addr != ZERO_ADDRESS
274     token_reserve: uint256 = self.token.balanceOf(self)
275     eth_bought: uint256 = self.getInputPrice(tokens_sold, token_reserve, as_unitless_number(self.balance))
276     wei_bought: uint256(wei) = as_wei_value(eth_bought, 'wei')
277     assert wei_bought >= min_eth_bought
278     assert self.token.transferFrom(buyer, self, tokens_sold)
279     tokens_bought: uint256 = Exchange(exchange_addr).ethToTokenTransferInput(min_tokens_bought, deadline, recipient, value=wei_bought)
280     log.EthPurchase(buyer, tokens_sold, wei_bought)
281     return tokens_bought
282 
283 # @notice Convert Tokens (self.token) to Tokens (token_addr).
284 # @dev User specifies exact input and minimum output.
285 # @param tokens_sold Amount of Tokens sold.
286 # @param min_tokens_bought Minimum Tokens (token_addr) purchased.
287 # @param min_eth_bought Minimum ETH purchased as intermediary.
288 # @param deadline Time after which this transaction can no longer be executed.
289 # @param token_addr The address of the token being purchased.
290 # @return Amount of Tokens (token_addr) bought.
291 @public
292 def tokenToTokenSwapInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, token_addr: address) -> uint256:
293     exchange_addr: address = self.factory.getExchange(token_addr)
294     return self.tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, msg.sender, exchange_addr)
295 
296 # @notice Convert Tokens (self.token) to Tokens (token_addr) and transfers
297 #         Tokens (token_addr) to recipient.
298 # @dev User specifies exact input and minimum output.
299 # @param tokens_sold Amount of Tokens sold.
300 # @param min_tokens_bought Minimum Tokens (token_addr) purchased.
301 # @param min_eth_bought Minimum ETH purchased as intermediary.
302 # @param deadline Time after which this transaction can no longer be executed.
303 # @param recipient The address that receives output ETH.
304 # @param token_addr The address of the token being purchased.
305 # @return Amount of Tokens (token_addr) bought.
306 @public
307 def tokenToTokenTransferInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, recipient: address, token_addr: address) -> uint256:
308     exchange_addr: address = self.factory.getExchange(token_addr)
309     return self.tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, recipient, exchange_addr)
310 
311 @private
312 def tokenToTokenOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, buyer: address, recipient: address, exchange_addr: address) -> uint256:
313     assert deadline >= block.timestamp and (tokens_bought > 0 and max_eth_sold > 0)
314     assert exchange_addr != self and exchange_addr != ZERO_ADDRESS
315     eth_bought: uint256(wei) = Exchange(exchange_addr).getEthToTokenOutputPrice(tokens_bought)
316     token_reserve: uint256 = self.token.balanceOf(self)
317     tokens_sold: uint256 = self.getOutputPrice(as_unitless_number(eth_bought), token_reserve, as_unitless_number(self.balance))
318     # tokens sold is always > 0
319     assert max_tokens_sold >= tokens_sold and max_eth_sold >= eth_bought
320     assert self.token.transferFrom(buyer, self, tokens_sold)
321     eth_sold: uint256(wei) = Exchange(exchange_addr).ethToTokenTransferOutput(tokens_bought, deadline, recipient, value=eth_bought)
322     log.EthPurchase(buyer, tokens_sold, eth_bought)
323     return tokens_sold
324 
325 # @notice Convert Tokens (self.token) to Tokens (token_addr).
326 # @dev User specifies maximum input and exact output.
327 # @param tokens_bought Amount of Tokens (token_addr) bought.
328 # @param max_tokens_sold Maximum Tokens (self.token) sold.
329 # @param max_eth_sold Maximum ETH purchased as intermediary.
330 # @param deadline Time after which this transaction can no longer be executed.
331 # @param token_addr The address of the token being purchased.
332 # @return Amount of Tokens (self.token) sold.
333 @public
334 def tokenToTokenSwapOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, token_addr: address) -> uint256:
335     exchange_addr: address = self.factory.getExchange(token_addr)
336     return self.tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, msg.sender, exchange_addr)
337 
338 # @notice Convert Tokens (self.token) to Tokens (token_addr) and transfers
339 #         Tokens (token_addr) to recipient.
340 # @dev User specifies maximum input and exact output.
341 # @param tokens_bought Amount of Tokens (token_addr) bought.
342 # @param max_tokens_sold Maximum Tokens (self.token) sold.
343 # @param max_eth_sold Maximum ETH purchased as intermediary.
344 # @param deadline Time after which this transaction can no longer be executed.
345 # @param recipient The address that receives output ETH.
346 # @param token_addr The address of the token being purchased.
347 # @return Amount of Tokens (self.token) sold.
348 @public
349 def tokenToTokenTransferOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, recipient: address, token_addr: address) -> uint256:
350     exchange_addr: address = self.factory.getExchange(token_addr)
351     return self.tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, recipient, exchange_addr)
352 
353 # @notice Convert Tokens (self.token) to Tokens (exchange_addr.token).
354 # @dev Allows trades through contracts that were not deployed from the same factory.
355 # @dev User specifies exact input and minimum output.
356 # @param tokens_sold Amount of Tokens sold.
357 # @param min_tokens_bought Minimum Tokens (token_addr) purchased.
358 # @param min_eth_bought Minimum ETH purchased as intermediary.
359 # @param deadline Time after which this transaction can no longer be executed.
360 # @param exchange_addr The address of the exchange for the token being purchased.
361 # @return Amount of Tokens (exchange_addr.token) bought.
362 @public
363 def tokenToExchangeSwapInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, exchange_addr: address) -> uint256:
364     return self.tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, msg.sender, exchange_addr)
365 
366 # @notice Convert Tokens (self.token) to Tokens (exchange_addr.token) and transfers
367 #         Tokens (exchange_addr.token) to recipient.
368 # @dev Allows trades through contracts that were not deployed from the same factory.
369 # @dev User specifies exact input and minimum output.
370 # @param tokens_sold Amount of Tokens sold.
371 # @param min_tokens_bought Minimum Tokens (token_addr) purchased.
372 # @param min_eth_bought Minimum ETH purchased as intermediary.
373 # @param deadline Time after which this transaction can no longer be executed.
374 # @param recipient The address that receives output ETH.
375 # @param exchange_addr The address of the exchange for the token being purchased.
376 # @return Amount of Tokens (exchange_addr.token) bought.
377 @public
378 def tokenToExchangeTransferInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, recipient: address, exchange_addr: address) -> uint256:
379     assert recipient != self
380     return self.tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, recipient, exchange_addr)
381 
382 # @notice Convert Tokens (self.token) to Tokens (exchange_addr.token).
383 # @dev Allows trades through contracts that were not deployed from the same factory.
384 # @dev User specifies maximum input and exact output.
385 # @param tokens_bought Amount of Tokens (token_addr) bought.
386 # @param max_tokens_sold Maximum Tokens (self.token) sold.
387 # @param max_eth_sold Maximum ETH purchased as intermediary.
388 # @param deadline Time after which this transaction can no longer be executed.
389 # @param exchange_addr The address of the exchange for the token being purchased.
390 # @return Amount of Tokens (self.token) sold.
391 @public
392 def tokenToExchangeSwapOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, exchange_addr: address) -> uint256:
393     return self.tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, msg.sender, exchange_addr)
394 
395 # @notice Convert Tokens (self.token) to Tokens (exchange_addr.token) and transfers
396 #         Tokens (exchange_addr.token) to recipient.
397 # @dev Allows trades through contracts that were not deployed from the same factory.
398 # @dev User specifies maximum input and exact output.
399 # @param tokens_bought Amount of Tokens (token_addr) bought.
400 # @param max_tokens_sold Maximum Tokens (self.token) sold.
401 # @param max_eth_sold Maximum ETH purchased as intermediary.
402 # @param deadline Time after which this transaction can no longer be executed.
403 # @param recipient The address that receives output ETH.
404 # @param token_addr The address of the token being purchased.
405 # @return Amount of Tokens (self.token) sold.
406 @public
407 def tokenToExchangeTransferOutput(tokens_bought: uint256, max_tokens_sold: uint256, max_eth_sold: uint256(wei), deadline: timestamp, recipient: address, exchange_addr: address) -> uint256:
408     assert recipient != self
409     return self.tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, recipient, exchange_addr)
410 
411 # @notice Public price function for ETH to Token trades with an exact input.
412 # @param eth_sold Amount of ETH sold.
413 # @return Amount of Tokens that can be bought with input ETH.
414 @public
415 @constant
416 def getEthToTokenInputPrice(eth_sold: uint256(wei)) -> uint256:
417     assert eth_sold > 0
418     token_reserve: uint256 = self.token.balanceOf(self)
419     return self.getInputPrice(as_unitless_number(eth_sold), as_unitless_number(self.balance), token_reserve)
420 
421 # @notice Public price function for ETH to Token trades with an exact output.
422 # @param tokens_bought Amount of Tokens bought.
423 # @return Amount of ETH needed to buy output Tokens.
424 @public
425 @constant
426 def getEthToTokenOutputPrice(tokens_bought: uint256) -> uint256(wei):
427     assert tokens_bought > 0
428     token_reserve: uint256 = self.token.balanceOf(self)
429     eth_sold: uint256 = self.getOutputPrice(tokens_bought, as_unitless_number(self.balance), token_reserve)
430     return as_wei_value(eth_sold, 'wei')
431 
432 # @notice Public price function for Token to ETH trades with an exact input.
433 # @param tokens_sold Amount of Tokens sold.
434 # @return Amount of ETH that can be bought with input Tokens.
435 @public
436 @constant
437 def getTokenToEthInputPrice(tokens_sold: uint256) -> uint256(wei):
438     assert tokens_sold > 0
439     token_reserve: uint256 = self.token.balanceOf(self)
440     eth_bought: uint256 = self.getInputPrice(tokens_sold, token_reserve, as_unitless_number(self.balance))
441     return as_wei_value(eth_bought, 'wei')
442 
443 # @notice Public price function for Token to ETH trades with an exact output.
444 # @param eth_bought Amount of output ETH.
445 # @return Amount of Tokens needed to buy output ETH.
446 @public
447 @constant
448 def getTokenToEthOutputPrice(eth_bought: uint256(wei)) -> uint256:
449     assert eth_bought > 0
450     token_reserve: uint256 = self.token.balanceOf(self)
451     return self.getOutputPrice(as_unitless_number(eth_bought), token_reserve, as_unitless_number(self.balance))
452 
453 # @return Address of Token that is sold on this exchange.
454 @public
455 @constant
456 def tokenAddress() -> address:
457     return self.token
458 
459 # @return Address of factory that created this exchange.
460 @public
461 @constant
462 def factoryAddress() -> address(Factory):
463     return self.factory
464 
465 # ERC20 compatibility for exchange liquidity modified from
466 # https://github.com/ethereum/vyper/blob/master/examples/tokens/ERC20.vy
467 @public
468 @constant
469 def balanceOf(_owner : address) -> uint256:
470     return self.balances[_owner]
471 
472 @public
473 def transfer(_to : address, _value : uint256) -> bool:
474     self.balances[msg.sender] -= _value
475     self.balances[_to] += _value
476     log.Transfer(msg.sender, _to, _value)
477     return True
478 
479 @public
480 def transferFrom(_from : address, _to : address, _value : uint256) -> bool:
481     self.balances[_from] -= _value
482     self.balances[_to] += _value
483     self.allowances[_from][msg.sender] -= _value
484     log.Transfer(_from, _to, _value)
485     return True
486 
487 @public
488 def approve(_spender : address, _value : uint256) -> bool:
489     self.allowances[msg.sender][_spender] = _value
490     log.Approval(msg.sender, _spender, _value)
491     return True
492 
493 @public
494 @constant
495 def allowance(_owner : address, _spender : address) -> uint256:
496     return self.allowances[_owner][_spender]