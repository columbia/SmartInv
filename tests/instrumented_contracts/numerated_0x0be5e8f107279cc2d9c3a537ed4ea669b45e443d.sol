1 pragma solidity ^0.4.20;
2 contract POMDA {
3 /*=================================
4 =            MODIFIERS            =
5 =================================*/
6 // only people with tokens
7 modifier onlyBagholders() {
8 require(myTokens() > 0);
9 _;
10 }
11 
12 // only people with profits
13 modifier onlyStronghands() {
14 require(myDividends(true) > 0);
15 _;
16 }
17 
18 /*==============================
19 =            EVENTS            =
20 ==============================*/
21 event onTokenPurchase(
22 address indexed customerAddress,
23 uint256 incomingEthereum,
24 uint256 tokensMinted,
25 address indexed referredBy
26 );
27 
28 event onTokenSell(
29 address indexed customerAddress,
30 uint256 tokensBurned,
31 uint256 ethereumEarned
32 );
33 
34 event onReinvestment(
35 address indexed customerAddress,
36 uint256 ethereumReinvested,
37 uint256 tokensMinted
38 );
39 
40 event onWithdraw(
41 address indexed customerAddress,
42 uint256 ethereumWithdrawn
43 );
44 
45 // ERC20
46 event Transfer(
47 address indexed from,
48 address indexed to,
49 uint256 tokens
50 );
51 
52 
53 /*=====================================
54 =            CONFIGURABLES            =
55 =====================================*/
56 string public name = "POMDA";
57 string public symbol = "POMDA";
58 uint8 constant public decimals = 18;
59 uint8 constant internal dividendFee_ = 10;
60 uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
61 uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
62 uint256 constant internal magnitude = 2**64;
63 
64 // proof of stake (defaults at 100 tokens)
65 uint256 public stakingRequirement = 100e18;
66 
67 // ambassador program
68 mapping(address => bool) internal ambassadors_;
69 uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
70 uint256 constant internal ambassadorQuota_ = 20 ether;
71 
72 
73 
74 /*================================
75 =            DATASETS            =
76 ================================*/
77 // amount of shares for each address (scaled number)
78 mapping(address => uint256) internal tokenBalanceLedger_;
79 mapping(address => uint256) internal referralBalance_;
80 mapping(address => int256) internal payoutsTo_;
81 uint256 internal tokenSupply_ = 0;
82 uint256 internal profitPerShare_;
83 
84 
85 
86 
87 
88 /*=======================================
89 =            PUBLIC FUNCTIONS            =
90 =======================================*/
91 /*
92 * -- APPLICATION ENTRY POINTS --  
93 */
94 function POMDA()
95 public
96 {
97         
98 }
99 function buy(address _referredBy)
100 public
101 payable
102 returns(uint256)
103 {
104 purchaseTokens(msg.value, _referredBy);
105 }
106 
107 /**
108 * Fallback function to handle ethereum that was send straight to the contract
109 * Unfortunately we cannot use a referral address this way.
110 */
111 function()
112 payable
113 public
114 {
115 purchaseTokens(msg.value, 0x0);
116 }
117 
118 /**
119 * Converts all of caller's dividends to tokens.
120 */
121 function reinvest()
122 onlyStronghands()
123 public
124 {
125 // fetch dividends
126 uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
127 
128 // pay out the dividends virtually
129 address _customerAddress = msg.sender;
130 payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
131 
132 // retrieve ref. bonus
133 _dividends += referralBalance_[_customerAddress];
134 referralBalance_[_customerAddress] = 0;
135 
136 // dispatch a buy order with the virtualized "withdrawn dividends"
137 uint256 _tokens = purchaseTokens(_dividends, 0x0);
138 
139 // fire event
140 onReinvestment(_customerAddress, _dividends, _tokens);
141 }
142 
143 /**
144 * Alias of sell() and withdraw().
145 */
146 function exit()
147 public
148 {
149 // get token count for caller & sell them all
150 address _customerAddress = msg.sender;
151 uint256 _tokens = tokenBalanceLedger_[_customerAddress];
152 if(_tokens > 0) sell(_tokens);
153 
154 // lambo delivery service
155 withdraw();
156 }
157 
158 /**
159 * Withdraws all of the callers earnings.
160 */
161 function withdraw()
162 onlyStronghands()
163 public
164 {
165 // setup data
166 address _customerAddress = msg.sender;
167 uint256 _dividends = myDividends(false); // get ref. bonus later in the code
168 
169 // update dividend tracker
170 payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
171 
172 // add ref. bonus
173 _dividends += referralBalance_[_customerAddress];
174 referralBalance_[_customerAddress] = 0;
175 
176 // lambo delivery service
177 _customerAddress.transfer(_dividends);
178 
179 // fire event
180 onWithdraw(_customerAddress, _dividends);
181 }
182 
183 /**
184 * Liquifies tokens to ethereum.
185 */
186 function sell(uint256 _amountOfTokens)
187 onlyBagholders()
188 public
189 {
190 // setup data
191 address _customerAddress = msg.sender;
192 // russian hackers BTFO
193 require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
194 uint256 _tokens = _amountOfTokens;
195 uint256 _ethereum = tokensToEthereum_(_tokens);
196 uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
197 uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
198 
199 // burn the sold tokens
200 tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
201 tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
202 
203 // update dividends tracker
204 int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
205 payoutsTo_[_customerAddress] -= _updatedPayouts;       
206 
207 // dividing by zero is a bad idea
208 if (tokenSupply_ > 0) {
209 // update the amount of dividends per token
210 profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
211 }
212 
213 // fire event
214 onTokenSell(_customerAddress, _tokens, _taxedEthereum);
215 }
216 
217 
218 /**
219 * Transfer tokens from the caller to a new holder.
220 * Remember, there's a 10% fee here as well.
221 */
222 function transfer(address _toAddress, uint256 _amountOfTokens)
223 onlyBagholders()
224 public
225 returns(bool)
226 {
227 // setup
228 address _customerAddress = msg.sender;
229 
230 // make sure we have the requested tokens
231 // also disables transfers until ambassador phase is over
232 // ( we dont want whale premines )
233 //require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
234 
235 // withdraw all outstanding dividends first
236 if(myDividends(true) > 0) withdraw();
237 
238 // liquify 10% of the tokens that are transfered
239 // these are dispersed to shareholders
240 uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
241 uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
242 uint256 _dividends = tokensToEthereum_(_tokenFee);
243 
244 // burn the fee tokens
245 tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
246 
247 // exchange tokens
248 tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
249 tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
250 
251 // update dividend trackers
252 payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
253 payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
254 
255 // disperse dividends among holders
256 profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
257 
258 // fire event
259 Transfer(_customerAddress, _toAddress, _taxedTokens);
260 
261 // ERC20
262 return true;
263 
264 }
265 
266 
267 /*----------  HELPERS AND CALCULATORS  ----------*/
268 /**
269 * Method to view the current Ethereum stored in the contract
270 * Example: totalEthereumBalance()
271 */
272 function totalEthereumBalance()
273 public
274 view
275 returns(uint)
276 {
277 return this.balance;
278 }
279 
280 /**
281 * Retrieve the total token supply.
282 */
283 function totalSupply()
284 public
285 view
286 returns(uint256)
287 {
288 return tokenSupply_;
289 }
290 
291 /**
292 * Retrieve the tokens owned by the caller.
293 */
294 function myTokens()
295 public
296 view
297 returns(uint256)
298 {
299 address _customerAddress = msg.sender;
300 return balanceOf(_customerAddress);
301 }
302 
303 /**
304 * Retrieve the dividends owned by the caller.
305 * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
306 * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
307 * But in the internal calculations, we want them separate. 
308 */ 
309 function myDividends(bool _includeReferralBonus) 
310 public 
311 view 
312 returns(uint256)
313 {
314 address _customerAddress = msg.sender;
315 return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
316 }
317 
318 /**
319 * Retrieve the token balance of any single address.
320 */
321 function balanceOf(address _customerAddress)
322 view
323 public
324 returns(uint256)
325 {
326 return tokenBalanceLedger_[_customerAddress];
327 }
328 
329 /**
330 * Retrieve the dividend balance of any single address.
331 */
332 function dividendsOf(address _customerAddress)
333 view
334 public
335 returns(uint256)
336 {
337 return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
338 }
339 
340 /**
341 * Return the buy price of 1 individual token.
342 */
343 function sellPrice() 
344 public 
345 view 
346 returns(uint256)
347 {
348 // our calculation relies on the token supply, so we need supply. Doh.
349 if(tokenSupply_ == 0){
350 return tokenPriceInitial_ - tokenPriceIncremental_;
351 } else {
352 uint256 _ethereum = tokensToEthereum_(1e18);
353 uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
354 uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
355 return _taxedEthereum;
356 }
357 }
358 
359 /**
360 * Return the sell price of 1 individual token.
361 */
362 function buyPrice() 
363 public 
364 view 
365 returns(uint256)
366 {
367 // our calculation relies on the token supply, so we need supply. Doh.
368 if(tokenSupply_ == 0){
369 return tokenPriceInitial_ + tokenPriceIncremental_;
370 } else {
371 uint256 _ethereum = tokensToEthereum_(1e18);
372 uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
373 uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
374 return _taxedEthereum;
375 }
376 }
377 
378 /**
379 * Function for the frontend to dynamically retrieve the price scaling of buy orders.
380 */
381 function calculateTokensReceived(uint256 _ethereumToSpend) 
382 public 
383 view 
384 returns(uint256)
385 {
386 uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
387 uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
388 uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
389 
390 return _amountOfTokens;
391 }
392 
393 /**
394 * Function for the frontend to dynamically retrieve the price scaling of sell orders.
395 */
396 function calculateEthereumReceived(uint256 _tokensToSell) 
397 public 
398 view 
399 returns(uint256)
400 {
401 require(_tokensToSell <= tokenSupply_);
402 uint256 _ethereum = tokensToEthereum_(_tokensToSell);
403 uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
404 uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
405 return _taxedEthereum;
406 }
407 
408 
409 /*==========================================
410 =            INTERNAL FUNCTIONS            =
411 ==========================================*/
412 function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
413 //    antiEarlyWhale(_incomingEthereum)
414 internal
415 returns(uint256)
416 {
417 // data setup
418 address _customerAddress = msg.sender;
419 uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
420 uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
421 uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
422 uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
423 uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
424 uint256 _fee = _dividends * magnitude;
425 
426 // no point in continuing execution if OP is a poorfag russian hacker
427 // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
428 // (or hackers)
429 // and yes we know that the safemath function automatically rules out the "greater then" equasion.
430 require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
431 
432 // is the user referred by a masternode?
433 if(
434 // is this a referred purchase?
435 _referredBy != 0x0000000000000000000000000000000000000000 &&
436 
437 // no cheating!
438 _referredBy != _customerAddress &&
439 
440 // does the referrer have at least X whole tokens?
441 // i.e is the referrer a godly chad masternode
442 tokenBalanceLedger_[_referredBy] >= stakingRequirement
443 ){
444 // wealth redistribution
445 referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
446 } else {
447 // no ref purchase
448 // add the referral bonus back to the global dividends cake
449 _dividends = SafeMath.add(_dividends, _referralBonus);
450 _fee = _dividends * magnitude;
451 }
452 
453 // we can't give people infinite ethereum
454 if(tokenSupply_ > 0){
455 
456 // add tokens to the pool
457 tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
458 
459 // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
460 profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
461 
462 // calculate the amount of tokens the customer receives over his purchase 
463 _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
464 
465 } else {
466 // add tokens to the pool
467 tokenSupply_ = _amountOfTokens;
468 }
469 
470 // update circulating supply & the ledger address for the customer
471 tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
472 
473 // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
474 //really i know you think you do but you don't
475 int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
476 payoutsTo_[_customerAddress] += _updatedPayouts;
477 
478 // fire event
479 onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
480 
481 return _amountOfTokens;
482 }
483 
484 /**
485 * Calculate Token price based on an amount of incoming ethereum
486 * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
487 * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
488 */
489 function ethereumToTokens_(uint256 _ethereum)
490 internal
491 view
492 returns(uint256)
493 {
494 uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
495 uint256 _tokensReceived = 
496 (
497 (
498 // underflow attempts BTFO
499 SafeMath.sub(
500 (sqrt
501 (
502 (_tokenPriceInitial**2)
503 +
504 (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
505 +
506 (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
507 +
508 (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
509 )
510 ), _tokenPriceInitial
511 )
512 )/(tokenPriceIncremental_)
513 )-(tokenSupply_)
514 ;
515 
516 return _tokensReceived;
517 }
518 
519 /**
520 * Calculate token sell value.
521 * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
522 * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
523 */
524 function tokensToEthereum_(uint256 _tokens)
525 internal
526 view
527 returns(uint256)
528 {
529 
530 uint256 tokens_ = (_tokens + 1e18);
531 uint256 _tokenSupply = (tokenSupply_ + 1e18);
532 uint256 _etherReceived =
533 (
534 // underflow attempts BTFO
535 SafeMath.sub(
536 (
537 (
538 (
539 tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
540 )-tokenPriceIncremental_
541 )*(tokens_ - 1e18)
542 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
543 )
544 /1e18);
545 return _etherReceived;
546 }
547 
548 
549 //This is where all your gas goes, sorry
550 //Not sorry, you probably only paid 1 gwei
551 function sqrt(uint x) internal pure returns (uint y) {
552 uint z = (x + 1) / 2;
553 y = x;
554 while (z < y) {
555 y = z;
556 z = (x / z + z) / 2;
557 }
558 }
559 }
560 
561 /**
562 * @title SafeMath
563 * @dev Math operations with safety checks that throw on error
564 */
565 library SafeMath {
566 
567 /**
568 * @dev Multiplies two numbers, throws on overflow.
569 */
570 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
571 if (a == 0) {
572 return 0;
573 }
574 uint256 c = a * b;
575 assert(c / a == b);
576 return c;
577 }
578 
579 /**
580 * @dev Integer division of two numbers, truncating the quotient.
581 */
582 function div(uint256 a, uint256 b) internal pure returns (uint256) {
583 // assert(b > 0); // Solidity automatically throws when dividing by 0
584 uint256 c = a / b;
585 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
586 return c;
587 }
588 
589 /**
590 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
591 */
592 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
593 assert(b <= a);
594 return a - b;
595 }
596 
597 /**
598 * @dev Adds two numbers, throws on overflow.
599 */
600 function add(uint256 a, uint256 b) internal pure returns (uint256) {
601 uint256 c = a + b;
602 assert(c >= a);
603 return c;
604 }
605 }