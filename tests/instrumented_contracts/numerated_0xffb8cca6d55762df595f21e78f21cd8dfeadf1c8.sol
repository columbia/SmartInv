1 pragma solidity ^0.4.25;
2 
3 /*
4 *
5 *  _____                  __          __   ______ _____ ______ 
6 * |  __ \                / _|        / _| |  ____|_   _|  ____|
7 * | |__) | __ ___   ___ | |_    ___ | |_  | |__    | | | |__   
8 * |  ___/ '__/ _ \ / _ \|  _|  / _ \|  _| |  __|   | | |  __|  
9 * | |   | | | (_) | (_) | |   | (_) | |   | |____ _| |_| |     
10 * |_|   |_|  \___/ \___/|_|    \___/|_|   |______|_____|_|     
11 *                                                              
12 *            Proof of EIF   -  ZERO DEV FEES!
13 *
14 * [✓] 5% EIF fee - 5% goes to EasyInvestForever (excluding the shared divs below)
15 * [✓] 48%-8% Withdraw fee goes to Token Holders as divs 
16 *     (fee starts at 48% and reduces down to 8% over 30 day period to discourage early dumps)
17 * [✓] 15% Deposit fee of which at least 5% goes to Token Holders as divs 
18 *      (up to 10% to any referrers - referrers are sticky for better referral earnings)
19 * [✓] 0% Token transfer fee enabling third party trading
20 * [✓] Multi-level STICKY Referral System - 10% from total purchase
21 *  *  [✓]  1st level 50% (5% from total purchase)
22 *  *  [✓]  2nd level 30% (3% from total purchase)
23 *  *  [✓]  3rd level 20% (2% from total purchase)
24 */
25 
26 
27 /**
28  * Definition of contract accepting Proof of EIF (EIF) tokens
29  * Games or any other innovative platforms can reuse this contract to support Proof Of EIF (EIF) tokens
30  */
31 contract AcceptsEIF {
32     ProofofEIF public tokenContract;
33 
34     constructor(address _tokenContract) public {
35         tokenContract = ProofofEIF(_tokenContract);
36     }
37 
38     modifier onlyTokenContract {
39         require(msg.sender == address(tokenContract));
40         _;
41     }
42 
43     /**
44     * @dev Standard ERC677 function that will handle incoming token transfers.
45     *
46     * @param _from  Token sender address.
47     * @param _value Amount of tokens.
48     * @param _data  Transaction metadata.
49     */
50     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
51 }
52 
53 
54 contract ProofofEIF {
55 
56     /*=================================
57     =            MODIFIERS            =
58     =================================*/
59 
60     modifier onlyBagholders {
61         require(myTokens() > 0);
62         _;
63     }
64 
65     modifier onlyStronghands {
66         require(myDividends(true) > 0);
67         _;
68     }
69     
70     modifier notGasbag() {
71       require(tx.gasprice <= 200000000000); // max 200 gwei
72       _;
73     }
74 
75     modifier notContract() {
76       require (msg.sender == tx.origin);
77 
78       _;
79     }
80     
81     
82        /// @dev Limit ambassador mine and prevent deposits before startTime
83     modifier antiEarlyWhale {
84         if (isPremine()) { //max 1ETH purchase premineLimit per ambassador
85           require(ambassadors_[msg.sender] && msg.value <= premineLimit);
86         // stop them purchasing a second time
87           ambassadors_[msg.sender]=false;
88         }
89         else require (isStarted());
90         _;
91     }
92     
93     
94     
95     // administrators can:
96     // -> change the name of the contract
97     // -> change the name of the token
98     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
99     // -> a few more things such as add ambassadors, administrators, reset more things
100     // they CANNOT:
101     // -> take funds
102     // -> disable withdrawals
103     // -> kill the contract
104     // -> change the price of tokens
105     modifier onlyAdministrator(){
106         address _customerAddress = msg.sender;
107         require(administrators[_customerAddress]);
108         _;
109     }    
110     
111     // administrator list (see above on what they can do)
112     mapping(address => bool) public administrators;
113     // ambassadors list (promoters who will get the contract started)
114     mapping(address => bool) public ambassadors_;
115 
116     /*==============================
117     =            EVENTS            =
118     ==============================*/
119 
120     event onTokenPurchase(
121         address indexed customerAddress,
122         uint256 incomingEthereum,
123         uint256 tokensMinted,
124         address indexed referredBy,
125         uint timestamp,
126         uint256 price
127     );
128 
129     event onTokenSell(
130         address indexed customerAddress,
131         uint256 tokensBurned,
132         uint256 ethereumEarned,
133         uint timestamp,
134         uint256 price
135     );
136 
137     event onReinvestment(
138         address indexed customerAddress,
139         uint256 ethereumReinvested,
140         uint256 tokensMinted
141     );
142 
143     event onWithdraw(
144         address indexed customerAddress,
145         uint256 ethereumWithdrawn
146     );
147 
148     event Transfer(
149         address indexed from,
150         address indexed to,
151         uint256 tokens
152     );
153 
154     event onReferralUse(
155         address indexed referrer,
156         uint8  indexed level,
157         uint256 ethereumCollected,
158         address indexed customerAddress,
159         uint256 timestamp
160     );
161 
162 
163 
164     string public name = "Proof of EIF";
165     string public symbol = "EIF";
166     uint8 constant public decimals = 18;
167     uint8 constant internal entryFee_ = 15;
168     
169     /// @dev 48% dividends for token selling
170     uint8 constant internal startExitFee_ = 48;
171 
172     /// @dev 8% dividends for token selling after step
173     uint8 constant internal finalExitFee_ = 8;
174 
175     /// @dev Exit fee falls over period of 30 days
176     uint256 constant internal exitFeeFallDuration_ = 30 days;
177     
178     /// @dev starting
179     uint256 public startTime = 0; //  January 1, 1970 12:00:00
180     mapping(address => uint256) internal bonusBalance_;
181     uint256 public depositCount_;
182     uint8 constant internal fundEIF_ = 5; // 5% goes to first EasyInvestForever contract
183     
184     /// @dev anti-early-whale
185     uint256 public maxEarlyStake = 2.5 ether;
186     uint256 public whaleBalanceLimit = 75 ether;
187     uint256 public premineLimit = 1 ether;
188     uint256 public ambassadorCount = 1;
189     
190     /// @dev PoEIF address
191     address public PoEIF;
192     
193     // Address to send the 5% EasyInvestForever Fee
194     address public giveEthFundAddress = 0x35027a992A3c232Dd7A350bb75004aD8567561B2;
195     uint256 public totalEthFundRecieved; // total ETH EasyInvestForever recieved from this contract
196     uint256 public totalEthFundCollected; // total ETH collected in this contract for EasyInvestForever
197     
198     
199     uint8 constant internal maxReferralFee_ = 10; // 10% from total sum (lev1 - 5%, lev2 - 3%, lev3 - 2%)
200     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
201     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
202     uint256 constant internal magnitude = 2 ** 64;
203     uint256 public stakingRequirement = 50e18;
204     mapping(address => uint256) internal tokenBalanceLedger_;
205     mapping(address => uint256) internal referralBalance_;
206     mapping(address => int256) internal payoutsTo_;
207     uint256 internal tokenSupply_;
208     uint256 internal profitPerShare_;
209     
210     // Special Platform control from scam game contracts on PoEIF platform
211     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept PoEIF tokens
212 
213     mapping(address => address) public stickyRef;
214     
215     /*=======================================
216     =            CONSTRUCTOR                =
217     =======================================*/
218 
219    constructor () public {
220      PoEIF = msg.sender;
221      // initially set only contract creator as ambassador and administrator but can be changed later
222      ambassadors_[PoEIF] = true;
223      administrators[PoEIF] = true;
224    }    
225     
226 
227     function buy(address _referredBy) notGasbag antiEarlyWhale public payable {
228         purchaseInternal(msg.value, _referredBy);
229     }
230 
231     function() payable notGasbag antiEarlyWhale public {
232         purchaseInternal(msg.value, 0x0);
233     }
234     
235 /**
236  * Sends FUND money to the Easy Invest Forever Contract
237  * Contract address can also be updated by admin if required in the future
238  */
239  
240      function updateFundAddress(address _newAddress)
241         onlyAdministrator()
242         public
243     {
244         giveEthFundAddress = _newAddress;
245     }
246     
247     function payFund() public {
248         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
249         require(ethToPay > 0);
250         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
251         if(!giveEthFundAddress.call.value(ethToPay)()) {
252             revert();
253         }
254     }
255 
256  /**
257   * Anyone can donate divs using this function to spread some love to all tokenholders without buying tokens
258   */
259     function donateDivs() payable public {
260         require(msg.value > 10000 wei && tokenSupply_ > 0);
261 
262         uint256 _dividends = msg.value;
263         // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
264         profitPerShare_ += (_dividends * magnitude / tokenSupply_);
265     } 
266 
267     // @dev Function setting the start time of the system  - can also be reset when contract balance is under 10ETH
268     function setStartTime(uint256 _startTime) onlyAdministrator public {
269         if (address(this).balance < 10 ether ) {
270             startTime = _startTime; 
271             // If not already in premine, set premine to start again - remove default ambassador afterwards for zero premine
272             if (!isPremine()) {depositCount_ = 0; ambassadorCount = 1; ambassadors_[PoEIF] = true;}
273         }
274     }
275     
276     // @dev Function for find if premine
277     function isPremine() public view returns (bool) {
278       return depositCount_ < ambassadorCount;
279     }
280 
281     // @dev Function for find if started
282     function isStarted() public view returns (bool) {
283       return startTime!=0 && now > startTime;
284     }    
285 
286     function reinvest() onlyStronghands public {
287         uint256 _dividends = myDividends(false);
288         address _customerAddress = msg.sender;
289         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
290         _dividends += referralBalance_[_customerAddress];
291         referralBalance_[_customerAddress] = 0;
292         uint256 _tokens = purchaseTokens(_dividends, 0x0);
293         emit onReinvestment(_customerAddress, _dividends, _tokens);
294     }
295 
296     function exit() public {
297         address _customerAddress = msg.sender;
298         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
299         if (_tokens > 0) sell(_tokens);
300         withdraw();
301     }
302 
303     function withdraw() onlyStronghands public {
304         address _customerAddress = msg.sender;
305         uint256 _dividends = myDividends(false);
306         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
307         _dividends += referralBalance_[_customerAddress];
308         referralBalance_[_customerAddress] = 0;
309         _customerAddress.transfer(_dividends);
310         emit onWithdraw(_customerAddress, _dividends);
311     }
312 
313     function sell(uint256 _amountOfTokens) onlyBagholders public {
314         address _customerAddress = msg.sender;
315         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
316         uint256 _tokens = _amountOfTokens;
317         uint256 _ethereum = tokensToEthereum_(_tokens);
318         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
319         
320         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundEIF_), 100);
321         // Take out dividends and then _fundPayout
322         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
323 
324         // Add ethereum to send to fund
325         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
326 
327         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
328         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
329 
330         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
331         payoutsTo_[_customerAddress] -= _updatedPayouts;
332 
333         if (tokenSupply_ > 0) {
334             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
335         }
336         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
337     }
338 
339     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
340         // setup
341         address _customerAddress = msg.sender;
342 
343         // make sure we have the requested tokens
344         // also disables transfers until ambassador phase is over
345         // ( we dont want whale premines )
346         require(!isPremine() && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
347 
348         // withdraw all outstanding dividends first
349         if(myDividends(true) > 0) withdraw();
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
362         return true;
363     }
364 
365 
366  /**
367     * Transfer token to a specified address and forward the data to recipient
368     * ERC-677 standard
369     * https://github.com/ethereum/EIPs/issues/677
370     * @param _to    Receiver address.
371     * @param _value Amount of tokens that will be transferred.
372     * @param _data  Transaction metadata.
373     */
374     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
375       require(_to != address(0));
376       require(canAcceptTokens_[_to] == true); // security check that contract approved by PoEIF platform
377       require(transfer(_to, _value)); // do a normal token transfer to the contract
378 
379       if (isContract(_to)) {
380         AcceptsEIF receiver = AcceptsEIF(_to);
381         require(receiver.tokenFallback(msg.sender, _value, _data));
382       }
383 
384       return true;
385     }
386 
387     /**
388      * Additional check that the game address we are sending tokens to is a contract
389      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
390      */
391      function isContract(address _addr) private constant returns (bool is_contract) {
392        // retrieve the size of the code on target address, this needs assembly
393        uint length;
394        assembly { length := extcodesize(_addr) }
395        return length > 0;
396      }
397 
398     /**
399      * Precautionary measures in case we need to adjust the masternode rate.
400      */
401     function setStakingRequirement(uint256 _amountOfTokens)
402         onlyAdministrator()
403         public
404     {
405         stakingRequirement = _amountOfTokens;
406     }
407     
408      /**
409      * Set new Early limits (only appropriate at start of new game).
410      */
411     function setEarlyLimits(uint256 _whaleBalanceLimit, uint256 _maxEarlyStake, uint256 _premineLimit)
412         onlyAdministrator()
413         public
414     {
415         whaleBalanceLimit = _whaleBalanceLimit;
416         maxEarlyStake = _maxEarlyStake;
417         premineLimit = _premineLimit;
418     }
419     
420 
421     /**
422      * Add or remove game contract, which can accept PoEIF (EIF) tokens
423      */
424     function setCanAcceptTokens(address _address, bool _value)
425       onlyAdministrator()
426       public
427     {
428       canAcceptTokens_[_address] = _value;
429     }
430 
431     /**
432      * If we want to rebrand, we can.
433      */
434     function setName(string _name)
435         onlyAdministrator()
436         public
437     {
438         name = _name;
439     }
440 
441     /**
442      * If we want to rebrand, we can.
443      */
444     function setSymbol(string _symbol)
445         onlyAdministrator()
446         public
447     {
448         symbol = _symbol;
449     }
450 
451   /**
452    * @dev add an address to the ambassadors_ list (this can be done anytime until the premine finishes)
453    * @param addr address
454    * @return true if the address was added to the list, false if the address was already in the list
455    */
456   function addAmbassador(address addr) onlyAdministrator public returns(bool success) {
457     if (!ambassadors_[addr] && isPremine()) {
458       ambassadors_[addr] = true;
459       ambassadorCount += 1;
460       success = true;
461     }
462   }
463 
464 
465   /**
466    * @dev remove an address from the ambassadors_ list
467    * (only do this if they take too long to buy premine - they are removed automatically during premine purchase)
468    * @param addr address
469    * @return true if the address was removed from the list,
470    * false if the address wasn't in the list in the first place
471    */
472   function removeAmbassador(address addr) onlyAdministrator public returns(bool success) {
473     if (ambassadors_[addr]) {
474       ambassadors_[addr] = false;
475       ambassadorCount -= 1;
476       success = true;
477     }
478   }
479   
480     /**
481    * @dev add an address to the administrators list
482    * @param addr address
483    * @return true if the address was added to the list, false if the address was already in the list
484    */
485   function addAdministrator(address addr) onlyAdministrator public returns(bool success) {
486     if (!administrators[addr]) {
487       administrators[addr] = true;
488       success = true;
489     }
490   }
491 
492 
493   /**
494    * @dev remove an address from the administrators list
495    * @param addr address
496    * @return true if the address was removed from the list,
497    * false if the address wasn't in the list in the first place or not called by original administrator
498    */
499   function removeAdministrator(address addr) onlyAdministrator public returns(bool success) {
500     if (administrators[addr] && msg.sender==PoEIF) {
501       administrators[addr] = false;
502       success = true;
503     }
504   }
505 
506 
507     function totalEthereumBalance() public view returns (uint256) {
508         return address(this).balance;
509     }
510 
511     function totalSupply() public view returns (uint256) {
512         return tokenSupply_;
513     }
514 
515     function myTokens() public view returns (uint256) {
516         address _customerAddress = msg.sender;
517         return balanceOf(_customerAddress);
518     }
519 
520     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
521         address _customerAddress = msg.sender;
522         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
523     }
524 
525     function balanceOf(address _customerAddress) public view returns (uint256) {
526         return tokenBalanceLedger_[_customerAddress];
527     }
528 
529     function dividendsOf(address _customerAddress) public view returns (uint256) {
530         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
531     }
532 
533     function sellPrice() public view returns (uint256) {
534         // our calculation relies on the token supply, so we need supply. Doh.
535         if (tokenSupply_ == 0) {
536             return tokenPriceInitial_ - tokenPriceIncremental_;
537         } else {
538             uint256 _ethereum = tokensToEthereum_(1e18);
539             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
540             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundEIF_), 100);
541             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
542             return _taxedEthereum;
543         }
544     }
545 
546     function buyPrice() public view returns (uint256) {
547         if (tokenSupply_ == 0) {
548             return tokenPriceInitial_ + tokenPriceIncremental_;
549         } else {
550             uint256 _ethereum = tokensToEthereum_(1e18);
551             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
552             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundEIF_), 100);
553             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
554 
555             return _taxedEthereum;
556         }
557     }
558 
559     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
560         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
561         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundEIF_), 100);
562         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
563         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
564 
565         return _amountOfTokens;
566     }
567 
568     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
569         require(_tokensToSell <= tokenSupply_);
570         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
571         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
572         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundEIF_), 100);
573         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
574         return _taxedEthereum;
575     }
576 
577     function exitFee() public view returns (uint8) {
578         if (startTime==0 || now < startTime){
579            return startExitFee_;
580         }
581         
582         uint256 secondsPassed = now - startTime;
583         if (secondsPassed >= exitFeeFallDuration_) {
584             return finalExitFee_;
585         }
586         uint8 totalChange = startExitFee_ - finalExitFee_;
587         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
588         uint8 currentFee = startExitFee_- currentChange;
589         return currentFee;
590     }
591     /*==========================================
592     =            INTERNAL FUNCTIONS            =
593     ==========================================*/
594 
595     // Make sure we will send back excess if user sends more than early limits
596     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
597       internal
598       notContract() // no contracts allowed
599       returns(uint256) {
600 
601       uint256 purchaseEthereum = _incomingEthereum;
602       uint256 excess;
603       if(purchaseEthereum > maxEarlyStake ) { // check if the transaction is over early limit of 2.5 ether
604           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= whaleBalanceLimit) { // if so check the contract is less than 75 ether whaleBalanceLimit
605               purchaseEthereum = maxEarlyStake;
606               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
607           }
608       }
609     
610       if (excess > 0) {
611         msg.sender.transfer(excess);
612       }
613     
614       purchaseTokens(purchaseEthereum, _referredBy);
615     }
616 
617     function handleReferrals(address _referredBy, uint _referralBonus, uint _undividedDividends) internal returns (uint){
618         uint _dividends = _undividedDividends;
619         address _level1Referrer = stickyRef[msg.sender];
620         
621         if (_level1Referrer == address(0x0)){
622             _level1Referrer = _referredBy;
623         }
624         // is the user referred by a masternode?
625         if(
626             // is this a referred purchase?
627             _level1Referrer != 0x0000000000000000000000000000000000000000 &&
628 
629             // no cheating!
630             _level1Referrer != msg.sender &&
631 
632             // does the referrer have at least X whole tokens?
633             // i.e is the referrer a godly chad masternode
634             tokenBalanceLedger_[_level1Referrer] >= stakingRequirement
635         ){
636             // wealth redistribution
637             if (stickyRef[msg.sender] == address(0x0)){
638                 stickyRef[msg.sender] = _level1Referrer;
639             }
640 
641             // level 1 refs - 50%
642             uint256 ethereumCollected =  _referralBonus/2;
643             referralBalance_[_level1Referrer] = SafeMath.add(referralBalance_[_level1Referrer], ethereumCollected);
644             _dividends = SafeMath.sub(_dividends, ethereumCollected);
645             emit onReferralUse(_level1Referrer, 1, ethereumCollected, msg.sender, now);
646 
647             address _level2Referrer = stickyRef[_level1Referrer];
648 
649             if (_level2Referrer != address(0x0) && tokenBalanceLedger_[_level2Referrer] >= stakingRequirement){
650                 // level 2 refs - 30%
651                 ethereumCollected =  (_referralBonus*3)/10;
652                 referralBalance_[_level2Referrer] = SafeMath.add(referralBalance_[_level2Referrer], ethereumCollected);
653                 _dividends = SafeMath.sub(_dividends, ethereumCollected);
654                 emit onReferralUse(_level2Referrer, 2, ethereumCollected, _level1Referrer, now);
655                 address _level3Referrer = stickyRef[_level2Referrer];
656 
657                 if (_level3Referrer != address(0x0) && tokenBalanceLedger_[_level3Referrer] >= stakingRequirement){
658                     //level 3 refs - 20%
659                     ethereumCollected =  (_referralBonus*2)/10;
660                     referralBalance_[_level3Referrer] = SafeMath.add(referralBalance_[_level3Referrer], ethereumCollected);
661                     _dividends = SafeMath.sub(_dividends, ethereumCollected);
662                     emit onReferralUse(_level3Referrer, 3, ethereumCollected, _level2Referrer, now);
663                 }
664             }
665         }
666         return _dividends;
667     }
668 
669     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
670         address _customerAddress = msg.sender;
671         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
672         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_incomingEthereum, maxReferralFee_), 100);
673         uint256 _dividends = handleReferrals(_referredBy, _referralBonus, _undividedDividends);
674         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundEIF_), 100);
675         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _undividedDividends), _fundPayout);
676         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
677         
678         
679         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
680         uint256 _fee = _dividends * magnitude;
681 
682         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
683 
684         if (tokenSupply_ > 0) {
685             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
686             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
687             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
688         } else {
689             tokenSupply_ = _amountOfTokens;
690         }
691 
692         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
693         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
694         payoutsTo_[_customerAddress] += _updatedPayouts;
695         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
696         // Keep track
697         depositCount_++;
698         return _amountOfTokens;
699     }
700 
701     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
702         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
703         uint256 _tokensReceived =
704             (
705                 (
706                     SafeMath.sub(
707                         (sqrt
708                             (
709                                 (_tokenPriceInitial ** 2)
710                                 +
711                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
712                                 +
713                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
714                                 +
715                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
716                             )
717                         ), _tokenPriceInitial
718                     )
719                 ) / (tokenPriceIncremental_)
720             ) - (tokenSupply_);
721 
722         return _tokensReceived;
723     }
724 
725     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
726         uint256 tokens_ = (_tokens + 1e18);
727         uint256 _tokenSupply = (tokenSupply_ + 1e18);
728         uint256 _etherReceived =
729             (
730                 SafeMath.sub(
731                     (
732                         (
733                             (
734                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
735                             ) - tokenPriceIncremental_
736                         ) * (tokens_ - 1e18)
737                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
738                 )
739                 / 1e18);
740 
741         return _etherReceived;
742     }
743 
744     function sqrt(uint256 x) internal pure returns (uint256 y) {
745         uint256 z = (x + 1) / 2;
746         y = x;
747 
748         while (z < y) {
749             y = z;
750             z = (x / z + z) / 2;
751         }
752     }
753 
754 
755 }
756 
757 library SafeMath {
758     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
759         if (a == 0) {
760             return 0;
761         }
762         uint256 c = a * b;
763         assert(c / a == b);
764         return c;
765     }
766 
767     function div(uint256 a, uint256 b) internal pure returns (uint256) {
768         uint256 c = a / b;
769         return c;
770     }
771 
772     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
773         assert(b <= a);
774         return a - b;
775     }
776 
777     function add(uint256 a, uint256 b) internal pure returns (uint256) {
778         uint256 c = a + b;
779         assert(c >= a);
780         return c;
781     }
782 }