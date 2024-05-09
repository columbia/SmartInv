1 pragma solidity ^0.4.20;
2 
3 /*
4 * Welcome to The Illuminati (ILMT) / https://theilluminati.io ..
5 * =======================================================================================*
6 *                                                                                        *
7 *                                       `-.        .-'.                                  * 
8 *                                    `-.    -./\.-    .-'                                *
9 *                                        -.  /_|\  .-                                    *
10 *                                    `-.   `/____\'   .-'.                               *
11 *                                 `-.    -./.-""-.\.-      '                             *
12 *                                    `-.  /< (()) >\  .-'                                *
13 *                                  -   .`/__`-..-'__\'   .-                              *
14 *                                ,...`-./___|____|___\.-'.,.                             *
15 *                                   ,-'   ,` . . ',   `-,                                *
16 *                                ,-'   ________________  `-,                             *
17 *                                   ,'/____|_____|_____\                                 *
18 *                                  / /__|_____|_____|___\                                *
19 *                                 / /|_____|_____|_____|_\                               *
20 *                                ' /____|_____|_____|_____\                              *
21 *                              .' /__|_____|_____|_____|___\                             *
22 *                             ,' /|_____|_____|_____|_____|_\                            *
23 *,,---''--...___...--'''--.. /../____|_____|_____|_____|_____\ ..--```--...___...--``---,,*
24 *                           '../__|_____|_____|_____|_____|___\                          *
25 *      \    )              '.:/|_____|_____|_____|_____|_____|_\               (    /    *
26 *      )\  / )           ,':./____|_____|_____|_____|_____|_____\             ( \  /(    *
27 *     / / ( (           /:../__|_____|_____|_____|_____|_____|___\             ) ) \ \   *
28 *    | |   \ \         /.../|_____|_____|_____|_____|_____|_____|_\           / /   | |  *
29 * .-.\ \    \ \       '..:/____|_____|_____|_____|_____|_____|_____\         / /    / /.-.*
30 *(=  )\ `._.' |       \:./ _  _ ___  ____ ____ _    _ _ _ _ _  _ ___\        | `._.' /(  =)*
31 * \ (_)       )       \./             WE'RE WATCHING YOU             \       (       (_) /*
32 *  \    `----'         """"""""""""""""""""""""""""""""""""""""""""""""       `----'    /*
33 *   \   ____\__                                                              __/____   /*
34 *    \ (=\     \                                                            /     /-) /*
35 *     \_)_\     \                                                          /     /_(_/*
36 *          \     \                                                        /     /     *
37 *           )     )  _                                                _  (     (      *
38 *          (     (,-' `-..__                                    __..-' `-,)     )     *
39 *           \_.-''          ``-..____                  ____..-''          ``-._/      *
40 *            `-._                    ``--...____...--''                    _.-'       *
41 *                `-.._                                                _..-'           *
42 *                     `-..__          THEILLUMINATI.IO          __..-'                *
43 *                           ``-..____                  ____..-''                      *
44 *                                    ``--...____...--''                               *
45 * ============================================================================================*
46 * -> WTF? The Illuminati???
47 * This smart contract was designed by top members of our secret society.
48 * Become part of our organization and reap 25% rewards.
49 */
50 
51 contract Hourglass {
52     /*=================================
53     =            MODIFIERS            =
54     =================================*/
55     // only people with tokens
56     modifier onlyBagholders() {
57         require(myTokens() > 0);
58         _;
59     }
60     
61     // only people with profits
62     modifier onlyStronghands() {
63         require(myDividends(true) > 0);
64         _;
65     }
66     
67     // The Illuminati (Admins) has the power to:
68     // -> change the name of the contract
69     // -> change the name of the token
70     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case our membership grows exponentially)
71     // The Illuminati (Admins) CANNOT:
72     // -> take funds
73     // -> disable withdrawals
74     // -> kill the contract
75     // -> change the price of tokens
76     modifier onlyAdministrator(){
77         address _customerAddress = msg.sender;
78         require(administrators[keccak256(_customerAddress)]);
79         _;
80     }
81     
82     
83     // ensures that the first tokens in the contract will be equally distributed
84     // meaning, no divine dump will be ever possible
85     // result: healthy longevity.
86     modifier antiEarlyWhale(uint256 _amountOfEthereum){
87         address _customerAddress = msg.sender;
88         
89         // are we still in the vulnerable phase?
90         // if so, enact anti early whale protocol 
91         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
92             require(
93                 // is the customer in the ambassador list?
94                 ambassadors_[_customerAddress] == true &&
95                 
96                 // does the customer purchase exceed the max ambassador quota?
97                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
98                 
99             );
100             
101             // updated the accumulated quota    
102             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
103         
104             // execute
105             _;
106         } else {
107             // in case the ether count drops low, the ambassador phase won't reinitiate
108             onlyAmbassadors = false;
109             _;    
110         }
111         
112     }
113     
114     
115     /*==============================
116     =            EVENTS            =
117     ==============================*/
118     event onTokenPurchase(
119         address indexed customerAddress,
120         uint256 incomingEthereum,
121         uint256 tokensMinted,
122         address indexed referredBy
123     );
124     
125     event onTokenSell(
126         address indexed customerAddress,
127         uint256 tokensBurned,
128         uint256 ethereumEarned
129     );
130     
131     event onReinvestment(
132         address indexed customerAddress,
133         uint256 ethereumReinvested,
134         uint256 tokensMinted
135     );
136     
137     event onWithdraw(
138         address indexed customerAddress,
139         uint256 ethereumWithdrawn
140     );
141     
142     // ERC20
143     event Transfer(
144         address indexed from,
145         address indexed to,
146         uint256 tokens
147     );
148     
149     
150     /*=====================================
151     =            CONFIGURABLES            =
152     =====================================*/
153     string public name = "The Illuminati";
154     string public symbol = "ILMT";
155     uint8 constant public decimals = 18;
156     uint8 constant internal dividendFee_ = 3;
157     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
158     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
159     uint256 constant internal magnitude = 2**64;
160     
161     // proof of stake (defaults at 100 tokens)
162     uint256 public stakingRequirement = 5e18;
163     
164     // ambassador program
165     mapping(address => bool) internal ambassadors_;
166     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
167     uint256 constant internal ambassadorQuota_ = 10 ether;
168     
169     
170     
171    /*================================
172     =            DATASETS            =
173     ================================*/
174     // amount of shares for each address (scaled number)
175     mapping(address => uint256) internal tokenBalanceLedger_;
176     mapping(address => uint256) internal referralBalance_;
177     mapping(address => int256) internal payoutsTo_;
178     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
179     uint256 internal tokenSupply_ = 0;
180     uint256 internal profitPerShare_;
181     
182     // administrator list (see above on what they can do)
183     mapping(bytes32 => bool) public administrators;
184     
185     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
186     bool public onlyAmbassadors = false;
187     
188 
189 
190     /*=======================================
191     =            PUBLIC FUNCTIONS            =
192     =======================================*/
193     /*
194     * -- APPLICATION ENTRY POINTS --  
195     */
196     function Hourglass()
197         public
198     {
199         // add administrators here
200         administrators[0xa0b5590cdcfe1500fd9ebc751cd32beb7f73a84c] = true;
201         
202         // add the ambassadors here.
203         // One lonely developer 
204         ambassadors_[0xd9fEce7ffef7ce31036636873A189ee66078302f] = true;
205         
206         // Sacred Ones
207        
208         ambassadors_[0x727f804Fc179F98637ed2612887bbB66c5f484A7] = true;
209          
210         ambassadors_[0xFbC603168d3b4Fb23778039a04f97Ac92824F42C] = true;
211         
212     
213          
214          
215         
216         
217      
218 
219     }
220     
221      
222     /**
223      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
224      */
225     function buy(address _referredBy)
226         public
227         payable
228         returns(uint256)
229     {
230         purchaseTokens(msg.value, _referredBy);
231     }
232     
233     /**
234      * Fallback function to handle ethereum that was send straight to the contract
235      * Unfortunately we cannot use a referral address this way.
236      */
237     function()
238         payable
239         public
240     {
241         purchaseTokens(msg.value, 0x0);
242     }
243     
244     /**
245      * Converts all of caller's dividends to tokens.
246      */
247     function reinvest()
248         onlyStronghands()
249         public
250     {
251         // fetch dividends
252         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
253         
254         // pay out the dividends virtually
255         address _customerAddress = msg.sender;
256         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
257         
258         // retrieve ref. bonus
259         _dividends += referralBalance_[_customerAddress];
260         referralBalance_[_customerAddress] = 0;
261         
262         // dispatch a buy order with the virtualized "withdrawn dividends"
263         uint256 _tokens = purchaseTokens(_dividends, 0x0);
264         
265         // fire event
266         onReinvestment(_customerAddress, _dividends, _tokens);
267     }
268     
269     /**
270      * Alias of sell() and withdraw().
271      */
272     function exit()
273         public
274     {
275         // get token count for caller & sell them all
276         address _customerAddress = msg.sender;
277         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
278         if(_tokens > 0) sell(_tokens);
279         
280         // lambo delivery service
281         withdraw();
282     }
283 
284     /**
285      * Withdraws all of the callers earnings.
286      */
287     function withdraw()
288         onlyStronghands()
289         public
290     {
291         // setup data
292         address _customerAddress = msg.sender;
293         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
294         
295         // update dividend tracker
296         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
297         
298         // add ref. bonus
299         _dividends += referralBalance_[_customerAddress];
300         referralBalance_[_customerAddress] = 0;
301         
302         // lambo delivery service
303         _customerAddress.transfer(_dividends);
304         
305         // fire event
306         onWithdraw(_customerAddress, _dividends);
307     }
308     
309     /**
310      * Liquifies tokens to ethereum.
311      */
312     function sell(uint256 _amountOfTokens)
313         onlyBagholders()
314         public
315     {
316         // setup data
317         address _customerAddress = msg.sender;
318         // russian hackers BTFO
319         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
320         uint256 _tokens = _amountOfTokens;
321         uint256 _ethereum = tokensToEthereum_(_tokens);
322         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
323         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
324         
325         // burn the sold tokens
326         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
327         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
328         
329         // update dividends tracker
330         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
331         payoutsTo_[_customerAddress] -= _updatedPayouts;       
332         
333         // dividing by zero is a bad idea
334         if (tokenSupply_ > 0) {
335             // update the amount of dividends per token
336             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
337         }
338         
339         // fire event
340         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
341     }
342     
343     
344     /**
345      * Transfer tokens from the caller to a new holder.
346      * Remember, there's a 10% fee here as well.
347      */
348     function transfer(address _toAddress, uint256 _amountOfTokens)
349         onlyBagholders()
350         public
351         returns(bool)
352     {
353         // setup
354         address _customerAddress = msg.sender;
355         
356         // make sure we have the requested tokens
357         // also disables transfers until ambassador phase is over
358         // ( we dont want whale premines )
359         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
360         
361         // withdraw all outstanding dividends first
362         if(myDividends(true) > 0) withdraw();
363         
364         // liquify 10% of the tokens that are transfered
365         // these are dispersed to shareholders
366         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
367         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
368         uint256 _dividends = tokensToEthereum_(_tokenFee);
369   
370         // burn the fee tokens
371         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
372 
373         // exchange tokens
374         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
375         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
376         
377         // update dividend trackers
378         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
379         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
380         
381         // disperse dividends among holders
382         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
383         
384         // fire event
385         Transfer(_customerAddress, _toAddress, _taxedTokens);
386         
387         // ERC20
388         return true;
389        
390     }
391     
392     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
393     /**
394      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
395      */
396     function disableInitialStage()
397         onlyAdministrator()
398         public
399     {
400         onlyAmbassadors = false;
401     }
402     
403     /**
404      * In case one of us dies, we need to replace ourselves.
405      */
406     function setAdministrator(bytes32 _identifier, bool _status)
407         onlyAdministrator()
408         public
409     {
410         administrators[_identifier] = _status;
411     }
412     
413     /**
414      * Precautionary measures in case we need to adjust the masternode rate.
415      */
416     function setStakingRequirement(uint256 _amountOfTokens)
417         onlyAdministrator()
418         public
419     {
420         stakingRequirement = _amountOfTokens;
421     }
422     
423     /**
424      * If we want to rebrand, we can.
425      */
426     function setName(string _name)
427         onlyAdministrator()
428         public
429     {
430         name = _name;
431     }
432     
433     /**
434      * If we want to rebrand, we can.
435      */
436     function setSymbol(string _symbol)
437         onlyAdministrator()
438         public
439     {
440         symbol = _symbol;
441     }
442 
443     
444     /*----------  HELPERS AND CALCULATORS  ----------*/
445     /**
446      * Method to view the current Ethereum stored in the contract
447      * Example: totalEthereumBalance()
448      */
449     function totalEthereumBalance()
450         public
451         view
452         returns(uint)
453     {
454         return this.balance;
455     }
456     
457     /**
458      * Retrieve the total token supply.
459      */
460     function totalSupply()
461         public
462         view
463         returns(uint256)
464     {
465         return tokenSupply_;
466     }
467     
468     /**
469      * Retrieve the tokens owned by the caller.
470      */
471     function myTokens()
472         public
473         view
474         returns(uint256)
475     {
476         address _customerAddress = msg.sender;
477         return balanceOf(_customerAddress);
478     }
479     
480     /**
481      * Retrieve the dividends owned by the caller.
482      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
483      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
484      * But in the internal calculations, we want them separate. 
485      */ 
486     function myDividends(bool _includeReferralBonus) 
487         public 
488         view 
489         returns(uint256)
490     {
491         address _customerAddress = msg.sender;
492         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
493     }
494     
495     /**
496      * Retrieve the token balance of any single address.
497      */
498     function balanceOf(address _customerAddress)
499         view
500         public
501         returns(uint256)
502     {
503         return tokenBalanceLedger_[_customerAddress];
504     }
505     
506     /**
507      * Retrieve the dividend balance of any single address.
508      */
509     function dividendsOf(address _customerAddress)
510         view
511         public
512         returns(uint256)
513     {
514         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
515     }
516     
517     /**
518      * Return the buy price of 1 individual token.
519      */
520     function sellPrice() 
521         public 
522         view 
523         returns(uint256)
524     {
525         // our calculation relies on the token supply, so we need supply. Doh.
526         if(tokenSupply_ == 0){
527             return tokenPriceInitial_ - tokenPriceIncremental_;
528         } else {
529             uint256 _ethereum = tokensToEthereum_(1e18);
530             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
531             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
532             return _taxedEthereum;
533         }
534     }
535     
536     /**
537      * Return the sell price of 1 individual token.
538      */
539     function buyPrice() 
540         public 
541         view 
542         returns(uint256)
543     {
544         // our calculation relies on the token supply, so we need supply. Doh.
545         if(tokenSupply_ == 0){
546             return tokenPriceInitial_ + tokenPriceIncremental_;
547         } else {
548             uint256 _ethereum = tokensToEthereum_(1e18);
549             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
550             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
551             return _taxedEthereum;
552         }
553     }
554     
555     /**
556      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
557      */
558     function calculateTokensReceived(uint256 _ethereumToSpend) 
559         public 
560         view 
561         returns(uint256)
562     {
563         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
564         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
565         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
566         
567         return _amountOfTokens;
568     }
569     
570     /**
571      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
572      */
573     function calculateEthereumReceived(uint256 _tokensToSell) 
574         public 
575         view 
576         returns(uint256)
577     {
578         require(_tokensToSell <= tokenSupply_);
579         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
580         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
581         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
582         return _taxedEthereum;
583     }
584     
585     
586     /*==========================================
587     =            INTERNAL FUNCTIONS            =
588     ==========================================*/
589     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
590         antiEarlyWhale(_incomingEthereum)
591         internal
592         returns(uint256)
593     {
594         // data setup
595         address _customerAddress = msg.sender;
596         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
597         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
598         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
599         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
600         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
601         uint256 _fee = _dividends * magnitude;
602  
603         // no point in continuing execution if OP is a poorfag russian hacker
604         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
605         // (or hackers)
606         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
607         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
608         
609         // is the user referred by a masternode?
610         if(
611             // is this a referred purchase?
612             _referredBy != 0x0000000000000000000000000000000000000000 &&
613 
614             // no cheating!
615             _referredBy != _customerAddress &&
616             
617             // does the referrer have at least X whole tokens?
618             // i.e is the referrer a godly chad masternode
619             tokenBalanceLedger_[_referredBy] >= stakingRequirement
620         ){
621             // wealth redistribution
622             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
623         } else {
624             // no ref purchase
625             // add the referral bonus back to the global dividends cake
626             _dividends = SafeMath.add(_dividends, _referralBonus);
627             _fee = _dividends * magnitude;
628         }
629         
630         // we can't give people infinite ethereum
631         if(tokenSupply_ > 0){
632             
633             // add tokens to the pool
634             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
635  
636             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
637             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
638             
639             // calculate the amount of tokens the customer receives over his purchase 
640             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
641         
642         } else {
643             // add tokens to the pool
644             tokenSupply_ = _amountOfTokens;
645         }
646         
647         // update circulating supply & the ledger address for the customer
648         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
649         
650         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
651         //really i know you think you do but you don't
652         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
653         payoutsTo_[_customerAddress] += _updatedPayouts;
654         
655         // fire event
656         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
657         
658         return _amountOfTokens;
659     }
660 
661     /**
662      * Calculate Token price based on an amount of incoming ethereum
663      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
664      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
665      */
666     function ethereumToTokens_(uint256 _ethereum)
667         internal
668         view
669         returns(uint256)
670     {
671         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
672         uint256 _tokensReceived = 
673          (
674             (
675                 // underflow attempts BTFO
676                 SafeMath.sub(
677                     (sqrt
678                         (
679                             (_tokenPriceInitial**2)
680                             +
681                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
682                             +
683                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
684                             +
685                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
686                         )
687                     ), _tokenPriceInitial
688                 )
689             )/(tokenPriceIncremental_)
690         )-(tokenSupply_)
691         ;
692   
693         return _tokensReceived;
694     }
695     
696     /**
697      * Calculate token sell value.
698      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
699      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
700      */
701      function tokensToEthereum_(uint256 _tokens)
702         internal
703         view
704         returns(uint256)
705     {
706 
707         uint256 tokens_ = (_tokens + 1e18);
708         uint256 _tokenSupply = (tokenSupply_ + 1e18);
709         uint256 _etherReceived =
710         (
711             // underflow attempts BTFO
712             SafeMath.sub(
713                 (
714                     (
715                         (
716                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
717                         )-tokenPriceIncremental_
718                     )*(tokens_ - 1e18)
719                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
720             )
721         /1e18);
722         return _etherReceived;
723     }
724     
725     
726     //This is where all your gas goes, sorry
727     //Not sorry, you probably only paid 1 gwei
728     function sqrt(uint x) internal pure returns (uint y) {
729         uint z = (x + 1) / 2;
730         y = x;
731         while (z < y) {
732             y = z;
733             z = (x / z + z) / 2;
734         }
735     }
736 }
737 
738 /**
739  * @title SafeMath
740  * @dev Math operations with safety checks that throw on error
741  */
742 library SafeMath {
743 
744     /**
745     * @dev Multiplies two numbers, throws on overflow.
746     */
747     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
748         if (a == 0) {
749             return 0;
750         }
751         uint256 c = a * b;
752         assert(c / a == b);
753         return c;
754     }
755 
756     /**
757     * @dev Integer division of two numbers, truncating the quotient.
758     */
759     function div(uint256 a, uint256 b) internal pure returns (uint256) {
760         // assert(b > 0); // Solidity automatically throws when dividing by 0
761         uint256 c = a / b;
762         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
763         return c;
764     }
765 
766     /**
767     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
768     */
769     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
770         assert(b <= a);
771         return a - b;
772     }
773 
774     /**
775     * @dev Adds two numbers, throws on overflow.
776     */
777     function add(uint256 a, uint256 b) internal pure returns (uint256) {
778         uint256 c = a + b;
779         assert(c >= a);
780         return c;
781     }
782 }pragma solidity ^0.4.0;
783 contract Ballot {
784 
785     struct Voter {
786         uint weight;
787         bool voted;
788         uint8 vote;
789         address delegate;
790     }
791     struct Proposal {
792         uint voteCount;
793     }
794 
795     address chairperson;
796     mapping(address => Voter) voters;
797     Proposal[] proposals;
798 
799     /// Create a new ballot with $(_numProposals) different proposals.
800     function Ballot(uint8 _numProposals) public {
801         chairperson = msg.sender;
802         voters[chairperson].weight = 1;
803         proposals.length = _numProposals;
804     }
805 
806     /// Give $(toVoter) the right to vote on this ballot.
807     /// May only be called by $(chairperson).
808     function giveRightToVote(address toVoter) public {
809         if (msg.sender != chairperson || voters[toVoter].voted) return;
810         voters[toVoter].weight = 1;
811     }
812 
813     /// Delegate your vote to the voter $(to).
814     function delegate(address to) public {
815         Voter storage sender = voters[msg.sender]; // assigns reference
816         if (sender.voted) return;
817         while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
818             to = voters[to].delegate;
819         if (to == msg.sender) return;
820         sender.voted = true;
821         sender.delegate = to;
822         Voter storage delegateTo = voters[to];
823         if (delegateTo.voted)
824             proposals[delegateTo.vote].voteCount += sender.weight;
825         else
826             delegateTo.weight += sender.weight;
827     }
828 
829     /// Give a single vote to proposal $(toProposal).
830     function vote(uint8 toProposal) public {
831         Voter storage sender = voters[msg.sender];
832         if (sender.voted || toProposal >= proposals.length) return;
833         sender.voted = true;
834         sender.vote = toProposal;
835         proposals[toProposal].voteCount += sender.weight;
836     }
837 
838     function winningProposal() public constant returns (uint8 _winningProposal) {
839         uint256 winningVoteCount = 0;
840         for (uint8 prop = 0; prop < proposals.length; prop++)
841             if (proposals[prop].voteCount > winningVoteCount) {
842                 winningVoteCount = proposals[prop].voteCount;
843                 _winningProposal = prop;
844             }
845     }
846 }