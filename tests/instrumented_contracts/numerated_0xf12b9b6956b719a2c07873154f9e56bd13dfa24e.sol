1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Bankroll.sol
4 
5 interface Bankroll {
6 
7     //Customer functions
8 
9     /// @dev Stores ETH funds for customer
10     function credit(address _customerAddress, uint256 amount) external returns (uint256);
11 
12     /// @dev Debits address by an amount
13     function debit(address _customerAddress, uint256 amount) external returns (uint256);
14 
15     /// @dev Withraws balance for address; returns amount sent
16     function withdraw(address _customerAddress) external returns (uint256);
17 
18     /// @dev Retrieve the token balance of any single address.
19     function balanceOf(address _customerAddress) external view returns (uint256);
20 
21     /// @dev Stats of any single address
22     function statsOf(address _customerAddress) external view returns (uint256[8]);
23 
24 
25     // System functions
26 
27     // @dev Deposit funds
28     function deposit() external payable;
29 
30     // @dev Deposit on behalf of an address; it is not a credit
31     function depositBy(address _customerAddress) external payable;
32 
33     // @dev Distribute house profit
34     function houseProfit(uint256 amount)  external;
35 
36 
37     /// @dev Get all the ETH stored in contract minus credits to customers
38     function netEthereumBalance() external view returns (uint256);
39 
40 
41     /// @dev Get all the ETH stored in contract
42     function totalEthereumBalance() external view returns (uint256);
43 
44 }
45 
46 // File: contracts/P4RTYRelay.sol
47 
48 /*
49  * Visit: https://p4rty.io
50  * Discord: https://discord.gg/7y3DHYF
51 */
52 
53 interface P4RTYRelay {
54     /**
55     * @dev Will relay to internal implementation
56     * @param beneficiary Token purchaser
57     * @param tokenAmount Number of tokens to be minted
58     */
59     function relay(address beneficiary, uint256 tokenAmount) external;
60 }
61 
62 // File: contracts/SessionQueue.sol
63 
64 /// A FIFO queue for storing addresses
65 contract SessionQueue {
66 
67     mapping(uint256 => address) private queue;
68     uint256 private first = 1;
69     uint256 private last = 0;
70 
71     /// @dev Push into queue
72     function enqueue(address data) internal {
73         last += 1;
74         queue[last] = data;
75     }
76 
77     /// @dev Returns true if the queue has elements in it
78     function available() internal view returns (bool) {
79         return last >= first;
80     }
81 
82     /// @dev Returns the size of the queue
83     function depth() internal view returns (uint256) {
84         return last - first + 1;
85     }
86 
87     /// @dev Pops from the head of the queue
88     function dequeue() internal returns (address data) {
89         require(last >= first);
90         // non-empty queue
91 
92         data = queue[first];
93 
94         delete queue[first];
95         first += 1;
96     }
97 
98     /// @dev Returns the head of the queue without a pop
99     function peek() internal view returns (address data) {
100         require(last >= first);
101         // non-empty queue
102 
103         data = queue[first];
104     }
105 }
106 
107 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that throw on error
112  */
113 library SafeMath {
114 
115   /**
116   * @dev Multiplies two numbers, throws on overflow.
117   */
118   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
119     if (a == 0) {
120       return 0;
121     }
122     c = a * b;
123     assert(c / a == b);
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers, truncating the quotient.
129   */
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     // assert(b > 0); // Solidity automatically throws when dividing by 0
132     // uint256 c = a / b;
133     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134     return a / b;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     assert(b <= a);
142     return a - b;
143   }
144 
145   /**
146   * @dev Adds two numbers, throws on overflow.
147   */
148   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 
155 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
156 
157 /**
158  * @title Ownable
159  * @dev The Ownable contract has an owner address, and provides basic authorization control
160  * functions, this simplifies the implementation of "user permissions".
161  */
162 contract Ownable {
163   address public owner;
164 
165 
166   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168 
169   /**
170    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
171    * account.
172    */
173   constructor() public {
174     owner = msg.sender;
175   }
176 
177   /**
178    * @dev Throws if called by any account other than the owner.
179    */
180   modifier onlyOwner() {
181     require(msg.sender == owner);
182     _;
183   }
184 
185   /**
186    * @dev Allows the current owner to transfer control of the contract to a newOwner.
187    * @param newOwner The address to transfer ownership to.
188    */
189   function transferOwnership(address newOwner) public onlyOwner {
190     require(newOwner != address(0));
191     emit OwnershipTransferred(owner, newOwner);
192     owner = newOwner;
193   }
194 
195 }
196 
197 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
198 
199 /**
200  * @title Whitelist
201  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
202  * @dev This simplifies the implementation of "user permissions".
203  */
204 contract Whitelist is Ownable {
205   mapping(address => bool) public whitelist;
206 
207   event WhitelistedAddressAdded(address addr);
208   event WhitelistedAddressRemoved(address addr);
209 
210   /**
211    * @dev Throws if called by any account that's not whitelisted.
212    */
213   modifier onlyWhitelisted() {
214     require(whitelist[msg.sender]);
215     _;
216   }
217 
218   /**
219    * @dev add an address to the whitelist
220    * @param addr address
221    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
222    */
223   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
224     if (!whitelist[addr]) {
225       whitelist[addr] = true;
226       emit WhitelistedAddressAdded(addr);
227       success = true;
228     }
229   }
230 
231   /**
232    * @dev add addresses to the whitelist
233    * @param addrs addresses
234    * @return true if at least one address was added to the whitelist,
235    * false if all addresses were already in the whitelist
236    */
237   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
238     for (uint256 i = 0; i < addrs.length; i++) {
239       if (addAddressToWhitelist(addrs[i])) {
240         success = true;
241       }
242     }
243   }
244 
245   /**
246    * @dev remove an address from the whitelist
247    * @param addr address
248    * @return true if the address was removed from the whitelist,
249    * false if the address wasn't in the whitelist in the first place
250    */
251   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
252     if (whitelist[addr]) {
253       whitelist[addr] = false;
254       emit WhitelistedAddressRemoved(addr);
255       success = true;
256     }
257   }
258 
259   /**
260    * @dev remove addresses from the whitelist
261    * @param addrs addresses
262    * @return true if at least one address was removed from the whitelist,
263    * false if all addresses weren't in the whitelist in the first place
264    */
265   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
266     for (uint256 i = 0; i < addrs.length; i++) {
267       if (removeAddressFromWhitelist(addrs[i])) {
268         success = true;
269       }
270     }
271   }
272 
273 }
274 
275 // File: contracts/P6.sol
276 
277 // solhint-disable-line
278 
279 
280 
281 
282 
283 
284 /*
285  * Visit: https://p4rty.io
286  * Discord: https://discord.gg/7y3DHYF
287  * Stable + DIVIS: Whale and Minow Friendly
288  * Fees balanced for maximum dividends for ALL
289  * Active depositors rewarded with P4RTY tokens
290  * 50% of ETH value in earned P4RTY token rewards
291  * 2% of dividends fund a gaming bankroll; gaming profits are paid back into P6
292  * P4RTYRelay is notified on all dividend producing transactions
293  * Smart Launch phase which is anti-whale & anti-snipe
294  *
295  * P6
296  * The worry free way to earn A TON OF ETH & P4RTY reward tokens
297  *
298  * -> What?
299  * The first Ethereum Bonded Pure Dividend Token:
300  * [✓] The only dividend printing press that is part of the P4RTY Entertainment Network
301  * [✓] Earn ERC20 P4RTY tokens on all ETH deposit activities
302  * [✓] 3% P6 Faucet for free P6 / P4RTY
303  * [✓] Auto-Reinvests
304  * [✓] 10% exchange fees on buys and sells
305  * [✓] 100 tokens to activate faucet
306  *
307  * -> How?
308  * To replay or use the faucet the contract must be fully launched
309  * To sell or transfer you need to be vested (maximum of 3 days) after a reinvest
310 */
311 
312 contract P6 is Whitelist, SessionQueue {
313 
314 
315     /*=================================
316     =            MODIFIERS            =
317     =================================*/
318 
319     /// @dev Only people with tokens
320     modifier onlyTokenHolders {
321         require(myTokens() > 0);
322         _;
323     }
324 
325     /// @dev Only people with profits
326     modifier onlyDivis {
327         require(myDividends(true) > 0);
328         _;
329     }
330 
331     /// @dev Only invested; If participating in prelaunch have to buy tokens
332     modifier invested {
333         require(stats[msg.sender].invested > 0, "Must buy tokens once to withdraw");
334         _;
335 
336     }
337 
338     /// @dev Owner not allowed
339     modifier ownerRestricted {
340         require(msg.sender != owner, "Reap not available, too soon");
341         _;
342     }
343 
344 
345     /// @dev The faucet has a rewardPeriod
346     modifier teamPlayer {
347         require(msg.sender == owner || now - lastReward[msg.sender] > rewardProcessingPeriod, "No spamming");
348         _;
349     }
350 
351 
352     /*==============================
353     =            EVENTS            =
354     ==============================*/
355 
356     event onLog(
357         string heading,
358         address caller,
359         address subj,
360         uint val
361     );
362 
363     event onTokenPurchase(
364         address indexed customerAddress,
365         uint256 incomingEthereum,
366         uint256 tokensMinted,
367         address indexed referredBy,
368         uint timestamp,
369         uint256 price
370     );
371 
372     event onTokenSell(
373         address indexed customerAddress,
374         uint256 tokensBurned,
375         uint256 ethereumEarned,
376         uint timestamp,
377         uint256 price
378     );
379 
380     event onReinvestment(
381         address indexed customerAddress,
382         uint256 ethereumReinvested,
383         uint256 tokensMinted
384     );
385 
386     event onCommunityReward(
387         address indexed sourceAddress,
388         address indexed destinationAddress,
389         uint256 ethereumEarned
390     );
391 
392     event onReinvestmentProxy(
393         address indexed customerAddress,
394         address indexed destinationAddress,
395         uint256 ethereumReinvested
396     );
397 
398     event onWithdraw(
399         address indexed customerAddress,
400         uint256 ethereumWithdrawn
401     );
402 
403     event onDeposit(
404         address indexed customerAddress,
405         uint256 ethereumDeposited
406     );
407 
408     // ERC20
409     event Transfer(
410         address indexed from,
411         address indexed to,
412         uint256 tokens
413     );
414 
415 
416     /*=====================================
417     =            CONFIGURABLES            =
418     =====================================*/
419 
420     /// @dev 10% dividends for token purchase
421     uint256  internal entryFee_ = 10;
422 
423     /// @dev 1% dividends for token transfer
424     uint256  internal transferFee_ = 1;
425 
426     /// @dev 10% dividends for token selling
427     uint256  internal exitFee_ = 10;
428 
429     /// @dev 3% of entryFee_  is given to faucet
430     /// traditional referral mechanism repurposed as a many to many faucet
431     /// powers auto reinvest
432     uint256  internal referralFee_ = 30;
433 
434     /// @dev 20% of entryFee/exit fee is given to Bankroll
435     uint256  internal maintenanceFee_ = 20;
436     address  internal maintenanceAddress;
437 
438     //Advanced Config
439     uint256 constant internal botAllowance = 10 ether;
440     uint256 constant internal bankrollThreshold = 0.5 ether;
441     uint256 constant internal botThreshold = 0.01 ether;
442     uint256 constant internal launchPeriod = 24 hours;
443     uint256 constant rewardProcessingPeriod = 3 hours;
444     uint256 constant reapPeriod = 7 days;
445     uint256 public  maxProcessingCap = 10;
446     uint256 constant  launchGasMaximum = 500000;
447     uint256 constant launchETHMaximum = 2 ether;
448     uint256 internal creationTime;
449     bool public contractIsLaunched = false;
450     uint public lastReaped;
451 
452 
453     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
454     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
455 
456     uint256 constant internal magnitude = 2 ** 64;
457 
458     /// @dev proof of stake (defaults at 100 tokens)
459     uint256 public stakingRequirement = 100e18;
460 
461 
462     /*=================================
463      =            DATASETS            =
464      ================================*/
465 
466     // bookkeeping for autoreinvest
467     struct Bot {
468         bool active;
469         bool queued;
470         uint256 lastBlock;
471     }
472 
473     // Onchain Stats!!!
474     struct Stats {
475         uint invested;
476         uint reinvested;
477         uint withdrawn;
478         uint rewarded;
479         uint contributed;
480         uint transferredTokens;
481         uint receivedTokens;
482         uint faucetTokens;
483         uint xInvested;
484         uint xReinvested;
485         uint xRewarded;
486         uint xContributed;
487         uint xWithdrawn;
488         uint xTransferredTokens;
489         uint xReceivedTokens;
490         uint xFaucet;
491     }
492 
493 
494     // amount of shares for each address (scaled number)
495     mapping(address => uint256) internal lastReward;
496     mapping(address => uint256) internal tokenBalanceLedger_;
497     mapping(address => uint256) internal referralBalance_;
498     mapping(address => int256) internal payoutsTo_;
499     mapping(address => Bot) internal bot;
500     mapping(address => Stats) internal stats;
501     //on chain referral tracking
502     mapping(address => address) public referrals;
503     uint256 internal tokenSupply_;
504     uint256 internal profitPerShare_;
505 
506     P4RTYRelay internal relay;
507     Bankroll internal bankroll;
508     bool internal bankrollEnabled = true;
509 
510     /*=======================================
511     =            PUBLIC FUNCTIONS           =
512     =======================================*/
513 
514     constructor(address relayAddress)  public {
515 
516         relay = P4RTYRelay(relayAddress);
517         updateMaintenanceAddress(msg.sender);
518         creationTime = now;
519     }
520 
521     //Maintenance Functions
522 
523     /// @dev Minted P4RTY tokens are sent to the maintenance address
524     function updateMaintenanceAddress(address maintenance) onlyOwner public {
525         maintenanceAddress = maintenance;
526     }
527 
528     /// @dev Update the bankroll; 2% of dividends go to the bankroll
529     function updateBankrollAddress(address bankrollAddress) onlyOwner public {
530         bankroll = Bankroll(bankrollAddress);
531     }
532 
533     /// @dev The cap determines the amount of addresses processed when a user runs the faucet
534     function updateProcessingCap(uint cap) onlyOwner public {
535         require(cap >= 5 && cap <= 15, "Capacity set outside of policy range");
536         maxProcessingCap = cap;
537     }
538 
539 
540     function getRegisteredAddresses() public view returns (address[2]){
541         return [address(relay), address(bankroll)];
542     }
543 
544 
545     //Bot Functions
546 
547     /* Activates the bot and queues if necessary; else removes */
548     function activateBot(bool auto) public {
549 
550         if (auto) {
551             // does the referrer have at least X whole tokens?
552             // i.e is the referrer a godly chad masternode
553             // We are doing this to avoid spamming the queue with addresses with no P6
554             require(tokenBalanceLedger_[msg.sender] >= stakingRequirement);
555 
556             bot[msg.sender].active = auto;
557 
558             //Spam protection for customerAddress
559             if (!bot[msg.sender].queued) {
560                 bot[msg.sender].queued = true;
561                 enqueue(msg.sender);
562             }
563 
564         } else {
565             // If you want to turn it off lets just do that
566             bot[msg.sender].active = auto;
567         }
568     }
569 
570     /* Returns if the sender has the reinvestment not enabled */
571     function botEnabled() public view returns (bool){
572         return bot[msg.sender].active;
573     }
574 
575 
576     function fundBankRoll(uint256 amount) internal {
577         bankroll.deposit.value(amount)();
578     }
579 
580     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
581     function buyFor(address _customerAddress) onlyWhitelisted public payable returns (uint256) {
582         return purchaseTokens(_customerAddress, msg.value);
583     }
584 
585     /// @dev Converts all incoming ethereum to tokens for the caller
586     function buy() public payable returns (uint256) {
587 
588         if (contractIsLaunched || msg.sender == owner) {
589             return purchaseTokens(msg.sender, msg.value);
590         } else {
591             return launchBuy();
592         }
593     }
594 
595     /// @dev Provides a buiyin and opens the contract for public use outside of the launch phase
596     function launchBuy() internal returns (uint256){
597 
598         /* YAY WE ARE LAUNCHING BABY!!!! */
599 
600         // BankrollBot needs to buyin
601         require(stats[owner].invested > botAllowance, "The bot requires a minimum war chest to protect and serve");
602 
603         // Keep it fair, but this is crypto...
604         require(SafeMath.add(stats[msg.sender].invested, msg.value) <= launchETHMaximum, "Exceeded investment cap");
605 
606         //See if we are done with the launchPeriod
607         if (now - creationTime > launchPeriod ){
608             contractIsLaunched = true;
609         }
610 
611         return purchaseTokens(msg.sender, msg.value);
612     }
613 
614     /// @dev Returns the remaining time before full launch and max buys
615     function launchTimer() public view returns (uint256){
616        uint lapse = now - creationTime;
617 
618        if (launchPeriod > lapse){
619            return SafeMath.sub(launchPeriod, lapse);
620        }  else {
621            return 0;
622        }
623     }
624 
625     /**
626      * @dev Fallback function to handle ethereum that was send straight to the contract
627      *  Unfortunately we cannot use a referral address this way.
628      */
629     function() payable public {
630         purchaseTokens(msg.sender, msg.value);
631     }
632 
633     /// @dev Converts all of caller's dividends to tokens.
634     function reinvest() onlyDivis public {
635         reinvestFor(msg.sender);
636     }
637 
638     /// @dev Internal utility method for reinvesting
639     function reinvestFor(address _customerAddress) internal returns (uint256) {
640 
641         // fetch dividends
642         uint256 _dividends = totalDividends(_customerAddress, false);
643         // retrieve ref. bonus later in the code
644 
645         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
646 
647         // retrieve ref. bonus
648         _dividends += referralBalance_[_customerAddress];
649         referralBalance_[_customerAddress] = 0;
650 
651         // dispatch a buy order with the virtualized "withdrawn dividends"
652         uint256 _tokens = purchaseTokens(_customerAddress, _dividends);
653 
654         // fire event
655         emit onReinvestment(_customerAddress, _dividends, _tokens);
656 
657         //Stats
658         stats[_customerAddress].reinvested = SafeMath.add(stats[_customerAddress].reinvested, _dividends);
659         stats[_customerAddress].xReinvested += 1;
660 
661         return _tokens;
662 
663     }
664 
665     /// @dev Withdraws all of the callers earnings.
666     function withdraw() onlyDivis  public {
667         withdrawFor(msg.sender);
668     }
669 
670     /// @dev Utility function for withdrawing earnings
671     function withdrawFor(address _customerAddress) internal {
672 
673         // setup data
674         uint256 _dividends = totalDividends(_customerAddress, false);
675         // get ref. bonus later in the code
676 
677         // update dividend tracker
678         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
679 
680         // add ref. bonus
681         _dividends += referralBalance_[_customerAddress];
682         referralBalance_[_customerAddress] = 0;
683 
684         // lambo delivery service
685         _customerAddress.transfer(_dividends);
686 
687         //stats
688         stats[_customerAddress].withdrawn = SafeMath.add(stats[_customerAddress].withdrawn, _dividends);
689         stats[_customerAddress].xWithdrawn += 1;
690 
691         // fire event
692         emit onWithdraw(_customerAddress, _dividends);
693     }
694 
695 
696     /// @dev Liquifies tokens to ethereum.
697     function sell(uint256 _amountOfTokens) onlyTokenHolders ownerRestricted public {
698         address _customerAddress = msg.sender;
699 
700         //Selling deactivates auto reinvest
701         bot[_customerAddress].active = false;
702 
703 
704         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
705         uint256 _tokens = _amountOfTokens;
706         uint256 _ethereum = tokensToEthereum_(_tokens);
707 
708 
709         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
710         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
711         //maintenance and referral come out of the exitfee
712         uint256 _dividends = SafeMath.sub(_undividedDividends, _maintenance);
713         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _undividedDividends);
714 
715         // burn the sold tokens
716         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
717         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
718 
719         // update dividends tracker
720         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
721         payoutsTo_[_customerAddress] -= _updatedPayouts;
722 
723 
724         //Apply maintenance fee to the bankroll
725         fundBankRoll(_maintenance);
726 
727         // dividing by zero is a bad idea
728         if (tokenSupply_ > 0) {
729             // update the amount of dividends per token
730             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
731         }
732 
733         // fire event
734         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
735 
736         //GO!!! Bankroll Bot GO!!!
737         brbReinvest(_customerAddress);
738     }
739 
740     //@dev Bankroll Bot can only transfer 10% of funds during a reapPeriod
741     //Its funds will always be locked because it always reinvests
742     function reap(address _toAddress) public onlyOwner {
743         require(now - lastReaped > reapPeriod, "Reap not available, too soon");
744         lastReaped = now;
745         transferTokens(owner, _toAddress, SafeMath.div(balanceOf(owner), 10));
746 
747     }
748 
749     /**
750      * @dev Transfer tokens from the caller to a new holder.
751      *  Remember, there's a 1% fee here as well.
752      */
753     function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders ownerRestricted external returns (bool){
754         address _customerAddress = msg.sender;
755         return transferTokens(_customerAddress, _toAddress, _amountOfTokens);
756     }
757 
758     /// @dev Utility function for transfering tokens
759     function transferTokens(address _customerAddress, address _toAddress, uint256 _amountOfTokens) internal returns (bool){
760 
761         // make sure we have the requested tokens
762         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
763 
764         // withdraw all outstanding dividends first
765         if (totalDividends(_customerAddress, true) > 0) {
766             withdrawFor(_customerAddress);
767         }
768 
769         // liquify a percentage of the tokens that are transfered
770         // these are dispersed to shareholders
771         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
772         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
773         uint256 _dividends = tokensToEthereum_(_tokenFee);
774 
775         // burn the fee tokens
776         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
777 
778         // exchange tokens
779         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
780         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
781 
782         // update dividend trackers
783         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
784         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
785 
786         // disperse dividends among holders
787         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
788 
789         // fire event
790         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
791 
792         //Stats
793         stats[_customerAddress].xTransferredTokens += 1;
794         stats[_customerAddress].transferredTokens += _amountOfTokens;
795         stats[_toAddress].receivedTokens += _taxedTokens;
796         stats[_toAddress].xReceivedTokens += 1;
797 
798         // ERC20
799         return true;
800     }
801 
802 
803     /*=====================================
804     =      HELPERS AND CALCULATORS        =
805     =====================================*/
806 
807     /**
808      * @dev Method to view the current Ethereum stored in the contract
809      *  Example: totalEthereumBalance()
810      */
811     function totalEthereumBalance() public view returns (uint256) {
812         return address(this).balance;
813     }
814 
815     /// @dev Retrieve the total token supply.
816     function totalSupply() public view returns (uint256) {
817         return tokenSupply_;
818     }
819 
820     /// @dev Retrieve the tokens owned by the caller.
821     function myTokens() public view returns (uint256) {
822         address _customerAddress = msg.sender;
823         return balanceOf(_customerAddress);
824     }
825 
826     /**
827      * @dev Retrieve the dividends owned by the caller.
828      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
829      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
830      *  But in the internal calculations, we want them separate.
831      */
832     /**
833      * @dev Retrieve the dividends owned by the caller.
834      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
835      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
836      *  But in the internal calculations, we want them separate.
837      */
838     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
839         return totalDividends(msg.sender, _includeReferralBonus);
840     }
841 
842     function totalDividends(address _customerAddress, bool _includeReferralBonus) internal view returns (uint256) {
843         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
844     }
845 
846     /// @dev Retrieve the token balance of any single address.
847     function balanceOf(address _customerAddress) public view returns (uint256) {
848         return tokenBalanceLedger_[_customerAddress];
849     }
850 
851     /// @dev Stats of any single address
852     function statsOf(address _customerAddress) public view returns (uint256[16]){
853         Stats memory s = stats[_customerAddress];
854         uint256[16] memory statArray = [s.invested, s.withdrawn, s.rewarded, s.contributed, s.transferredTokens, s.receivedTokens, s.xInvested, s.xRewarded, s.xContributed, s.xWithdrawn, s.xTransferredTokens, s.xReceivedTokens, s.reinvested, s.xReinvested, s.faucetTokens, s.xFaucet];
855         return statArray;
856     }
857 
858     /// @dev Retrieve the dividend balance of any single address.
859     function dividendsOf(address _customerAddress) public view returns (uint256) {
860         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
861     }
862 
863     /// @dev Return the sell price of 1 individual token.
864     function sellPrice() public view returns (uint256) {
865         // our calculation relies on the token supply, so we need supply. Doh.
866         if (tokenSupply_ == 0) {
867             return tokenPriceInitial_ - tokenPriceIncremental_;
868         } else {
869             uint256 _ethereum = tokensToEthereum_(1e18);
870             uint256 _dividends = SafeMath.div(_ethereum, exitFee_);
871             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
872             return _taxedEthereum;
873         }
874 
875     }
876 
877     /// @dev Return the buy price of 1 individual token.
878     function buyPrice() public view returns (uint256) {
879         // our calculation relies on the token supply, so we need supply. Doh.
880         if (tokenSupply_ == 0) {
881             return tokenPriceInitial_ + tokenPriceIncremental_;
882         } else {
883             uint256 _ethereum = tokensToEthereum_(1e18);
884             uint256 _dividends = SafeMath.div(_ethereum, entryFee_);
885             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
886             return _taxedEthereum;
887         }
888 
889     }
890 
891     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
892     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
893         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
894         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
895         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
896 
897         return _amountOfTokens;
898     }
899 
900     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
901     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
902         require(_tokensToSell <= tokenSupply_);
903         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
904         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
905         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
906         return _taxedEthereum;
907     }
908 
909 
910     /*==========================================
911     =            INTERNAL FUNCTIONS            =
912     ==========================================*/
913 
914     /// @dev Internal function to actually purchase the tokens.
915     function purchaseTokens(address _customerAddress, uint256 _incomingEthereum) internal returns (uint256) {
916         // data setup
917         address _referredBy = msg.sender;
918         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
919         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
920         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
921         //maintenance and referral come out of the buyin
922         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus, _maintenance));
923         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
924         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
925         uint256 _fee = _dividends * magnitude;
926         uint256 _tokenAllocation = SafeMath.div(_incomingEthereum, 2);
927 
928 
929         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
930         // (or hackers)
931         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
932         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
933 
934         //Apply maintenance fee to bankroll
935         fundBankRoll(_maintenance);
936 
937         // is the user referred by a masternode?
938         if (
939 
940         // no cheating!
941             _referredBy != _customerAddress &&
942 
943             // does the referrer have at least X whole tokens?
944             // i.e is the referrer a godly chad masternode
945             tokenBalanceLedger_[_referredBy] >= stakingRequirement
946         ) {
947             // wealth redistribution
948             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
949 
950             //Stats
951             stats[_referredBy].rewarded = SafeMath.add(stats[_referredBy].rewarded, _referralBonus);
952             stats[_referredBy].xRewarded += 1;
953             stats[_customerAddress].contributed = SafeMath.add(stats[_customerAddress].contributed, _referralBonus);
954             stats[_customerAddress].xContributed += 1;
955 
956             //It pays to play
957             emit onCommunityReward(_customerAddress, _referredBy, _referralBonus);
958         } else {
959             // no ref purchase
960             // add the referral bonus back to the global dividends cake
961             _dividends = SafeMath.add(_dividends, _referralBonus);
962             _fee = _dividends * magnitude;
963         }
964 
965         // we can't give people infinite ethereum
966         if (tokenSupply_ > 0) {
967             // add tokens to the pool
968             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
969 
970             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
971             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
972 
973             // calculate the amount of tokens the customer receives over his purchase
974             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
975         } else {
976             // add tokens to the pool
977             tokenSupply_ = _amountOfTokens;
978         }
979 
980         // update circulating supply & the ledger address for the customer
981         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
982 
983         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
984         // really i know you think you do but you don't
985         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
986         payoutsTo_[_customerAddress] += _updatedPayouts;
987 
988         //Notifying the relay is simple and should represent the total economic activity which is the _incomingEthereum
989         //Every player is a customer and mints their own tokens when the buy or reinvest, relay P4RTY 50/50
990         relay.relay(maintenanceAddress, _tokenAllocation);
991         relay.relay(_customerAddress, _tokenAllocation);
992 
993         // fire event
994         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
995 
996         //Stats
997         stats[_customerAddress].invested = SafeMath.add(stats[_customerAddress].invested, _incomingEthereum);
998         stats[_customerAddress].xInvested += 1;
999 
1000         //GO!!! Bankroll Bot GO!!!
1001         brbReinvest(_customerAddress);
1002 
1003         return _amountOfTokens;
1004     }
1005 
1006     /**
1007      * Calculate Token price based on an amount of incoming ethereum
1008      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1009      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1010      */
1011     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256)
1012     {
1013         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1014         uint256 _tokensReceived =
1015         (
1016         (
1017         // underflow attempts BTFO
1018         SafeMath.sub(
1019             (sqrt
1020         (
1021             (_tokenPriceInitial ** 2)
1022             +
1023             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
1024             +
1025             (((tokenPriceIncremental_) ** 2) * (tokenSupply_ ** 2))
1026             +
1027             (2 * (tokenPriceIncremental_) * _tokenPriceInitial * tokenSupply_)
1028         )
1029             ), _tokenPriceInitial
1030         )
1031         ) / (tokenPriceIncremental_)
1032         ) - (tokenSupply_)
1033         ;
1034 
1035         return _tokensReceived;
1036     }
1037 
1038     /**
1039      * Calculate token sell value.
1040      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1041      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1042      */
1043     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256)
1044     {
1045 
1046         uint256 tokens_ = (_tokens + 1e18);
1047         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1048         uint256 _etherReceived =
1049         (
1050         // underflow attempts BTFO
1051         SafeMath.sub(
1052             (
1053             (
1054             (
1055             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
1056             ) - tokenPriceIncremental_
1057             ) * (tokens_ - 1e18)
1058             ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
1059         )
1060         / 1e18);
1061         return _etherReceived;
1062     }
1063 
1064     /*
1065         Is end user eligible to process rewards?
1066     */
1067     function rewardAvailable() public view returns (bool){
1068         return available() && now - lastReward[msg.sender] > rewardProcessingPeriod &&
1069         tokenBalanceLedger_[msg.sender] >= stakingRequirement;
1070     }
1071 
1072     /// @dev Returns timer info used for the vesting and the faucet
1073     function timerInfo() public view returns (uint, uint, uint){
1074         return (now, lastReward[msg.sender], rewardProcessingPeriod);
1075     }
1076 
1077 
1078     //This is where all your gas goes, sorry
1079     //Not sorry, you probably only paid 1 gwei
1080     function sqrt(uint x) internal pure returns (uint y) {
1081         uint z = (x + 1) / 2;
1082         y = x;
1083         while (z < y) {
1084             y = z;
1085             z = (x / z + z) / 2;
1086         }
1087     }
1088 
1089     //
1090     // BankRollBot Functions
1091     //
1092 
1093     //Reinvest on all buys and sells
1094     function brbReinvest(address _customerAddress) internal {
1095         if (_customerAddress != owner && bankrollEnabled) {
1096             if (totalDividends(owner, true) > bankrollThreshold) {
1097                 reinvestFor(owner);
1098             }
1099         }
1100 
1101 
1102     }
1103 
1104     /*
1105         Can only be run once per day from the caller avoid bots
1106         Minimum of 100 P6
1107         Minimum of 5 P4RTY + amount minted based on dividends processed in 24 hour period
1108     */
1109     function processRewards() public teamPlayer {
1110         require(tokenBalanceLedger_[msg.sender] >= stakingRequirement, "Must meet staking requirement");
1111 
1112 
1113         uint256 count = 0;
1114         address _customer;
1115 
1116         while (available() && count < maxProcessingCap) {
1117 
1118             //If this queue has already been processed in this block exit without altering the queue
1119             _customer = peek();
1120 
1121             if (bot[_customer].lastBlock == block.number) {
1122                 break;
1123             }
1124 
1125             //Pop
1126             dequeue();
1127 
1128 
1129             //Update tracking
1130             bot[_customer].lastBlock = block.number;
1131             bot[_customer].queued = false;
1132 
1133             //User could have deactivated while still being queued
1134             if (bot[_customer].active) {
1135 
1136                 // don't queue or process empty accounts
1137                 if (tokenBalanceLedger_[_customer] >= stakingRequirement) {
1138 
1139                     //Reinvest divs; be gas efficient
1140                     if (totalDividends(_customer, true) > botThreshold) {
1141 
1142                         //No bankroll reinvest when processing the queue
1143                         bankrollEnabled = false;
1144                         reinvestFor(_customer);
1145                         bankrollEnabled = true;
1146                     }
1147 
1148                     enqueue(_customer);
1149                     bot[_customer].queued = true;
1150 
1151                 } else {
1152                     // If minimums aren't met deactivate
1153                     bot[_customer].active = false;
1154                 }
1155             }
1156 
1157             count++;
1158         }
1159 
1160         stats[msg.sender].xFaucet += 1;
1161         lastReward[msg.sender] = now;
1162         stats[msg.sender].faucetTokens = reinvestFor(msg.sender);
1163     }
1164 
1165 
1166 }