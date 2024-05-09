1 pragma solidity ^0.4.24;
2 
3 /*
4 * GREED VS FEAR
5 */
6 
7 contract AcceptsGreedVSFear {
8         GreedVSFear public tokenContract;
9         
10     constructor(address _tokenContract) public {
11 	        tokenContract = GreedVSFear(_tokenContract);
12 	    }
13 	    
14 	    modifier onlyTokenContract {
15 	        require(msg.sender == address(tokenContract));
16 	        _;
17 	    }
18 
19 	    function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
20 	}
21 	
22 
23 
24 contract GreedVSFear {
25     /*=================================
26     =            MODIFIERS            =
27     =================================*/
28     // only people with tokens
29     modifier onlyBagholders() {
30         require(myTokens() > 0);
31         _;
32     }
33     
34     // only people with profits
35     modifier onlyStronghands() {
36         require(myDividends(true) > 0);
37         _;
38     }
39     
40     modifier noUnapprovedContracts() {
41         require (msg.sender == tx.origin || approvedContracts[msg.sender] == true);
42         _;
43     }
44     
45     mapping (address => uint256) public sellTmr;
46     mapping (address => uint256) public buyTmr;
47     
48     uint256 sellTimerN = (15 hours);
49     uint256 buyTimerN = (45 minutes);
50     
51     uint256 buyMax = 25 ether;
52     
53     
54     modifier sellLimit(){
55         require(block.timestamp > sellTmr[msg.sender] , "You cannot sell because of the sell timer");
56         
57         _;
58     }
59     
60     modifier buyLimit(){
61         require(block.timestamp > buyTmr[msg.sender], "You cannot buy because of buy cooldown");
62         require(msg.value <= buyMax, "You cannot buy because you bought over the max");
63         buyTmr[msg.sender] = block.timestamp + buyTimerN;
64         sellTmr[msg.sender] = block.timestamp + sellTimerN;
65         _;
66     }
67     
68     // administrators can:
69     // -> change the name of the contract
70     // -> change the name of the token
71     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
72     // they CANNOT:
73     // -> take funds
74     // -> disable withdrawals
75     // -> kill the contract
76     // -> change the price of tokens
77     modifier onlyAdministrator(){
78         address _customerAddress = msg.sender;
79         require(administrators[_customerAddress]);
80         _;
81     }
82     
83 
84     /*==============================
85     =            EVENTS            =
86     ==============================*/
87     event onTokenPurchase(
88         address indexed customerAddress,
89         uint256 incomingEthereum,
90         uint256 tokensMinted,
91         address indexed referredBy
92     );
93     
94     event onTokenSell(
95         address indexed customerAddress,
96         uint256 tokensBurned,
97         uint256 ethereumEarned
98     );
99     
100     event onReinvestment(
101         address indexed customerAddress,
102         uint256 ethereumReinvested,
103         uint256 tokensMinted
104     );
105     
106     event onWithdraw(
107         address indexed customerAddress,
108         uint256 ethereumWithdrawn
109     );
110     
111     // ERC20
112     event Transfer(
113         address indexed from,
114         address indexed to,
115         uint256 tokens
116     );
117     
118     
119     /*=====================================
120     =            CONFIGURABLES            =
121     =====================================*/
122     string public name = "Greed VS Fear";
123     string public symbol = "GREED";
124     uint8 constant public decimals = 18;
125     uint8 constant internal dividendFee_ = 20; // Fear Math
126     uint8 constant internal jackpotFee_ = 5;
127     uint8 constant internal greedFee_ = 5; 
128     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
129     uint256 constant internal tokenPriceIncremental_ = 0.00000002 ether;
130     uint256 constant internal magnitude = 2**64;
131     
132     address constant public devGreed = 0x90F1A46816D26db43397729f50C6622E795f9957;    
133     address constant public jackpotAddress = 0xFEb461A778Be56aEE6F8138D1ddA8fcc768E5800;
134     uint256 public jackpotReceived;
135     uint256 public jackpotCollected;
136     
137     // proof of stake 
138     uint256 public stakingRequirement = 250e18;
139     
140     // ambassador program
141     mapping(address => bool) internal ambassadors_;
142     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
143     uint256 constant internal ambassadorQuota_ = 2000 ether;
144     
145     
146     
147    /*================================
148     =            DATASETS            =
149     ================================*/
150     // amount of shares for each address (scaled number)
151     mapping(address => uint256) internal tokenBalanceLedger_;
152     mapping(address => uint256) internal referralBalance_;
153     mapping(address => int256) internal payoutsTo_;
154     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
155     uint256 internal tokenSupply_ = 0;
156     uint256 internal profitPerShare_;
157     
158     // administrator list (see above on what they can do)
159     mapping(address => bool) public administrators;
160     
161     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
162     bool public onlyAmbassadors = false;
163     
164     mapping(address => bool) public canAcceptTokens_; 
165 
166 	mapping(address => bool) public approvedContracts;
167 
168 
169     /*=======================================
170     =            PUBLIC FUNCTIONS            =
171     =======================================*/
172     /*
173     * -- APPLICATION ENTRY POINTS --  
174     */
175     function Greedy()
176         public payable
177     {
178         // add administrators here
179 
180         administrators[msg.sender] = true;
181         ambassadors_[msg.sender] = true;
182 
183 
184 
185         purchaseTokens(msg.value, address(0x0));
186         
187 
188     }
189     
190      
191     /**
192      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
193      */
194     function buy(address _referredBy)
195         public
196         payable
197         returns(uint256)
198     {
199         purchaseTokens(msg.value, _referredBy);
200     }
201     
202     /**
203      * Fallback function to handle ethereum that was send straight to the contract
204      * Unfortunately we cannot use a referral address this way.
205      */
206     function()
207         payable
208         public
209     {
210         purchaseTokens(msg.value, 0x0);
211     }
212     
213 	    function jackpotSend() payable public {
214 	      uint256 ethToPay = SafeMath.sub(jackpotCollected, jackpotReceived);
215 	      require(ethToPay > 1);
216 	      jackpotReceived = SafeMath.add(jackpotReceived, ethToPay);
217 	      if(!jackpotAddress.call.value(ethToPay).gas(400000)()) {
218 	         jackpotReceived = SafeMath.sub(jackpotReceived, ethToPay);
219 	      }
220 	    }
221     
222     
223     /**
224      * Converts all of caller's dividends to tokens.
225     */
226     function reinvest()
227         onlyStronghands()
228         public
229     {
230         // fetch dividends
231         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
232         
233         // pay out the dividends virtually
234         address _customerAddress = msg.sender;
235         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
236         
237         // retrieve ref. bonus
238         _dividends += referralBalance_[_customerAddress];
239         referralBalance_[_customerAddress] = 0;
240         
241         // dispatch a buy order with the virtualized "withdrawn dividends"
242         uint256 _tokens = _purchaseTokens(_dividends, 0x0);
243         
244         // fire event
245         emit onReinvestment(_customerAddress, _dividends, _tokens);
246     }
247     
248     /**
249      * Alias of sell() and withdraw().
250      */
251     function exit()
252         public
253         sellLimit()
254     {
255         // get token count for caller & sell them all
256         address _customerAddress = msg.sender;
257         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
258         if(_tokens > 0) sell(_tokens);
259         
260         // lambo delivery service
261         withdraw();
262     }
263 
264     /**
265      * Withdraws all of the callers earnings.
266      */
267     function withdraw()
268         onlyStronghands()
269         sellLimit()
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
287         emit onWithdraw(_customerAddress, _dividends);
288     }
289     
290     /**
291      * Liquifies tokens to ethereum.
292      */
293     function sell(uint256 _amountOfTokens)
294         onlyBagholders()
295         sellLimit()
296         public
297     {
298         // setup data
299         address _customerAddress = msg.sender;
300         // russian hackers BTFO
301         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
302         uint256 _tokens = _amountOfTokens;
303         uint256 _ethereum = tokensToEthereum_(_tokens);
304         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
305         uint256 _jackpotSend = SafeMath.div(SafeMath.mul(_ethereum, jackpotFee_), 100);
306         uint256 _greedyFee = SafeMath.div(SafeMath.mul(_ethereum, greedFee_), 100);
307         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _jackpotSend), _greedyFee);	
308         jackpotCollected = SafeMath.add(jackpotCollected, _jackpotSend);
309         devGreed.transfer(_greedyFee);
310         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
311         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
312         
313         // update dividends tracker
314         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
315         payoutsTo_[_customerAddress] -= _updatedPayouts;       
316         
317         // dividing by zero is a bad idea
318         if (tokenSupply_ > 0) {
319             // update the amount of dividends per token
320             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
321         }
322         
323         // fire event
324         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
325     }
326     
327     
328     /**
329      * Transfer tokens from the caller to a new holder.
330      */
331     function transfer(address _toAddress, uint256 _amountOfTokens)
332         onlyBagholders()
333         sellLimit()
334         public
335         returns(bool)
336     {
337         // setup
338         address _customerAddress = msg.sender;
339         
340         // make sure we have the requested tokens
341         // also disables transfers until ambassador phase is over
342         // ( we dont want whale premines )
343         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
344         
345         // withdraw all outstanding dividends first
346         if(myDividends(true) > 0) withdraw();
347         
348   
349 
350 
351         // exchange tokens
352         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
353         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
354         
355         // update dividend trackers
356         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
357         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
358 
359         
360         // fire event
361         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
362         
363         // ERC20
364         return true;
365        
366     }
367     
368 	    function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
369 	      require(_to != address(0));
370 	      require(canAcceptTokens_[_to] == true);
371 	      require(transfer(_to, _value));
372 	
373 	      if (isContract(_to)) {
374 	        AcceptsGreedVSFear receiver = AcceptsGreedVSFear(_to);
375 	        require(receiver.tokenFallback(msg.sender, _value, _data));
376 	      }
377 	
378 	      return true;
379 	      
380 	    }
381 	    
382 	     function isContract(address _addr) private constant returns (bool is_contract) {
383 	       // retrieve the size of the code on target address, this needs assembly
384 	       uint length;
385 	       assembly { length := extcodesize(_addr) }
386 	       return length > 0;
387 	     }
388 	
389 	      /**
390 	     * This function is a way to spread dividends to tokenholders from other contracts
391 	     */
392 	     function sendDividends () payable public
393 	    {
394 	        require(msg.value > 10000 wei);
395 	
396 	        uint256 _dividends = msg.value;
397 	        profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
398 	    }      
399 	
400 
401     
402     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
403     /**
404      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
405      */
406     function disableInitialStage()
407         onlyAdministrator()
408         public
409     {
410         onlyAmbassadors = false;
411     }
412     
413     /**
414      * In case one of us dies, we need to replace ourselves.
415      */
416     function setAdministrator(address _identifier, bool _status)
417         onlyAdministrator()
418         public
419     {
420         administrators[_identifier] = _status;
421     }
422     
423     /**
424      * Precautionary measures in case we need to adjust the masternode rate.
425      */
426     function setStakingRequirement(uint256 _amountOfTokens)
427         onlyAdministrator()
428         public
429     {
430         stakingRequirement = _amountOfTokens;
431     }
432 
433 	    function setCanAcceptTokens(address _address, bool _value)
434 	      onlyAdministrator()
435 	      public
436 	    {
437 	      canAcceptTokens_[_address] = _value;
438 	    }
439     
440     /**
441      * If we want to rebrand, we can.
442      */
443     function setName(string _name)
444         onlyAdministrator()
445         public
446     {
447         name = _name;
448     }
449     
450     /**
451      * If we want to rebrand, we can.
452      */
453     function setSymbol(string _symbol)
454         onlyAdministrator()
455         public
456     {
457         symbol = _symbol;
458     }
459 
460 	     function setApprovedContracts(address contractAddress, bool yesOrNo)
461 	        onlyAdministrator()
462 	        public
463 	     {
464 	        approvedContracts[contractAddress] = yesOrNo;
465 	     }
466     
467     /*----------  HELPERS AND CALCULATORS  ----------*/
468     /**
469      * Method to view the current Ethereum stored in the contract
470      * Example: totalEthereumBalance()
471      */
472     function totalEthereumBalance()
473         public
474         view
475         returns(uint)
476     {
477         return address(this).balance;
478     }
479     
480     /**
481      * Retrieve the total token supply.
482      */
483     function totalSupply()
484         public
485         view
486         returns(uint256)
487     {
488         return tokenSupply_;
489     }
490     
491     /**
492      * Retrieve the tokens owned by the caller.
493      */
494     function myTokens()
495         public
496         view
497         returns(uint256)
498     {
499         address _customerAddress = msg.sender;
500         return balanceOf(_customerAddress);
501     }
502     
503     /**
504      * Retrieve the dividends owned by the caller.
505      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
506      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
507      * But in the internal calculations, we want them separate. 
508      */ 
509     function myDividends(bool _includeReferralBonus) 
510         public 
511         view 
512         returns(uint256)
513     {
514         address _customerAddress = msg.sender;
515         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
516     }
517     
518     /**
519      * Retrieve the token balance of any single address.
520      */
521     function balanceOf(address _customerAddress)
522         view
523         public
524         returns(uint256)
525     {
526         return tokenBalanceLedger_[_customerAddress];
527     }
528     
529     /**
530      * Retrieve the dividend balance of any single address.
531      */
532     function dividendsOf(address _customerAddress)
533         view
534         public
535         returns(uint256)
536     {
537         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
538     }
539     
540     /**
541      * Return the buy price of 1 individual token.
542      */
543     function sellPrice() 
544         public 
545         view 
546         returns(uint256)
547     {
548         // our calculation relies on the token supply, so we need supply. Doh.
549         if(tokenSupply_ == 0){
550             return tokenPriceInitial_ - tokenPriceIncremental_;
551         } else {
552             uint256 _ethereum = tokensToEthereum_(1e18);
553             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
554             uint256 _jackpotPay = SafeMath.div(SafeMath.mul(_ethereum, jackpotFee_), 100);
555             uint256 _devPay = SafeMath.div(SafeMath.mul(_ethereum, greedFee_), 100);
556             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _jackpotPay), _devPay);
557 
558             return _taxedEthereum;
559         }
560     }
561     
562     /**
563      * Return the sell price of 1 individual token.
564      */
565     function buyPrice() 
566         public 
567         view 
568         returns(uint256)
569     {
570         // our calculation relies on the token supply, so we need supply. Doh.
571         if(tokenSupply_ == 0){
572             return tokenPriceInitial_ + tokenPriceIncremental_;
573         } else {
574             uint256 _ethereum = tokensToEthereum_(1e18);
575             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
576             uint256 _jackpotPay = SafeMath.div(SafeMath.mul(_ethereum, jackpotFee_), 100);
577             uint256 _devPay = SafeMath.div(SafeMath.mul(_ethereum, greedFee_), 100);
578             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _jackpotPay), _devPay);
579             return _taxedEthereum;
580         }
581     }
582     
583     /**
584      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
585      */
586     function calculateTokensReceived(uint256 _ethereumToSpend) 
587         public 
588         view 
589         returns(uint256)
590     {
591         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
592         uint256 _jackpotPay = SafeMath.div(SafeMath.mul(_ethereumToSpend, jackpotFee_), 100);
593         uint256 _devPay = SafeMath.div(SafeMath.mul(_ethereumToSpend, greedFee_), 100);
594         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _jackpotPay), _devPay);
595         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
596         
597         return _amountOfTokens;
598     }
599     
600     /**
601      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
602      */
603     function calculateEthereumReceived(uint256 _tokensToSell) 
604         public 
605         view 
606         returns(uint256)
607     {
608         require(_tokensToSell <= tokenSupply_);
609         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
610         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
611         uint256 _jackpotPay = SafeMath.div(SafeMath.mul(_ethereum, jackpotFee_), 100);
612         uint256 _devPay = SafeMath.div(SafeMath.mul(_ethereum, greedFee_), 100);
613         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _jackpotPay), _devPay);
614         return _taxedEthereum;
615     }
616 
617 	    function releaseJackpot()
618 	        public
619 	        view
620 	        returns(uint256) {
621 	        return SafeMath.sub(jackpotCollected, jackpotReceived);
622 	    }
623     
624     /*==========================================
625     =            INTERNAL FUNCTIONS            =
626     ==========================================*/
627     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
628         buyLimit()
629         internal
630         returns(uint256)
631     {
632         return _purchaseTokens(_incomingEthereum, _referredBy);
633     }
634     
635     function _purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256){
636         
637         // data setup
638         address _customerAddress = msg.sender;
639         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
640         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
641         uint256 _greedyFee = SafeMath.div(SafeMath.mul(_undividedDividends, greedFee_), 100);
642         uint256 _jackpotPay = SafeMath.div(SafeMath.mul(_incomingEthereum, jackpotFee_), 100);
643         uint256 _dividends = SafeMath.sub(SafeMath.sub(_undividedDividends, _referralBonus), _greedyFee);
644         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _jackpotPay), _greedyFee);
645 	             jackpotCollected = SafeMath.add(jackpotCollected, _jackpotPay);
646 	             devGreed.transfer(_greedyFee);
647         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
648         uint256 _fee = _dividends * magnitude;
649  
650         // no point in continuing execution if OP is a poorfag russian hacker
651         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
652         // (or hackers)
653         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
654         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
655         
656         // is the user referred by a masternode?
657         if(
658             // is this a referred purchase?
659             _referredBy != 0x0000000000000000000000000000000000000000 &&
660 
661             // no cheating!
662             _referredBy != _customerAddress &&
663             
664             // does the referrer have at least X whole tokens?
665             // i.e is the referrer a godly chad masternode
666             tokenBalanceLedger_[_referredBy] >= stakingRequirement
667         ){
668             // wealth redistribution
669             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
670         } else {
671             // no ref purchase
672             // add the referral bonus back to the global dividends cake
673             _dividends = SafeMath.add(_dividends, _referralBonus);
674             _fee = _dividends * magnitude;
675         }
676         
677         // we can't give people infinite ethereum
678         if(tokenSupply_ > 0){
679             
680             // add tokens to the pool
681             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
682  
683    
684             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
685             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
686             
687             // calculate the amount of tokens the customer receives over his purchase 
688             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
689         
690         } else {
691             // add tokens to the pool
692             tokenSupply_ = _amountOfTokens;
693         }
694         
695         // update circulating supply & the ledger address for the customer
696         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
697         
698         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
699         //really i know you think you do but you don't
700         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
701         payoutsTo_[_customerAddress] += _updatedPayouts;
702         
703         // fire event
704         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
705         
706         return _amountOfTokens;
707     }
708 
709     /**
710      * Calculate Token price based on an amount of incoming ethereum
711      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
712      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
713      */
714     function ethereumToTokens_(uint256 _ethereum)
715         internal
716         view
717         returns(uint256)
718     {
719         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
720         uint256 _tokensReceived = 
721          (
722             (
723                 // underflow attempts BTFO
724                 SafeMath.sub(
725                     (sqrt
726                         (
727                             (_tokenPriceInitial**2)
728                             +
729                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
730                             +
731                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
732                             +
733                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
734                         )
735                     ), _tokenPriceInitial
736                 )
737             )/(tokenPriceIncremental_)
738         )-(tokenSupply_)
739         ;
740   
741         return _tokensReceived;
742     }
743     
744     /**
745      * Calculate token sell value.
746      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
747      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
748      */
749      function tokensToEthereum_(uint256 _tokens)
750         internal
751         view
752         returns(uint256)
753     {
754 
755         uint256 tokens_ = (_tokens + 1e18);
756         uint256 _tokenSupply = (tokenSupply_ + 1e18);
757         uint256 _etherReceived =
758         (
759             // underflow attempts BTFO
760             SafeMath.sub(
761                 (
762                     (
763                         (
764                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
765                         )-tokenPriceIncremental_
766                     )*(tokens_ - 1e18)
767                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
768             )
769         /1e18);
770         return _etherReceived;
771     }
772     
773     
774     //This is where all your gas goes, sorry
775     //Not sorry, you probably only paid 1 gwei
776     function sqrt(uint x) internal pure returns (uint y) {
777         uint z = (x + 1) / 2;
778         y = x;
779         while (z < y) {
780             y = z;
781             z = (x / z + z) / 2;
782         }
783     }
784 }
785 
786 /**
787  * @title SafeMath
788  * @dev Math operations with safety checks that throw on error
789  */
790 library SafeMath {
791 
792     /**
793     * @dev Multiplies two numbers, throws on overflow.
794     */
795     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
796         if (a == 0) {
797             return 0;
798         }
799         uint256 c = a * b;
800         assert(c / a == b);
801         return c;
802     }
803 
804     /**
805     * @dev Integer division of two numbers, truncating the quotient.
806     */
807     function div(uint256 a, uint256 b) internal pure returns (uint256) {
808         // assert(b > 0); // Solidity automatically throws when dividing by 0
809         uint256 c = a / b;
810         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
811         return c;
812     }
813 
814     /**
815     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
816     */
817     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
818         assert(b <= a);
819         return a - b;
820     }
821 
822     /**
823     * @dev Adds two numbers, throws on overflow.
824     */
825     function add(uint256 a, uint256 b) internal pure returns (uint256) {
826         uint256 c = a + b;
827         assert(c >= a);
828         return c;
829     }
830 }