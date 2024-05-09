1 pragma solidity ^0.4.21;
2 
3 /*
4 * BeNow
5 *
6 * You are 100% responsible for auditing this contract code. 
7 * If there's a flaw in this code and you lose ETH, you are 100% responsible.
8 *
9 */
10 
11 contract Hourglass {
12     /*=================================
13     =            MODIFIERS            =
14     =================================*/
15     // only people with tokens
16     modifier onlyBagholders() {
17         require(myTokens() > 0);
18         _;
19     }
20 
21     // only people with profits
22     modifier onlyStronghands() {
23         require(myDividends() > 0);
24         _;
25     }
26 
27     // administrators can:
28     // -> change the name of the contract
29     // -> change the name of the token
30     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
31     // they CANNOT:
32     // -> take funds
33     // -> disable withdrawals
34     // -> kill the contract
35     // -> change the price of tokens
36     modifier onlyAdministrator(){
37         address _customerAddress = msg.sender;
38         require(administrators[_customerAddress]);
39         _;
40     }
41 
42 
43     // ensures that the first tokens in the contract will be equally distributed
44     // meaning, no divine dump will be ever possible
45     // result: healthy longevity.
46     modifier antiEarlyWhale(uint256 _amountOfEthereum){
47         address _customerAddress = msg.sender;
48 
49         // are we still in the vulnerable phase?
50         // if so, enact anti early whale protocol
51         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
52             require(
53                 // is the customer in the ambassador list?
54                 ambassadors_[_customerAddress] == true &&
55 
56                 // does the customer purchase exceed the max ambassador quota?
57                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
58 
59             );
60 
61             // updated the accumulated quota
62             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
63 
64             // execute
65             _;
66         } else {
67             // in case the ether count drops low, the ambassador phase won't reinitiate
68             onlyAmbassadors = false;
69             _;
70         }
71 
72     }
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
112     string public name = "BeNOW";
113     string public symbol = "NOW";
114     uint8 constant public decimals = 18;
115     uint8 constant internal dividendFee_ = 20;
116     uint8 constant internal developerFee_ = 2;
117     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
118     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
119     uint256 constant internal magnitude = 2**64;
120 
121     address constant public developerFundAddress = 0xc22388e302ac17c7a2b87a9a3e7325febd4e2458;
122     uint256 public totalDevelopmentFundBalance;
123     uint256 public totalDevelopmentFundEarned;
124     
125     bool firstBuy = true;
126 
127     // proof of stake (defaults at 100 tokens)
128     uint256 public stakingRequirement = 100e18;
129 
130     // ambassador program
131     mapping(address => bool) internal ambassadors_;
132     uint256 constant internal ambassadorMaxPurchase_ = 3 ether;
133     uint256 constant internal ambassadorQuota_ = 40 ether;
134     
135     // saved savedReferrals
136     mapping(address => address) internal savedReferrals_;
137     
138     // total earned for referrals
139     mapping(address => uint256) internal totalEarned_;
140 
141 
142 
143    /*================================
144     =            DATASETS            =
145     ================================*/
146     // amount of shares for each address (scaled number)
147     mapping(address => uint256) internal tokenBalanceLedger_;
148     mapping(address => uint256) internal referralBalance_;
149     mapping(address => int256) internal payoutsTo_;
150     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
151     uint256 internal tokenSupply_ = 0;
152     uint256 internal profitPerShare_;
153 
154     // administrator list (see above on what they can do)
155     mapping(address => bool) public administrators;
156 
157     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
158     bool public onlyAmbassadors = true;
159 
160     /*=======================================
161     =            PUBLIC FUNCTIONS            =
162     =======================================*/
163     /*
164     * -- APPLICATION ENTRY POINTS --
165     */
166     function Hourglass()
167         public
168     {
169         // add administrators here
170         administrators[developerFundAddress] = true;
171 
172         ambassadors_[0xA36f907BE1FBf75e2495Cc87F8f4D201c1b634Af] = true;
173         ambassadors_[0x5Ec92834A6bc25Fe70DE9483F6F4B1051fcc0C96] = true;
174         ambassadors_[0xe8B1C589e86DEf7563aD43BebDDB7B1677beC9A9] = true;
175         ambassadors_[0x4da6fc68499FB3753e77DD6871F2A0e4DC02fEbE] = true;
176         ambassadors_[0x8E2a227eC573dd2Ef11c5B0B7985cb3d9ADf06b3] = true;
177         ambassadors_[0xD795b28e43a14d395DDF608eaC6906018e3AF0fC] = true;
178         ambassadors_[0xD01167b13444E3A75c415d644C832Ab8FC3fc742] = true;
179         ambassadors_[0x46091f77b224576E224796de5c50e8120Ad7D764] = true;
180         ambassadors_[0x871A93B4046545CCff4F1e41EedFC52A6acCbc42] = true;
181         ambassadors_[0xcbbcf632C87D3dF7342642525Cc5F30090E390a6] = true;
182         ambassadors_[0x025fb7cad32448571150de24ac254fe8d9c10c50] = true;
183         ambassadors_[0xe196F7c242dE1F42B10c262558712e6268834008] = true;
184         ambassadors_[0x4ffe17a2a72bc7422cb176bc71c04ee6d87ce329] = true;
185         ambassadors_[0x867e1996C36f57545C365B33edd48923873792F6] = true;
186         ambassadors_[0x1ef88e2858fb1052180e2a372d94f24bcb8cc5b0] = true;
187         ambassadors_[0x642e0Ce9AE8c0D8007e0ACAF82C8D716FF8c74c1] = true;
188         ambassadors_[0x26d8627dbFF586A3B769f34DaAd6085Ef13B2978] = true;
189         ambassadors_[0x9abcf6b5ae277c1a4a14f3db48c89b59d831dc8f] = true;
190         ambassadors_[0x847c5b4024C19547BCa7EFD503EbbB97f500f4C0] = true;
191         ambassadors_[0x19e361e3CF55bAD433Ed107997728849b172a139] = true;
192         ambassadors_[0x008ca4F1bA79D1A265617c6206d7884ee8108a78] = true;
193         ambassadors_[0xE7F53CE9421670AC2f11C5035E6f6f13d9829aa6] = true;
194         ambassadors_[0x63913b8B5C6438f23c986aD6FdF103523B17fb90] = true;
195         ambassadors_[0x43593BCFC24301da0763ED18845A120FaEC1EAfE] = true;
196         ambassadors_[0x87A7e71D145187eE9aAdc86954d39cf0e9446751] = true;
197         ambassadors_[0x7c76A64AC61D1eeaFE2B8AF6F7f0a6a1890418F3] = true;
198         ambassadors_[0xb0eF8673E22849bB45B3c97226C11a33394eEec1] = true;
199         ambassadors_[0xc585ca6a9B9C0d99457B401f8e2FD12048713cbc] = true;
200         
201     }
202 
203 
204     /**
205      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
206      */
207     function buy(address _referredBy)
208         public
209         payable
210         returns(uint256)
211     {
212         
213         require(msg.value >= .1 ether);
214         
215         if(savedReferrals_[msg.sender] == 0x0000000000000000000000000000000000000000){
216             savedReferrals_[msg.sender] = _referredBy;
217         }else{
218             _referredBy = savedReferrals_[msg.sender];
219         }
220         
221         purchaseTokens(msg.value, savedReferrals_[msg.sender]);
222     }
223 
224     /**
225      * Fallback function to handle ethereum that was send straight to the contract
226      * Unfortunately we cannot use a referral address this way.
227      */
228     function()
229         payable
230         public
231     {
232         purchaseTokens(msg.value, savedReferrals_[msg.sender]);
233     }
234 
235     /**
236      * Converts all of caller's dividends to tokens.
237      */
238     function reinvest()
239         onlyStronghands()
240         public
241     {
242         // fetch dividends
243         uint256 _dividends = myDividends(); // retrieve ref. bonus later in the code
244 
245         // pay out the dividends virtually
246         address _customerAddress = msg.sender;
247         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
248 
249         // dispatch a buy order with the virtualized "withdrawn dividends"
250         uint256 _tokens = purchaseTokensWithoutDevelopmentFund(_dividends, savedReferrals_[msg.sender]);
251 
252         // fire event
253         onReinvestment(_customerAddress, _dividends, _tokens);
254     }
255     
256     /**
257      * Converts all of caller's affiliate rewards to tokens.
258      */
259     function reinvestAffiliate()
260         public
261     {
262         
263         require(referralBalance_[msg.sender] > 0);
264         
265         // fetch rewards
266         uint256 _dividends = referralBalance_[msg.sender];
267         referralBalance_[msg.sender] = 0;
268         
269         address _customerAddress = msg.sender;
270 
271         // dispatch a buy order with the virtualized "withdrawn dividends"
272         uint256 _tokens = purchaseTokensWithoutDevelopmentFund(_dividends, savedReferrals_[msg.sender]);
273 
274         // fire event
275         onReinvestment(_customerAddress, _dividends, _tokens);
276     }
277 
278     /**
279      * Alias of sell() and withdraw().
280      */
281     function exit()
282         public
283     {
284         // get token count for caller & sell them all
285         address _customerAddress = msg.sender;
286         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
287         if(_tokens > 0) sell(_tokens);
288 
289         // lambo delivery service
290         withdraw();
291     }
292     
293     /**
294      *  Returns the saved referral.
295      */ 
296      function getSavedReferral(address customer) public view returns (address) {
297          return savedReferrals_[customer];
298      }
299      
300      /**
301      *  Returns the total referral commision earned.
302      */ 
303      function getTotalComission(address customer) public view returns (uint256) {
304          return totalEarned_[customer];
305      }
306      
307      /**
308      *  Returns the development fund balance.
309      */ 
310      function getDevelopmentFundBalance() public view returns (uint256) {
311          return totalDevelopmentFundBalance;
312      }
313      
314      /**
315      *  Returns the total amount development fund has earned.
316      */ 
317      function getTotalDevelopmentFundEarned() public view returns (uint256) {
318          return totalDevelopmentFundEarned;
319      }
320      
321      /**
322      *  Returns affiliate commision.
323      */ 
324      function getReferralBalance() public view returns (uint256) {
325          return referralBalance_[msg.sender];
326      }
327     
328      
329      /**
330      *  Withdraw development fund.
331      */ 
332      function withdrawTotalDevEarned() public {
333          require(msg.sender == developerFundAddress);
334          developerFundAddress.transfer(totalDevelopmentFundBalance);
335          totalDevelopmentFundBalance = 0;
336      }
337 
338     /**
339      * Withdraws all of the callers earnings.
340      */
341     function withdraw()
342         onlyStronghands()
343         public
344     {
345         
346         require(!onlyAmbassadors);
347         
348         // setup data
349         address _customerAddress = msg.sender;
350         uint256 _dividends = myDividends(); // get ref. bonus later in the code
351 
352         // update dividend tracker
353         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
354 
355         // lambo delivery service
356         _customerAddress.transfer(_dividends);
357 
358         // fire event
359         onWithdraw(_customerAddress, _dividends);
360     }
361     
362     /**
363      * Withdraws affiliate earnings
364      */
365     function withdrawAffiliateRewards()
366         onlyStronghands()
367         public
368     {
369         
370         require(!onlyAmbassadors);
371         
372         // setup data
373         address _customerAddress = msg.sender;
374         uint256 _dividends = referralBalance_[_customerAddress];
375         
376         referralBalance_[_customerAddress] = 0;
377         
378         // lambo delivery service
379         _customerAddress.transfer(_dividends);
380         
381         // fire event
382         onWithdraw(_customerAddress, _dividends);
383     }
384 
385     /**
386      * Liquifies tokens to ethereum.
387      */
388     function sell(uint256 _amountOfTokens)
389         onlyBagholders()
390         public
391     {
392         
393         require(_amountOfTokens >= 40 && !onlyAmbassadors);
394         
395         if(ambassadors_[msg.sender] == true){
396             require(1529260200 < now);
397         }
398         
399         // setup data
400         address _customerAddress = msg.sender;
401         // russian hackers BTFO
402         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
403         uint256 _tokens = _amountOfTokens;
404         uint256 _ethereum = tokensToEthereum_(_tokens);
405 
406         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
407         uint256 _devFund = SafeMath.div(SafeMath.mul(_ethereum, developerFee_), 100);
408 
409         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _devFund);
410 
411         totalDevelopmentFundBalance = SafeMath.add(totalDevelopmentFundBalance, _devFund);
412         totalDevelopmentFundEarned = SafeMath.add(totalDevelopmentFundEarned, _devFund);
413 
414         // burn the sold tokens
415         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
416         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
417 
418         // update dividends tracker
419         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
420         payoutsTo_[_customerAddress] -= _updatedPayouts;
421 
422         // dividing by zero is a bad idea
423         if (tokenSupply_ > 0) {
424             // update the amount of dividends per token
425             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
426         }
427 
428         // fire event
429         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
430     }
431 
432 
433     /**
434      * Transfer tokens from the caller to a new holder.
435      */
436     function transfer(address _toAddress, uint256 _amountOfTokens)
437         onlyBagholders()
438         public
439         returns(bool)
440     {
441         
442         if(ambassadors_[msg.sender] == true){
443             require(1529260200 < now);
444         }
445         
446         // setup
447         address _customerAddress = msg.sender;
448 
449         // make sure we have the requested tokens
450         // also disables transfers until ambassador phase is over
451         // ( we dont want whale premines )
452         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
453 
454         // withdraw all outstanding dividends first
455         if(myDividends() > 0) withdraw();
456 
457         // exchange tokens
458         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
459         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
460 
461         // update dividend trackers
462         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
463         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
464 
465 
466         // fire event
467         Transfer(_customerAddress, _toAddress, _amountOfTokens);
468 
469         // ERC20
470         return true;
471     }
472 
473     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
474     /**
475      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
476      */
477     function disableInitialStage()
478         onlyAdministrator()
479         public
480     {
481         onlyAmbassadors = false;
482     }
483 
484     /**
485      * In case one of us dies, we need to replace ourselves.
486      */
487     function setAdministrator(address _identifier, bool _status)
488         onlyAdministrator()
489         public
490     {
491         administrators[_identifier] = _status;
492     }
493 
494     /**
495      * Precautionary measures in case we need to adjust the masternode rate.
496      */
497     function setStakingRequirement(uint256 _amountOfTokens)
498         onlyAdministrator()
499         public
500     {
501         stakingRequirement = _amountOfTokens;
502     }
503 
504     /**
505      * If we want to rebrand, we can.
506      */
507     function setName(string _name)
508         onlyAdministrator()
509         public
510     {
511         name = _name;
512     }
513 
514     /**
515      * If we want to rebrand, we can.
516      */
517     function setSymbol(string _symbol)
518         onlyAdministrator()
519         public
520     {
521         symbol = _symbol;
522     }
523 
524 
525     /*----------  HELPERS AND CALCULATORS  ----------*/
526     /**
527      * Method to view the current Ethereum stored in the contract
528      * Example: totalEthereumBalance()
529      */
530     function totalEthereumBalance()
531         public
532         view
533         returns(uint)
534     {
535         return this.balance;
536     }
537 
538     /**
539      * Retrieve the total token supply.
540      */
541     function totalSupply()
542         public
543         view
544         returns(uint256)
545     {
546         return tokenSupply_;
547     }
548 
549     /**
550      * Retrieve the tokens owned by the caller.
551      */
552     function myTokens()
553         public
554         view
555         returns(uint256)
556     {
557         address _customerAddress = msg.sender;
558         return balanceOf(_customerAddress);
559     }
560 
561     /**
562      * Retrieve the dividends owned by the caller.
563      */
564     function myDividends()
565         public
566         view
567         returns(uint256)
568     {
569         address _customerAddress = msg.sender;
570         return dividendsOf(_customerAddress) ;
571     }
572 
573     /**
574      * Retrieve the token balance of any single address.
575      */
576     function balanceOf(address _customerAddress)
577         view
578         public
579         returns(uint256)
580     {
581         return tokenBalanceLedger_[_customerAddress];
582     }
583 
584     /**
585      * Retrieve the dividend balance of any single address.
586      */
587     function dividendsOf(address _customerAddress)
588         view
589         public
590         returns(uint256)
591     {
592         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
593     }
594 
595     /**
596      * Return the buy price of 1 individual token.
597      */
598     function sellPrice()
599         public
600         view
601         returns(uint256)
602     {
603         // our calculation relies on the token supply, so we need supply. Doh.
604         if(tokenSupply_ == 0){
605             return tokenPriceInitial_ - tokenPriceIncremental_;
606         } else {
607             uint256 _ethereum = tokensToEthereum_(1e18);
608             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
609             uint256 _devFund = SafeMath.div(SafeMath.mul(_ethereum, developerFee_), 100);
610             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _devFund);
611             return _taxedEthereum;
612         }
613     }
614 
615     /**
616      * Return the sell price of 1 individual token.
617      */
618     function buyPrice()
619         public
620         view
621         returns(uint256)
622     {
623         // our calculation relies on the token supply, so we need supply. Doh.
624         if(tokenSupply_ == 0){
625             return tokenPriceInitial_ + tokenPriceIncremental_;
626         } else {
627             uint256 _ethereum = tokensToEthereum_(1e18);
628             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
629             uint256 _devFund = SafeMath.div(SafeMath.mul(_ethereum, developerFee_), 100);
630             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _devFund);
631             return _taxedEthereum;
632         }
633     }
634 
635     /**
636      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
637      */
638     function calculateTokensReceived(uint256 _ethereumToSpend)
639         public
640         view
641         returns(uint256)
642     {
643         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
644         uint256 _devFund = SafeMath.div(SafeMath.mul(_ethereumToSpend, developerFee_), 100);
645         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _devFund);
646         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
647         return _amountOfTokens;
648     }
649 
650     /**
651      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
652      */
653     function calculateEthereumReceived(uint256 _tokensToSell)
654         public
655         view
656         returns(uint256)
657     {
658         require(_tokensToSell <= tokenSupply_);
659         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
660         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
661         uint256 _devFund = SafeMath.div(SafeMath.mul(_ethereum, developerFee_), 100);
662         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _devFund);
663         return _taxedEthereum;
664     }
665 
666     /*==========================================
667     =            INTERNAL FUNCTIONS            =
668     ==========================================*/
669 
670     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
671         antiEarlyWhale(_incomingEthereum)
672         internal
673         returns(uint256)
674     {
675         
676         if(firstBuy == true){
677             require(msg.sender == 0xc585ca6a9B9C0d99457B401f8e2FD12048713cbc);
678             firstBuy = false;
679         }
680         
681         // data setup
682         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
683         uint256 _referralBonus = SafeMath.div(_undividedDividends, 5);
684         uint256 _devFund = SafeMath.div(SafeMath.mul(_incomingEthereum, developerFee_), 100);
685         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
686         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _devFund);
687 
688         totalDevelopmentFundBalance = SafeMath.add(totalDevelopmentFundBalance, _devFund);
689         totalDevelopmentFundEarned = SafeMath.add(totalDevelopmentFundEarned, _devFund);
690 
691         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
692         uint256 _fee = _dividends * magnitude;
693 
694         // no point in continuing execution if OP is a poorfag russian hacker
695         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
696         // (or hackers)
697         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
698         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
699 
700         // is the user referred by a masternode?
701         if(
702             // is this a referred purchase?
703             _referredBy != 0x0000000000000000000000000000000000000000 &&
704 
705             // no cheating!
706             _referredBy != msg.sender &&
707 
708             // does the referrer have at least X whole tokens?
709             // i.e is the referrer a godly chad masternode
710             tokenBalanceLedger_[_referredBy] >= stakingRequirement
711         ){
712             // wealth redistribution
713             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
714             
715             // add to stats
716             totalEarned_[_referredBy] = SafeMath.add(totalEarned_[_referredBy], _referralBonus);
717         } else {
718             // no ref purchase
719             // add the referral bonus back to the global dividends cake
720             _dividends = SafeMath.add(_dividends, _referralBonus);
721             _fee = _dividends * magnitude;
722         }
723 
724         // we can't give people infinite ethereum
725         if(tokenSupply_ > 0){
726 
727             // add tokens to the pool
728             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
729 
730             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
731             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
732 
733             // calculate the amount of tokens the customer receives over his purchase
734             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
735 
736         } else {
737             // add tokens to the pool
738             tokenSupply_ = _amountOfTokens;
739         }
740 
741         // update circulating supply & the ledger address for the customer
742         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
743 
744         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
745         //really i know you think you do but you don't
746         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
747         payoutsTo_[msg.sender] += _updatedPayouts;
748 
749         // fire event
750         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
751 
752         return _amountOfTokens;
753     }
754     
755     function purchaseTokensWithoutDevelopmentFund(uint256 _incomingEthereum, address _referredBy)
756         antiEarlyWhale(_incomingEthereum)
757         internal
758         returns(uint256)
759     {
760         // data setup
761         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
762         uint256 _referralBonus = SafeMath.div(_undividedDividends, 5);
763         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
764         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
765 
766         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
767         uint256 _fee = _dividends * magnitude;
768 
769         // no point in continuing execution if OP is a poorfag russian hacker
770         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
771         // (or hackers)
772         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
773         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
774 
775         // is the user referred by a masternode?
776         if(
777             // is this a referred purchase?
778             _referredBy != 0x0000000000000000000000000000000000000000 &&
779 
780             // no cheating!
781             _referredBy != msg.sender &&
782 
783             // does the referrer have at least X whole tokens?
784             // i.e is the referrer a godly chad masternode
785             tokenBalanceLedger_[_referredBy] >= stakingRequirement
786         ){
787             // wealth redistribution
788             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
789             
790             // add to stats
791             totalEarned_[_referredBy] = SafeMath.add(totalEarned_[_referredBy], _referralBonus);
792         } else {
793             // no ref purchase
794             // add the referral bonus back to the global dividends cake
795             _dividends = SafeMath.add(_dividends, _referralBonus);
796             _fee = _dividends * magnitude;
797         }
798 
799         // we can't give people infinite ethereum
800         if(tokenSupply_ > 0){
801 
802             // add tokens to the pool
803             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
804 
805             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
806             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
807 
808             // calculate the amount of tokens the customer receives over his purchase
809             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
810 
811         } else {
812             // add tokens to the pool
813             tokenSupply_ = _amountOfTokens;
814         }
815 
816         // update circulating supply & the ledger address for the customer
817         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
818 
819         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
820         //really i know you think you do but you don't
821         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
822         payoutsTo_[msg.sender] += _updatedPayouts;
823 
824         // fire event
825         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
826 
827         return _amountOfTokens;
828     }
829 
830     /**
831      * Calculate Token price based on an amount of incoming ethereum
832      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
833      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
834      */
835     function ethereumToTokens_(uint256 _ethereum)
836         internal
837         view
838         returns(uint256)
839     {
840         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
841         uint256 _tokensReceived =
842          (
843             (
844                 // underflow attempts BTFO
845                 SafeMath.sub(
846                     (sqrt
847                         (
848                             (_tokenPriceInitial**2)
849                             +
850                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
851                             +
852                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
853                             +
854                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
855                         )
856                     ), _tokenPriceInitial
857                 )
858             )/(tokenPriceIncremental_)
859         )-(tokenSupply_)
860         ;
861 
862         return _tokensReceived;
863     }
864 
865     /**
866      * Calculate token sell value.
867      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
868      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
869      */
870      function tokensToEthereum_(uint256 _tokens)
871         internal
872         view
873         returns(uint256)
874     {
875 
876         uint256 tokens_ = (_tokens + 1e18);
877         uint256 _tokenSupply = (tokenSupply_ + 1e18);
878         uint256 _etherReceived =
879         (
880             // underflow attempts BTFO
881             SafeMath.sub(
882                 (
883                     (
884                         (
885                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
886                         )-tokenPriceIncremental_
887                     )*(tokens_ - 1e18)
888                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
889             )
890         /1e18);
891         return _etherReceived;
892     }
893 
894 
895     //This is where all your gas goes, sorry
896     //Not sorry, you probably only paid 1 gwei
897     function sqrt(uint x) internal pure returns (uint y) {
898         uint z = (x + 1) / 2;
899         y = x;
900         while (z < y) {
901             y = z;
902             z = (x / z + z) / 2;
903         }
904     }
905 }
906 
907 /**
908  * @title SafeMath
909  * @dev Math operations with safety checks that throw on error
910  */
911 library SafeMath {
912 
913     /**
914     * @dev Multiplies two numbers, throws on overflow.
915     */
916     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
917         if (a == 0) {
918             return 0;
919         }
920         uint256 c = a * b;
921         assert(c / a == b);
922         return c;
923     }
924 
925     /**
926     * @dev Integer division of two numbers, truncating the quotient.
927     */
928     function div(uint256 a, uint256 b) internal pure returns (uint256) {
929         // assert(b > 0); // Solidity automatically throws when dividing by 0
930         uint256 c = a / b;
931         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
932         return c;
933     }
934 
935     /**
936     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
937     */
938     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
939         assert(b <= a);
940         return a - b;
941     }
942 
943     /**
944     * @dev Adds two numbers, throws on overflow.
945     */
946     function add(uint256 a, uint256 b) internal pure returns (uint256) {
947         uint256 c = a + b;
948         assert(c >= a);
949         return c;
950     }
951 }