1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract PlayCoinPow {
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
32         require(administrators[keccak256(abi.encodePacked(_customerAddress))]);
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
49                 // does the customer purchase exceed the max ambassador quota?
50                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
51                 
52             );
53             
54             // updated the accumulated quota    
55             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
56         
57             // execute
58             _;
59         } else {
60             // in case the ether count drops low, the ambassador phase won't reinitiate
61             onlyAmbassadors = false;
62             _;    
63         }
64         
65     }
66 
67 
68     modifier isActivated() {
69         require(activated_ == true, "its not ready yet.  check ?eta in discord");
70         _;
71     }
72     
73     
74     /*==============================
75     =            EVENTS            =
76     ==============================*/
77     event onTokenPurchase(
78         address indexed customerAddress,
79         uint256 incomingEthereum,
80         uint256 tokensMinted,
81         address indexed referredBy
82     );
83     
84     event onTokenSell(
85         address indexed customerAddress,
86         uint256 tokensBurned,
87         uint256 ethereumEarned
88     );
89     
90     event onReinvestment(
91         address indexed customerAddress,
92         uint256 ethereumReinvested,
93         uint256 tokensMinted
94     );
95     
96     event onWithdraw(
97         address indexed customerAddress,
98         uint256 ethereumWithdrawn
99     );
100     
101     // ERC20
102     event Transfer(
103         address indexed from,
104         address indexed to,
105         uint256 tokens
106     );
107     
108     
109     /*=====================================
110     =            CONFIGURABLES            =
111     =====================================*/
112     string public name = "PlayCoin Pow";
113     string public symbol = "PCP";
114     uint8 constant public decimals = 18;
115     uint8 constant internal dividendFee_ = 10;
116     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
117     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
118     uint256 constant internal magnitude = 2**64;
119     
120     // proof of stake (defaults at 100 tokens)
121     uint256 public stakingRequirement = 100e18;
122     
123     // ambassador program
124     mapping(address => bool) internal ambassadors_;
125     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
126     uint256 constant internal ambassadorQuota_ = 20 ether;
127     
128     
129     
130    /*================================
131     =            DATASETS            =
132     ================================*/
133     // amount of shares for each address (scaled number)
134     mapping(address => uint256) internal tokenBalanceLedger_;
135     mapping(address => uint256) internal referralBalance_;
136     mapping(address => int256) internal payoutsTo_;
137     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
138     uint256 internal tokenSupply_ = 0;
139     uint256 internal profitPerShare_;
140     
141     // administrator list (see above on what they can do)
142     mapping(bytes32 => bool) public administrators;
143     
144     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
145     bool public onlyAmbassadors = true;
146     address private admin = msg.sender;
147     bool public activated_ = false ;
148     
149 
150 
151     /*=======================================
152     =            PUBLIC FUNCTIONS            =
153     =======================================*/
154     /*
155     * -- APPLICATION ENTRY POINTS --  
156     */
157     constructor() public {
158         // add administrators here
159         administrators[keccak256(abi.encodePacked(admin))] = true;
160 
161         ambassadors_[admin] = true;
162     }
163 
164 
165     function activate() onlyAdministrator() public {
166         
167         // can only be ran once
168         require(activated_ == false, "PCP already activated");
169         
170         // activate the contract 
171         activated_ = true;
172     }
173 
174     function addAmbassador(address _ambassador) onlyAdministrator() public {
175         
176         if( ambassadors_[_ambassador] == false){
177             ambassadors_[_ambassador] = true;
178         }
179     }
180 
181     function getAmbassador(address _ambassador) onlyAdministrator() public view returns(bool){
182         return ambassadors_[_ambassador];
183     }
184     
185      
186     /**
187      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
188      */
189     function buy(address _referredBy)
190         public
191         payable
192         returns(uint256)
193     {
194         purchaseTokens(msg.value, _referredBy);
195     }
196     
197     /**
198      * Fallback function to handle ethereum that was send straight to the contract
199      * Unfortunately we cannot use a referral address this way.
200      */
201     function()
202         payable
203         public
204     {
205         purchaseTokens(msg.value, 0x0);
206     }
207     
208     /**
209      * Converts all of caller's dividends to tokens.
210      */
211     function reinvest()
212         onlyStronghands()
213         public
214     {
215         // fetch dividends
216         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
217         
218         // pay out the dividends virtually
219         address _customerAddress = msg.sender;
220         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
221         
222         // retrieve ref. bonus
223         _dividends += referralBalance_[_customerAddress];
224         referralBalance_[_customerAddress] = 0;
225         
226         // dispatch a buy order with the virtualized "withdrawn dividends"
227         uint256 _tokens = purchaseTokens(_dividends, 0x0);
228         
229         // fire event
230         emit onReinvestment(_customerAddress, _dividends, _tokens);
231     }
232     
233     /**
234      * Alias of sell() and withdraw().
235      */
236     function exit()
237         public
238     {
239         // get token count for caller & sell them all
240         address _customerAddress = msg.sender;
241         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
242         if(_tokens > 0) sell(_tokens);
243         
244         // lambo delivery service
245         withdraw();
246     }
247 
248     /**
249      * Withdraws all of the callers earnings.
250      */
251     function withdraw()
252         onlyStronghands()
253         public
254     {
255         // setup data
256         address _customerAddress = msg.sender;
257         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
258         
259         // update dividend tracker
260         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
261         
262         // add ref. bonus
263         _dividends += referralBalance_[_customerAddress];
264         referralBalance_[_customerAddress] = 0;
265         
266         // lambo delivery service
267         _customerAddress.transfer(_dividends);
268         
269         // fire event
270         emit onWithdraw(_customerAddress, _dividends);
271     }
272     
273     /**
274      * Liquifies tokens to ethereum.
275      */
276     function sell(uint256 _amountOfTokens)
277         onlyBagholders()
278         public
279     {
280         // setup data
281         address _customerAddress = msg.sender;
282         // russian hackers BTFO
283         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
284         uint256 _tokens = _amountOfTokens;
285         uint256 _ethereum = tokensToEthereum_(_tokens);
286         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
287         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
288         
289         // burn the sold tokens
290         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
291         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
292         
293         // update dividends tracker
294         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
295         payoutsTo_[_customerAddress] -= _updatedPayouts;       
296         
297         // dividing by zero is a bad idea
298         if (tokenSupply_ > 0) {
299             // update the amount of dividends per token
300             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
301         }
302         
303         // fire event
304         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
305     }
306     
307     
308     /**
309      * Transfer tokens from the caller to a new holder.
310      * Remember, there's a 10% fee here as well.
311      */
312     function transfer(address _toAddress, uint256 _amountOfTokens)
313         onlyBagholders()
314         public
315         returns(bool)
316     {
317         // setup
318         address _customerAddress = msg.sender;
319         
320         // make sure we have the requested tokens
321         // also disables transfers until ambassador phase is over
322         // ( we dont want whale premines )
323         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
324         
325         // withdraw all outstanding dividends first
326         if(myDividends(true) > 0) withdraw();
327         
328         // liquify 10% of the tokens that are transfered
329         // these are dispersed to shareholders
330         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
331         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
332         uint256 _dividends = tokensToEthereum_(_tokenFee);
333   
334         // burn the fee tokens
335         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
336 
337         // exchange tokens
338         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
339         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
340         
341         // update dividend trackers
342         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
343         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
344         
345         // disperse dividends among holders
346         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
347         
348         // fire event
349         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
350         
351         // ERC20
352         return true;
353        
354     }
355     
356     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
357     /**
358      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
359      */
360     function disableInitialStage()
361         onlyAdministrator()
362         public
363     {
364         onlyAmbassadors = false;
365     }
366     
367     /**
368      * In case one of us dies, we need to replace ourselves.
369      */
370     function setAdministrator(bytes32 _identifier, bool _status)
371         onlyAdministrator()
372         public
373     {
374         administrators[_identifier] = _status;
375     }
376     
377     /**
378      * Precautionary measures in case we need to adjust the masternode rate.
379      */
380     function setStakingRequirement(uint256 _amountOfTokens)
381         onlyAdministrator()
382         public
383     {
384         stakingRequirement = _amountOfTokens;
385     }
386     
387     /**
388      * If we want to rebrand, we can.
389      */
390     function setName(string _name)
391         onlyAdministrator()
392         public
393     {
394         name = _name;
395     }
396     
397     /**
398      * If we want to rebrand, we can.
399      */
400     function setSymbol(string _symbol)
401         onlyAdministrator()
402         public
403     {
404         symbol = _symbol;
405     }
406 
407     
408     /*----------  HELPERS AND CALCULATORS  ----------*/
409     /**
410      * Method to view the current Ethereum stored in the contract
411      * Example: totalEthereumBalance()
412      */
413     function totalEthereumBalance()
414         public
415         view
416         returns(uint)
417     {
418         return address(this).balance;
419     }
420     
421     /**
422      * Retrieve the total token supply.
423      */
424     function totalSupply()
425         public
426         view
427         returns(uint256)
428     {
429         return tokenSupply_;
430     }
431     
432     /**
433      * Retrieve the tokens owned by the caller.
434      */
435     function myTokens()
436         public
437         view
438         returns(uint256)
439     {
440         address _customerAddress = msg.sender;
441         return balanceOf(_customerAddress);
442     }
443     
444     /**
445      * Retrieve the dividends owned by the caller.
446      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
447      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
448      * But in the internal calculations, we want them separate. 
449      */ 
450     function myDividends(bool _includeReferralBonus) 
451         public 
452         view 
453         returns(uint256)
454     {
455         address _customerAddress = msg.sender;
456         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
457     }
458     
459     /**
460      * Retrieve the token balance of any single address.
461      */
462     function balanceOf(address _customerAddress)
463         view
464         public
465         returns(uint256)
466     {
467         return tokenBalanceLedger_[_customerAddress];
468     }
469     
470     /**
471      * Retrieve the dividend balance of any single address.
472      */
473     function dividendsOf(address _customerAddress)
474         view
475         public
476         returns(uint256)
477     {
478         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
479     }
480     
481     /**
482      * Return the buy price of 1 individual token.
483      */
484     function sellPrice() 
485         public 
486         view 
487         returns(uint256)
488     {
489         // our calculation relies on the token supply, so we need supply. Doh.
490         if(tokenSupply_ == 0){
491             return tokenPriceInitial_ - tokenPriceIncremental_;
492         } else {
493             uint256 _ethereum = tokensToEthereum_(1e18);
494             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
495             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
496             return _taxedEthereum;
497         }
498     }
499     
500     /**
501      * Return the sell price of 1 individual token.
502      */
503     function buyPrice() 
504         public 
505         view 
506         returns(uint256)
507     {
508         // our calculation relies on the token supply, so we need supply. Doh.
509         if(tokenSupply_ == 0){
510             return tokenPriceInitial_ + tokenPriceIncremental_;
511         } else {
512             uint256 _ethereum = tokensToEthereum_(1e18);
513             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
514             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
515             return _taxedEthereum;
516         }
517     }
518     
519     /**
520      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
521      */
522     function calculateTokensReceived(uint256 _ethereumToSpend) 
523         public 
524         view 
525         returns(uint256)
526     {
527         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
528         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
529         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
530         
531         return _amountOfTokens;
532     }
533     
534     /**
535      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
536      */
537     function calculateEthereumReceived(uint256 _tokensToSell) 
538         public 
539         view 
540         returns(uint256)
541     {
542         require(_tokensToSell <= tokenSupply_);
543         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
544         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
545         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
546         return _taxedEthereum;
547     }
548     
549     
550     /*==========================================
551     =            INTERNAL FUNCTIONS            =
552     ==========================================*/
553     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
554         isActivated() 
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
621         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
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