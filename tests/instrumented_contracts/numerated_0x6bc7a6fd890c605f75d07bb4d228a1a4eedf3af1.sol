1 pragma solidity ^0.4.20;
2 
3 /*
4 * ====================================*
5 *  _____   ____    ____   _______     *
6 * |  ___| / __ \  |    \ |__   __|    * 
7 * | |___ | |__| | |    /    | |       *
8 * |  ___||  __  | | |\ \    | |       *
9 * | |    | |  | | | | \ \   | |       *
10 * |_|    |_|  |_| |_|  \_\  |_|       *
11 * ====================================*
12 * 
13 * Freedom Around Revolutionary Technology
14 *
15 * Changing the humanitarian world while having fun!
16 *
17 * This source code is THE contract the crypto-community 
18 * deserves. It was cloned from POOH and perfected by the genius mind of 
19 * Kenneth Pacheco using ideas from the proof crypto-community.
20 * 
21 */
22 
23 contract FART {
24     /*=================================
25     =            MODIFIERS            =
26     =================================*/
27     // only people with tokens
28     modifier onlyTokenHolders() {
29         require(myTokens() > 0);
30         _;
31     }
32     
33     // only non-founders
34     modifier onlyNonFounders() {
35         require(foundingFARTers_[msg.sender] == false);
36         _;
37     }
38     
39     // only people with profits
40     modifier onlyStronghands() {
41         require(myDividends(true) > 0);
42         _;
43     }
44     
45     // ensures that the contract is only open to the public when the founders are ready for it to be
46     modifier areWeLive(uint256 _amountOfEthereum){
47         address _customerAddress = msg.sender;
48         
49         // are we open to the public?
50         if( onlyFounders && ((totalEthereumBalance() - _amountOfEthereum) <= preLiveTeamFoundersMaxPurchase_ )){
51             require(
52                 // is the customer in the ambassador list?
53                 foundingFARTers_[_customerAddress] == true &&
54                 
55                 // does the customer purchase exceed the max quota needed to send contract live?
56                 (contractQuotaToGoLive_[_customerAddress] + _amountOfEthereum) <= preLiveIndividualFoundersMaxPurchase_
57                 
58             );
59             
60             // update the accumulated quota    
61             contractQuotaToGoLive_[_customerAddress] = SafeMath.add(contractQuotaToGoLive_[_customerAddress], _amountOfEthereum);
62         
63             // execute
64             _;
65         } else {
66             // in case the ether count drops low, the ambassador phase won't reinitiate
67             onlyFounders = false;
68             _;    
69         }
70         
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
87         uint256 ethereumEarned,
88         address indexed charity
89     );
90     
91     event onReinvestment(
92         address indexed customerAddress,
93         uint256 ethereumReinvested,
94         uint256 tokensMinted
95     );
96     
97     event onWithdraw(
98         address indexed customerAddress,
99         uint256 ethereumWithdrawn
100     );
101     
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
112     string public name = "FART";
113     string public symbol = "FART";
114     uint8 constant public decimals = 18;
115     uint8 constant internal dividendFee_ = 15; //15% = (5% to charity + 10% divs)
116     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
117     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
118     uint256 constant internal magnitude = 2**64;
119     
120     // Referral link requirement (20 tokens instead of 5 bacause this is mainly for charity)
121     uint256 public referralLinkMinimum = 20e18; 
122     
123     // founders program (Founders initially put in 1 ETH and can add more later when contract is live)
124     mapping(address => bool) internal foundingFARTers_;
125     uint256 constant internal preLiveIndividualFoundersMaxPurchase_ = 2 ether;
126     uint256 constant internal preLiveTeamFoundersMaxPurchase_ = 3 ether;
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
137     mapping(address => uint256) internal contractQuotaToGoLive_;
138     uint256 internal tokenSupply_ = 0;
139     uint256 internal profitPerShare_;
140     
141     // administrator list (see above on what they can do)
142     mapping(bytes32 => bool) public administrators;
143     
144     // when this is set to true, only founders can purchase tokens (this prevents an errored contract from being live to the public)
145     bool public onlyFounders = true;
146     
147 
148 
149     /*=======================================
150     =            PUBLIC FUNCTIONS            =
151     =======================================*/
152     /*
153     * -- APPLICATION ENTRY POINTS --  
154     */
155     function FART()
156         public
157     {
158         
159         //No admin! True trust-less contracts don't have the ability to be alteredd! 'This is HUUUUUUUUUUGE!' - Donald Trump
160         
161         
162         // add the founders here. Founders cannot sell or transfer FART tokens, thereby making the token increase in value over time
163         foundingFARTers_[0x7e474fe5Cfb720804860215f407111183cbc2f85] = true; //Kenneth Pacheco    - https://www.linkedin.com/in/kennethpacheco/
164         foundingFARTers_[0xfD7533DA3eBc49a608eaac6200A88a34fc479C77] = true; // Micheal Slattery  - https://www.linkedin.com/in/michael-james-slattery-5b36a926/
165     }
166     
167      
168     /**
169      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
170      */
171     function buy(address _referredBy, address _charity)
172         public
173         payable
174         returns(uint256)
175     {
176         purchaseTokens(msg.value, _referredBy, _charity);
177     }
178     
179     /**
180      * Fallback function to handle ethereum that was sent straight to the contract
181      */
182     function buy()
183         payable
184         public
185     {
186         purchaseTokens(msg.value, 0x0, 0x0);
187     }
188     
189     /**
190      * Converts all of caller's dividends to tokens.
191      */
192     function reinvest()
193         onlyStronghands()//  <------Hey! We know this term!
194         public
195     {
196         // fetch dividends
197         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
198         
199         // pay out the dividends virtually
200         address _customerAddress = msg.sender;
201         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
202         
203         // retrieve ref. bonus
204         _dividends += referralBalance_[_customerAddress];
205         referralBalance_[_customerAddress] = 0;
206         
207         // dispatch a buy order with the virtualized "withdrawn dividends"
208         uint256 _tokens = purchaseTokens(_dividends, 0x0, 0x0);
209         
210         // fire event
211         onReinvestment(_customerAddress, _dividends, _tokens);
212     }
213     
214     /**
215      * Alias of sell() and withdraw().
216      */
217     function eject()
218         public
219     {
220         // get token count for caller & sell them all
221         address _customerAddress = msg.sender;
222         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
223         if(_tokens > 0) sell(_tokens, 0x0);
224         
225         // get out now
226         withdraw();
227     }
228 
229     /**
230      * Withdraws all of the callers earnings.
231      */
232     function withdraw()
233         onlyStronghands()
234         public
235     {
236         // setup data
237         address _customerAddress = msg.sender;
238         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
239         
240         // update dividend tracker
241         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
242         
243         // add ref. bonus
244         _dividends += referralBalance_[_customerAddress];
245         referralBalance_[_customerAddress] = 0;
246         
247         // lambo delivery service
248         _customerAddress.transfer(_dividends);
249         
250         // fire event
251         onWithdraw(_customerAddress, _dividends);
252     }
253     
254     /**
255      * Withdraws all of charity's earnings.
256      */
257     function withdrawForCharity(address _charity)
258         internal
259     {
260         // setup data
261         address _customerAddress = _charity;
262         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
263         
264         // update dividend tracker
265         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
266         
267         // add ref. bonus
268         _dividends += referralBalance_[_customerAddress];
269         referralBalance_[_customerAddress] = 0;
270         
271         // lambo delivery service
272         _customerAddress.transfer(_dividends);
273         
274         // fire event
275         onWithdraw(_customerAddress, _dividends);
276     }
277     
278     /**
279      * Liquifies tokens to ethereum.
280      */
281     function sell(uint256 _amountOfTokens, address _charity)
282         onlyTokenHolders() //Can't sell what you don't have
283         onlyNonFounders() //Founders can't sell tokens
284         public
285     {
286         // setup data
287         address _customerAddress = msg.sender;
288         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
289         uint256 _tokens = _amountOfTokens;
290         uint256 _ethereum = tokensToEthereum_(_tokens);
291         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
292         uint256 _charityDividends = SafeMath.div(_dividends, 3);
293         
294         if(_charity != 0x0000000000000000000000000000000000000000 && _charity != _customerAddress)//if not, it's an eject-call with no charity address
295         {    _charityDividends = SafeMath.div(_dividends, 3); // 1/3 of divs go to charity (5%)
296              _dividends = SafeMath.sub(_dividends, _charityDividends); // 2/3 of divs go to everyone (10%)
297              
298              //fire event to send to charity
299              withdrawForCharity(_charity);
300         }
301        
302         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
303         
304         // burn the sold tokens
305         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
306         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
307         
308         // update dividends tracker
309         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
310         payoutsTo_[_customerAddress] -= _updatedPayouts;       
311         
312         // dividing by zero is a bad idea
313         if (tokenSupply_ > 0) {
314             // update the amount of dividends per token
315             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
316         }
317         
318         // fire event
319         onTokenSell(_customerAddress, _tokens, _taxedEthereum, _charity);
320     }
321     
322     
323     /**
324      * Transfer tokens from the caller to a new holder.
325      * No fee to transfer because I hate doing math.
326      */
327     function transfer(address _toAddress, uint256 _amountOfTokens)
328         onlyTokenHolders() // Can't tranfer what you don't have
329         onlyNonFounders() // Founders cannot transfer their tokens to be able to sell them
330         public
331         returns(bool)
332     {
333         // setup
334         address _customerAddress = msg.sender;
335         
336         // make sure we have the requested tokens
337         // also disables transfers until ambassador phase is over
338         // ( we dont want whale premines )
339         require(!onlyFounders && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
340         
341         // withdraw all outstanding dividends first
342         if(myDividends(true) > 0) withdraw();
343 
344         // exchange tokens
345         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
346         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
347         
348         // fire event
349         Transfer(_customerAddress, _toAddress, _amountOfTokens);
350         
351         // ERC20
352         return true;
353        
354     }
355     
356     /*----------  HELPERS AND CALCULATORS  ----------*/
357     /**
358      * Method to view the current Ethereum stored in the contract
359      * Example: totalEthereumBalance()
360      */
361     function totalEthereumBalance()
362         public
363         view
364         returns(uint)
365     {
366         return address (this).balance;
367     }
368     
369     /**
370      * Retrieve the total token supply.
371      */
372     function totalSupply()
373         public
374         view
375         returns(uint256)
376     {
377         return tokenSupply_;
378     }
379     
380     /**
381      * Retrieve the tokens owned by the caller.
382      */
383     function myTokens()
384         public
385         view
386         returns(uint256)
387     {
388         address _customerAddress = msg.sender;
389         return balanceOf(_customerAddress);
390     }
391     
392     /**
393      * Retrieve the dividends owned by the caller.
394      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
395      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
396      * But in the internal calculations, we want them separate. 
397      */ 
398     function myDividends(bool _includeReferralBonus) 
399         public 
400         view 
401         returns(uint256)
402     {
403         address _customerAddress = msg.sender;
404         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
405     }
406     
407     /**
408      * Retrieve the token balance of any single address.
409      */
410     function balanceOf(address _customerAddress)
411         view
412         public
413         returns(uint256)
414     {
415         return tokenBalanceLedger_[_customerAddress];
416     }
417     
418     /**
419      * Retrieve the dividend balance of any single address.
420      */
421     function dividendsOf(address _customerAddress)
422         view
423         public
424         returns(uint256)
425     {
426         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
427     }
428     
429     /**
430      * Return the buy price of 1 individual token.
431      */
432     function sellPrice() 
433         public 
434         view 
435         returns(uint256)
436     {
437         // our calculation relies on the token supply, so we need supply. Doh.
438         if(tokenSupply_ == 0){
439             return tokenPriceInitial_ - tokenPriceIncremental_;
440         } else {
441             uint256 _ethereum = tokensToEthereum_(1e18);
442             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
443             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
444             return _taxedEthereum;
445         }
446     }
447     
448     /**
449      * Return the sell price of 1 individual token.
450      */
451     function buyPrice() 
452         public 
453         view 
454         returns(uint256)
455     {
456         // our calculation relies on the token supply, so we need supply. Doh.
457         if(tokenSupply_ == 0){
458             return tokenPriceInitial_ + tokenPriceIncremental_;
459         } else {
460             uint256 _ethereum = tokensToEthereum_(1e18);
461             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
462             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
463             return _taxedEthereum;
464         }
465     }
466     
467     /**
468      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
469      */
470     function calculateTokensReceived(uint256 _ethereumToSpend) 
471         public 
472         view 
473         returns(uint256)
474     {
475         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
476         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
477         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
478         
479         return _amountOfTokens;
480     }
481     
482     /**
483      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
484      */
485     function calculateEthereumReceived(uint256 _tokensToSell) 
486         public 
487         view 
488         returns(uint256)
489     {
490         require(_tokensToSell <= tokenSupply_);
491         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
492         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
493         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
494         return _taxedEthereum;
495     }
496     
497     
498     /*==========================================
499     =            INTERNAL FUNCTIONS            =
500     ==========================================*/
501      function purchaseTokens(uint256 _incomingEthereum, address _referredBy, address _charity)
502         areWeLive(_incomingEthereum)
503         internal
504         returns(uint256)
505     {
506         // data setup
507         address _customerAddress = msg.sender;
508         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
509         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
510         uint256 _dividends = SafeMath.sub(SafeMath.sub(_undividedDividends, _referralBonus), _referralBonus);  //subrtacting referral bonus and charity divs
511         uint256 _amountOfTokens = ethereumToTokens_(SafeMath.sub(_incomingEthereum, _undividedDividends));
512         uint256 _fee = _dividends * magnitude;
513  
514         // no point in continuing execution if OP is a poorfag russian hacker
515         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
516         // (or hackers)
517         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
518         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
519         
520         // is the user referred by a masternode?
521         if(
522             // is this a referred purchase?
523             _referredBy != 0x0000000000000000000000000000000000000000 &&
524 
525             // no cheating!
526             _referredBy != _customerAddress &&
527             
528             // does the referrer have at least X whole tokens?
529             // i.e is the referrer a godly chad masternode
530             tokenBalanceLedger_[_referredBy] >= referralLinkMinimum
531         ){
532             // wealth redistribution
533             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
534         } else {
535             // no ref purchase
536             // add the referral bonus back to the global dividends cake
537             _dividends = SafeMath.add(_dividends, SafeMath.div(_undividedDividends, 3));
538             _fee = _dividends * magnitude;
539         }
540         
541         //Let's check for foul play with the charity address
542         if(
543             // is this a referred purchase?
544             _charity != 0x0000000000000000000000000000000000000000 &&
545 
546             // no cheating!
547             _charity != _customerAddress 
548         ){
549             // charity redistribution
550             referralBalance_[_charity] = SafeMath.add(referralBalance_[_charity], _referralBonus);
551              // fire event to send charity proceeds
552             withdrawForCharity(_charity);
553             
554         } else 
555         {
556             // no ref purchase
557             // add the referral bonus back to the global dividends
558             _dividends = SafeMath.add(_dividends, _referralBonus);
559             _fee = _dividends * magnitude;
560         }
561         
562         // we can't give people infinite ethereum
563         if(tokenSupply_ > 0){
564             
565             // add tokens to the pool
566             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
567  
568             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
569             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
570             
571             // calculate the amount of tokens the customer receives over his purchase 
572             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
573         
574         } else {
575             // add tokens to the pool
576             tokenSupply_ = _amountOfTokens;
577         }
578         
579         // update circulating supply & the ledger address for the customer
580         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
581         
582         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
583         //really i know you think you do but you don't
584         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
585         payoutsTo_[_customerAddress] += _updatedPayouts;
586         
587         
588         // fire event
589         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
590         
591         return _amountOfTokens;
592     }
593     
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
715         
716         // If you have read all the way to here, thank you.  You are one of the good players that does their OWN resarch! Way to go!
717     }
718 }