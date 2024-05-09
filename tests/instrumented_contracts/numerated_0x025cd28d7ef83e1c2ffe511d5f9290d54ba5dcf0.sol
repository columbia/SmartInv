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
63 
64 contract ProductionUnitToken {
65 
66     /*=================================
67     =            MODIFIERS            =
68     =================================*/
69 
70     /// @dev Only people with tokens
71     modifier onlyBagholders {
72         require(myTokens() > 0);
73         _;
74     }
75 
76     /// @dev Only people with profits
77     modifier onlyStronghands {
78         require(myDividends(true) > 0);
79         _;
80     }
81 
82 
83     /*==============================
84     =            EVENTS            =
85     ==============================*/
86 
87     event onTokenPurchase(
88         address indexed customerAddress,
89         uint256 incomingEthereum,
90         uint256 tokensMinted,
91         address indexed referredBy,
92         uint timestamp,
93         uint256 price
94     );
95 
96     event onTokenSell(
97         address indexed customerAddress,
98         uint256 tokensBurned,
99         uint256 ethereumEarned,
100         uint timestamp,
101         uint256 price
102     );
103 
104     event onReinvestment(
105         address indexed customerAddress,
106         uint256 ethereumReinvested,
107         uint256 tokensMinted
108     );
109 
110     event onWithdraw(
111         address indexed customerAddress,
112         uint256 ethereumWithdrawn
113     );
114 
115     // ERC20
116     event Transfer(
117         address indexed from,
118         address indexed to,
119         uint256 tokens
120     );
121 
122 
123     /*=====================================
124     =            DEPENDENCIES             =
125     =====================================*/
126 
127     // MoonInc contract
128     MoonInc public moonIncContract;
129 
130 
131     /*=====================================
132     =            CONFIGURABLES            =
133     =====================================*/
134 
135     string public name = "Production Unit | Moon, Inc.";
136     string public symbol = "ProductionUnit";
137     uint8 constant public decimals = 18;
138 
139     /// @dev dividends for token purchase
140     uint8 public entryFee_;
141 
142     /// @dev dividends for token transfer
143     uint8 public transferFee_;
144 
145     /// @dev dividends for token selling
146     uint8 public exitFee_;
147 
148     /// @dev 20% of entryFee_ is given to referrer
149     uint8 constant internal refferalFee_ = 20;
150 
151     uint256 public tokenPriceInitial_; // original is 0.0000001 ether
152     uint256 public tokenPriceIncremental_; // original is 0.00000001 ether
153     uint256 constant internal magnitude = 2 ** 64;
154 
155     /// @dev proof of stake (10 tokens)
156     uint256 public stakingRequirement = 10e18;
157 
158     // cookie production multiplier (how many cookies do 1 token make per second)
159     uint256 public cookieProductionMultiplier;
160 
161     // auto start timer
162     uint256 public startTime;
163 
164     // Maximum amount of dev one time pre-mine
165     mapping(address => uint) public ambassadorsMaxPremine;
166     mapping(address => bool) public ambassadorsPremined;
167     mapping(address => address) public ambassadorsPrerequisite;
168 
169 
170    /*=================================
171     =            DATASETS            =
172     ================================*/
173 
174     // amount of shares for each address (scaled number)
175     mapping(address => uint256) internal tokenBalanceLedger_;
176     mapping(address => uint256) internal referralBalance_;
177     mapping(address => int256) internal payoutsTo_;
178     uint256 internal tokenSupply_;
179 
180 
181     /*=======================================
182     =            PUBLIC FUNCTIONS           =
183     =======================================*/
184 
185     /// @dev Set the MoonInc contract address to notify when token amount changes
186     function ProductionUnitToken(
187         address _moonIncContractAddress, uint8 _entryFee, uint8 _transferFee, uint8 _exitFee,
188         uint _tokenPriceInitial, uint _tokenPriceIncremental, uint _cookieProductionMultiplier, uint _startTime
189     ) public {
190         moonIncContract = MoonInc(_moonIncContractAddress);
191         entryFee_ = _entryFee;
192         transferFee_ = _transferFee;
193         exitFee_ = _exitFee;
194         tokenPriceInitial_ = _tokenPriceInitial;
195         tokenPriceIncremental_ = _tokenPriceIncremental;
196         cookieProductionMultiplier = _cookieProductionMultiplier;
197         startTime = _startTime;
198 
199         // Set ambassadors' maximum one time pre-mine amount (Total 1.29 ETH pre-mine).
200         uint BETA_DIVISOR = 1000; // TODO: remove this in main launch contract
201 
202         // MA
203         ambassadorsMaxPremine[0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD] = 0.28 ether / BETA_DIVISOR;
204         ambassadorsPremined[address(0)] = true; // first ambassador don't need prerequisite
205 
206         // BL
207         ambassadorsMaxPremine[0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f] = 0.28 ether / BETA_DIVISOR;
208         ambassadorsPrerequisite[0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f] = 0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD;
209 
210         // PH
211         ambassadorsMaxPremine[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = 0.28 ether / BETA_DIVISOR;
212         ambassadorsPrerequisite[0x183feBd8828a9ac6c70C0e27FbF441b93004fC05] = 0xc951D3463EbBa4e9Ec8dDfe1f42bc5895C46eC8f;
213 
214         // RS
215         ambassadorsMaxPremine[0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d] = 0.09 ether / BETA_DIVISOR;
216         ambassadorsPrerequisite[0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d] = 0x183feBd8828a9ac6c70C0e27FbF441b93004fC05;
217 
218         // LN
219         ambassadorsMaxPremine[0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05] = 0.09 ether / BETA_DIVISOR;
220         ambassadorsPrerequisite[0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05] = 0x1fbc2Ca750E003A56d706C595b49a0A430EBA92d;
221 
222         // LE
223         ambassadorsMaxPremine[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = 0.09 ether / BETA_DIVISOR;
224         ambassadorsPrerequisite[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = 0x41F29054E7c0BC59a8AF10f3a6e7C0E53B334e05;
225 
226         // MI
227         ambassadorsMaxPremine[0x0a3239799518E7F7F339867A4739282014b97Dcf] = 0.09 ether / BETA_DIVISOR;
228         ambassadorsPrerequisite[0x0a3239799518E7F7F339867A4739282014b97Dcf] = 0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41;
229 
230         // PO
231         ambassadorsMaxPremine[0x31529d5Ab0D299D9b0594B7f2ef3515Be668AA87] = 0.09 ether / BETA_DIVISOR;
232         ambassadorsPrerequisite[0x31529d5Ab0D299D9b0594B7f2ef3515Be668AA87] = 0x0a3239799518E7F7F339867A4739282014b97Dcf;
233     }
234 
235     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
236     function buy(address _referredBy) public payable returns (uint256) {
237         purchaseTokens(msg.value, _referredBy);
238     }
239 
240     /**
241      * @dev Fallback function to handle ethereum that was send straight to the contract
242      *  Unfortunately we cannot use a referral address this way.
243      */
244     function() payable public {
245         purchaseTokens(msg.value, 0x0);
246     }
247 
248     /// @dev Converts all of caller's dividends to tokens.
249     function reinvest() onlyStronghands public {
250         // fetch dividends
251         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
252 
253         // pay out the dividends virtually
254         address _customerAddress = msg.sender;
255         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
256 
257         // retrieve ref. bonus
258         _dividends += referralBalance_[_customerAddress];
259         referralBalance_[_customerAddress] = 0;
260 
261         // dispatch a buy order with the virtualized "withdrawn dividends"
262         uint256 _tokens = purchaseTokens(_dividends, 0x0);
263 
264         // fire event
265         onReinvestment(_customerAddress, _dividends, _tokens);
266     }
267 
268     /// @dev Alias of sell() and withdraw().
269     function exit() public {
270         // get token count for caller & sell them all
271         address _customerAddress = msg.sender;
272         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
273         if (_tokens > 0) sell(_tokens);
274 
275         // lambo delivery service
276         withdraw();
277     }
278 
279     /// @dev Withdraws all of the callers earnings.
280     function withdraw() onlyStronghands public {
281         // setup data
282         address _customerAddress = msg.sender;
283         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
284 
285         // update dividend tracker
286         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
287 
288         // add ref. bonus
289         _dividends += referralBalance_[_customerAddress];
290         referralBalance_[_customerAddress] = 0;
291 
292         // lambo delivery service
293         _customerAddress.transfer(_dividends);
294 
295         // fire event
296         onWithdraw(_customerAddress, _dividends);
297     }
298 
299     /// @dev Liquifies tokens to ethereum.
300     function sell(uint256 _amountOfTokens) onlyBagholders public {
301         require(now >= startTime);
302 
303         // setup data
304         address _customerAddress = msg.sender;
305         // russian hackers BTFO
306         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
307         uint256 _tokens = _amountOfTokens;
308         uint256 _ethereum = tokensToEthereum_(_tokens);
309         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
310         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
311 
312         // burn the sold tokens
313         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
314         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
315 
316         // update dividends tracker
317         int256 _updatedPayouts = (int256) (_taxedEthereum * magnitude);
318         payoutsTo_[_customerAddress] -= _updatedPayouts;
319 
320         // Tell MoonInc contract for tokens amount change, and transfer dividends.
321         moonIncContract.handleProductionDecrease.value(_dividends)(_customerAddress, _tokens * cookieProductionMultiplier);
322 
323         // fire event
324         onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
325     }
326 
327     /**
328      * @dev Transfer tokens from the caller to a new holder.
329      *  Remember, there's a fee here as well.
330      */
331     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
332         // setup
333         address _customerAddress = msg.sender;
334 
335         // make sure we have the requested tokens
336         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
337 
338         // withdraw all outstanding dividends first
339         if (myDividends(true) > 0) {
340             withdraw();
341         }
342 
343         // liquify 10% of the tokens that are transfered
344         // these are dispersed to shareholders
345         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
346         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
347         uint256 _dividends = tokensToEthereum_(_tokenFee);
348 
349         // burn the fee tokens
350         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
351 
352         // exchange tokens
353         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
354         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
355 
356         // Tell MoonInc contract for tokens amount change, and transfer dividends.
357         moonIncContract.handleProductionDecrease.value(_dividends)(_customerAddress, _amountOfTokens * cookieProductionMultiplier);
358         moonIncContract.handleProductionIncrease(_toAddress, _taxedTokens * cookieProductionMultiplier);
359 
360         // fire event
361         Transfer(_customerAddress, _toAddress, _taxedTokens);
362 
363         // ERC20
364         return true;
365     }
366 
367 
368     /*=====================================
369     =      HELPERS AND CALCULATORS        =
370     =====================================*/
371 
372     function getSettings() public view returns (uint8, uint8, uint8, uint256, uint256, uint256, uint256) {
373         return (entryFee_, transferFee_, exitFee_, tokenPriceInitial_,
374             tokenPriceIncremental_, cookieProductionMultiplier, startTime);
375     }
376 
377     /**
378      * @dev Method to view the current Ethereum stored in the contract
379      *  Example: totalEthereumBalance()
380      */
381     function totalEthereumBalance() public view returns (uint256) {
382         return this.balance;
383     }
384 
385     /// @dev Retrieve the total token supply.
386     function totalSupply() public view returns (uint256) {
387         return tokenSupply_;
388     }
389 
390     /// @dev Retrieve the tokens owned by the caller.
391     function myTokens() public view returns (uint256) {
392         address _customerAddress = msg.sender;
393         return balanceOf(_customerAddress);
394     }
395 
396     /**
397      * @dev Retrieve the dividends owned by the caller.
398      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
399      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
400      *  But in the internal calculations, we want them separate.
401      */
402     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
403         address _customerAddress = msg.sender;
404         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
405     }
406 
407     /// @dev Retrieve the token balance of any single address.
408     function balanceOf(address _customerAddress) public view returns (uint256) {
409         return tokenBalanceLedger_[_customerAddress];
410     }
411 
412     /// @dev Retrieve the dividend balance of any single address.
413     function dividendsOf(address _customerAddress) public view returns (uint256) {
414         return (uint256) ((int256) (-payoutsTo_[_customerAddress])) / magnitude;
415     }
416 
417     /// @dev Return the sell price of 1 individual token.
418     function sellPrice() public view returns (uint256) {
419         // our calculation relies on the token supply, so we need supply. Doh.
420         if (tokenSupply_ == 0) {
421             return tokenPriceInitial_ - tokenPriceIncremental_;
422         } else {
423             uint256 _ethereum = tokensToEthereum_(1e18);
424             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
425             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
426 
427             return _taxedEthereum;
428         }
429     }
430 
431     /// @dev Return the buy price of 1 individual token.
432     function buyPrice() public view returns (uint256) {
433         // our calculation relies on the token supply, so we need supply. Doh.
434         if (tokenSupply_ == 0) {
435             return tokenPriceInitial_ + tokenPriceIncremental_;
436         } else {
437             uint256 _ethereum = tokensToEthereum_(1e18);
438             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
439             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
440 
441             return _taxedEthereum;
442         }
443     }
444 
445     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
446     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
447         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
448         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
449         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
450 
451         return _amountOfTokens;
452     }
453 
454     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
455     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
456         require(_tokensToSell <= tokenSupply_);
457         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
458         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
459         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
460         return _taxedEthereum;
461     }
462 
463 
464     /*==========================================
465     =            INTERNAL FUNCTIONS            =
466     ==========================================*/
467 
468     /// @dev Internal function to actually purchase the tokens.
469     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
470         // Remove this on main launch
471         require(_incomingEthereum <= 1 finney);
472 
473         require(
474             // auto start
475             now >= startTime ||
476             // ambassador pre-mine within 1 hour before startTime, sequences enforced
477             (now >= startTime - 1 hours && !ambassadorsPremined[msg.sender] && ambassadorsPremined[ambassadorsPrerequisite[msg.sender]] && _incomingEthereum <= ambassadorsMaxPremine[msg.sender]) ||
478             // ambassador pre-mine within 10 minutes before startTime, sequences not enforced
479             (now >= startTime - 10 minutes && !ambassadorsPremined[msg.sender] && _incomingEthereum <= ambassadorsMaxPremine[msg.sender])
480         );
481 
482         if (now < startTime) {
483             ambassadorsPremined[msg.sender] = true;
484         }
485 
486         // data setup
487         address _customerAddress = msg.sender;
488         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
489         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
490         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
491         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
492         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
493 
494         // no point in continuing execution if OP is a poorfag russian hacker
495         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
496         // (or hackers)
497         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
498         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
499 
500         // is the user referred by a masternode?
501         if (
502             // is this a referred purchase?
503             _referredBy != 0x0000000000000000000000000000000000000000 &&
504 
505             // no cheating!
506             _referredBy != _customerAddress &&
507 
508             // does the referrer have at least X whole tokens?
509             // i.e is the referrer a godly chad masternode
510             tokenBalanceLedger_[_referredBy] >= stakingRequirement
511         ) {
512             // wealth redistribution
513             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
514         } else {
515             // no ref purchase
516             // add the referral bonus back to the global dividends cake
517             _dividends = SafeMath.add(_dividends, _referralBonus);
518         }
519 
520         // add tokens to the pool
521         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
522 
523         // update circulating supply & the ledger address for the customer
524         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
525 
526         // Tell MoonInc contract for tokens amount change, and transfer dividends.
527         moonIncContract.handleProductionIncrease.value(_dividends)(_customerAddress, _amountOfTokens * cookieProductionMultiplier);
528 
529         // fire event
530         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
531 
532         return _amountOfTokens;
533     }
534 
535     /**
536      * @dev Calculate Token price based on an amount of incoming ethereum
537      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
538      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
539      */
540     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
541         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
542         uint256 _tokensReceived =
543          (
544             (
545                 // underflow attempts BTFO
546                 SafeMath.sub(
547                     (sqrt
548                         (
549                             (_tokenPriceInitial ** 2)
550                             +
551                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
552                             +
553                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
554                             +
555                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
556                         )
557                     ), _tokenPriceInitial
558                 )
559             ) / (tokenPriceIncremental_)
560         ) - (tokenSupply_);
561 
562         return _tokensReceived;
563     }
564 
565     /**
566      * @dev Calculate token sell value.
567      *  It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
568      *  Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
569      */
570     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
571         uint256 tokens_ = (_tokens + 1e18);
572         uint256 _tokenSupply = (tokenSupply_ + 1e18);
573         uint256 _etherReceived =
574         (
575             // underflow attempts BTFO
576             SafeMath.sub(
577                 (
578                     (
579                         (
580                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
581                         ) - tokenPriceIncremental_
582                     ) * (tokens_ - 1e18)
583                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
584             )
585         / 1e18);
586 
587         return _etherReceived;
588     }
589 
590     /// @dev This is where all your gas goes.
591     function sqrt(uint256 x) internal pure returns (uint256 y) {
592         uint256 z = (x + 1) / 2;
593         y = x;
594 
595         while (z < y) {
596             y = z;
597             z = (x / z + z) / 2;
598         }
599     }
600 
601 
602 }
603 
604 
605 contract MoonInc {
606 
607     string public constant name  = "Cookie | Moon, Inc.";
608     string public constant symbol = "Cookie";
609     uint8 public constant decimals = 18;
610 
611     // Total balances
612     uint256 public totalEtherCookieResearchPool; // Eth dividends to be split between players' cookie production
613     uint256 public totalCookieProduction;
614     uint256 private roughSupply;
615     uint256 private lastTotalCookieSaveTime; // Last time any player claimed their produced cookie
616 
617     // Balances for each player
618     mapping(address => uint256) public cookieProduction;
619     mapping(address => uint256) public cookieBalance;
620     mapping(address => uint256) private lastCookieSaveTime; // Last time player claimed their produced cookie
621 
622     // Mapping of approved ERC20 transfers (by player)
623     mapping(address => mapping(address => uint256)) internal allowed;
624 
625     // Production unit contracts
626     ProductionUnitToken[] public productionUnitTokenContracts;
627     mapping(address => bool) productionUnitTokenContractAddresses;
628 
629     // Store the production unit start time to calculate sell price.
630     uint256[] public tokenContractStartTime;
631 
632     uint256 public constant firstUnitStartTime = 1526763600; // TODO: change this in main launch contract
633     
634     // ERC20 events
635     event Transfer(address indexed from, address indexed to, uint tokens);
636     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
637 
638     // Constructor
639     function MoonInc() public payable {
640         // Create first production unit (Space Kitty)
641         createProductionUnit1Beta();
642 
643         // Create first production unit (Space Rabbit)
644         // createProductionUnit2Beta();
645 
646         // Create first production unit (Space Hamster)
647         // createProductionUnit3Beta();
648     }
649 
650     function() public payable {
651         // Fallback will add to research pot
652         totalEtherCookieResearchPool += msg.value;
653     }
654 
655     // TODO: Create 7 createProductionUnit functions in main launch contract
656 
657     function createProductionUnit1Beta() public {
658         require(productionUnitTokenContracts.length == 0);
659 
660         createProductionUnitTokenContract(10, 10, 10, 0.0000001 ether / 1000, 0.00000001 ether / 1000, 1, firstUnitStartTime);
661     }
662 
663     function createProductionUnit2Beta() public {
664         require(productionUnitTokenContracts.length == 1);
665 
666         createProductionUnitTokenContract(15, 15, 15, 0.0000001 ether / 1000, 0.00000001 ether / 1000, 3, firstUnitStartTime + 1 days);
667     }
668 
669     function createProductionUnit3Beta() public {
670         require(productionUnitTokenContracts.length == 2);
671 
672         createProductionUnitTokenContract(20, 20, 20, 0.0000001 ether / 1000, 0.00000001 ether / 1000, 9, firstUnitStartTime + 2 days);
673     }
674 
675     function createProductionUnitTokenContract(
676         uint8 _entryFee, uint8 _transferFee, uint8 _exitFee, uint256 _tokenPriceInitial, 
677         uint256 _tokenPriceIncremental, uint256 _cookieProductionMultiplier, uint256 _startTime
678     ) internal {
679         ProductionUnitToken newContract = new ProductionUnitToken(address(this),
680             _entryFee, _transferFee, _exitFee, _tokenPriceInitial, _tokenPriceIncremental, _cookieProductionMultiplier, _startTime);
681         productionUnitTokenContracts.push(newContract);
682         productionUnitTokenContractAddresses[address(newContract)] = true;
683 
684         tokenContractStartTime.push(_startTime);
685     }
686 
687     function productionUnitTokenContractCount() public view returns (uint) {
688         return productionUnitTokenContracts.length;
689     }
690 
691     function handleProductionIncrease(address player, uint256 amount) public payable {
692         require(productionUnitTokenContractAddresses[msg.sender]);
693 
694         updatePlayersCookie(player);
695 
696         totalCookieProduction = SafeMath.add(totalCookieProduction, amount);
697         cookieProduction[player] = SafeMath.add(cookieProduction[player], amount);
698 
699         if (msg.value > 0) {
700             totalEtherCookieResearchPool += msg.value;
701         }
702     }
703 
704     function handleProductionDecrease(address player, uint256 amount) public payable {
705         require(productionUnitTokenContractAddresses[msg.sender]);
706 
707         updatePlayersCookie(player);
708 
709         totalCookieProduction = SafeMath.sub(totalCookieProduction, amount);
710         cookieProduction[player] = SafeMath.sub(cookieProduction[player], amount);
711 
712         if (msg.value > 0) {
713             totalEtherCookieResearchPool += msg.value;
714         }
715     }
716 
717     function getState() public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
718         return (totalCookieProduction, cookieProduction[msg.sender], totalSupply(), balanceOf(msg.sender), 
719             totalEtherCookieResearchPool, lastTotalCookieSaveTime, computeSellPrice());
720     }
721 
722     function totalSupply() public constant returns(uint256) {
723         return roughSupply + balanceOfTotalUnclaimedCookie();
724     }
725 
726     function balanceOf(address player) public constant returns(uint256) {
727         return cookieBalance[player] + balanceOfUnclaimedCookie(player);
728     }
729 
730     function balanceOfTotalUnclaimedCookie() public constant returns(uint256) {
731         if (lastTotalCookieSaveTime > 0 && lastTotalCookieSaveTime < block.timestamp) {
732             return (totalCookieProduction * (block.timestamp - lastTotalCookieSaveTime));
733         }
734 
735         return 0;
736     }
737 
738     function balanceOfUnclaimedCookie(address player) internal constant returns (uint256) {
739         uint256 lastSave = lastCookieSaveTime[player];
740 
741         if (lastSave > 0 && lastSave < block.timestamp) {
742             return (cookieProduction[player] * (block.timestamp - lastSave));
743         }
744 
745         return 0;
746     }
747 
748     function transfer(address recipient, uint256 amount) public returns (bool) {
749         updatePlayersCookie(msg.sender);
750         require(amount <= cookieBalance[msg.sender]);
751 
752         cookieBalance[msg.sender] -= amount;
753         cookieBalance[recipient] += amount;
754 
755         Transfer(msg.sender, recipient, amount);
756 
757         return true;
758     }
759 
760     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
761         updatePlayersCookie(player);
762         require(amount <= allowed[player][msg.sender] && amount <= cookieBalance[player]);
763 
764         cookieBalance[player] -= amount;
765         cookieBalance[recipient] += amount;
766         allowed[player][msg.sender] -= amount;
767 
768         Transfer(player, recipient, amount);
769 
770         return true;
771     }
772 
773     function approve(address approvee, uint256 amount) public returns (bool){
774         allowed[msg.sender][approvee] = amount;
775         Approval(msg.sender, approvee, amount);
776 
777         return true;
778     }
779 
780     function allowance(address player, address approvee) public constant returns(uint256){
781         return allowed[player][approvee];
782     }
783 
784     function updatePlayersCookie(address player) internal {
785         roughSupply += balanceOfTotalUnclaimedCookie();
786         cookieBalance[player] += balanceOfUnclaimedCookie(player);
787         lastTotalCookieSaveTime = block.timestamp;
788         lastCookieSaveTime[player] = block.timestamp;
789     }
790 
791     // Sell all cookies, the eth earned is calculated by the proportion of cookies owned.
792     // Selling of cookie is forbidden within one hour of new production unit launch.
793     function sellAllCookies() public {
794         updatePlayersCookie(msg.sender);
795 
796         uint256 sellPrice = computeSellPrice();
797 
798         require(sellPrice > 0);
799 
800         uint256 myCookies = cookieBalance[msg.sender];
801         uint256 value = myCookies * sellPrice / (1 ether);
802 
803         cookieBalance[msg.sender] = 0;
804 
805         msg.sender.transfer(value);
806     }
807 
808     // Compute sell price for 1 cookie, it is 0.5 when a new token contract is deployed,
809     // and then goes up until it reaches the maximum sell price after 5 days.
810     function computeSellPrice() public view returns (uint) {
811         uint256 supply = totalSupply();
812 
813         if (supply == 0) {
814             return 0;
815         }
816 
817         uint index;
818         uint lastTokenContractStartTime = now;
819 
820         while (index < tokenContractStartTime.length && tokenContractStartTime[index] < now) {
821             lastTokenContractStartTime = tokenContractStartTime[index];
822             index++;
823         }
824 
825         if (now < lastTokenContractStartTime + 1 hours) {
826             return 0;
827         }
828 
829         uint timeToMaxValue = 2 days; // TODO: change to 5 days in main launch contract
830 
831         uint256 secondsPassed = now - lastTokenContractStartTime;
832         secondsPassed = secondsPassed <= timeToMaxValue ? secondsPassed : timeToMaxValue;
833         uint256 multiplier = 5000 + 5000 * secondsPassed / timeToMaxValue;
834 
835         return 1 ether * totalEtherCookieResearchPool / supply * multiplier / 10000;
836     }
837 
838 }