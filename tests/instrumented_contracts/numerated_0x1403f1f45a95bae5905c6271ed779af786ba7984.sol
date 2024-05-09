1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team CopyCat presents..
5 * ==============================*
6 * _____     _ _ _ _____    __   * 
7 *|  _  |___| | | |  |  |  | |   *
8 *|   __| . | | | |  |  |  | |   *
9 *|__|  |___|_____|  |  |  |_|   * 
10 *                               *
11 * ==============================*
12 * -> Are you tired of unnecessry divs? Do you just want to pump and dump in its simplicity?
13 * Inspired by the fifth autonomous pyramid, this contract merely has been changed to have 1% divs.
14 * Also known as "Proof of Cuck Hands"
15 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
16 * [x] Audited, tested, and approved by known community security specialists such as tocsick and Arc.
17 * [X] New functionality; you can now perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags!
18 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
19 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
20 * [x] Masternodes: Holding 100 PoWH3D Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
21 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
22 *
23 * -> What about the last projects?
24 * Every programming member of the old dev team has been fired and/or killed by 232.
25 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
26 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
27 * 
28 * -> Who worked on this project?
29 * - Vitalik (math/memes/main site/master)
30 * - Satoshi (lead solidity dev/lead web3 dev)
31 * - Bill Gates (concept design/feedback/management)
32 * - Stephen Hawking (main site/web3/test cases)
33 * - Steve Jobs (math formulae/whitepaper)
34 *
35 * -> Who has audited & approved the projected:
36 * - Jesus
37 * - Kanye
38 * - Trump
39 */
40 
41 contract POMW1 {
42     /*=================================
43     =            MODIFIERS            =
44     =================================*/
45     // only people with tokens
46     modifier onlyBagholders() {
47         require(myTokens() > 0);
48         _;
49     }
50     
51     // only people with profits
52     modifier onlyStronghands() {
53         require(myDividends(true) > 0);
54         _;
55     }
56     
57     // administrators can:
58     // -> change the name of the contract
59     // -> change the name of the token
60     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
61     // they CANNOT:
62     // -> take funds
63     // -> disable withdrawals
64     // -> kill the contract
65     // -> change the price of tokens
66     modifier onlyAdministrator(){
67         address _customerAddress = msg.sender;
68         require(administrators[keccak256(_customerAddress)]);
69         _;
70     }
71     
72     
73     // ensures that the first tokens in the contract will be equally distributed
74     // meaning, no divine dump will be ever possible
75     // result: healthy longevity.
76     modifier antiEarlyWhale(uint256 _amountOfEthereum){
77         address _customerAddress = msg.sender;
78         
79         // are we still in the vulnerable phase?
80         // if so, enact anti early whale protocol 
81         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
82             require(
83                 // is the customer in the ambassador list?
84                 ambassadors_[_customerAddress] == true &&
85                 
86                 // does the customer purchase exceed the max ambassador quota?
87                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
88                 
89             );
90             
91             // updated the accumulated quota    
92             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
93         
94             // execute
95             _;
96         } else {
97             // in case the ether count drops low, the ambassador phase won't reinitiate
98             onlyAmbassadors = false;
99             _;    
100         }
101         
102     }
103     
104     
105     /*==============================
106     =            EVENTS            =
107     ==============================*/
108     event onTokenPurchase(
109         address indexed customerAddress,
110         uint256 incomingEthereum,
111         uint256 tokensMinted,
112         address indexed referredBy
113     );
114     
115     event onTokenSell(
116         address indexed customerAddress,
117         uint256 tokensBurned,
118         uint256 ethereumEarned
119     );
120     
121     event onReinvestment(
122         address indexed customerAddress,
123         uint256 ethereumReinvested,
124         uint256 tokensMinted
125     );
126     
127     event onWithdraw(
128         address indexed customerAddress,
129         uint256 ethereumWithdrawn
130     );
131     
132     // ERC20
133     event Transfer(
134         address indexed from,
135         address indexed to,
136         uint256 tokens
137     );
138     
139     
140     /*=====================================
141     =            CONFIGURABLES            =
142     =====================================*/
143     string public name = "POMW1";
144     string public symbol = "POMW1";
145     uint8 constant public decimals = 18;
146     uint8 constant internal dividendFee_ = 100;
147     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
148     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
149     uint256 constant internal magnitude = 2**64;
150     
151     // proof of stake (defaults at 100 tokens)
152     uint256 public stakingRequirement = 5e18;
153     
154     // ambassador program
155     mapping(address => bool) internal ambassadors_;
156     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
157     uint256 constant internal ambassadorQuota_ = 10 ether;
158     
159     
160     
161    /*================================
162     =            DATASETS            =
163     ================================*/
164     // amount of shares for each address (scaled number)
165     mapping(address => uint256) internal tokenBalanceLedger_;
166     mapping(address => uint256) internal referralBalance_;
167     mapping(address => int256) internal payoutsTo_;
168     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
169     uint256 internal tokenSupply_ = 0;
170     uint256 internal profitPerShare_;
171     
172     // administrator list (see above on what they can do)
173     mapping(bytes32 => bool) public administrators;
174     
175     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
176     bool public onlyAmbassadors = false;
177     
178 
179 
180     /*=======================================
181     =            PUBLIC FUNCTIONS            =
182     =======================================*/
183     /*
184     * -- APPLICATION ENTRY POINTS --  
185     */
186     function Hourglass()
187         public
188     {
189         // add administrators here
190         administrators[0x5e2e288e04567ecf74ca6e5cbe6e54052c3e563f055e9df29e777d57b479be91] = true;
191         
192         // add the ambassadors here.
193         // One lonely developer 
194         ambassadors_[0x5597172d80e12FbbDb1c3eA915Ed513e39A0ab36] = true;
195         
196         
197      
198 
199     }
200     
201      
202     /**
203      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
204      */
205     function buy(address _referredBy)
206         public
207         payable
208         returns(uint256)
209     {
210         purchaseTokens(msg.value, _referredBy);
211     }
212     
213     /**
214      * Fallback function to handle ethereum that was send straight to the contract
215      * Unfortunately we cannot use a referral address this way.
216      */
217     function()
218         payable
219         public
220     {
221         purchaseTokens(msg.value, 0x0);
222     }
223     
224     /**
225      * Converts all of caller's dividends to tokens.
226      */
227     function reinvest()
228         onlyStronghands()
229         public
230     {
231         // fetch dividends
232         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
233         
234         // pay out the dividends virtually
235         address _customerAddress = msg.sender;
236         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
237         
238         // retrieve ref. bonus
239         _dividends += referralBalance_[_customerAddress];
240         referralBalance_[_customerAddress] = 0;
241         
242         // dispatch a buy order with the virtualized "withdrawn dividends"
243         uint256 _tokens = purchaseTokens(_dividends, 0x0);
244         
245         // fire event
246         onReinvestment(_customerAddress, _dividends, _tokens);
247     }
248     
249     /**
250      * Alias of sell() and withdraw().
251      */
252     function exit()
253         public
254     {
255         // get token count for caller & sell them all
256         address _customerAddress = msg.sender;
257         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
258         if(_tokens > 0) sell(_tokens);
259         
260         // lambo delivery service
261         withdraw();
262     }
263 
264     /**
265      * Withdraws all of the callers earnings.
266      */
267     function withdraw()
268         onlyStronghands()
269         public
270     {
271         // setup data
272         address _customerAddress = msg.sender;
273         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
274         
275         // update dividend tracker
276         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
277         
278         // add ref. bonus
279         _dividends += referralBalance_[_customerAddress];
280         referralBalance_[_customerAddress] = 0;
281         
282         // lambo delivery service
283         _customerAddress.transfer(_dividends);
284         
285         // fire event
286         onWithdraw(_customerAddress, _dividends);
287     }
288     
289     /**
290      * Liquifies tokens to ethereum.
291      */
292     function sell(uint256 _amountOfTokens)
293         onlyBagholders()
294         public
295     {
296         // setup data
297         address _customerAddress = msg.sender;
298         // russian hackers BTFO
299         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
300         uint256 _tokens = _amountOfTokens;
301         uint256 _ethereum = tokensToEthereum_(_tokens);
302         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
303         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
304         
305         // burn the sold tokens
306         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
307         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
308         
309         // update dividends tracker
310         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
311         payoutsTo_[_customerAddress] -= _updatedPayouts;       
312         
313         // dividing by zero is a bad idea
314         if (tokenSupply_ > 0) {
315             // update the amount of dividends per token
316             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
317         }
318         
319         // fire event
320         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
321     }
322     
323     
324     /**
325      * Transfer tokens from the caller to a new holder.
326      * Remember, there's a 10% fee here as well.
327      */
328     function transfer(address _toAddress, uint256 _amountOfTokens)
329         onlyBagholders()
330         public
331         returns(bool)
332     {
333         // setup
334         address _customerAddress = msg.sender;
335         
336         // make sure we have the requested tokens
337         // also disables transfers until ambassador phase is over
338         // ( we dont want whale premines )
339         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
340         
341         // withdraw all outstanding dividends first
342         if(myDividends(true) > 0) withdraw();
343         
344         // liquify 10% of the tokens that are transfered
345         // these are dispersed to shareholders
346         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
347         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
348         uint256 _dividends = tokensToEthereum_(_tokenFee);
349   
350         // burn the fee tokens
351         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
352 
353         // exchange tokens
354         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
355         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
356         
357         // update dividend trackers
358         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
359         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
360         
361         // disperse dividends among holders
362         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
363         
364         // fire event
365         Transfer(_customerAddress, _toAddress, _taxedTokens);
366         
367         // ERC20
368         return true;
369        
370     }
371     
372     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
373     /**
374      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
375      */
376     function disableInitialStage()
377         onlyAdministrator()
378         public
379     {
380         onlyAmbassadors = false;
381     }
382     
383     /**
384      * In case one of us dies, we need to replace ourselves.
385      */
386     function setAdministrator(bytes32 _identifier, bool _status)
387         onlyAdministrator()
388         public
389     {
390         administrators[_identifier] = _status;
391     }
392     
393     /**
394      * Precautionary measures in case we need to adjust the masternode rate.
395      */
396     function setStakingRequirement(uint256 _amountOfTokens)
397         onlyAdministrator()
398         public
399     {
400         stakingRequirement = _amountOfTokens;
401     }
402     
403     /**
404      * If we want to rebrand, we can.
405      */
406     function setName(string _name)
407         onlyAdministrator()
408         public
409     {
410         name = _name;
411     }
412     
413     /**
414      * If we want to rebrand, we can.
415      */
416     function setSymbol(string _symbol)
417         onlyAdministrator()
418         public
419     {
420         symbol = _symbol;
421     }
422 
423     
424     /*----------  HELPERS AND CALCULATORS  ----------*/
425     /**
426      * Method to view the current Ethereum stored in the contract
427      * Example: totalEthereumBalance()
428      */
429     function totalEthereumBalance()
430         public
431         view
432         returns(uint)
433     {
434         return this.balance;
435     }
436     
437     /**
438      * Retrieve the total token supply.
439      */
440     function totalSupply()
441         public
442         view
443         returns(uint256)
444     {
445         return tokenSupply_;
446     }
447     
448     /**
449      * Retrieve the tokens owned by the caller.
450      */
451     function myTokens()
452         public
453         view
454         returns(uint256)
455     {
456         address _customerAddress = msg.sender;
457         return balanceOf(_customerAddress);
458     }
459     
460     /**
461      * Retrieve the dividends owned by the caller.
462      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
463      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
464      * But in the internal calculations, we want them separate. 
465      */ 
466     function myDividends(bool _includeReferralBonus) 
467         public 
468         view 
469         returns(uint256)
470     {
471         address _customerAddress = msg.sender;
472         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
473     }
474     
475     /**
476      * Retrieve the token balance of any single address.
477      */
478     function balanceOf(address _customerAddress)
479         view
480         public
481         returns(uint256)
482     {
483         return tokenBalanceLedger_[_customerAddress];
484     }
485     
486     /**
487      * Retrieve the dividend balance of any single address.
488      */
489     function dividendsOf(address _customerAddress)
490         view
491         public
492         returns(uint256)
493     {
494         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
495     }
496     
497     /**
498      * Return the buy price of 1 individual token.
499      */
500     function sellPrice() 
501         public 
502         view 
503         returns(uint256)
504     {
505         // our calculation relies on the token supply, so we need supply. Doh.
506         if(tokenSupply_ == 0){
507             return tokenPriceInitial_ - tokenPriceIncremental_;
508         } else {
509             uint256 _ethereum = tokensToEthereum_(1e18);
510             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
511             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
512             return _taxedEthereum;
513         }
514     }
515     
516     /**
517      * Return the sell price of 1 individual token.
518      */
519     function buyPrice() 
520         public 
521         view 
522         returns(uint256)
523     {
524         // our calculation relies on the token supply, so we need supply. Doh.
525         if(tokenSupply_ == 0){
526             return tokenPriceInitial_ + tokenPriceIncremental_;
527         } else {
528             uint256 _ethereum = tokensToEthereum_(1e18);
529             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
530             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
531             return _taxedEthereum;
532         }
533     }
534     
535     /**
536      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
537      */
538     function calculateTokensReceived(uint256 _ethereumToSpend) 
539         public 
540         view 
541         returns(uint256)
542     {
543         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
544         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
545         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
546         
547         return _amountOfTokens;
548     }
549     
550     /**
551      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
552      */
553     function calculateEthereumReceived(uint256 _tokensToSell) 
554         public 
555         view 
556         returns(uint256)
557     {
558         require(_tokensToSell <= tokenSupply_);
559         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
560         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
561         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
562         return _taxedEthereum;
563     }
564     
565     
566     /*==========================================
567     =            INTERNAL FUNCTIONS            =
568     ==========================================*/
569     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
570         antiEarlyWhale(_incomingEthereum)
571         internal
572         returns(uint256)
573     {
574         // data setup
575         address _customerAddress = msg.sender;
576         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
577         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
578         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
579         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
580         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
581         uint256 _fee = _dividends * magnitude;
582  
583         // no point in continuing execution if OP is a poorfag russian hacker
584         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
585         // (or hackers)
586         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
587         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
588         
589         // is the user referred by a masternode?
590         if(
591             // is this a referred purchase?
592             _referredBy != 0x0000000000000000000000000000000000000000 &&
593 
594             // no cheating!
595             _referredBy != _customerAddress &&
596             
597             // does the referrer have at least X whole tokens?
598             // i.e is the referrer a godly chad masternode
599             tokenBalanceLedger_[_referredBy] >= stakingRequirement
600         ){
601             // wealth redistribution
602             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
603         } else {
604             // no ref purchase
605             // add the referral bonus back to the global dividends cake
606             _dividends = SafeMath.add(_dividends, _referralBonus);
607             _fee = _dividends * magnitude;
608         }
609         
610         // we can't give people infinite ethereum
611         if(tokenSupply_ > 0){
612             
613             // add tokens to the pool
614             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
615  
616             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
617             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
618             
619             // calculate the amount of tokens the customer receives over his purchase 
620             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
621         
622         } else {
623             // add tokens to the pool
624             tokenSupply_ = _amountOfTokens;
625         }
626         
627         // update circulating supply & the ledger address for the customer
628         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
629         
630         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
631         //really i know you think you do but you don't
632         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
633         payoutsTo_[_customerAddress] += _updatedPayouts;
634         
635         // fire event
636         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
637         
638         return _amountOfTokens;
639     }
640 
641     /**
642      * Calculate Token price based on an amount of incoming ethereum
643      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
644      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
645      */
646     function ethereumToTokens_(uint256 _ethereum)
647         internal
648         view
649         returns(uint256)
650     {
651         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
652         uint256 _tokensReceived = 
653          (
654             (
655                 // underflow attempts BTFO
656                 SafeMath.sub(
657                     (sqrt
658                         (
659                             (_tokenPriceInitial**2)
660                             +
661                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
662                             +
663                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
664                             +
665                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
666                         )
667                     ), _tokenPriceInitial
668                 )
669             )/(tokenPriceIncremental_)
670         )-(tokenSupply_)
671         ;
672   
673         return _tokensReceived;
674     }
675     
676     /**
677      * Calculate token sell value.
678      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
679      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
680      */
681      function tokensToEthereum_(uint256 _tokens)
682         internal
683         view
684         returns(uint256)
685     {
686 
687         uint256 tokens_ = (_tokens + 1e18);
688         uint256 _tokenSupply = (tokenSupply_ + 1e18);
689         uint256 _etherReceived =
690         (
691             // underflow attempts BTFO
692             SafeMath.sub(
693                 (
694                     (
695                         (
696                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
697                         )-tokenPriceIncremental_
698                     )*(tokens_ - 1e18)
699                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
700             )
701         /1e18);
702         return _etherReceived;
703     }
704     
705     
706     //This is where all your gas goes, sorry
707     //Not sorry, you probably only paid 1 gwei
708     function sqrt(uint x) internal pure returns (uint y) {
709         uint z = (x + 1) / 2;
710         y = x;
711         while (z < y) {
712             y = z;
713             z = (x / z + z) / 2;
714         }
715     }
716 }
717 
718 /**
719  * @title SafeMath
720  * @dev Math operations with safety checks that throw on error
721  */
722 library SafeMath {
723 
724     /**
725     * @dev Multiplies two numbers, throws on overflow.
726     */
727     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
728         if (a == 0) {
729             return 0;
730         }
731         uint256 c = a * b;
732         assert(c / a == b);
733         return c;
734     }
735 
736     /**
737     * @dev Integer division of two numbers, truncating the quotient.
738     */
739     function div(uint256 a, uint256 b) internal pure returns (uint256) {
740         // assert(b > 0); // Solidity automatically throws when dividing by 0
741         uint256 c = a / b;
742         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
743         return c;
744     }
745 
746     /**
747     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
748     */
749     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
750         assert(b <= a);
751         return a - b;
752     }
753 
754     /**
755     * @dev Adds two numbers, throws on overflow.
756     */
757     function add(uint256 a, uint256 b) internal pure returns (uint256) {
758         uint256 c = a + b;
759         assert(c >= a);
760         return c;
761     }
762 }