1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents..
5 * Proof Of Sunny Decree
6 * -> What?
7 * The original autonomous pyramid, improved:
8 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
9 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
10 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
11 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
12 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
13 * [x] Masternodes: Holding 100 PoWH3D Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
14 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
15 *
16 * -> What about the last projects?
17 * Every programming member of the old dev team has been fired and/or killed by 232.
18 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
19 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
20 * 
21 * -> Who worked on this project?
22 * - PonziBot (math/memes/main site/master)
23 * - Mantso (lead solidity dev/lead web3 dev)
24 * - swagg (concept design/feedback/management)
25 * - Anonymous#1 (main site/web3/test cases)
26 * - Anonymous#2 (math formulae/whitepaper)
27 *
28 * -> Who has audited & approved the projected:
29 * - Arc
30 * - tocisck
31 * - sumpunk
32 */
33 
34 contract Hourglass {
35     /*=================================
36     =            MODIFIERS            =
37     =================================*/
38     // only people with tokens
39     modifier onlyBagholders() {
40         require(myTokens() > 0);
41         _;
42     }
43     
44     // only people with profits
45     modifier onlyStronghands() {
46         require(myDividends(true) > 0);
47         _;
48     }
49     
50     // administrators can:
51     // -> change the name of the contract
52     // -> change the name of the token
53     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
54     // they CANNOT:
55     // -> take funds
56     // -> disable withdrawals
57     // -> kill the contract
58     // -> change the price of tokens
59     modifier onlyAdministrator(){
60         address _customerAddress = msg.sender;
61         require(administrators[keccak256(_customerAddress)]);
62         _;
63     }
64     
65     
66     // ensures that the first tokens in the contract will be equally distributed
67     // meaning, no divine dump will be ever possible
68     // result: healthy longevity.
69     modifier antiEarlyWhale(uint256 _amountOfEthereum){
70         address _customerAddress = msg.sender;
71         
72         // are we still in the vulnerable phase?
73         // if so, enact anti early whale protocol 
74         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
75             require(
76                 // is the customer in the ambassador list?
77                 ambassadors_[_customerAddress] == true &&
78                 
79                 // does the customer purchase exceed the max ambassador quota?
80                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
81                 
82             );
83             
84             // updated the accumulated quota    
85             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
86         
87             // execute
88             _;
89         } else {
90             // in case the ether count drops low, the ambassador phase won't reinitiate
91             onlyAmbassadors = false;
92             _;    
93         }
94         
95     }
96     
97     
98     /*==============================
99     =            EVENTS            =
100     ==============================*/
101     event onTokenPurchase(
102         address indexed customerAddress,
103         uint256 incomingEthereum,
104         uint256 tokensMinted,
105         address indexed referredBy
106     );
107     
108     event onTokenSell(
109         address indexed customerAddress,
110         uint256 tokensBurned,
111         uint256 ethereumEarned
112     );
113     
114     event onReinvestment(
115         address indexed customerAddress,
116         uint256 ethereumReinvested,
117         uint256 tokensMinted
118     );
119     
120     event onWithdraw(
121         address indexed customerAddress,
122         uint256 ethereumWithdrawn
123     );
124     
125     // ERC20
126     event Transfer(
127         address indexed from,
128         address indexed to,
129         uint256 tokens
130     );
131     
132     
133     /*=====================================
134     =            CONFIGURABLES            =
135     =====================================*/
136     string public name = "ProofOfSunnyDecree";
137     string public symbol = "POSD";
138     uint8 constant public decimals = 18;
139     uint8 constant internal dividendFee_ = 4;
140     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
141     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
142     uint256 constant internal magnitude = 2**64;
143     
144     // proof of stake (defaults at 50 tokens)
145     uint256 public stakingRequirement = 50e18;
146     
147     // ambassador program
148     mapping(address => bool) internal ambassadors_;
149     uint256 constant internal ambassadorMaxPurchase_ = .51 ether;
150     uint256 constant internal ambassadorQuota_ = .5 ether;
151     
152     
153     
154    /*================================
155     =            DATASETS            =
156     ================================*/
157     // amount of shares for each address (scaled number)
158     mapping(address => uint256) internal tokenBalanceLedger_;
159     mapping(address => uint256) internal referralBalance_;
160     mapping(address => int256) internal payoutsTo_;
161     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
162     uint256 internal tokenSupply_ = 0;
163     uint256 internal profitPerShare_;
164     
165     // administrator list (see above on what they can do)
166     mapping(bytes32 => bool) public administrators;
167     
168     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
169     bool public onlyAmbassadors = true;
170     
171 
172 
173     /*=======================================
174     =            PUBLIC FUNCTIONS            =
175     =======================================*/
176     /*
177     * -- APPLICATION ENTRY POINTS --  
178     */
179     function Hourglass()
180         public
181     {
182         
183         ambassadors_[0x8EDc34E08C9659Ebf60E62B96dcedF26e57998D6] = true;
184     }
185     
186      
187     /**
188      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
189      */
190     function buy(address _referredBy)
191         public
192         payable
193         returns(uint256)
194     {
195         purchaseTokens(msg.value, _referredBy);
196     }
197     
198     /**
199      * Fallback function to handle ethereum that was send straight to the contract
200      * Unfortunately we cannot use a referral address this way.
201      */
202     function()
203         payable
204         public
205     {
206         purchaseTokens(msg.value, 0x0);
207     }
208     
209     /**
210      * Converts all of caller's dividends to tokens.
211      */
212     function reinvest()
213         onlyStronghands()
214         public
215     {
216         // fetch dividends
217         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
218         
219         // pay out the dividends virtually
220         address _customerAddress = msg.sender;
221         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
222         
223         // retrieve ref. bonus
224         _dividends += referralBalance_[_customerAddress];
225         referralBalance_[_customerAddress] = 0;
226         
227         // dispatch a buy order with the virtualized "withdrawn dividends"
228         uint256 _tokens = purchaseTokens(_dividends, 0x0);
229         
230         // fire event
231         onReinvestment(_customerAddress, _dividends, _tokens);
232     }
233     
234     /**
235      * Alias of sell() and withdraw().
236      */
237     function exit()
238         public
239     {
240         // get token count for caller & sell them all
241         address _customerAddress = msg.sender;
242         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
243         if(_tokens > 0) sell(_tokens);
244         
245         // lambo delivery service
246         withdraw();
247     }
248 
249     /**
250      * Withdraws all of the callers earnings.
251      */
252     function withdraw()
253         onlyStronghands()
254         public
255     {
256         // setup data
257         address _customerAddress = msg.sender;
258         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
259         
260         // update dividend tracker
261         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
262         
263         // add ref. bonus
264         _dividends += referralBalance_[_customerAddress];
265         referralBalance_[_customerAddress] = 0;
266         
267         // lambo delivery service
268         _customerAddress.transfer(_dividends);
269         
270         // fire event
271         onWithdraw(_customerAddress, _dividends);
272     }
273     
274     /**
275      * Liquifies tokens to ethereum.
276      */
277     function sell(uint256 _amountOfTokens)
278         onlyBagholders()
279         public
280     {
281         // setup data
282         address _customerAddress = msg.sender;
283         // russian hackers BTFO
284         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
285         uint256 _tokens = _amountOfTokens;
286         uint256 _ethereum = tokensToEthereum_(_tokens);
287         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
288         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
289         
290         // burn the sold tokens
291         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
292         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
293         
294         // update dividends tracker
295         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
296         payoutsTo_[_customerAddress] -= _updatedPayouts;       
297         
298         // dividing by zero is a bad idea
299         if (tokenSupply_ > 0) {
300             // update the amount of dividends per token
301             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
302         }
303         
304         // fire event
305         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
306     }
307     
308     
309     /**
310      * Transfer tokens from the caller to a new holder.
311      * Remember, there's a 10% fee here as well.
312      */
313     function transfer(address _toAddress, uint256 _amountOfTokens)
314         onlyBagholders()
315         public
316         returns(bool)
317     {
318         // setup
319         address _customerAddress = msg.sender;
320         
321         // make sure we have the requested tokens
322         // also disables transfers until ambassador phase is over
323         // ( we dont want whale premines )
324         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
325         
326         // withdraw all outstanding dividends first
327         if(myDividends(true) > 0) withdraw();
328         
329         // liquify 10% of the tokens that are transfered
330         // these are dispersed to shareholders
331         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
332         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
333         uint256 _dividends = tokensToEthereum_(_tokenFee);
334   
335         // burn the fee tokens
336         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
337 
338         // exchange tokens
339         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
340         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
341         
342         // update dividend trackers
343         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
344         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
345         
346         // disperse dividends among holders
347         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
348         
349         // fire event
350         Transfer(_customerAddress, _toAddress, _taxedTokens);
351         
352         // ERC20
353         return true;
354        
355     }
356     
357     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
358     /**
359      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
360      */
361     function disableInitialStage()
362         onlyAdministrator()
363         public
364     {
365         onlyAmbassadors = false;
366     }
367     
368     /**
369      * In case one of us dies, we need to replace ourselves.
370      */
371     function setAdministrator(bytes32 _identifier, bool _status)
372         onlyAdministrator()
373         public
374     {
375         administrators[_identifier] = _status;
376     }
377     
378     /**
379      * Precautionary measures in case we need to adjust the masternode rate.
380      */
381     function setStakingRequirement(uint256 _amountOfTokens)
382         onlyAdministrator()
383         public
384     {
385         stakingRequirement = _amountOfTokens;
386     }
387     
388     /**
389      * If we want to rebrand, we can.
390      */
391     function setName(string _name)
392         onlyAdministrator()
393         public
394     {
395         name = _name;
396     }
397     
398     /**
399      * If we want to rebrand, we can.
400      */
401     function setSymbol(string _symbol)
402         onlyAdministrator()
403         public
404     {
405         symbol = _symbol;
406     }
407 
408     
409     /*----------  HELPERS AND CALCULATORS  ----------*/
410     /**
411      * Method to view the current Ethereum stored in the contract
412      * Example: totalEthereumBalance()
413      */
414     function totalEthereumBalance()
415         public
416         view
417         returns(uint)
418     {
419         return this.balance;
420     }
421     
422     /**
423      * Retrieve the total token supply.
424      */
425     function totalSupply()
426         public
427         view
428         returns(uint256)
429     {
430         return tokenSupply_;
431     }
432     
433     /**
434      * Retrieve the tokens owned by the caller.
435      */
436     function myTokens()
437         public
438         view
439         returns(uint256)
440     {
441         address _customerAddress = msg.sender;
442         return balanceOf(_customerAddress);
443     }
444     
445     /**
446      * Retrieve the dividends owned by the caller.
447      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
448      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
449      * But in the internal calculations, we want them separate. 
450      */ 
451     function myDividends(bool _includeReferralBonus) 
452         public 
453         view 
454         returns(uint256)
455     {
456         address _customerAddress = msg.sender;
457         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
458     }
459     
460     /**
461      * Retrieve the token balance of any single address.
462      */
463     function balanceOf(address _customerAddress)
464         view
465         public
466         returns(uint256)
467     {
468         return tokenBalanceLedger_[_customerAddress];
469     }
470     
471     /**
472      * Retrieve the dividend balance of any single address.
473      */
474     function dividendsOf(address _customerAddress)
475         view
476         public
477         returns(uint256)
478     {
479         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
480     }
481     
482     /**
483      * Return the buy price of 1 individual token.
484      */
485     function sellPrice() 
486         public 
487         view 
488         returns(uint256)
489     {
490         // our calculation relies on the token supply, so we need supply. Doh.
491         if(tokenSupply_ == 0){
492             return tokenPriceInitial_ - tokenPriceIncremental_;
493         } else {
494             uint256 _ethereum = tokensToEthereum_(1e18);
495             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
496             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
497             return _taxedEthereum;
498         }
499     }
500     
501     /**
502      * Return the sell price of 1 individual token.
503      */
504     function buyPrice() 
505         public 
506         view 
507         returns(uint256)
508     {
509         // our calculation relies on the token supply, so we need supply. Doh.
510         if(tokenSupply_ == 0){
511             return tokenPriceInitial_ + tokenPriceIncremental_;
512         } else {
513             uint256 _ethereum = tokensToEthereum_(1e18);
514             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
515             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
516             return _taxedEthereum;
517         }
518     }
519     
520     /**
521      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
522      */
523     function calculateTokensReceived(uint256 _ethereumToSpend) 
524         public 
525         view 
526         returns(uint256)
527     {
528         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
529         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
530         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
531         
532         return _amountOfTokens;
533     }
534     
535     /**
536      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
537      */
538     function calculateEthereumReceived(uint256 _tokensToSell) 
539         public 
540         view 
541         returns(uint256)
542     {
543         require(_tokensToSell <= tokenSupply_);
544         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
545         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
546         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
547         return _taxedEthereum;
548     }
549     
550     
551     /*==========================================
552     =            INTERNAL FUNCTIONS            =
553     ==========================================*/
554     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
555         antiEarlyWhale(_incomingEthereum)
556         internal
557         returns(uint256)
558     {
559         // data setup
560         address _customerAddress = msg.sender;
561         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
562         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
563         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
564         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
565         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
566         uint256 _fee = _dividends * magnitude;
567  
568         // no point in continuing execution if OP is a poorfag russian hacker
569         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
570         // (or hackers)
571         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
572         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
573         
574         // is the user referred by a masternode?
575         if(
576             // is this a referred purchase?
577             _referredBy != 0x0000000000000000000000000000000000000000 &&
578 
579             // no cheating!
580             _referredBy != _customerAddress &&
581             
582             // does the referrer have at least X whole tokens?
583             // i.e is the referrer a godly chad masternode
584             tokenBalanceLedger_[_referredBy] >= stakingRequirement
585         ){
586             // wealth redistribution
587             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
588         } else {
589             // no ref purchase
590             // add the referral bonus back to the global dividends cake
591             _dividends = SafeMath.add(_dividends, _referralBonus);
592             _fee = _dividends * magnitude;
593         }
594         
595         // we can't give people infinite ethereum
596         if(tokenSupply_ > 0){
597             
598             // add tokens to the pool
599             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
600  
601             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
602             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
603             
604             // calculate the amount of tokens the customer receives over his purchase 
605             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
606         
607         } else {
608             // add tokens to the pool
609             tokenSupply_ = _amountOfTokens;
610         }
611         
612         // update circulating supply & the ledger address for the customer
613         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
614         
615         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
616         //really i know you think you do but you don't
617         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
618         payoutsTo_[_customerAddress] += _updatedPayouts;
619         
620         // fire event
621         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
622         
623         return _amountOfTokens;
624     }
625 
626     /**
627      * Calculate Token price based on an amount of incoming ethereum
628      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
629      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
630      */
631     function ethereumToTokens_(uint256 _ethereum)
632         internal
633         view
634         returns(uint256)
635     {
636         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
637         uint256 _tokensReceived = 
638          (
639             (
640                 // underflow attempts BTFO
641                 SafeMath.sub(
642                     (sqrt
643                         (
644                             (_tokenPriceInitial**2)
645                             +
646                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
647                             +
648                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
649                             +
650                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
651                         )
652                     ), _tokenPriceInitial
653                 )
654             )/(tokenPriceIncremental_)
655         )-(tokenSupply_)
656         ;
657   
658         return _tokensReceived;
659     }
660     
661     /**
662      * Calculate token sell value.
663      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
664      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
665      */
666      function tokensToEthereum_(uint256 _tokens)
667         internal
668         view
669         returns(uint256)
670     {
671 
672         uint256 tokens_ = (_tokens + 1e18);
673         uint256 _tokenSupply = (tokenSupply_ + 1e18);
674         uint256 _etherReceived =
675         (
676             // underflow attempts BTFO
677             SafeMath.sub(
678                 (
679                     (
680                         (
681                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
682                         )-tokenPriceIncremental_
683                     )*(tokens_ - 1e18)
684                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
685             )
686         /1e18);
687         return _etherReceived;
688     }
689     
690     
691     //This is where all your gas goes, sorry
692     //Not sorry, you probably only paid 1 gwei
693     function sqrt(uint x) internal pure returns (uint y) {
694         uint z = (x + 1) / 2;
695         y = x;
696         while (z < y) {
697             y = z;
698             z = (x / z + z) / 2;
699         }
700     }
701 }
702 
703 /**
704  * @title SafeMath
705  * @dev Math operations with safety checks that throw on error
706  */
707 library SafeMath {
708 
709     /**
710     * @dev Multiplies two numbers, throws on overflow.
711     */
712     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
713         if (a == 0) {
714             return 0;
715         }
716         uint256 c = a * b;
717         assert(c / a == b);
718         return c;
719     }
720 
721     /**
722     * @dev Integer division of two numbers, truncating the quotient.
723     */
724     function div(uint256 a, uint256 b) internal pure returns (uint256) {
725         // assert(b > 0); // Solidity automatically throws when dividing by 0
726         uint256 c = a / b;
727         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
728         return c;
729     }
730 
731     /**
732     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
733     */
734     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
735         assert(b <= a);
736         return a - b;
737     }
738 
739     /**
740     * @dev Adds two numbers, throws on overflow.
741     */
742     function add(uint256 a, uint256 b) internal pure returns (uint256) {
743         uint256 c = a + b;
744         assert(c >= a);
745         return c;
746     }
747 }