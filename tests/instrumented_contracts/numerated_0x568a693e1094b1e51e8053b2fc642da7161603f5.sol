1 pragma solidity ^0.4.20;
2 
3 /*
4 *Team Bitconnect presents 
5 *Bitconnect2.0  a fully decentralized earning platform
6 *no guarantees are given
7 * If you buy BC2 token you will receive dividends as long as you hold those token.
8 * ====================================*
9 * -> What?
10 * The original autonomous pyramid, improved:
11 * [x] More stable than ever, having withstood severe testnet abuse and attack attempts from our community!.
12 * [x] Audited, tested, and approved by known community security specialists.
13 * [X] New functionality; you can now perform partial sell orders. 
14 * [x] New functionality; you can now transfer tokens between wallets. Trading is now possible from within the contract!
15 * [x] New Feature: PoS Masternodes! The first implementation of Ethereum Staking in the world! Vitalik is mad.
16 * [x] Masternodes: Holding 1 BC2 Token allows you to generate a Masternode link, Masternode links are used as unique entry points to the contract!
17 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 10% dividends fee rerouted from the master-node, to the node-master!
18 *
19 * -> What about the last projects?
20 * BitConnect 2 is a new Project
21 * The new dev team consists of seasoned, professional developers and has been audited by veteran solidity experts.
22 * Additionally, two independent testnet iterations have been used by hundreds of people; not a single point of failure was found.
23 * 
24 * -> Who worked on this project?
25 * - Gilgamesh
26 * - 
27 * - 
28 * - 
29 */
30 
31 contract BitConnect {
32     /*=================================
33     =            MODIFIERS            =
34     =================================*/
35     // only people with tokens
36     modifier onlyBagholders() {
37         require(myTokens() > 0);
38         _;
39     }
40     
41     // only people with profits
42     modifier onlyStronghands() {
43         require(myDividends(true) > 0);
44         _;
45     }
46     
47     // administrators can:
48     // -> change the name of the contract
49     // -> change the name of the token
50     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
51     // they CANNOT:
52     // -> take funds
53     // -> disable withdrawals
54     // -> kill the contract
55     // -> change the price of tokens
56     modifier onlyAdministrator(){
57         address _customerAddress = msg.sender;
58         require(administrators[keccak256(_customerAddress)]);
59         _;
60     }
61     
62     
63     // ensures that the first tokens in the contract will be equally distributed
64     // meaning, no divine dump will be ever possible
65     // result: healthy longevity.
66     modifier antiEarlyWhale(uint256 _amountOfEthereum){
67         address _customerAddress = msg.sender;
68         
69         // are we still in the vulnerable phase?
70         // if so, enact anti early whale protocol 
71         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
72             require(
73                 // is the customer in the ambassador list?
74                 ambassadors_[_customerAddress] == true &&
75                 
76                 // does the customer purchase exceed the max ambassador quota?
77                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
78                 
79             );
80             
81             // updated the accumulated quota    
82             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
83         
84             // execute
85             _;
86         } else {
87             // in case the ether count drops low, the ambassador phase won't reinitiate
88             onlyAmbassadors = false;
89             _;    
90         }
91         
92     }
93     
94     
95     /*==============================
96     =            EVENTS            =
97     ==============================*/
98     event onTokenPurchase(
99         address indexed customerAddress,
100         uint256 incomingEthereum,
101         uint256 tokensMinted,
102         address indexed referredBy
103     );
104     
105     event onTokenSell(
106         address indexed customerAddress,
107         uint256 tokensBurned,
108         uint256 ethereumEarned
109     );
110     
111     event onReinvestment(
112         address indexed customerAddress,
113         uint256 ethereumReinvested,
114         uint256 tokensMinted
115     );
116     
117     event onWithdraw(
118         address indexed customerAddress,
119         uint256 ethereumWithdrawn
120     );
121     
122     // ERC20
123     event Transfer(
124         address indexed from,
125         address indexed to,
126         uint256 tokens
127     );
128     
129     
130     /*=====================================
131     =            CONFIGURABLES            =
132     =====================================*/
133     string public name = "BitConnect2";
134     string public symbol = "BC2";
135     uint8 constant public decimals = 18;
136     uint8 constant internal dividendFee_ = 10;
137     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
138     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
139     uint256 constant internal magnitude = 2**64;
140     
141     // proof of stake (defaults at 100 tokens)
142     uint256 public stakingRequirement = 1e18;
143     
144     // ambassador program
145     mapping(address => bool) internal ambassadors_;
146     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
147     uint256 constant internal ambassadorQuota_ = 20 ether;
148     
149     
150     
151    /*================================
152     =            DATASETS            =
153     ================================*/
154     // amount of shares for each address (scaled number)
155     mapping(address => uint256) internal tokenBalanceLedger_;
156     mapping(address => uint256) internal referralBalance_;
157     mapping(address => int256) internal payoutsTo_;
158     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
159     uint256 internal tokenSupply_ = 0;
160     uint256 internal profitPerShare_;
161     
162     // administrator list (see above on what they can do)
163     mapping(bytes32 => bool) public administrators;
164     
165     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
166     bool public onlyAmbassadors = true;
167     
168 
169 
170     /*=======================================
171     =            PUBLIC FUNCTIONS            =
172     =======================================*/
173     /*
174     * -- APPLICATION ENTRY POINTS --  
175     */
176     function BitConnect()
177         public
178     {
179         // add administrators here
180         administrators[keccak256(0x293Bcb20584a2e0E6d1b559E25783311ec29121C)] = true;
181         
182         // add the ambassadors here.
183         // Gilgamesh 
184         ambassadors_[0x56f248c36642b58251d44e3328e735c01cba875d] = true;
185         
186         
187         ambassadors_[0x293Bcb20584a2e0E6d1b559E25783311ec29121C] = true;
188    
189         
190 
191     }
192     
193      
194     /**
195      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
196      */
197     function buy(address _referredBy)
198         public
199         payable
200         returns(uint256)
201     {
202         purchaseTokens(msg.value, _referredBy);
203     }
204     
205     /**
206      * Fallback function to handle ethereum that was send straight to the contract
207      * Unfortunately we cannot use a referral address this way.
208      */
209     function()
210         payable
211         public
212     {
213         purchaseTokens(msg.value, 0x0);
214     }
215     
216     /**
217      * Converts all of caller's dividends to tokens.
218      */
219     function reinvest()
220         onlyStronghands()
221         public
222     {
223         // fetch dividends
224         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
225         
226         // pay out the dividends virtually
227         address _customerAddress = msg.sender;
228         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
229         
230         // retrieve ref. bonus
231         _dividends += referralBalance_[_customerAddress];
232         referralBalance_[_customerAddress] = 0;
233         
234         // dispatch a buy order with the virtualized "withdrawn dividends"
235         uint256 _tokens = purchaseTokens(_dividends, 0x0);
236         
237         // fire event
238         onReinvestment(_customerAddress, _dividends, _tokens);
239     }
240     
241     /**
242      * Alias of sell() and withdraw().
243      */
244     function exit()
245         public
246     {
247         // get token count for caller & sell them all
248         address _customerAddress = msg.sender;
249         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
250         if(_tokens > 0) sell(_tokens);
251         
252         // lambo delivery service
253         withdraw();
254     }
255 
256     /**
257      * Withdraws all of the callers earnings.
258      */
259     function withdraw()
260         onlyStronghands()
261         public
262     {
263         // setup data
264         address _customerAddress = msg.sender;
265         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
266         
267         // update dividend tracker
268         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
269         
270         // add ref. bonus
271         _dividends += referralBalance_[_customerAddress];
272         referralBalance_[_customerAddress] = 0;
273         
274         // lambo delivery service
275         _customerAddress.transfer(_dividends);
276         
277         // fire event
278         onWithdraw(_customerAddress, _dividends);
279     }
280     
281     /**
282      * Liquifies tokens to ethereum.
283      */
284     function sell(uint256 _amountOfTokens)
285         onlyBagholders()
286         public
287     {
288         // setup data
289         address _customerAddress = msg.sender;
290         // russian hackers BTFO
291         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
292         uint256 _tokens = _amountOfTokens;
293         uint256 _ethereum = tokensToEthereum_(_tokens);
294         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
295         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
296         
297         // burn the sold tokens
298         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
299         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
300         
301         // update dividends tracker
302         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
303         payoutsTo_[_customerAddress] -= _updatedPayouts;       
304         
305         // dividing by zero is a bad idea
306         if (tokenSupply_ > 0) {
307             // update the amount of dividends per token
308             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
309         }
310         
311         // fire event
312         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
313     }
314     
315     
316     /**
317      * Transfer tokens from the caller to a new holder.
318      * Remember, there's a 10% fee here as well.
319      */
320     function transfer(address _toAddress, uint256 _amountOfTokens)
321         onlyBagholders()
322         public
323         returns(bool)
324     {
325         // setup
326         address _customerAddress = msg.sender;
327         
328         // make sure we have the requested tokens
329         // also disables transfers until ambassador phase is over
330         // ( we dont want whale premines )
331         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
332         
333         // withdraw all outstanding dividends first
334         if(myDividends(true) > 0) withdraw();
335         
336         // liquify 10% of the tokens that are transfered
337         // these are dispersed to shareholders
338         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
339         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
340         uint256 _dividends = tokensToEthereum_(_tokenFee);
341   
342         // burn the fee tokens
343         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
344 
345         // exchange tokens
346         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
347         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
348         
349         // update dividend trackers
350         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
351         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
352         
353         // disperse dividends among holders
354         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
355         
356         // fire event
357         Transfer(_customerAddress, _toAddress, _taxedTokens);
358         
359         // ERC20
360         return true;
361        
362     }
363     
364     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
365     /**
366      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
367      */
368     function disableInitialStage()
369         onlyAdministrator()
370         public
371     {
372         onlyAmbassadors = false;
373     }
374     
375     /**
376      * In case one of us dies, we need to replace ourselves.
377      */
378     function setAdministrator(bytes32 _identifier, bool _status)
379         onlyAdministrator()
380         public
381     {
382         administrators[_identifier] = _status;
383     }
384     
385     /**
386      * Precautionary measures in case we need to adjust the masternode rate.
387      */
388     function setStakingRequirement(uint256 _amountOfTokens)
389         onlyAdministrator()
390         public
391     {
392         stakingRequirement = _amountOfTokens;
393     }
394     
395     /**
396      * If we want to rebrand, we can.
397      */
398     function setName(string _name)
399         onlyAdministrator()
400         public
401     {
402         name = _name;
403     }
404     
405     /**
406      * If we want to rebrand, we can.
407      */
408     function setSymbol(string _symbol)
409         onlyAdministrator()
410         public
411     {
412         symbol = _symbol;
413     }
414 
415     
416     /*----------  HELPERS AND CALCULATORS  ----------*/
417     /**
418      * Method to view the current Ethereum stored in the contract
419      * Example: totalEthereumBalance()
420      */
421     function totalEthereumBalance()
422         public
423         view
424         returns(uint)
425     {
426         return this.balance;
427     }
428     
429     /**
430      * Retrieve the total token supply.
431      */
432     function totalSupply()
433         public
434         view
435         returns(uint256)
436     {
437         return tokenSupply_;
438     }
439     
440     /**
441      * Retrieve the tokens owned by the caller.
442      */
443     function myTokens()
444         public
445         view
446         returns(uint256)
447     {
448         address _customerAddress = msg.sender;
449         return balanceOf(_customerAddress);
450     }
451     
452     /**
453      * Retrieve the dividends owned by the caller.
454      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
455      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
456      * But in the internal calculations, we want them separate. 
457      */ 
458     function myDividends(bool _includeReferralBonus) 
459         public 
460         view 
461         returns(uint256)
462     {
463         address _customerAddress = msg.sender;
464         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
465     }
466     
467     /**
468      * Retrieve the token balance of any single address.
469      */
470     function balanceOf(address _customerAddress)
471         view
472         public
473         returns(uint256)
474     {
475         return tokenBalanceLedger_[_customerAddress];
476     }
477     
478     /**
479      * Retrieve the dividend balance of any single address.
480      */
481     function dividendsOf(address _customerAddress)
482         view
483         public
484         returns(uint256)
485     {
486         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
487     }
488     
489     /**
490      * Return the buy price of 1 individual token.
491      */
492     function sellPrice() 
493         public 
494         view 
495         returns(uint256)
496     {
497         // our calculation relies on the token supply, so we need supply. Doh.
498         if(tokenSupply_ == 0){
499             return tokenPriceInitial_ - tokenPriceIncremental_;
500         } else {
501             uint256 _ethereum = tokensToEthereum_(1e18);
502             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
503             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
504             return _taxedEthereum;
505         }
506     }
507     
508     /**
509      * Return the sell price of 1 individual token.
510      */
511     function buyPrice() 
512         public 
513         view 
514         returns(uint256)
515     {
516         // our calculation relies on the token supply, so we need supply. Doh.
517         if(tokenSupply_ == 0){
518             return tokenPriceInitial_ + tokenPriceIncremental_;
519         } else {
520             uint256 _ethereum = tokensToEthereum_(1e18);
521             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
522             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
523             return _taxedEthereum;
524         }
525     }
526     
527     /**
528      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
529      */
530     function calculateTokensReceived(uint256 _ethereumToSpend) 
531         public 
532         view 
533         returns(uint256)
534     {
535         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
536         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
537         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
538         
539         return _amountOfTokens;
540     }
541     
542     /**
543      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
544      */
545     function calculateEthereumReceived(uint256 _tokensToSell) 
546         public 
547         view 
548         returns(uint256)
549     {
550         require(_tokensToSell <= tokenSupply_);
551         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
552         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
553         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
554         return _taxedEthereum;
555     }
556     
557     
558     /*==========================================
559     =            INTERNAL FUNCTIONS            =
560     ==========================================*/
561     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
562         antiEarlyWhale(_incomingEthereum)
563         internal
564         returns(uint256)
565     {
566         // data setup
567         address _customerAddress = msg.sender;
568         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
569         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
570         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
571         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
572         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
573         uint256 _fee = _dividends * magnitude;
574  
575         // no point in continuing execution if OP is a poorfag russian hacker
576         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
577         // (or hackers)
578         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
579         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
580         
581         // is the user referred by a masternode?
582         if(
583             // is this a referred purchase?
584             _referredBy != 0x0000000000000000000000000000000000000000 &&
585 
586             // no cheating!
587             _referredBy != _customerAddress &&
588             
589             // does the referrer have at least X whole tokens?
590             // i.e is the referrer a godly chad masternode
591             tokenBalanceLedger_[_referredBy] >= stakingRequirement
592         ){
593             // wealth redistribution
594             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
595         } else {
596             // no ref purchase
597             // add the referral bonus back to the global dividends cake
598             _dividends = SafeMath.add(_dividends, _referralBonus);
599             _fee = _dividends * magnitude;
600         }
601         
602         // we can't give people infinite ethereum
603         if(tokenSupply_ > 0){
604             
605             // add tokens to the pool
606             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
607  
608             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
609             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
610             
611             // calculate the amount of tokens the customer receives over his purchase 
612             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
613         
614         } else {
615             // add tokens to the pool
616             tokenSupply_ = _amountOfTokens;
617         }
618         
619         // update circulating supply & the ledger address for the customer
620         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
621         
622         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
623         //really i know you think you do but you don't
624         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
625         payoutsTo_[_customerAddress] += _updatedPayouts;
626         
627         // fire event
628         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
629         
630         return _amountOfTokens;
631     }
632 
633     /**
634      * Calculate Token price based on an amount of incoming ethereum
635      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
636      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
637      */
638     function ethereumToTokens_(uint256 _ethereum)
639         internal
640         view
641         returns(uint256)
642     {
643         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
644         uint256 _tokensReceived = 
645          (
646             (
647                 // underflow attempts BTFO
648                 SafeMath.sub(
649                     (sqrt
650                         (
651                             (_tokenPriceInitial**2)
652                             +
653                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
654                             +
655                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
656                             +
657                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
658                         )
659                     ), _tokenPriceInitial
660                 )
661             )/(tokenPriceIncremental_)
662         )-(tokenSupply_)
663         ;
664   
665         return _tokensReceived;
666     }
667     
668     /**
669      * Calculate token sell value.
670      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
671      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
672      */
673      function tokensToEthereum_(uint256 _tokens)
674         internal
675         view
676         returns(uint256)
677     {
678 
679         uint256 tokens_ = (_tokens + 1e18);
680         uint256 _tokenSupply = (tokenSupply_ + 1e18);
681         uint256 _etherReceived =
682         (
683             // underflow attempts BTFO
684             SafeMath.sub(
685                 (
686                     (
687                         (
688                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
689                         )-tokenPriceIncremental_
690                     )*(tokens_ - 1e18)
691                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
692             )
693         /1e18);
694         return _etherReceived;
695     }
696     
697     
698     //This is where all your gas goes, sorry
699     //Not sorry, you probably only paid 1 gwei
700     function sqrt(uint x) internal pure returns (uint y) {
701         uint z = (x + 1) / 2;
702         y = x;
703         while (z < y) {
704             y = z;
705             z = (x / z + z) / 2;
706         }
707     }
708 }
709 
710 /**
711  * @title SafeMath
712  * @dev Math operations with safety checks that throw on error
713  */
714 library SafeMath {
715 
716     /**
717     * @dev Multiplies two numbers, throws on overflow.
718     */
719     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
720         if (a == 0) {
721             return 0;
722         }
723         uint256 c = a * b;
724         assert(c / a == b);
725         return c;
726     }
727 
728     /**
729     * @dev Integer division of two numbers, truncating the quotient.
730     */
731     function div(uint256 a, uint256 b) internal pure returns (uint256) {
732         // assert(b > 0); // Solidity automatically throws when dividing by 0
733         uint256 c = a / b;
734         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
735         return c;
736     }
737 
738     /**
739     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
740     */
741     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
742         assert(b <= a);
743         return a - b;
744     }
745 
746     /**
747     * @dev Adds two numbers, throws on overflow.
748     */
749     function add(uint256 a, uint256 b) internal pure returns (uint256) {
750         uint256 c = a + b;
751         assert(c >= a);
752         return c;
753     }
754 }