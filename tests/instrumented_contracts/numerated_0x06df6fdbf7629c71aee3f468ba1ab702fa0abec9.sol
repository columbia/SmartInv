1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev called by the owner to pause, triggers stopped state
95    */
96   function pause() onlyOwner whenNotPaused public {
97     paused = true;
98     emit Pause();
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() onlyOwner whenPaused public {
105     paused = false;
106     emit Unpause();
107   }
108 }
109 
110 
111 /**
112  * @title ERC20Basic
113  * @dev Simpler version of ERC20 interface
114  * See https://github.com/ethereum/EIPs/issues/179
115  */
116 contract ERC20Basic {
117   function totalSupply() public view returns (uint256);
118   function balanceOf(address who) public view returns (uint256);
119   function transfer(address to, uint256 value) public returns (bool);
120   event Transfer(address indexed from, address indexed to, uint256 value);
121 }
122 
123 contract BBODServiceRegistry is Ownable {
124 
125   //1. Manager
126   //2. CustodyStorage
127   mapping(uint => address) public registry;
128 
129     constructor(address _owner) {
130         owner = _owner;
131     }
132 
133   function setServiceRegistryEntry (uint key, address entry) external onlyOwner {
134     registry[key] = entry;
135   }
136 }
137 
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender)
145     public view returns (uint256);
146 
147   function transferFrom(address from, address to, uint256 value)
148     public returns (bool);
149 
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 value
155   );
156 }
157 
158 
159 /**
160  * @title SafeMath
161  * @dev Math operations with safety checks that throw on error
162  */
163 library SafeMath {
164 
165   /**
166   * @dev Multiplies two numbers, throws on overflow.
167   */
168   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
169     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
170     // benefit is lost if 'b' is also tested.
171     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
172     if (a == 0) {
173       return 0;
174     }
175 
176     c = a * b;
177     assert(c / a == b);
178     return c;
179   }
180 
181   /**
182   * @dev Integer division of two numbers, truncating the quotient.
183   */
184   function div(uint256 a, uint256 b) internal pure returns (uint256) {
185     // assert(b > 0); // Solidity automatically throws when dividing by 0
186     // uint256 c = a / b;
187     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188     return a / b;
189   }
190 
191   /**
192   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
193   */
194   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195     assert(b <= a);
196     return a - b;
197   }
198 
199   /**
200   * @dev Adds two numbers, throws on overflow.
201   */
202   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
203     c = a + b;
204     assert(c >= a);
205     return c;
206   }
207 }
208 
209 
210 contract ManagerInterface {
211   function createCustody(address) external {}
212 
213   function isExchangeAlive() public pure returns (bool) {}
214 
215   function isDailySettlementOnGoing() public pure returns (bool) {}
216 }
217 
218 contract Custody {
219 
220   using SafeMath for uint;
221 
222   BBODServiceRegistry public bbodServiceRegistry;
223   address public owner;
224 
225   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227   constructor(address _serviceRegistryAddress, address _owner) public {
228     bbodServiceRegistry = BBODServiceRegistry(_serviceRegistryAddress);
229     owner = _owner;
230   }
231 
232   function() public payable {}
233 
234   modifier liveExchangeOrOwner(address _recipient) {
235     var manager = ManagerInterface(bbodServiceRegistry.registry(1));
236 
237     if (manager.isExchangeAlive()) {
238 
239       require(msg.sender == address(manager));
240 
241       if (manager.isDailySettlementOnGoing()) {
242         require(_recipient == address(manager), "Only manager can do this when the settlement is ongoing");
243       } else {
244         require(_recipient == owner);
245       }
246 
247     } else {
248       require(msg.sender == owner, "Only owner can do this when exchange is dead");
249     }
250     _;
251   }
252 
253   function withdraw(uint _amount, address _recipient) external liveExchangeOrOwner(_recipient) {
254     _recipient.transfer(_amount);
255   }
256 
257   function transferToken(address _erc20Address, address _recipient, uint _amount)
258     external liveExchangeOrOwner(_recipient) {
259 
260     ERC20 token = ERC20(_erc20Address);
261 
262     token.transfer(_recipient, _amount);
263   }
264 
265   function transferOwnership(address newOwner) public {
266     require(msg.sender == owner, "Only the owner can transfer ownership");
267     require(newOwner != address(0));
268 
269     emit OwnershipTransferred(owner, newOwner);
270     owner = newOwner;
271   }
272 }
273 
274 
275 contract CustodyStorage {
276 
277   BBODServiceRegistry public bbodServiceRegistry;
278 
279   mapping(address => bool) public custodiesMap;
280 
281   //Number of all custodies in the contract
282   uint public custodyCounter = 0;
283 
284   address[] public custodiesArray;
285 
286   event CustodyRemoved(address indexed custody);
287 
288   constructor(address _serviceRegistryAddress) public {
289     bbodServiceRegistry = BBODServiceRegistry(_serviceRegistryAddress);
290   }
291 
292   modifier onlyManager() {
293     require(msg.sender == bbodServiceRegistry.registry(1));
294     _;
295   }
296 
297   function addCustody(address _custody) external onlyManager {
298     custodiesMap[_custody] = true;
299     custodiesArray.push(_custody);
300     custodyCounter++;
301   }
302 
303   function removeCustody(address _custodyAddress, uint _arrayIndex) external onlyManager {
304     require(custodiesArray[_arrayIndex] == _custodyAddress);
305 
306     if (_arrayIndex == custodyCounter - 1) {
307       //Removing last custody
308       custodiesMap[_custodyAddress] = false;
309       emit CustodyRemoved(_custodyAddress);
310       custodyCounter--;
311       return;
312     }
313 
314     custodiesMap[_custodyAddress] = false;
315     //Overwriting deleted custody with the last custody in the array
316     custodiesArray[_arrayIndex] = custodiesArray[custodyCounter - 1];
317     custodyCounter--;
318 
319     emit CustodyRemoved(_custodyAddress);
320   }
321 }
322 contract Insurance is Custody {
323 
324   constructor(address _serviceRegistryAddress, address _owner)
325   Custody(_serviceRegistryAddress, _owner) public {}
326 
327   function useInsurance (uint _amount) external {
328     var manager = ManagerInterface(bbodServiceRegistry.registry(1));
329     //Only usable for manager during settlement
330     require(manager.isDailySettlementOnGoing() && msg.sender == address(manager));
331 
332     address(manager).transfer(_amount);
333   }
334 }
335 
336 contract Manager is Pausable {
337 using SafeMath for uint;
338 
339 mapping(address => bool) public ownerAccountsMap;
340 mapping(address => bool) public exchangeAccountsMap;
341 
342 //SETTLEMENT PREPARATION####
343 
344 enum SettlementPhase {
345 PREPARING, ONGOING, FINISHED
346 }
347 
348 enum Cryptocurrency {
349 ETH, BBD
350 }
351 
352 //Initially ready for a settlement
353 SettlementPhase public currentSettlementPhase = SettlementPhase.FINISHED;
354 
355 uint public startingFeeBalance = 0;
356 uint public totalFeeFlows = 0;
357 uint public startingInsuranceBalance = 0;
358 uint public totalInsuranceFlows = 0;
359 
360 uint public lastSettlementStartedTimestamp = 0;
361 uint public earliestNextSettlementTimestamp = 0;
362 
363 mapping(uint => mapping(address => bool)) public custodiesServedETH;
364 mapping(uint => mapping(address => bool)) public custodiesServedBBD;
365 
366 address public feeAccount;
367 address public insuranceAccount;
368 ERC20 public bbdToken;
369 CustodyStorage public custodyStorage;
370 
371 address public custodyFactory;
372 uint public gweiBBDPriceInWei;
373 uint public lastTimePriceSet;
374 uint constant public gwei = 1000000000;
375 
376 uint public maxTimeIntervalHB = 1 weeks;
377 uint public heartBeat = now;
378 
379 constructor(address _feeAccount, address _insuranceAccount, address _bbdTokenAddress, address _custodyStorage,
380 address _serviceRegistryAddress) public {
381 //Contract creator is the first owner
382 ownerAccountsMap[msg.sender] = true;
383 feeAccount = _feeAccount;
384 insuranceAccount = _insuranceAccount;
385 bbdToken = ERC20(_bbdTokenAddress);
386 custodyStorage = CustodyStorage(_custodyStorage);
387 }
388 
389 function() public payable {}
390 
391 function setCustodyFactory(address _custodyFactory) external onlyOwner {
392 custodyFactory = _custodyFactory;
393 }
394 
395 function pause() public onlyExchangeOrOwner {
396 paused = true;
397 }
398 
399 function unpause() public onlyExchangeOrOwner {
400 paused = false;
401 }
402 
403 modifier onlyAllowedInPhase(SettlementPhase _phase) {
404 require(currentSettlementPhase == _phase, "Not allowed in this phase");
405 _;
406 }
407 
408 modifier onlyOwner() {
409 require(ownerAccountsMap[msg.sender] == true, "Only an owner can perform this action");
410 _;
411 }
412 
413 modifier onlyExchange() {
414 require(exchangeAccountsMap[msg.sender] == true, "Only an exchange can perform this action");
415 _;
416 }
417 
418 modifier onlyExchangeOrOwner() {
419 require(exchangeAccountsMap[msg.sender] == true ||
420 ownerAccountsMap[msg.sender] == true);
421 _;
422 }
423 
424 function isDailySettlementOnGoing() external view returns (bool) {
425 return currentSettlementPhase != SettlementPhase.FINISHED;
426 }
427 
428 function updateHeartBeat() external whenNotPaused onlyOwner {
429 heartBeat = now;
430 }
431 
432 function isExchangeAlive() external view returns (bool) {
433 return now - heartBeat < maxTimeIntervalHB;
434 }
435 
436 function addOwnerAccount(address _exchangeAccount) external onlyOwner {
437 ownerAccountsMap[_exchangeAccount] = true;
438 }
439 
440 function addExchangeAccount(address _exchangeAccount) external onlyOwner whenNotPaused {
441 exchangeAccountsMap[_exchangeAccount] = true;
442 }
443 
444 function rmExchangeAccount(address _exchangeAccount) external onlyOwner whenNotPaused {
445 exchangeAccountsMap[_exchangeAccount] = false;
446 }
447 
448 function setBBDPrice(uint _priceInWei) external onlyExchangeOrOwner whenNotPaused
449 onlyAllowedInPhase(SettlementPhase.FINISHED) {
450 if(gweiBBDPriceInWei == 0) {
451 gweiBBDPriceInWei = _priceInWei;
452 } else {
453 //Max 100% daily increase in price
454 if(_priceInWei > gweiBBDPriceInWei) {
455 require(_priceInWei - gweiBBDPriceInWei <= (gweiBBDPriceInWei / 2));
456 //Max 50% daily decrease in price
457 } else if(_priceInWei < gweiBBDPriceInWei) {
458 require(gweiBBDPriceInWei - _priceInWei <= (gweiBBDPriceInWei / 2));
459 }
460 gweiBBDPriceInWei = _priceInWei;
461 }
462 //Price can only be set once per day
463 require(now - lastTimePriceSet > 23 hours);
464 
465 lastTimePriceSet = now;
466 }
467 
468 function createCustody(address _custody) external whenNotPaused onlyAllowedInPhase(SettlementPhase.FINISHED) {
469 require(msg.sender == custodyFactory);
470 custodyStorage.addCustody(_custody);
471 }
472 
473 function removeCustody(address _custodyAddress, uint _arrayIndex) external whenNotPaused onlyExchangeOrOwner
474 onlyAllowedInPhase(SettlementPhase.FINISHED) {
475 custodyStorage.removeCustody(_custodyAddress, _arrayIndex);
476 }
477 
478 /// @dev Exchange uses this function to withdraw ether from the contract
479 /// @param _amount to withdraw
480 /// @param _recipient to send withdrawn ether to
481 function withdrawFromManager(uint _amount, address _recipient) external onlyExchangeOrOwner
482 whenNotPaused onlyAllowedInPhase(SettlementPhase.FINISHED) {
483 _recipient.transfer(_amount);
484 }
485 
486 /// @dev Users use this function to withdraw ether from their custody
487 /// @param _amount to withdraw
488 /// @param _custodyAddress to withdraw from
489 function withdrawFromCustody(uint _amount, address _custodyAddress,address _recipient) external onlyExchangeOrOwner
490 whenNotPaused onlyAllowedInPhase(SettlementPhase.FINISHED) {
491 Custody custody = Custody(_custodyAddress);
492 custody.withdraw(_amount, _recipient);
493 }
494 
495 /// @dev Users use this function to withdraw ether from their custody
496 /// @param _tokenAddress of the ERC20 to withdraw from
497 /// @param _amount to withdraw
498 /// @param _custodyAddress to withdraw from
499 function withdrawTokensFromCustody(address _tokenAddress, uint _amount, address _custodyAddress, address _recipient)
500 external whenNotPaused onlyAllowedInPhase(SettlementPhase.FINISHED) onlyExchangeOrOwner {
501 Custody custody = Custody(_custodyAddress);
502 custody.transferToken(_tokenAddress, _recipient,_amount);
503 }
504 
505 //DAILY SETTLEMENT
506 
507 /// @dev This function prepares the daily settlement - resets all settlement
508 /// @dev scope storage variables to 0.
509 function startSettlementPreparation() external whenNotPaused onlyExchangeOrOwner
510 onlyAllowedInPhase(SettlementPhase.FINISHED) {
511 require(now > earliestNextSettlementTimestamp, "A settlement can happen once per day");
512 require(gweiBBDPriceInWei > 0, "BBD Price cannot be 0 during settlement");
513 
514 lastSettlementStartedTimestamp = now;
515 totalFeeFlows = 0;
516 totalInsuranceFlows = 0;
517 
518 currentSettlementPhase = SettlementPhase.ONGOING;
519 
520 
521 startingFeeBalance = feeAccount.balance +
522 ((bbdToken.balanceOf(feeAccount) * gweiBBDPriceInWei) / gwei);
523 
524 startingInsuranceBalance = insuranceAccount.balance;
525 }
526 
527 /// @dev This function is used to process a batch of net eth flows, two arrays
528 /// @dev are pairs of custody addresses and the balance changes that should
529 /// @dev be executed. Transaction will revert if exchange rules are violated.
530 /// @param _custodies flow addresses
531 /// @param _flows flow balance changes (can be negative or positive)
532 /// @param _fee calculated and deducted from all batch flows
533 /// @param _insurance to be used
534 function settleETHBatch(address[] _custodies, int[] _flows, uint _fee, uint _insurance) external whenNotPaused onlyExchangeOrOwner
535 onlyAllowedInPhase(SettlementPhase.ONGOING) {
536 
537 require(_custodies.length == _flows.length);
538 
539 uint preBatchBalance = address(this).balance;
540 
541 if(_insurance > 0) {
542 Insurance(insuranceAccount).useInsurance(_insurance);
543 }
544 
545 for (uint flowIndex = 0; flowIndex < _flows.length; flowIndex++) {
546 
547 //Every custody can be served ETH once during settlement
548 require(custodiesServedETH[lastSettlementStartedTimestamp][_custodies[flowIndex]] == false);
549 
550 //All addresses must be custodies
551 require(custodyStorage.custodiesMap(_custodies[flowIndex]));
552 
553 if (_flows[flowIndex] > 0) {
554 //10% rule
555 var outboundFlow = uint(_flows[flowIndex]);
556 
557 //100% rule exception threshold
558 if(outboundFlow > 10 ether) {
559 //100% rule
560 require(getTotalBalanceFor(_custodies[flowIndex]) >= outboundFlow);
561 }
562 
563 _custodies[flowIndex].transfer(uint(_flows[flowIndex]));
564 
565 } else if (_flows[flowIndex] < 0) {
566 Custody custody = Custody(_custodies[flowIndex]);
567 
568 custody.withdraw(uint(-_flows[flowIndex]), address(this));
569 }
570 
571 custodiesServedETH[lastSettlementStartedTimestamp][_custodies[flowIndex]] = true;
572 }
573 
574 if(_fee > 0) {
575 feeAccount.transfer(_fee);
576 totalFeeFlows = totalFeeFlows + _fee;
577 //100% rule for fee account
578 require(totalFeeFlows <= startingFeeBalance);
579 }
580 
581 uint postBatchBalance = address(this).balance;
582 
583 //Zero-sum guaranteed for ever batch
584 if(address(this).balance > preBatchBalance) {
585 uint leftovers = address(this).balance - preBatchBalance;
586 insuranceAccount.transfer(leftovers);
587 totalInsuranceFlows += leftovers;
588 //100% rule for insurance account
589 require(totalInsuranceFlows <= startingInsuranceBalance);
590 }
591 }
592 
593 /// @dev This function is used to process a batch of net bbd flows, two arrays
594 /// @dev are pairs of custody addresses and the balance changes that should
595 /// @dev be executed. Transaction will revert if exchange rules are violated.
596 /// @param _custodies flow addresses
597 /// @param _flows flow balance changes (can be negative or positive)
598 /// @param _fee calculated and deducted from all batch flows
599 function settleBBDBatch(address[] _custodies, int[] _flows, uint _fee) external whenNotPaused onlyExchangeOrOwner
600 onlyAllowedInPhase(SettlementPhase.ONGOING) {
601 //TODO optimize for gas usage
602 
603 require(_custodies.length == _flows.length);
604 
605 uint preBatchBalance = bbdToken.balanceOf(address(this));
606 
607 for (uint flowIndex = 0; flowIndex < _flows.length; flowIndex++) {
608 
609 //Every custody can be served BBD once during settlement
610 require(custodiesServedBBD[lastSettlementStartedTimestamp][_custodies[flowIndex]] == false);
611 //All addresses must be custodies
612 require(custodyStorage.custodiesMap(_custodies[flowIndex]));
613 
614 if (_flows[flowIndex] > 0) {
615 var flowValue = ((uint(_flows[flowIndex]) * gweiBBDPriceInWei)/gwei);
616 
617 //Minimal BBD transfer is 1gWeiBBD
618 require(flowValue >= 1);
619 
620 //50% rule threshold
621 if(flowValue > 10 ether) {
622 //50% rule for bbd
623 require((getTotalBalanceFor(_custodies[flowIndex]) / 2) >= flowValue);
624 }
625 
626 bbdToken.transfer(_custodies[flowIndex], uint(_flows[flowIndex]));
627 
628 } else if (_flows[flowIndex] < 0) {
629 Custody custody = Custody(_custodies[flowIndex]);
630 
631 custody.transferToken(address(bbdToken),address(this), uint(-(_flows[flowIndex])));
632 }
633 
634 custodiesServedBBD[lastSettlementStartedTimestamp][_custodies[flowIndex]] = true;
635 }
636 
637 if(_fee > 0) {
638 bbdToken.transfer(feeAccount, _fee);
639 //No need for safe math, as transfer will trow if _fee could cause overflow
640 totalFeeFlows += ((_fee * gweiBBDPriceInWei) / gwei);
641 require (totalFeeFlows <= startingFeeBalance);
642 }
643 
644 uint postBatchBalance = bbdToken.balanceOf(address(this));
645 
646 //Zero-or-less-sum guaranteed for every batch, no insurance for spots
647 require(postBatchBalance <= preBatchBalance);
648 }
649 
650 /// @dev This function is used to finish the settlement process
651 function finishSettlement() external whenNotPaused onlyExchangeOrOwner
652 onlyAllowedInPhase(SettlementPhase.ONGOING) {
653 //TODO phase change event?
654 earliestNextSettlementTimestamp = lastSettlementStartedTimestamp + 23 hours;
655 
656 currentSettlementPhase = SettlementPhase.FINISHED;
657 }
658 
659 function getTotalBalanceFor(address _custody) internal view returns (uint) {
660 
661 var bbdHoldingsInWei = ((bbdToken.balanceOf(_custody) * gweiBBDPriceInWei) / gwei);
662 
663 return _custody.balance + bbdHoldingsInWei;
664 }
665 
666 function checkIfCustodiesServedETH(address[] _custodies) external view returns (bool) {
667 for (uint custodyIndex = 0; custodyIndex < _custodies.length; custodyIndex++) {
668 if(custodiesServedETH[lastSettlementStartedTimestamp][_custodies[custodyIndex]]) {
669 return true;
670 }
671 }
672 return false;
673 }
674 
675 function checkIfCustodiesServedBBD(address[] _custodies) external view returns (bool) {
676 for (uint custodyIndex = 0; custodyIndex < _custodies.length; custodyIndex++) {
677 if(custodiesServedBBD[lastSettlementStartedTimestamp][_custodies[custodyIndex]]) {
678 return true;
679 }
680 }
681 return false;
682 }
683 }