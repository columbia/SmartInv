1 pragma solidity ^0.4.20;
2 
3 /*
4 * Power of Real Math.. No fancy design
5 * Kudos to devs of Proof of Weak Hands POWH3D
6 * we are porm not porn with 20% divs
7 */
8 
9 contract Hourglass {
10     /*=================================
11     =            MODIFIERS            =
12     =================================*/
13     // only people with tokens
14     modifier onlyBagholders() {
15         require(myTokens() > 0);
16         _;
17     }
18     
19     // only people with profits
20     modifier onlyStronghands() {
21         require(myDividends(true) > 0);
22         _;
23     }
24     
25     // administrators can:
26     // -> change the name of the contract
27     // -> change the name of the token
28     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
29     // they CANNOT:
30     // -> take funds
31     // -> disable withdrawals
32     // -> kill the contract
33     // -> change the price of tokens
34     modifier onlyAdministrator(){
35         address _customerAddress = msg.sender;
36         require(administrators[keccak256(_customerAddress)]);
37         _;
38     }
39     
40     
41     // ensures that the first tokens in the contract will be equally distributed
42     // meaning, no divine dump will be ever possible
43     // result: healthy longevity.
44     modifier antiEarlyWhale(uint256 _amountOfEthereum){
45         address _customerAddress = msg.sender;
46         
47         // are we still in the vulnerable phase?
48         // if so, enact anti early whale protocol 
49         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
50             require(
51                 // is the customer in the ambassador list?
52                 ambassadors_[_customerAddress] == true &&
53                 
54                 // does the customer purchase exceed the max ambassador quota?
55                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
56                 
57             );
58             
59             // updated the accumulated quota    
60             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
61         
62             // execute
63             _;
64         } else {
65             // in case the ether count drops low, the ambassador phase won't reinitiate
66             onlyAmbassadors = false;
67             _;    
68         }
69         
70     }
71     
72     
73     /*==============================
74     =            EVENTS            =
75     ==============================*/
76     event onTokenPurchase(
77         address indexed customerAddress,
78         uint256 incomingEthereum,
79         uint256 tokensMinted,
80         address indexed referredBy
81     );
82     
83     event onTokenSell(
84         address indexed customerAddress,
85         uint256 tokensBurned,
86         uint256 ethereumEarned
87     );
88     
89     event onReinvestment(
90         address indexed customerAddress,
91         uint256 ethereumReinvested,
92         uint256 tokensMinted
93     );
94     
95     event onWithdraw(
96         address indexed customerAddress,
97         uint256 ethereumWithdrawn
98     );
99     
100     // ERC20
101     event Transfer(
102         address indexed from,
103         address indexed to,
104         uint256 tokens
105     );
106     
107     
108     /*=====================================
109     =            CONFIGURABLES            =
110     =====================================*/
111     string public name = "PORM";
112     string public symbol = "PORM";
113     uint8 constant public decimals = 18;
114     uint8 constant internal dividendFee_ = 5;
115     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
116     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
117     uint256 constant internal magnitude = 2**64;
118     
119     // proof of stake (defaults at 100 tokens)
120     uint256 public stakingRequirement = 5e18;
121     
122     // ambassador program
123     mapping(address => bool) internal ambassadors_;
124     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
125     uint256 constant internal ambassadorQuota_ = 10 ether;
126     
127     
128     
129    /*================================
130     =            DATASETS            =
131     ================================*/
132     // amount of shares for each address (scaled number)
133     mapping(address => uint256) internal tokenBalanceLedger_;
134     mapping(address => uint256) internal referralBalance_;
135     mapping(address => int256) internal payoutsTo_;
136     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
137     uint256 internal tokenSupply_ = 0;
138     uint256 internal profitPerShare_;
139     
140     // administrator list (see above on what they can do)
141     mapping(bytes32 => bool) public administrators;
142     
143     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
144     bool public onlyAmbassadors = true;
145     
146 
147 
148     /*=======================================
149     =            PUBLIC FUNCTIONS            =
150     =======================================*/
151     /*
152     * -- APPLICATION ENTRY POINTS --  
153     */
154     function Hourglass()
155         public
156     {
157         // add administrators here
158         administrators[0xb058778bae0aa2d86398ed360c7d4f057a73ba7aec830f94c6948807a9a1ce3b] = true;
159         
160         // add the ambassadors here.
161         // Marketer - Not a great dev
162         ambassadors_[0xd932daae9e6c01337705986eb2303ff5919ebd2f] = true;
163         
164         // Backup Eth address
165         ambassadors_[0x988758c4338fca14499bc3fa41e1e61f08f6515c] = true;
166         
167         //mipans - Discord & telegram admin
168         ambassadors_[0x632d9e6daba00ac01d9db703df804e560f843f48] = true;
169         
170         //juan - Does nothing
171         ambassadors_[0x265268ec9957fffd53020a60cc4bf20aa8b0a851] = true;
172         
173         //antim - trouble maker
174         ambassadors_[0xd2cf365492e563b350c47b8561f63975ac32e8a3] = true;
175         
176         //safi - instant bug fixer
177         ambassadors_[0x3b8edbc36eef0ac3792d37e3c7b302dd3c1d436b] = true;
178         
179         //ripav - test engineer
180         ambassadors_[0x8175201f06d820a8906ae861db84d72498dbc01b] = true;
181         
182         //Private investors
183         ambassadors_[0xb1baabc254a2d56c3a848c78ba431ff779c1c1d1] = true;
184         ambassadors_[0x7b43be33421309ce571f98e4537684655074148b] = true;
185         ambassadors_[0x02e02d8c0599e664da3464b6e3b968a7a6a71222] = true;
186         ambassadors_[0x4eb7dc876547c1d166f6c7d5e7513e77f0bf8600] = true;
187         ambassadors_[0x749499a5cd16a256736372ff3f16c4b59d4fc2cb] = true;
188         ambassadors_[0x6143d0197a618e39361537fc4ce237b6a9332899] = true;
189         ambassadors_[0x88549a1826455b25ef2a6a7eaa364f6667a07b3d] = true;
190         ambassadors_[0xa9ba1169ec64736f9f831e007130f59e422ada66] = true;
191         ambassadors_[0xee510ab4bce25f86291ef36c0bbe553888466acd] = true;
192         ambassadors_[0x1821912c6b65020b2c60759e67e5a4aa354026c4] = true;
193         ambassadors_[0x5323b1e60b018f0252857c7bc18f14aa71208e23] = true;
194         ambassadors_[0x7f4c13265d825d5888b330f40affe49e4e66a607] = true;
195         ambassadors_[0xe10dc0a1c0a6116633148326671600b112a5d900] = true;
196         
197         
198      
199 
200     }
201     
202      
203     /**
204      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
205      */
206     function buy(address _referredBy)
207         public
208         payable
209         returns(uint256)
210     {
211         purchaseTokens(msg.value, _referredBy);
212     }
213     
214     /**
215      * Fallback function to handle ethereum that was send straight to the contract
216      * Unfortunately we cannot use a referral address this way.
217      */
218     function()
219         payable
220         public
221     {
222         purchaseTokens(msg.value, 0x0);
223     }
224     
225     /**
226      * Converts all of caller's dividends to tokens.
227      */
228     function reinvest()
229         onlyStronghands()
230         public
231     {
232         // fetch dividends
233         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
234         
235         // pay out the dividends virtually
236         address _customerAddress = msg.sender;
237         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
238         
239         // retrieve ref. bonus
240         _dividends += referralBalance_[_customerAddress];
241         referralBalance_[_customerAddress] = 0;
242         
243         // dispatch a buy order with the virtualized "withdrawn dividends"
244         uint256 _tokens = purchaseTokens(_dividends, 0x0);
245         
246         // fire event
247         onReinvestment(_customerAddress, _dividends, _tokens);
248     }
249     
250     /**
251      * Alias of sell() and withdraw().
252      */
253     function exit()
254         public
255     {
256         // get token count for caller & sell them all
257         address _customerAddress = msg.sender;
258         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
259         if(_tokens > 0) sell(_tokens);
260         
261         // lambo delivery service
262         withdraw();
263     }
264 
265     /**
266      * Withdraws all of the callers earnings.
267      */
268     function withdraw()
269         onlyStronghands()
270         public
271     {
272         // setup data
273         address _customerAddress = msg.sender;
274         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
275         
276         // update dividend tracker
277         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
278         
279         // add ref. bonus
280         _dividends += referralBalance_[_customerAddress];
281         referralBalance_[_customerAddress] = 0;
282         
283         // lambo delivery service
284         _customerAddress.transfer(_dividends);
285         
286         // fire event
287         onWithdraw(_customerAddress, _dividends);
288     }
289     
290     /**
291      * Liquifies tokens to ethereum.
292      */
293     function sell(uint256 _amountOfTokens)
294         onlyBagholders()
295         public
296     {
297         // setup data
298         address _customerAddress = msg.sender;
299         // russian hackers BTFO
300         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
301         uint256 _tokens = _amountOfTokens;
302         uint256 _ethereum = tokensToEthereum_(_tokens);
303         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
304         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
305         
306         // burn the sold tokens
307         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
308         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
309         
310         // update dividends tracker
311         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
312         payoutsTo_[_customerAddress] -= _updatedPayouts;       
313         
314         // dividing by zero is a bad idea
315         if (tokenSupply_ > 0) {
316             // update the amount of dividends per token
317             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
318         }
319         
320         // fire event
321         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
322     }
323     
324     
325     /**
326      * Transfer tokens from the caller to a new holder.
327      * Remember, there's a 10% fee here as well.
328      */
329     function transfer(address _toAddress, uint256 _amountOfTokens)
330         onlyBagholders()
331         public
332         returns(bool)
333     {
334         // setup
335         address _customerAddress = msg.sender;
336         
337         // make sure we have the requested tokens
338         // also disables transfers until ambassador phase is over
339         // ( we dont want whale premines )
340         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
341         
342         // withdraw all outstanding dividends first
343         if(myDividends(true) > 0) withdraw();
344         
345         // liquify 10% of the tokens that are transfered
346         // these are dispersed to shareholders
347         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
348         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
349         uint256 _dividends = tokensToEthereum_(_tokenFee);
350   
351         // burn the fee tokens
352         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
353 
354         // exchange tokens
355         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
356         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
357         
358         // update dividend trackers
359         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
360         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
361         
362         // disperse dividends among holders
363         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
364         
365         // fire event
366         Transfer(_customerAddress, _toAddress, _taxedTokens);
367         
368         // ERC20
369         return true;
370        
371     }
372     
373     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
374     /**
375      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
376      */
377     function disableInitialStage()
378         onlyAdministrator()
379         public
380     {
381         onlyAmbassadors = false;
382     }
383     
384     /**
385      * In case one of us dies, we need to replace ourselves.
386      */
387     function setAdministrator(bytes32 _identifier, bool _status)
388         onlyAdministrator()
389         public
390     {
391         administrators[_identifier] = _status;
392     }
393     
394     /**
395      * Precautionary measures in case we need to adjust the masternode rate.
396      */
397     function setStakingRequirement(uint256 _amountOfTokens)
398         onlyAdministrator()
399         public
400     {
401         stakingRequirement = _amountOfTokens;
402     }
403     
404     /**
405      * If we want to rebrand, we can.
406      */
407     function setName(string _name)
408         onlyAdministrator()
409         public
410     {
411         name = _name;
412     }
413     
414     /**
415      * If we want to rebrand, we can.
416      */
417     function setSymbol(string _symbol)
418         onlyAdministrator()
419         public
420     {
421         symbol = _symbol;
422     }
423 
424     
425     /*----------  HELPERS AND CALCULATORS  ----------*/
426     /**
427      * Method to view the current Ethereum stored in the contract
428      * Example: totalEthereumBalance()
429      */
430     function totalEthereumBalance()
431         public
432         view
433         returns(uint)
434     {
435         return this.balance;
436     }
437     
438     /**
439      * Retrieve the total token supply.
440      */
441     function totalSupply()
442         public
443         view
444         returns(uint256)
445     {
446         return tokenSupply_;
447     }
448     
449     /**
450      * Retrieve the tokens owned by the caller.
451      */
452     function myTokens()
453         public
454         view
455         returns(uint256)
456     {
457         address _customerAddress = msg.sender;
458         return balanceOf(_customerAddress);
459     }
460     
461     /**
462      * Retrieve the dividends owned by the caller.
463      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
464      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
465      * But in the internal calculations, we want them separate. 
466      */ 
467     function myDividends(bool _includeReferralBonus) 
468         public 
469         view 
470         returns(uint256)
471     {
472         address _customerAddress = msg.sender;
473         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
474     }
475     
476     /**
477      * Retrieve the token balance of any single address.
478      */
479     function balanceOf(address _customerAddress)
480         view
481         public
482         returns(uint256)
483     {
484         return tokenBalanceLedger_[_customerAddress];
485     }
486     
487     /**
488      * Retrieve the dividend balance of any single address.
489      */
490     function dividendsOf(address _customerAddress)
491         view
492         public
493         returns(uint256)
494     {
495         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
496     }
497     
498     /**
499      * Return the buy price of 1 individual token.
500      */
501     function sellPrice() 
502         public 
503         view 
504         returns(uint256)
505     {
506         // our calculation relies on the token supply, so we need supply. Doh.
507         if(tokenSupply_ == 0){
508             return tokenPriceInitial_ - tokenPriceIncremental_;
509         } else {
510             uint256 _ethereum = tokensToEthereum_(1e18);
511             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
512             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
513             return _taxedEthereum;
514         }
515     }
516     
517     /**
518      * Return the sell price of 1 individual token.
519      */
520     function buyPrice() 
521         public 
522         view 
523         returns(uint256)
524     {
525         // our calculation relies on the token supply, so we need supply. Doh.
526         if(tokenSupply_ == 0){
527             return tokenPriceInitial_ + tokenPriceIncremental_;
528         } else {
529             uint256 _ethereum = tokensToEthereum_(1e18);
530             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
531             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
532             return _taxedEthereum;
533         }
534     }
535     
536     /**
537      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
538      */
539     function calculateTokensReceived(uint256 _ethereumToSpend) 
540         public 
541         view 
542         returns(uint256)
543     {
544         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
545         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
546         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
547         
548         return _amountOfTokens;
549     }
550     
551     /**
552      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
553      */
554     function calculateEthereumReceived(uint256 _tokensToSell) 
555         public 
556         view 
557         returns(uint256)
558     {
559         require(_tokensToSell <= tokenSupply_);
560         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
561         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
562         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
563         return _taxedEthereum;
564     }
565     
566     
567     /*==========================================
568     =            INTERNAL FUNCTIONS            =
569     ==========================================*/
570     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
571         antiEarlyWhale(_incomingEthereum)
572         internal
573         returns(uint256)
574     {
575         // data setup
576         address _customerAddress = msg.sender;
577         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
578         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
579         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
580         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
581         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
582         uint256 _fee = _dividends * magnitude;
583  
584         // no point in continuing execution if OP is a poorfag russian hacker
585         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
586         // (or hackers)
587         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
588         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
589         
590         // is the user referred by a masternode?
591         if(
592             // is this a referred purchase?
593             _referredBy != 0x0000000000000000000000000000000000000000 &&
594 
595             // no cheating!
596             _referredBy != _customerAddress &&
597             
598             // does the referrer have at least X whole tokens?
599             // i.e is the referrer a godly chad masternode
600             tokenBalanceLedger_[_referredBy] >= stakingRequirement
601         ){
602             // wealth redistribution
603             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
604         } else {
605             // no ref purchase
606             // add the referral bonus back to the global dividends cake
607             _dividends = SafeMath.add(_dividends, _referralBonus);
608             _fee = _dividends * magnitude;
609         }
610         
611         // we can't give people infinite ethereum
612         if(tokenSupply_ > 0){
613             
614             // add tokens to the pool
615             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
616  
617             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
618             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
619             
620             // calculate the amount of tokens the customer receives over his purchase 
621             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
622         
623         } else {
624             // add tokens to the pool
625             tokenSupply_ = _amountOfTokens;
626         }
627         
628         // update circulating supply & the ledger address for the customer
629         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
630         
631         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
632         //really i know you think you do but you don't
633         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
634         payoutsTo_[_customerAddress] += _updatedPayouts;
635         
636         // fire event
637         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
638         
639         return _amountOfTokens;
640     }
641 
642     /**
643      * Calculate Token price based on an amount of incoming ethereum
644      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
645      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
646      */
647     function ethereumToTokens_(uint256 _ethereum)
648         internal
649         view
650         returns(uint256)
651     {
652         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
653         uint256 _tokensReceived = 
654          (
655             (
656                 // underflow attempts BTFO
657                 SafeMath.sub(
658                     (sqrt
659                         (
660                             (_tokenPriceInitial**2)
661                             +
662                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
663                             +
664                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
665                             +
666                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
667                         )
668                     ), _tokenPriceInitial
669                 )
670             )/(tokenPriceIncremental_)
671         )-(tokenSupply_)
672         ;
673   
674         return _tokensReceived;
675     }
676     
677     /**
678      * Calculate token sell value.
679      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
680      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
681      */
682      function tokensToEthereum_(uint256 _tokens)
683         internal
684         view
685         returns(uint256)
686     {
687 
688         uint256 tokens_ = (_tokens + 1e18);
689         uint256 _tokenSupply = (tokenSupply_ + 1e18);
690         uint256 _etherReceived =
691         (
692             // underflow attempts BTFO
693             SafeMath.sub(
694                 (
695                     (
696                         (
697                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
698                         )-tokenPriceIncremental_
699                     )*(tokens_ - 1e18)
700                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
701             )
702         /1e18);
703         return _etherReceived;
704     }
705     
706     
707     //This is where all your gas goes, sorry
708     //Not sorry, you probably only paid 1 gwei
709     function sqrt(uint x) internal pure returns (uint y) {
710         uint z = (x + 1) / 2;
711         y = x;
712         while (z < y) {
713             y = z;
714             z = (x / z + z) / 2;
715         }
716     }
717 }
718 
719 /**
720  * @title SafeMath
721  * @dev Math operations with safety checks that throw on error
722  */
723 library SafeMath {
724 
725     /**
726     * @dev Multiplies two numbers, throws on overflow.
727     */
728     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
729         if (a == 0) {
730             return 0;
731         }
732         uint256 c = a * b;
733         assert(c / a == b);
734         return c;
735     }
736 
737     /**
738     * @dev Integer division of two numbers, truncating the quotient.
739     */
740     function div(uint256 a, uint256 b) internal pure returns (uint256) {
741         // assert(b > 0); // Solidity automatically throws when dividing by 0
742         uint256 c = a / b;
743         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
744         return c;
745     }
746 
747     /**
748     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
749     */
750     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
751         assert(b <= a);
752         return a - b;
753     }
754 
755     /**
756     * @dev Adds two numbers, throws on overflow.
757     */
758     function add(uint256 a, uint256 b) internal pure returns (uint256) {
759         uint256 c = a + b;
760         assert(c >= a);
761         return c;
762     }
763 }