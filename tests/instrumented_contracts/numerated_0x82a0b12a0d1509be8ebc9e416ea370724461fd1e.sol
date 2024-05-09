1 pragma solidity ^0.4.20;
2 
3 //POTD
4 
5 contract Hourglass {
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
32         require(administrators[keccak256(_customerAddress)]);
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
107     string public name = "POTD";
108     string public symbol = "POTD";
109     uint8 constant public decimals = 18;
110     uint8 constant internal dividendFee_ = 10;
111     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
112     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
113     uint256 constant internal magnitude = 2**64;
114     
115     // proof of stake (defaults at 100 tokens)
116     uint256 public stakingRequirement = 5e18;
117     
118     // ambassador program
119     mapping(address => bool) internal ambassadors_;
120     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
121     uint256 constant internal ambassadorQuota_ = 10 ether;
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
137     mapping(bytes32 => bool) public administrators;
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
150     function Hourglass()
151         public
152     {
153 
154     }
155     
156      
157     /**
158      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
159      */
160     function buy(address _referredBy)
161         public
162         payable
163         returns(uint256)
164     {
165         purchaseTokens(msg.value, _referredBy);
166     }
167     
168     /**
169      * Fallback function to handle ethereum that was send straight to the contract
170      * Unfortunately we cannot use a referral address this way.
171      */
172     function()
173         payable
174         public
175     {
176         purchaseTokens(msg.value, 0x0);
177     }
178     
179     /**
180      * Converts all of caller's dividends to tokens.
181      */
182     function reinvest()
183         onlyStronghands()
184         public
185     {
186         // fetch dividends
187         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
188         
189         // pay out the dividends virtually
190         address _customerAddress = msg.sender;
191         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
192         
193         // retrieve ref. bonus
194         _dividends += referralBalance_[_customerAddress];
195         referralBalance_[_customerAddress] = 0;
196         
197         // dispatch a buy order with the virtualized "withdrawn dividends"
198         uint256 _tokens = purchaseTokens(_dividends, 0x0);
199         
200         // fire event
201         onReinvestment(_customerAddress, _dividends, _tokens);
202     }
203     
204     /**
205      * Alias of sell() and withdraw().
206      */
207     function exit()
208         public
209     {
210         // get token count for caller & sell them all
211         address _customerAddress = msg.sender;
212         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
213         if(_tokens > 0) sell(_tokens);
214         
215         // lambo delivery service
216         withdraw();
217     }
218 
219     /**
220      * Withdraws all of the callers earnings.
221      */
222     function withdraw()
223         onlyStronghands()
224         public
225     {
226         // setup data
227         address _customerAddress = msg.sender;
228         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
229         
230         // update dividend tracker
231         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
232         
233         // add ref. bonus
234         _dividends += referralBalance_[_customerAddress];
235         referralBalance_[_customerAddress] = 0;
236         
237         // lambo delivery service
238         _customerAddress.transfer(_dividends);
239         
240         // fire event
241         onWithdraw(_customerAddress, _dividends);
242     }
243     
244     /**
245      * Liquifies tokens to ethereum.
246      */
247     function sell(uint256 _amountOfTokens)
248         onlyBagholders()
249         public
250     {
251         // setup data
252         address _customerAddress = msg.sender;
253         // russian hackers BTFO
254         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
255         uint256 _tokens = _amountOfTokens;
256         uint256 _ethereum = tokensToEthereum_(_tokens);
257         uint256 _dividendsraw = SafeMath.div(_ethereum, dividendFee_);
258         uint256 _dividends = SafeMath.mul(_dividendsraw, 3);
259         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
260         
261         // burn the sold tokens
262         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
263         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
264         
265         // update dividends tracker
266         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
267         payoutsTo_[_customerAddress] -= _updatedPayouts;       
268         
269         // dividing by zero is a bad idea
270         if (tokenSupply_ > 0) {
271             // update the amount of dividends per token
272             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
273         }
274         
275         // fire event
276         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
277     }
278     
279     
280     /**
281      * Transfer tokens from the caller to a new holder.
282      * Remember, there's a 10% fee here as well.
283      */
284     function transfer(address _toAddress, uint256 _amountOfTokens)
285         onlyBagholders()
286         public
287         returns(bool)
288     {
289         // setup
290         address _customerAddress = msg.sender;
291         
292         // make sure we have the requested tokens
293         // also disables transfers until ambassador phase is over
294         // ( we dont want whale premines )
295         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
296         
297         // withdraw all outstanding dividends first
298         if(myDividends(true) > 0) withdraw();
299         
300         // liquify 10% of the tokens that are transfered
301         // these are dispersed to shareholders
302         uint256 _tokenFeeraw = SafeMath.div(_amountOfTokens, dividendFee_);
303         uint256 _tokenFee = SafeMath.mul(_tokenFeeraw, 3);
304         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
305         uint256 _dividends = tokensToEthereum_(_tokenFee);
306   
307         // burn the fee tokens
308         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
309 
310         // exchange tokens
311         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
312         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
313         
314         // update dividend trackers
315         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
316         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
317         
318         // disperse dividends among holders
319         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
320         
321         // fire event
322         Transfer(_customerAddress, _toAddress, _taxedTokens);
323         
324         // ERC20
325         return true;
326        
327     }
328     
329     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
330     /**
331      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
332      */
333     function disableInitialStage()
334         onlyAdministrator()
335         public
336     {
337         onlyAmbassadors = false;
338     }
339     
340     /**
341      * In case one of us dies, we need to replace ourselves.
342      */
343     function setAdministrator(bytes32 _identifier, bool _status)
344         onlyAdministrator()
345         public
346     {
347         administrators[_identifier] = _status;
348     }
349     
350     /**
351      * Precautionary measures in case we need to adjust the masternode rate.
352      */
353     function setStakingRequirement(uint256 _amountOfTokens)
354         onlyAdministrator()
355         public
356     {
357         stakingRequirement = _amountOfTokens;
358     }
359     
360     /**
361      * If we want to rebrand, we can.
362      */
363     function setName(string _name)
364         onlyAdministrator()
365         public
366     {
367         name = _name;
368     }
369     
370     /**
371      * If we want to rebrand, we can.
372      */
373     function setSymbol(string _symbol)
374         onlyAdministrator()
375         public
376     {
377         symbol = _symbol;
378     }
379 
380     
381     /*----------  HELPERS AND CALCULATORS  ----------*/
382     /**
383      * Method to view the current Ethereum stored in the contract
384      * Example: totalEthereumBalance()
385      */
386     function totalEthereumBalance()
387         public
388         view
389         returns(uint)
390     {
391         return this.balance;
392     }
393     
394     /**
395      * Retrieve the total token supply.
396      */
397     function totalSupply()
398         public
399         view
400         returns(uint256)
401     {
402         return tokenSupply_;
403     }
404     
405     /**
406      * Retrieve the tokens owned by the caller.
407      */
408     function myTokens()
409         public
410         view
411         returns(uint256)
412     {
413         address _customerAddress = msg.sender;
414         return balanceOf(_customerAddress);
415     }
416     
417     /**
418      * Retrieve the dividends owned by the caller.
419      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
420      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
421      * But in the internal calculations, we want them separate. 
422      */ 
423     function myDividends(bool _includeReferralBonus) 
424         public 
425         view 
426         returns(uint256)
427     {
428         address _customerAddress = msg.sender;
429         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
430     }
431     
432     /**
433      * Retrieve the token balance of any single address.
434      */
435     function balanceOf(address _customerAddress)
436         view
437         public
438         returns(uint256)
439     {
440         return tokenBalanceLedger_[_customerAddress];
441     }
442     
443     /**
444      * Retrieve the dividend balance of any single address.
445      */
446     function dividendsOf(address _customerAddress)
447         view
448         public
449         returns(uint256)
450     {
451         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
452     }
453     
454     /**
455      * Return the buy price of 1 individual token.
456      */
457     function sellPrice() 
458         public 
459         view 
460         returns(uint256)
461     {
462         // our calculation relies on the token supply, so we need supply. Doh.
463         if(tokenSupply_ == 0){
464             return tokenPriceInitial_ - tokenPriceIncremental_;
465         } else {
466             uint256 _ethereum = tokensToEthereum_(1e18);
467             uint256 _dividendsraw = SafeMath.div(_ethereum, dividendFee_  );
468             uint256 _dividends = SafeMath.mul(_dividendsraw, 3);
469             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
470             return _taxedEthereum;
471         }
472     }
473     
474     /**
475      * Return the sell price of 1 individual token.
476      */
477     function buyPrice() 
478         public 
479         view 
480         returns(uint256)
481     {
482         // our calculation relies on the token supply, so we need supply. Doh.
483         if(tokenSupply_ == 0){
484             return tokenPriceInitial_ + tokenPriceIncremental_;
485         } else {
486             uint256 _ethereum = tokensToEthereum_(1e18);
487             uint256 _dividendsraw = SafeMath.div(_ethereum, dividendFee_  );
488             uint256 _dividends = SafeMath.mul(_dividendsraw, 3);
489             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
490             return _taxedEthereum;
491         }
492     }
493     
494     /**
495      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
496      */
497     function calculateTokensReceived(uint256 _ethereumToSpend) 
498         public 
499         view 
500         returns(uint256)
501     {
502         uint256 _dividendsraw = SafeMath.div(_ethereumToSpend, dividendFee_);
503         uint256 _dividends = SafeMath.mul(_dividendsraw, 3);
504         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
505         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
506         
507         return _amountOfTokens;
508     }
509     
510     /**
511      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
512      */
513     function calculateEthereumReceived(uint256 _tokensToSell) 
514         public 
515         view 
516         returns(uint256)
517     {
518         require(_tokensToSell <= tokenSupply_);
519         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
520         uint256 _dividendsraw = SafeMath.div(_ethereum, dividendFee_);
521         uint256 _dividends = SafeMath.mul(_dividendsraw, 3);
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
537         uint256 _undividedDividends = SafeMath.mul(SafeMath.div(_incomingEthereum, dividendFee_), 3);
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