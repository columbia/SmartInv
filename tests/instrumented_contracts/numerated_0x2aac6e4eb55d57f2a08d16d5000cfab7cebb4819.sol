1 pragma solidity ^0.4.20;
2 
3 // shit
4 
5 contract SHIT {
6     /*=================================
7     =            MODIFIERS            =
8     =================================*/
9     // only people with tokens
10     modifier onlyBagholders() {
11         require(myTokens() > 0);
12         _;
13     }
14     
15     // only people with profits
16     modifier onlyStronghands() {
17         require(myDividends(true) > 0);
18         _;
19     }
20     
21     // administrators can:
22     // -> change the name of the contract
23     // -> change the name of the token
24     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
25     // they CANNOT:
26     // -> take funds
27     // -> disable withdrawals
28     // -> kill the contract
29     // -> change the price of tokens
30     modifier onlyAdministrator(){
31         address _customerAddress = msg.sender;
32         require(administrators[_customerAddress]);
33         _;
34     }
35     
36     
37     // ensures that the first tokens in the contract will be equally distributed
38     // meaning, no divine dump will be ever possible
39     // result: healthy longevity.
40     modifier antiEarlyWhale(uint256 _amountOfEthereum){
41         address _customerAddress = msg.sender;
42         
43         // are we still in the vulnerable phase?
44         // if so, enact anti early whale protocol 
45         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
46             require(
47                 // is the customer in the ambassador list?
48                 ambassadors_[_customerAddress] == true &&
49                 
50                 // does the customer purchase exceed the max ambassador quota?
51                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
52                 
53             );
54             
55             // updated the accumulated quota    
56             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
57         
58             // execute
59             _;
60         } else {
61             // in case the ether count drops low, the ambassador phase won't reinitiate
62             onlyAmbassadors = false;
63             _;    
64         }
65         
66     }
67     
68     
69     /*==============================
70     =            EVENTS            =
71     ==============================*/
72     event onTokenPurchase(
73         address indexed customerAddress,
74         uint256 incomingEthereum,
75         uint256 tokensMinted,
76         address indexed referredBy
77     );
78     
79     event onTokenSell(
80         address indexed customerAddress,
81         uint256 tokensBurned,
82         uint256 ethereumEarned
83     );
84     
85     event onReinvestment(
86         address indexed customerAddress,
87         uint256 ethereumReinvested,
88         uint256 tokensMinted
89     );
90     
91     event onWithdraw(
92         address indexed customerAddress,
93         uint256 ethereumWithdrawn
94     );
95     
96     // ERC20
97     event Transfer(
98         address indexed from,
99         address indexed to,
100         uint256 tokens
101     );
102     
103     
104     /*=====================================
105     =            CONFIGURABLES            =
106     =====================================*/
107     string public name = "SHIT";
108     string public symbol = "SHIT";
109     uint8 constant public decimals = 18;
110     uint8 constant internal dividendFee_ = 5; 
111     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
112     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
113     uint256 constant internal magnitude = 2**64;
114     
115     // proof of stake (defaults at 100 tokens)
116     uint256 public stakingRequirement = 100e18;
117     
118     // ambassador program
119     mapping(address => bool) internal ambassadors_;
120     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
121     uint256 constant internal ambassadorQuota_ = 20 ether;
122     
123     
124     
125    /*================================
126     =            DATASETS            =
127     ================================*/
128     // amount of shares for each address (scaled number)
129     mapping(address => uint256) internal tokenBalanceLedger_;
130     mapping(address => uint256) internal referralBalance_;
131     mapping(address => int256) internal payoutsTo_;
132     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
133     uint256 internal tokenSupply_ = 0;
134     uint256 internal profitPerShare_;
135     
136     // administrator list (see above on what they can do)
137     mapping(address => bool) public administrators;
138     
139     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
140     bool public onlyAmbassadors = false;
141     
142 
143 
144     /*=======================================
145     =            PUBLIC FUNCTIONS            =
146     =======================================*/
147     /*
148     * -- APPLICATION ENTRY POINTS --  
149     */
150     function SHIT()
151         public
152     {
153         // add administrators here
154 
155         administrators[msg.sender] = true;
156 
157 
158         
159 
160     }
161     
162      
163     /**
164      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
165      */
166     function buy(address _referredBy)
167         public
168         payable
169         returns(uint256)
170     {
171         purchaseTokens(msg.value, _referredBy);
172     }
173     
174     /**
175      * Fallback function to handle ethereum that was send straight to the contract
176      * Unfortunately we cannot use a referral address this way.
177      */
178     function()
179         payable
180         public
181     {
182         purchaseTokens(msg.value, 0x0);
183     }
184     
185     /**
186      * Converts all of caller's dividends to tokens.
187     */
188     function reinvest()
189         onlyStronghands()
190         public
191     {
192         // fetch dividends
193         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
194         
195         // pay out the dividends virtually
196         address _customerAddress = msg.sender;
197         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
198         
199         // retrieve ref. bonus
200         _dividends += referralBalance_[_customerAddress];
201         referralBalance_[_customerAddress] = 0;
202         
203         // dispatch a buy order with the virtualized "withdrawn dividends"
204         uint256 _tokens = purchaseTokens(_dividends, 0x0);
205         
206         // fire event
207         onReinvestment(_customerAddress, _dividends, _tokens);
208     }
209     
210     /**
211      * Alias of sell() and withdraw().
212      */
213     function exit()
214         public
215     {
216         // get token count for caller & sell them all
217         address _customerAddress = msg.sender;
218         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
219         if(_tokens > 0) sell(_tokens);
220         
221         // lambo delivery service
222         withdraw();
223     }
224 
225     /**
226      * Withdraws all of the callers earnings.
227      */
228     function withdraw()
229         onlyStronghands()
230         public
231     {
232         // setup data
233         address _customerAddress = msg.sender;
234         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
235         
236         // update dividend tracker
237         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
238         
239         // add ref. bonus
240         _dividends += referralBalance_[_customerAddress];
241         referralBalance_[_customerAddress] = 0;
242         
243         // lambo delivery service
244         _customerAddress.transfer(_dividends);
245         
246         // fire event
247         onWithdraw(_customerAddress, _dividends);
248     }
249     
250     /**
251      * Liquifies tokens to ethereum.
252      */
253     function sell(uint256 _amountOfTokens)
254         onlyBagholders()
255         public
256     {
257         // setup data
258         address _customerAddress = msg.sender;
259         // russian hackers BTFO
260         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
261         uint256 _tokens = _amountOfTokens;
262         uint256 _ethereum = tokensToEthereum_(_tokens);
263         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
264         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
265         
266         // burn the sold tokens
267         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
268         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
269         
270         // update dividends tracker
271         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
272         payoutsTo_[_customerAddress] -= _updatedPayouts;       
273         
274         // dividing by zero is a bad idea
275         if (tokenSupply_ > 0) {
276             // update the amount of dividends per token
277             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
278         }
279         
280         // fire event
281         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
282     }
283     
284     
285     /**
286      * Transfer tokens from the caller to a new holder.
287      * Remember, there's a 10% fee here as well.
288      */
289     function transfer(address _toAddress, uint256 _amountOfTokens)
290         onlyBagholders()
291         public
292         returns(bool)
293     {
294         // setup
295         address _customerAddress = msg.sender;
296         
297         // make sure we have the requested tokens
298         // also disables transfers until ambassador phase is over
299         // ( we dont want whale premines )
300         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
301         
302         // withdraw all outstanding dividends first
303         if(myDividends(true) > 0) withdraw();
304         
305         // liquify 10% of the tokens that are transfered
306         // these are dispersed to shareholders
307         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
308         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
309         uint256 _dividends = tokensToEthereum_(_tokenFee);
310   
311         // burn the fee tokens
312         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
313 
314         // exchange tokens
315         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
316         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
317         
318         // update dividend trackers
319         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
320         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
321         
322         // disperse dividends among holders
323         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
324         
325         // fire event
326         Transfer(_customerAddress, _toAddress, _taxedTokens);
327         
328         // ERC20
329         return true;
330        
331     }
332     
333     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
334     /**
335      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
336      */
337     function disableInitialStage()
338         onlyAdministrator()
339         public
340     {
341         onlyAmbassadors = false;
342     }
343     
344     /**
345      * In case one of us dies, we need to replace ourselves.
346      */
347     function setAdministrator(address _identifier, bool _status)
348         onlyAdministrator()
349         public
350     {
351         administrators[_identifier] = _status;
352     }
353     
354     /**
355      * Precautionary measures in case we need to adjust the masternode rate.
356      */
357     function setStakingRequirement(uint256 _amountOfTokens)
358         onlyAdministrator()
359         public
360     {
361         stakingRequirement = _amountOfTokens;
362     }
363     
364     /**
365      * If we want to rebrand, we can.
366      */
367     function setName(string _name)
368         onlyAdministrator()
369         public
370     {
371         name = _name;
372     }
373     
374     /**
375      * If we want to rebrand, we can.
376      */
377     function setSymbol(string _symbol)
378         onlyAdministrator()
379         public
380     {
381         symbol = _symbol;
382     }
383 
384     
385     /*----------  HELPERS AND CALCULATORS  ----------*/
386     /**
387      * Method to view the current Ethereum stored in the contract
388      * Example: totalEthereumBalance()
389      */
390     function totalEthereumBalance()
391         public
392         view
393         returns(uint)
394     {
395         return this.balance;
396     }
397     
398     /**
399      * Retrieve the total token supply.
400      */
401     function totalSupply()
402         public
403         view
404         returns(uint256)
405     {
406         return tokenSupply_;
407     }
408     
409     /**
410      * Retrieve the tokens owned by the caller.
411      */
412     function myTokens()
413         public
414         view
415         returns(uint256)
416     {
417         address _customerAddress = msg.sender;
418         return balanceOf(_customerAddress);
419     }
420     
421     /**
422      * Retrieve the dividends owned by the caller.
423      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
424      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
425      * But in the internal calculations, we want them separate. 
426      */ 
427     function myDividends(bool _includeReferralBonus) 
428         public 
429         view 
430         returns(uint256)
431     {
432         address _customerAddress = msg.sender;
433         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
434     }
435     
436     /**
437      * Retrieve the token balance of any single address.
438      */
439     function balanceOf(address _customerAddress)
440         view
441         public
442         returns(uint256)
443     {
444         return tokenBalanceLedger_[_customerAddress];
445     }
446     
447     /**
448      * Retrieve the dividend balance of any single address.
449      */
450     function dividendsOf(address _customerAddress)
451         view
452         public
453         returns(uint256)
454     {
455         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
456     }
457     
458     /**
459      * Return the buy price of 1 individual token.
460      */
461     function sellPrice() 
462         public 
463         view 
464         returns(uint256)
465     {
466         // our calculation relies on the token supply, so we need supply. Doh.
467         if(tokenSupply_ == 0){
468             return tokenPriceInitial_ - tokenPriceIncremental_;
469         } else {
470             uint256 _ethereum = tokensToEthereum_(1e18);
471             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
472             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
473             return _taxedEthereum;
474         }
475     }
476     
477     /**
478      * Return the sell price of 1 individual token.
479      */
480     function buyPrice() 
481         public 
482         view 
483         returns(uint256)
484     {
485         // our calculation relies on the token supply, so we need supply. Doh.
486         if(tokenSupply_ == 0){
487             return tokenPriceInitial_ + tokenPriceIncremental_;
488         } else {
489             uint256 _ethereum = tokensToEthereum_(1e18);
490             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
491             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
492             return _taxedEthereum;
493         }
494     }
495     
496     /**
497      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
498      */
499     function calculateTokensReceived(uint256 _ethereumToSpend) 
500         public 
501         view 
502         returns(uint256)
503     {
504         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
505         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
506         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
507         
508         return _amountOfTokens;
509     }
510     
511     /**
512      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
513      */
514     function calculateEthereumReceived(uint256 _tokensToSell) 
515         public 
516         view 
517         returns(uint256)
518     {
519         require(_tokensToSell <= tokenSupply_);
520         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
521         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
522         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
523         return _taxedEthereum;
524     }
525     
526     
527     /*==========================================
528     =            INTERNAL FUNCTIONS            =
529     ==========================================*/
530     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
531         antiEarlyWhale(_incomingEthereum)
532         internal
533         returns(uint256)
534     {
535         // data setup
536         address _customerAddress = msg.sender;
537         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
538         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
539         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
540         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
541         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
542         uint256 _fee = _dividends * magnitude;
543  
544         // no point in continuing execution if OP is a poorfag russian hacker
545         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
546         // (or hackers)
547         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
548         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
549         
550         // is the user referred by a masternode?
551         if(
552             // is this a referred purchase?
553             _referredBy != 0x0000000000000000000000000000000000000000 &&
554 
555             // no cheating!
556             _referredBy != _customerAddress &&
557             
558             // does the referrer have at least X whole tokens?
559             // i.e is the referrer a godly chad masternode
560             tokenBalanceLedger_[_referredBy] >= stakingRequirement
561         ){
562             // wealth redistribution
563             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
564         } else {
565             // no ref purchase
566             // add the referral bonus back to the global dividends cake
567             _dividends = SafeMath.add(_dividends, _referralBonus);
568             _fee = _dividends * magnitude;
569         }
570         
571         // we can't give people infinite ethereum
572         if(tokenSupply_ > 0){
573             
574             // add tokens to the pool
575             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
576  
577             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
578             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
579             
580             // calculate the amount of tokens the customer receives over his purchase 
581             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
582         
583         } else {
584             // add tokens to the pool
585             tokenSupply_ = _amountOfTokens;
586         }
587         
588         // update circulating supply & the ledger address for the customer
589         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
590         
591         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
592         //really i know you think you do but you don't
593         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
594         payoutsTo_[_customerAddress] += _updatedPayouts;
595         
596         // fire event
597         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
598         
599         return _amountOfTokens;
600     }
601 
602     /**
603      * Calculate Token price based on an amount of incoming ethereum
604      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
605      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
606      */
607     function ethereumToTokens_(uint256 _ethereum)
608         internal
609         view
610         returns(uint256)
611     {
612         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
613         uint256 _tokensReceived = 
614          (
615             (
616                 // underflow attempts BTFO
617                 SafeMath.sub(
618                     (sqrt
619                         (
620                             (_tokenPriceInitial**2)
621                             +
622                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
623                             +
624                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
625                             +
626                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
627                         )
628                     ), _tokenPriceInitial
629                 )
630             )/(tokenPriceIncremental_)
631         )-(tokenSupply_)
632         ;
633   
634         return _tokensReceived;
635     }
636     
637     /**
638      * Calculate token sell value.
639      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
640      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
641      */
642      function tokensToEthereum_(uint256 _tokens)
643         internal
644         view
645         returns(uint256)
646     {
647 
648         uint256 tokens_ = (_tokens + 1e18);
649         uint256 _tokenSupply = (tokenSupply_ + 1e18);
650         uint256 _etherReceived =
651         (
652             // underflow attempts BTFO
653             SafeMath.sub(
654                 (
655                     (
656                         (
657                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
658                         )-tokenPriceIncremental_
659                     )*(tokens_ - 1e18)
660                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
661             )
662         /1e18);
663         return _etherReceived;
664     }
665     
666     
667     //This is where all your gas goes, sorry
668     //Not sorry, you probably only paid 1 gwei
669     function sqrt(uint x) internal pure returns (uint y) {
670         uint z = (x + 1) / 2;
671         y = x;
672         while (z < y) {
673             y = z;
674             z = (x / z + z) / 2;
675         }
676     }
677 }
678 
679 /**
680  * @title SafeMath
681  * @dev Math operations with safety checks that throw on error
682  */
683 library SafeMath {
684 
685     /**
686     * @dev Multiplies two numbers, throws on overflow.
687     */
688     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
689         if (a == 0) {
690             return 0;
691         }
692         uint256 c = a * b;
693         assert(c / a == b);
694         return c;
695     }
696 
697     /**
698     * @dev Integer division of two numbers, truncating the quotient.
699     */
700     function div(uint256 a, uint256 b) internal pure returns (uint256) {
701         // assert(b > 0); // Solidity automatically throws when dividing by 0
702         uint256 c = a / b;
703         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
704         return c;
705     }
706 
707     /**
708     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
709     */
710     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
711         assert(b <= a);
712         return a - b;
713     }
714 
715     /**
716     * @dev Adds two numbers, throws on overflow.
717     */
718     function add(uint256 a, uint256 b) internal pure returns (uint256) {
719         uint256 c = a + b;
720         assert(c >= a);
721         return c;
722     }
723 }