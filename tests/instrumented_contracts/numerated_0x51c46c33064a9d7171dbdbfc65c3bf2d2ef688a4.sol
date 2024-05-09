1 pragma solidity ^0.4.21;
2 
3 /*
4 * Wall Street Market presents......
5 
6  _       __      ____   _____ __                 __     ______          __                         
7 | |     / /___ _/ / /  / ___// /_________  ___  / /_   / ____/  _______/ /_  ____ _____  ____ ____ 
8 | | /| / / __ `/ / /   \__ \/ __/ ___/ _ \/ _ \/ __/  / __/ | |/_/ ___/ __ \/ __ `/ __ \/ __ `/ _ \
9 | |/ |/ / /_/ / / /   ___/ / /_/ /  /  __/  __/ /_   / /____>  </ /__/ / / / /_/ / / / / /_/ /  __/
10 |__/|__/\__,_/_/_/   /____/\__/_/   \___/\___/\__/  /_____/_/|_|\___/_/ /_/\__,_/_/ /_/\__, /\___/ 
11                                                                                       /____/       
12 
13 
14 website:    https://wallstreetmarket.tk
15 
16 discord:    https://discord.gg/8AFP9gS
17 
18 25% Dividends Fees/Payouts
19 
20 5% of Buy In Fee Goes into the Bond Market Contract for Distribution to Bond holders
21 
22 Referral Program pays out 33% of Buy-in/Sell Fees to user of masternode link
23 
24 */
25 
26 
27 
28 
29 
30 contract AcceptsExchange {
31     Exchange public tokenContract;
32 
33     function AcceptsExchange(address _tokenContract) public {
34         tokenContract = Exchange(_tokenContract);
35     }
36 
37     modifier onlyTokenContract {
38         require(msg.sender == address(tokenContract));
39         _;
40     }
41 
42     /**
43     * @dev Standard ERC677 function that will handle incoming token transfers.
44     *
45     * @param _from  Token sender address.
46     * @param _value Amount of tokens.
47     * @param _data  Transaction metadata.
48     */
49     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
50 }
51 
52 
53 contract Exchange {
54     /*=================================
55     =            MODIFIERS            =
56     =================================*/
57     // only people with tokens
58     modifier onlyBagholders() {
59         require(myTokens() > 0);
60         _;
61     }
62 
63     // only people with profits
64     modifier onlyStronghands() {
65         require(myDividends(true) > 0);
66         _;
67     }
68 
69     modifier notContract() {
70       require (msg.sender == tx.origin);
71       _;
72     }
73 
74     // administrators can:
75     // -> change the name of the contract
76     // -> change the name of the token
77     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
78     // they CANNOT:
79     // -> take funds
80     // -> disable withdrawals
81     // -> kill the contract
82     // -> change the price of tokens
83     modifier onlyAdministrator(){
84         address _customerAddress = msg.sender;
85         require(administrators[_customerAddress]);
86         _;
87     }
88 
89  
90     /*==============================
91     =            EVENTS            =
92     ==============================*/
93     event onTokenPurchase(
94         address indexed customerAddress,
95         uint256 incomingEthereum,
96         uint256 tokensMinted,
97         address indexed referredBy
98     );
99 
100     event onTokenSell(
101         address indexed customerAddress,
102         uint256 tokensBurned,
103         uint256 ethereumEarned
104     );
105 
106     event onReinvestment(
107         address indexed customerAddress,
108         uint256 ethereumReinvested,
109         uint256 tokensMinted
110     );
111 
112     event onWithdraw(
113         address indexed customerAddress,
114         uint256 ethereumWithdrawn
115     );
116 
117     // ERC20
118     event Transfer(
119         address indexed from,
120         address indexed to,
121         uint256 tokens
122     );
123 
124 
125     /*=====================================
126     =            CONFIGURABLES            =
127     =====================================*/
128     string public name = "WallStreetExchange";
129     string public symbol = "STOCK";
130     uint8 constant public decimals = 18;
131 
132     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
133     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
134     uint256 constant internal magnitude = 2**64;
135 
136    
137     uint256 public totalEthFundRecieved; // total ETH charity recieved from this contract
138     uint256 public totalEthFundCollected; // total ETH charity collected in this contract
139 
140     // proof of stake (defaults at 25 tokens)
141     uint256 public stakingRequirement = 25e18;
142 
143     // ambassador program
144     mapping(address => bool) internal ambassadors_;
145     uint256 constant internal ambassadorMaxPurchase_ = 2.5 ether;
146     uint256 constant internal ambassadorQuota_ = 2.5 ether;
147 
148 
149 
150    /*================================
151     =            DATASETS            =
152     ================================*/
153     // amount of shares for each address (scaled number)
154     mapping(address => uint256) internal tokenBalanceLedger_;
155     mapping(address => uint256) internal referralBalance_;
156     mapping(address => int256) internal payoutsTo_;
157     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
158     uint256 internal tokenSupply_ = 0;
159     uint256 internal profitPerShare_;
160 
161 
162     uint8 internal dividendFee_ = 20; // 20% dividend fee on each buy and sell
163     uint8 internal fundFee_ = 5; // 5% bond fund fee on each buy and sell
164     uint8 internal altFundFee_ = 0; // Fund fee rate on each buy and sell for future game
165 
166 
167     // administrator list (see above on what they can do)
168     mapping(address => bool) public administrators;
169 
170     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
171     bool public onlyAmbassadors = true;
172 
173     // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
174     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
175 
176     mapping(address => address) public stickyRef;
177 
178      address public bondFundAddress = 0x1822435de9b923a7a8c4fbd2f6d0aa8f743d3010;   //Bond Fund
179      address public altFundAddress = 0x1822435de9b923a7a8c4fbd2f6d0aa8f743d3010;    //Alternate Fund for Future Game
180 
181     /*=======================================
182     =            PUBLIC FUNCTIONS            =
183     =======================================*/
184     /*
185     * -- APPLICATION ENTRY POINTS --
186     */
187     function Exchange()
188         public
189     {
190         // add administrators here
191         administrators[msg.sender] = true;
192     }
193     /**
194      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
195      */
196     function buy(address _referredBy)
197         public
198         payable
199         returns(uint256)
200     {
201         
202         require(tx.gasprice <= 0.05 szabo);
203         purchaseTokens(msg.value, _referredBy);
204     }
205 
206     /**
207      * Fallback function to handle ethereum that was send straight to the contract
208      * Unfortunately we cannot use a referral address this way.
209      */
210     function()
211         payable
212         public
213     {
214         
215         require(tx.gasprice <= 0.05 szabo);
216         purchaseTokens(msg.value, 0x0);
217     }
218 
219     /**
220      * Sends Bondf Fund ether to the bond contract
221      * 
222      */
223     function payFund() payable public 
224     onlyAdministrator()
225     {
226         
227 
228         uint256 _bondEthToPay = 0;
229 
230         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
231         require(ethToPay > 1);
232 
233         uint256 altEthToPay = SafeMath.div(SafeMath.mul(ethToPay,altFundFee_),100);
234         if (altFundFee_ > 0){
235             _bondEthToPay = SafeMath.sub(ethToPay,altEthToPay);
236         } else{
237             _bondEthToPay = 0;
238         }
239 
240         
241         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
242         if(!bondFundAddress.call.value(_bondEthToPay).gas(400000)()) {
243             totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, _bondEthToPay);
244         }
245 
246         if(altEthToPay > 0){
247             if(!altFundAddress.call.value(altEthToPay).gas(400000)()) {
248                 totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, altEthToPay);
249             }
250         }
251       
252     }
253 
254     /**
255      * Converts all of caller's dividends to tokens.
256      */
257     function reinvest()
258         onlyStronghands()
259         public
260     {
261         // fetch dividends
262         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
263 
264         // pay out the dividends virtually
265         address _customerAddress = msg.sender;
266         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
267 
268         // retrieve ref. bonus
269         _dividends += referralBalance_[_customerAddress];
270         referralBalance_[_customerAddress] = 0;
271 
272         // dispatch a buy order with the virtualized "withdrawn dividends"
273         uint256 _tokens = purchaseTokens(_dividends, 0x0);
274 
275         // fire event
276         onReinvestment(_customerAddress, _dividends, _tokens);
277     }
278 
279     /**
280      * Alias of sell() and withdraw().
281      */
282     function exit()
283         public
284     {
285         // get token count for caller & sell them all
286         address _customerAddress = msg.sender;
287         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
288         if(_tokens > 0) sell(_tokens);
289 
290         // lambo delivery service
291         withdraw();
292     }
293 
294     /**
295      * Withdraws all of the callers earnings.
296      */
297     function withdraw()
298         onlyStronghands()
299         public
300     {
301         // setup data
302         address _customerAddress = msg.sender;
303         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
304 
305         // update dividend tracker
306         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
307 
308         // add ref. bonus
309         _dividends += referralBalance_[_customerAddress];
310         referralBalance_[_customerAddress] = 0;
311 
312         // lambo delivery service
313         _customerAddress.transfer(_dividends);
314 
315         // fire event
316         onWithdraw(_customerAddress, _dividends);
317     }
318 
319     /**
320      * Liquifies tokens to ethereum.
321      */
322     function sell(uint256 _amountOfTokens)
323         onlyBagholders()
324         public
325     {
326         // setup data
327         address _customerAddress = msg.sender;
328         // russian hackers BTFO
329         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
330         uint256 _tokens = _amountOfTokens;
331         uint256 _ethereum = tokensToEthereum_(_tokens);
332 
333         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
334         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
335         
336         uint256 _refPayout = _dividends / 3;
337         _dividends = SafeMath.sub(_dividends, _refPayout);
338         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
339 
340         // Take out dividends and then _fundPayout
341         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
342 
343         // Add ethereum to send to fund
344         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
345 
346         // burn the sold tokens
347         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
348         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
349 
350         // update dividends tracker
351         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
352         payoutsTo_[_customerAddress] -= _updatedPayouts;
353 
354         // dividing by zero is a bad idea
355         if (tokenSupply_ > 0) {
356             // update the amount of dividends per token
357             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
358         }
359 
360         // fire event
361         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
362     }
363 
364 
365     /**
366      * Transfer tokens from the caller to a new holder.
367      * REMEMBER THIS IS 0% TRANSFER FEE
368      */
369     function transfer(address _toAddress, uint256 _amountOfTokens)
370         onlyBagholders()
371         public
372         returns(bool)
373     {
374         // setup
375         address _customerAddress = msg.sender;
376 
377         // make sure we have the requested tokens
378         // also disables transfers until ambassador phase is over
379         // ( we dont want whale premines )
380         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
381 
382         // withdraw all outstanding dividends first
383         if(myDividends(true) > 0) withdraw();
384 
385         // exchange tokens
386         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
387         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
388 
389         // update dividend trackers
390         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
391         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
392 
393 
394         // fire event
395         Transfer(_customerAddress, _toAddress, _amountOfTokens);
396 
397         // ERC20
398         return true;
399     }
400 
401     /**
402     * Transfer token to a specified address and forward the data to recipient
403     * ERC-677 standard
404     * https://github.com/ethereum/EIPs/issues/677
405     * @param _to    Receiver address.
406     * @param _value Amount of tokens that will be transferred.
407     * @param _data  Transaction metadata.
408     */
409     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
410       require(_to != address(0));
411       require(canAcceptTokens_[_to] == true); // security check that contract approved by Wall Street Exchange platform
412       require(transfer(_to, _value)); // do a normal token transfer to the contract
413 
414       if (isContract(_to)) {
415         AcceptsExchange receiver = AcceptsExchange(_to);
416         require(receiver.tokenFallback(msg.sender, _value, _data));
417       }
418 
419       return true;
420     }
421 
422     /**
423      * Additional check that the game address we are sending tokens to is a contract
424      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
425      */
426      function isContract(address _addr) private constant returns (bool is_contract) {
427        // retrieve the size of the code on target address, this needs assembly
428        uint length;
429        assembly { length := extcodesize(_addr) }
430        return length > 0;
431      }
432 
433     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
434     /**
435      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
436      */
437     //function disableInitialStage()
438     //    onlyAdministrator()
439     //    public
440     //{
441     //    onlyAmbassadors = false;
442     //}
443 
444     
445   
446     function setBondFundAddress(address _newBondFundAddress)
447         onlyAdministrator()
448         public
449     {
450         bondFundAddress = _newBondFundAddress;
451     }
452 
453     
454     function setAltFundAddress(address _newAltFundAddress)
455         onlyAdministrator()
456         public
457     {
458         altFundAddress = _newAltFundAddress;
459     }
460 
461 
462     /**
463      * Set fees/rates
464      */
465     function setFeeRates(uint8 _newDivRate, uint8 _newFundFee, uint8 _newAltRate)
466         onlyAdministrator()
467         public
468     {
469         dividendFee_ = _newDivRate;
470         fundFee_ = _newFundFee;
471         altFundFee_ = _newAltRate;
472     }
473 
474 
475     /**
476      * In case one of us dies, we need to replace ourselves.
477      */
478     function setAdministrator(address _identifier, bool _status)
479         onlyAdministrator()
480         public
481     {
482         administrators[_identifier] = _status;
483     }
484 
485     /**
486      * Precautionary measures in case we need to adjust the masternode rate.
487      */
488     function setStakingRequirement(uint256 _amountOfTokens)
489         onlyAdministrator()
490         public
491     {
492         stakingRequirement = _amountOfTokens;
493     }
494 
495     /**
496      * Add or remove game contract, which can accept Wall Street Market tokens
497      */
498     function setCanAcceptTokens(address _address, bool _value)
499       onlyAdministrator()
500       public
501     {
502       canAcceptTokens_[_address] = _value;
503     }
504 
505     /**
506      * If we want to rebrand, we can.
507      */
508     function setName(string _name)
509         onlyAdministrator()
510         public
511     {
512         name = _name;
513     }
514 
515     /**
516      * If we want to rebrand, we can.
517      */
518     function setSymbol(string _symbol)
519         onlyAdministrator()
520         public
521     {
522         symbol = _symbol;
523     }
524 
525 
526     /*----------  HELPERS AND CALCULATORS  ----------*/
527     /**
528      * Method to view the current Ethereum stored in the contract
529      * Example: totalEthereumBalance()
530      */
531     function totalEthereumBalance()
532         public
533         view
534         returns(uint)
535     {
536         return this.balance;
537     }
538 
539     /**
540      * Retrieve the total token supply.
541      */
542     function totalSupply()
543         public
544         view
545         returns(uint256)
546     {
547         return tokenSupply_;
548     }
549 
550     /**
551      * Retrieve the tokens owned by the caller.
552      */
553     function myTokens()
554         public
555         view
556         returns(uint256)
557     {
558         address _customerAddress = msg.sender;
559         return balanceOf(_customerAddress);
560     }
561 
562     /**
563      * Retrieve the dividends owned by the caller.
564      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
565      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
566      * But in the internal calculations, we want them separate.
567      */
568     function myDividends(bool _includeReferralBonus)
569         public
570         view
571         returns(uint256)
572     {
573         address _customerAddress = msg.sender;
574         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
575     }
576 
577     /**
578      * Retrieve the token balance of any single address.
579      */
580     function balanceOf(address _customerAddress)
581         view
582         public
583         returns(uint256)
584     {
585         return tokenBalanceLedger_[_customerAddress];
586     }
587 
588     /**
589      * Retrieve the dividend balance of any single address.
590      */
591     function dividendsOf(address _customerAddress)
592         view
593         public
594         returns(uint256)
595     {
596         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
597     }
598 
599     /**
600      * Return the buy price of 1 individual token.
601      */
602     function sellPrice()
603         public
604         view
605         returns(uint256)
606     {
607         // our calculation relies on the token supply, so we need supply. Doh.
608         if(tokenSupply_ == 0){
609             return tokenPriceInitial_ - tokenPriceIncremental_;
610         } else {
611             uint256 _ethereum = tokensToEthereum_(1e18);
612             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
613             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
614             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
615             return _taxedEthereum;
616         }
617     }
618 
619     /**
620      * Return the sell price of 1 individual token.
621      */
622     function buyPrice()
623         public
624         view
625         returns(uint256)
626     {
627         // our calculation relies on the token supply, so we need supply. Doh.
628         if(tokenSupply_ == 0){
629             return tokenPriceInitial_ + tokenPriceIncremental_;
630         } else {
631             uint256 _ethereum = tokensToEthereum_(1e18);
632             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
633             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
634             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
635             return _taxedEthereum;
636         }
637     }
638 
639     /**
640      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
641      */
642     function calculateTokensReceived(uint256 _ethereumToSpend)
643         public
644         view
645         returns(uint256)
646     {
647         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
648         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_), 100);
649         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
650         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
651         return _amountOfTokens;
652     }
653 
654     /**
655      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
656      */
657     function calculateEthereumReceived(uint256 _tokensToSell)
658         public
659         view
660         returns(uint256)
661     {
662         require(_tokensToSell <= tokenSupply_);
663         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
664         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
665         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_), 100);
666         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
667         return _taxedEthereum;
668     }
669 
670     /**
671      * Function for the frontend to show ether waiting to be send to fund in contract
672      */
673     function etherToSendFund()
674         public
675         view
676         returns(uint256) {
677         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
678     }
679 
680 
681     /*==========================================
682     =            INTERNAL FUNCTIONS            =
683     ==========================================*/
684 
685     // Make sure we will send back excess if user sends more then 5 ether before 10 ETH in contract
686     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
687       notContract()// no contracts allowed
688       internal
689       returns(uint256) {
690 
691       uint256 purchaseEthereum = _incomingEthereum;
692       uint256 excess;
693       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
694           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 10 ether) { // if so check the contract is less then 100 ether
695               purchaseEthereum = 2.5 ether;
696               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
697           }
698       }
699 
700       purchaseTokens(purchaseEthereum, _referredBy);
701 
702       if (excess > 0) {
703         msg.sender.transfer(excess);
704       }
705     }
706 
707     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
708         uint _dividends = _currentDividends;
709         uint _fee = _currentFee;
710         address _referredBy = stickyRef[msg.sender];
711         if (_referredBy == address(0x0)){
712             _referredBy = _ref;
713         }
714         // is the user referred by a masternode?
715         if(
716             // is this a referred purchase?
717             _referredBy != 0x0000000000000000000000000000000000000000 &&
718 
719             // no cheating!
720             _referredBy != msg.sender &&
721 
722             // does the referrer have at least X whole tokens?
723             // i.e is the referrer a godly chad masternode
724             tokenBalanceLedger_[_referredBy] >= stakingRequirement
725         ){
726             // wealth redistribution
727             if (stickyRef[msg.sender] == address(0x0)){
728                 stickyRef[msg.sender] = _referredBy;
729             }
730             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
731             address currentRef = stickyRef[_referredBy];
732             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
733                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
734                 currentRef = stickyRef[currentRef];
735                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
736                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
737                 }
738                 else{
739                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
740                     _fee = _dividends * magnitude;
741                 }
742             }
743             else{
744                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
745                 _fee = _dividends * magnitude;
746             }
747             
748             
749         } else {
750             // no ref purchase
751             // add the referral bonus back to the global dividends cake
752             _dividends = SafeMath.add(_dividends, _referralBonus);
753             _fee = _dividends * magnitude;
754         }
755         return (_dividends, _fee);
756     }
757 
758 
759     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
760        
761         internal
762         returns(uint256)
763     {
764         // data setup
765         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
766         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
767         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_), 100);
768         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
769         uint256 _fee;
770         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
771         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
772         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
773 
774         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
775 
776 
777         // no point in continuing execution if OP is a poorfag russian hacker
778         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
779         // (or hackers)
780         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
781         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
782 
783 
784 
785         // we can't give people infinite ethereum
786         if(tokenSupply_ > 0){
787  
788             // add tokens to the pool
789             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
790 
791             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
792             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
793 
794             // calculate the amount of tokens the customer receives over his purchase
795             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
796 
797         } else {
798             // add tokens to the pool
799             tokenSupply_ = _amountOfTokens;
800         }
801 
802         // update circulating supply & the ledger address for the customer
803         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
804 
805         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
806         //really i know you think you do but you don't
807         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
808         payoutsTo_[msg.sender] += _updatedPayouts;
809 
810         // fire event
811         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
812 
813         return _amountOfTokens;
814     }
815 
816     /**
817      * Calculate Token price based on an amount of incoming ethereum
818      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
819      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
820      */
821     function ethereumToTokens_(uint256 _ethereum)
822         internal
823         view
824         returns(uint256)
825     {
826         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
827         uint256 _tokensReceived =
828          (
829             (
830                 // underflow attempts BTFO
831                 SafeMath.sub(
832                     (sqrt
833                         (
834                             (_tokenPriceInitial**2)
835                             +
836                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
837                             +
838                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
839                             +
840                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
841                         )
842                     ), _tokenPriceInitial
843                 )
844             )/(tokenPriceIncremental_)
845         )-(tokenSupply_)
846         ;
847 
848         return _tokensReceived;
849     }
850 
851     /**
852      * Calculate token sell value.
853      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
854      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
855      */
856      function tokensToEthereum_(uint256 _tokens)
857         internal
858         view
859         returns(uint256)
860     {
861 
862         uint256 tokens_ = (_tokens + 1e18);
863         uint256 _tokenSupply = (tokenSupply_ + 1e18);
864         uint256 _etherReceived =
865         (
866             // underflow attempts BTFO
867             SafeMath.sub(
868                 (
869                     (
870                         (
871                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
872                         )-tokenPriceIncremental_
873                     )*(tokens_ - 1e18)
874                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
875             )
876         /1e18);
877         return _etherReceived;
878     }
879 
880 
881     //This is where all your gas goes, sorry
882     //Not sorry, you probably only paid 1 gwei
883     function sqrt(uint x) internal pure returns (uint y) {
884         uint z = (x + 1) / 2;
885         y = x;
886         while (z < y) {
887             y = z;
888             z = (x / z + z) / 2;
889         }
890     }
891 }
892 
893 /**
894  * @title SafeMath
895  * @dev Math operations with safety checks that throw on error
896  */
897 library SafeMath {
898 
899     /**
900     * @dev Multiplies two numbers, throws on overflow.
901     */
902     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
903         if (a == 0) {
904             return 0;
905         }
906         uint256 c = a * b;
907         assert(c / a == b);
908         return c;
909     }
910 
911     /**
912     * @dev Integer division of two numbers, truncating the quotient.
913     */
914     function div(uint256 a, uint256 b) internal pure returns (uint256) {
915         // assert(b > 0); // Solidity automatically throws when dividing by 0
916         uint256 c = a / b;
917         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
918         return c;
919     }
920 
921     /**
922     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
923     */
924     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
925         assert(b <= a);
926         return a - b;
927     }
928 
929     /**
930     * @dev Adds two numbers, throws on overflow.
931     */
932     function add(uint256 a, uint256 b) internal pure returns (uint256) {
933         uint256 c = a + b;
934         assert(c >= a);
935         return c;
936     }
937 }