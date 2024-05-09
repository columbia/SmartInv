1 pragma solidity ^0.4.20;
2 
3 
4 contract Win {
5     /*=================================
6     =            MODIFIERS            =
7     =================================*/
8     // only people with tokens
9     modifier onlyBagholders() {
10         require(myTokens() > 0);
11         _;
12     }
13 
14     // only people with profits
15     modifier onlyStronghands() {
16         require(myDividends(true) > 0);
17         _;
18     }
19 
20     modifier onlyAdministrator(){
21         address _customerAddress = msg.sender;
22         require(administrators[_customerAddress] == true);
23         _;
24     }
25 
26     modifier gameIsActive {
27         require(gameActive == true);
28         _;
29     }
30 
31 
32 
33     /*==============================
34     =            EVENTS            =
35     ==============================*/
36     event onTokenPurchase(
37         address indexed customerAddress,
38         uint256 incomingEthereum,
39         uint256 tokensMinted,
40         address indexed referredBy
41     );
42 
43     event onTokenSell(
44         address indexed customerAddress,
45         uint256 tokensBurned,
46         uint256 ethereumEarned
47     );
48 
49     event onReinvestment(
50         address indexed customerAddress,
51         uint256 ethereumReinvested,
52         uint256 tokensMinted
53     );
54 
55     event onWithdraw(
56         address indexed customerAddress,
57         uint256 ethereumWithdrawn
58     );
59 
60     // ERC20
61     event Transfer(
62         address indexed from,
63         address indexed to,
64         uint256 tokens
65     );
66 
67     event onAddDividend(address indexed sender, uint _incomingEthereum, uint profitPerShare_);
68 
69 
70 
71     /*=====================================
72     =            CONFIGURABLES            =
73     =====================================*/
74     string public name = "WIN";
75     string public symbol = "WIN";
76     uint8 constant public decimals = 18;
77     uint8 constant internal dividendFee_ = 6;
78     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
79     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
80     uint256 constant internal magnitude = 2 ** 64;
81 
82     // proof of stake (defaults at 100 tokens)
83     uint256 public stakingRequirement = 100e18;
84 
85     uint256 internal winFunds;
86 
87     bool public gameActive;
88 
89 
90     /*================================
91      =            DATASETS            =
92      ================================*/
93     // amount of shares for each address (scaled number)
94     mapping(address => uint256) internal tokenBalanceLedger_;
95     mapping(address => uint256) internal referralBalance_;
96     mapping(address => int256) internal payoutsTo_;
97     uint256 internal tokenSupply_ = 0;
98     uint256 internal profitPerShare_;
99 
100     // administrator list (see above on what they can do)
101     mapping(address => bool) public administrators;
102 
103 
104     /*=======================================
105     =            PUBLIC FUNCTIONS            =
106     =======================================*/
107     /*
108     * -- APPLICATION ENTRY POINTS --
109     */
110     constructor () public
111     {
112         administrators[msg.sender] = true;
113         gameActive = true;
114 
115     }
116 
117     function addDividend()
118     onlyAdministrator
119     public
120     payable
121     {
122         uint _incomingEthereum = msg.value;
123         require(_incomingEthereum > 0);
124         profitPerShare_ = SafeMath.add(profitPerShare_, (_incomingEthereum * magnitude) / tokenSupply_);
125         emit onAddDividend(msg.sender, _incomingEthereum, profitPerShare_);
126     }
127 
128 
129     /**
130      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
131      */
132     function buy(address _referredBy)
133     public
134     payable
135     returns (uint256)
136     {
137         purchaseTokens(msg.value, _referredBy);
138     }
139 
140     /**
141      * Fallback function to handle ethereum that was send straight to the contract
142      * Unfortunately we cannot use a referral address this way.
143      */
144     function()
145     payable
146     public
147     {
148         purchaseTokens(msg.value, 0x0);
149     }
150 
151     /**
152      * Converts all of caller's dividends to tokens.
153      */
154     function reinvest()
155     gameIsActive
156     onlyStronghands()
157     public
158     {
159         // fetch dividends
160         uint256 _dividends = myDividends(false);
161         // retrieve ref. bonus later in the code
162 
163         // pay out the dividends virtually
164         address _customerAddress = msg.sender;
165         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
166 
167         // retrieve ref. bonus
168         _dividends += referralBalance_[_customerAddress];
169         referralBalance_[_customerAddress] = 0;
170 
171         // dispatch a buy order with the virtualized "withdrawn dividends"
172         uint256 _tokens = purchaseTokens(_dividends, 0x0);
173 
174         // fire event
175         emit onReinvestment(_customerAddress, _dividends, _tokens);
176     }
177 
178     /**
179      * Alias of sell() and withdraw().
180      */
181     function exit()
182     gameIsActive
183     public
184     {
185         // get token count for caller & sell them all
186         address _customerAddress = msg.sender;
187         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
188         if (_tokens > 0) sell(_tokens);
189 
190         // lambo delivery service
191         withdraw();
192     }
193 
194     /**
195      * Withdraws all of the callers earnings.
196      */
197     function withdraw()
198     gameIsActive
199     onlyStronghands()
200     public
201     {
202         // setup data
203         address _customerAddress = msg.sender;
204         uint256 _dividends = myDividends(false);
205         // get ref. bonus later in the code
206 
207         // update dividend tracker
208         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
209 
210         // add ref. bonus
211         _dividends += referralBalance_[_customerAddress];
212         referralBalance_[_customerAddress] = 0;
213 
214         require(SafeMath.sub(totalEthereumBalance(),winFunds)>_dividends);
215 
216         // lambo delivery service
217         _customerAddress.transfer(_dividends);
218 
219         // fire event
220         emit onWithdraw(_customerAddress, _dividends);
221     }
222 
223     /**
224      * Liquifies tokens to ethereum.
225      */
226     function sell(uint256 _amountOfTokens)
227     gameIsActive
228     onlyBagholders()
229     public
230     {
231         // setup data
232         address _customerAddress = msg.sender;
233         // russian hackers BTFO
234         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
235         uint256 _tokens = _amountOfTokens;
236         uint256 _ethereum = tokensToEthereum_(_tokens);
237         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
238         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
239 
240         uint256 funds = SafeMath.div(_dividends, 10);
241         winFunds = SafeMath.add(winFunds,funds);
242         _dividends = SafeMath.sub(_dividends, funds);
243 
244         // burn the sold tokens
245         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
246         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
247 
248         // update dividends tracker
249         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
250         payoutsTo_[_customerAddress] -= _updatedPayouts;
251 
252         // dividing by zero is a bad idea
253         if (tokenSupply_ > 0) {
254             // update the amount of dividends per token
255             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
256         }
257 
258         // fire event
259         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
260     }
261 
262 
263     /**
264      * Transfer tokens from the caller to a new holder.
265      * Remember, there's a 10% fee here as well.
266      */
267     function transfer(address _toAddress, uint256 _amountOfTokens)
268     gameIsActive
269     onlyBagholders()
270     public
271     returns (bool)
272     {
273         // setup
274         address _customerAddress = msg.sender;
275 
276         // ( we dont want whale premines )
277         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
278 
279         // withdraw all outstanding dividends first
280         if (myDividends(true) > 0) withdraw();
281 
282         // liquify 10% of the tokens that are transfered
283         // these are dispersed to shareholders
284         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
285         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
286         uint256 _dividends = tokensToEthereum_(_tokenFee);
287 
288         uint256 funds = SafeMath.div(_dividends, 10);
289         winFunds = SafeMath.add(winFunds,funds);
290         _dividends = SafeMath.sub(_dividends, funds);
291 
292         // burn the fee tokens
293         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
294 
295         // exchange tokens
296         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
297         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
298 
299         // update dividend trackers
300         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
301         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
302 
303         // disperse dividends among holders
304         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
305 
306         // fire event
307         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
308 
309         // ERC20
310         return true;
311 
312     }
313 
314     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
315 
316     function getFunds() onlyAdministrator view public returns(uint) {
317         return winFunds;
318     }
319 
320     function withdrawAllFunds(address to) onlyAdministrator public {
321         to.transfer(winFunds);
322         winFunds = 0;
323     }
324 
325     function withdrawFunds(address to,uint256 value) onlyAdministrator public {
326         require(winFunds>=value);
327         to.transfer(value);
328         winFunds = SafeMath.sub(winFunds,value);
329     }
330 
331     function setGameActive(bool value) onlyAdministrator public {
332         gameActive = value;
333     }
334 
335     function setAdministrator(address _identifier, bool _status)
336     onlyAdministrator()
337     public
338     {
339         administrators[_identifier] = _status;
340     }
341 
342     /**
343      * Precautionary measures in case we need to adjust the masternode rate.
344      */
345     function setStakingRequirement(uint256 _amountOfTokens)
346     onlyAdministrator()
347     public
348     {
349         stakingRequirement = _amountOfTokens;
350     }
351 
352     /**
353      * If we want to rebrand, we can.
354      */
355     function setName(string _name)
356     onlyAdministrator()
357     public
358     {
359         name = _name;
360     }
361 
362     /**
363      * If we want to rebrand, we can.
364      */
365     function setSymbol(string _symbol)
366     onlyAdministrator()
367     public
368     {
369         symbol = _symbol;
370     }
371 
372 
373     /*----------  HELPERS AND CALCULATORS  ----------*/
374     /**
375      * Method to view the current Ethereum stored in the contract
376      * Example: totalEthereumBalance()
377      */
378     function totalEthereumBalance()
379     public
380     view
381     returns (uint)
382     {
383         return address(this).balance;
384     }
385 
386     /**
387      * Retrieve the total token supply.
388      */
389     function totalSupply()
390     public
391     view
392     returns (uint256)
393     {
394         return tokenSupply_;
395     }
396 
397     /**
398      * Retrieve the tokens owned by the caller.
399      */
400     function myTokens()
401     public
402     view
403     returns (uint256)
404     {
405         address _customerAddress = msg.sender;
406         return balanceOf(_customerAddress);
407     }
408 
409     /**
410      * Retrieve the dividends owned by the caller.
411      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
412      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
413      * But in the internal calculations, we want them separate.
414      */
415     function myDividends(bool _includeReferralBonus)
416     public
417     view
418     returns (uint256)
419     {
420         address _customerAddress = msg.sender;
421         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
422     }
423 
424     /**
425      * Retrieve the token balance of any single address.
426      */
427     function balanceOf(address _customerAddress)
428     view
429     public
430     returns (uint256)
431     {
432         return tokenBalanceLedger_[_customerAddress];
433     }
434 
435     /**
436      * Retrieve the dividend balance of any single address.
437      */
438     function dividendsOf(address _customerAddress)
439     view
440     public
441     returns (uint256)
442     {
443         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
444     }
445 
446     /**
447      * Return the buy price of 1 individual token.
448      */
449     function sellPrice()
450     public
451     view
452     returns (uint256)
453     {
454         // our calculation relies on the token supply, so we need supply. Doh.
455         if (tokenSupply_ == 0) {
456             return tokenPriceInitial_ - tokenPriceIncremental_;
457         } else {
458             uint256 _ethereum = tokensToEthereum_(1e18);
459             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
460             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
461             return _taxedEthereum;
462         }
463     }
464 
465     /**
466      * Return the sell price of 1 individual token.
467      */
468     function buyPrice()
469     public
470     view
471     returns (uint256)
472     {
473         // our calculation relies on the token supply, so we need supply. Doh.
474         if (tokenSupply_ == 0) {
475             return tokenPriceInitial_ + tokenPriceIncremental_;
476         } else {
477             uint256 _ethereum = tokensToEthereum_(1e18);
478             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
479             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
480             return _taxedEthereum;
481         }
482     }
483 
484     /**
485      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
486      */
487     function calculateTokensReceived(uint256 _ethereumToSpend)
488     public
489     view
490     returns (uint256)
491     {
492         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
493         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
494         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
495 
496         return _amountOfTokens;
497     }
498 
499     /**
500      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
501      */
502     function calculateEthereumReceived(uint256 _tokensToSell)
503     public
504     view
505     returns (uint256)
506     {
507         require(_tokensToSell <= tokenSupply_);
508         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
509         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
510         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
511         return _taxedEthereum;
512     }
513 
514 
515     /*==========================================
516     =            INTERNAL FUNCTIONS            =
517     ==========================================*/
518     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
519     gameIsActive
520     internal
521     returns (uint256)
522     {
523         // data setup
524         address _customerAddress = msg.sender;
525         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
526         uint256 _referralBonus = SafeMath.div(_undividedDividends, 5);
527         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
528 
529         uint256 funds = SafeMath.div(_undividedDividends, 10);
530         winFunds = SafeMath.add(winFunds,funds);
531         _dividends = SafeMath.sub(_dividends, funds);
532 
533         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
534         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
535         uint256 _fee = _dividends * magnitude;
536 
537         // no point in continuing execution if OP is a poorfag russian hacker
538         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
539         // (or hackers)
540         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
541         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_));
542 
543         // is the user referred by a masternode?
544         if (
545         // is this a referred purchase?
546             _referredBy != 0x0000000000000000000000000000000000000000 &&
547 
548             // no cheating!
549             _referredBy != _customerAddress &&
550 
551             // does the referrer have at least X whole tokens?
552             // i.e is the referrer a godly chad masternode
553             tokenBalanceLedger_[_referredBy] >= stakingRequirement
554         ) {
555             // wealth redistribution
556             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
557         } else {
558             // no ref purchase
559             // add the referral bonus back to the global dividends cake
560             _dividends = SafeMath.add(_dividends, _referralBonus);
561             _fee = _dividends * magnitude;
562         }
563 
564         // we can't give people infinite ethereum
565         if (tokenSupply_ > 0) {
566 
567             // add tokens to the pool
568             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
569 
570             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
571             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
572 
573             // calculate the amount of tokens the customer receives over his purchase
574             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
575 
576         } else {
577             // add tokens to the pool
578             tokenSupply_ = _amountOfTokens;
579         }
580 
581         // update circulating supply & the ledger address for the customer
582         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
583 
584         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
585         //really i know you think you do but you don't
586         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
587         payoutsTo_[_customerAddress] += _updatedPayouts;
588 
589         // fire event
590         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
591 
592         return _amountOfTokens;
593     }
594 
595     /**
596      * Calculate Token price based on an amount of incoming ethereum
597      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
598      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
599      */
600     function ethereumToTokens_(uint256 _ethereum)
601     internal
602     view
603     returns (uint256)
604     {
605         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
606         uint256 _tokensReceived =
607         (
608         (
609         // underflow attempts BTFO
610         SafeMath.sub(
611             (sqrt
612         (
613             (_tokenPriceInitial ** 2)
614             +
615             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
616             +
617             (((tokenPriceIncremental_) ** 2) * (tokenSupply_ ** 2))
618             +
619             (2 * (tokenPriceIncremental_) * _tokenPriceInitial * tokenSupply_)
620         )
621             ), _tokenPriceInitial
622         )
623         ) / (tokenPriceIncremental_)
624         ) - (tokenSupply_)
625         ;
626 
627         return _tokensReceived;
628     }
629 
630     /**
631      * Calculate token sell value.
632      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
633      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
634      */
635     function tokensToEthereum_(uint256 _tokens)
636     internal
637     view
638     returns (uint256)
639     {
640 
641         uint256 tokens_ = (_tokens + 1e18);
642         uint256 _tokenSupply = (tokenSupply_ + 1e18);
643         uint256 _etherReceived =
644         (
645         // underflow attempts BTFO
646         SafeMath.sub(
647             (
648             (
649             (
650             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
651             ) - tokenPriceIncremental_
652             ) * (tokens_ - 1e18)
653             ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
654         )
655         / 1e18);
656         return _etherReceived;
657     }
658 
659 
660     //This is where all your gas goes, sorry
661     //Not sorry, you probably only paid 1 gwei
662     function sqrt(uint x) internal pure returns (uint y) {
663         uint z = (x + 1) / 2;
664         y = x;
665         while (z < y) {
666             y = z;
667             z = (x / z + z) / 2;
668         }
669     }
670 }
671 
672 /**
673  * @title SafeMath
674  * @dev Math operations with safety checks that throw on error
675  */
676 library SafeMath {
677 
678     /**
679     * @dev Multiplies two numbers, throws on overflow.
680     */
681     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
682         if (a == 0) {
683             return 0;
684         }
685         uint256 c = a * b;
686         assert(c / a == b);
687         return c;
688     }
689 
690     /**
691     * @dev Integer division of two numbers, truncating the quotient.
692     */
693     function div(uint256 a, uint256 b) internal pure returns (uint256) {
694         // assert(b > 0); // Solidity automatically throws when dividing by 0
695         uint256 c = a / b;
696         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
697         return c;
698     }
699 
700     /**
701     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
702     */
703     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
704         assert(b <= a);
705         return a - b;
706     }
707 
708     /**
709     * @dev Adds two numbers, throws on overflow.
710     */
711     function add(uint256 a, uint256 b) internal pure returns (uint256) {
712         uint256 c = a + b;
713         assert(c >= a);
714         return c;
715     }
716 }