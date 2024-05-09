1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/Administrable.sol
46 
47 /**
48  * @title Administrable
49  * @dev Base contract extending Ownable with support for administration capabilities.
50  */
51 contract Administrable is Ownable {
52 
53     event LogAdministratorAdded(address indexed caller, address indexed administrator);
54     event LogAdministratorRemoved(address indexed caller, address indexed administrator);
55 
56     mapping (address => bool) private administrators;
57 
58     modifier onlyAdministrator() {
59         require(administrators[msg.sender], "caller is not administrator");
60         _;
61     }
62 
63     constructor() internal {
64         administrators[msg.sender] = true;
65 
66         emit LogAdministratorAdded(msg.sender, msg.sender);
67     }
68 
69     /**
70      * Add a new administrator to the list.
71      * @param newAdministrator The administrator address to add.
72      */
73     function addAdministrator(address newAdministrator) public onlyOwner {
74         require(newAdministrator != address(0), "newAdministrator is zero");
75         require(!administrators[newAdministrator], "newAdministrator is already present");
76 
77         administrators[newAdministrator] = true;
78 
79         emit LogAdministratorAdded(msg.sender, newAdministrator);
80     }
81 
82     /**
83      * Remove an existing administrator from the list.
84      * @param oldAdministrator The administrator address to remove.
85      */
86     function removeAdministrator(address oldAdministrator) public onlyOwner {
87         require(oldAdministrator != address(0), "oldAdministrator is zero");
88         require(administrators[oldAdministrator], "oldAdministrator is not present");
89 
90         administrators[oldAdministrator] = false;
91 
92         emit LogAdministratorRemoved(msg.sender, oldAdministrator);
93     }
94 
95     /**
96      * @return true if target address has administrator privileges, false otherwise
97      */
98     function isAdministrator(address target) public view returns(bool isReallyAdministrator) {
99         return administrators[target];
100     }
101 
102     /**
103      * Transfer ownership taking administration privileges into account.
104      * @param newOwner The new contract owner.
105      */
106     function transferOwnership(address newOwner) public onlyOwner {
107         administrators[msg.sender] = false;
108         emit LogAdministratorRemoved(msg.sender, msg.sender);
109 
110         administrators[newOwner] = true;
111         emit LogAdministratorAdded(msg.sender, newOwner);
112 
113         Ownable.transferOwnership(newOwner);
114     }
115 }
116 
117 // File: contracts/TokenSale.sol
118 
119 contract TokenSale {
120     /**
121     * Buy tokens for the beneficiary using paid Ether.
122     * @param beneficiary the beneficiary address that will receive the tokens.
123     */
124     function buyTokens(address beneficiary) public payable;
125 }
126 
127 // File: contracts/WhitelistableConstraints.sol
128 
129 /**
130  * @title WhitelistableConstraints
131  * @dev Contract encapsulating the constraints applicable to a Whitelistable contract.
132  */
133 contract WhitelistableConstraints {
134 
135     /**
136      * @dev Check if whitelist with specified parameters is allowed.
137      * @param _maxWhitelistLength The maximum length of whitelist. Zero means no whitelist.
138      * @param _weiWhitelistThresholdBalance The threshold balance triggering whitelist check.
139      * @return true if whitelist with specified parameters is allowed, false otherwise
140      */
141     function isAllowedWhitelist(uint256 _maxWhitelistLength, uint256 _weiWhitelistThresholdBalance)
142         public pure returns(bool isReallyAllowedWhitelist) {
143         return _maxWhitelistLength > 0 || _weiWhitelistThresholdBalance > 0;
144     }
145 }
146 
147 // File: contracts/Whitelistable.sol
148 
149 /**
150  * @title Whitelistable
151  * @dev Base contract implementing a whitelist to keep track of investors.
152  * The construction parameters allow for both whitelisted and non-whitelisted contracts:
153  * 1) maxWhitelistLength = 0 and whitelistThresholdBalance > 0: whitelist disabled
154  * 2) maxWhitelistLength > 0 and whitelistThresholdBalance = 0: whitelist enabled, full whitelisting
155  * 3) maxWhitelistLength > 0 and whitelistThresholdBalance > 0: whitelist enabled, partial whitelisting
156  */
157 contract Whitelistable is WhitelistableConstraints {
158 
159     event LogMaxWhitelistLengthChanged(address indexed caller, uint256 indexed maxWhitelistLength);
160     event LogWhitelistThresholdBalanceChanged(address indexed caller, uint256 indexed whitelistThresholdBalance);
161     event LogWhitelistAddressAdded(address indexed caller, address indexed subscriber);
162     event LogWhitelistAddressRemoved(address indexed caller, address indexed subscriber);
163 
164     mapping (address => bool) public whitelist;
165 
166     uint256 public whitelistLength;
167 
168     uint256 public maxWhitelistLength;
169 
170     uint256 public whitelistThresholdBalance;
171 
172     constructor(uint256 _maxWhitelistLength, uint256 _whitelistThresholdBalance) internal {
173         require(isAllowedWhitelist(_maxWhitelistLength, _whitelistThresholdBalance), "parameters not allowed");
174 
175         maxWhitelistLength = _maxWhitelistLength;
176         whitelistThresholdBalance = _whitelistThresholdBalance;
177     }
178 
179     /**
180      * @return true if whitelist is currently enabled, false otherwise
181      */
182     function isWhitelistEnabled() public view returns(bool isReallyWhitelistEnabled) {
183         return maxWhitelistLength > 0;
184     }
185 
186     /**
187      * @return true if subscriber is whitelisted, false otherwise
188      */
189     function isWhitelisted(address _subscriber) public view returns(bool isReallyWhitelisted) {
190         return whitelist[_subscriber];
191     }
192 
193     function setMaxWhitelistLengthInternal(uint256 _maxWhitelistLength) internal {
194         require(isAllowedWhitelist(_maxWhitelistLength, whitelistThresholdBalance),
195             "_maxWhitelistLength not allowed");
196         require(_maxWhitelistLength != maxWhitelistLength, "_maxWhitelistLength equal to current one");
197 
198         maxWhitelistLength = _maxWhitelistLength;
199 
200         emit LogMaxWhitelistLengthChanged(msg.sender, maxWhitelistLength);
201     }
202 
203     function setWhitelistThresholdBalanceInternal(uint256 _whitelistThresholdBalance) internal {
204         require(isAllowedWhitelist(maxWhitelistLength, _whitelistThresholdBalance),
205             "_whitelistThresholdBalance not allowed");
206         require(whitelistLength == 0 || _whitelistThresholdBalance > whitelistThresholdBalance,
207             "_whitelistThresholdBalance not greater than current one");
208 
209         whitelistThresholdBalance = _whitelistThresholdBalance;
210 
211         emit LogWhitelistThresholdBalanceChanged(msg.sender, _whitelistThresholdBalance);
212     }
213 
214     function addToWhitelistInternal(address _subscriber) internal {
215         require(_subscriber != address(0), "_subscriber is zero");
216         require(!whitelist[_subscriber], "already whitelisted");
217         require(whitelistLength < maxWhitelistLength, "max whitelist length reached");
218 
219         whitelistLength++;
220 
221         whitelist[_subscriber] = true;
222 
223         emit LogWhitelistAddressAdded(msg.sender, _subscriber);
224     }
225 
226     function removeFromWhitelistInternal(address _subscriber, uint256 _balance) internal {
227         require(_subscriber != address(0), "_subscriber is zero");
228         require(whitelist[_subscriber], "not whitelisted");
229         require(_balance <= whitelistThresholdBalance, "_balance greater than whitelist threshold");
230 
231         assert(whitelistLength > 0);
232 
233         whitelistLength--;
234 
235         whitelist[_subscriber] = false;
236 
237         emit LogWhitelistAddressRemoved(msg.sender, _subscriber);
238     }
239 
240     /**
241      * @param _subscriber The subscriber for which the balance check is required.
242      * @param _balance The balance value to check for allowance.
243      * @return true if the balance is allowed for the subscriber, false otherwise
244      */
245     function isAllowedBalance(address _subscriber, uint256 _balance) public view returns(bool isReallyAllowed) {
246         return !isWhitelistEnabled() || _balance <= whitelistThresholdBalance || whitelist[_subscriber];
247     }
248 }
249 
250 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
251 
252 /**
253  * @title SafeMath
254  * @dev Math operations with safety checks that throw on error
255  */
256 library SafeMath {
257 
258   /**
259   * @dev Multiplies two numbers, throws on overflow.
260   */
261   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
262     if (a == 0) {
263       return 0;
264     }
265     c = a * b;
266     assert(c / a == b);
267     return c;
268   }
269 
270   /**
271   * @dev Integer division of two numbers, truncating the quotient.
272   */
273   function div(uint256 a, uint256 b) internal pure returns (uint256) {
274     // assert(b > 0); // Solidity automatically throws when dividing by 0
275     // uint256 c = a / b;
276     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
277     return a / b;
278   }
279 
280   /**
281   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
282   */
283   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284     assert(b <= a);
285     return a - b;
286   }
287 
288   /**
289   * @dev Adds two numbers, throws on overflow.
290   */
291   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
292     c = a + b;
293     assert(c >= a);
294     return c;
295   }
296 }
297 
298 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
299 
300 /**
301  * @title ERC20Basic
302  * @dev Simpler version of ERC20 interface
303  * @dev see https://github.com/ethereum/EIPs/issues/179
304  */
305 contract ERC20Basic {
306   function totalSupply() public view returns (uint256);
307   function balanceOf(address who) public view returns (uint256);
308   function transfer(address to, uint256 value) public returns (bool);
309   event Transfer(address indexed from, address indexed to, uint256 value);
310 }
311 
312 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
313 
314 /**
315  * @title ERC20 interface
316  * @dev see https://github.com/ethereum/EIPs/issues/20
317  */
318 contract ERC20 is ERC20Basic {
319   function allowance(address owner, address spender) public view returns (uint256);
320   function transferFrom(address from, address to, uint256 value) public returns (bool);
321   function approve(address spender, uint256 value) public returns (bool);
322   event Approval(address indexed owner, address indexed spender, uint256 value);
323 }
324 
325 // File: contracts/MultipleBidReservation.sol
326 
327 /**
328  * A multiple-bid Reservation Contract (RC) for early deposit collection and manual token bid during
329  * the Initial Coin Offering (ICO) crowdsale events.
330  * The RC implements the following spec:
331  * - investors allowed to simply send ethers to the RC address
332  * - investors allowed to get refunded after ICO event if RC failed
333  * - multiple bids using investor addresses performed by owner or authorized administator
334  * - maximum cap on the total balance
335  * - minimum threshold on each subscriber balance
336  * - maximum number of subscribers
337  * - optional whitelist with max deposit threshold for non-whitelisted subscribers
338  * - kill switch callable by owner or authorized administator
339  * - withdraw pattern for refunding
340  * Just the RC owner or an authorized administator is allowed to shutdown the lifecycle halting the
341  * RC; no bounties are provided.
342  */
343 contract MultipleBidReservation is Administrable, Whitelistable {
344     using SafeMath for uint256;
345 
346     event LogMultipleBidReservationCreated(
347         uint256 indexed startBlock,
348         uint256 indexed endBlock,
349         uint256 maxSubscribers,
350         uint256 maxCap,
351         uint256 minDeposit,
352         uint256 maxWhitelistLength,
353         uint256 indexed whitelistThreshold
354     );
355     event LogStartBlockChanged(uint256 indexed startBlock);
356     event LogEndBlockChanged(uint256 indexed endBlock);
357     event LogMaxCapChanged(uint256 indexed maxCap);
358     event LogMinDepositChanged(uint256 indexed minDeposit);
359     event LogMaxSubscribersChanged(uint256 indexed maxSubscribers);
360     event LogCrowdsaleAddressChanged(address indexed crowdsale);
361     event LogAbort(address indexed caller);
362     event LogDeposit(
363         address indexed subscriber,
364         uint256 indexed amount,
365         uint256 indexed balance,
366         uint256 raisedFunds
367     );
368     event LogBuy(address caller, uint256 indexed from, uint256 indexed to);
369     event LogRefund(address indexed subscriber, uint256 indexed amount, uint256 indexed raisedFunds);
370 
371     // The block interval [start, end] where investments are allowed (both inclusive)
372     uint256 public startBlock;
373     uint256 public endBlock;
374 
375     // RC maximum cap (expressed in wei)
376     uint256 public maxCap;
377 
378     // RC minimum balance per subscriber (expressed in wei)
379     uint256 public minDeposit;
380 
381     // RC maximum number of allowed subscribers
382     uint256 public maxSubscribers;
383 
384     // Crowdsale public address
385     TokenSale public crowdsale;
386 
387     // RC current raised balance expressed in wei
388     uint256 public raisedFunds;
389 
390     // ERC20-compliant token issued during ICO
391     ERC20 public token;
392 
393     // Reservation balances (expressed in wei) deposited by each subscriber
394     mapping (address => uint256) public balances;
395 
396     // The list of subscribers in incoming order
397     address[] public subscribers;
398 
399     // Flag indicating if reservation has been forcibly terminated
400     bool public aborted;
401 
402     // The maximum value for whitelist threshold in wei
403     uint256 constant public MAX_WHITELIST_THRESHOLD = 2**256 - 1;
404 
405     modifier beforeStart() {
406         require(block.number < startBlock, "already started");
407         _;
408     }
409 
410     modifier beforeEnd() {
411         require(block.number <= endBlock, "already ended");
412         _;
413     }
414 
415     modifier whenReserving() {
416         require(!aborted, "aborted");
417         _;
418     }
419 
420     modifier whenAborted() {
421         require(aborted, "not aborted");
422         _;
423     }
424 
425     constructor(
426         uint256 _startBlock,
427         uint256 _endBlock,
428         uint256 _maxSubscribers,
429         uint256 _maxCap,
430         uint256 _minDeposit,
431         uint256 _maxWhitelistLength,
432         uint256 _whitelistThreshold
433     )
434     Whitelistable(_maxWhitelistLength, _whitelistThreshold) public
435     {
436         require(_startBlock >= block.number, "_startBlock < current block");
437         require(_endBlock >= _startBlock, "_endBlock < _startBlock");
438         require(_maxSubscribers > 0, "_maxSubscribers is 0");
439         require(_maxCap > 0, "_maxCap is 0");
440         require(_minDeposit > 0, "_minDeposit is 0");
441 
442         startBlock = _startBlock;
443         endBlock = _endBlock;
444         maxSubscribers = _maxSubscribers;
445         maxCap = _maxCap;
446         minDeposit = _minDeposit;
447 
448         emit LogMultipleBidReservationCreated(
449             startBlock,
450             endBlock,
451             maxSubscribers,
452             maxCap,
453             minDeposit,
454             _maxWhitelistLength,
455             _whitelistThreshold
456         );
457     }
458 
459     function hasStarted() public view returns(bool started) {
460         return block.number >= startBlock;
461     }
462 
463     function hasEnded() public view returns(bool ended) {
464         return block.number > endBlock;
465     }
466 
467     /**
468      * @return The current number of RC subscribers
469      */
470     function numSubscribers() public view returns(uint256 numberOfSubscribers) {
471         return subscribers.length;
472     }
473 
474     /**
475      * Change the RC start block number.
476      * @param _startBlock The start block
477      */
478     function setStartBlock(uint256 _startBlock) external onlyOwner beforeStart whenReserving {
479         require(_startBlock >= block.number, "_startBlock < current block");
480         require(_startBlock <= endBlock, "_startBlock > endBlock");
481         require(_startBlock != startBlock, "_startBlock == startBlock");
482 
483         startBlock = _startBlock;
484 
485         emit LogStartBlockChanged(_startBlock);
486     }
487 
488     /**
489      * Change the RC end block number.
490      * @param _endBlock The end block
491      */
492     function setEndBlock(uint256 _endBlock) external onlyOwner beforeEnd whenReserving {
493         require(_endBlock >= block.number, "_endBlock < current block");
494         require(_endBlock >= startBlock, "_endBlock < startBlock");
495         require(_endBlock != endBlock, "_endBlock == endBlock");
496 
497         endBlock = _endBlock;
498 
499         emit LogEndBlockChanged(_endBlock);
500     }
501 
502     /**
503      * Change the RC maximum cap. New value shall be at least equal to raisedFunds.
504      * @param _maxCap The RC maximum cap, expressed in wei
505      */
506     function setMaxCap(uint256 _maxCap) external onlyOwner beforeEnd whenReserving {
507         require(_maxCap > 0 && _maxCap >= raisedFunds, "invalid _maxCap");
508 
509         maxCap = _maxCap;
510 
511         emit LogMaxCapChanged(maxCap);
512     }
513 
514     /**
515      * Change the minimum deposit for each RC subscriber. New value shall be lower than previous.
516      * @param _minDeposit The minimum deposit for each RC subscriber, expressed in wei
517      */
518     function setMinDeposit(uint256 _minDeposit) external onlyOwner beforeEnd whenReserving {
519         require(_minDeposit > 0 && _minDeposit < minDeposit, "_minDeposit not in (0, minDeposit)");
520 
521         minDeposit = _minDeposit;
522 
523         emit LogMinDepositChanged(minDeposit);
524     }
525 
526     /**
527      * Change the maximum number of accepted RC subscribers. New value shall be at least equal to the current
528      * number of subscribers.
529      * @param _maxSubscribers The maximum number of subscribers
530      */
531     function setMaxSubscribers(uint256 _maxSubscribers) external onlyOwner beforeEnd whenReserving {
532         require(_maxSubscribers > 0 && _maxSubscribers >= subscribers.length, "invalid _maxSubscribers");
533 
534         maxSubscribers = _maxSubscribers;
535 
536         emit LogMaxSubscribersChanged(maxSubscribers);
537     }
538 
539     /**
540      * Change the ICO crowdsale address.
541      * @param _crowdsale The ICO crowdsale address
542      */
543     function setCrowdsaleAddress(address _crowdsale) external onlyOwner whenReserving {
544         require(_crowdsale != address(0), "_crowdsale is 0");
545 
546         crowdsale = TokenSale(_crowdsale);
547 
548         emit LogCrowdsaleAddressChanged(_crowdsale);
549     }
550 
551     /**
552      * Change the maximum whitelist length. New value shall satisfy the #isAllowedWhitelist conditions.
553      * @param _maxWhitelistLength The maximum whitelist length
554      */
555     function setMaxWhitelistLength(uint256 _maxWhitelistLength) external onlyOwner beforeEnd whenReserving {
556         setMaxWhitelistLengthInternal(_maxWhitelistLength);
557     }
558 
559     /**
560      * Change the whitelist threshold balance. New value shall satisfy the #isAllowedWhitelist conditions.
561      * @param _whitelistThreshold The threshold balance (in wei) above which whitelisting is required to invest
562      */
563     function setWhitelistThresholdBalance(uint256 _whitelistThreshold) external onlyOwner beforeEnd whenReserving {
564         setWhitelistThresholdBalanceInternal(_whitelistThreshold);
565     }
566 
567     /**
568      * Add the subscriber to the whitelist.
569      * @param _subscriber The subscriber to add to the whitelist.
570      */
571     function addToWhitelist(address _subscriber) external onlyOwner beforeEnd whenReserving {
572         addToWhitelistInternal(_subscriber);
573     }
574 
575     /**
576      * Removed the subscriber from the whitelist.
577      * @param _subscriber The subscriber to remove from the whitelist.
578      */
579     function removeFromWhitelist(address _subscriber) external onlyOwner beforeEnd whenReserving {
580         removeFromWhitelistInternal(_subscriber, balances[_subscriber]);
581     }
582 
583     /**
584      * Abort the contract before the ICO start time. An administrator is allowed to use this 'kill switch'
585      * to deactivate any contract function except the investor refunding.
586      */
587     function abort() external onlyAdministrator whenReserving {
588         aborted = true;
589 
590         emit LogAbort(msg.sender);
591     }
592 
593     /**
594      * Let the caller invest its money before the ICO start time.
595      */
596     function invest() external payable whenReserving {
597         deposit(msg.sender, msg.value);
598     }
599 
600     /**
601      * Execute a batch of multiple bids into the ICO crowdsale.
602      * @param _from The subscriber index, included, from which the batch starts.
603      * @param _to The subscriber index, excluded, to which the batch ends.
604      */
605     function buy(uint256 _from, uint256 _to) external onlyAdministrator whenReserving {
606         require(_from < _to, "_from >= _to");
607         require(crowdsale != address(0), "crowdsale not set");
608         require(subscribers.length > 0, "subscribers size is 0");
609         require(hasEnded(), "not ended");
610 
611         uint to = _to > subscribers.length ? subscribers.length : _to;
612 
613         for (uint256 i=_from; i<to; i++) {
614             address subscriber = subscribers[i];
615 
616             uint256 subscriberBalance = balances[subscriber];
617 
618             if (subscriberBalance > 0) {
619                 balances[subscriber] = 0;
620 
621                 crowdsale.buyTokens.value(subscriberBalance)(subscriber);
622             }
623         }
624 
625         emit LogBuy(msg.sender, _from, _to);
626     }
627 
628     /**
629      * Refund the invested money to the caller after the RC termination.
630      */
631     function refund() external whenAborted {
632         // Read the calling subscriber balance once
633         uint256 subscriberBalance = balances[msg.sender];
634 
635         // Withdraw is allowed IFF the calling subscriber has not zero balance
636         require(subscriberBalance > 0, "caller balance is 0");
637 
638         // Withdraw is allowed IFF the contract has some token balance
639         require(raisedFunds > 0, "token balance is 0");
640 
641         // Safely decrease the total balance
642         raisedFunds = raisedFunds.sub(subscriberBalance);
643 
644         // Clear the subscriber balance before transfer to prevent re-entrant attacks
645         balances[msg.sender] = 0;
646 
647         emit LogRefund(msg.sender, subscriberBalance, raisedFunds);
648 
649         // Transfer the balance back to the calling subscriber or throws on error
650         msg.sender.transfer(subscriberBalance);
651     }
652 
653     /**
654      * Allow investing by just sending money to the contract address.
655      */
656     function () external payable whenReserving {
657         deposit(msg.sender, msg.value);
658     }
659 
660     /**
661      * Deposit the money amount for the beneficiary when RC is running.
662      */
663     function deposit(address beneficiary, uint256 amount) internal {
664         // Deposit is allowed IFF the RC is currently running
665         require(startBlock <= block.number && block.number <= endBlock, "not open");
666 
667         uint256 newRaisedFunds = raisedFunds.add(amount);
668 
669         // Deposit is allowed IFF the contract balance will not reach its maximum cap
670         require(newRaisedFunds <= maxCap, "over max cap");
671 
672         uint256 currentBalance = balances[beneficiary];
673         uint256 finalBalance = currentBalance.add(amount);
674 
675         // Deposit is allowed IFF investor deposit shall be at least equal to the minimum deposit threshold
676         require(finalBalance >= minDeposit, "deposit < min deposit");
677 
678         // Balances over whitelist threshold are allowed IFF the sender is in whitelist
679         require(isAllowedBalance(beneficiary, finalBalance), "balance not allowed");
680 
681         // Increase the subscriber count if sender does not have a balance yet
682         if (currentBalance == 0) {
683             // New subscribers are allowed IFF the contract has not yet the max number of subscribers
684             require(subscribers.length < maxSubscribers, "max subscribers reached");
685 
686             subscribers.push(beneficiary);
687         }
688 
689         // Add the received amount to the subscriber balance
690         balances[beneficiary] = finalBalance;
691 
692         raisedFunds = newRaisedFunds;
693 
694         emit LogDeposit(beneficiary, amount, finalBalance, newRaisedFunds);
695     }
696 }
697 
698 // File: contracts/NokuCustomReservation.sol
699 
700 /**
701  * @title NokuCustomReservation
702  * @dev Extension of MultipleBidReservation.
703  */
704 contract NokuCustomReservation is MultipleBidReservation {
705     event LogNokuCustomReservationCreated();
706 
707     constructor(
708         uint256 _startBlock,
709         uint256 _endBlock,
710         uint256 _maxSubscribers,
711         uint256 _maxCap,
712         uint256 _minDeposit,
713         uint256 _maxWhitelistLength,
714         uint256 _whitelistThreshold
715     )
716     MultipleBidReservation(
717         _startBlock,
718         _endBlock,
719         _maxSubscribers,
720         _maxCap,
721         _minDeposit,
722         _maxWhitelistLength,
723         _whitelistThreshold
724     )
725     public {
726         emit LogNokuCustomReservationCreated();
727     }
728 }
729 
730 // File: contracts/NokuPricingPlan.sol
731 
732 /**
733 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
734 */
735 contract NokuPricingPlan {
736     /**
737     * @dev Pay the fee for the service identified by the specified name.
738     * The fee amount shall already be approved by the client.
739     * @param serviceName The name of the target service.
740     * @param multiplier The multiplier of the base service fee to apply.
741     * @param client The client of the target service.
742     * @return true if fee has been paid.
743     */
744     function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);
745 
746     /**
747     * @dev Get the usage fee for the service identified by the specified name.
748     * The returned fee amount shall be approved before using #payFee method.
749     * @param serviceName The name of the target service.
750     * @param multiplier The multiplier of the base service fee to apply.
751     * @return The amount to approve before really paying such fee.
752     */
753     function usageFee(bytes32 serviceName, uint256 multiplier) public constant returns(uint fee);
754 }
755 
756 // File: openzeppelin-solidity/contracts/AddressUtils.sol
757 
758 /**
759  * Utility library of inline functions on addresses
760  */
761 library AddressUtils {
762 
763   /**
764    * Returns whether the target address is a contract
765    * @dev This function will return false if invoked during the constructor of a contract,
766    *  as the code is not actually created until after the constructor finishes.
767    * @param addr address to check
768    * @return whether the target address is a contract
769    */
770   function isContract(address addr) internal view returns (bool) {
771     uint256 size;
772     // XXX Currently there is no better way to check if there is a contract in an address
773     // than to check the size of the code at that address.
774     // See https://ethereum.stackexchange.com/a/14016/36603
775     // for more details about how this works.
776     // TODO Check this again before the Serenity release, because all addresses will be
777     // contracts then.
778     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
779     return size > 0;
780   }
781 
782 }
783 
784 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
785 
786 /**
787  * @title Pausable
788  * @dev Base contract which allows children to implement an emergency stop mechanism.
789  */
790 contract Pausable is Ownable {
791   event Pause();
792   event Unpause();
793 
794   bool public paused = false;
795 
796 
797   /**
798    * @dev Modifier to make a function callable only when the contract is not paused.
799    */
800   modifier whenNotPaused() {
801     require(!paused);
802     _;
803   }
804 
805   /**
806    * @dev Modifier to make a function callable only when the contract is paused.
807    */
808   modifier whenPaused() {
809     require(paused);
810     _;
811   }
812 
813   /**
814    * @dev called by the owner to pause, triggers stopped state
815    */
816   function pause() onlyOwner whenNotPaused public {
817     paused = true;
818     emit Pause();
819   }
820 
821   /**
822    * @dev called by the owner to unpause, returns to normal state
823    */
824   function unpause() onlyOwner whenPaused public {
825     paused = false;
826     emit Unpause();
827   }
828 }
829 
830 // File: contracts/NokuCustomService.sol
831 
832 contract NokuCustomService is Pausable {
833     using AddressUtils for address;
834 
835     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
836 
837     // The pricing plan determining the fee to be paid in NOKU tokens by customers
838     NokuPricingPlan public pricingPlan;
839 
840     constructor(address _pricingPlan) internal {
841         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
842 
843         pricingPlan = NokuPricingPlan(_pricingPlan);
844     }
845 
846     function setPricingPlan(address _pricingPlan) public onlyOwner {
847         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
848         require(NokuPricingPlan(_pricingPlan) != pricingPlan, "_pricingPlan equal to current");
849         
850         pricingPlan = NokuPricingPlan(_pricingPlan);
851 
852         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
853     }
854 }
855 
856 // File: contracts/NokuCustomReservationService.sol
857 
858 /**
859  * @title NokuCustomReservationService
860  * @dev Extension of NokuCustomService adding the fee payment in NOKU tokens.
861  */
862 contract NokuCustomReservationService is NokuCustomService {
863     event LogNokuCustomReservationServiceCreated(address indexed caller);
864 
865     bytes32 public constant SERVICE_NAME = "NokuCustomERC20.reservation";
866     uint256 public constant CREATE_AMOUNT = 1 * 10**18;
867 
868     constructor(address _pricingPlan) NokuCustomService(_pricingPlan) public {
869         emit LogNokuCustomReservationServiceCreated(msg.sender);
870     }
871 
872     function createCustomReservation(
873         uint256 _startBlock,
874         uint256 _endBlock,
875         uint256 _maxSubscribers,
876         uint256 _maxCap,
877         uint256 _minDeposit,
878         uint256 _maxWhitelistLength,
879         uint256 _whitelistThreshold
880     )
881     public returns(NokuCustomReservation customReservation)
882     {
883         customReservation = new NokuCustomReservation(
884             _startBlock,
885             _endBlock,
886             _maxSubscribers,
887             _maxCap,
888             _minDeposit,
889             _maxWhitelistLength,
890             _whitelistThreshold
891         );
892 
893         // Transfer NokuCustomReservation ownership to the client
894         customReservation.transferOwnership(msg.sender);
895 
896         require(pricingPlan.payFee(SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
897     }
898 }