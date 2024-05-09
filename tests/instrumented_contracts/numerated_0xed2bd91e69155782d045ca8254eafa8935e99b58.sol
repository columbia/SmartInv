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
334 
335         _;
336 
337     }
338 
339     /// @dev After every reinvest features are protected by a cooloff to vest funds
340     modifier cooledOff {
341         require(msg.sender == owner && !contractIsLaunched || now - bot[msg.sender].coolOff > coolOffPeriod);
342         _;
343     }
344 
345     /// @dev The faucet has a rewardPeriod
346     modifier teamPlayer {
347         require(msg.sender == owner || now - lastReward[msg.sender] > rewardProcessingPeriod, "No spamming");
348         _;
349     }
350 
351     /// @dev Functions only available after launch
352     modifier launched {
353         require(contractIsLaunched || msg.sender == owner, "Contract not lauched");
354         _;
355     }
356 
357 
358     /*==============================
359     =            EVENTS            =
360     ==============================*/
361 
362     event onLog(
363         string heading,
364         address caller,
365         address subj,
366         uint val
367     );
368 
369     event onTokenPurchase(
370         address indexed customerAddress,
371         uint256 incomingEthereum,
372         uint256 tokensMinted,
373         address indexed referredBy,
374         uint timestamp,
375         uint256 price
376     );
377 
378     event onTokenSell(
379         address indexed customerAddress,
380         uint256 tokensBurned,
381         uint256 ethereumEarned,
382         uint timestamp,
383         uint256 price
384     );
385 
386     event onReinvestment(
387         address indexed customerAddress,
388         uint256 ethereumReinvested,
389         uint256 tokensMinted
390     );
391 
392     event onCommunityReward(
393         address indexed sourceAddress,
394         address indexed destinationAddress,
395         uint256 ethereumEarned
396     );
397 
398     event onReinvestmentProxy(
399         address indexed customerAddress,
400         address indexed destinationAddress,
401         uint256 ethereumReinvested
402     );
403 
404     event onWithdraw(
405         address indexed customerAddress,
406         uint256 ethereumWithdrawn
407     );
408 
409     event onDeposit(
410         address indexed customerAddress,
411         uint256 ethereumDeposited
412     );
413 
414     // ERC20
415     event Transfer(
416         address indexed from,
417         address indexed to,
418         uint256 tokens
419     );
420 
421 
422     /*=====================================
423     =            CONFIGURABLES            =
424     =====================================*/
425 
426     /// @dev 10% dividends for token purchase
427     uint256  internal entryFee_ = 10;
428 
429     /// @dev 1% dividends for token transfer
430     uint256  internal transferFee_ = 1;
431 
432     /// @dev 10% dividends for token selling
433     uint256  internal exitFee_ = 10;
434 
435     /// @dev 3% of entryFee_  is given to faucet
436     /// traditional referral mechanism repurposed as a many to many faucet
437     /// powers auto reinvest
438     uint256  internal referralFee_ = 30;
439 
440     /// @dev 20% of entryFee/exit fee is given to Bankroll
441     uint256  internal maintenanceFee_ = 20;
442     address  internal maintenanceAddress;
443 
444     //Advanced Config
445     uint256 constant internal bankrollThreshold = 0.5 ether;
446     uint256 constant internal botThreshold = 0.01 ether;
447     uint256 constant rewardProcessingPeriod = 6 hours;
448     uint256 constant reapPeriod = 7 days;
449     uint256 public  maxProcessingCap = 10;
450 
451     uint256 public coolOffPeriod = 3 days;
452     uint256 public launchETHMaximum = 20 ether;
453     bool public contractIsLaunched = false;
454     uint public lastReaped;
455 
456 
457     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
458     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
459 
460     uint256 constant internal magnitude = 2 ** 64;
461 
462     /// @dev proof of stake (defaults at 100 tokens)
463     uint256 public stakingRequirement = 100e18;
464 
465 
466     /*=================================
467      =            DATASETS            =
468      ================================*/
469 
470     // bookkeeping for autoreinvest
471     struct Bot {
472         bool active;
473         bool queued;
474         uint256 lastBlock;
475         uint256 coolOff;
476     }
477 
478     // Onchain Stats!!!
479     struct Stats {
480         uint invested;
481         uint reinvested;
482         uint withdrawn;
483         uint rewarded;
484         uint contributed;
485         uint transferredTokens;
486         uint receivedTokens;
487         uint xInvested;
488         uint xReinvested;
489         uint xRewarded;
490         uint xContributed;
491         uint xWithdrawn;
492         uint xTransferredTokens;
493         uint xReceivedTokens;
494     }
495 
496 
497     // amount of shares for each address (scaled number)
498     mapping(address => uint256) internal lastReward;
499     mapping(address => uint256) internal tokenBalanceLedger_;
500     mapping(address => uint256) internal referralBalance_;
501     mapping(address => int256) internal payoutsTo_;
502     mapping(address => Bot) internal bot;
503     mapping(address => Stats) internal stats;
504     //on chain referral tracking
505     mapping(address => address) public referrals;
506     uint256 internal tokenSupply_;
507     uint256 internal profitPerShare_;
508 
509     P4RTYRelay public relay;
510     Bankroll public bankroll;
511     bool internal bankrollEnabled = true;
512 
513     /*=======================================
514     =            PUBLIC FUNCTIONS           =
515     =======================================*/
516 
517     constructor(address relayAddress)  public {
518 
519         relay = P4RTYRelay(relayAddress);
520         updateMaintenanceAddress(msg.sender);
521     }
522 
523     //Maintenance Functions
524 
525     /// @dev Minted P4RTY tokens are sent to the maintenance address
526     function updateMaintenanceAddress(address maintenance) onlyOwner public {
527         maintenanceAddress = maintenance;
528     }
529 
530     /// @dev Update the bankroll; 2% of dividends go to the bankroll
531     function updateBankrollAddress(address bankrollAddress) onlyOwner public {
532         bankroll = Bankroll(bankrollAddress);
533     }
534 
535     /// @dev The cap determines the amount of addresses processed when a user runs the faucet
536     function updateProcessingCap(uint cap) onlyOwner public {
537         require(cap >= 5 && cap <= 15, "Capacity set outside of policy range");
538         maxProcessingCap = cap;
539     }
540 
541     /// @dev Updates the coolOff period where reinvest must vest
542     function updateCoolOffPeriod(uint coolOff) onlyOwner public {
543         require(coolOff >= 5 minutes && coolOff <= 3 days);
544         coolOffPeriod = coolOff;
545     }
546 
547     /// @dev Opens the contract for public use outside of the launch phase
548     function launchContract() onlyOwner public {
549         contractIsLaunched = true;
550     }
551 
552 
553     //Bot Functions
554 
555     /* Activates the bot and queues if necessary; else removes */
556     function activateBot(bool auto) public {
557         bot[msg.sender].active = auto;
558 
559         //Spam protection for customerAddress
560         if (bot[msg.sender].active) {
561             if (!bot[msg.sender].queued) {
562                 bot[msg.sender].queued = true;
563                 enqueue(msg.sender);
564             }
565         }
566     }
567 
568     /* Returns if the sender has the reinvestment not enabled */
569     function botEnabled() public view returns (bool){
570         return bot[msg.sender].active;
571     }
572 
573 
574     function fundBankRoll(uint256 amount) internal {
575         bankroll.deposit.value(amount)();
576     }
577 
578     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
579     function buyFor(address _customerAddress) onlyWhitelisted public payable returns (uint256) {
580         return purchaseTokens(_customerAddress, msg.value);
581     }
582 
583     /// @dev Converts all incoming ethereum to tokens for the caller
584     function buy() public payable returns (uint256) {
585         if (contractIsLaunched){
586             //ETH sent during prelaunch needs to be processed
587             if(stats[msg.sender].invested == 0 && referralBalance_[msg.sender] > 0){
588                 reinvestFor(msg.sender);
589             }
590             return purchaseTokens(msg.sender, msg.value);
591         }  else {
592             //Just deposit funds
593             return deposit();
594         }
595     }
596 
597     function deposit() internal returns (uint256) {
598         require(msg.value > 0);
599 
600         //Just add to the referrals for sidelined ETH
601         referralBalance_[msg.sender] = SafeMath.add(referralBalance_[msg.sender], msg.value);
602 
603         require(referralBalance_[msg.sender] <= launchETHMaximum, "Exceeded investment cap");
604 
605         emit onDeposit(msg.sender, msg.value);
606 
607         return 0;
608 
609     }
610 
611     /**
612      * @dev Fallback function to handle ethereum that was send straight to the contract
613      *  Unfortunately we cannot use a referral address this way.
614      */
615     function() payable public {
616         purchaseTokens(msg.sender, msg.value);
617     }
618 
619     /// @dev Converts all of caller's dividends to tokens.
620     function reinvest() onlyDivis launched public {
621         reinvestFor(msg.sender);
622     }
623 
624     /// @dev Allows owner to reinvest on behalf of a supporter
625     function investSupporter(address _customerAddress) public onlyOwner {
626         require(!contractIsLaunched, "Contract already opened");
627         reinvestFor(_customerAddress);
628     }
629 
630     /// @dev Internal utility method for reinvesting
631     function reinvestFor(address _customerAddress) internal {
632 
633         // fetch dividends
634         uint256 _dividends = totalDividends(_customerAddress, false);
635         // retrieve ref. bonus later in the code
636 
637         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
638 
639         // retrieve ref. bonus
640         _dividends += referralBalance_[_customerAddress];
641         referralBalance_[_customerAddress] = 0;
642 
643         // dispatch a buy order with the virtualized "withdrawn dividends"
644         uint256 _tokens = purchaseTokens(_customerAddress, _dividends);
645 
646         // fire event
647         emit onReinvestment(_customerAddress, _dividends, _tokens);
648 
649         //Stats
650         stats[_customerAddress].reinvested = SafeMath.add(stats[_customerAddress].reinvested, _dividends);
651         stats[_customerAddress].xReinvested += 1;
652 
653         //Refresh the coolOff
654         bot[_customerAddress].coolOff = now;
655 
656     }
657 
658     /// @dev Withdraws all of the callers earnings.
659     function withdraw() onlyDivis  invested public {
660         withdrawFor(msg.sender);
661     }
662 
663     /// @dev Utility function for withdrawing earnings
664     function withdrawFor(address _customerAddress) internal {
665 
666         // setup data
667         uint256 _dividends = totalDividends(_customerAddress, false);
668         // get ref. bonus later in the code
669 
670         // update dividend tracker
671         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
672 
673         // add ref. bonus
674         _dividends += referralBalance_[_customerAddress];
675         referralBalance_[_customerAddress] = 0;
676 
677         // lambo delivery service
678         _customerAddress.transfer(_dividends);
679 
680         //stats
681         stats[_customerAddress].withdrawn = SafeMath.add(stats[_customerAddress].withdrawn, _dividends);
682         stats[_customerAddress].xWithdrawn += 1;
683 
684         // fire event
685         emit onWithdraw(_customerAddress, _dividends);
686     }
687 
688 
689     /// @dev Liquifies tokens to ethereum.
690     function sell(uint256 _amountOfTokens) onlyTokenHolders cooledOff public {
691         address _customerAddress = msg.sender;
692 
693         //Selling deactivates auto reinvest
694         bot[_customerAddress].active = false;
695 
696 
697         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
698         uint256 _tokens = _amountOfTokens;
699         uint256 _ethereum = tokensToEthereum_(_tokens);
700 
701 
702         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
703         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
704         //maintenance and referral come out of the exitfee
705         uint256 _dividends = SafeMath.sub(_undividedDividends, _maintenance);
706         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _undividedDividends);
707 
708         // burn the sold tokens
709         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
710         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
711 
712         // update dividends tracker
713         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
714         payoutsTo_[_customerAddress] -= _updatedPayouts;
715 
716 
717         //Apply maintenance fee to the bankroll
718         fundBankRoll(_maintenance);
719 
720         // dividing by zero is a bad idea
721         if (tokenSupply_ > 0) {
722             // update the amount of dividends per token
723             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
724         }
725 
726         // fire event
727         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
728 
729         //GO!!! Bankroll Bot GO!!!
730         brbReinvest(_customerAddress);
731     }
732 
733     //@dev Bankroll Bot can only transfer 10% of funds during a reapPeriod
734     //Its funds will always be locked because it always reinvests
735     function reap(address _toAddress) public onlyOwner {
736         require(now - lastReaped > reapPeriod, "Reap not available, too soon");
737         lastReaped = now;
738         transferTokens(owner, _toAddress, SafeMath.div(balanceOf(owner), 10));
739 
740     }
741 
742     /**
743      * @dev Transfer tokens from the caller to a new holder.
744      *  Remember, there's a 1% fee here as well.
745      */
746     function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders cooledOff external returns (bool){
747         address _customerAddress = msg.sender;
748         return transferTokens(_customerAddress, _toAddress, _amountOfTokens);
749     }
750 
751     /// @dev Utility function for transfering tokens
752     function transferTokens(address _customerAddress, address _toAddress, uint256 _amountOfTokens)  internal returns (bool){
753 
754         // make sure we have the requested tokens
755         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
756 
757         // withdraw all outstanding dividends first
758         if (totalDividends(_customerAddress,true) > 0) {
759             withdrawFor(_customerAddress);
760         }
761 
762         // liquify a percentage of the tokens that are transfered
763         // these are dispersed to shareholders
764         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
765         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
766         uint256 _dividends = tokensToEthereum_(_tokenFee);
767 
768         // burn the fee tokens
769         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
770 
771         // exchange tokens
772         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
773         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
774 
775         // update dividend trackers
776         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
777         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
778 
779         // disperse dividends among holders
780         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
781 
782         // fire event
783         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
784 
785         //Stats
786         stats[_customerAddress].xTransferredTokens += 1;
787         stats[_customerAddress].transferredTokens += _amountOfTokens;
788         stats[_toAddress].receivedTokens += _taxedTokens;
789         stats[_toAddress].xReceivedTokens += 1;
790 
791         // ERC20
792         return true;
793     }
794 
795 
796     /*=====================================
797     =      HELPERS AND CALCULATORS        =
798     =====================================*/
799 
800     /**
801      * @dev Method to view the current Ethereum stored in the contract
802      *  Example: totalEthereumBalance()
803      */
804     function totalEthereumBalance() public view returns (uint256) {
805         return address(this).balance;
806     }
807 
808     /// @dev Retrieve the total token supply.
809     function totalSupply() public view returns (uint256) {
810         return tokenSupply_;
811     }
812 
813     /// @dev Retrieve the tokens owned by the caller.
814     function myTokens() public view returns (uint256) {
815         address _customerAddress = msg.sender;
816         return balanceOf(_customerAddress);
817     }
818 
819     /**
820      * @dev Retrieve the dividends owned by the caller.
821      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
822      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
823      *  But in the internal calculations, we want them separate.
824      */
825     /**
826      * @dev Retrieve the dividends owned by the caller.
827      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
828      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
829      *  But in the internal calculations, we want them separate.
830      */
831     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
832         return totalDividends(msg.sender, _includeReferralBonus);
833     }
834 
835     function totalDividends(address _customerAddress, bool _includeReferralBonus) internal view returns (uint256) {
836         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
837     }
838 
839     /// @dev Retrieve the token balance of any single address.
840     function balanceOf(address _customerAddress) public view returns (uint256) {
841         return tokenBalanceLedger_[_customerAddress];
842     }
843 
844     /// @dev Stats of any single address
845     function statsOf(address _customerAddress) public view returns (uint256[14]){
846         Stats memory s = stats[_customerAddress];
847         uint256[14] memory statArray = [s.invested, s.withdrawn, s.rewarded, s.contributed, s.transferredTokens, s.receivedTokens, s.xInvested, s.xRewarded, s.xContributed, s.xWithdrawn, s.xTransferredTokens, s.xReceivedTokens, s.reinvested, s.xReinvested];
848         return statArray;
849     }
850 
851     /// @dev Retrieve the dividend balance of any single address.
852     function dividendsOf(address _customerAddress) public view returns (uint256) {
853         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
854     }
855 
856     /// @dev Return the sell price of 1 individual token.
857     function sellPrice() public view returns (uint256) {
858         // our calculation relies on the token supply, so we need supply. Doh.
859         if (tokenSupply_ == 0) {
860             return tokenPriceInitial_ - tokenPriceIncremental_;
861         } else {
862             uint256 _ethereum = tokensToEthereum_(1e18);
863             uint256 _dividends = SafeMath.div(_ethereum, exitFee_);
864             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
865             return _taxedEthereum;
866         }
867 
868     }
869 
870     /// @dev Return the buy price of 1 individual token.
871     function buyPrice() public view returns (uint256) {
872         // our calculation relies on the token supply, so we need supply. Doh.
873         if (tokenSupply_ == 0) {
874             return tokenPriceInitial_ + tokenPriceIncremental_;
875         } else {
876             uint256 _ethereum = tokensToEthereum_(1e18);
877             uint256 _dividends = SafeMath.div(_ethereum, entryFee_);
878             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
879             return _taxedEthereum;
880         }
881 
882     }
883 
884     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
885     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
886         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
887         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
888         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
889 
890         return _amountOfTokens;
891     }
892 
893     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
894     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
895         require(_tokensToSell <= tokenSupply_);
896         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
897         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
898         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
899         return _taxedEthereum;
900     }
901 
902 
903     /*==========================================
904     =            INTERNAL FUNCTIONS            =
905     ==========================================*/
906 
907     /// @dev Internal function to actually purchase the tokens.
908     function purchaseTokens(address _customerAddress, uint256 _incomingEthereum) internal returns (uint256) {
909         // data setup
910         address _referredBy = msg.sender;
911         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
912         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
913         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
914         //maintenance and referral come out of the buyin
915         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus, _maintenance));
916         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
917         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
918         uint256 _fee = _dividends * magnitude;
919         uint256 _tokenAllocation = SafeMath.div(_incomingEthereum, 2);
920 
921 
922         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
923         // (or hackers)
924         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
925         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
926 
927         //Apply maintenance fee to bankroll
928         fundBankRoll(_maintenance);
929 
930         // is the user referred by a masternode?
931         if (
932 
933         // no cheating!
934             _referredBy != _customerAddress &&
935 
936             // does the referrer have at least X whole tokens?
937             // i.e is the referrer a godly chad masternode
938             tokenBalanceLedger_[_referredBy] >= stakingRequirement
939         ) {
940             // wealth redistribution
941             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
942 
943             //Stats
944             stats[_referredBy].rewarded = SafeMath.add(stats[_referredBy].rewarded, _referralBonus);
945             stats[_referredBy].xRewarded += 1;
946             stats[_customerAddress].contributed = SafeMath.add(stats[_customerAddress].contributed, _referralBonus);
947             stats[_customerAddress].xContributed += 1;
948 
949             //It pays to play
950             emit onCommunityReward(_customerAddress, _referredBy, _referralBonus);
951         } else {
952             // no ref purchase
953             // add the referral bonus back to the global dividends cake
954             _dividends = SafeMath.add(_dividends, _referralBonus);
955             _fee = _dividends * magnitude;
956         }
957 
958         // we can't give people infinite ethereum
959         if (tokenSupply_ > 0) {
960             // add tokens to the pool
961             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
962 
963             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
964             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
965 
966             // calculate the amount of tokens the customer receives over his purchase
967             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
968         } else {
969             // add tokens to the pool
970             tokenSupply_ = _amountOfTokens;
971         }
972 
973         // update circulating supply & the ledger address for the customer
974         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
975 
976         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
977         // really i know you think you do but you don't
978         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
979         payoutsTo_[_customerAddress] += _updatedPayouts;
980 
981         //Notifying the relay is simple and should represent the total economic activity which is the _incomingEthereum
982         //Every player is a customer and mints their own tokens when the buy or reinvest, relay P4RTY 50/50
983         relay.relay(maintenanceAddress, _tokenAllocation);
984         relay.relay(_customerAddress, _tokenAllocation);
985 
986         // fire event
987         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
988 
989         //Stats
990         stats[_customerAddress].invested = SafeMath.add(stats[_customerAddress].invested, _incomingEthereum);
991         stats[_customerAddress].xInvested += 1;
992 
993         //GO!!! Bankroll Bot GO!!!
994         brbReinvest(_customerAddress);
995 
996         return _amountOfTokens;
997     }
998 
999     /**
1000      * Calculate Token price based on an amount of incoming ethereum
1001      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1002      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1003      */
1004     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256)
1005     {
1006         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1007         uint256 _tokensReceived =
1008         (
1009         (
1010         // underflow attempts BTFO
1011         SafeMath.sub(
1012             (sqrt
1013         (
1014             (_tokenPriceInitial ** 2)
1015             +
1016             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
1017             +
1018             (((tokenPriceIncremental_) ** 2) * (tokenSupply_ ** 2))
1019             +
1020             (2 * (tokenPriceIncremental_) * _tokenPriceInitial * tokenSupply_)
1021         )
1022             ), _tokenPriceInitial
1023         )
1024         ) / (tokenPriceIncremental_)
1025         ) - (tokenSupply_)
1026         ;
1027 
1028         return _tokensReceived;
1029     }
1030 
1031     /**
1032      * Calculate token sell value.
1033      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1034      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1035      */
1036     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256)
1037     {
1038 
1039         uint256 tokens_ = (_tokens + 1e18);
1040         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1041         uint256 _etherReceived =
1042         (
1043         // underflow attempts BTFO
1044         SafeMath.sub(
1045             (
1046             (
1047             (
1048             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
1049             ) - tokenPriceIncremental_
1050             ) * (tokens_ - 1e18)
1051             ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
1052         )
1053         / 1e18);
1054         return _etherReceived;
1055     }
1056 
1057 
1058     /// @dev Returns true if the tokens are fully vested after a reinvest
1059     function isVested() public view returns (bool) {
1060         return now - bot[msg.sender].coolOff > coolOffPeriod;
1061     }
1062 
1063     /*
1064         Is end user eligible to process rewards?
1065     */
1066     function rewardAvailable() public view returns (bool){
1067         return available() && now - lastReward[msg.sender] > rewardProcessingPeriod &&
1068         tokenBalanceLedger_[msg.sender] >= stakingRequirement;
1069     }
1070 
1071     /// @dev Returns timer info used for the vesting and the faucet
1072     function timerInfo() public view returns (uint, uint[2], uint[2]){
1073         return (now, [bot[msg.sender].coolOff, coolOffPeriod], [lastReward[msg.sender], rewardProcessingPeriod]);
1074     }
1075 
1076 
1077     //This is where all your gas goes, sorry
1078     //Not sorry, you probably only paid 1 gwei
1079     function sqrt(uint x) internal pure returns (uint y) {
1080         uint z = (x + 1) / 2;
1081         y = x;
1082         while (z < y) {
1083             y = z;
1084             z = (x / z + z) / 2;
1085         }
1086     }
1087 
1088     //
1089     // BankRollBot Functions
1090     //
1091 
1092     //Reinvest on all buys and sells
1093     function brbReinvest(address _customerAddress) internal {
1094         if (_customerAddress != owner && bankrollEnabled) {
1095             if (totalDividends(owner, true) > bankrollThreshold) {
1096                 reinvestFor(owner);
1097             }
1098         }
1099 
1100 
1101     }
1102 
1103     /*
1104         Can only be run once per day from the caller avoid bots
1105         Minimum of 100 P6
1106         Minimum of 5 P4RTY + amount minted based on dividends processed in 24 hour period
1107     */
1108     function processRewards() public teamPlayer launched {
1109         require(tokenBalanceLedger_[msg.sender] >= stakingRequirement, "Must meet staking requirement");
1110 
1111 
1112         uint256 count = 0;
1113         address _customer;
1114 
1115         while (available() && count < maxProcessingCap) {
1116 
1117             //If this queue has already been processed in this block exit without altering the queue
1118             _customer = peek();
1119 
1120             if (bot[_customer].lastBlock == block.number){
1121                 break;
1122             }
1123 
1124             //Pop
1125             dequeue();
1126 
1127 
1128             //Update tracking
1129             bot[_customer].lastBlock = block.number;
1130             bot[_customer].queued = false;
1131 
1132             //User could have deactivated while still being queued
1133             if (bot[_customer].active) {
1134 
1135                 //Reinvest divs; be gas efficient
1136                 if (totalDividends(_customer, true) > botThreshold) {
1137 
1138                     //No bankroll reinvest when processing the queue
1139                     bankrollEnabled = false;
1140                     reinvestFor(_customer);
1141                     bankrollEnabled = true;
1142                 }
1143 
1144 
1145                 enqueue(_customer);
1146                 bot[_customer].queued = true;
1147             }
1148 
1149             count++;
1150         }
1151 
1152         lastReward[msg.sender] = now;
1153         reinvestFor(msg.sender);
1154     }
1155 
1156 
1157 
1158 }