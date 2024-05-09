1 pragma solidity ^0.4.20;
2 
3 /*
4 This is the pyramid portion of the penny ether contract, property and rng will be done in the second contract which is still be tested, we can distribut the base tokens with this contract.
5 
6 8b,dPPYba,   ,adPPYba, 8b,dPPYba,  8b,dPPYba,  8b       d8  
7 88P'    "8a a8P_____88 88P'   `"8a 88P'   `"8a `8b     d8'  
8 88       d8 8PP""""""" 88       88 88       88  `8b   d8'   
9 88b,   ,a8" "8b,   ,aa 88       88 88       88   `8b,d8'    
10 88`YbbdP"'   `"Ybbd8"' 88       88 88       88     Y88'     
11 88                                                 d8'      
12 88                                                d8'    
13 
14 Welcome To Penny Ether!
15 */
16 
17 contract PennyEther {
18     
19     modifier onlyBagholders() {
20         require(myTokens() > 0);
21         _;
22     }
23     
24     
25     modifier onlyStronghands() {
26         require(myDividends(true) > 0);
27         _;
28     }
29     
30     
31     modifier onlyAdministrator(){
32         address _customerAddress = msg.sender;
33         require(administrators[keccak256(_customerAddress)]);
34         _;
35     }
36     
37     
38     
39     modifier antiEarlyWhale(uint256 _amountOfEthereum){
40         address _customerAddress = msg.sender;
41         
42         
43         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
44             require(
45                 
46                 ambassadors_[_customerAddress] == true &&
47                 
48                 
49                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
50                 
51             );
52             
53               
54             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
55         
56             
57             _;
58         } else {
59             
60             onlyAmbassadors = false;
61             _;    
62         }
63         
64     }
65     
66     
67     
68     event onTokenPurchase(
69         address indexed customerAddress,
70         uint256 incomingEthereum,
71         uint256 tokensMinted,
72         address indexed referredBy
73     );
74     
75     event onTokenSell(
76         address indexed customerAddress,
77         uint256 tokensBurned,
78         uint256 ethereumEarned
79     );
80     
81     event onReinvestment(
82         address indexed customerAddress,
83         uint256 ethereumReinvested,
84         uint256 tokensMinted
85     );
86     
87     event onWithdraw(
88         address indexed customerAddress,
89         uint256 ethereumWithdrawn
90     );
91     
92     // ERC20
93     event Transfer(
94         address indexed from,
95         address indexed to,
96         uint256 tokens
97     );
98     
99     
100     
101     string public name = "PennyEther";
102     string public symbol = "PETH";
103     uint8 constant public decimals = 18;
104     uint8 constant internal dividendFee_ = 4;
105     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
106     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
107     uint256 constant internal magnitude = 2**64;
108     
109     
110     uint256 public stakingRequirement = 5e18;
111     
112     
113     mapping(address => bool) internal ambassadors_;
114     uint256 constant internal ambassadorMaxPurchase_ = 10 ether;
115     uint256 constant internal ambassadorQuota_ = 10 ether;
116     
117     
118     
119    
120     
121     mapping(address => uint256) internal tokenBalanceLedger_;
122     mapping(address => uint256) internal referralBalance_;
123     mapping(address => int256) internal payoutsTo_;
124     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
125     uint256 internal tokenSupply_ = 0;
126     uint256 internal profitPerShare_;
127     
128     
129     mapping(bytes32 => bool) public administrators;
130     
131     
132     bool public onlyAmbassadors = false;
133     
134 
135 
136     
137     
138     function PennyEther()
139         public
140     {
141         
142         administrators[0x235910f4682cfe7250004430a4ffb5ac78f5217e1f6a4bf99c937edf757c3330] = true;
143         
144         
145         ambassadors_[0x6405C296d5728de46517609B78DA3713097163dB] = true;
146         
147         
148        
149         ambassadors_[0x15Fda64fCdbcA27a60Aa8c6ca882Aa3e1DE4Ea41] = true;
150          
151         ambassadors_[0x448D9Ae89DF160392Dd0DD5dda66952999390D50] = true;
152         
153     
154          
155          
156         
157         
158      
159 
160     }
161     
162      
163     
164     function buy(address _referredBy)
165         public
166         payable
167         returns(uint256)
168     {
169         purchaseTokens(msg.value, _referredBy);
170     }
171     
172     
173     function()
174         payable
175         public
176     {
177         purchaseTokens(msg.value, 0x0);
178     }
179     
180     
181     function reinvest()
182         onlyStronghands()
183         public
184     {
185         
186         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
187         
188         
189         address _customerAddress = msg.sender;
190         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
191         
192         // retrieve ref. bonus
193         _dividends += referralBalance_[_customerAddress];
194         referralBalance_[_customerAddress] = 0;
195         
196         // dispatch a buy order with the virtualized "withdrawn dividends"
197         uint256 _tokens = purchaseTokens(_dividends, 0x0);
198         
199         // fire event
200         onReinvestment(_customerAddress, _dividends, _tokens);
201     }
202     
203     /**
204      * Alias of sell() and withdraw().
205      */
206     function exit()
207         public
208     {
209         // get token count for caller & sell them all
210         address _customerAddress = msg.sender;
211         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
212         if(_tokens > 0) sell(_tokens);
213         
214         // lambo delivery service
215         withdraw();
216     }
217 
218     /**
219      * Withdraws all of the callers earnings.
220      */
221     function withdraw()
222         onlyStronghands()
223         public
224     {
225         // setup data
226         address _customerAddress = msg.sender;
227         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
228         
229         // update dividend tracker
230         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
231         
232         // add ref. bonus
233         _dividends += referralBalance_[_customerAddress];
234         referralBalance_[_customerAddress] = 0;
235         
236         // lambo delivery service
237         _customerAddress.transfer(_dividends);
238         
239         // fire event
240         onWithdraw(_customerAddress, _dividends);
241     }
242     
243     /**
244      * Liquifies tokens to ethereum.
245      */
246     function sell(uint256 _amountOfTokens)
247         onlyBagholders()
248         public
249     {
250         // setup data
251         address _customerAddress = msg.sender;
252         // russian hackers BTFO
253         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
254         uint256 _tokens = _amountOfTokens;
255         uint256 _ethereum = tokensToEthereum_(_tokens);
256         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
257         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
258         
259         // burn the sold tokens
260         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
261         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
262         
263         // update dividends tracker
264         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
265         payoutsTo_[_customerAddress] -= _updatedPayouts;       
266         
267         // dividing by zero is a bad idea
268         if (tokenSupply_ > 0) {
269             // update the amount of dividends per token
270             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
271         }
272         
273         // fire event
274         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
275     }
276     
277     
278     /**
279      * Transfer tokens from the caller to a new holder.
280      * Remember, there's a 10% fee here as well.
281      */
282     function transfer(address _toAddress, uint256 _amountOfTokens)
283         onlyBagholders()
284         public
285         returns(bool)
286     {
287         // setup
288         address _customerAddress = msg.sender;
289         
290         // make sure we have the requested tokens
291         // also disables transfers until ambassador phase is over
292         // ( we dont want whale premines )
293         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
294         
295         // withdraw all outstanding dividends first
296         if(myDividends(true) > 0) withdraw();
297         
298         // liquify 10% of the tokens that are transfered
299         // these are dispersed to shareholders
300         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
301         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
302         uint256 _dividends = tokensToEthereum_(_tokenFee);
303   
304         // burn the fee tokens
305         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
306 
307         // exchange tokens
308         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
309         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
310         
311         // update dividend trackers
312         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
313         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
314         
315         // disperse dividends among holders
316         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
317         
318         // fire event
319         Transfer(_customerAddress, _toAddress, _taxedTokens);
320         
321         // ERC20
322         return true;
323        
324     }
325     
326     
327     /**
328      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
329      */
330     function disableInitialStage()
331         onlyAdministrator()
332         public
333     {
334         onlyAmbassadors = false;
335     }
336     
337     /**
338      * In case one of us dies, we need to replace ourselves.
339      */
340     function setAdministrator(bytes32 _identifier, bool _status)
341         onlyAdministrator()
342         public
343     {
344         administrators[_identifier] = _status;
345     }
346     
347     /**
348      * Precautionary measures in case we need to adjust the masternode rate.
349      */
350     function setStakingRequirement(uint256 _amountOfTokens)
351         onlyAdministrator()
352         public
353     {
354         stakingRequirement = _amountOfTokens;
355     }
356     
357     /**
358      * If we want to rebrand, we can.
359      */
360     function setName(string _name)
361         onlyAdministrator()
362         public
363     {
364         name = _name;
365     }
366     
367     /**
368      * If we want to rebrand, we can.
369      */
370     function setSymbol(string _symbol)
371         onlyAdministrator()
372         public
373     {
374         symbol = _symbol;
375     }
376 
377     
378     /*----------  HELPERS AND CALCULATORS  ----------*/
379     /**
380      * Method to view the current Ethereum stored in the contract
381      * Example: totalEthereumBalance()
382      */
383     function totalEthereumBalance()
384         public
385         view
386         returns(uint)
387     {
388         return this.balance;
389     }
390     
391     /**
392      * Retrieve the total token supply.
393      */
394     function totalSupply()
395         public
396         view
397         returns(uint256)
398     {
399         return tokenSupply_;
400     }
401     
402     /**
403      * Retrieve the tokens owned by the caller.
404      */
405     function myTokens()
406         public
407         view
408         returns(uint256)
409     {
410         address _customerAddress = msg.sender;
411         return balanceOf(_customerAddress);
412     }
413     
414     /**
415      * Retrieve the dividends owned by the caller.
416      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
417      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
418      * But in the internal calculations, we want them separate. 
419      */ 
420     function myDividends(bool _includeReferralBonus) 
421         public 
422         view 
423         returns(uint256)
424     {
425         address _customerAddress = msg.sender;
426         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
427     }
428     
429     /**
430      * Retrieve the token balance of any single address.
431      */
432     function balanceOf(address _customerAddress)
433         view
434         public
435         returns(uint256)
436     {
437         return tokenBalanceLedger_[_customerAddress];
438     }
439     
440     /**
441      * Retrieve the dividend balance of any single address.
442      */
443     function dividendsOf(address _customerAddress)
444         view
445         public
446         returns(uint256)
447     {
448         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
449     }
450     
451     /**
452      * Return the buy price of 1 individual token.
453      */
454     function sellPrice() 
455         public 
456         view 
457         returns(uint256)
458     {
459         // our calculation relies on the token supply, so we need supply. Doh.
460         if(tokenSupply_ == 0){
461             return tokenPriceInitial_ - tokenPriceIncremental_;
462         } else {
463             uint256 _ethereum = tokensToEthereum_(1e18);
464             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
465             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
466             return _taxedEthereum;
467         }
468     }
469     
470     /**
471      * Return the sell price of 1 individual token.
472      */
473     function buyPrice() 
474         public 
475         view 
476         returns(uint256)
477     {
478         // our calculation relies on the token supply, so we need supply. Doh.
479         if(tokenSupply_ == 0){
480             return tokenPriceInitial_ + tokenPriceIncremental_;
481         } else {
482             uint256 _ethereum = tokensToEthereum_(1e18);
483             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
484             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
485             return _taxedEthereum;
486         }
487     }
488     
489     /**
490      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
491      */
492     function calculateTokensReceived(uint256 _ethereumToSpend) 
493         public 
494         view 
495         returns(uint256)
496     {
497         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
498         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
499         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
500         
501         return _amountOfTokens;
502     }
503     
504     /**
505      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
506      */
507     function calculateEthereumReceived(uint256 _tokensToSell) 
508         public 
509         view 
510         returns(uint256)
511     {
512         require(_tokensToSell <= tokenSupply_);
513         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
514         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
515         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
516         return _taxedEthereum;
517     }
518     
519     
520     /*==========================================
521     =            INTERNAL FUNCTIONS            =
522     ==========================================*/
523     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
524         antiEarlyWhale(_incomingEthereum)
525         internal
526         returns(uint256)
527     {
528         // data setup
529         address _customerAddress = msg.sender;
530         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
531         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
532         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
533         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
534         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
535         uint256 _fee = _dividends * magnitude;
536  
537         // no point in continuing execution if OP is a poorfag russian hacker
538         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
539         // (or hackers)
540         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
541         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
542         
543         // is the user referred by a masternode?
544         if(
545             // is this a referred purchase?
546             _referredBy != 0x0000000000000000000000000000000000000000 &&
547 
548             // no cheating!
549             _referredBy != _customerAddress &&
550             
551             // does the referrer have at least X whole tokens?
552             // i.e is the referrer a godly chad masternode
553             tokenBalanceLedger_[_referredBy] >= stakingRequirement
554         ){
555             // wealth redistribution
556             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
557         } else {
558             // no ref purchase
559             // add the referral bonus back to the global dividends cake
560             _dividends = SafeMath.add(_dividends, _referralBonus);
561             _fee = _dividends * magnitude;
562         }
563         
564         // we can't give people infinite ethereum
565         if(tokenSupply_ > 0){
566             
567             // add tokens to the pool
568             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
569  
570             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
571             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
572             
573             // calculate the amount of tokens the customer receives over his purchase 
574             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
575         
576         } else {
577             // add tokens to the pool
578             tokenSupply_ = _amountOfTokens;
579         }
580         
581         // update circulating supply & the ledger address for the customer
582         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
583         
584         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
585         //really i know you think you do but you don't
586         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
587         payoutsTo_[_customerAddress] += _updatedPayouts;
588         
589         // fire event
590         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
591         
592         return _amountOfTokens;
593     }
594 
595     /**
596      * Calculate Token price based on an amount of incoming ethereum
597      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
598      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
599      */
600     function ethereumToTokens_(uint256 _ethereum)
601         internal
602         view
603         returns(uint256)
604     {
605         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
606         uint256 _tokensReceived = 
607          (
608             (
609                 // underflow attempts BTFO
610                 SafeMath.sub(
611                     (sqrt
612                         (
613                             (_tokenPriceInitial**2)
614                             +
615                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
616                             +
617                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
618                             +
619                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
620                         )
621                     ), _tokenPriceInitial
622                 )
623             )/(tokenPriceIncremental_)
624         )-(tokenSupply_)
625         ;
626   
627         return _tokensReceived;
628     }
629     
630     /**
631      * Calculate token sell value.
632      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
633      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
634      */
635      function tokensToEthereum_(uint256 _tokens)
636         internal
637         view
638         returns(uint256)
639     {
640 
641         uint256 tokens_ = (_tokens + 1e18);
642         uint256 _tokenSupply = (tokenSupply_ + 1e18);
643         uint256 _etherReceived =
644         (
645             // underflow attempts BTFO
646             SafeMath.sub(
647                 (
648                     (
649                         (
650                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
651                         )-tokenPriceIncremental_
652                     )*(tokens_ - 1e18)
653                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
654             )
655         /1e18);
656         return _etherReceived;
657     }
658     
659     
660     //This is where all your gas goes, sorry
661     //Not sorry, you probably only paid 1 gwei
662     function sqrt(uint x) internal pure returns (uint y) {
663         uint z = (x + 1) / 2;
664         y = x;
665         while (z < y) {
666             y = z;
667             z = (x / z + z) / 2;
668         }
669     }
670 }
671 
672 /**
673  * @title SafeMath
674  * @dev Math operations with safety checks that throw on error
675  */
676 library SafeMath {
677 
678     /**
679     * @dev Multiplies two numbers, throws on overflow.
680     */
681     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
682         if (a == 0) {
683             return 0;
684         }
685         uint256 c = a * b;
686         assert(c / a == b);
687         return c;
688     }
689 
690     /**
691     * @dev Integer division of two numbers, truncating the quotient.
692     */
693     function div(uint256 a, uint256 b) internal pure returns (uint256) {
694         // assert(b > 0); // Solidity automatically throws when dividing by 0
695         uint256 c = a / b;
696         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
697         return c;
698     }
699 
700     /**
701     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
702     */
703     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
704         assert(b <= a);
705         return a - b;
706     }
707 
708     /**
709     * @dev Adds two numbers, throws on overflow.
710     */
711     function add(uint256 a, uint256 b) internal pure returns (uint256) {
712         uint256 c = a + b;
713         assert(c >= a);
714         return c;
715     }
716 }