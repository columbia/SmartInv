1 # Copyright (C) 2021 VolumeFi Software, Inc.
2 
3 #  This program is free software: you can redistribute it and/or modify
4 #  it under the terms of the Apache 2.0 License. 
5 #  This program is distributed WITHOUT ANY WARRANTY without even the implied warranty of
6 #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
7 #  @author VolumeFi, Software Inc.
8 #  @notice This Vyper contract adds liquidity to any Uniswap V3 pool using ETH or any ERC20 Token.
9 #  SPDX-License-Identifier: Apache-2.0
10 
11 # @version ^0.2.12
12 
13 struct MintParams:
14     token0: address
15     token1: address
16     fee: uint256
17     tickLower: int128
18     tickUpper: int128
19     amount0Desired: uint256
20     amount1Desired: uint256
21     amount0Min: uint256
22     amount1Min: uint256
23     recipient: address
24     deadline: uint256
25 
26 struct SingleMintParams:
27     token0: address
28     token1: address
29     fee: uint256
30     tickLower: int128
31     tickUpper: int128
32     sqrtPriceAX96: uint256
33     sqrtPriceBX96: uint256
34     liquidityMin: uint256
35     recipient: address
36     deadline: uint256
37 
38 struct ModifyParams:
39     fee: uint256
40     tickLower: int128
41     tickUpper: int128
42     recipient: address
43     deadline: uint256
44 
45 interface ERC20:
46     def allowance(_owner: address, _spender: address) -> uint256: view
47 
48 interface ERC721:
49     def transferFrom(_from: address, _to: address, _tokenId: uint256): payable
50 
51 interface NonfungiblePositionManager:
52     def burn(tokenId: uint256): payable
53 
54 interface UniswapV2Factory:
55     def getPair(tokenA: address, tokenB: address) -> address: view
56 
57 interface UniswapV2Pair:
58     def token0() -> address: view
59     def token1() -> address: view
60     def getReserves() -> (uint256, uint256, uint256): view
61     def mint(to: address) -> uint256: nonpayable
62 
63 interface WrappedEth:
64     def deposit(): payable
65     def withdraw(amount: uint256): nonpayable
66 
67 event AddedLiquidity:
68     tokenId: indexed(uint256)
69     token0: indexed(address)
70     token1: indexed(address)
71     liquidity: uint256
72     amount0: uint256
73     amount1: uint256
74 
75 event NFLPModified:
76     oldTokenId: indexed(uint256)
77     newTokenId: indexed(uint256)
78 
79 event Paused:
80     paused: bool
81 
82 event FeeChanged:
83     newFee: uint256
84 
85 NONFUNGIBLEPOSITIONMANAGER: constant(address) = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88
86 UNISWAPV3FACTORY: constant(address) = 0x1F98431c8aD98523631AE4a59f267346ea31F984
87 
88 UNISWAPV2FACTORY: constant(address) = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
89 UNISWAPV2ROUTER02: constant(address) = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
90 
91 VETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
92 WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
93 
94 APPROVE_MID: constant(Bytes[4]) = method_id("approve(address,uint256)")
95 TRANSFER_MID: constant(Bytes[4]) = method_id("transfer(address,uint256)")
96 TRANSFERFROM_MID: constant(Bytes[4]) = method_id("transferFrom(address,address,uint256)")
97 CAIPIN_MID: constant(Bytes[4]) = method_id("createAndInitializePoolIfNecessary(address,address,uint24,uint160)")
98 GETPOOL_MID: constant(Bytes[4]) = method_id("getPool(address,address,uint24)")
99 SLOT0_MID: constant(Bytes[4]) = method_id("slot0()")
100 MINT_MID: constant(Bytes[4]) = method_id("mint((address,address,uint24,int24,int24,uint256,uint256,uint256,uint256,address,uint256))")
101 POSITIONS_MID: constant(Bytes[4]) = method_id("positions(uint256)")
102 INCREASELIQUIDITY_MID: constant(Bytes[4]) = method_id("increaseLiquidity((uint256,uint256,uint256,uint256,uint256,uint256))")
103 DECREASELIQUIDITY_MID: constant(Bytes[4]) = method_id("decreaseLiquidity((uint256,uint128,uint256,uint256,uint256))")
104 COLLECT_MID: constant(Bytes[4]) = method_id("collect((uint256,address,uint128,uint128))")
105 SWAPETFT_MID: constant(Bytes[4]) = method_id("swapExactTokensForTokens(uint256,uint256,address[],address,uint256)")
106 
107 paused: public(bool)
108 admin: public(address)
109 feeAddress: public(address)
110 feeAmount: public(uint256)
111 
112 @external
113 def __init__():
114     self.paused = False
115     self.admin = msg.sender
116     self.feeAddress = 0xf29399fB3311082d9F8e62b988cBA44a5a98ebeD
117     self.feeAmount = 5 * 10 ** 15
118 
119 @internal
120 @pure
121 def uintSqrt(x: uint256) -> uint256:
122     if x > 3:
123         z: uint256 = (x + 1) / 2
124         y: uint256 = x
125         for i in range(256):
126             if y == z:
127                 return y
128             y = z
129             z = (x / z + z) / 2
130         raise "Did not coverage"
131     elif x == 0:
132         return 0
133     else:
134         return 1
135 
136 @internal
137 def safeApprove(_token: address, _spender: address, _value: uint256):
138     _response: Bytes[32] = raw_call(
139         _token,
140         concat(
141             APPROVE_MID,
142             convert(_spender, bytes32),
143             convert(_value, bytes32)
144         ),
145         max_outsize=32
146     )  # dev: failed approve
147     if len(_response) > 0:
148         assert convert(_response, bool), "Approve failed"  # dev: failed approve
149 
150 @internal
151 def safeTransfer(_token: address, _to: address, _value: uint256):
152     _response: Bytes[32] = raw_call(
153         _token,
154         concat(
155             TRANSFER_MID,
156             convert(_to, bytes32),
157             convert(_value, bytes32)
158         ),
159         max_outsize=32
160     )  # dev: failed transfer
161     if len(_response) > 0:
162         assert convert(_response, bool), "Transfer failed"  # dev: failed transfer
163 
164 @internal
165 def safeTransferFrom(_token: address, _from: address, _to: address, _value: uint256):
166     _response: Bytes[32] = raw_call(
167         _token,
168         concat(
169             TRANSFERFROM_MID,
170             convert(_from, bytes32),
171             convert(_to, bytes32),
172             convert(_value, bytes32)
173         ),
174         max_outsize=32
175     )  # dev: failed transferFrom
176     if len(_response) > 0:
177         assert convert(_response, bool), "TransferFrom failed"  # dev: failed transferFrom
178 
179 @internal
180 def addLiquidity(_tokenId: uint256, sender: address, uniV3Params: MintParams, _sqrtPriceX96: uint256 = 0) -> (uint256, uint256, uint256):
181     self.safeApprove(uniV3Params.token0, NONFUNGIBLEPOSITIONMANAGER, uniV3Params.amount0Desired)
182     self.safeApprove(uniV3Params.token1, NONFUNGIBLEPOSITIONMANAGER, uniV3Params.amount1Desired)
183     if _tokenId == 0:
184         sqrtPriceX96: uint256 = _sqrtPriceX96
185         _response32: Bytes[32] = empty(Bytes[32])
186         if sqrtPriceX96 == 0:
187             _response32 = raw_call(
188                 UNISWAPV3FACTORY,
189                 concat(
190                     GETPOOL_MID,
191                     convert(uniV3Params.token0, bytes32),
192                     convert(uniV3Params.token1, bytes32),
193                     convert(uniV3Params.fee, bytes32)
194                 ),
195                 max_outsize=32,
196                 is_static_call=True
197             )
198             pool: address = convert(convert(_response32, bytes32), address)
199             assert pool != ZERO_ADDRESS, "Pool does not exist"
200             _response224: Bytes[224] = raw_call(
201                 pool,
202                 SLOT0_MID,
203                 max_outsize=224,
204                 is_static_call=True
205             )
206             sqrtPriceX96 = convert(slice(_response224, 0, 32), uint256)
207             assert sqrtPriceX96 != 0, "Pool does not initialized"
208 
209         _response32 = raw_call(
210             NONFUNGIBLEPOSITIONMANAGER,
211             concat(
212                 CAIPIN_MID,
213                 convert(uniV3Params.token0, bytes32),
214                 convert(uniV3Params.token1, bytes32),
215                 convert(uniV3Params.fee, bytes32),
216                 convert(sqrtPriceX96, bytes32)
217             ),
218             max_outsize=32
219         )
220         assert convert(convert(_response32, bytes32), address) != ZERO_ADDRESS, "Create Or Init Pool failed"
221         _response128: Bytes[128] = raw_call(
222             NONFUNGIBLEPOSITIONMANAGER,
223             concat(
224                 MINT_MID,
225                 convert(uniV3Params.token0, bytes32),
226                 convert(uniV3Params.token1, bytes32),
227                 convert(uniV3Params.fee, bytes32),
228                 convert(uniV3Params.tickLower, bytes32),
229                 convert(uniV3Params.tickUpper, bytes32),
230                 convert(uniV3Params.amount0Desired, bytes32),
231                 convert(uniV3Params.amount1Desired, bytes32),
232                 convert(uniV3Params.amount0Min, bytes32),
233                 convert(uniV3Params.amount1Min, bytes32),
234                 convert(uniV3Params.recipient, bytes32),
235                 convert(uniV3Params.deadline, bytes32)
236             ),
237             max_outsize=128
238         )
239         tokenId: uint256 = convert(slice(_response128, 0, 32), uint256)
240         liquidity: uint256 = convert(slice(_response128, 32, 32), uint256)
241         amount0: uint256 = convert(slice(_response128, 64, 32), uint256)
242         amount1: uint256 = convert(slice(_response128, 96, 32), uint256)
243         log AddedLiquidity(tokenId, uniV3Params.token0, uniV3Params.token1, liquidity, amount0, amount1)
244         return (amount0, amount1, liquidity)
245     else:
246         liquidity: uint256 = 0
247         amount0: uint256 = 0
248         amount1: uint256 = 0
249         _response96: Bytes[96] = raw_call(
250             NONFUNGIBLEPOSITIONMANAGER,
251             concat(
252                 INCREASELIQUIDITY_MID,
253                 convert(_tokenId, bytes32),
254                 convert(uniV3Params.amount0Desired, bytes32),
255                 convert(uniV3Params.amount1Desired, bytes32),
256                 convert(uniV3Params.amount0Min, bytes32),
257                 convert(uniV3Params.amount1Min, bytes32),
258                 convert(uniV3Params.deadline, bytes32)
259             ),
260             max_outsize=96
261         )
262         liquidity = convert(slice(_response96, 0, 32), uint256)
263         amount0 = convert(slice(_response96, 32, 32), uint256)
264         amount1 = convert(slice(_response96, 64, 32), uint256)
265         log AddedLiquidity(_tokenId, uniV3Params.token0, uniV3Params.token1, liquidity, amount0, amount1)
266         return (amount0, amount1, liquidity)
267 
268 @external
269 @payable
270 @nonreentrant('lock')
271 def addLiquidityEthForUniV3(_tokenId: uint256, uniV3Params: MintParams):
272     assert not self.paused, "Paused"
273     assert convert(uniV3Params.token0, uint256) < convert(uniV3Params.token1, uint256), "Unsorted tokens"
274     if uniV3Params.token0 == WETH:
275         if msg.value > uniV3Params.amount0Desired:
276             send(msg.sender, msg.value - uniV3Params.amount0Desired)
277         else:
278             assert msg.value == uniV3Params.amount0Desired, "Eth not enough"
279         WrappedEth(WETH).deposit(value=uniV3Params.amount0Desired)
280         self.safeTransferFrom(uniV3Params.token1, msg.sender, self, uniV3Params.amount1Desired)
281         amount0: uint256 = 0
282         amount1: uint256 = 0
283         liquidity: uint256 = 0
284         (amount0, amount1, liquidity) = self.addLiquidity(_tokenId, msg.sender, uniV3Params)
285         amount0 = uniV3Params.amount0Desired - amount0
286         amount1 = uniV3Params.amount1Desired - amount1
287         if amount0 > 0:
288             WrappedEth(WETH).withdraw(amount0)
289             send(msg.sender, amount0)
290             self.safeApprove(uniV3Params.token0, NONFUNGIBLEPOSITIONMANAGER, 0)
291         if amount1 > 0:
292             self.safeTransfer(uniV3Params.token1, msg.sender, amount1)
293             self.safeApprove(uniV3Params.token1, NONFUNGIBLEPOSITIONMANAGER, 0)
294     else:
295         assert uniV3Params.token1 == WETH, "Not Eth Pair"
296         if msg.value > uniV3Params.amount1Desired:
297             send(msg.sender, msg.value - uniV3Params.amount1Desired)
298         else:
299             assert msg.value == uniV3Params.amount1Desired, "Eth not enough"
300         WrappedEth(WETH).deposit(value=uniV3Params.amount1Desired)
301         self.safeTransferFrom(uniV3Params.token0, msg.sender, self, uniV3Params.amount0Desired)
302         amount0: uint256 = 0
303         amount1: uint256 = 0
304         liquidity: uint256 = 0
305         (amount0, amount1, liquidity) = self.addLiquidity(_tokenId, msg.sender, uniV3Params)
306         amount0 = uniV3Params.amount0Desired - amount0
307         amount1 = uniV3Params.amount1Desired - amount1
308         if amount0 > 0:
309             self.safeTransfer(uniV3Params.token0, msg.sender, amount0)
310             self.safeApprove(uniV3Params.token0, NONFUNGIBLEPOSITIONMANAGER, 0)
311         if amount1 > 0:
312             WrappedEth(WETH).withdraw(amount1)
313             send(msg.sender, amount1)
314             self.safeApprove(uniV3Params.token1, NONFUNGIBLEPOSITIONMANAGER, 0)
315 
316 @external
317 @nonreentrant('lock')
318 def addLiquidityForUniV3(_tokenId: uint256, uniV3Params: MintParams):
319     assert not self.paused, "Paused"
320     assert convert(uniV3Params.token0, uint256) < convert(uniV3Params.token1, uint256), "Unsorted tokens"
321 
322     self.safeTransferFrom(uniV3Params.token0, msg.sender, self, uniV3Params.amount0Desired)
323     self.safeTransferFrom(uniV3Params.token1, msg.sender, self, uniV3Params.amount1Desired)
324 
325     amount0: uint256 = 0
326     amount1: uint256 = 0
327     liquidity: uint256 = 0
328     (amount0, amount1, liquidity) = self.addLiquidity(_tokenId, msg.sender, uniV3Params)
329     amount0 = uniV3Params.amount0Desired - amount0
330     amount1 = uniV3Params.amount1Desired - amount1
331     if amount0 > 0:
332         self.safeTransfer(uniV3Params.token0, msg.sender, amount0)
333         self.safeApprove(uniV3Params.token0, NONFUNGIBLEPOSITIONMANAGER, 0)
334     if amount1 > 0:
335         self.safeTransfer(uniV3Params.token1, msg.sender, amount1)
336         self.safeApprove(uniV3Params.token1, NONFUNGIBLEPOSITIONMANAGER, 0)
337 
338 @external
339 @payable
340 @nonreentrant('lock')
341 def modifyPositionForUniV3NFLP(_tokenId: uint256, modifyParams: ModifyParams):
342     assert _tokenId != 0, "Wrong Token ID"
343     fee: uint256 = self.feeAmount
344     if msg.value > fee:
345         send(msg.sender, msg.value - fee)
346     else:
347         assert msg.value == fee, "Insufficient fee"
348     send(self.feeAddress, fee)
349     ERC721(NONFUNGIBLEPOSITIONMANAGER).transferFrom(msg.sender, self, _tokenId)
350     
351     _response384: Bytes[384] = raw_call(
352         NONFUNGIBLEPOSITIONMANAGER,
353         concat(
354             POSITIONS_MID,
355             convert(_tokenId, bytes32)
356         ),
357         max_outsize=384,
358         is_static_call=True
359     )
360     token0: address = convert(convert(slice(_response384, 64, 32), uint256), address)
361     token1: address = convert(convert(slice(_response384, 96, 32), uint256), address)
362     liquidity: uint256 = convert(slice(_response384, 224, 32), uint256)
363     
364     _response64: Bytes[64] = raw_call(
365         NONFUNGIBLEPOSITIONMANAGER,
366         concat(
367             DECREASELIQUIDITY_MID,
368             convert(_tokenId, bytes32),
369             convert(liquidity, bytes32),
370             convert(0, bytes32),
371             convert(0, bytes32),
372             convert(modifyParams.deadline, bytes32)
373         ),
374         max_outsize=64
375     )
376 
377     _response64 = raw_call(
378         NONFUNGIBLEPOSITIONMANAGER,
379         concat(
380             COLLECT_MID,
381             convert(_tokenId, bytes32),
382             convert(self, bytes32),
383             convert(2 ** 128 - 1, bytes32),
384             convert(2 ** 128 - 1, bytes32)
385         ),
386         max_outsize=64
387     )
388     amount0: uint256 = convert(slice(_response64, 0, 32), uint256)
389     amount1: uint256 = convert(slice(_response64, 32, 32), uint256)
390     
391     NonfungiblePositionManager(NONFUNGIBLEPOSITIONMANAGER).burn(_tokenId)
392 
393     sqrtPriceX96: uint256 = 0
394     _response32: Bytes[32] = raw_call(
395         UNISWAPV3FACTORY,
396         concat(
397             GETPOOL_MID,
398             convert(token0, bytes32),
399             convert(token1, bytes32),
400             convert(modifyParams.fee, bytes32)
401         ),
402         max_outsize=32,
403         is_static_call=True
404     )
405     pool: address = convert(convert(_response32, bytes32), address)
406     if pool == ZERO_ADDRESS:
407         sqrtPriceX96 = 2 ** 96 * self.uintSqrt(amount0) / self.uintSqrt(amount1)
408     else:
409         _response224: Bytes[224] = raw_call(
410             pool,
411             SLOT0_MID,
412             max_outsize=224,
413             is_static_call=True
414         )
415         sqrtPriceX96 = convert(slice(_response224, 0, 32), uint256)
416         if sqrtPriceX96 == 0:
417             sqrtPriceX96 = 2 ** 96 * self.uintSqrt(amount1) / self.uintSqrt(amount1)
418 
419     _response32 = raw_call(
420         NONFUNGIBLEPOSITIONMANAGER,
421         concat(
422             CAIPIN_MID,
423             convert(token0, bytes32),
424             convert(token1, bytes32),
425             convert(modifyParams.fee, bytes32),
426             convert(sqrtPriceX96, bytes32)
427         ),
428         max_outsize=32
429     )
430 
431     assert convert(convert(_response32, bytes32), address) != ZERO_ADDRESS, "Create Or Init Pool failed"
432 
433     self.safeApprove(token0, NONFUNGIBLEPOSITIONMANAGER, amount0)
434     self.safeApprove(token1, NONFUNGIBLEPOSITIONMANAGER, amount1)
435 
436     _response128: Bytes[128] = raw_call(
437         NONFUNGIBLEPOSITIONMANAGER,
438         concat(
439             MINT_MID,
440             convert(token0, bytes32),
441             convert(token1, bytes32),
442             convert(modifyParams.fee, bytes32),
443             convert(modifyParams.tickLower, bytes32),
444             convert(modifyParams.tickUpper, bytes32),
445             convert(amount0, bytes32),
446             convert(amount1, bytes32),
447             convert(0, bytes32),
448             convert(0, bytes32),
449             convert(msg.sender, bytes32),
450             convert(modifyParams.deadline, bytes32)
451         ),
452         max_outsize=128
453     )
454     tokenId: uint256 = convert(slice(_response128, 0, 32), uint256)
455     liquiditynew: uint256 = convert(slice(_response128, 32, 32), uint256)
456     amount0new: uint256 = convert(slice(_response128, 64, 32), uint256)
457     amount1new: uint256 = convert(slice(_response128, 96, 32), uint256)
458 
459     if amount0 > amount0new:
460         self.safeTransfer(token0, msg.sender, amount0 - amount0new)
461         self.safeApprove(token0, NONFUNGIBLEPOSITIONMANAGER, 0)
462     if amount1 > amount1new:
463         self.safeTransfer(token1, msg.sender, amount1 - amount1new)
464         self.safeApprove(token1, NONFUNGIBLEPOSITIONMANAGER, 0)
465     log NFLPModified(_tokenId, tokenId)
466 
467 @internal
468 def _token2Token(fromToken: address, toToken: address, tokens2Trade: uint256, deadline: uint256) -> uint256:
469     if fromToken == toToken:
470         return tokens2Trade
471     self.safeApprove(fromToken, UNISWAPV2ROUTER02, tokens2Trade)
472     _response: Bytes[128] = raw_call(
473         UNISWAPV2ROUTER02,
474         concat(
475             SWAPETFT_MID,
476             convert(tokens2Trade, bytes32),
477             convert(0, bytes32),
478             convert(160, bytes32),
479             convert(self, bytes32),
480             convert(deadline, bytes32),
481             convert(2, bytes32),
482             convert(fromToken, bytes32),
483             convert(toToken, bytes32)
484         ),
485         max_outsize=128
486     )
487     tokenBought: uint256 = convert(slice(_response, 96, 32), uint256)
488     self.safeApprove(fromToken, UNISWAPV2ROUTER02, 0)
489     assert tokenBought > 0, "Error Swapping Token"
490     return tokenBought
491 
492 # (X + fX') * (Y - Y') = X * Y
493 # Y' / (X_toinvest - X') = p^2 = P
494 # Quadratic equation solution for X'
495 @internal
496 @view
497 def _getUserInForSqrtPriceX96(reserveIn: uint256, reserveOut: uint256, priceX96: uint256, toInvest: uint256) -> uint256:
498     b: uint256 = reserveIn + (reserveOut * 997 / 1000 * 2 ** 96 / priceX96) - toInvest * 997 / 1000
499     return (self.uintSqrt(b * b + 4 * reserveIn * toInvest * 997 / 1000) - b) * 1000 / 1994
500 
501 @internal
502 @pure
503 def _getPairTokens(pair: address) -> (address, address):
504     token0: address = UniswapV2Pair(pair).token0()
505     token1: address = UniswapV2Pair(pair).token1()
506     return (token0, token1)
507 
508 @internal
509 @view
510 def _getLiquidityInPool(midToken: address, pair: address) -> uint256:
511     res0: uint256 = 0
512     res1: uint256 = 0
513     token0: address = ZERO_ADDRESS
514     token1: address = ZERO_ADDRESS
515     blockTimestampLast: uint256 = 0
516     (res0, res1, blockTimestampLast) = UniswapV2Pair(pair).getReserves()
517     (token0, token1) = self._getPairTokens(pair)
518     if token0 == midToken:
519         return res0
520     else:
521         return res1
522 
523 @internal
524 @view
525 def _getMidToken(midToken: address, token0: address, token1: address) -> address:
526     pair0: address = UniswapV2Factory(UNISWAPV2FACTORY).getPair(midToken, token0)
527     pair1: address = UniswapV2Factory(UNISWAPV2FACTORY).getPair(midToken, token1)
528     eth0: uint256 = self._getLiquidityInPool(midToken, pair0)
529     eth1: uint256 = self._getLiquidityInPool(midToken, pair1)
530     if eth0 > eth1:
531         return token0
532     else:
533         return token1
534 
535 @internal
536 @view
537 def _getVirtualPriceX96(sqrtPriceAX96: uint256, sqrtPriceX96: uint256, sqrtPriceBX96: uint256) -> uint256:
538     ret: uint256 = (sqrtPriceBX96 - sqrtPriceX96) * 2 ** 96 / sqrtPriceBX96 * 2 ** 96 / sqrtPriceX96 * 2 ** 96 / (sqrtPriceX96 - sqrtPriceAX96)
539     if ret > 2 ** 160:
540         return 2 ** 160
541     else:
542         return ret
543 
544 @external
545 @payable
546 @nonreentrant('lock')
547 def investTokenForUniPair(_token: address, amount: uint256, _tokenId: uint256, _uniV3Params: SingleMintParams):
548     assert not self.paused, "Paused"
549     assert amount > 0, "Invalid input amount"
550     uniV3Params: MintParams = MintParams({
551         token0: _uniV3Params.token0,
552         token1: _uniV3Params.token1,
553         fee: _uniV3Params.fee,
554         tickLower: _uniV3Params.tickLower,
555         tickUpper: _uniV3Params.tickUpper,
556         amount0Desired: 0,
557         amount1Desired: 0,
558         amount0Min: 0,
559         amount1Min: 0,
560         recipient: _uniV3Params.recipient,
561         deadline: _uniV3Params.deadline
562     })
563     assert convert(uniV3Params.token0, uint256) < convert(uniV3Params.token1, uint256), "Unsorted tokens"
564     fee: uint256 = self.feeAmount
565     assert msg.value >= fee, "Insufficient fee"
566     send(self.feeAddress, fee)
567     msg_value: uint256 = msg.value
568     msg_value -= fee
569     token: address = _token
570     _response32: Bytes[32] = empty(Bytes[32])
571     toInvest: uint256 = 0
572     midToken: address = WETH
573     if token == VETH or token == ZERO_ADDRESS:
574         if msg_value > amount:
575             send(msg.sender, msg_value - amount)
576         else:
577             assert msg_value >= amount, "Insufficient value"
578         WrappedEth(WETH).deposit(value=amount)
579         token = WETH
580         toInvest = amount
581     #invest Token
582     else:
583         self.safeTransferFrom(token, msg.sender, self, amount)
584         if msg_value > 0:
585             send(msg.sender, msg_value)
586         if token == WETH:
587             toInvest = amount
588         elif token != uniV3Params.token0 and token != uniV3Params.token1:
589             toInvest = self._token2Token(token, WETH, amount, uniV3Params.deadline)
590         else:
591             midToken = token
592             toInvest = amount
593     if uniV3Params.token0 != WETH and uniV3Params.token1 != WETH and token != uniV3Params.token0 and token != uniV3Params.token1:
594         midToken = self._getMidToken(WETH, uniV3Params.token0, uniV3Params.token1)
595         toInvest = self._token2Token(WETH, midToken, toInvest, uniV3Params.deadline)
596 
597     res0: uint256 = 0
598     res1: uint256 = 0
599     blockTimestampLast: uint256 = 0
600     pair: address = UniswapV2Factory(UNISWAPV2FACTORY).getPair(uniV3Params.token0, uniV3Params.token1)
601     endToken: address = ZERO_ADDRESS
602     if midToken == uniV3Params.token0:
603         (res0, res1, blockTimestampLast) = UniswapV2Pair(pair).getReserves()
604         endToken = uniV3Params.token1
605     else:
606         (res1, res0, blockTimestampLast) = UniswapV2Pair(pair).getReserves()
607         endToken = uniV3Params.token0
608 
609     sqrtPriceX96: uint256 = 0
610     _response32 = raw_call(
611         UNISWAPV3FACTORY,
612         concat(
613             GETPOOL_MID,
614             convert(uniV3Params.token0, bytes32),
615             convert(uniV3Params.token1, bytes32),
616             convert(uniV3Params.fee, bytes32)
617         ),
618         max_outsize=32,
619         is_static_call=True
620     )
621     pool: address = convert(convert(_response32, bytes32), address)
622     assert pool != ZERO_ADDRESS, "Pool does not exist"
623     _response224: Bytes[224] = raw_call(
624         pool,
625         SLOT0_MID,
626         max_outsize=224,
627         is_static_call=True
628     )
629     sqrtPriceX96 = convert(slice(_response224, 0, 32), uint256)
630     assert sqrtPriceX96 != 0, "Pool does not initialized"
631     retAmount: uint256 = 0
632     swapAmount: uint256 = 0
633     if sqrtPriceX96 <= _uniV3Params.sqrtPriceAX96:
634         if convert(midToken, uint256) > convert(endToken, uint256):
635             swapAmount = toInvest
636     elif sqrtPriceX96 >= _uniV3Params.sqrtPriceBX96:
637         if convert(midToken, uint256) < convert(endToken, uint256):
638             swapAmount = toInvest
639     else:
640         virtualPriceX96: uint256 = self._getVirtualPriceX96(_uniV3Params.sqrtPriceAX96, sqrtPriceX96, _uniV3Params.sqrtPriceBX96)
641         if convert(midToken, uint256) > convert(endToken, uint256):
642             swapAmount = self._getUserInForSqrtPriceX96(res0, res1, virtualPriceX96, toInvest)
643         else:
644             swapAmount = self._getUserInForSqrtPriceX96(res0, res1, 2 ** 192 / virtualPriceX96, toInvest)
645 
646     if swapAmount > toInvest:
647         swapAmount = toInvest
648 
649     if swapAmount > 0:
650         retAmount = self._token2Token(midToken, endToken, swapAmount, uniV3Params.deadline)
651 
652     if uniV3Params.token0 == midToken:
653         uniV3Params.amount0Desired = toInvest - swapAmount
654         uniV3Params.amount1Desired = retAmount
655     else:
656         uniV3Params.amount1Desired = toInvest - swapAmount
657         uniV3Params.amount0Desired = retAmount
658 
659     amount0: uint256 = 0
660     amount1: uint256 = 0
661     liquidity: uint256 = 0
662     (amount0, amount1, liquidity) = self.addLiquidity(_tokenId, msg.sender, uniV3Params, sqrtPriceX96)
663     assert liquidity >= _uniV3Params.liquidityMin, "High Slippage"
664     amount0 = uniV3Params.amount0Desired - amount0
665     amount1 = uniV3Params.amount1Desired - amount1
666     if amount0 > 0:
667         self.safeApprove(uniV3Params.token0, NONFUNGIBLEPOSITIONMANAGER, 0)
668     if amount1 > 0:
669         self.safeApprove(uniV3Params.token1, NONFUNGIBLEPOSITIONMANAGER, 0)
670 
671 # Admin functions
672 @external
673 def pause(_paused: bool):
674     assert msg.sender == self.admin, "Not admin"
675     self.paused = _paused
676     log Paused(_paused)
677 
678 @external
679 def newAdmin(_admin: address):
680     assert msg.sender == self.admin, "Not admin"
681     self.admin = _admin
682 
683 @external
684 def newFeeAmount(_feeAmount: uint256):
685     assert msg.sender == self.admin, "Not admin"
686     self.feeAmount = _feeAmount
687     log FeeChanged(_feeAmount)
688 
689 @external
690 def newFeeAddress(_feeAddress: address):
691     assert msg.sender == self.admin, "Not admin"
692     self.feeAddress = _feeAddress
693 
694 @external
695 @nonreentrant('lock')
696 def batchWithdraw(token: address[8], amount: uint256[8], to: address[8]):
697     assert msg.sender == self.admin, "Not admin"
698     for i in range(8):
699         if token[i] == VETH:
700             send(to[i], amount[i])
701         elif token[i] != ZERO_ADDRESS:
702             self.safeTransfer(token[i], to[i], amount[i])
703 
704 @external
705 @nonreentrant('lock')
706 def withdraw(token: address, amount: uint256, to: address):
707     assert msg.sender == self.admin, "Not admin"
708     if token == VETH:
709         send(to, amount)
710     elif token != ZERO_ADDRESS:
711         self.safeTransfer(token, to, amount)
712 
713 @external
714 @payable
715 def __default__():
716     assert msg.sender == WETH, "can't receive Eth"