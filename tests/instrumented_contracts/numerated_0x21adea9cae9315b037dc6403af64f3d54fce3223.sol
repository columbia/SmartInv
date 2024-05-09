1 pragma solidity 0.4.20;
2 
3 /*
4 * Team AppX presents - Moon, Inc. | Competitive Ethereum Idle Pyramid
5 * 
6 * - You can buy workers with ETH to increase your cookies production.
7 * - You can sell your cookies and claim a proportion of the cookie fund.
8 * - You cannot sell cookies within the first hour of a new production unit launch.
9 * - The selling price of a cookie depends on the Cookie Fund and the total cookies supply, the formula is:
10 *   CookiePrice = CookieFund / TotalCookieSupply * Multiplier
11 *   * Where Multiplier is a number from 0.5 to 1, which starts with 0.5 after a new production unit started, and reaches maximum value (1) after 5 days.
12 * - You can sell your workers at any time like normal tokens
13 *
14 */
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   /**
45   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60   
61 }
62 
63 contract ProductionUnitToken {
64 
65     /*=================================
66     =            MODIFIERS            =
67     =================================*/
68 
69     /// @dev Only people with tokens
70     modifier onlyBagholders {
71         require(myTokens() > 0);
72         _;
73     }
74 
75     /// @dev Only people with profits
76     modifier onlyStronghands {
77         require(myDividends(true) > 0);
78         _;
79     }
80 
81 
82     /*==============================
83     =            EVENTS            =
84     ==============================*/
85 
86     event onTokenPurchase(
87         address indexed customerAddress,
88         uint256 incomingEthereum,
89         uint256 tokensMinted,
90         address indexed referredBy,
91         uint timestamp,
92         uint256 price
93     );
94 
95     event onTokenSell(
96         address indexed customerAddress,
97         uint256 tokensBurned,
98         uint256 ethereumEarned,
99         uint timestamp,
100         uint256 price
101     );
102 
103     event onReinvestment(
104         address indexed customerAddress,
105         uint256 ethereumReinvested,
106         uint256 tokensMinted
107     );
108 
109     event onWithdraw(
110         address indexed customerAddress,
111         uint256 ethereumWithdrawn
112     );
113 
114     // ERC20
115     event Transfer(
116         address indexed from,
117         address indexed to,
118         uint256 tokens
119     );
120 
121 
122     /*=====================================
123     =            DEPENDENCIES             =
124     =====================================*/
125 
126     // MoonInc contract
127     MoonInc public moonIncContract;
128 
129 
130     /*=====================================
131     =            CONFIGURABLES            =
132     =====================================*/
133 
134     string public name = "Production Unit | Moon, Inc.";
135     string public symbol = "ProductionUnit";
136     uint8 constant public decimals = 18;
137 
138     /// @dev dividends for token purchase
139     uint8 public entryFee_;
140 
141     /// @dev dividends for token transfer
142     uint8 public transferFee_;
143 
144     /// @dev dividends for token selling
145     uint8 public exitFee_;
146 
147     /// @dev 20% of entryFee_ is given to referrer
148     uint8 constant internal refferalFee_ = 20;
149 
150     uint256 public tokenPriceInitial_; // original is 0.0000001 ether
151     uint256 public tokenPriceIncremental_; // original is 0.00000001 ether
152     uint256 constant internal magnitude = 2 ** 64;
153 
154     /// @dev proof of stake (10 tokens)
155     uint256 public stakingRequirement = 10e18;
156 
157     // cookie production multiplier (how many cookies do 1 token make per second)
158     uint256 public cookieProductionMultiplier;
159 
160     // auto start timer
161     uint256 public startTime;
162 
163     // Maximum amount of dev one time pre-mine
164     mapping(address => uint) public ambassadorsMaxPremine;
165     mapping(address => bool) public ambassadorsPremined;
166     mapping(address => address) public ambassadorsPrerequisite;
167 
168 
169    /*=================================
170     =            DATASETS            =
171     ================================*/
172 
173     // amount of shares for each address (scaled number)
174     mapping(address => uint256) internal tokenBalanceLedger_;
175     mapping(address => uint256) internal referralBalance_;
176     mapping(address => int256) internal payoutsTo_;
177     uint256 internal tokenSupply_;
178 
179 
180     /*=======================================
181     =            PUBLIC FUNCTIONS           =
182     =======================================*/
183 
184     /// @dev Set the MoonInc contract address to notify when token amount changes
185     function ProductionUnitToken(
186         address _moonIncContractAddress, uint8 _entryFee, uint8 _transferFee, uint8 _exitFee,
187         uint _tokenPriceInitial, uint _tokenPriceIncremental, uint _cookieProductionMultiplier, uint _startTime
188     ) public {
189         moonIncContract = MoonInc(_moonIncContractAddress);
190         entryFee_ = _entryFee;
191         transferFee_ = _transferFee;
192         exitFee_ = _exitFee;
193         tokenPriceInitial_ = _tokenPriceInitial;
194         tokenPriceIncremental_ = _tokenPriceIncremental;
195         cookieProductionMultiplier = _cookieProductionMultiplier;
196         startTime = _startTime;
197 
198         // Set ambassadors' maximum one time pre-mine amount (Total 1.29 ETH pre-mine).
199         uint BETA_DIVISOR = 1000; // TODO: remove this in main launch contract
200 
201         // MA
202         ambassadorsMaxPremine[0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD] = 0.28 ether / BETA_DIVISOR;
203         ambassadorsPremined[address(0)] = true; // first ambassador don't need prerequisite
204 
205         // BL
206         ambassadorsMaxPremine[0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f] = 0.28 ether / BETA_DIVISOR;
207         ambassadorsPrerequisite[0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f] = 0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD;
208 
209         // PH
210         ambassadorsMaxPremine[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = 0.28 ether / BETA_DIVISOR;
211         ambassadorsPrerequisite[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = 0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f;
212 
213         // RS
214         ambassadorsMaxPremine[0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d] = 0.09 ether / BETA_DIVISOR;
215         ambassadorsPrerequisite[0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d] = 0x183feBd8828a9ac6c70C0e27FbF441b93004fC05;
216 
217         // LN
218         ambassadorsMaxPremine[0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05] = 0.09 ether / BETA_DIVISOR;
219         ambassadorsPrerequisite[0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05] = 0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d;
220 
221         // LE
222         ambassadorsMaxPremine[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = 0.09 ether / BETA_DIVISOR;
223         ambassadorsPrerequisite[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = 0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05;
224 
225         // MI
226         ambassadorsMaxPremine[0x0a3239799518E7F7F339867A4739282014b97Dcf] = 0.09 ether / BETA_DIVISOR;
227         ambassadorsPrerequisite[0x0a3239799518E7F7F339867A4739282014b97Dcf] = 0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41;
228 
229         // PO
230         ambassadorsMaxPremine[0x31529d5Ab0D299D9b0594B7f2ef3515Be668AA87] = 0.09 ether / BETA_DIVISOR;
231         ambassadorsPrerequisite[0x31529d5Ab0D299D9b0594B7f2ef3515Be668AA87] = 0x0a3239799518E7F7F339867A4739282014b97Dcf;
232     }
233 
234     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
235     function buy(address _referredBy) public payable returns (uint256) {
236         purchaseTokens(msg.value, _referredBy);
237     }
238 
239     /**
240      * @dev Fallback function to handle ethereum that was send straight to the contract
241      *  Unfortunately we cannot use a referral address this way.
242      */
243     function() payable public {
244         purchaseTokens(msg.value, 0x0);
245     }
246 
247     /// @dev Converts all of caller's dividends to tokens.
248     function reinvest() onlyStronghands public {
249         // fetch dividends
250         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
251 
252         // pay out the dividends virtually
253         address _customerAddress = msg.sender;
254         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
255 
256         // retrieve ref. bonus
257         _dividends += referralBalance_[_customerAddress];
258         referralBalance_[_customerAddress] = 0;
259 
260         // dispatch a buy order with the virtualized "withdrawn dividends"
261         uint256 _tokens = purchaseTokens(_dividends, 0x0);
262 
263         // fire event
264         onReinvestment(_customerAddress, _dividends, _tokens);
265     }
266 
267     /// @dev Alias of sell() and withdraw().
268     function exit() public {
269         // get token count for caller & sell them all
270         address _customerAddress = msg.sender;
271         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
272         if (_tokens > 0) sell(_tokens);
273 
274         // lambo delivery service
275         withdraw();
276     }
277 
278     /// @dev Withdraws all of the callers earnings.
279     function withdraw() onlyStronghands public {
280         // setup data
281         address _customerAddress = msg.sender;
282         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
283 
284         // update dividend tracker
285         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
286 
287         // add ref. bonus
288         _dividends += referralBalance_[_customerAddress];
289         referralBalance_[_customerAddress] = 0;
290 
291         // lambo delivery service
292         _customerAddress.transfer(_dividends);
293 
294         // fire event
295         onWithdraw(_customerAddress, _dividends);
296     }
297 
298     /// @dev Liquifies tokens to ethereum.
299     function sell(uint256 _amountOfTokens) onlyBagholders public {
300         require(now >= startTime);
301 
302         // setup data
303         address _customerAddress = msg.sender;
304         // russian hackers BTFO
305         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
306         uint256 _tokens = _amountOfTokens;
307         uint256 _ethereum = tokensToEthereum_(_tokens);
308         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
309         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
310 
311         // burn the sold tokens
312         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
313         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
314 
315         // update dividends tracker
316         int256 _updatedPayouts = (int256) (_taxedEthereum * magnitude);
317         payoutsTo_[_customerAddress] -= _updatedPayouts;
318 
319         // Tell MoonInc contract for tokens amount change, and transfer dividends.
320         moonIncContract.handleProductionDecrease.value(_dividends)(_customerAddress, _tokens * cookieProductionMultiplier);
321 
322         // fire event
323         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
324     }
325 
326     /**
327      * @dev Transfer tokens from the caller to a new holder.
328      *  Remember, there's a fee here as well.
329      */
330     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
331         // setup
332         address _customerAddress = msg.sender;
333 
334         // make sure we have the requested tokens
335         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336 
337         // withdraw all outstanding dividends first
338         if (myDividends(true) > 0) {
339             withdraw();
340         }
341 
342         // liquify 10% of the tokens that are transfered
343         // these are dispersed to shareholders
344         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
345         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
346         uint256 _dividends = tokensToEthereum_(_tokenFee);
347 
348         // burn the fee tokens
349         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
350 
351         // exchange tokens
352         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
353         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
354 
355         // Tell MoonInc contract for tokens amount change, and transfer dividends.
356         moonIncContract.handleProductionDecrease.value(_dividends)(_customerAddress, _amountOfTokens * cookieProductionMultiplier);
357         moonIncContract.handleProductionIncrease(_toAddress, _taxedTokens * cookieProductionMultiplier);
358 
359         // fire event
360         Transfer(_customerAddress, _toAddress, _taxedTokens);
361 
362         // ERC20
363         return true;
364     }
365 
366 
367     /*=====================================
368     =      HELPERS AND CALCULATORS        =
369     =====================================*/
370 
371     function getSettings() public view returns (uint8, uint8, uint8, uint256, uint256, uint256, uint256) {
372         return (entryFee_, transferFee_, exitFee_, tokenPriceInitial_,
373             tokenPriceIncremental_, cookieProductionMultiplier, startTime);
374     }
375 
376     /**
377      * @dev Method to view the current Ethereum stored in the contract
378      *  Example: totalEthereumBalance()
379      */
380     function totalEthereumBalance() public view returns (uint256) {
381         return this.balance;
382     }
383 
384     /// @dev Retrieve the total token supply.
385     function totalSupply() public view returns (uint256) {
386         return tokenSupply_;
387     }
388 
389     /// @dev Retrieve the tokens owned by the caller.
390     function myTokens() public view returns (uint256) {
391         address _customerAddress = msg.sender;
392         return balanceOf(_customerAddress);
393     }
394 
395     /**
396      * @dev Retrieve the dividends owned by the caller.
397      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
398      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
399      *  But in the internal calculations, we want them separate.
400      */
401     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
402         address _customerAddress = msg.sender;
403         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
404     }
405 
406     /// @dev Retrieve the token balance of any single address.
407     function balanceOf(address _customerAddress) public view returns (uint256) {
408         return tokenBalanceLedger_[_customerAddress];
409     }
410 
411     /// @dev Retrieve the dividend balance of any single address.
412     function dividendsOf(address _customerAddress) public view returns (uint256) {
413         return (uint256) ((int256) (-payoutsTo_[_customerAddress])) / magnitude;
414     }
415 
416     /// @dev Return the sell price of 1 individual token.
417     function sellPrice() public view returns (uint256) {
418         // our calculation relies on the token supply, so we need supply. Doh.
419         if (tokenSupply_ == 0) {
420             return tokenPriceInitial_ - tokenPriceIncremental_;
421         } else {
422             uint256 _ethereum = tokensToEthereum_(1e18);
423             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
424             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
425 
426             return _taxedEthereum;
427         }
428     }
429 
430     /// @dev Return the buy price of 1 individual token.
431     function buyPrice() public view returns (uint256) {
432         // our calculation relies on the token supply, so we need supply. Doh.
433         if (tokenSupply_ == 0) {
434             return tokenPriceInitial_ + tokenPriceIncremental_;
435         } else {
436             uint256 _ethereum = tokensToEthereum_(1e18);
437             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
438             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
439 
440             return _taxedEthereum;
441         }
442     }
443 
444     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
445     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
446         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
447         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
448         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
449 
450         return _amountOfTokens;
451     }
452 
453     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
454     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
455         require(_tokensToSell <= tokenSupply_);
456         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
457         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
458         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
459         return _taxedEthereum;
460     }
461 
462 
463     /*==========================================
464     =            INTERNAL FUNCTIONS            =
465     ==========================================*/
466 
467     /// @dev Internal function to actually purchase the tokens.
468     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
469         // Remove this on main launch
470         require(_incomingEthereum <= 1 finney);
471 
472         require(
473             // auto start
474             now >= startTime ||
475             // ambassador pre-mine within 1 hour before startTime, sequences enforced
476             (now >= startTime - 1 hours && !ambassadorsPremined[msg.sender] && ambassadorsPremined[ambassadorsPrerequisite[msg.sender]] && _incomingEthereum <= ambassadorsMaxPremine[msg.sender]) ||
477             // ambassador pre-mine within 10 minutes before startTime, sequences not enforced
478             (now >= startTime - 10 minutes && !ambassadorsPremined[msg.sender] && _incomingEthereum <= ambassadorsMaxPremine[msg.sender])
479         );
480 
481         if (now < startTime) {
482             ambassadorsPremined[msg.sender] = true;
483         }
484 
485         // data setup
486         address _customerAddress = msg.sender;
487         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
488         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
489         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
490         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
491         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
492 
493         // no point in continuing execution if OP is a poorfag russian hacker
494         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
495         // (or hackers)
496         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
497         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
498 
499         // is the user referred by a masternode?
500         if (
501             // is this a referred purchase?
502             _referredBy != 0x0000000000000000000000000000000000000000 &&
503 
504             // no cheating!
505             _referredBy != _customerAddress &&
506 
507             // does the referrer have at least X whole tokens?
508             // i.e is the referrer a godly chad masternode
509             tokenBalanceLedger_[_referredBy] >= stakingRequirement
510         ) {
511             // wealth redistribution
512             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
513         } else {
514             // no ref purchase
515             // add the referral bonus back to the global dividends cake
516             _dividends = SafeMath.add(_dividends, _referralBonus);
517         }
518 
519         // add tokens to the pool
520         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
521 
522         // update circulating supply & the ledger address for the customer
523         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
524 
525         // Tell MoonInc contract for tokens amount change, and transfer dividends.
526         moonIncContract.handleProductionIncrease.value(_dividends)(_customerAddress, _amountOfTokens * cookieProductionMultiplier);
527 
528         // fire event
529         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
530 
531         return _amountOfTokens;
532     }
533 
534     /**
535      * @dev Calculate Token price based on an amount of incoming ethereum
536      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
537      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
538      */
539     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
540         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
541         uint256 _tokensReceived =
542          (
543             (
544                 // underflow attempts BTFO
545                 SafeMath.sub(
546                     (sqrt
547                         (
548                             (_tokenPriceInitial ** 2)
549                             +
550                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
551                             +
552                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
553                             +
554                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
555                         )
556                     ), _tokenPriceInitial
557                 )
558             ) / (tokenPriceIncremental_)
559         ) - (tokenSupply_);
560 
561         return _tokensReceived;
562     }
563 
564     /**
565      * @dev Calculate token sell value.
566      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
567      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
568      */
569     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
570         uint256 tokens_ = (_tokens + 1e18);
571         uint256 _tokenSupply = (tokenSupply_ + 1e18);
572         uint256 _etherReceived =
573         (
574             // underflow attempts BTFO
575             SafeMath.sub(
576                 (
577                     (
578                         (
579                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
580                         ) - tokenPriceIncremental_
581                     ) * (tokens_ - 1e18)
582                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
583             )
584         / 1e18);
585 
586         return _etherReceived;
587     }
588 
589     /// @dev This is where all your gas goes.
590     function sqrt(uint256 x) internal pure returns (uint256 y) {
591         uint256 z = (x + 1) / 2;
592         y = x;
593 
594         while (z < y) {
595             y = z;
596             z = (x / z + z) / 2;
597         }
598     }
599 
600 
601 }
602 
603 contract MoonInc {
604 
605     string public constant name  = "Cookie | Moon, Inc.";
606     string public constant symbol = "Cookie";
607     uint8 public constant decimals = 18;
608 
609     // Total balances
610     uint256 public totalEtherCookieResearchPool; // Eth dividends to be split between players' cookie production
611     uint256 public totalCookieProduction;
612     uint256 private roughSupply;
613     uint256 private lastTotalCookieSaveTime; // Last time any player claimed their produced cookie
614 
615     // Balances for each player
616     mapping(address => uint256) public cookieProduction;
617     mapping(address => uint256) public cookieBalance;
618     mapping(address => uint256) private lastCookieSaveTime; // Last time player claimed their produced cookie
619 
620     // Mapping of approved ERC20 transfers (by player)
621     mapping(address => mapping(address => uint256)) internal allowed;
622 
623     // Production unit contracts
624     ProductionUnitToken[] public productionUnitTokenContracts;
625     mapping(address => bool) productionUnitTokenContractAddresses;
626 
627     // Store the production unit start time to calculate sell price.
628     uint256[] public tokenContractStartTime;
629 
630     uint256 public constant firstUnitStartTime = 1526763600; // TODO: change this in main launch contract
631     
632     // ERC20 events
633     event Transfer(address indexed from, address indexed to, uint tokens);
634     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
635 
636     // Constructor
637     function MoonInc() public payable {
638         // Create first production unit (Space Kitty)
639         createProductionUnit1Beta();
640 
641         // Create first production unit (Space Rabbit)
642         // createProductionUnit2Beta();
643 
644         // Create first production unit (Space Hamster)
645         // createProductionUnit3Beta();
646     }
647 
648     function() public payable {
649         // Fallback will add to research pot
650         totalEtherCookieResearchPool += msg.value;
651     }
652 
653     // TODO: Create 7 createProductionUnit functions in main launch contract
654 
655     function createProductionUnit1Beta() public {
656         require(productionUnitTokenContracts.length == 0);
657 
658         createProductionUnitTokenContract(10, 10, 10, 0.0000001 ether / 1000, 0.00000001 ether / 1000, 1, firstUnitStartTime);
659     }
660 
661     function createProductionUnit2Beta() public {
662         require(productionUnitTokenContracts.length == 1);
663 
664         createProductionUnitTokenContract(15, 15, 15, 0.0000001 ether / 1000, 0.00000001 ether / 1000, 3, firstUnitStartTime + 1 days);
665     }
666 
667     function createProductionUnit3Beta() public {
668         require(productionUnitTokenContracts.length == 2);
669 
670         createProductionUnitTokenContract(20, 20, 20, 0.0000001 ether / 1000, 0.00000001 ether / 1000, 9, firstUnitStartTime + 2 days);
671     }
672 
673     function createProductionUnitTokenContract(
674         uint8 _entryFee, uint8 _transferFee, uint8 _exitFee, uint256 _tokenPriceInitial, 
675         uint256 _tokenPriceIncremental, uint256 _cookieProductionMultiplier, uint256 _startTime
676     ) internal {
677         ProductionUnitToken newContract = new ProductionUnitToken(address(this),
678             _entryFee, _transferFee, _exitFee, _tokenPriceInitial, _tokenPriceIncremental, _cookieProductionMultiplier, _startTime);
679         productionUnitTokenContracts.push(newContract);
680         productionUnitTokenContractAddresses[address(newContract)] = true;
681 
682         tokenContractStartTime.push(_startTime);
683     }
684 
685     function productionUnitTokenContractCount() public view returns (uint) {
686         return productionUnitTokenContracts.length;
687     }
688 
689     function handleProductionIncrease(address player, uint256 amount) public payable {
690         require(productionUnitTokenContractAddresses[msg.sender]);
691 
692         updatePlayersCookie(player);
693 
694         totalCookieProduction = SafeMath.add(totalCookieProduction, amount);
695         cookieProduction[player] = SafeMath.add(cookieProduction[player], amount);
696 
697         if (msg.value > 0) {
698             totalEtherCookieResearchPool += msg.value;
699         }
700     }
701 
702     function handleProductionDecrease(address player, uint256 amount) public payable {
703         require(productionUnitTokenContractAddresses[msg.sender]);
704 
705         updatePlayersCookie(player);
706 
707         totalCookieProduction = SafeMath.sub(totalCookieProduction, amount);
708         cookieProduction[player] = SafeMath.sub(cookieProduction[player], amount);
709 
710         if (msg.value > 0) {
711             totalEtherCookieResearchPool += msg.value;
712         }
713     }
714 
715     function getState() public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
716         return (totalCookieProduction, cookieProduction[msg.sender], totalSupply(), balanceOf(msg.sender), 
717             totalEtherCookieResearchPool, lastTotalCookieSaveTime, computeSellPrice());
718     }
719 
720     function totalSupply() public constant returns(uint256) {
721         return roughSupply + balanceOfTotalUnclaimedCookie();
722     }
723 
724     function balanceOf(address player) public constant returns(uint256) {
725         return cookieBalance[player] + balanceOfUnclaimedCookie(player);
726     }
727 
728     function balanceOfTotalUnclaimedCookie() public constant returns(uint256) {
729         if (lastTotalCookieSaveTime > 0 && lastTotalCookieSaveTime < block.timestamp) {
730             return (totalCookieProduction * (block.timestamp - lastTotalCookieSaveTime));
731         }
732 
733         return 0;
734     }
735 
736     function balanceOfUnclaimedCookie(address player) internal constant returns (uint256) {
737         uint256 lastSave = lastCookieSaveTime[player];
738 
739         if (lastSave > 0 && lastSave < block.timestamp) {
740             return (cookieProduction[player] * (block.timestamp - lastSave));
741         }
742 
743         return 0;
744     }
745 
746     function transfer(address recipient, uint256 amount) public returns (bool) {
747         updatePlayersCookie(msg.sender);
748         require(amount <= cookieBalance[msg.sender]);
749 
750         cookieBalance[msg.sender] -= amount;
751         cookieBalance[recipient] += amount;
752 
753         Transfer(msg.sender, recipient, amount);
754 
755         return true;
756     }
757 
758     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
759         updatePlayersCookie(player);
760         require(amount <= allowed[player][msg.sender] && amount <= cookieBalance[player]);
761 
762         cookieBalance[player] -= amount;
763         cookieBalance[recipient] += amount;
764         allowed[player][msg.sender] -= amount;
765 
766         Transfer(player, recipient, amount);
767 
768         return true;
769     }
770 
771     function approve(address approvee, uint256 amount) public returns (bool){
772         allowed[msg.sender][approvee] = amount;
773         Approval(msg.sender, approvee, amount);
774 
775         return true;
776     }
777 
778     function allowance(address player, address approvee) public constant returns(uint256){
779         return allowed[player][approvee];
780     }
781 
782     function updatePlayersCookie(address player) internal {
783         uint256 cookieGain = balanceOfUnclaimedCookie(player);
784         lastTotalCookieSaveTime = block.timestamp;
785         lastCookieSaveTime[player] = block.timestamp;
786         roughSupply += cookieGain;
787         cookieBalance[player] += cookieGain;
788     }
789 
790     // Sell all cookies, the eth earned is calculated by the proportion of cookies owned.
791     // Selling of cookie is forbidden within one hour of new production unit launch.
792     function sellAllCookies() public {
793         updatePlayersCookie(msg.sender);
794 
795         uint256 sellPrice = computeSellPrice();
796 
797         require(sellPrice > 0);
798 
799         uint256 myCookies = cookieBalance[msg.sender];
800         uint256 value = myCookies * sellPrice / (1 ether);
801 
802         cookieBalance[msg.sender] = 0;
803 
804         msg.sender.transfer(value);
805     }
806 
807     // Compute sell price for 1 cookie, it is 0.5 when a new token contract is deployed,
808     // and then goes up until it reaches the maximum sell price after 5 days.
809     function computeSellPrice() public view returns (uint) {
810         uint256 supply = totalSupply();
811 
812         if (supply == 0) {
813             return 0;
814         }
815 
816         uint index;
817         uint lastTokenContractStartTime = now;
818 
819         while (index < tokenContractStartTime.length && tokenContractStartTime[index] < now) {
820             lastTokenContractStartTime = tokenContractStartTime[index];
821             index++;
822         }
823 
824         if (now < lastTokenContractStartTime + 1 hours) {
825             return 0;
826         }
827 
828         uint timeToMaxValue = 2 days; // TODO: change to 5 days in main launch contract
829 
830         uint256 secondsPassed = now - lastTokenContractStartTime;
831         secondsPassed = secondsPassed <= timeToMaxValue ? secondsPassed : timeToMaxValue;
832         uint256 multiplier = 5000 + 5000 * secondsPassed / timeToMaxValue;
833 
834         return 1 ether * totalEtherCookieResearchPool / supply * multiplier / 10000;
835     }
836 
837 }