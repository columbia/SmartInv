1 pragma solidity ^0.4.25;
2 
3 
4 contract Hourglass {
5     /*=================================
6     =            MODIFIERS            =
7     =================================*/
8     // only people with tokens
9     modifier onlyBagholders() {
10         require(myTokens() > 0);
11         _;
12     }
13     
14     // only people with profits
15     modifier onlyStronghands() {
16         require(myDividends(true) > 0);
17         _;
18     }
19     
20     // administrator can:
21     // -> change the name of the contract
22     // -> change the name of the token
23     // -> change the PoS difficulty (How many tokens it costs to be a referrer, in case it gets crazy high later)
24     // they CANNOT:
25     // -> take funds
26     // -> disable withdrawals
27     // -> kill the contract
28     // -> change the price of tokens
29     modifier onlyAdministrator(){
30         address _customerAddress = msg.sender;
31         require(admin_ == _customerAddress);
32         _;
33     }
34     
35     
36     
37     /*==============================
38     =            EVENTS            =
39     ==============================*/
40     event onTokenPurchase(
41         address indexed customerAddress,
42         uint256 incomingEthereum,
43         uint256 tokensMinted,
44         address indexed referredBy
45     );
46     
47     event onTokenSell(
48         address indexed customerAddress,
49         uint256 tokensBurned,
50         uint256 ethereumEarned
51     );
52     
53     event onReinvestment(
54         address indexed customerAddress,
55         uint256 ethereumReinvested,
56         uint256 tokensMinted
57     );
58     
59     event onWithdraw(
60         address indexed customerAddress,
61         uint256 ethereumWithdrawn
62     );
63     
64     // ERC20
65     event Transfer(
66         address indexed from,
67         address indexed to,
68         uint256 tokens
69     );
70     
71     
72     /*=====================================
73     =            CONFIGURABLES            =
74     =====================================*/
75     string public name = "E3D";
76     string public symbol = "E3D";
77     uint8 constant public decimals = 18;
78     uint8 constant internal dividendFee_ = 30;
79     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
80     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
81     uint256 constant internal magnitude = 2**64;
82     
83     // proof of stake (defaults at 100 tokens)
84     uint256 public stakingRequirement = 100e18;
85    
86    //admin details
87     address private admin_;
88     
89     
90     
91    /*================================
92     =            DATASETS            =
93     ================================*/
94     // amount of shares for each address (scaled number)
95     mapping(address => uint256) internal tokenBalanceLedger_;
96     mapping(address => uint256) internal referralBalance_;
97     mapping(address => int256) internal payoutsTo_;
98     mapping(address => address) internal firstReferrer;
99     uint256 internal tokenSupply_ = 0;
100     uint256 internal profitPerShare_;
101     
102     /*=======================================
103     =            PUBLIC FUNCTIONS            =
104     =======================================*/
105     /*
106     * -- APPLICATION ENTRY POINTS --  
107     */
108     constructor()
109         public
110     {
111         // add administrator here
112         admin_ = msg.sender;
113         
114     }
115 
116     
117      
118     /**
119      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
120      */
121     function buy(address _referredBy)
122         public
123         payable
124         returns(uint256)
125     {
126         purchaseTokens(msg.value, _referredBy);
127     }
128     
129     /**
130      * Fallback function to handle ethereum that was send straight to the contract
131      * Unfortunately we cannot use a referral address this way.
132      */
133     function()
134         payable
135         public
136     {
137         purchaseTokens(msg.value, 0x0);
138     }
139     
140     /**
141      * Converts all of caller's dividends to tokens.
142      */
143     function reinvest()
144         onlyStronghands()
145         public
146     {
147         // fetch dividends
148         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
149         
150         // pay out the dividends virtually
151         address _customerAddress = msg.sender;
152         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
153         
154         // retrieve ref. bonus
155         _dividends += referralBalance_[_customerAddress];
156         referralBalance_[_customerAddress] = 0;
157         
158         // dispatch a buy order with the virtualized "withdrawn dividends"
159         uint256 _tokens = purchaseTokens(_dividends, 0x0);
160         
161         // fire event
162         emit onReinvestment(_customerAddress, _dividends, _tokens);
163     }
164     
165     /**
166      * Alias of sell() and withdraw().
167      */
168     function exit()
169         public
170     {
171         // get token count for caller & sell them all
172         address _customerAddress = msg.sender;
173         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
174         if(_tokens > 0) sell(_tokens);
175         
176         // lambo delivery service
177         withdraw();
178     }
179 
180     /**
181      * Withdraws all of the callers earnings.
182      */
183     function withdraw()
184         onlyStronghands()
185         public
186     {
187         // setup data
188         address _customerAddress = msg.sender;
189         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
190         
191         // update dividend tracker
192         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
193         
194         // add ref. bonus
195         _dividends += referralBalance_[_customerAddress];
196         referralBalance_[_customerAddress] = 0;
197         
198         // lambo delivery service
199         _customerAddress.transfer(_dividends);
200         
201         // fire event
202         emit onWithdraw(_customerAddress, _dividends);
203     }
204     
205     /**
206      * Liquifies tokens to ethereum.
207      */
208     function sell(uint256 _amountOfTokens)
209         onlyBagholders()
210         public
211     {
212         // setup data
213         address _customerAddress = msg.sender;
214        //should have the balance to sell
215         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
216         uint256 _tokens = _amountOfTokens;
217         uint256 _ethereum = tokensToEthereum_(_tokens);
218         uint256 _dividends = SafeMath.div(_ethereum, 10);
219         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
220         uint256 _adminFees = SafeMath.div(SafeMath.mul(_dividends,3),100);
221         uint256 _finalDividends = SafeMath.sub(_dividends,_adminFees);
222         
223         // burn the sold tokens
224         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
225         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
226 
227         //Transfer admin fees
228         admin_.transfer(_adminFees);
229         
230         
231         // update dividends tracker
232         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
233         payoutsTo_[_customerAddress] -= _updatedPayouts;       
234         
235         // dividing by zero is a bad idea
236         if (tokenSupply_ > 0) {
237             // update the amount of dividends per token
238             profitPerShare_ = SafeMath.add(profitPerShare_, (_finalDividends * magnitude) / tokenSupply_);
239         }
240         
241         // fire event
242         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
243     }
244     
245     
246     /**
247      * Transfer tokens from the caller to a new holder.
248      * Remember, there's a 10% fee here as well.
249      */
250     function transfer(address _toAddress, uint256 _amountOfTokens)
251         onlyBagholders()
252         public
253         returns(bool)
254     {
255         // setup
256         address _customerAddress = msg.sender;
257         
258         // make sure we have the requested tokens
259         // ( we dont want whale premines )
260         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
261         
262         // withdraw all outstanding dividends first
263         if(myDividends(true) > 0) withdraw();
264         
265         // liquify 10% of the tokens that are transfered
266         // these are dispersed to shareholders
267         uint256 _tokenFee = SafeMath.div(_amountOfTokens, 10);
268         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
269         uint256 _dividends = tokensToEthereum_(_tokenFee);
270   
271         // burn the fee tokens
272         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
273 
274         // exchange tokens
275         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
276         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
277         
278         // update dividend trackers
279         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
280         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
281         
282         // disperse dividends among holders
283         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
284         
285         // fire event
286         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
287         
288         // ERC20
289         return true;
290        
291     }
292     
293     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
294     
295     /**
296      * Admin can change the admin
297     */
298     
299     function changeAdmin(address _newAdmin) 
300     onlyAdministrator() 
301     public 
302     {
303         require(_newAdmin != address(0));
304         admin_ = _newAdmin;
305     }
306     
307     /**
308      * Precautionary measures in case we need to adjust the masternode rate.
309      */
310     function setStakingRequirement(uint256 _amountOfTokens)
311         onlyAdministrator()
312         public
313     {
314         stakingRequirement = _amountOfTokens;
315     }
316     
317     /**
318      * If we want to rebrand, we can.
319      */
320     function setName(string _name)
321         onlyAdministrator()
322         public
323     {
324         name = _name;
325     }
326     
327     /**
328      * If we want to rebrand, we can.
329      */
330     function setSymbol(string _symbol)
331         onlyAdministrator()
332         public
333     {
334         symbol = _symbol;
335     }
336 
337     
338     /*----------  HELPERS AND CALCULATORS  ----------*/
339     /**
340      * Method to view the current Ethereum stored in the contract
341      * Example: totalEthereumBalance()
342      */
343     function totalEthereumBalance()
344         public
345         view
346         returns(uint)
347     {
348         return address(this).balance;
349     }
350     
351     /**
352      * Retrieve the total token supply.
353      */
354     function totalSupply()
355         public
356         view
357         returns(uint256)
358     {
359         return tokenSupply_;
360     }
361     
362     /**
363      * Retrieve the tokens owned by the caller.
364      */
365     function myTokens()
366         public
367         view
368         returns(uint256)
369     {
370         address _customerAddress = msg.sender;
371         return balanceOf(_customerAddress);
372     }
373     
374     /**
375      * Retrieve the dividends owned by the caller.
376      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
377      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
378      * But in the internal calculations, we want them separate. 
379      */ 
380     function myDividends(bool _includeReferralBonus) 
381         public 
382         view 
383         returns(uint256)
384     {
385         address _customerAddress = msg.sender;
386         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
387     }
388     
389     /**
390      * Retrieve the token balance of any single address.
391      */
392     function balanceOf(address _customerAddress)
393         view
394         public
395         returns(uint256)
396     {
397         return tokenBalanceLedger_[_customerAddress];
398     }
399     
400     /**
401      * Retrieve the dividend balance of any single address.
402      */
403     function dividendsOf(address _customerAddress)
404         view
405         public
406         returns(uint256)
407     {
408         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
409     }
410     
411     /**
412      * Return the buy price of 1 individual token.
413      */
414     function sellPrice() 
415         public 
416         view 
417         returns(uint256)
418     {
419         // our calculation relies on the token supply, so we need supply. Doh.
420         if(tokenSupply_ == 0){
421             return tokenPriceInitial_ - tokenPriceIncremental_;
422         } else {
423             uint256 _ethereum = tokensToEthereum_(1e18);
424             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
425             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
426             return _taxedEthereum;
427         }
428     }
429     
430     /**
431      * Return the sell price of 1 individual token.
432      */
433     function buyPrice() 
434         public 
435         view 
436         returns(uint256)
437     {
438         // our calculation relies on the token supply, so we need supply. Doh.
439         if(tokenSupply_ == 0){
440             return tokenPriceInitial_ + tokenPriceIncremental_;
441         } else {
442             uint256 _ethereum = tokensToEthereum_(1e18);
443             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
444             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
445             return _taxedEthereum;
446         }
447     }
448     
449     /**
450      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
451      */
452     function calculateTokensReceived(uint256 _ethereumToSpend) 
453         public 
454         view 
455         returns(uint256)
456     {
457         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
458         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
459         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
460         
461         return _amountOfTokens;
462     }
463     
464     /**
465      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
466      */
467     function calculateEthereumReceived(uint256 _tokensToSell) 
468         public 
469         view 
470         returns(uint256)
471     {
472         require(_tokensToSell <= tokenSupply_);
473         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
474         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
475         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
476         return _taxedEthereum;
477     }
478     
479     
480     /*==========================================
481     =            INTERNAL FUNCTIONS            =
482     ==========================================*/
483     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
484         internal
485         returns(uint256)
486     {
487         // data setup
488         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum,dividendFee_),100); //this is the taxed amount as 30% of total investment
489         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, 40),100); //To be given to the referrers
490         uint256 _dividends = SafeMath.div(_undividedDividends, 2); //To be distributed among current holders
491         uint256 adminFees = SafeMath.div(_undividedDividends,10); //To be transferred to admin
492         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends); //Amount for which the user will get the tokens
493         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum); //number of tokens as per current rate
494         uint256 _fee = _dividends * magnitude;
495  
496         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
497         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
498        
499         if(!calculateReferralBonus(_referralBonus, _referredBy)) {
500             // no ref purchase
501             // add the referral bonus back to the global dividends cake
502             _dividends = SafeMath.add(_dividends, _referralBonus);
503             _fee = _dividends * magnitude;
504         }
505                
506         // we can't give people infinite ethereum
507         if(tokenSupply_ > 0){
508             
509             // add tokens to the pool
510             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
511  
512             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
513             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
514             
515             // calculate the amount of tokens the customer receives over his purchase 
516             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
517         
518         } else {
519             // add tokens to the pool
520             tokenSupply_ = _amountOfTokens;
521         }
522         
523         // update circulating supply & the ledger address for the customer
524         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
525         
526         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
527         //really i know you think you do but you don't
528         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
529         payoutsTo_[msg.sender] += _updatedPayouts;
530         admin_.transfer(adminFees);
531         
532         // fire event
533         emit onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
534         
535         return _amountOfTokens;
536     }
537     
538     
539      function calculateReferralBonus(uint256 _referralBonus, address _referredBy) private returns(bool) {
540 
541          if(
542             // is this a referred purchase?
543             _referredBy != 0x0000000000000000000000000000000000000000 &&
544 
545             // Ohoo noo, you can't refer yourself buddy :P
546             _referredBy != msg.sender &&
547             
548             // does the referrer fulfill the staking requirement for referrals
549             
550             tokenBalanceLedger_[_referredBy] >= stakingRequirement
551         ) {
552             //If the user has already been referred by someone previously, can't be referred by someone else
553             if(firstReferrer[msg.sender] != 0x0000000000000000000000000000000000000000) {
554                     _referredBy  = firstReferrer[msg.sender];
555             }  
556             else {
557                 firstReferrer[msg.sender] = _referredBy;
558             }  
559                 
560         //check for second referrer
561             if(firstReferrer[_referredBy] != 0x0000000000000000000000000000000000000000)
562             { 
563                 address _secondReferrer = firstReferrer[_referredBy];
564                 //check for third referrer
565                 if(firstReferrer[_secondReferrer] != 0x0000000000000000000000000000000000000000) {
566                     address _thirdReferrer = firstReferrer[_secondReferrer];
567 
568                     //transfer 20% to third referrer
569                     referralBalance_[_thirdReferrer] = SafeMath.add(referralBalance_[_thirdReferrer], SafeMath.div(SafeMath.mul(_referralBonus,20),100));
570                     //transfer 30% to second referrer
571                     referralBalance_[_secondReferrer] = SafeMath.add(referralBalance_[_secondReferrer], SafeMath.div(SafeMath.mul(_referralBonus,30),100));
572                     //transfer 50% to first referrer
573                     referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(_referralBonus,2));
574                 }
575                 //No Third Referrer then transfer to first and second referrer
576                 else {
577                     //transfer 40% to second referrer
578                     referralBalance_[_secondReferrer] = SafeMath.add(referralBalance_[_secondReferrer], SafeMath.div(SafeMath.mul(_referralBonus,40),100));
579                     //transfer 60% to first referrer
580                     referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_referralBonus,60),100));
581                 }
582             } //no second referrer then transfer all to the first referrer
583             else {
584                 referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
585             }
586             return true;
587     }
588     //might be possible that the referrer is 0x0 but previously someone has referred the user
589     else if(
590             //0x0 coming from the UI
591             _referredBy == 0x0000000000000000000000000000000000000000 &&
592             
593             //check if the somone has previously referred the user
594             firstReferrer[msg.sender] != 0x0000000000000000000000000000000000000000 &&
595 
596             //The referrer should always has the staking requirement for referring
597             tokenBalanceLedger_[firstReferrer[msg.sender]] >= stakingRequirement
598 
599         ) {
600            //check for second referrer
601             if(firstReferrer[_referredBy] != 0x0000000000000000000000000000000000000000)
602             { 
603                 address _secondReferrer1 = firstReferrer[_referredBy];
604                 //check for third referrer
605                 if(firstReferrer[_secondReferrer1] != 0x0000000000000000000000000000000000000000) {
606                     address _thirdReferrer1 = firstReferrer[_secondReferrer1];
607 
608                     //transfer 20% to third referrer
609                     referralBalance_[_thirdReferrer1] = SafeMath.add(referralBalance_[_thirdReferrer1], SafeMath.div(SafeMath.mul(_referralBonus,20),100));
610                     //transfer 30% to second referrer
611                     referralBalance_[_secondReferrer1] = SafeMath.add(referralBalance_[_secondReferrer1], SafeMath.div(SafeMath.mul(_referralBonus,30),100));
612                     //transfer 50% to first referrer
613                     referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(_referralBonus,2));
614                 }
615                 //No Third Referrer then transfer to first and second referrer
616                 else {
617                     //transfer 40% to second referrer
618                     referralBalance_[_secondReferrer1] = SafeMath.add(referralBalance_[_secondReferrer1], SafeMath.div(SafeMath.mul(_referralBonus,40),100));
619                     //transfer 60% to first referrer
620                     referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], SafeMath.div(SafeMath.mul(_referralBonus,40),100));
621                 }
622             } //no second referrer then transfer all to the first referrer
623             else {
624                 referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
625             }
626             return true;
627         }
628         return false;
629      }
630 
631     /**
632      * Calculate Token price based on an amount of incoming ethereum
633      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
634      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
635      */
636     function ethereumToTokens_(uint256 _ethereum)
637         internal
638         view
639         returns(uint256)
640     {
641         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
642         uint256 _tokensReceived = 
643          (
644             (
645                 // underflow attempts BTFO
646                 SafeMath.sub(
647                     (sqrt
648                         (
649                             (_tokenPriceInitial**2)
650                             +
651                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
652                             +
653                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
654                             +
655                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
656                         )
657                     ), _tokenPriceInitial
658                 )
659             )/(tokenPriceIncremental_)
660         )-(tokenSupply_)
661         ;
662   
663         return _tokensReceived;
664     }
665     
666     /**
667      * Calculate token sell value.
668      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
669      */
670      function tokensToEthereum_(uint256 _tokens)
671         internal
672         view
673         returns(uint256)
674     {
675 
676         uint256 tokens_ = (_tokens + 1e18);
677         uint256 _tokenSupply = (tokenSupply_ + 1e18);
678         uint256 _etherReceived =
679         (
680             // underflow attempts BTFO
681             SafeMath.sub(
682                 (
683                     (
684                         (
685                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
686                         )-tokenPriceIncremental_
687                     )*(tokens_ - 1e18)
688                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
689             )
690         /1e18);
691         return _etherReceived;
692     }
693     
694     
695     //This is where all your gas goes, sorry
696     //Not sorry, you probably only paid 1 gwei
697     function sqrt(uint x) internal pure returns (uint y) {
698         uint z = (x + 1) / 2;
699         y = x;
700         while (z < y) {
701             y = z;
702             z = (x / z + z) / 2;
703         }
704     }
705 }
706 
707 /**
708  * @title SafeMath
709  * @dev Math operations with safety checks that throw on error
710  */
711 library SafeMath {
712 
713     /**
714     * @dev Multiplies two numbers, throws on overflow.
715     */
716     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
717         if (a == 0) {
718             return 0;
719         }
720         uint256 c = a * b;
721         assert(c / a == b);
722         return c;
723     }
724 
725     /**
726     * @dev Integer division of two numbers, truncating the quotient.
727     */
728     function div(uint256 a, uint256 b) internal pure returns (uint256) {
729         // assert(b > 0); // Solidity automatically throws when dividing by 0
730         uint256 c = a / b;
731         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
732         return c;
733     }
734 
735     /**
736     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
737     */
738     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
739         assert(b <= a);
740         return a - b;
741     }
742 
743     /**
744     * @dev Adds two numbers, throws on overflow.
745     */
746     function add(uint256 a, uint256 b) internal pure returns (uint256) {
747         uint256 c = a + b;
748         assert(c >= a);
749         return c;
750     }
751 }