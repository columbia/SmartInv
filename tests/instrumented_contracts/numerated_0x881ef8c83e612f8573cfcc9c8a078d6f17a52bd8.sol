1 pragma solidity 0.4.20;
2 
3 /*
4 * Team AppX presents - Moon, Inc. | Competitive Ethereum Idle Pyramid
5 * Website: https://mooninc.io/
6 * Backup: https://mooninc.surge.sh/
7 * Discord: https://discord.gg/9Ab8Az3
8 * 
9 * There are 2 contracts:
10 * 1. MoonInc: handle Cookie production, cookie price calulation and cookie selling
11 *      - Reference: [Goo] https://etherscan.io/address/0x57b116da40f21f91aec57329ecb763d29c1b2355#code
12 * 2. ProductionUnitToken: handle production units tokens buy, sell, reinvest and withdraw
13 *      - Reference: [PoWTF] https://etherscan.io/address/0x702392282255f8c0993dbbbb148d80d2ef6795b1#code
14 *
15 * Features:
16 * - You can buy workers with ETH to increase your cookies production.
17 * - You can sell your cookies and claim a proportion of the cookie fund.
18 * - You cannot sell cookies within the first hour of a new production unit launch.
19 * - The selling price of a cookie depends on the Cookie Fund and the total cookies supply, the formula is:
20 *   CookiePrice = CookieFund / TotalCookieSupply * Multiplier
21 *   * Where Multiplier is a number from 0.5 to 1, which starts with 0.5 after a new production unit started, and reaches maximum value (1) after 5 days.
22 * - You can sell your workers at any time like normal tokens
23 *
24 * Developed by by AppX Matthew, ft. MrBlobby | GOO
25 *
26 */
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   /**
57   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72   
73 }
74 
75 contract ProductionUnitToken {
76 
77     /*=================================
78     =            MODIFIERS            =
79     =================================*/
80 
81     /// @dev Only people with tokens
82     modifier onlyBagholders {
83         require(myTokens() > 0);
84         _;
85     }
86 
87     /// @dev Only people with profits
88     modifier onlyStronghands {
89         require(myDividends(true) > 0);
90         _;
91     }
92 
93 
94     /*==============================
95     =            EVENTS            =
96     ==============================*/
97 
98     event onTokenPurchase(
99         address indexed customerAddress,
100         uint256 incomingEthereum,
101         uint256 tokensMinted,
102         address indexed referredBy,
103         uint timestamp,
104         uint256 price
105     );
106 
107     event onTokenSell(
108         address indexed customerAddress,
109         uint256 tokensBurned,
110         uint256 ethereumEarned,
111         uint timestamp,
112         uint256 price
113     );
114 
115     event onReinvestment(
116         address indexed customerAddress,
117         uint256 ethereumReinvested,
118         uint256 tokensMinted
119     );
120 
121     event onWithdraw(
122         address indexed customerAddress,
123         uint256 ethereumWithdrawn
124     );
125 
126     // ERC20
127     event Transfer(
128         address indexed from,
129         address indexed to,
130         uint256 tokens
131     );
132 
133 
134     /*=====================================
135     =            DEPENDENCIES             =
136     =====================================*/
137 
138     // MoonInc contract
139     MoonInc public moonIncContract;
140 
141 
142     /*=====================================
143     =            CONFIGURABLES            =
144     =====================================*/
145 
146     string public name = "Production Unit | Moon, Inc.";
147     string public symbol = "ProductionUnit";
148     uint8 constant public decimals = 18;
149 
150     /// @dev dividends for token purchase
151     uint8 public entryFee_;
152 
153     /// @dev dividends for token transfer
154     uint8 public transferFee_;
155 
156     /// @dev dividends for token selling
157     uint8 public exitFee_;
158 
159     /// @dev 20% of entryFee_ is given to referrer
160     uint8 constant internal refferalFee_ = 20;
161 
162     uint256 public tokenPriceInitial_; // original is 0.0000001 ether
163     uint256 public tokenPriceIncremental_; // original is 0.00000001 ether
164     uint256 constant internal magnitude = 2 ** 64;
165 
166     /// @dev proof of stake (10 tokens)
167     uint256 public stakingRequirement = 10e18;
168 
169     // cookie production multiplier (how many cookies do 1 token make per second)
170     uint256 public cookieProductionMultiplier;
171 
172     // auto start timer
173     uint256 public startTime;
174 
175     // Maximum amount of dev one time pre-mine
176     mapping(address => uint) public ambassadorsMaxPremine;
177     mapping(address => bool) public ambassadorsPremined;
178     mapping(address => address) public ambassadorsPrerequisite;
179 
180 
181    /*=================================
182     =            DATASETS            =
183     ================================*/
184 
185     // amount of shares for each address (scaled number)
186     mapping(address => uint256) internal tokenBalanceLedger_;
187     mapping(address => uint256) internal referralBalance_;
188     mapping(address => int256) internal payoutsTo_;
189     uint256 internal tokenSupply_;
190 
191 
192     /*=======================================
193     =            PUBLIC FUNCTIONS           =
194     =======================================*/
195 
196     /// @dev Set the MoonInc contract address to notify when token amount changes
197     function ProductionUnitToken(
198         address _moonIncContractAddress, uint8 _entryFee, uint8 _transferFee, uint8 _exitFee,
199         uint _tokenPriceInitial, uint _tokenPriceIncremental, uint _cookieProductionMultiplier, uint _startTime
200     ) public {
201         moonIncContract = MoonInc(_moonIncContractAddress);
202         entryFee_ = _entryFee;
203         transferFee_ = _transferFee;
204         exitFee_ = _exitFee;
205         tokenPriceInitial_ = _tokenPriceInitial;
206         tokenPriceIncremental_ = _tokenPriceIncremental;
207         cookieProductionMultiplier = _cookieProductionMultiplier;
208         startTime = _startTime;
209 
210         // Set ambassadors' maximum one time pre-mine amount (Total 1.47 ETH pre-mine including last 2 ambassadors from contest).
211         // MA
212         ambassadorsMaxPremine[0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD] = 0.28 ether;
213         ambassadorsPremined[address(0)] = true; // first ambassador don't need prerequisite
214 
215         // BL
216         ambassadorsMaxPremine[0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f] = 0.28 ether;
217         ambassadorsPrerequisite[0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f] = 0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD;
218 
219         // PH
220         ambassadorsMaxPremine[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = 0.28 ether;
221         ambassadorsPrerequisite[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = 0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f;
222 
223         // RS
224         ambassadorsMaxPremine[0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d] = 0.09 ether;
225         ambassadorsPrerequisite[0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d] = 0x183feBd8828a9ac6c70C0e27FbF441b93004fC05;
226 
227         // LN
228         ambassadorsMaxPremine[0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05] = 0.09 ether;
229         ambassadorsPrerequisite[0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05] = 0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d;
230 
231         // LE
232         ambassadorsMaxPremine[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = 0.09 ether;
233         ambassadorsPrerequisite[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = 0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05;
234 
235         // MI
236         ambassadorsMaxPremine[0x0a3239799518E7F7F339867A4739282014b97Dcf] = 0.09 ether;
237         ambassadorsPrerequisite[0x0a3239799518E7F7F339867A4739282014b97Dcf] = 0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41;
238 
239         // PO
240         ambassadorsMaxPremine[0x31529d5Ab0D299D9b0594B7f2ef3515Be668AA87] = 0.09 ether;
241         ambassadorsPrerequisite[0x31529d5Ab0D299D9b0594B7f2ef3515Be668AA87] = 0x0a3239799518E7F7F339867A4739282014b97Dcf;
242     }
243 
244     bool public lastTwoAmbassadorsAdded;
245 
246     /// @dev Add the last 2 ambassadors from the invite contest because they both offline in the time the contract is deployed.
247     function addLastTwoAmbassadors(address _address1, address _address2) public {
248         require(msg.sender == 0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD && !lastTwoAmbassadorsAdded);
249 
250         lastTwoAmbassadorsAdded = true;
251 
252         // KHAN
253         ambassadorsMaxPremine[_address1] = 0.09 ether;
254         ambassadorsPrerequisite[_address1] = 0x31529d5Ab0D299D9b0594B7f2ef3515Be668AA87;
255 
256         // CRYPTOWHALE
257         ambassadorsMaxPremine[_address2] = 0.09 ether;
258         ambassadorsPrerequisite[_address2] = _address1;
259     }
260 
261     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
262     function buy(address _referredBy) public payable returns (uint256) {
263         purchaseTokens(msg.value, _referredBy);
264     }
265 
266     /**
267      * @dev Fallback function to handle ethereum that was send straight to the contract
268      *  Unfortunately we cannot use a referral address this way.
269      */
270     function() payable public {
271         purchaseTokens(msg.value, 0x0);
272     }
273 
274     /// @dev Converts all of caller's dividends to tokens.
275     function reinvest() onlyStronghands public {
276         // fetch dividends
277         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
278 
279         // pay out the dividends virtually
280         address _customerAddress = msg.sender;
281         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
282 
283         // retrieve ref. bonus
284         _dividends += referralBalance_[_customerAddress];
285         referralBalance_[_customerAddress] = 0;
286 
287         // dispatch a buy order with the virtualized "withdrawn dividends"
288         uint256 _tokens = purchaseTokens(_dividends, 0x0);
289 
290         // fire event
291         onReinvestment(_customerAddress, _dividends, _tokens);
292     }
293 
294     /// @dev Alias of sell() and withdraw().
295     function exit() public {
296         // get token count for caller & sell them all
297         address _customerAddress = msg.sender;
298         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
299         if (_tokens > 0) sell(_tokens);
300 
301         // lambo delivery service
302         withdraw();
303     }
304 
305     /// @dev Withdraws all of the callers earnings.
306     function withdraw() onlyStronghands public {
307         // setup data
308         address _customerAddress = msg.sender;
309         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
310 
311         // update dividend tracker
312         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
313 
314         // add ref. bonus
315         _dividends += referralBalance_[_customerAddress];
316         referralBalance_[_customerAddress] = 0;
317 
318         // lambo delivery service
319         _customerAddress.transfer(_dividends);
320 
321         // fire event
322         onWithdraw(_customerAddress, _dividends);
323     }
324 
325     /// @dev Liquifies tokens to ethereum.
326     function sell(uint256 _amountOfTokens) onlyBagholders public {
327         require(now >= startTime);
328 
329         // setup data
330         address _customerAddress = msg.sender;
331         // russian hackers BTFO
332         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
333         uint256 _tokens = _amountOfTokens;
334         uint256 _ethereum = tokensToEthereum_(_tokens);
335         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
336         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
337 
338         // burn the sold tokens
339         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
340         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
341 
342         // update dividends tracker
343         int256 _updatedPayouts = (int256) (_taxedEthereum * magnitude);
344         payoutsTo_[_customerAddress] -= _updatedPayouts;
345 
346         // Tell MoonInc contract for tokens amount change, and transfer dividends.
347         moonIncContract.handleProductionDecrease.value(_dividends)(_customerAddress, _tokens * cookieProductionMultiplier);
348 
349         // fire event
350         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
351     }
352 
353     /**
354      * @dev Transfer tokens from the caller to a new holder.
355      *  Remember, there's a fee here as well.
356      */
357     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
358         // setup
359         address _customerAddress = msg.sender;
360 
361         // make sure we have the requested tokens
362         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
363 
364         // withdraw all outstanding dividends first
365         if (myDividends(true) > 0) {
366             withdraw();
367         }
368 
369         // liquify 10% of the tokens that are transfered
370         // these are dispersed to shareholders
371         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
372         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
373         uint256 _dividends = tokensToEthereum_(_tokenFee);
374 
375         // burn the fee tokens
376         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
377 
378         // exchange tokens
379         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
380         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
381 
382         // Tell MoonInc contract for tokens amount change, and transfer dividends.
383         moonIncContract.handleProductionDecrease.value(_dividends)(_customerAddress, _amountOfTokens * cookieProductionMultiplier);
384         moonIncContract.handleProductionIncrease(_toAddress, _taxedTokens * cookieProductionMultiplier);
385 
386         // fire event
387         Transfer(_customerAddress, _toAddress, _taxedTokens);
388 
389         // ERC20
390         return true;
391     }
392 
393 
394     /*=====================================
395     =      HELPERS AND CALCULATORS        =
396     =====================================*/
397 
398     function getSettings() public view returns (uint8, uint8, uint8, uint256, uint256, uint256, uint256) {
399         return (entryFee_, transferFee_, exitFee_, tokenPriceInitial_,
400             tokenPriceIncremental_, cookieProductionMultiplier, startTime);
401     }
402 
403     /**
404      * @dev Method to view the current Ethereum stored in the contract
405      *  Example: totalEthereumBalance()
406      */
407     function totalEthereumBalance() public view returns (uint256) {
408         return this.balance;
409     }
410 
411     /// @dev Retrieve the total token supply.
412     function totalSupply() public view returns (uint256) {
413         return tokenSupply_;
414     }
415 
416     /// @dev Retrieve the tokens owned by the caller.
417     function myTokens() public view returns (uint256) {
418         address _customerAddress = msg.sender;
419         return balanceOf(_customerAddress);
420     }
421 
422     /**
423      * @dev Retrieve the dividends owned by the caller.
424      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
425      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
426      *  But in the internal calculations, we want them separate.
427      */
428     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
429         address _customerAddress = msg.sender;
430         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
431     }
432 
433     /// @dev Retrieve the token balance of any single address.
434     function balanceOf(address _customerAddress) public view returns (uint256) {
435         return tokenBalanceLedger_[_customerAddress];
436     }
437 
438     /// @dev Retrieve the dividend balance of any single address.
439     function dividendsOf(address _customerAddress) public view returns (uint256) {
440         return (uint256) ((int256) (-payoutsTo_[_customerAddress])) / magnitude;
441     }
442 
443     /// @dev Return the sell price of 1 individual token.
444     function sellPrice() public view returns (uint256) {
445         // our calculation relies on the token supply, so we need supply. Doh.
446         if (tokenSupply_ == 0) {
447             return tokenPriceInitial_ - tokenPriceIncremental_;
448         } else {
449             uint256 _ethereum = tokensToEthereum_(1e18);
450             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
451             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
452 
453             return _taxedEthereum;
454         }
455     }
456 
457     /// @dev Return the buy price of 1 individual token.
458     function buyPrice() public view returns (uint256) {
459         // our calculation relies on the token supply, so we need supply. Doh.
460         if (tokenSupply_ == 0) {
461             return tokenPriceInitial_ + tokenPriceIncremental_;
462         } else {
463             uint256 _ethereum = tokensToEthereum_(1e18);
464             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
465             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
466 
467             return _taxedEthereum;
468         }
469     }
470 
471     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
472     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
473         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
474         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
475         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
476 
477         return _amountOfTokens;
478     }
479 
480     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
481     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
482         require(_tokensToSell <= tokenSupply_);
483         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
484         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
485         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
486         return _taxedEthereum;
487     }
488 
489 
490     /*==========================================
491     =            INTERNAL FUNCTIONS            =
492     ==========================================*/
493 
494     /// @dev Internal function to actually purchase the tokens.
495     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
496         require(
497             // auto start
498             now >= startTime ||
499             // ambassador pre-mine within 1 hour before startTime, sequences enforced
500             (now >= startTime - 1 hours && !ambassadorsPremined[msg.sender] && ambassadorsPremined[ambassadorsPrerequisite[msg.sender]] && _incomingEthereum <= ambassadorsMaxPremine[msg.sender]) ||
501             // ambassador pre-mine within 10 minutes before startTime, sequences not enforced
502             (now >= startTime - 10 minutes && !ambassadorsPremined[msg.sender] && _incomingEthereum <= ambassadorsMaxPremine[msg.sender])
503         );
504 
505         if (now < startTime) {
506             ambassadorsPremined[msg.sender] = true;
507         }
508 
509         // data setup
510         address _customerAddress = msg.sender;
511         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
512         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
513         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
514         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
515         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
516 
517         // no point in continuing execution if OP is a poorfag russian hacker
518         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
519         // (or hackers)
520         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
521         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
522 
523         // is the user referred by a masternode?
524         if (
525             // is this a referred purchase?
526             _referredBy != 0x0000000000000000000000000000000000000000 &&
527 
528             // no cheating!
529             _referredBy != _customerAddress &&
530 
531             // does the referrer have at least X whole tokens?
532             // i.e is the referrer a godly chad masternode
533             tokenBalanceLedger_[_referredBy] >= stakingRequirement
534         ) {
535             // wealth redistribution
536             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
537         } else {
538             // no ref purchase
539             // add the referral bonus back to the global dividends cake
540             _dividends = SafeMath.add(_dividends, _referralBonus);
541         }
542 
543         // add tokens to the pool
544         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
545 
546         // update circulating supply & the ledger address for the customer
547         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
548 
549         // Tell MoonInc contract for tokens amount change, and transfer dividends.
550         moonIncContract.handleProductionIncrease.value(_dividends)(_customerAddress, _amountOfTokens * cookieProductionMultiplier);
551 
552         // fire event
553         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
554 
555         return _amountOfTokens;
556     }
557 
558     /**
559      * @dev Calculate Token price based on an amount of incoming ethereum
560      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
561      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
562      */
563     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
564         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
565         uint256 _tokensReceived =
566          (
567             (
568                 // underflow attempts BTFO
569                 SafeMath.sub(
570                     (sqrt
571                         (
572                             (_tokenPriceInitial ** 2)
573                             +
574                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
575                             +
576                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
577                             +
578                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
579                         )
580                     ), _tokenPriceInitial
581                 )
582             ) / (tokenPriceIncremental_)
583         ) - (tokenSupply_);
584 
585         return _tokensReceived;
586     }
587 
588     /**
589      * @dev Calculate token sell value.
590      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
591      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
592      */
593     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
594         uint256 tokens_ = (_tokens + 1e18);
595         uint256 _tokenSupply = (tokenSupply_ + 1e18);
596         uint256 _etherReceived =
597         (
598             // underflow attempts BTFO
599             SafeMath.sub(
600                 (
601                     (
602                         (
603                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
604                         ) - tokenPriceIncremental_
605                     ) * (tokens_ - 1e18)
606                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
607             )
608         / 1e18);
609 
610         return _etherReceived;
611     }
612 
613     /// @dev This is where all your gas goes.
614     function sqrt(uint256 x) internal pure returns (uint256 y) {
615         uint256 z = (x + 1) / 2;
616         y = x;
617 
618         while (z < y) {
619             y = z;
620             z = (x / z + z) / 2;
621         }
622     }
623 
624 
625 }
626 
627 contract MoonInc {
628 
629     string public constant name  = "Cookie | Moon, Inc.";
630     string public constant symbol = "Cookie";
631     uint8 public constant decimals = 18;
632 
633     // Global balances
634     uint256 public totalCookieProduction;
635     uint256 private roughSupply;
636     uint256 private lastTotalCookieSaveTime; // Last time any player claimed their produced cookie
637 
638     // Balances for each player
639     mapping(address => uint256) public cookieProduction;
640     mapping(address => uint256) public cookieBalance;
641     mapping(address => uint256) private lastCookieSaveTime; // Last time player claimed their produced cookie
642 
643     // Mapping of approved ERC20 transfers (by player)
644     mapping(address => mapping(address => uint256)) internal allowed;
645 
646     // Production unit contracts
647     ProductionUnitToken[] public productionUnitTokenContracts;
648     mapping(address => bool) productionUnitTokenContractAddresses;
649 
650     // Store the production unit start time to calculate sell price.
651     uint256[] public tokenContractStartTime;
652 
653     // Public launch at: Wed, 23 May 2018, 21:00 GMT
654     uint256 public constant firstUnitStartTime = 1527109200;
655     
656     // ERC20 events
657     event Transfer(address indexed from, address indexed to, uint tokens);
658     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
659 
660     // Constructor
661     function MoonInc() public payable {
662         // Create first production unit (Space Kitty)
663         createProductionUnit1();
664     }
665 
666     // No fallback function to avoid accidentally sending money to this contract instead of ProductionUnitToken contract.
667     // function() public payable {}
668 
669     // Public function to create the ProductionUnitToken contracts.
670 
671     function createProductionUnit1() public {
672         require(productionUnitTokenContracts.length == 0);
673 
674         createProductionUnitTokenContract(10, 10, 10, 0.0000001 ether, 0.00000001 ether, 1, firstUnitStartTime);
675     }
676 
677     function createProductionUnit2() public {
678         require(productionUnitTokenContracts.length == 1);
679 
680         createProductionUnitTokenContract(15, 15, 15, 0.0000001 ether, 0.00000001 ether, 3, firstUnitStartTime + 2 days);
681     }
682 
683     function createProductionUnit3() public {
684         require(productionUnitTokenContracts.length == 2);
685 
686         createProductionUnitTokenContract(20, 20, 20, 0.0000001 ether, 0.00000001 ether, 9, firstUnitStartTime + 4 days);
687     }
688 
689     function createProductionUnit4() public {
690         require(productionUnitTokenContracts.length == 3);
691 
692         createProductionUnitTokenContract(25, 25, 25, 0.0000001 ether, 0.00000001 ether, 3**3, firstUnitStartTime + 7 days);
693     }
694 
695     function createProductionUnit5() public {
696         require(productionUnitTokenContracts.length == 4);
697 
698         createProductionUnitTokenContract(30, 30, 30, 0.0000001 ether, 0.00000001 ether, 3**4, firstUnitStartTime + 11 days);
699     }
700 
701     function createProductionUnit6() public {
702         require(productionUnitTokenContracts.length == 5);
703 
704         createProductionUnitTokenContract(30, 30, 30, 0.0000001 ether, 0.00000001 ether, 3**5, firstUnitStartTime + 16 days);
705     }
706 
707     function createProductionUnit7() public {
708         require(productionUnitTokenContracts.length == 6);
709 
710         createProductionUnitTokenContract(30, 30, 30, 0.0000001 ether, 0.00000001 ether, 3**6, firstUnitStartTime + 21 days);
711     }
712 
713     function createProductionUnitTokenContract(
714         uint8 _entryFee, uint8 _transferFee, uint8 _exitFee, uint256 _tokenPriceInitial, 
715         uint256 _tokenPriceIncremental, uint256 _cookieProductionMultiplier, uint256 _startTime
716     ) internal {
717         ProductionUnitToken newContract = new ProductionUnitToken(address(this),
718             _entryFee, _transferFee, _exitFee, _tokenPriceInitial, _tokenPriceIncremental, _cookieProductionMultiplier, _startTime);
719         productionUnitTokenContracts.push(newContract);
720         productionUnitTokenContractAddresses[address(newContract)] = true;
721 
722         tokenContractStartTime.push(_startTime);
723     }
724 
725     function productionUnitTokenContractCount() public view returns (uint) {
726         return productionUnitTokenContracts.length;
727     }
728 
729     function handleProductionIncrease(address player, uint256 amount) public payable {
730         require(productionUnitTokenContractAddresses[msg.sender]);
731 
732         updatePlayersCookie(player);
733 
734         totalCookieProduction = SafeMath.add(totalCookieProduction, amount);
735         cookieProduction[player] = SafeMath.add(cookieProduction[player], amount);
736     }
737 
738     function handleProductionDecrease(address player, uint256 amount) public payable {
739         require(productionUnitTokenContractAddresses[msg.sender]);
740 
741         updatePlayersCookie(player);
742 
743         totalCookieProduction = SafeMath.sub(totalCookieProduction, amount);
744         cookieProduction[player] = SafeMath.sub(cookieProduction[player], amount);
745     }
746 
747     function getState() public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
748         return (totalCookieProduction, cookieProduction[msg.sender], totalSupply(), balanceOf(msg.sender), 
749             address(this).balance, lastTotalCookieSaveTime, computeSellPrice());
750     }
751 
752     function totalSupply() public constant returns(uint256) {
753         return roughSupply + balanceOfTotalUnclaimedCookie();
754     }
755 
756     function balanceOf(address player) public constant returns(uint256) {
757         return cookieBalance[player] + balanceOfUnclaimedCookie(player);
758     }
759 
760     function balanceOfTotalUnclaimedCookie() public constant returns(uint256) {
761         if (lastTotalCookieSaveTime > 0 && lastTotalCookieSaveTime < block.timestamp) {
762             return (totalCookieProduction * (block.timestamp - lastTotalCookieSaveTime));
763         }
764 
765         return 0;
766     }
767 
768     function balanceOfUnclaimedCookie(address player) internal constant returns (uint256) {
769         uint256 lastSave = lastCookieSaveTime[player];
770 
771         if (lastSave > 0 && lastSave < block.timestamp) {
772             return (cookieProduction[player] * (block.timestamp - lastSave));
773         }
774 
775         return 0;
776     }
777 
778     function transfer(address recipient, uint256 amount) public returns (bool) {
779         updatePlayersCookie(msg.sender);
780         require(amount <= cookieBalance[msg.sender]);
781 
782         cookieBalance[msg.sender] -= amount;
783         cookieBalance[recipient] += amount;
784 
785         Transfer(msg.sender, recipient, amount);
786 
787         return true;
788     }
789 
790     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
791         updatePlayersCookie(player);
792         require(amount <= allowed[player][msg.sender] && amount <= cookieBalance[player]);
793 
794         cookieBalance[player] -= amount;
795         cookieBalance[recipient] += amount;
796         allowed[player][msg.sender] -= amount;
797 
798         Transfer(player, recipient, amount);
799 
800         return true;
801     }
802 
803     function approve(address approvee, uint256 amount) public returns (bool){
804         allowed[msg.sender][approvee] = amount;
805         Approval(msg.sender, approvee, amount);
806 
807         return true;
808     }
809 
810     function allowance(address player, address approvee) public constant returns(uint256){
811         return allowed[player][approvee];
812     }
813 
814     function updatePlayersCookie(address player) internal {
815         roughSupply += balanceOfTotalUnclaimedCookie();
816         cookieBalance[player] += balanceOfUnclaimedCookie(player);
817         lastTotalCookieSaveTime = block.timestamp;
818         lastCookieSaveTime[player] = block.timestamp;
819     }
820 
821     // Sell all cookies, the eth earned is calculated by the proportion of cookies owned.
822     // Selling of cookie is forbidden within one hour of new production unit launch.
823     function sellAllCookies() public {
824         updatePlayersCookie(msg.sender);
825 
826         uint256 sellPrice = computeSellPrice();
827 
828         require(sellPrice > 0);
829 
830         uint256 myCookies = cookieBalance[msg.sender];
831         uint256 value = myCookies * sellPrice / (1 ether);
832 
833         cookieBalance[msg.sender] = 0;
834 
835         msg.sender.transfer(value);
836     }
837 
838     // Compute sell price for 1 cookie, it is 0.5 when a new token contract is deployed,
839     // and then goes up until it reaches the maximum sell price after 5 days.
840     function computeSellPrice() public view returns (uint) {
841         uint256 supply = totalSupply();
842 
843         if (supply == 0) {
844             return 0;
845         }
846 
847         uint index;
848         uint lastTokenContractStartTime = now;
849 
850         while (index < tokenContractStartTime.length && tokenContractStartTime[index] < now) {
851             lastTokenContractStartTime = tokenContractStartTime[index];
852             index++;
853         }
854 
855         if (now < lastTokenContractStartTime + 1 hours) {
856             return 0;
857         }
858 
859         uint timeToMaxValue = 5 days;
860 
861         uint256 secondsPassed = now - lastTokenContractStartTime;
862         secondsPassed = secondsPassed <= timeToMaxValue ? secondsPassed : timeToMaxValue;
863         uint256 multiplier = 5000 + 5000 * secondsPassed / timeToMaxValue;
864 
865         return 1 ether * address(this).balance / supply * multiplier / 10000;
866     }
867 
868 }