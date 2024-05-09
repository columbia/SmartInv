1 pragma solidity ^0.4.20;
2  
3 /*
4 * 
5 * ====================================*
6 * ▄▄▄·▄▄▄              ·▄▄▄          ·▄▄▄     ▄▄▄· ▪  ·▄▄▄▄  .▄▄ · 
7 *▐█ ▄█▀▄ █·▪     ▪     ▐▄▄·    ▪     ▐▄▄·    ▐█ ▀█ ██ ██▪ ██ ▐█ ▀. 
8 * ██▀·▐▀▀▄  ▄█▀▄  ▄█▀▄ ██▪      ▄█▀▄ ██▪     ▄█▀▀█ ▐█·▐█· ▐█▌▄▀▀▀█▄
9 *▐█▪·•▐█•█▌▐█▌.▐▌▐█▌.▐▌██▌.    ▐█▌.▐▌██▌.    ▐█ ▪▐▌▐█▌██. ██ ▐█▄▪▐█
10 *.▀   .▀  ▀ ▀█▄▀▪ ▀█▄▀▪▀▀▀      ▀█▄▀▪▀▀▀      ▀  ▀ ▀▀▀▀▀▀▀▀•  ▀▀▀▀ 
11 * 
12 * ====================================*
13 * WWW.PROOFOFAIDS.COM
14 * 
15 */
16  
17 contract ProofOfAIDS {
18     /*=================================
19     =            MODIFIERS            =
20     =================================*/
21     // only people with tokens
22     modifier onlyBagholders() {
23         require(myTokens() > 0);
24         _;
25     }
26  
27     // only people with profits
28     modifier onlyStronghands() {
29         require(myDividends(true) > 0);
30         _;
31     }
32  
33     // administrators can:
34     // -> change the name of the contract
35     // -> change the name of the token
36     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
37     // they CANNOT:
38     // -> take funds
39     // -> disable withdrawals
40     // -> kill the contract
41     // -> change the price of tokens
42     modifier onlyAdministrator(){
43         address _customerAddress = msg.sender;
44         require(administrators[_customerAddress]);
45         _;
46     }
47  
48  
49     // ensures that the first tokens in the contract will be equally distributed
50     // meaning, no divine dump will be ever possible
51     // result: healthy longevity.
52     modifier antiEarlyWhale(uint256 _amountOfEthereum){
53         address _customerAddress = msg.sender;
54  
55         // are we still in the vulnerable phase?
56         // if so, enact anti early whale protocol
57         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
58             require(
59                 // is the customer in the ambassador list?
60                 ambassadors_[_customerAddress] == true &&
61  
62                 // does the customer purchase exceed the max ambassador quota?
63                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
64  
65             );
66  
67             // updated the accumulated quota
68             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
69  
70             // execute
71             _;
72         } else {
73             // in case the ether count drops low, the ambassador phase won't reinitiate
74             onlyAmbassadors = false;
75             _;
76         }
77  
78     }
79  
80  
81     /*==============================
82     =            EVENTS            =
83     ==============================*/
84     event onTokenPurchase(
85         address indexed customerAddress,
86         uint256 incomingEthereum,
87         uint256 tokensMinted,
88         address indexed referredBy
89     );
90  
91     event onTokenSell(
92         address indexed customerAddress,
93         uint256 tokensBurned,
94         uint256 ethereumEarned
95     );
96  
97     event onReinvestment(
98         address indexed customerAddress,
99         uint256 ethereumReinvested,
100         uint256 tokensMinted
101     );
102  
103     event onWithdraw(
104         address indexed customerAddress,
105         uint256 ethereumWithdrawn
106     );
107  
108     // ERC20
109     event Transfer(
110         address indexed from,
111         address indexed to,
112         uint256 tokens
113     );
114  
115  
116     /*=====================================
117     =            CONFIGURABLES            =
118     =====================================*/
119     string public name = "ProofOfAIDS";
120     string public symbol = "POA";
121     uint8 constant public decimals = 18;
122     uint8 constant internal dividendFee_ = 50; // Look, strong Math 12.5% SUPER SAFE
123     uint256 constant internal tokenPriceInitial_ = 0.000000001 ether;
124     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
125     uint256 constant internal magnitude = 2**64;
126  
127     // proof of stake (defaults at 100 tokens)
128     uint256 public stakingRequirement = 100e18;
129  
130     // ambassador program
131     mapping(address => bool) internal ambassadors_;
132     uint256 constant internal ambassadorMaxPurchase_ = 0.5 ether;
133     uint256 constant internal ambassadorQuota_ = 3 ether;
134  
135  
136  
137    /*================================
138     =            DATASETS            =
139     ================================*/
140     // amount of shares for each address (scaled number)
141     mapping(address => uint256) internal tokenBalanceLedger_;
142     mapping(address => uint256) internal referralBalance_;
143     mapping(address => int256) internal payoutsTo_;
144     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
145     uint256 internal tokenSupply_ = 0;
146     uint256 internal profitPerShare_;
147  
148     // administrator list (see above on what they can do)
149     mapping(address => bool) public administrators;
150  
151     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
152     bool public onlyAmbassadors = true;
153  
154  
155  
156     /*=======================================
157     =            PUBLIC FUNCTIONS            =
158     =======================================*/
159     /*
160     * -- APPLICATION ENTRY POINTS --
161     */
162     function ProofOfAIDS()
163         public
164     {
165         // add administrators here
166         administrators[0x5d4E9E60C6B3Dd2779CA1F374694e031e2Ca2557] = true;
167     }
168  
169     /**
170      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
171      */
172     function buy(address _referredBy)
173         public
174         payable
175         returns(uint256)
176     {
177         purchaseTokens(msg.value, _referredBy);
178     }
179  
180     /**
181      * Fallback function to handle ethereum that was send straight to the contract
182      * Unfortunately we cannot use a referral address this way.
183      */
184     function()
185         payable
186         public
187     {
188         purchaseTokens(msg.value, 0x0);
189     }
190  
191     /**
192      * Converts all of caller's dividends to tokens.
193     */
194     function reinvest()
195         onlyStronghands()
196         public
197     {
198         // fetch dividends
199         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
200  
201         // pay out the dividends virtually
202         address _customerAddress = msg.sender;
203         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
204  
205         // retrieve ref. bonus
206         _dividends += referralBalance_[_customerAddress];
207         referralBalance_[_customerAddress] = 0;
208  
209         // dispatch a buy order with the virtualized "withdrawn dividends"
210         uint256 _tokens = purchaseTokens(_dividends, 0x0);
211  
212         // fire event
213         onReinvestment(_customerAddress, _dividends, _tokens);
214     }
215  
216     /**
217      * Alias of sell() and withdraw().
218      */
219     function exit()
220         public
221     {
222         // get token count for caller & sell them all
223         address _customerAddress = msg.sender;
224         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
225         if(_tokens > 0) sell(_tokens);
226  
227         // lambo delivery service
228         withdraw();
229     }
230  
231     /**
232      * Withdraws all of the callers earnings.
233      */
234     function withdraw()
235         onlyStronghands()
236         public
237     {
238         // setup data
239         address _customerAddress = msg.sender;
240         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
241  
242         // update dividend tracker
243         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
244  
245         // add ref. bonus
246         _dividends += referralBalance_[_customerAddress];
247         referralBalance_[_customerAddress] = 0;
248  
249         // lambo delivery service
250         _customerAddress.transfer(_dividends);
251  
252         // fire event
253         onWithdraw(_customerAddress, _dividends);
254     }
255  
256     /**
257      * Liquifies tokens to ethereum.
258      */
259     function sell(uint256 _amountOfTokens)
260         onlyBagholders()
261         public
262     {
263         // setup data
264         address _customerAddress = msg.sender;
265         // russian hackers BTFO
266         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
267         uint256 _tokens = _amountOfTokens;
268         uint256 _ethereum = tokensToEthereum_(_tokens);
269         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
270         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
271  
272         // burn the sold tokens
273         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
274         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
275  
276         // update dividends tracker
277         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
278         payoutsTo_[_customerAddress] -= _updatedPayouts;
279  
280         // dividing by zero is a bad idea
281         if (tokenSupply_ > 0) {
282             // update the amount of dividends per token
283             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
284         }
285  
286         // fire event
287         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
288     }
289  
290  
291     /**
292      * Transfer tokens from the caller to a new holder.
293      * Remember, there's a 10% fee here as well.
294      */
295     function transfer(address _toAddress, uint256 _amountOfTokens)
296         onlyBagholders()
297         public
298         returns(bool)
299     {
300         // setup
301         address _customerAddress = msg.sender;
302  
303         // make sure we have the requested tokens
304         // also disables transfers until ambassador phase is over
305         // ( we dont want whale premines )
306         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
307  
308         // withdraw all outstanding dividends first
309         if(myDividends(true) > 0) withdraw();
310  
311         // exchange tokens
312         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
313         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
314  
315         // update dividend trackers
316         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
317         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
318  
319         // fire event
320         Transfer(_customerAddress, _toAddress, _amountOfTokens);
321  
322         // ERC20
323         return true;
324  
325     }
326  
327     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
328     /**
329      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
330      */
331     function disableInitialStage()
332         onlyAdministrator()
333         public
334     {
335         onlyAmbassadors = false;
336     }
337  
338     /**
339      * In case one of us dies, we need to replace ourselves.
340      */
341     function setAdministrator(address _identifier, bool _status)
342         onlyAdministrator()
343         public
344     {
345         administrators[_identifier] = _status;
346     }
347  
348     /**
349      * Precautionary measures in case we need to adjust the masternode rate.
350      */
351     function setStakingRequirement(uint256 _amountOfTokens)
352         onlyAdministrator()
353         public
354     {
355         stakingRequirement = _amountOfTokens;
356     }
357  
358     /**
359      * If we want to rebrand, we can.
360      */
361     function setName(string _name)
362         onlyAdministrator()
363         public
364     {
365         name = _name;
366     }
367  
368     /**
369      * If we want to rebrand, we can.
370      */
371     function setSymbol(string _symbol)
372         onlyAdministrator()
373         public
374     {
375         symbol = _symbol;
376     }
377  
378  
379     /*----------  HELPERS AND CALCULATORS  ----------*/
380     /**
381      * Method to view the current Ethereum stored in the contract
382      * Example: totalEthereumBalance()
383      */
384     function totalEthereumBalance()
385         public
386         view
387         returns(uint)
388     {
389         return this.balance;
390     }
391  
392     /**
393      * Retrieve the total token supply.
394      */
395     function totalSupply()
396         public
397         view
398         returns(uint256)
399     {
400         return tokenSupply_;
401     }
402  
403     /**
404      * Retrieve the tokens owned by the caller.
405      */
406     function myTokens()
407         public
408         view
409         returns(uint256)
410     {
411         address _customerAddress = msg.sender;
412         return balanceOf(_customerAddress);
413     }
414  
415     /**
416      * Retrieve the dividends owned by the caller.
417      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
418      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
419      * But in the internal calculations, we want them separate.
420      */
421     function myDividends(bool _includeReferralBonus)
422         public
423         view
424         returns(uint256)
425     {
426         address _customerAddress = msg.sender;
427         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
428     }
429  
430     /**
431      * Retrieve the token balance of any single address.
432      */
433     function balanceOf(address _customerAddress)
434         view
435         public
436         returns(uint256)
437     {
438         return tokenBalanceLedger_[_customerAddress];
439     }
440  
441     /**
442      * Retrieve the dividend balance of any single address.
443      */
444     function dividendsOf(address _customerAddress)
445         view
446         public
447         returns(uint256)
448     {
449         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
450     }
451  
452     /**
453      * Return the buy price of 1 individual token.
454      */
455     function sellPrice()
456         public
457         view
458         returns(uint256)
459     {
460         // our calculation relies on the token supply, so we need supply. Doh.
461         if(tokenSupply_ == 0){
462             return tokenPriceInitial_ - tokenPriceIncremental_;
463         } else {
464             uint256 _ethereum = tokensToEthereum_(1e18);
465             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
466             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
467             return _taxedEthereum;
468         }
469     }
470  
471     /**
472      * Return the sell price of 1 individual token.
473      */
474     function buyPrice()
475         public
476         view
477         returns(uint256)
478     {
479         // our calculation relies on the token supply, so we need supply. Doh.
480         if(tokenSupply_ == 0){
481             return tokenPriceInitial_ + tokenPriceIncremental_;
482         } else {
483             uint256 _ethereum = tokensToEthereum_(1e18);
484             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
485             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
486             return _taxedEthereum;
487         }
488     }
489  
490     /**
491      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
492      */
493     function calculateTokensReceived(uint256 _ethereumToSpend)
494         public
495         view
496         returns(uint256)
497     {
498         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
499         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
500         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
501  
502         return _amountOfTokens;
503     }
504  
505     /**
506      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
507      */
508     function calculateEthereumReceived(uint256 _tokensToSell)
509         public
510         view
511         returns(uint256)
512     {
513         require(_tokensToSell <= tokenSupply_);
514         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
515         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
516         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
517         return _taxedEthereum;
518     }
519  
520  
521     /*==========================================
522     =            INTERNAL FUNCTIONS            =
523     ==========================================*/
524     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
525         antiEarlyWhale(_incomingEthereum)
526         internal
527         returns(uint256)
528     {
529         // data setup
530         address _customerAddress = msg.sender;
531         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
532         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
533         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
534         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
535         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
536         uint256 _fee = _dividends * magnitude;
537  
538         // no point in continuing execution if OP is a poorfag russian hacker
539         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
540         // (or hackers)
541         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
542         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
543  
544         // is the user referred by a masternode?
545         if(
546             // is this a referred purchase?
547             _referredBy != 0x0000000000000000000000000000000000000000 &&
548  
549             // no cheating!
550             _referredBy != _customerAddress &&
551  
552             // does the referrer have at least X whole tokens?
553             // i.e is the referrer a godly chad masternode
554             tokenBalanceLedger_[_referredBy] >= stakingRequirement
555         ){
556             // wealth redistribution
557             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
558         } else {
559             // no ref purchase
560             // add the referral bonus back to the global dividends cake
561             _dividends = SafeMath.add(_dividends, _referralBonus);
562             _fee = _dividends * magnitude;
563         }
564  
565         // we can't give people infinite ethereum
566         if(tokenSupply_ > 0){
567  
568             // add tokens to the pool
569             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
570  
571             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
572             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
573  
574             // calculate the amount of tokens the customer receives over his purchase
575             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
576  
577         } else {
578             // add tokens to the pool
579             tokenSupply_ = _amountOfTokens;
580         }
581  
582         // update circulating supply & the ledger address for the customer
583         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
584  
585         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
586         //really i know you think you do but you don't
587         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
588         payoutsTo_[_customerAddress] += _updatedPayouts;
589  
590         // fire event
591         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
592  
593         return _amountOfTokens;
594     }
595  
596     /**
597      * Calculate Token price based on an amount of incoming ethereum
598      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
599      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
600      */
601     function ethereumToTokens_(uint256 _ethereum)
602         internal
603         view
604         returns(uint256)
605     {
606         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
607         uint256 _tokensReceived =
608          (
609             (
610                 // underflow attempts BTFO
611                 SafeMath.sub(
612                     (sqrt
613                         (
614                             (_tokenPriceInitial**2)
615                             +
616                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
617                             +
618                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
619                             +
620                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
621                         )
622                     ), _tokenPriceInitial
623                 )
624             )/(tokenPriceIncremental_)
625         )-(tokenSupply_)
626         ;
627  
628         return _tokensReceived;
629     }
630  
631     /**
632      * Calculate token sell value.
633      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
634      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
635      */
636      function tokensToEthereum_(uint256 _tokens)
637         internal
638         view
639         returns(uint256)
640     {
641  
642         uint256 tokens_ = (_tokens + 1e18);
643         uint256 _tokenSupply = (tokenSupply_ + 1e18);
644         uint256 _etherReceived =
645         (
646             // underflow attempts BTFO
647             SafeMath.sub(
648                 (
649                     (
650                         (
651                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
652                         )-tokenPriceIncremental_
653                     )*(tokens_ - 1e18)
654                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
655             )
656         /1e18);
657         return _etherReceived;
658     }
659  
660  
661     //This is where all your gas goes, sorry
662     //Not sorry, you probably only paid 1 gwei
663     function sqrt(uint x) internal pure returns (uint y) {
664         uint z = (x + 1) / 2;
665         y = x;
666         while (z < y) {
667             y = z;
668             z = (x / z + z) / 2;
669         }
670     }
671 }
672  
673 /**
674  * @title SafeMath
675  * @dev Math operations with safety checks that throw on error
676  */
677 library SafeMath {
678  
679     /**
680     * @dev Multiplies two numbers, throws on overflow.
681     */
682     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
683         if (a == 0) {
684             return 0;
685         }
686         uint256 c = a * b;
687         assert(c / a == b);
688         return c;
689     }
690  
691     /**
692     * @dev Integer division of two numbers, truncating the quotient.
693     */
694     function div(uint256 a, uint256 b) internal pure returns (uint256) {
695         // assert(b > 0); // Solidity automatically throws when dividing by 0
696         uint256 c = a / b;
697         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
698         return c;
699     }
700  
701     /**
702     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
703     */
704     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
705         assert(b <= a);
706         return a - b;
707     }
708  
709     /**
710     * @dev Adds two numbers, throws on overflow.
711     */
712     function add(uint256 a, uint256 b) internal pure returns (uint256) {
713         uint256 c = a + b;
714         assert(c >= a);
715         return c;
716     }
717 }