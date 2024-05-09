1 pragma solidity ^0.4.23;
2 
3 // File: contracts/ReinvestProxy.sol
4 
5 /*
6  * Visit: https://p4rty.io
7  * Discord: https://discord.gg/7y3DHYF
8  * Copyright Mako Labs LLC 2018 All Rights Reseerved
9 */
10 interface ReinvestProxy {
11 
12     /// @dev Converts all incoming ethereum to tokens for the caller,
13     function reinvestFor(address customer) external payable;
14 
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/Math.sol
18 
19 /**
20  * @title Math
21  * @dev Assorted math operations
22  */
23 library Math {
24   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
25     return a >= b ? a : b;
26   }
27 
28   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
29     return a < b ? a : b;
30   }
31 
32   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
33     return a >= b ? a : b;
34   }
35 
36   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
37     return a < b ? a : b;
38   }
39 }
40 
41 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     if (a == 0) {
54       return 0;
55     }
56     c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     // uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return a / b;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
90 
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97   address public owner;
98 
99 
100   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     owner = msg.sender;
109   }
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) public onlyOwner {
124     require(newOwner != address(0));
125     emit OwnershipTransferred(owner, newOwner);
126     owner = newOwner;
127   }
128 
129 }
130 
131 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
132 
133 /**
134  * @title Whitelist
135  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
136  * @dev This simplifies the implementation of "user permissions".
137  */
138 contract Whitelist is Ownable {
139   mapping(address => bool) public whitelist;
140 
141   event WhitelistedAddressAdded(address addr);
142   event WhitelistedAddressRemoved(address addr);
143 
144   /**
145    * @dev Throws if called by any account that's not whitelisted.
146    */
147   modifier onlyWhitelisted() {
148     require(whitelist[msg.sender]);
149     _;
150   }
151 
152   /**
153    * @dev add an address to the whitelist
154    * @param addr address
155    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
156    */
157   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
158     if (!whitelist[addr]) {
159       whitelist[addr] = true;
160       emit WhitelistedAddressAdded(addr);
161       success = true;
162     }
163   }
164 
165   /**
166    * @dev add addresses to the whitelist
167    * @param addrs addresses
168    * @return true if at least one address was added to the whitelist,
169    * false if all addresses were already in the whitelist
170    */
171   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
172     for (uint256 i = 0; i < addrs.length; i++) {
173       if (addAddressToWhitelist(addrs[i])) {
174         success = true;
175       }
176     }
177   }
178 
179   /**
180    * @dev remove an address from the whitelist
181    * @param addr address
182    * @return true if the address was removed from the whitelist,
183    * false if the address wasn't in the whitelist in the first place
184    */
185   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
186     if (whitelist[addr]) {
187       whitelist[addr] = false;
188       emit WhitelistedAddressRemoved(addr);
189       success = true;
190     }
191   }
192 
193   /**
194    * @dev remove addresses from the whitelist
195    * @param addrs addresses
196    * @return true if at least one address was removed from the whitelist,
197    * false if all addresses weren't in the whitelist in the first place
198    */
199   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
200     for (uint256 i = 0; i < addrs.length; i++) {
201       if (removeAddressFromWhitelist(addrs[i])) {
202         success = true;
203       }
204     }
205   }
206 
207 }
208 
209 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
210 
211 /**
212  * @title ERC20Basic
213  * @dev Simpler version of ERC20 interface
214  * @dev see https://github.com/ethereum/EIPs/issues/179
215  */
216 contract ERC20Basic {
217   function totalSupply() public view returns (uint256);
218   function balanceOf(address who) public view returns (uint256);
219   function transfer(address to, uint256 value) public returns (bool);
220   event Transfer(address indexed from, address indexed to, uint256 value);
221 }
222 
223 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
224 
225 /**
226  * @title ERC20 interface
227  * @dev see https://github.com/ethereum/EIPs/issues/20
228  */
229 contract ERC20 is ERC20Basic {
230   function allowance(address owner, address spender) public view returns (uint256);
231   function transferFrom(address from, address to, uint256 value) public returns (bool);
232   function approve(address spender, uint256 value) public returns (bool);
233   event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 // File: contracts/P4RTYDaoVault.sol
237 
238 /*
239  * Visit: https://p4rty.io
240  * Discord: https://discord.gg/7y3DHYF
241  * Copyright Mako Labs LLC 2018 All Rights Reseerved
242 */
243 
244 contract P4RTYDaoVault is Whitelist {
245 
246 
247     /*=================================
248     =            MODIFIERS            =
249     =================================*/
250 
251     /// @dev Only people with profits
252     modifier onlyDivis {
253         require(myDividends() > 0);
254         _;
255     }
256 
257 
258     /*==============================
259     =            EVENTS            =
260     ==============================*/
261 
262     event onStake(
263         address indexed customerAddress,
264         uint256 stakedTokens,
265         uint256 timestamp
266     );
267 
268     event onDeposit(
269         address indexed fundingSource,
270         uint256 ethDeposited,
271         uint    timestamp
272     );
273 
274     event onWithdraw(
275         address indexed customerAddress,
276         uint256 ethereumWithdrawn,
277         uint timestamp
278     );
279 
280     event onReinvestmentProxy(
281         address indexed customerAddress,
282         address indexed destinationAddress,
283         uint256 ethereumReinvested
284     );
285 
286 
287 
288 
289     /*=====================================
290     =            CONFIGURABLES            =
291     =====================================*/
292 
293 
294     uint256 constant internal magnitude = 2 ** 64;
295 
296 
297     /*=================================
298      =            DATASETS            =
299      ================================*/
300 
301     // amount of shares for each address (scaled number)
302     mapping(address => uint256) internal tokenBalanceLedger_;
303     mapping(address => int256) internal payoutsTo_;
304 
305     //Initial deposits backed by one virtual share that cannot be unstaked
306     uint256 internal tokenSupply_ = 1;
307     uint256 internal profitPerShare_;
308 
309     ERC20 public p4rty;
310 
311 
312     /*=======================================
313     =            PUBLIC FUNCTIONS           =
314     =======================================*/
315 
316     constructor(address _p4rtyAddress) Ownable() public {
317 
318         p4rty = ERC20(_p4rtyAddress);
319 
320     }
321 
322     /**
323      * @dev Fallback function to handle ethereum that was send straight to the contract
324      */
325     function() payable public {
326         deposit();
327     }
328 
329     /// @dev Internal function to actually purchase the tokens.
330     function deposit() payable public  {
331 
332         uint256 _incomingEthereum = msg.value;
333         address _fundingSource = msg.sender;
334 
335         // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
336         profitPerShare_ += (_incomingEthereum * magnitude / tokenSupply_);
337 
338 
339         // fire event
340         emit onDeposit(_fundingSource, _incomingEthereum, now);
341 
342     }
343 
344     function stake(uint _amountOfTokens) public {
345 
346 
347         //Approval has to happen separately directly with p4rty
348         //p4rty.approve(<DAO>, _amountOfTokens);
349 
350         address _customerAddress = msg.sender;
351 
352         //Customer needs to have P4RTY
353         require(p4rty.balanceOf(_customerAddress) > 0);
354 
355 
356 
357         uint256 _balance = p4rty.balanceOf(_customerAddress);
358         uint256 _stakeAmount = Math.min256(_balance,_amountOfTokens);
359 
360         require(_stakeAmount > 0);
361         p4rty.transferFrom(_customerAddress, address(this), _stakeAmount);
362 
363         //Add to the tokenSupply_
364         tokenSupply_ = SafeMath.add(tokenSupply_, _stakeAmount);
365 
366         // update circulating supply & the ledger address for the customer
367         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _stakeAmount);
368 
369         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
370         // really i know you think you do but you don't
371         int256 _updatedPayouts = (int256) (profitPerShare_ * _stakeAmount);
372         payoutsTo_[_customerAddress] += _updatedPayouts;
373 
374         emit onStake(_customerAddress, _amountOfTokens, now);
375     }
376 
377     /// @dev Withdraws all of the callers earnings.
378     function withdraw() onlyDivis public {
379 
380         address _customerAddress = msg.sender;
381         // setup data
382         uint256 _dividends = dividendsOf(_customerAddress);
383 
384         // update dividend tracker
385         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
386 
387 
388         // lambo delivery service
389         _customerAddress.transfer(_dividends);
390 
391         // fire event
392         emit onWithdraw(_customerAddress, _dividends, now);
393     }
394 
395     function reinvestByProxy(address _customerAddress) onlyWhitelisted public {
396         // setup data
397         uint256 _dividends = dividendsOf(_customerAddress);
398 
399         // update dividend tracker
400         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
401 
402 
403         // dispatch a buy order with the virtualized "withdrawn dividends"
404         ReinvestProxy reinvestProxy =  ReinvestProxy(msg.sender);
405         reinvestProxy.reinvestFor.value(_dividends)(_customerAddress);
406 
407         emit onReinvestmentProxy(_customerAddress,msg.sender,_dividends);
408 
409     }
410 
411 
412     /*=====================================
413     =      HELPERS AND CALCULATORS        =
414     =====================================*/
415 
416     /**
417      * @dev Method to view the current Ethereum stored in the contract
418      *  Example: totalEthereumBalance()
419      */
420     function totalEthereumBalance() public view returns (uint256) {
421         return address(this).balance;
422     }
423 
424     /// @dev Retrieve the total token supply.
425     function totalSupply() public view returns (uint256) {
426         return tokenSupply_;
427     }
428 
429     /// @dev Retrieve the tokens owned by the caller.
430     function myTokens() public view returns (uint256) {
431         address _customerAddress = msg.sender;
432         return balanceOf(_customerAddress);
433     }
434 
435     /// @dev The percentage of the
436     function votingPower(address _customerAddress) public view returns (uint256) {
437         return SafeMath.div(balanceOf(_customerAddress), totalSupply());
438     }
439 
440     /**
441      * @dev Retrieve the dividends owned by the caller.
442      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
443      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
444      *  But in the internal calculations, we want them separate.
445      */
446     function myDividends() public view returns (uint256) {
447         return dividendsOf(msg.sender);
448 
449     }
450 
451     /// @dev Retrieve the token balance of any single address.
452     function balanceOf(address _customerAddress) public view returns (uint256) {
453         return tokenBalanceLedger_[_customerAddress];
454     }
455 
456     /// @dev Retrieve the dividend balance of any single address.
457     function dividendsOf(address _customerAddress) public view returns (uint256) {
458         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
459     }
460 
461 }
462 
463 // File: contracts/Bankroll.sol
464 
465 interface Bankroll {
466 
467     //Customer functions
468 
469     /// @dev Stores ETH funds for customer
470     function credit(address _customerAddress, uint256 amount) external returns (uint256);
471 
472     /// @dev Debits address by an amount
473     function debit(address _customerAddress, uint256 amount) external returns (uint256);
474 
475     /// @dev Withraws balance for address; returns amount sent
476     function withdraw(address _customerAddress) external returns (uint256);
477 
478     /// @dev Retrieve the token balance of any single address.
479     function balanceOf(address _customerAddress) external view returns (uint256);
480 
481     /// @dev Stats of any single address
482     function statsOf(address _customerAddress) external view returns (uint256[8]);
483 
484 
485     // System functions
486 
487     // @dev Deposit funds
488     function deposit() external payable;
489 
490     // @dev Deposit on behalf of an address; it is not a credit
491     function depositBy(address _customerAddress) external payable;
492 
493     // @dev Distribute house profit
494     function houseProfit(uint256 amount)  external;
495 
496 
497     /// @dev Get all the ETH stored in contract minus credits to customers
498     function netEthereumBalance() external view returns (uint256);
499 
500 
501     /// @dev Get all the ETH stored in contract
502     function totalEthereumBalance() external view returns (uint256);
503 
504 }
505 
506 // File: contracts/P4RTYRelay.sol
507 
508 /*
509  * Visit: https://p4rty.io
510  * Discord: https://discord.gg/7y3DHYF
511 */
512 
513 interface P4RTYRelay {
514     /**
515     * @dev Will relay to internal implementation
516     * @param beneficiary Token purchaser
517     * @param tokenAmount Number of tokens to be minted
518     */
519     function relay(address beneficiary, uint256 tokenAmount) external;
520 }
521 
522 // File: contracts/SessionQueue.sol
523 
524 /// A FIFO queue for storing addresses
525 contract SessionQueue {
526 
527     mapping(uint256 => address) private queue;
528     uint256 private first = 1;
529     uint256 private last = 0;
530 
531     /// @dev Push into queue
532     function enqueue(address data) internal {
533         last += 1;
534         queue[last] = data;
535     }
536 
537     /// @dev Returns true if the queue has elements in it
538     function available() internal view returns (bool) {
539         return last >= first;
540     }
541 
542     /// @dev Returns the size of the queue
543     function depth() internal view returns (uint256) {
544         return last - first + 1;
545     }
546 
547     /// @dev Pops from the head of the queue
548     function dequeue() internal returns (address data) {
549         require(last >= first);
550         // non-empty queue
551 
552         data = queue[first];
553 
554         delete queue[first];
555         first += 1;
556     }
557 
558     /// @dev Returns the head of the queue without a pop
559     function peek() internal view returns (address data) {
560         require(last >= first);
561         // non-empty queue
562 
563         data = queue[first];
564     }
565 }
566 
567 // File: contracts/P6.sol
568 
569 // solhint-disable-line
570 
571 
572 
573 
574 
575 
576 /*
577  * Visit: https://p4rty.io
578  * Discord: https://discord.gg/7y3DHYF
579  * Stable + DIVIS: Whale and Minow Friendly
580  * Fees balanced for maximum dividends for ALL
581  * Active depositors rewarded with P4RTY tokens
582  * 50% of ETH value in earned P4RTY token rewards
583  * 2% of dividends fund a gaming bankroll; gaming profits are paid back into P6
584  * P4RTYRelay is notified on all dividend producing transactions
585  * Smart Launch phase which is anti-whale & anti-snipe
586  *
587  * P6
588  * The worry free way to earn A TON OF ETH & P4RTY reward tokens
589  *
590  * -> What?
591  * The first Ethereum Bonded Pure Dividend Token:
592  * [✓] The only dividend printing press that is part of the P4RTY Entertainment Network
593  * [✓] Earn ERC20 P4RTY tokens on all ETH deposit activities
594  * [✓] 3% P6 Faucet for free P6 / P4RTY
595  * [✓] Auto-Reinvests
596  * [✓] 10% exchange fees on buys and sells
597  * [✓] 100 tokens to activate faucet
598  *
599  * -> How?
600  * To replay or use the faucet the contract must be fully launched
601  * To sell or transfer you need to be vested (maximum of 3 days) after a reinvest
602 */
603 
604 contract P6 is Whitelist, SessionQueue {
605 
606 
607     /*=================================
608     =            MODIFIERS            =
609     =================================*/
610 
611     /// @dev Only people with tokens
612     modifier onlyTokenHolders {
613         require(myTokens() > 0);
614         _;
615     }
616 
617     /// @dev Only people with profits
618     modifier onlyDivis {
619         require(myDividends(true) > 0);
620         _;
621     }
622 
623     /// @dev Only invested; If participating in prelaunch have to buy tokens
624     modifier invested {
625         require(stats[msg.sender].invested > 0, "Must buy tokens once to withdraw");
626 
627         _;
628 
629     }
630 
631     /// @dev After every reinvest features are protected by a cooloff to vest funds
632     modifier cooledOff {
633         require(msg.sender == owner && !contractIsLaunched || now - bot[msg.sender].coolOff > coolOffPeriod);
634         _;
635     }
636 
637     /// @dev The faucet has a rewardPeriod
638     modifier teamPlayer {
639         require(msg.sender == owner || now - lastReward[msg.sender] > rewardProcessingPeriod, "No spamming");
640         _;
641     }
642 
643     /// @dev Functions only available after launch
644     modifier launched {
645         require(contractIsLaunched || msg.sender == owner, "Contract not lauched");
646         _;
647     }
648 
649 
650     /*==============================
651     =            EVENTS            =
652     ==============================*/
653 
654     event onLog(
655         string heading,
656         address caller,
657         address subj,
658         uint val
659     );
660 
661     event onTokenPurchase(
662         address indexed customerAddress,
663         uint256 incomingEthereum,
664         uint256 tokensMinted,
665         address indexed referredBy,
666         uint timestamp,
667         uint256 price
668     );
669 
670     event onTokenSell(
671         address indexed customerAddress,
672         uint256 tokensBurned,
673         uint256 ethereumEarned,
674         uint timestamp,
675         uint256 price
676     );
677 
678     event onReinvestment(
679         address indexed customerAddress,
680         uint256 ethereumReinvested,
681         uint256 tokensMinted
682     );
683 
684     event onCommunityReward(
685         address indexed sourceAddress,
686         address indexed destinationAddress,
687         uint256 ethereumEarned
688     );
689 
690     event onReinvestmentProxy(
691         address indexed customerAddress,
692         address indexed destinationAddress,
693         uint256 ethereumReinvested
694     );
695 
696     event onWithdraw(
697         address indexed customerAddress,
698         uint256 ethereumWithdrawn
699     );
700 
701     event onDeposit(
702         address indexed customerAddress,
703         uint256 ethereumDeposited
704     );
705 
706     // ERC20
707     event Transfer(
708         address indexed from,
709         address indexed to,
710         uint256 tokens
711     );
712 
713 
714     /*=====================================
715     =            CONFIGURABLES            =
716     =====================================*/
717 
718     /// @dev 10% dividends for token purchase
719     uint256  internal entryFee_ = 10;
720 
721     /// @dev 1% dividends for token transfer
722     uint256  internal transferFee_ = 1;
723 
724     /// @dev 10% dividends for token selling
725     uint256  internal exitFee_ = 10;
726 
727     /// @dev 3% of entryFee_  is given to faucet
728     /// traditional referral mechanism repurposed as a many to many faucet
729     /// powers auto reinvest
730     uint256  internal referralFee_ = 30;
731 
732     /// @dev 20% of entryFee/exit fee is given to Bankroll
733     uint256  internal maintenanceFee_ = 20;
734     address  internal maintenanceAddress;
735 
736     //Advanced Config
737     uint256 constant internal bankrollThreshold = 0.5 ether;
738     uint256 constant internal botThreshold = 0.01 ether;
739     uint256 constant rewardProcessingPeriod = 6 hours;
740     uint256 constant reapPeriod = 7 days;
741     uint256 public  maxProcessingCap = 10;
742 
743     uint256 public coolOffPeriod = 3 days;
744     uint256 public launchETHMaximum = 20 ether;
745     bool public contractIsLaunched = false;
746     uint public lastReaped;
747 
748 
749     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
750     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
751 
752     uint256 constant internal magnitude = 2 ** 64;
753 
754     /// @dev proof of stake (defaults at 100 tokens)
755     uint256 public stakingRequirement = 100e18;
756 
757 
758     /*=================================
759      =            DATASETS            =
760      ================================*/
761 
762     // bookkeeping for autoreinvest
763     struct Bot {
764         bool active;
765         bool queued;
766         uint256 lastBlock;
767         uint256 coolOff;
768     }
769 
770     // Onchain Stats!!!
771     struct Stats {
772         uint invested;
773         uint reinvested;
774         uint withdrawn;
775         uint rewarded;
776         uint contributed;
777         uint transferredTokens;
778         uint receivedTokens;
779         uint xInvested;
780         uint xReinvested;
781         uint xRewarded;
782         uint xContributed;
783         uint xWithdrawn;
784         uint xTransferredTokens;
785         uint xReceivedTokens;
786     }
787 
788 
789     // amount of shares for each address (scaled number)
790     mapping(address => uint256) internal lastReward;
791     mapping(address => uint256) internal tokenBalanceLedger_;
792     mapping(address => uint256) internal referralBalance_;
793     mapping(address => int256) internal payoutsTo_;
794     mapping(address => Bot) internal bot;
795     mapping(address => Stats) internal stats;
796     //on chain referral tracking
797     mapping(address => address) public referrals;
798     uint256 internal tokenSupply_;
799     uint256 internal profitPerShare_;
800 
801     P4RTYRelay public relay;
802     Bankroll public bankroll;
803     bool internal bankrollEnabled = true;
804 
805     /*=======================================
806     =            PUBLIC FUNCTIONS           =
807     =======================================*/
808 
809     constructor(address relayAddress)  public {
810 
811         relay = P4RTYRelay(relayAddress);
812         updateMaintenanceAddress(msg.sender);
813     }
814 
815     //Maintenance Functions
816 
817     /// @dev Minted P4RTY tokens are sent to the maintenance address
818     function updateMaintenanceAddress(address maintenance) onlyOwner public {
819         maintenanceAddress = maintenance;
820     }
821 
822     /// @dev Update the bankroll; 2% of dividends go to the bankroll
823     function updateBankrollAddress(address bankrollAddress) onlyOwner public {
824         bankroll = Bankroll(bankrollAddress);
825     }
826 
827     /// @dev The cap determines the amount of addresses processed when a user runs the faucet
828     function updateProcessingCap(uint cap) onlyOwner public {
829         require(cap >= 5 && cap <= 15, "Capacity set outside of policy range");
830         maxProcessingCap = cap;
831     }
832 
833     /// @dev Updates the coolOff period where reinvest must vest
834     function updateCoolOffPeriod(uint coolOff) onlyOwner public {
835         require(coolOff >= 5 minutes && coolOff <= 3 days);
836         coolOffPeriod = coolOff;
837     }
838 
839     /// @dev Opens the contract for public use outside of the launch phase
840     function launchContract() onlyOwner public {
841         contractIsLaunched = true;
842     }
843 
844 
845     //Bot Functions
846 
847     /* Activates the bot and queues if necessary; else removes */
848     function activateBot(bool auto) public {
849         bot[msg.sender].active = auto;
850 
851         //Spam protection for customerAddress
852         if (bot[msg.sender].active) {
853             if (!bot[msg.sender].queued) {
854                 bot[msg.sender].queued = true;
855                 enqueue(msg.sender);
856             }
857         }
858     }
859 
860     /* Returns if the sender has the reinvestment not enabled */
861     function botEnabled() public view returns (bool){
862         return bot[msg.sender].active;
863     }
864 
865 
866     function fundBankRoll(uint256 amount) internal {
867         bankroll.deposit.value(amount)();
868     }
869 
870     /// @dev Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
871     function buyFor(address _customerAddress) onlyWhitelisted public payable returns (uint256) {
872         return purchaseTokens(_customerAddress, msg.value);
873     }
874 
875     /// @dev Converts all incoming ethereum to tokens for the caller
876     function buy() public payable returns (uint256) {
877         if (contractIsLaunched){
878             //ETH sent during prelaunch needs to be processed
879             if(stats[msg.sender].invested == 0 && referralBalance_[msg.sender] > 0){
880                 reinvestFor(msg.sender);
881             }
882             return purchaseTokens(msg.sender, msg.value);
883         }  else {
884             //Just deposit funds
885             return deposit();
886         }
887     }
888 
889     function deposit() internal returns (uint256) {
890         require(msg.value > 0);
891 
892         //Just add to the referrals for sidelined ETH
893         referralBalance_[msg.sender] = SafeMath.add(referralBalance_[msg.sender], msg.value);
894 
895         require(referralBalance_[msg.sender] <= launchETHMaximum, "Exceeded investment cap");
896 
897         emit onDeposit(msg.sender, msg.value);
898 
899         return 0;
900 
901     }
902 
903     /**
904      * @dev Fallback function to handle ethereum that was send straight to the contract
905      *  Unfortunately we cannot use a referral address this way.
906      */
907     function() payable public {
908         purchaseTokens(msg.sender, msg.value);
909     }
910 
911     /// @dev Converts all of caller's dividends to tokens.
912     function reinvest() onlyDivis launched public {
913         reinvestFor(msg.sender);
914     }
915 
916     /// @dev Allows owner to reinvest on behalf of a supporter
917     function investSupporter(address _customerAddress) public onlyOwner {
918         require(!contractIsLaunched, "Contract already opened");
919         reinvestFor(_customerAddress);
920     }
921 
922     /// @dev Internal utility method for reinvesting
923     function reinvestFor(address _customerAddress) internal {
924 
925         // fetch dividends
926         uint256 _dividends = totalDividends(_customerAddress, false);
927         // retrieve ref. bonus later in the code
928 
929         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
930 
931         // retrieve ref. bonus
932         _dividends += referralBalance_[_customerAddress];
933         referralBalance_[_customerAddress] = 0;
934 
935         // dispatch a buy order with the virtualized "withdrawn dividends"
936         uint256 _tokens = purchaseTokens(_customerAddress, _dividends);
937 
938         // fire event
939         emit onReinvestment(_customerAddress, _dividends, _tokens);
940 
941         //Stats
942         stats[_customerAddress].reinvested = SafeMath.add(stats[_customerAddress].reinvested, _dividends);
943         stats[_customerAddress].xReinvested += 1;
944 
945         //Refresh the coolOff
946         bot[_customerAddress].coolOff = now;
947 
948     }
949 
950     /// @dev Withdraws all of the callers earnings.
951     function withdraw() onlyDivis  invested public {
952         withdrawFor(msg.sender);
953     }
954 
955     /// @dev Utility function for withdrawing earnings
956     function withdrawFor(address _customerAddress) internal {
957 
958         // setup data
959         uint256 _dividends = totalDividends(_customerAddress, false);
960         // get ref. bonus later in the code
961 
962         // update dividend tracker
963         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
964 
965         // add ref. bonus
966         _dividends += referralBalance_[_customerAddress];
967         referralBalance_[_customerAddress] = 0;
968 
969         // lambo delivery service
970         _customerAddress.transfer(_dividends);
971 
972         //stats
973         stats[_customerAddress].withdrawn = SafeMath.add(stats[_customerAddress].withdrawn, _dividends);
974         stats[_customerAddress].xWithdrawn += 1;
975 
976         // fire event
977         emit onWithdraw(_customerAddress, _dividends);
978     }
979 
980 
981     /// @dev Liquifies tokens to ethereum.
982     function sell(uint256 _amountOfTokens) onlyTokenHolders cooledOff public {
983         address _customerAddress = msg.sender;
984 
985         //Selling deactivates auto reinvest
986         bot[_customerAddress].active = false;
987 
988 
989         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
990         uint256 _tokens = _amountOfTokens;
991         uint256 _ethereum = tokensToEthereum_(_tokens);
992 
993 
994         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
995         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
996         //maintenance and referral come out of the exitfee
997         uint256 _dividends = SafeMath.sub(_undividedDividends, _maintenance);
998         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _undividedDividends);
999 
1000         // burn the sold tokens
1001         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
1002         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
1003 
1004         // update dividends tracker
1005         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
1006         payoutsTo_[_customerAddress] -= _updatedPayouts;
1007 
1008 
1009         //Apply maintenance fee to the bankroll
1010         fundBankRoll(_maintenance);
1011 
1012         // dividing by zero is a bad idea
1013         if (tokenSupply_ > 0) {
1014             // update the amount of dividends per token
1015             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
1016         }
1017 
1018         // fire event
1019         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
1020 
1021         //GO!!! Bankroll Bot GO!!!
1022         brbReinvest(_customerAddress);
1023     }
1024 
1025     //@dev Bankroll Bot can only transfer 10% of funds during a reapPeriod
1026     //Its funds will always be locked because it always reinvests
1027     function reap(address _toAddress) public onlyOwner {
1028         require(now - lastReaped > reapPeriod, "Reap not available, too soon");
1029         lastReaped = now;
1030         transferTokens(owner, _toAddress, SafeMath.div(balanceOf(owner), 10));
1031 
1032     }
1033 
1034     /**
1035      * @dev Transfer tokens from the caller to a new holder.
1036      *  Remember, there's a 1% fee here as well.
1037      */
1038     function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders cooledOff external returns (bool){
1039         address _customerAddress = msg.sender;
1040         return transferTokens(_customerAddress, _toAddress, _amountOfTokens);
1041     }
1042 
1043     /// @dev Utility function for transfering tokens
1044     function transferTokens(address _customerAddress, address _toAddress, uint256 _amountOfTokens)  internal returns (bool){
1045 
1046         // make sure we have the requested tokens
1047         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
1048 
1049         // withdraw all outstanding dividends first
1050         if (totalDividends(_customerAddress,true) > 0) {
1051             withdrawFor(_customerAddress);
1052         }
1053 
1054         // liquify a percentage of the tokens that are transfered
1055         // these are dispersed to shareholders
1056         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
1057         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
1058         uint256 _dividends = tokensToEthereum_(_tokenFee);
1059 
1060         // burn the fee tokens
1061         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
1062 
1063         // exchange tokens
1064         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
1065         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
1066 
1067         // update dividend trackers
1068         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
1069         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
1070 
1071         // disperse dividends among holders
1072         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
1073 
1074         // fire event
1075         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
1076 
1077         //Stats
1078         stats[_customerAddress].xTransferredTokens += 1;
1079         stats[_customerAddress].transferredTokens += _amountOfTokens;
1080         stats[_toAddress].receivedTokens += _taxedTokens;
1081         stats[_toAddress].xReceivedTokens += 1;
1082 
1083         // ERC20
1084         return true;
1085     }
1086 
1087 
1088     /*=====================================
1089     =      HELPERS AND CALCULATORS        =
1090     =====================================*/
1091 
1092     /**
1093      * @dev Method to view the current Ethereum stored in the contract
1094      *  Example: totalEthereumBalance()
1095      */
1096     function totalEthereumBalance() public view returns (uint256) {
1097         return address(this).balance;
1098     }
1099 
1100     /// @dev Retrieve the total token supply.
1101     function totalSupply() public view returns (uint256) {
1102         return tokenSupply_;
1103     }
1104 
1105     /// @dev Retrieve the tokens owned by the caller.
1106     function myTokens() public view returns (uint256) {
1107         address _customerAddress = msg.sender;
1108         return balanceOf(_customerAddress);
1109     }
1110 
1111     /**
1112      * @dev Retrieve the dividends owned by the caller.
1113      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
1114      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
1115      *  But in the internal calculations, we want them separate.
1116      */
1117     /**
1118      * @dev Retrieve the dividends owned by the caller.
1119      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
1120      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
1121      *  But in the internal calculations, we want them separate.
1122      */
1123     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
1124         return totalDividends(msg.sender, _includeReferralBonus);
1125     }
1126 
1127     function totalDividends(address _customerAddress, bool _includeReferralBonus) internal view returns (uint256) {
1128         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
1129     }
1130 
1131     /// @dev Retrieve the token balance of any single address.
1132     function balanceOf(address _customerAddress) public view returns (uint256) {
1133         return tokenBalanceLedger_[_customerAddress];
1134     }
1135 
1136     /// @dev Stats of any single address
1137     function statsOf(address _customerAddress) public view returns (uint256[14]){
1138         Stats memory s = stats[_customerAddress];
1139         uint256[14] memory statArray = [s.invested, s.withdrawn, s.rewarded, s.contributed, s.transferredTokens, s.receivedTokens, s.xInvested, s.xRewarded, s.xContributed, s.xWithdrawn, s.xTransferredTokens, s.xReceivedTokens, s.reinvested, s.xReinvested];
1140         return statArray;
1141     }
1142 
1143     /// @dev Retrieve the dividend balance of any single address.
1144     function dividendsOf(address _customerAddress) public view returns (uint256) {
1145         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
1146     }
1147 
1148     /// @dev Return the sell price of 1 individual token.
1149     function sellPrice() public view returns (uint256) {
1150         // our calculation relies on the token supply, so we need supply. Doh.
1151         if (tokenSupply_ == 0) {
1152             return tokenPriceInitial_ - tokenPriceIncremental_;
1153         } else {
1154             uint256 _ethereum = tokensToEthereum_(1e18);
1155             uint256 _dividends = SafeMath.div(_ethereum, exitFee_);
1156             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
1157             return _taxedEthereum;
1158         }
1159 
1160     }
1161 
1162     /// @dev Return the buy price of 1 individual token.
1163     function buyPrice() public view returns (uint256) {
1164         // our calculation relies on the token supply, so we need supply. Doh.
1165         if (tokenSupply_ == 0) {
1166             return tokenPriceInitial_ + tokenPriceIncremental_;
1167         } else {
1168             uint256 _ethereum = tokensToEthereum_(1e18);
1169             uint256 _dividends = SafeMath.div(_ethereum, entryFee_);
1170             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
1171             return _taxedEthereum;
1172         }
1173 
1174     }
1175 
1176     /// @dev Function for the frontend to dynamically retrieve the price scaling of buy orders.
1177     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
1178         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
1179         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
1180         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1181 
1182         return _amountOfTokens;
1183     }
1184 
1185     /// @dev Function for the frontend to dynamically retrieve the price scaling of sell orders.
1186     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
1187         require(_tokensToSell <= tokenSupply_);
1188         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
1189         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
1190         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
1191         return _taxedEthereum;
1192     }
1193 
1194 
1195     /*==========================================
1196     =            INTERNAL FUNCTIONS            =
1197     ==========================================*/
1198 
1199     /// @dev Internal function to actually purchase the tokens.
1200     function purchaseTokens(address _customerAddress, uint256 _incomingEthereum) internal returns (uint256) {
1201         // data setup
1202         address _referredBy = msg.sender;
1203         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
1204         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_), 100);
1205         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
1206         //maintenance and referral come out of the buyin
1207         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus, _maintenance));
1208         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
1209         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1210         uint256 _fee = _dividends * magnitude;
1211         uint256 _tokenAllocation = SafeMath.div(_incomingEthereum, 2);
1212 
1213 
1214         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
1215         // (or hackers)
1216         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
1217         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
1218 
1219         //Apply maintenance fee to bankroll
1220         fundBankRoll(_maintenance);
1221 
1222         // is the user referred by a masternode?
1223         if (
1224 
1225         // no cheating!
1226             _referredBy != _customerAddress &&
1227 
1228             // does the referrer have at least X whole tokens?
1229             // i.e is the referrer a godly chad masternode
1230             tokenBalanceLedger_[_referredBy] >= stakingRequirement
1231         ) {
1232             // wealth redistribution
1233             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
1234 
1235             //Stats
1236             stats[_referredBy].rewarded = SafeMath.add(stats[_referredBy].rewarded, _referralBonus);
1237             stats[_referredBy].xRewarded += 1;
1238             stats[_customerAddress].contributed = SafeMath.add(stats[_customerAddress].contributed, _referralBonus);
1239             stats[_customerAddress].xContributed += 1;
1240 
1241             //It pays to play
1242             emit onCommunityReward(_customerAddress, _referredBy, _referralBonus);
1243         } else {
1244             // no ref purchase
1245             // add the referral bonus back to the global dividends cake
1246             _dividends = SafeMath.add(_dividends, _referralBonus);
1247             _fee = _dividends * magnitude;
1248         }
1249 
1250         // we can't give people infinite ethereum
1251         if (tokenSupply_ > 0) {
1252             // add tokens to the pool
1253             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
1254 
1255             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
1256             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
1257 
1258             // calculate the amount of tokens the customer receives over his purchase
1259             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
1260         } else {
1261             // add tokens to the pool
1262             tokenSupply_ = _amountOfTokens;
1263         }
1264 
1265         // update circulating supply & the ledger address for the customer
1266         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
1267 
1268         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
1269         // really i know you think you do but you don't
1270         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
1271         payoutsTo_[_customerAddress] += _updatedPayouts;
1272 
1273         //Notifying the relay is simple and should represent the total economic activity which is the _incomingEthereum
1274         //Every player is a customer and mints their own tokens when the buy or reinvest, relay P4RTY 50/50
1275         relay.relay(maintenanceAddress, _tokenAllocation);
1276         relay.relay(_customerAddress, _tokenAllocation);
1277 
1278         // fire event
1279         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
1280 
1281         //Stats
1282         stats[_customerAddress].invested = SafeMath.add(stats[_customerAddress].invested, _incomingEthereum);
1283         stats[_customerAddress].xInvested += 1;
1284 
1285         //GO!!! Bankroll Bot GO!!!
1286         brbReinvest(_customerAddress);
1287 
1288         return _amountOfTokens;
1289     }
1290 
1291     /**
1292      * Calculate Token price based on an amount of incoming ethereum
1293      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1294      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1295      */
1296     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256)
1297     {
1298         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1299         uint256 _tokensReceived =
1300         (
1301         (
1302         // underflow attempts BTFO
1303         SafeMath.sub(
1304             (sqrt
1305         (
1306             (_tokenPriceInitial ** 2)
1307             +
1308             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
1309             +
1310             (((tokenPriceIncremental_) ** 2) * (tokenSupply_ ** 2))
1311             +
1312             (2 * (tokenPriceIncremental_) * _tokenPriceInitial * tokenSupply_)
1313         )
1314             ), _tokenPriceInitial
1315         )
1316         ) / (tokenPriceIncremental_)
1317         ) - (tokenSupply_)
1318         ;
1319 
1320         return _tokensReceived;
1321     }
1322 
1323     /**
1324      * Calculate token sell value.
1325      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1326      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1327      */
1328     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256)
1329     {
1330 
1331         uint256 tokens_ = (_tokens + 1e18);
1332         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1333         uint256 _etherReceived =
1334         (
1335         // underflow attempts BTFO
1336         SafeMath.sub(
1337             (
1338             (
1339             (
1340             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
1341             ) - tokenPriceIncremental_
1342             ) * (tokens_ - 1e18)
1343             ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
1344         )
1345         / 1e18);
1346         return _etherReceived;
1347     }
1348 
1349 
1350     /// @dev Returns true if the tokens are fully vested after a reinvest
1351     function isVested() public view returns (bool) {
1352         return now - bot[msg.sender].coolOff > coolOffPeriod;
1353     }
1354 
1355     /*
1356         Is end user eligible to process rewards?
1357     */
1358     function rewardAvailable() public view returns (bool){
1359         return available() && now - lastReward[msg.sender] > rewardProcessingPeriod &&
1360         tokenBalanceLedger_[msg.sender] >= stakingRequirement;
1361     }
1362 
1363     /// @dev Returns timer info used for the vesting and the faucet
1364     function timerInfo() public view returns (uint, uint[2], uint[2]){
1365         return (now, [bot[msg.sender].coolOff, coolOffPeriod], [lastReward[msg.sender], rewardProcessingPeriod]);
1366     }
1367 
1368 
1369     //This is where all your gas goes, sorry
1370     //Not sorry, you probably only paid 1 gwei
1371     function sqrt(uint x) internal pure returns (uint y) {
1372         uint z = (x + 1) / 2;
1373         y = x;
1374         while (z < y) {
1375             y = z;
1376             z = (x / z + z) / 2;
1377         }
1378     }
1379 
1380     //
1381     // BankRollBot Functions
1382     //
1383 
1384     //Reinvest on all buys and sells
1385     function brbReinvest(address _customerAddress) internal {
1386         if (_customerAddress != owner && bankrollEnabled) {
1387             if (totalDividends(owner, true) > bankrollThreshold) {
1388                 reinvestFor(owner);
1389             }
1390         }
1391 
1392 
1393     }
1394 
1395     /*
1396         Can only be run once per day from the caller avoid bots
1397         Minimum of 100 P6
1398         Minimum of 5 P4RTY + amount minted based on dividends processed in 24 hour period
1399     */
1400     function processRewards() public teamPlayer launched {
1401         require(tokenBalanceLedger_[msg.sender] >= stakingRequirement, "Must meet staking requirement");
1402 
1403 
1404         uint256 count = 0;
1405         address _customer;
1406 
1407         while (available() && count < maxProcessingCap) {
1408 
1409             //If this queue has already been processed in this block exit without altering the queue
1410             _customer = peek();
1411 
1412             if (bot[_customer].lastBlock == block.number){
1413                 break;
1414             }
1415 
1416             //Pop
1417             dequeue();
1418 
1419 
1420             //Update tracking
1421             bot[_customer].lastBlock = block.number;
1422             bot[_customer].queued = false;
1423 
1424             //User could have deactivated while still being queued
1425             if (bot[_customer].active) {
1426 
1427                 //Reinvest divs; be gas efficient
1428                 if (totalDividends(_customer, true) > botThreshold) {
1429 
1430                     //No bankroll reinvest when processing the queue
1431                     bankrollEnabled = false;
1432                     reinvestFor(_customer);
1433                     bankrollEnabled = true;
1434                 }
1435 
1436 
1437                 enqueue(_customer);
1438                 bot[_customer].queued = true;
1439             }
1440 
1441             count++;
1442         }
1443 
1444         lastReward[msg.sender] = now;
1445         reinvestFor(msg.sender);
1446     }
1447 
1448 
1449 
1450 }
1451 
1452 // File: contracts/P4RTYBankrollVault.sol
1453 
1454 /*
1455  * Visit: https://p4rty.io
1456  * Discord: https://discord.gg/7y3DHYF
1457 */
1458 
1459 contract P4RTYBankrollVault is Whitelist {
1460 
1461     using SafeMath for uint;
1462 
1463     /*==============================
1464     =            EVENTS            =
1465     ==============================*/
1466 
1467     event onDeposit(
1468         address indexed fundingSource,
1469         uint256 ethDeposited,
1470         uint    timestamp
1471     );
1472 
1473     event onCredit(
1474         address indexed customerAddress,
1475         uint256 ethCredited,
1476         uint    timestamp
1477     );
1478 
1479     event onDebit(
1480         address indexed customerAddress,
1481         uint256 ethDedited,
1482         uint    timestamp
1483     );
1484 
1485 
1486 
1487     event onWithdraw(
1488         address indexed customerAddress,
1489         uint256 ethereumWithdrawn,
1490         uint timestamp
1491     );
1492 
1493     event onAirdrop(
1494         address contractAddress,
1495         uint256 ethereumSent,
1496         uint timestamp
1497     );
1498 
1499 
1500 
1501     /*=====================================
1502     =            CONFIGURABLES            =
1503     =====================================*/
1504 
1505     uint256 public daoFee = 10;
1506     uint256 public p6Fee = 15;
1507     uint256 constant public outboundThreshold = 0.5 ether;
1508     uint256 internal p6Outbound = 0;
1509     uint256 internal daoOutbound =0;
1510 
1511 
1512     /*=================================
1513      =            DATASETS            =
1514      ================================*/
1515 
1516     struct Stats {
1517         uint deposit;
1518         uint credit;
1519         uint debit;
1520         uint withdrawn;
1521         uint xDeposit;
1522         uint xCredit;
1523         uint xDebit;
1524         uint xWithdrawn;
1525     }
1526 
1527     // amount of shares for each address (scaled number)
1528     mapping(address => uint256) internal vault;
1529     mapping(address => Stats) internal stats;
1530     uint256 internal totalCustomerCredit;
1531     P6 public p6;
1532     P4RTYDaoVault public dao;
1533 
1534 
1535     /*=======================================
1536     =            PUBLIC FUNCTIONS           =
1537     =======================================*/
1538 
1539     constructor(address daoAddress) public {
1540         dao = P4RTYDaoVault(daoAddress);
1541     }
1542 
1543     function updateP6Fee(uint256 fee) public onlyOwner {
1544         require ( fee >= 1 && fee <= 25);
1545         p6Fee = fee;
1546     }
1547 
1548     function updateDaoFee(uint256 fee) public onlyOwner {
1549         require ( fee >= 1 && fee <= 25);
1550         daoFee = fee;
1551     }
1552 
1553     function updateP6Address(address p6Address) public onlyOwner {
1554         p6 = P6(p6Address);
1555     }
1556 
1557     //Customer functions
1558 
1559 
1560     /// @dev Stores ETH funds for customer
1561     function credit(address _customerAddress, uint256 amount) onlyWhitelisted external returns (uint256){
1562         vault[_customerAddress] = vault[_customerAddress].add(amount);
1563 
1564         totalCustomerCredit = totalCustomerCredit.add(amount);
1565 
1566         //Stats
1567         stats[_customerAddress].credit = stats[_customerAddress].credit.add(amount);
1568         stats[_customerAddress].xCredit += 1;
1569 
1570         emit onCredit(_customerAddress, amount, now);
1571 
1572         return vault[_customerAddress];
1573 
1574     }
1575 
1576     /// @dev Debits address by an amount or sets to zero
1577     function debit(address _customerAddress, uint256 amount) onlyWhitelisted external returns (uint256){
1578 
1579         //No money movement; usually a lost wager
1580         vault[_customerAddress] = Math.max256(0, vault[_customerAddress].sub(amount));
1581 
1582         totalCustomerCredit = totalCustomerCredit.sub(amount);
1583 
1584         //Stats
1585         stats[_customerAddress].debit = stats[_customerAddress].debit.add(amount);
1586         stats[_customerAddress].xDebit += 1;
1587 
1588         emit onWithdraw(_customerAddress, amount, now);
1589 
1590         return vault[_customerAddress];
1591     }
1592 
1593     /// @dev Withraws balance for address; returns amount sent
1594     function withdraw(address _customerAddress) onlyWhitelisted external returns (uint256){
1595         require(vault[_customerAddress] > 0);
1596 
1597         uint256 amount = vault[_customerAddress];
1598 
1599         vault[_customerAddress] = 0;
1600         totalCustomerCredit = totalCustomerCredit.sub(amount);
1601 
1602         _customerAddress.transfer(amount);
1603 
1604         //Stats
1605         stats[_customerAddress].withdrawn = stats[_customerAddress].withdrawn.add(amount);
1606         stats[_customerAddress].xWithdrawn += 1;
1607 
1608         emit onWithdraw(_customerAddress, amount, now);
1609     }
1610 
1611     function houseProfit(uint256 amount) onlyWhitelisted external {
1612         fundP6(amount);
1613         fundDao(amount);
1614     }
1615 
1616     /// @dev Retrieve the token balance of any single address.
1617     function balanceOf(address _customerAddress)  onlyWhitelisted external view returns (uint256) {
1618         return vault[_customerAddress];
1619     }
1620 
1621     /// @dev Stats of any single address
1622     function statsOf(address _customerAddress) public view returns (uint256[8]){
1623         Stats memory s = stats[_customerAddress];
1624         uint256[8] memory statArray = [s.deposit, s.credit, s.debit, s.withdrawn,
1625         s.xDeposit, s.xCredit, s.xDebit, s.xWithdrawn];
1626         return statArray;
1627     }
1628 
1629 
1630     // System functions
1631 
1632 
1633     /**
1634      * @dev Fallback function to handle ethereum that was send straight to the contract
1635      * Should just deposit so that we can accept funds from contracts as well using transfer
1636      */
1637     function() payable public {
1638         emit onDeposit(msg.sender, msg.value, now);
1639     }
1640 
1641     /// @dev Proper way to fund bankrollvault; don't use fallback
1642     function deposit() payable public  {
1643         // fire event
1644         emit onDeposit(msg.sender, msg.value, now);
1645     }
1646 
1647     /// @dev Proper way to fund bankrollvault by a specific customer
1648     function depositBy(address _customerAddress ) onlyWhitelisted payable external {
1649         // fire event; profit do not immediately shared with Snowfall
1650 
1651         //Stats
1652         stats[_customerAddress].deposit = stats[_customerAddress].deposit.add(msg.value);
1653         stats[_customerAddress].xDeposit += 1;
1654 
1655         emit onDeposit(_customerAddress, msg.value, now);
1656     }
1657 
1658     /**
1659     * @dev The bridge to the launch ecosystem. Community has to participate to dump divs
1660     * Should
1661     */
1662     function fundP6(uint256 amount) internal {
1663         uint256 fee = amount.mul(p6Fee).div(100);
1664 
1665         p6Outbound = p6Outbound.add(fee);
1666 
1667         //GO P6 GO!!!
1668         if (p6Outbound >= outboundThreshold){
1669             fee = p6Outbound;
1670             p6Outbound = 0;
1671             p6.buyFor.value(fee)(owner);
1672             emit onAirdrop(address(p6), fee, now);
1673         }
1674 
1675     }
1676 
1677     /**
1678     * @dev The bridge to the launch ecosystem. Community has to participate to dump divs
1679     * Should
1680     */
1681     function fundDao(uint256 amount) internal {
1682         uint256 fee = amount.mul(daoFee).div(100);
1683 
1684         daoOutbound = daoOutbound.add(fee);
1685 
1686         //GO P6 GO!!!
1687         if (daoOutbound >= outboundThreshold){
1688             fee = daoOutbound;
1689             daoOutbound = 0;
1690             dao.deposit.value(fee)();
1691             emit onAirdrop(address(dao), fee, now);
1692         }
1693 
1694     }
1695 
1696     /**
1697       * @dev Get all the ETH stored in contract
1698       *
1699       */
1700     function totalEthereumBalance() public view returns (uint256) {
1701         return address(this).balance;
1702     }
1703 
1704     /**
1705      * @dev Get all the ETH stored in contract minus credits to customers
1706      *
1707      */
1708     function netEthereumBalance() public view returns (uint256) {
1709         return address(this).balance.sub(totalCustomerCredit);
1710     }
1711 }