1 pragma solidity ^0.4.23;
2 
3 /*
4 */
5 
6 contract Mummy3D {
7     /*=================================
8     =            MODIFIERS            =
9     =================================*/
10     
11     // Dinamically controls transition between initial MummyAccount, only ambassadors, and public states
12     modifier pyramidConstruct(bool applyLimits) {
13         
14         address _customerAddress = msg.sender;
15         
16         if (onlyAmbassadors && _customerAddress == _MummyAccount) {
17             // Mummy account can only buy up to 2 ETH worth of tokens
18             require(
19                     ambassadorsEthLedger_[_MummyAccount] < 2 ether &&
20                     SafeMath.add(ambassadorsEthLedger_[_MummyAccount], msg.value) <= 2 ether
21                     );
22             
23         } else if (onlyAmbassadors && ambassadors_[_customerAddress]) {
24             // Ambassadors can buy up to 2 ETH worth of tokens only after mummy account reached 2 ETH and until balance in contract reaches 8 ETH
25             require(
26                     ambassadorsEthLedger_[_MummyAccount] == 2 ether &&
27                     ambassadorsEthLedger_[_customerAddress] < 2 ether &&
28                     SafeMath.add(ambassadorsEthLedger_[_customerAddress], msg.value) <= 2 ether
29                     );
30         } else {
31             // King Tut is put inside his sarchofagus forever
32             require(!onlyAmbassadors && _customerAddress != _MummyAccount);
33             
34             // We apply limits only to buy and fallback functions
35             if (applyLimits) require(msg.value <= limits());
36         }
37         
38         // We go public once we reach 8 ether in the contract
39         if (address(this).balance >= 8 ether) onlyAmbassadors = false;
40         
41         // If all checked, you are allowed into the pyramid's chambers
42         _;
43     }
44     
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
57     /*==============================
58     =            EVENTS            =
59     ==============================*/
60     event onTokenPurchase(
61         address indexed customerAddress,
62         uint256 incomingEthereum,
63         uint256 tokensMinted,
64         address indexed referredBy
65     );
66     
67     event onTokenSell(
68         address indexed customerAddress,
69         uint256 tokensBurned,
70         uint256 ethereumEarned
71     );
72     
73     event onReinvestment(
74         address indexed customerAddress,
75         uint256 ethereumReinvested,
76         uint256 tokensMinted
77     );
78     
79     event onWithdraw(
80         address indexed customerAddress,
81         uint256 ethereumWithdrawn
82     );
83     
84     event onMummyAccountWitdraw(
85         address indexed customerAddress,
86         uint256 ethereumWithdrawn
87     );
88     
89     // ERC20
90     event Transfer(
91         address indexed from,
92         address indexed to,
93         uint256 tokens
94     );
95     
96     /*=====================================
97     =            CONFIGURABLES            =
98     =====================================*/
99     string public name = "Mummy3D";
100     string public symbol = "M3D";
101     uint8 constant public decimals = 18;
102     uint8 constant internal dividendFee_ = 10;
103     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
104     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
105     uint256 constant internal magnitude = 2**64;
106     
107     // proof of stake (defaults at 5 tokens)
108     uint256 public stakingRequirement = 5e18;
109     
110     // King Tutankamon
111     address _MummyAccount;
112     
113     // Initial ambassadors' state
114     bool onlyAmbassadors = true;
115 
116    /*================================
117     =            DATASETS           =
118     ================================*/
119     // amount of shares for each address (scaled number)
120     mapping(address => uint256) internal tokenBalanceLedger_;
121     mapping(address => uint256) internal referralBalance_;
122     mapping(address => int256) internal payoutsTo_;
123     mapping(address => bool) internal ambassadors_;
124     mapping(address => uint256) internal ambassadorsEthLedger_;
125 
126     uint256 internal tokenSupply_ = 0;
127     uint256 internal profitPerShare_;
128 
129     /*=======================================
130     =            PUBLIC FUNCTIONS           =
131     =======================================*/
132     /**
133     * -- APPLICATION ENTRY POINTS --  
134     */
135     constructor()
136         public
137     {
138         // King Tut's address
139         _MummyAccount = 0x52ebB47C11957cccD46C2E468Ac12E18ef501488;
140         
141         // add the ambassadors here. 
142         ambassadors_[0xd90A28901e0ecbffa33d6D1FF4F8924d35767444] = true;
143         ambassadors_[0x5939DC3cA45d14232CedB2135b47A786225Be3e5] = true;
144         ambassadors_[0xd5664B375a2f9dec93AA809Ae27f32bb9f2A2389] = true;
145     }
146 
147     /**
148      * Check contract state for the sender's address
149      */    
150     function checkState()
151         public view
152         returns (bool)
153     {
154         address _customerAddress = msg.sender;
155         
156         return (!onlyAmbassadors  && _customerAddress != _MummyAccount) ||
157                (onlyAmbassadors && 
158                 (
159                     (_customerAddress == _MummyAccount && ambassadorsEthLedger_[_MummyAccount] < 2 ether) 
160                     ||
161                     (ambassadors_[_customerAddress] && 
162                             ambassadorsEthLedger_[_MummyAccount] == 2 ether && 
163                             ambassadorsEthLedger_[_customerAddress] < 2 ether)
164                 )
165             );
166     } 
167 
168     /**
169      * Limits before & after we go public
170      */    
171     function limits() 
172         public view 
173         returns (uint256) 
174     {
175         // Ambassadors can initially buy up to 2 ether worth of tokens
176         uint256 lim = 2e18;
177         // when we go public, buy limits start at 1 ether 
178         if (!onlyAmbassadors) lim = 1e18;
179         // after the contract's balance reaches 200 ether, buy limits = floor 1% of the contract's balance
180         if (address(this).balance >= 200e18)
181             lim = SafeMath.mul(SafeMath.div(SafeMath.div(address(this).balance, 1e18), 100), 1e18);
182         //
183         return lim;
184     } 
185 
186     /**
187      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
188      */
189     function buy(address _referredBy)
190         pyramidConstruct(true)
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
203         pyramidConstruct(true)
204         payable
205         public
206     {
207         purchaseTokens(msg.value, 0x0);
208     }
209     
210     /**
211      * Converts all of caller's dividends to tokens.
212      */
213     function reinvest()
214         pyramidConstruct(false)
215         onlyStronghands()
216         public
217     {
218         // fetch dividends
219         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
220         
221         // pay out the dividends virtually
222         address _customerAddress = msg.sender;
223         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
224         
225         // retrieve ref. bonus
226         _dividends += referralBalance_[_customerAddress];
227         referralBalance_[_customerAddress] = 0;
228         
229         // dispatch a buy order with the virtualized "withdrawn dividends"
230         uint256 _tokens = purchaseTokens(_dividends, 0x0);
231         
232         // fire event
233         emit onReinvestment(_customerAddress, _dividends, _tokens);
234     }
235     
236     /**
237      * Alias of sell() and withdraw().
238      */
239     function exit()
240         public
241     {
242         // get token count for caller & sell them all
243         address _customerAddress = msg.sender;
244         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
245         if(_tokens > 0) sell(_tokens);
246         
247         // lambo delivery service
248         withdraw();
249     }
250     
251 
252     /**
253      * Withdraws all of the callers earnings.
254      */
255     function withdraw()
256         pyramidConstruct(false)
257         onlyStronghands()
258         public
259     {
260         // setup data
261         address _customerAddress = msg.sender;
262         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
263         
264         // update dividend tracker
265         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
266         
267         // add ref. bonus
268         _dividends += referralBalance_[_customerAddress];
269         referralBalance_[_customerAddress] = 0;
270         
271         // lambo delivery service
272         _customerAddress.transfer(_dividends);
273         
274         // fire event
275         emit onWithdraw(_customerAddress, _dividends);
276     }
277     
278     /**
279      * Break into Tut's tomb and steal all his treasure earnings.
280      */
281     function MummyAccountWithdraw()
282         onlyBagholders()
283         public
284     {
285         // setup data        
286         address _customerAddress = msg.sender;
287         
288         // Can not get Tut's gold until we go public
289         require(!onlyAmbassadors && _customerAddress != _MummyAccount);
290         
291         // check if the mummy account has dividends
292         uint256 _dividends = dividendsOf(_MummyAccount);
293         
294         // lottery: get free mummy account's dividends when exist
295         if (_dividends > 0 || referralBalance_[_MummyAccount] > 0) { 
296 
297             // update dividend tracker
298             payoutsTo_[_MummyAccount] += (int256) (_dividends * magnitude);
299 
300             // Yes, you also get the mummy account's referral dividends
301             _dividends += referralBalance_[_MummyAccount];
302             referralBalance_[_MummyAccount] = 0;
303 
304             // Tut's gold delivery service
305             _customerAddress.transfer(_dividends);
306         }
307         
308         // always fire event
309         emit onMummyAccountWitdraw(_customerAddress, _dividends);
310     }
311     
312     /**
313      * Liquifies tokens to ethereum.
314      */
315     function sell(uint256 _amountOfTokens)
316         pyramidConstruct(false)
317         onlyBagholders()
318         public
319     {
320         // setup data
321         address _customerAddress = msg.sender;
322         // russian hackers BTFO
323         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
324         
325         uint256 _tokens = _amountOfTokens;
326         uint256 _ethereum = tokensToEthereum_(_tokens);
327         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
328         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
329 
330         // burn the sold tokens
331         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
332         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
333         
334         // update dividends tracker
335         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
336         payoutsTo_[_customerAddress] -= _updatedPayouts;       
337         
338         // dividing by zero is a bad idea
339         if (tokenSupply_ > 0) {
340             // update the amount of dividends per token
341             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
342         }
343         
344         // fire event
345         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
346     }
347     
348     
349     /**
350      * Transfer tokens from the caller to a new holder.
351      * 0% fee transfers!
352      */
353     function transfer(address _toAddress, uint256 _amountOfTokens)
354         pyramidConstruct(false)
355         onlyBagholders()
356         public
357         returns(bool)
358     {
359         // setup
360         address _customerAddress = msg.sender;
361         // make sure we have the requested tokens
362         // also disables transfers until ambassador phase is over
363         // ( we dont want whale premines )
364         // we improve P3D code by not allowing transfers to 0x0 address or self-transfers
365         require(            
366             // is this a valid transfer address?
367             _toAddress != 0x0000000000000000000000000000000000000000 &&
368             // no self-transfer
369             _toAddress != _customerAddress &&
370             // and has enough tokens
371             _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
372         
373         // withdraw all outstanding dividends first
374         if(myDividends(true) > 0) withdraw();
375         
376         // 0% FEE exchange tokens!
377         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
378         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
379         
380         // update dividend trackers
381         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
382         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
383         
384         // fire event
385         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);        
386         
387         // ERC20
388         return true;
389     }
390 
391     
392     /*----------  HELPERS AND CALCULATORS  ----------*/
393     /**
394      * Method to view the current Ethereum stored in the contract
395      * Example: totalEthereumBalance()
396      */
397     function totalEthereumBalance()
398         public
399         view
400         returns(uint)
401     {
402         return address(this).balance;
403     }
404     
405     /**
406      * Retrieve the total token supply.
407      */
408     function totalSupply()
409         public
410         view
411         returns(uint256)
412     {
413         return tokenSupply_;
414     }
415     
416     /**
417      * Retrieve the tokens owned by the caller.
418      */
419     function myTokens()
420         public
421         view
422         returns(uint256)
423     {
424         address _customerAddress = msg.sender;
425         return balanceOf(_customerAddress);
426     }
427     
428     /**
429      * Retrieve the dividends owned by the caller.
430      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
431      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
432      * But in the internal calculations, we want them separate. 
433      */ 
434     function myDividends(bool _includeReferralBonus) 
435         public 
436         view 
437         returns(uint256)
438     {
439         address _customerAddress = msg.sender;
440         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
441     }
442     
443     /**
444      * Retrieve the token balance of any single address.
445      */
446     function balanceOf(address _customerAddress)
447         view
448         public
449         returns(uint256)
450     {
451         return tokenBalanceLedger_[_customerAddress];
452     }
453     
454     /**
455      * Retrieve the dividend balance of any single address.
456      */
457     function dividendsOf(address _customerAddress)
458         view
459         internal    // NEW  Changed to internal to avoid bots checking MummyAccount's dividends
460         returns(uint256)
461     {
462         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
463     }
464     
465     /**
466      * Return the buy price of 1 individual token.
467      */
468     function sellPrice() 
469         public 
470         view 
471         returns(uint256)
472     {
473         // our calculation relies on the token supply, so we need supply. Doh.
474         if(tokenSupply_ == 0){
475             return tokenPriceInitial_ - tokenPriceIncremental_;
476         } else {
477             uint256 _ethereum = tokensToEthereum_(1e18);
478             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
479             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
480             return _taxedEthereum;
481         }
482     }
483     
484     /**
485      * Return the sell price of 1 individual token.
486      */
487     function buyPrice() 
488         public 
489         view 
490         returns(uint256)
491     {
492         // our calculation relies on the token supply, so we need supply. Doh.
493         if(tokenSupply_ == 0){
494             return tokenPriceInitial_ + tokenPriceIncremental_;
495         } else {
496             uint256 _ethereum = tokensToEthereum_(1e18);
497             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
498             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
499             return _taxedEthereum;
500         }
501     }
502     
503     /**
504      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
505      */
506     function calculateTokensReceived(uint256 _ethereumToSpend) 
507         public 
508         view 
509         returns(uint256)
510     {
511         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
512         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
513         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
514         
515         return _amountOfTokens;
516     }
517     
518     /**
519      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
520      */
521     function calculateEthereumReceived(uint256 _tokensToSell) 
522         public 
523         view 
524         returns(uint256)
525     {
526         require(_tokensToSell <= tokenSupply_);
527         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
528         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
529         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
530         return _taxedEthereum;
531     }
532 
533     
534     /*==========================================
535     =            INTERNAL FUNCTIONS            =
536     ==========================================*/
537     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
538         internal
539         returns(uint256)
540     {
541         // data setup
542         address _customerAddress = msg.sender;
543         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
544         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
545         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
546         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
547         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
548         uint256 _fee = _dividends * magnitude;
549  
550         // no point in continuing execution if OP is a poorfag russian hacker
551         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
552         // (or hackers)
553         // and yes we know that the safemath function automatically rules out the "greater than" equation.
554         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
555         
556         // is the user referred by a masternode?
557         if(
558             // is this a referred purchase?
559             _referredBy != 0x0000000000000000000000000000000000000000 &&
560             // no cheating!
561             _referredBy != _customerAddress &&
562             // does the referrer have at least X whole tokens?
563             // i.e is the referrer a godly chad masternode
564             tokenBalanceLedger_[_referredBy] >= stakingRequirement
565         ){
566             // wealth redistribution
567             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
568         } else {
569             // no ref purchase
570             // add the referral bonus back to the global dividends cake
571             _dividends = SafeMath.add(_dividends, _referralBonus);
572             _fee = _dividends * magnitude;
573         }
574         
575         // we can't give people infinite ethereum
576         if(tokenSupply_ > 0){
577             // add tokens to the pool
578             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
579             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
580             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
581             // calculate the amount of tokens the customer receives over his purchase 
582             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
583         
584         } else {
585             // add tokens to the pool
586             tokenSupply_ = _amountOfTokens;
587         }
588         
589         // update circulating supply & the ledger address for the customer
590         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
591         
592         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
593         //really i know you think you do but you don't
594         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
595         payoutsTo_[_customerAddress] += _updatedPayouts;
596         
597         // Track King Tut's & ambassadors' ethereum invested during onlyAmbassadors state
598         if (onlyAmbassadors && (_customerAddress == _MummyAccount || ambassadors_[_customerAddress])) 
599             ambassadorsEthLedger_[_customerAddress] = SafeMath.add(ambassadorsEthLedger_[_customerAddress], _incomingEthereum);
600         
601         // fire event
602         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
603         
604         return _amountOfTokens;
605     }
606 
607     /**
608      * Calculate Token price based on an amount of incoming ethereum
609      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
610      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
611      */
612     function ethereumToTokens_(uint256 _ethereum)
613         internal
614         view
615         returns(uint256)
616     {
617         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
618         uint256 _tokensReceived = 
619          (
620             (
621                 // underflow attempts BTFO
622                 SafeMath.sub(
623                     (sqrt
624                         (
625                             (_tokenPriceInitial**2)
626                             +
627                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
628                             +
629                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
630                             +
631                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
632                         )
633                     ), _tokenPriceInitial
634                 )
635             )/(tokenPriceIncremental_)
636         )-(tokenSupply_)
637         ;
638   
639         return _tokensReceived;
640     }
641     
642     /**
643      * Calculate token sell value.
644      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
645      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
646      */
647      function tokensToEthereum_(uint256 _tokens)
648         internal
649         view
650         returns(uint256)
651     {
652         uint256 tokens_ = (_tokens + 1e18);
653         uint256 _tokenSupply = (tokenSupply_ + 1e18);
654         uint256 _etherReceived =
655         (
656             // underflow attempts BTFO
657             SafeMath.sub(
658                 (
659                     (
660                         (
661                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
662                         )-tokenPriceIncremental_
663                     )*(tokens_ - 1e18)
664                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
665             )
666         /1e18);
667         return _etherReceived;
668     }
669     
670     
671     //This is where all your gas goes, sorry
672     //Not sorry, you probably only paid 1 gwei
673     function sqrt(uint x) internal pure returns (uint y) {
674         uint z = (x + 1) / 2;
675         y = x;
676         while (z < y) {
677             y = z;
678             z = (x / z + z) / 2;
679         }
680     }
681     
682 }
683 
684 /**
685  * @title SafeMath
686  * @dev Math operations with safety checks that throw on error
687  */
688 library SafeMath {
689 
690     /**
691     * @dev Multiplies two numbers, throws on overflow.
692     */
693     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
694         if (a == 0) {
695             return 0;
696         }
697         uint256 c = a * b;
698         assert(c / a == b);
699         return c;
700     }
701 
702     /**
703     * @dev Integer division of two numbers, truncating the quotient.
704     */
705     function div(uint256 a, uint256 b) internal pure returns (uint256) {
706         // assert(b > 0); // Solidity automatically throws when dividing by 0
707         uint256 c = a / b;
708         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
709         return c;
710     }
711 
712     /**
713     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
714     */
715     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
716         assert(b <= a);
717         return a - b;
718     }
719 
720     /**
721     * @dev Adds two numbers, throws on overflow.
722     */
723     function add(uint256 a, uint256 b) internal pure returns (uint256) {
724         uint256 c = a + b;
725         assert(c >= a);
726         return c;
727     }
728 
729 }