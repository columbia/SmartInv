1 pragma solidity ^0.4.20;
2 
3 /*
4 * Proof of Bling Muthafucker
5 * 
6 * This be a cold-ass lil cloned POWH3D smart-ass contract
7 *
8 * Our thugged-out asses have made some chizzlez ta parametas like fuckin tha dividendFee_ divisor from 10 ta 4 ta yield a funky-ass bigger Fee n' Dividendz
9 *
10 * 25% DIVs 
11 *
12 * If yo ass has a master node, you get 25% of those fly ass DIVs fo' yoself
13 *
14 * If yo ass don't have a master node then referral go to the crib
15 *
16 * Get yo ass a master node and shill this shit
17 */
18 
19 contract BLING {
20     /*=================================
21     =        Fly Ass MODIFIERS        =
22     =================================*/
23     // only playas wit tokens
24     modifier onlyBagholders() {
25         require(myTokens() > 0);
26         _;
27     }
28     
29      // only playas wit profits
30     modifier onlyStronghands() {
31         require(myDividends(true) > 0);
32         _;
33     }
34     
35     // administrators can:
36     // -> change the name of the contract
37     // -> change the name of the token
38     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
39     // they CANNOT:
40     // -> take funds
41     // -> disable withdrawals
42     // -> kill tha contract
43     // -> change the price of tokens
44     modifier onlyAdministrator(){
45         address _customerAddress = msg.sender;
46 
47         require(administrators[_customerAddress]);
48         _;
49     }
50     
51       // ensures dat tha straight-up original gangsta tokens up in tha contract is ghon be equally distributed
52     // meaning, no divine dump is ghon be eva possible
53     // result: healthy longevity.
54     modifier antiEarlyWhale(uint256 _amountOfEthereum){
55         address _customerAddress = msg.sender;
56         
57         // are we still in the vulnerable phase?
58         // if so, enact anti early whale protocol 
59         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
60             require(
61                 // is the customer in the ambassador list?
62                 ambassadors_[_customerAddress] == true &&
63                 
64                 // does the customer purchase exceed the max ambassador quota?
65                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
66                 
67             );
68             
69             // updated the accumulated quota    
70             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
71         
72             // execute
73             _;
74         } else {
75             // in case the ether count drops low, the ambassador phase won't reinitiate
76             onlyAmbassadors = false;
77             _;    
78         }
79         
80     }
81     
82     
83     /*==============================
84     =            EVENTS            =
85     ==============================*/
86     event onTokenPurchase(
87         address indexed customerAddress,
88         uint256 incomingEthereum,
89         uint256 tokensMinted,
90         address indexed referredBy
91     );
92     
93     event onTokenSell(
94         address indexed customerAddress,
95         uint256 tokensBurned,
96         uint256 ethereumEarned
97     );
98     
99     event onReinvestment(
100         address indexed customerAddress,
101         uint256 ethereumReinvested,
102         uint256 tokensMinted
103     );
104     
105     event onWithdraw(
106         address indexed customerAddress,
107         uint256 ethereumWithdrawn
108     );
109     
110     // ERC20
111     event Transfer(
112         address indexed from,
113         address indexed to,
114         uint256 tokens
115     );
116 
117     
118     /*=====================================
119     =            CONFIGURABLES            =
120     =====================================*/
121     string public name = "PROOFOFBLING";
122     string public symbol = "BLING";
123     uint8 constant public decimals = 18;
124     uint8 constant internal dividendFee_ = 4;    //25% Dividends Bitches
125     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
126     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
127     uint256 constant internal magnitude = 2**64;
128     
129     // No Master Nodes in this Game
130     uint256 public stakingRequirement = 10e18;   //10 Muthafuckin Tokens
131     
132     // ambassador program
133     mapping(address => bool) internal ambassadors_;     // We ain't using this shit
134     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
135     uint256 constant internal ambassadorQuota_ = 20 ether;
136     
137     
138     
139    /*================================
140     =            DATASETS            =
141     ================================*/
142     // amount of shares for each address (scaled number)
143     mapping(address => uint256) internal tokenBalanceLedger_;
144     mapping(address => uint256) internal referralBalance_;
145     mapping(address => int256) internal payoutsTo_;
146     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
147     uint256 internal tokenSupply_ = 0;
148     uint256 internal profitPerShare_;
149     
150     // administrator list (see above on what they can do)
151     //mapping(bytes32 => bool) public administrators;
152     mapping(address => bool) public administrators;
153     
154     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
155     bool public onlyAmbassadors = true;
156 
157     address HNIC;
158     
159 
160 
161     /*=======================================
162     =            PUBLIC FUNCTIONS            =
163     =======================================*/
164     /*
165     * -- APPLICATION ENTRY POINTS --  
166     */
167     function BLING()
168         public
169     {
170         // add administrators here
171 
172 
173         administrators[msg.sender] = true;
174 
175         HNIC = msg.sender;
176 
177         onlyAmbassadors = false;
178 
179     }
180     
181      
182     /**
183      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
184      */
185     function buy(address _referredBy)
186         public
187         payable
188         returns(uint256)
189     {
190         purchaseTokens(msg.value, _referredBy);
191     }
192     
193     /**
194      * Fallback function to handle ethereum that was send straight to the contract
195      * Unfortunately we cannot use a referral address this way.
196      */
197     function()
198         payable
199         public
200     {
201         purchaseTokens(msg.value, 0x0);
202     }
203     
204     /**
205      * Converts all of caller's dividends to tokens.
206      */
207     function reinvest()
208         onlyStronghands()
209         public
210     {
211         // fetch dividends
212         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
213         
214         // pay out the dividends virtually
215         address _customerAddress = msg.sender;
216         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
217         
218         // retrieve ref. bonus
219         _dividends += referralBalance_[_customerAddress];
220         referralBalance_[_customerAddress] = 0;
221         
222         // dispatch a buy order with the virtualized "withdrawn dividends"
223         uint256 _tokens = purchaseTokens(_dividends, 0x0);
224         
225         // fire event
226         onReinvestment(_customerAddress, _dividends, _tokens);
227     }
228     
229     /**
230      * Alias of sell() and withdraw().
231      */
232     function exit()
233         public
234     {
235         // get token count for caller & sell them all
236         address _customerAddress = msg.sender;
237         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
238         if(_tokens > 0) sell(_tokens);
239         
240         // lambo delivery service
241         withdraw();
242     }
243 
244     /**
245      * Withdraws all of the callers earnings.
246      */
247     function withdraw()
248         onlyStronghands()
249         public
250     {
251         // setup data
252         address _customerAddress = msg.sender;
253         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
254         
255         // update dividend tracker
256         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
257         
258         // add ref. bonus
259         _dividends += referralBalance_[_customerAddress];
260         referralBalance_[_customerAddress] = 0;
261         
262         // lambo delivery service
263         _customerAddress.transfer(_dividends);
264         
265         // fire event
266         onWithdraw(_customerAddress, _dividends);
267     }
268     
269     /**
270      * Liquifies tokens to ethereum.
271      */
272     function sell(uint256 _amountOfTokens)
273         onlyBagholders()
274         public
275     {
276         // setup data
277         address _customerAddress = msg.sender;
278         // russian hackers BTFO
279         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
280         uint256 _tokens = _amountOfTokens;
281         uint256 _ethereum = tokensToEthereum_(_tokens);
282         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
283         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
284         
285         // burn the sold tokens
286         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
287         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
288         
289         // update dividends tracker
290         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
291         payoutsTo_[_customerAddress] -= _updatedPayouts;       
292         
293         // dividing by zero is a bad idea
294         if (tokenSupply_ > 0) {
295             // update the amount of dividends per token
296             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
297         }
298         
299         // fire event
300         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
301     }
302     
303     
304     /**
305      * Transfer tokens from the caller to a new holder.
306      * Remember, there's a 10% fee here as well.
307      */
308     function transfer(address _toAddress, uint256 _amountOfTokens)
309         onlyBagholders()
310         public
311         returns(bool)
312     {
313         // setup
314         address _customerAddress = msg.sender;
315         
316         // make sure we have the requested tokens
317         // also disables transfers until ambassador phase is over
318         // ( we dont want whale premines )
319         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
320         
321         // withdraw all outstanding dividends first
322         if(myDividends(true) > 0) withdraw();
323         
324         // liquify 10% of the tokens that are transfered
325         // these are dispersed to shareholders
326         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
327         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
328         uint256 _dividends = tokensToEthereum_(_tokenFee);
329   
330         // burn the fee tokens
331         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
332 
333         // exchange tokens
334         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
335         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
336         
337         // update dividend trackers
338         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
339         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
340         
341         // disperse dividends among holders
342         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
343         
344         // fire event
345         Transfer(_customerAddress, _toAddress, _taxedTokens);
346         
347         // ERC20
348         return true;
349        
350     }
351     
352     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
353     /**
354      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
355      */
356     function disableInitialStage()
357         onlyAdministrator()
358         public
359     {
360         onlyAmbassadors = false;
361     }
362     
363     /**
364      * In case one of us gets capped, we need to replace his azz.
365      */
366     function setAdministrator(address _identifier, bool _status)
367         onlyAdministrator()
368         public
369     {
370         administrators[_identifier] = _status;
371     }
372     
373     /**
374      * Precautionary measures in case we need to adjust the masternode rate.
375      */
376     function setStakingRequirement(uint256 _amountOfTokens)
377         onlyAdministrator()
378         public
379     {
380         stakingRequirement = _amountOfTokens;
381     }
382     
383     /**
384      * If we want to rebrand, we can.
385      */
386     function setName(string _name)
387         onlyAdministrator()
388         public
389     {
390         name = _name;
391     }
392     
393     /**
394      * If we want to rebrand, we can.
395      */
396     function setSymbol(string _symbol)
397         onlyAdministrator()
398         public
399     {
400         symbol = _symbol;
401     }
402 
403     
404     /*----------  HELPERS AND CALCULATORS  ----------*/
405     /**
406      * Method to view the current Ethereum stored in the contract
407      * Example: totalEthereumBalance()
408      */
409     function totalEthereumBalance()
410         public
411         view
412         returns(uint)
413     {
414         return address (this).balance;
415     }
416     
417     /**
418      * Retrieve the total token supply.
419      */
420     function totalSupply()
421         public
422         view
423         returns(uint256)
424     {
425         return tokenSupply_;
426     }
427     
428     /**
429      * Retrieve the tokens owned by the caller.
430      */
431     function myTokens()
432         public
433         view
434         returns(uint256)
435     {
436         address _customerAddress = msg.sender;
437         return balanceOf(_customerAddress);
438     }
439     
440     /**
441      * Retrieve the dividends owned by the caller.
442      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
443      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
444      * But in the internal calculations, we want them separate. 
445      */ 
446     function myDividends(bool _includeReferralBonus) 
447         public 
448         view 
449         returns(uint256)
450     {
451         address _customerAddress = msg.sender;
452         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
453     }
454     
455     /**
456      * Retrieve the token balance of any single address.
457      */
458     function balanceOf(address _customerAddress)
459         view
460         public
461         returns(uint256)
462     {
463         return tokenBalanceLedger_[_customerAddress];
464     }
465     
466     /**
467      * Retrieve the dividend balance of any single address.
468      */
469     function dividendsOf(address _customerAddress)
470         view
471         public
472         returns(uint256)
473     {
474         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
475     }
476     
477     /**
478      * Return the buy price of 1 individual token.
479      */
480     function sellPrice() 
481         public 
482         view 
483         returns(uint256)
484     {
485         // our calculation relies on the token supply, so we need supply. Doh.
486         if(tokenSupply_ == 0){
487             return tokenPriceInitial_ - tokenPriceIncremental_;
488         } else {
489             uint256 _ethereum = tokensToEthereum_(1e18);
490             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
491             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
492             return _taxedEthereum;
493         }
494     }
495     
496     /**
497      * Return the sell price of 1 individual token.
498      */
499     function buyPrice() 
500         public 
501         view 
502         returns(uint256)
503     {
504         // our calculation relies on the token supply, so we need supply. Doh.
505         if(tokenSupply_ == 0){
506             return tokenPriceInitial_ + tokenPriceIncremental_;
507         } else {
508             uint256 _ethereum = tokensToEthereum_(1e18);
509             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
510             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
511             return _taxedEthereum;
512         }
513     }
514     
515     /**
516      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
517      */
518     function calculateTokensReceived(uint256 _ethereumToSpend) 
519         public 
520         view 
521         returns(uint256)
522     {
523         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
524         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
525         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
526         
527         return _amountOfTokens;
528     }
529     
530     /**
531      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
532      */
533     function calculateEthereumReceived(uint256 _tokensToSell) 
534         public 
535         view 
536         returns(uint256)
537     {
538         require(_tokensToSell <= tokenSupply_);
539         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
540         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
541         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
542         return _taxedEthereum;
543     }
544     
545     
546     /*==========================================
547     =            INTERNAL FUNCTIONS            =
548     ==========================================*/
549     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
550         antiEarlyWhale(_incomingEthereum)
551         internal
552         returns(uint256)
553     {
554         // data setup
555         address _customerAddress = msg.sender;
556         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
557         uint256 _referralBonus = SafeMath.div(_undividedDividends, 4);           //shill this shit
558         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
559         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
560         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
561         uint256 _fee = _dividends * magnitude;
562  
563         // no point in continuing execution if OP is a poorfag russian hacker
564         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
565         // (or hackers)
566         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
567         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
568         
569         // is the user referred by a masternode?
570         if(
571             // is this a referred purchase?
572             _referredBy != 0x0000000000000000000000000000000000000000 &&
573 
574             // no cheating!
575             _referredBy != _customerAddress &&
576             
577             // does the referrer have at least X whole tokens?
578             // i.e is the referrer a godly chad masternode
579             tokenBalanceLedger_[_referredBy] >= stakingRequirement
580         ){
581             // wealth redistribution
582             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
583             
584         } else {
585             // no ref purchase
586             // Ref to the crib
587             referralBalance_[HNIC] = SafeMath.add(referralBalance_[HNIC], _referralBonus);
588             //_dividends = SafeMath.add(_dividends, _referralBonus);
589            // _fee = _dividends * magnitude;
590         }
591         
592         // we can't give people infinite ethereum
593         if(tokenSupply_ > 0){
594             
595             // add tokens to the pool
596             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
597  
598             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
599             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
600             
601             // calculate the amount of tokens the customer receives over his purchase 
602             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
603         
604         } else {
605             // add tokens to the pool
606             tokenSupply_ = _amountOfTokens;
607         }
608         
609         // update circulating supply & the ledger address for the customer
610         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
611         
612         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
613         //really i know you think you do but you don't
614         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
615         payoutsTo_[_customerAddress] += _updatedPayouts;
616         
617         // fire event
618         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
619         
620         return _amountOfTokens;
621     }
622 
623     /**
624      * Calculate Token price based on an amount of incoming ethereum
625      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
626      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
627      */
628     function ethereumToTokens_(uint256 _ethereum)
629         internal
630         view
631         returns(uint256)
632     {
633         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
634         uint256 _tokensReceived = 
635          (
636             (
637                 // underflow attempts BTFO
638                 SafeMath.sub(
639                     (sqrt
640                         (
641                             (_tokenPriceInitial**2)
642                             +
643                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
644                             +
645                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
646                             +
647                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
648                         )
649                     ), _tokenPriceInitial
650                 )
651             )/(tokenPriceIncremental_)
652         )-(tokenSupply_)
653         ;
654   
655         return _tokensReceived;
656     }
657     
658     /**
659      * Calculate token sell value.
660      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
661      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
662      */
663      function tokensToEthereum_(uint256 _tokens)
664         internal
665         view
666         returns(uint256)
667     {
668 
669         uint256 tokens_ = (_tokens + 1e18);
670         uint256 _tokenSupply = (tokenSupply_ + 1e18);
671         uint256 _etherReceived =
672         (
673             // underflow attempts BTFO
674             SafeMath.sub(
675                 (
676                     (
677                         (
678                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
679                         )-tokenPriceIncremental_
680                     )*(tokens_ - 1e18)
681                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
682             )
683         /1e18);
684         return _etherReceived;
685     }
686     
687     
688     //This is where all your gas goes, sorry
689     //Not sorry, you probably only paid 1 gwei
690     function sqrt(uint x) internal pure returns (uint y) {
691         uint z = (x + 1) / 2;
692         y = x;
693         while (z < y) {
694             y = z;
695             z = (x / z + z) / 2;
696         }
697     }
698 }
699 
700 /**
701  * @title SafeMath
702  * @dev Math operations with safety checks that throw on error
703  */
704 library SafeMath {
705 
706     /**
707     * @dev Multiplies two numbers, throws on overflow.
708     */
709     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
710         if (a == 0) {
711             return 0;
712         }
713         uint256 c = a * b;
714         assert(c / a == b);
715         return c;
716     }
717 
718     /**
719     * @dev Integer division of two numbers, truncating the quotient.
720     */
721     function div(uint256 a, uint256 b) internal pure returns (uint256) {
722         // assert(b > 0); // Solidity automatically throws when dividing by 0
723         uint256 c = a / b;
724         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
725         return c;
726     }
727 
728     /**
729     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
730     */
731     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
732         assert(b <= a);
733         return a - b;
734     }
735 
736     /**
737     * @dev Adds two numbers, throws on overflow.
738     */
739     function add(uint256 a, uint256 b) internal pure returns (uint256) {
740         uint256 c = a + b;
741         assert(c >= a);
742         return c;
743     }
744 }