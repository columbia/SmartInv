1 /**
2  * DELFI is an on-chain price oracle you can reason about
3  * it provides a liquidity-weighted index of ETH/DAI prices from decentralized exchanges
4  * the price is backed up by the ETH amount required to move the rate more than 5%
5  * this provides a quantifiable threshold of economic activity the price can safely support
6 
7                                    ___---___
8                              ___---___---___---___
9                        ___---___---         ---___---___
10                  ___---___---                    ---___---___
11            ___---___---            D E L F I          ---___---___
12      ___---___---                   eth/dai                  ---___---___
13 __---___---_________________________________________________________---___---__
14 ===============================================================================
15  ||||                                                                     ||||
16  |---------------------------------------------------------------------------|
17  |___-----___-----___-----___-----___-----___-----___-----___-----___-----___|
18  / _ \===/ _ \   / _ \===/ _ \   / _ \===/ _ \   / _ \===/ _ \   / _ \===/ _ \
19 ( (.\ oOo /.) ) ( (.\ oOo /.) ) ( (.\ oOo /.) ) ( (.\ oOo /.) ) ( (.\ oOo /.) )
20  \__/=====\__/   \__/=====\__/   \__/=====\__/   \__/=====\__/   \__/=====\__/
21     |||||||         |||||||         |||||||         |||||||         |||||||
22     |||||||         |||||||         |||||||         |||||||         |||||||
23     |||||||         |||||||         |||||||         |||||||         |||||||
24     |||||||         |||||||         |||||||         |||||||         |||||||
25     |||||||         |||||||         |||||||         |||||||         |||||||
26     |||||||         |||||||         |||||||         |||||||         |||||||
27     |||||||         |||||||         |||||||         |||||||         |||||||
28     |||||||         |||||||         |||||||         |||||||         |||||||
29     (oOoOo)         (oOoOo)         (oOoOo)         (oOoOo)         (oOoOo)
30     J%%%%%L         J%%%%%L         J%%%%%L         J%%%%%L         J%%%%%L
31    ZZZZZZZZZ       ZZZZZZZZZ       ZZZZZZZZZ       ZZZZZZZZZ       ZZZZZZZZZ
32   ===========================================================================
33 __|_________________________________________________________________________|__
34 _|___________________________________________________________________________|_
35 |_____________________________________________________________________________|
36 _______________________________________________________________________________
37 
38  */
39 
40 pragma solidity ^0.5.4;
41 
42 //////////////
43 //INTERFACES//
44 //////////////
45 
46 contract ERC20 {
47 	function balanceOf(address) external view returns(uint256) {}
48 }
49 
50 contract Uniswap {
51 	function getEthToTokenInputPrice(uint256) external view returns(uint256) {}
52 	function getTokenToEthOutputPrice(uint256) external view returns(uint256) {}
53 }
54 
55 contract Eth2Dai {
56 	function getBuyAmount(address, address, uint256) external view returns(uint256) {}
57 	function getPayAmount(address, address, uint256) external view returns(uint256) {}
58 }
59 
60 contract Bancor {
61 	function getReturn(address, address, uint256) external view returns(uint256, uint256) {}
62 }
63 
64 contract BancorDai {
65 	function getReturn(address, address, uint256) external view returns(uint256) {}
66 }
67 
68 contract Kyber {
69 	function searchBestRate(address, address, uint256, bool) external view returns(address, uint256) {}
70 }
71 
72 /////////////////
73 //MAIN CONTRACT//
74 /////////////////
75 
76 contract Delfi {
77 
78 	///////////////////
79 	//STATE VARIABLES//
80 	///////////////////
81 
82 	/** latest ETH/DAI price */
83 	uint256 public latestRate;
84 	/** block number of latest state update */
85 	uint256 public latestBlock;
86 	/** latest cost to move the price 5% */
87 	uint256 public latestCostToMovePrice;
88 
89 	uint256 constant public ONE_ETH = 10**18;
90 	uint256 constant public FIVE_PERCENT = 5;
91 	
92 	address constant public DAI = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
93 	address constant public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
94 	address constant public BNT = 0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C;
95 	address constant public UNISWAP = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
96 	address constant public ETH2DAI = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
97 	address constant public BANCOR = 0xCBc6a023eb975a1e2630223a7959988948E664f3;
98 	address constant public BANCORDAI = 0x587044b74004E3D5eF2D453b7F8d198d9e4cB558;
99 	address constant public BANCORETH = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
100 	address constant public KYBER = 0x9ae49C0d7F8F9EF4B864e004FE86Ac8294E20950;
101 	address constant public KYBERETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
102 	address constant public KYBER_OASIS_RESERVE = 0x04A487aFd662c4F9DEAcC07A7B10cFb686B682A4;
103 	address constant public KYBER_UNISWAP_RESERVE = 0x13032DeB2d37556cf49301f713E9d7e1d1A8b169;
104 
105 
106 	///////////////////////////
107 	//CONTRACT INSTANTIATIONS//
108 	///////////////////////////
109 	
110 	ERC20 constant dai = ERC20(DAI);
111 	Uniswap constant uniswap = Uniswap(UNISWAP);
112 	Eth2Dai constant eth2dai = Eth2Dai(ETH2DAI);
113 	Bancor constant bancor = Bancor(BANCOR);
114 	BancorDai constant bancordai = BancorDai(BANCORDAI);
115 	Kyber constant kyber = Kyber(KYBER);
116 
117 	///////////////
118 	//CONSTRUCTOR//
119 	///////////////
120 	
121 	constructor() public {
122 		/** set intial values */
123 		updateCurrentRate(); 
124 	}
125 
126 	///////////
127 	//METHODS//
128 	///////////
129 	
130 	/**
131 	 * get the DAI balance of an address
132 	 * @param _owner address of token holder
133 	 * @return _tokenAmount token balance of holder in smallest unit
134 	 */
135 	function getDaiBalance(
136 		address _owner
137 	) 
138 	public 
139 	view 
140 	returns(
141 		uint256 _tokenAmount
142 	) {
143 		return dai.balanceOf(_owner);
144 	}
145 
146 	/**
147 	 * get the non-token ETH balance of an address
148 	 * @param _owner address to check
149 	 * @return _ethAmount amount in wei
150 	 */
151 	function getEthBalance(
152 	    address _owner
153 	) 
154 	public 
155 	view 
156 	returns(
157 	    uint256 _ethAmount
158 	) {
159 	    return _owner.balance;
160 	}
161 
162 	/**
163 	 * get the buy price of DAI on uniswap
164 	 * @param _ethAmount amount of ETH being spent in wei
165 	 * @return _rate returned as a rate in wei
166 	 */
167 	function getUniswapBuyPrice(
168 		uint256 _ethAmount
169 	)
170 	public 
171 	view 
172 	returns(
173 		uint256 _rate
174 	) {
175 		uint256 tokenAmount = uniswap.getEthToTokenInputPrice(_ethAmount);
176 		return (tokenAmount * ONE_ETH) / _ethAmount;
177 	}
178 
179 	/**
180 	 * get the sell price of DAI on uniswap
181 	 * @param _ethAmount amount of ETH being purchased in wei
182 	 * @return _rate returned as a rate in wei
183 	 */
184 	function getUniswapSellPrice(
185 		uint256 _ethAmount
186 	)
187 	public 
188 	view 
189 	returns(
190 		uint256 _rate
191 	) {
192 		uint256 ethAmount = uniswap.getTokenToEthOutputPrice(_ethAmount);
193 		return (ethAmount * ONE_ETH) / _ethAmount;
194 	}
195 
196 	/**
197 	 * get the buy price of DAI on Eth2Dai
198 	 * @param _ethAmount amount of ETH being spent in wei
199 	 * @return _rate returned as a rate in wei
200 	 */
201 	function getEth2DaiBuyPrice(
202 		uint256 _ethAmount
203 	)
204 	public 
205 	view 
206 	returns(
207 		uint256 _rate
208 	) {
209 		uint256 tokenAmount = eth2dai.getBuyAmount(DAI, WETH, _ethAmount);
210 		return (tokenAmount * ONE_ETH) / _ethAmount;
211 	}
212 
213 	/**
214 	 * get the sell price of DAI on Eth2Dai
215 	 * @param _ethAmount amount of ETH being purchased in wei
216 	 * @return _rate returned as a rate in wei
217 	 */
218 	function getEth2DaiSellPrice(
219 		uint256 _ethAmount
220 	)
221 	public 
222 	view 
223 	returns(
224 		uint256 _rate
225 	) {
226 		uint256 ethAmount = eth2dai.getPayAmount(DAI, WETH, _ethAmount);
227 		return (ethAmount * ONE_ETH) / _ethAmount;
228 	}
229 
230 	/**
231 	 * get the buy price of DAI on Bancor
232 	 * @param _ethAmount amount of ETH being spent in wei
233 	 * @return _rate returned as a rate in wei
234 	 */
235 	function getBancorBuyPrice(
236 		uint256 _ethAmount
237 	)
238 	public 
239 	view 
240 	returns(
241 		uint256 _rate
242 	) {
243 		/** convert from eth to bnt */
244 		/** parse tuple return value */
245 		uint256 bntAmount;
246 		(bntAmount,) = bancor.getReturn(BANCORETH, BNT, _ethAmount);
247 		/** convert from bnt to eth */
248 		uint256 tokenAmount = bancordai.getReturn(BNT, DAI, bntAmount);
249 		return (tokenAmount * ONE_ETH) / _ethAmount;
250 	}
251 
252 	/**
253 	 * get the sell price of DAI on Bancor
254 	 * @param _ethAmount amount of ETH being purchased in wei
255 	 * @return _rate returned as a rate in wei
256 	 */
257 	function getBancorSellPrice(
258 		uint256 _ethAmount
259 	)
260 	public 
261 	view 
262 	returns(
263 		uint256 _rate
264 	) {
265 		uint256 roughTokenAmount = (latestRate * _ethAmount) / ONE_ETH;
266 		/** convert from dai to bnt*/
267 		uint256 bntAmount = bancordai.getReturn(DAI, BNT, roughTokenAmount);
268 		/** convert from bnt to eth */
269 		/** parse tuple return value */
270 		uint256 ethAmount;
271 		(ethAmount,) = bancor.getReturn(BNT, BANCORETH, bntAmount);
272 		return (ONE_ETH * roughTokenAmount) / ethAmount;
273 	}
274 
275 	/**
276 	 * get the buy price of DAI on Kyber
277 	 * @param _ethAmount amount of ETH being spent in wei
278 	 * @return _reserveAddress reserve address with best rate
279 	 * @return _rate returned as a rate in wei
280 	 */
281 	function getKyberBuyPrice(
282 		uint256 _ethAmount
283 	)
284 	public 
285 	view
286 	returns(	
287 	  address _reserveAddress,
288 		uint256 _rate
289 	) {
290 		return kyber.searchBestRate(KYBERETH, DAI, _ethAmount, true);
291 	}
292 
293 	/**
294 	 * get the sell price of DAI on Kyber
295 	 * @param _ethAmount amount of ETH being purchased in wei
296 	 * @return _reserveAddress reserve address with best rate
297 	 * @return _rate returned as a rate in wei
298 	 */
299 	function getKyberSellPrice(
300 		uint256 _ethAmount
301 	)
302 	public 
303 	view
304 	returns(
305 		address _reserveAddress,
306 		uint256 _rate
307 	) {
308 		/** get an approximate token amount to calculate ETH returned */
309 		/** if there is no recent price, calc current kyber buy price */
310 		uint256 recentRate;
311 		if (block.number > latestRate + 100) {
312 			(,recentRate) = getKyberBuyPrice(_ethAmount);
313 		} else {
314 			recentRate = latestRate;	
315 		}
316 		uint256 ethAmount;
317 		address reserveAddress;
318 		(reserveAddress, ethAmount) = kyber.searchBestRate(DAI, KYBERETH, _ethAmount, true);
319 	    uint256 tokenAmount = (_ethAmount * ONE_ETH) / ethAmount;
320 	    return (reserveAddress, (tokenAmount * ONE_ETH) / _ethAmount);
321 	}
322 
323 	/**
324 	 * get the most recent saved rate
325 	 * cheap to call but information may be outdated
326 	 * @return _rate most recent saved ETH/DAI rate in wei
327 	 * @return _block block.number the most recent state was saved
328 	 * @return _costToMoveFivePercent cost to move the price 5% in wei
329 	 */
330 	function getLatestSavedRate() 
331 	view
332 	public
333 	returns(
334 		uint256 _rate,
335 		uint256 _block,
336 		uint256 _costToMoveFivePercent
337 	) {
338 		return (latestRate, latestBlock, latestCostToMovePrice);
339 	}
340 
341 	/**
342 	 * updates the price information to the current block and returns this information
343 	 * comparatively expensive to call but always up to date
344 	 * @return _rate most recent saved ETH/DAI rate in wei
345 	 * @return _block block.number the most recent state was saved
346 	 * @return _costToMoveFivePercent cost to move the price 5% in wei
347 	 */
348 	function getLatestRate()
349 	external
350 	returns(
351 		uint256 _rate,
352 		uint256 _block,
353 		uint256 _costToMoveFivePercent
354 	) {
355 		updateCurrentRate();
356 		return (latestRate, latestBlock, latestCostToMovePrice);
357 	}
358 
359 	//////////////////////
360 	//INTERNAL FUNCTIONS//
361 	//////////////////////
362 
363 	/**
364 	 * updates the current rate in state
365 	 * @return _rate most recent saved ETH/DAI rate in wei
366 	 * @return _costToMoveFivePercent cost to move the price 5% in wei 
367 	 */
368 	function updateCurrentRate()  
369 	internal 
370 	returns(
371 	  uint256 _rate,
372 		uint256 _costToMoveFivePercent
373 	) {
374 
375 		/** find midpoints of each spread */
376 		uint256[3] memory midPointArray = [
377 		    findMidPoint(getUniswapBuyPrice(ONE_ETH), getUniswapSellPrice(ONE_ETH)),
378 		    findMidPoint(getBancorBuyPrice(ONE_ETH), getBancorBuyPrice(ONE_ETH)),
379 		    findMidPoint(getEth2DaiBuyPrice(ONE_ETH), getEth2DaiSellPrice(ONE_ETH))
380 		];
381 
382 		/** find liquidity of pooled exchanges */
383 		uint256 uniswapLiquidity = getEthBalance(UNISWAP);
384 		uint256 bancorLiquidity = getDaiBalance(BANCORDAI) * ONE_ETH / midPointArray[1]; 
385 		uint256 eth2daiRoughLiquidity = getDaiBalance(ETH2DAI) * ONE_ETH / midPointArray[2]; 
386         
387 		/** cost of percent move for pooled exchanges */
388 		/** 2.5% of liquidity is approximately a 5% price move */
389 		uint256 costToMovePriceUniswap = (uniswapLiquidity * FIVE_PERCENT) / 50; 
390 		uint256 costToMovePriceBancor = (bancorLiquidity * FIVE_PERCENT) / 50;
391 		
392 		/** divide by price difference */
393 		uint256 largeBuy = eth2daiRoughLiquidity / 2;
394 		uint256 priceMove = getEth2DaiBuyPrice(largeBuy);
395 		uint256 priceMovePercent = ((midPointArray[2] * 10000) / priceMove) - 10000;
396 		
397 		/** ensure largeBuy causes a price move more than _percent */
398 		/** increase large buy amount if necessary */
399 		if (priceMovePercent < FIVE_PERCENT * 100) {
400 			largeBuy += eth2daiRoughLiquidity - 1;
401 			priceMove = getEth2DaiBuyPrice(largeBuy);
402 			priceMovePercent = ((midPointArray[2] * 10000) / priceMove) - 10000;
403 		}
404 
405 		uint256 ratioOfPriceMove = FIVE_PERCENT * 10000 / priceMovePercent;
406  		uint256 costToMovePriceEth2Dai = largeBuy * ratioOfPriceMove / 100;
407 		
408 		/** information stored in memory arrays to avoid stack depth issues */
409 		uint256[3] memory costOfPercentMoveArray = [costToMovePriceUniswap, costToMovePriceBancor, costToMovePriceEth2Dai];
410         
411     return calcRatio(midPointArray, costOfPercentMoveArray);
412 	}
413 	
414 	/**
415 	 * extension of previous method used to update state
416 	 * @return _rate most recent saved ETH/DAI rate in wei
417 	 * @return _costToMoveFivePercent cost to move the price 5% in wei 
418 	 */
419 	function calcRatio(
420 		uint256[3] memory _midPointArray,
421 		uint256[3] memory _costOfPercentMoveArray
422 	) 
423 	internal
424 	returns(
425 		uint256 _rate,
426 		uint256 _costToMoveFivePercent
427 	)
428 	{
429 		uint256 totalCostOfPercentMove = _costOfPercentMoveArray[0] + _costOfPercentMoveArray[1] + _costOfPercentMoveArray[2];
430 		
431 		/** calculate proportion of each exchange in the formula */
432 		/** precise to two decimals */
433 		uint256 precision = 10000; 
434 		uint256[3] memory propotionArray;
435 		propotionArray[0] = (_costOfPercentMoveArray[0] * precision) / totalCostOfPercentMove;
436 		propotionArray[1] = (_costOfPercentMoveArray[1] * precision) / totalCostOfPercentMove;
437 		propotionArray[2] = (_costOfPercentMoveArray[2] * precision) / totalCostOfPercentMove;
438 
439 		/** balance prices */
440 		uint256 balancedRate = 
441 			(
442 				(_midPointArray[0] * propotionArray[0]) + 
443 				(_midPointArray[1] * propotionArray[1]) + 
444 				(_midPointArray[2] * propotionArray[2])
445 			) 
446 			/ precision;
447 
448 		latestRate = balancedRate;
449 		latestBlock = block.number;
450 		latestCostToMovePrice = totalCostOfPercentMove;
451 
452 		return (balancedRate, totalCostOfPercentMove);
453 	}
454 
455 	/**
456 	 * utility function to find mean of an array of values
457 	 * no safe math, yolo
458 	 * @param _a first value
459 	 * @param _b second value
460 	 * @return _midpoint average value
461 	 */
462 	function findMidPoint(
463 		uint256 _a, 
464 		uint256 _b
465 	) 
466 	internal 
467 	pure 
468 	returns(
469 		uint256 _midpoint
470 		) {
471 		return (_a + _b) / 2;
472 	}
473 
474 
475 	////////////
476 	//FALLBACK//
477 	////////////
478 
479 	/**
480 	 * non-payable fallback function
481 	 * this is redundant but more explicit than not including a fallback
482 	 */
483 	function() external {}
484 
485 }