1 //v1.0.14
2 //License: Apache2.0
3 pragma solidity ^0.4.8;
4 
5 contract TokenSpender {
6     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
7 }
8 
9 pragma solidity ^0.4.8;
10 
11 contract ERC20 {
12   uint public totalSupply;
13   function balanceOf(address who) constant returns (uint);
14   function allowance(address owner, address spender) constant returns (uint);
15 
16   function transfer(address to, uint value) returns (bool ok);
17   function transferFrom(address from, address to, uint value) returns (bool ok);
18   function approve(address spender, uint value) returns (bool ok);
19   event Transfer(address indexed from, address indexed to, uint value);
20   event Approval(address indexed owner, address indexed spender, uint value);
21 }
22 
23 pragma solidity ^0.4.8;
24 
25 contract SafeMath {
26   function safeMul(uint a, uint b) internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) internal returns (uint) {
33     assert(b > 0);
34     uint c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a >= b ? a : b;
52   }
53 
54   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55     return a < b ? a : b;
56   }
57 
58   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a >= b ? a : b;
60   }
61 
62   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63     return a < b ? a : b;
64   }
65 
66   function assert(bool assertion) internal {
67     if (!assertion) {
68       throw;
69     }
70   }
71 }
72 
73 pragma solidity ^0.4.21;
74 
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  * last open zepplin version used for : add sub mul div function : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
80 * commit : https://github.com/OpenZeppelin/zeppelin-solidity/commit/815d9e1f457f57cfbb1b4e889f2255c9a517f661
81  */
82 library SafeMathOZ
83 {
84 	function add(uint256 a, uint256 b) internal pure returns (uint256)
85 	{
86 		uint256 c = a + b;
87 		assert(c >= a);
88 		return c;
89 	}
90 
91 	function sub(uint256 a, uint256 b) internal pure returns (uint256)
92 	{
93 		assert(b <= a);
94 		return a - b;
95 	}
96 
97 	function mul(uint256 a, uint256 b) internal pure returns (uint256)
98 	{
99 		if (a == 0)
100 		{
101 			return 0;
102 		}
103 		uint256 c = a * b;
104 		assert(c / a == b);
105 		return c;
106 	}
107 
108 	function div(uint256 a, uint256 b) internal pure returns (uint256)
109 	{
110 		// assert(b > 0); // Solidity automatically throws when dividing by 0
111 		uint256 c = a / b;
112 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 		return c;
114 	}
115 
116 	function max(uint256 a, uint256 b) internal pure returns (uint256)
117 	{
118 		return a >= b ? a : b;
119 	}
120 
121 	function min(uint256 a, uint256 b) internal pure returns (uint256)
122 	{
123 		return a < b ? a : b;
124 	}
125 
126 	function mulByFraction(uint256 a, uint256 b, uint256 c) internal pure returns (uint256)
127 	{
128 		return div(mul(a, b), c);
129 	}
130 
131 	function percentage(uint256 a, uint256 b) internal pure returns (uint256)
132 	{
133 		return mulByFraction(a, b, 100);
134 	}
135 	// Source : https://ethereum.stackexchange.com/questions/8086/logarithm-math-operation-in-solidity
136 	function log(uint x) internal pure returns (uint y)
137 	{
138 		assembly
139 		{
140 			let arg := x
141 			x := sub(x,1)
142 			x := or(x, div(x, 0x02))
143 			x := or(x, div(x, 0x04))
144 			x := or(x, div(x, 0x10))
145 			x := or(x, div(x, 0x100))
146 			x := or(x, div(x, 0x10000))
147 			x := or(x, div(x, 0x100000000))
148 			x := or(x, div(x, 0x10000000000000000))
149 			x := or(x, div(x, 0x100000000000000000000000000000000))
150 			x := add(x, 1)
151 			let m := mload(0x40)
152 			mstore(m,           0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
153 			mstore(add(m,0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
154 			mstore(add(m,0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
155 			mstore(add(m,0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
156 			mstore(add(m,0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
157 			mstore(add(m,0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
158 			mstore(add(m,0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
159 			mstore(add(m,0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
160 			mstore(0x40, add(m, 0x100))
161 			let magic := 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
162 			let shift := 0x100000000000000000000000000000000000000000000000000000000000000
163 			let a := div(mul(x, magic), shift)
164 			y := div(mload(add(m,sub(255,a))), shift)
165 			y := add(y, mul(256, gt(arg, 0x8000000000000000000000000000000000000000000000000000000000000000)))
166 		}
167 	}
168 }
169 
170 
171 pragma solidity ^0.4.8;
172 
173 contract Ownable {
174   address public owner;
175 
176   function Ownable() {
177     owner = msg.sender;
178   }
179 
180   modifier onlyOwner() {
181     if (msg.sender == owner)
182       _;
183   }
184 
185   function transferOwnership(address newOwner) onlyOwner {
186     if (newOwner != address(0)) owner = newOwner;
187   }
188 
189 }
190 
191 pragma solidity ^0.4.21;
192 
193 /**
194  * @title Ownable
195  * @dev The Ownable contract has an owner address, and provides basic authorization control
196  * functions, this simplifies the implementation of "user permissions".
197  */
198 contract OwnableOZ
199 {
200 	address public m_owner;
201 	bool    public m_changeable;
202 
203 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205 	/**
206 	 * @dev Throws if called by any account other than the owner.
207 	 */
208 	modifier onlyOwner()
209 	{
210 		require(msg.sender == m_owner);
211 		_;
212 	}
213 
214 	/**
215 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
216 	 * account.
217 	 */
218 	function OwnableOZ() public
219 	{
220 		m_owner      = msg.sender;
221 		m_changeable = true;
222 	}
223 
224 	/**
225 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
226 	 * @param _newOwner The address to transfer ownership to.
227 	 */
228 	function setImmutableOwnership(address _newOwner) public onlyOwner
229 	{
230 		require(m_changeable);
231 		require(_newOwner != address(0));
232 		emit OwnershipTransferred(m_owner, _newOwner);
233 		m_owner      = _newOwner;
234 		m_changeable = false;
235 	}
236 
237 }
238 
239 
240 pragma solidity ^0.4.8;
241 
242 contract RLC is ERC20, SafeMath, Ownable {
243 
244     /* Public variables of the token */
245   string public name;       //fancy name
246   string public symbol;
247   uint8 public decimals;    //How many decimals to show.
248   string public version = 'v0.1';
249   uint public initialSupply;
250   uint public totalSupply;
251   bool public locked;
252   //uint public unlockBlock;
253 
254   mapping(address => uint) balances;
255   mapping (address => mapping (address => uint)) allowed;
256 
257   // lock transfer during the ICO
258   modifier onlyUnlocked() {
259     if (msg.sender != owner && locked) throw;
260     _;
261   }
262 
263   /*
264    *  The RLC Token created with the time at which the crowdsale end
265    */
266 
267   function RLC() {
268     // lock the transfer function during the crowdsale
269     locked = true;
270     //unlockBlock=  now + 45 days; // (testnet) - for mainnet put the block number
271 
272     initialSupply = 87000000000000000;
273     totalSupply = initialSupply;
274     balances[msg.sender] = initialSupply;// Give the creator all initial tokens
275     name = 'iEx.ec Network Token';        // Set the name for display purposes
276     symbol = 'RLC';                       // Set the symbol for display purposes
277     decimals = 9;                        // Amount of decimals for display purposes
278   }
279 
280   function unlock() onlyOwner {
281     locked = false;
282   }
283 
284   function burn(uint256 _value) returns (bool){
285     balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
286     totalSupply = safeSub(totalSupply, _value);
287     Transfer(msg.sender, 0x0, _value);
288     return true;
289   }
290 
291   function transfer(address _to, uint _value) onlyUnlocked returns (bool) {
292     balances[msg.sender] = safeSub(balances[msg.sender], _value);
293     balances[_to] = safeAdd(balances[_to], _value);
294     Transfer(msg.sender, _to, _value);
295     return true;
296   }
297 
298   function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool) {
299     var _allowance = allowed[_from][msg.sender];
300 
301     balances[_to] = safeAdd(balances[_to], _value);
302     balances[_from] = safeSub(balances[_from], _value);
303     allowed[_from][msg.sender] = safeSub(_allowance, _value);
304     Transfer(_from, _to, _value);
305     return true;
306   }
307 
308   function balanceOf(address _owner) constant returns (uint balance) {
309     return balances[_owner];
310   }
311 
312   function approve(address _spender, uint _value) returns (bool) {
313     allowed[msg.sender][_spender] = _value;
314     Approval(msg.sender, _spender, _value);
315     return true;
316   }
317 
318     /* Approve and then comunicate the approved contract in a single tx */
319   function approveAndCall(address _spender, uint256 _value, bytes _extraData){
320       TokenSpender spender = TokenSpender(_spender);
321       if (approve(_spender, _value)) {
322           spender.receiveApproval(msg.sender, _value, this, _extraData);
323       }
324   }
325 
326   function allowance(address _owner, address _spender) constant returns (uint remaining) {
327     return allowed[_owner][_spender];
328   }
329 
330 }
331 
332 pragma solidity ^0.4.21;
333 
334 library IexecLib
335 {
336 	/***************************************************************************/
337 	/*                              Market Order                               */
338 	/***************************************************************************/
339 	enum MarketOrderDirectionEnum
340 	{
341 		UNSET,
342 		BID,
343 		ASK,
344 		CLOSED
345 	}
346 	struct MarketOrder
347 	{
348 		MarketOrderDirectionEnum direction;
349 		uint256 category;        // runtime selection
350 		uint256 trust;           // for PoCo
351 		uint256 value;           // value/cost/price
352 		uint256 volume;          // quantity of instances (total)
353 		uint256 remaining;       // remaining instances
354 		address workerpool;      // BID can use null for any
355 		address workerpoolOwner; // fix ownership if workerpool ownership change during the workorder steps
356 	}
357 
358 	/***************************************************************************/
359 	/*                               Work Order                                */
360 	/***************************************************************************/
361 	enum WorkOrderStatusEnum
362 	{
363 		UNSET,     // Work order not yet initialized (invalid address)
364 		ACTIVE,    // Marketed → constributions are open
365 		REVEALING, // Starting consensus reveal
366 		CLAIMED,   // failed consensus
367 		COMPLETED  // Concensus achieved
368 	}
369 
370 	/***************************************************************************/
371 	/*                                Consensus                                */
372 	/*                                   ---                                   */
373 	/*                         used in WorkerPool.sol                          */
374 	/***************************************************************************/
375 	struct Consensus
376 	{
377 		uint256 poolReward;
378 		uint256 stakeAmount;
379 		bytes32 consensus;
380 		uint256 revealDate;
381 		uint256 revealCounter;
382 		uint256 consensusTimeout;
383 		uint256 winnerCount;
384 		address[] contributors;
385 		address workerpoolOwner;
386 		uint256 schedulerRewardRatioPolicy;
387 
388 	}
389 
390 	/***************************************************************************/
391 	/*                              Contribution                               */
392 	/*                                   ---                                   */
393 	/*                         used in WorkerPool.sol                          */
394 	/***************************************************************************/
395 	enum ContributionStatusEnum
396 	{
397 		UNSET,
398 		AUTHORIZED,
399 		CONTRIBUTED,
400 		PROVED,
401 		REJECTED
402 	}
403 	struct Contribution
404 	{
405 		ContributionStatusEnum status;
406 		bytes32 resultHash;
407 		bytes32 resultSign;
408 		address enclaveChallenge;
409 		uint256 score;
410 		uint256 weight;
411 	}
412 
413 	/***************************************************************************/
414 	/*                Account / ContributionHistory / Category                 */
415 	/*                                   ---                                   */
416 	/*                          used in IexecHub.sol                           */
417 	/***************************************************************************/
418 	struct Account
419 	{
420 		uint256 stake;
421 		uint256 locked;
422 	}
423 
424 	struct ContributionHistory // for credibility computation, f = failed/total
425 	{
426 		uint256 success;
427 		uint256 failed;
428 	}
429 
430 	struct Category
431 	{
432 		uint256 catid;
433 		string  name;
434 		string  description;
435 		uint256 workClockTimeRef;
436 	}
437 
438 }
439 
440 
441 pragma solidity ^0.4.21;
442 
443 
444 contract IexecHubInterface
445 {
446 	RLC public rlc;
447 
448 	function attachContracts(
449 		address _tokenAddress,
450 		address _marketplaceAddress,
451 		address _workerPoolHubAddress,
452 		address _appHubAddress,
453 		address _datasetHubAddress)
454 		public;
455 
456 	function setCategoriesCreator(
457 		address _categoriesCreator)
458 	public;
459 
460 	function createCategory(
461 		string  _name,
462 		string  _description,
463 		uint256 _workClockTimeRef)
464 	public returns (uint256 catid);
465 
466 	function createWorkerPool(
467 		string  _description,
468 		uint256 _subscriptionLockStakePolicy,
469 		uint256 _subscriptionMinimumStakePolicy,
470 		uint256 _subscriptionMinimumScorePolicy)
471 	external returns (address createdWorkerPool);
472 
473 	function createApp(
474 		string  _appName,
475 		uint256 _appPrice,
476 		string  _appParams)
477 	external returns (address createdApp);
478 
479 	function createDataset(
480 		string  _datasetName,
481 		uint256 _datasetPrice,
482 		string  _datasetParams)
483 	external returns (address createdDataset);
484 
485 	function buyForWorkOrder(
486 		uint256 _marketorderIdx,
487 		address _workerpool,
488 		address _app,
489 		address _dataset,
490 		string  _params,
491 		address _callback,
492 		address _beneficiary)
493 	external returns (address);
494 
495 	function isWoidRegistred(
496 		address _woid)
497 	public view returns (bool);
498 
499 	function lockWorkOrderCost(
500 		address _requester,
501 		address _workerpool, // Address of a smartcontract
502 		address _app,        // Address of a smartcontract
503 		address _dataset)    // Address of a smartcontract
504 	internal returns (uint256);
505 
506 	function claimFailedConsensus(
507 		address _woid)
508 	public returns (bool);
509 
510 	function finalizeWorkOrder(
511 		address _woid,
512 		string  _stdout,
513 		string  _stderr,
514 		string  _uri)
515 	public returns (bool);
516 
517 	function getCategoryWorkClockTimeRef(
518 		uint256 _catId)
519 	public view returns (uint256 workClockTimeRef);
520 
521 	function existingCategory(
522 		uint256 _catId)
523 	public view  returns (bool categoryExist);
524 
525 	function getCategory(
526 		uint256 _catId)
527 		public view returns (uint256 catid, string name, string  description, uint256 workClockTimeRef);
528 
529 	function getWorkerStatus(
530 		address _worker)
531 	public view returns (address workerPool, uint256 workerScore);
532 
533 	function getWorkerScore(address _worker) public view returns (uint256 workerScore);
534 
535 	function registerToPool(address _worker) public returns (bool subscribed);
536 
537 	function unregisterFromPool(address _worker) public returns (bool unsubscribed);
538 
539 	function evictWorker(address _worker) public returns (bool unsubscribed);
540 
541 	function removeWorker(address _workerpool, address _worker) internal returns (bool unsubscribed);
542 
543 	function lockForOrder(address _user, uint256 _amount) public returns (bool);
544 
545 	function unlockForOrder(address _user, uint256 _amount) public returns (bool);
546 
547 	function lockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
548 
549 	function unlockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
550 
551 	function rewardForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
552 
553 	function seizeForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
554 
555 	function deposit(uint256 _amount) external returns (bool);
556 
557 	function withdraw(uint256 _amount) external returns (bool);
558 
559 	function checkBalance(address _owner) public view returns (uint256 stake, uint256 locked);
560 
561 	function reward(address _user, uint256 _amount) internal returns (bool);
562 
563 	function seize(address _user, uint256 _amount) internal returns (bool);
564 
565 	function lock(address _user, uint256 _amount) internal returns (bool);
566 
567 	function unlock(address _user, uint256 _amount) internal returns (bool);
568 }
569 
570 
571 pragma solidity ^0.4.21;
572 
573 
574 contract IexecHubAccessor
575 {
576 	IexecHubInterface internal iexecHubInterface;
577 
578 	modifier onlyIexecHub()
579 	{
580 		require(msg.sender == address(iexecHubInterface));
581 		_;
582 	}
583 
584 	function IexecHubAccessor(address _iexecHubAddress) public
585 	{
586 		require(_iexecHubAddress != address(0));
587 		iexecHubInterface = IexecHubInterface(_iexecHubAddress);
588 	}
589 
590 }
591 
592 pragma solidity ^0.4.21;
593 contract MarketplaceInterface
594 {
595 	function createMarketOrder(
596 		IexecLib.MarketOrderDirectionEnum _direction,
597 		uint256 _category,
598 		uint256 _trust,
599 		uint256 _value,
600 		address _workerpool,
601 		uint256 _volume)
602 	public returns (uint);
603 
604 	function closeMarketOrder(
605 		uint256 _marketorderIdx)
606 	public returns (bool);
607 
608 	function getMarketOrderValue(
609 		uint256 _marketorderIdx)
610 	public view returns(uint256);
611 
612 	function getMarketOrderWorkerpoolOwner(
613 		uint256 _marketorderIdx)
614 	public view returns(address);
615 
616 	function getMarketOrderCategory(
617 		uint256 _marketorderIdx)
618 	public view returns (uint256);
619 
620 	function getMarketOrderTrust(
621 		uint256 _marketorderIdx)
622 	public view returns(uint256);
623 
624 	function getMarketOrder(
625 		uint256 _marketorderIdx)
626 	public view returns(
627 		IexecLib.MarketOrderDirectionEnum direction,
628 		uint256 category,       // runtime selection
629 		uint256 trust,          // for PoCo
630 		uint256 value,          // value/cost/price
631 		uint256 volume,         // quantity of instances (total)
632 		uint256 remaining,      // remaining instances
633 		address workerpool);    // BID can use null for any
634 }
635 
636 
637 
638 
639 pragma solidity ^0.4.21;
640 
641 
642 contract MarketplaceAccessor
643 {
644 	address              internal marketplaceAddress;
645 	MarketplaceInterface internal marketplaceInterface;
646 /* not used
647 	modifier onlyMarketplace()
648 	{
649 		require(msg.sender == marketplaceAddress);
650 		_;
651 	}*/
652 
653 	function MarketplaceAccessor(address _marketplaceAddress) public
654 	{
655 		require(_marketplaceAddress != address(0));
656 		marketplaceAddress   = _marketplaceAddress;
657 		marketplaceInterface = MarketplaceInterface(_marketplaceAddress);
658 	}
659 }
660 
661 
662 pragma solidity ^0.4.21;
663 
664 contract WorkOrder
665 {
666 
667 
668 	event WorkOrderActivated();
669 	event WorkOrderReActivated();
670 	event WorkOrderRevealing();
671 	event WorkOrderClaimed  ();
672 	event WorkOrderCompleted();
673 
674 	/**
675 	 * Members
676 	 */
677 	IexecLib.WorkOrderStatusEnum public m_status;
678 
679 	uint256 public m_marketorderIdx;
680 
681 	address public m_app;
682 	address public m_dataset;
683 	address public m_workerpool;
684 	address public m_requester;
685 
686 	uint256 public m_emitcost;
687 	string  public m_params;
688 	address public m_callback;
689 	address public m_beneficiary;
690 
691 	bytes32 public m_resultCallbackProof;
692 	string  public m_stdout;
693 	string  public m_stderr;
694 	string  public m_uri;
695 
696 	address public m_iexecHubAddress;
697 
698 	modifier onlyIexecHub()
699 	{
700 		require(msg.sender == m_iexecHubAddress);
701 		_;
702 	}
703 
704 	/**
705 	 * Constructor
706 	 */
707 	function WorkOrder(
708 		uint256 _marketorderIdx,
709 		address _requester,
710 		address _app,
711 		address _dataset,
712 		address _workerpool,
713 		uint256 _emitcost,
714 		string  _params,
715 		address _callback,
716 		address _beneficiary)
717 	public
718 	{
719 		m_iexecHubAddress = msg.sender;
720 		require(_requester != address(0));
721 		m_status         = IexecLib.WorkOrderStatusEnum.ACTIVE;
722 		m_marketorderIdx = _marketorderIdx;
723 		m_app            = _app;
724 		m_dataset        = _dataset;
725 		m_workerpool     = _workerpool;
726 		m_requester      = _requester;
727 		m_emitcost       = _emitcost;
728 		m_params         = _params;
729 		m_callback       = _callback;
730 		m_beneficiary    = _beneficiary;
731 		// needed for the scheduler to authorize api token access on this m_beneficiary address in case _requester is a smart contract.
732 	}
733 
734 	function startRevealingPhase() public returns (bool)
735 	{
736 		require(m_workerpool == msg.sender);
737 		require(m_status == IexecLib.WorkOrderStatusEnum.ACTIVE);
738 		m_status = IexecLib.WorkOrderStatusEnum.REVEALING;
739 		emit WorkOrderRevealing();
740 		return true;
741 	}
742 
743 	function reActivate() public returns (bool)
744 	{
745 		require(m_workerpool == msg.sender);
746 		require(m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
747 		m_status = IexecLib.WorkOrderStatusEnum.ACTIVE;
748 		emit WorkOrderReActivated();
749 		return true;
750 	}
751 
752 
753 	function claim() public onlyIexecHub
754 	{
755 		require(m_status == IexecLib.WorkOrderStatusEnum.ACTIVE || m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
756 		m_status = IexecLib.WorkOrderStatusEnum.CLAIMED;
757 		emit WorkOrderClaimed();
758 	}
759 
760 
761 	function setResult(string _stdout, string _stderr, string _uri) public onlyIexecHub
762 	{
763 		require(m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
764 		m_status = IexecLib.WorkOrderStatusEnum.COMPLETED;
765 		m_stdout = _stdout;
766 		m_stderr = _stderr;
767 		m_uri    = _uri;
768 		m_resultCallbackProof =keccak256(_stdout,_stderr,_uri);
769 		emit WorkOrderCompleted();
770 	}
771 
772 }
773 
774 pragma solidity ^0.4.21;
775 
776 contract IexecCallbackInterface
777 {
778 
779 	function workOrderCallback(
780 		address _woid,
781 		string  _stdout,
782 		string  _stderr,
783 		string  _uri) public returns (bool);
784 
785 	event WorkOrderCallback(address woid, string stdout, string stderr, string uri);
786 }
787 
788 
789 pragma solidity ^0.4.21;
790 
791 contract Marketplace is IexecHubAccessor
792 {
793 	using SafeMathOZ for uint256;
794 
795 	/**
796 	 * Marketplace
797 	 */
798 	uint                                 public m_orderCount;
799 	mapping(uint =>IexecLib.MarketOrder) public m_orderBook;
800 
801 	uint256 public constant ASK_STAKE_RATIO  = 30;
802 
803 	/**
804 	 * Events
805 	 */
806 	event MarketOrderCreated   (uint marketorderIdx);
807 	event MarketOrderClosed    (uint marketorderIdx);
808 	event MarketOrderAskConsume(uint marketorderIdx, address requester);
809 
810 	/**
811 	 * Constructor
812 	 */
813 	function Marketplace(address _iexecHubAddress)
814 	IexecHubAccessor(_iexecHubAddress)
815 	public
816 	{
817 	}
818 
819 	/**
820 	 * Market orders
821 	 */
822 	function createMarketOrder(
823 		IexecLib.MarketOrderDirectionEnum _direction,
824 		uint256 _category,
825 		uint256 _trust,
826 		uint256 _value,
827 		address _workerpool,
828 		uint256 _volume)
829 	public returns (uint)
830 	{
831 		require(iexecHubInterface.existingCategory(_category));
832 		require(_volume >0);
833 		m_orderCount = m_orderCount.add(1);
834 		IexecLib.MarketOrder storage marketorder    = m_orderBook[m_orderCount];
835 		marketorder.direction      = _direction;
836 		marketorder.category       = _category;
837 		marketorder.trust          = _trust;
838 		marketorder.value          = _value;
839 		marketorder.volume         = _volume;
840 		marketorder.remaining      = _volume;
841 
842 		if (_direction == IexecLib.MarketOrderDirectionEnum.ASK)
843 		{
844 			require(WorkerPool(_workerpool).m_owner() == msg.sender);
845 
846 			require(iexecHubInterface.lockForOrder(msg.sender, _value.percentage(ASK_STAKE_RATIO).mul(_volume))); // mul must be done after percentage to avoid rounding errors
847 			marketorder.workerpool      = _workerpool;
848 			marketorder.workerpoolOwner = msg.sender;
849 		}
850 		else
851 		{
852 			// no BID implementation
853 			revert();
854 		}
855 		emit MarketOrderCreated(m_orderCount);
856 		return m_orderCount;
857 	}
858 
859 	function closeMarketOrder(uint256 _marketorderIdx) public returns (bool)
860 	{
861 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
862 		if (marketorder.direction == IexecLib.MarketOrderDirectionEnum.ASK)
863 		{
864 			require(marketorder.workerpoolOwner == msg.sender);
865 			require(iexecHubInterface.unlockForOrder(marketorder.workerpoolOwner, marketorder.value.percentage(ASK_STAKE_RATIO).mul(marketorder.remaining))); // mul must be done after percentage to avoid rounding errors
866 		}
867 		else
868 		{
869 			// no BID implementation
870 			revert();
871 		}
872 		marketorder.direction = IexecLib.MarketOrderDirectionEnum.CLOSED;
873 		emit MarketOrderClosed(_marketorderIdx);
874 		return true;
875 	}
876 
877 
878 	/**
879 	 * Assets consumption
880 	 */
881 	function consumeMarketOrderAsk(
882 		uint256 _marketorderIdx,
883 		address _requester,
884 		address _workerpool)
885 	public onlyIexecHub returns (bool)
886 	{
887 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
888 		require(marketorder.direction  == IexecLib.MarketOrderDirectionEnum.ASK);
889 		require(marketorder.remaining  >  0);
890 		require(marketorder.workerpool == _workerpool);
891 
892 		marketorder.remaining = marketorder.remaining.sub(1);
893 		if (marketorder.remaining == 0)
894 		{
895 			marketorder.direction = IexecLib.MarketOrderDirectionEnum.CLOSED;
896 		}
897 		require(iexecHubInterface.lockForOrder(_requester, marketorder.value));
898 		emit MarketOrderAskConsume(_marketorderIdx, _requester);
899 		return true;
900 	}
901 
902 	function existingMarketOrder(uint256 _marketorderIdx) public view  returns (bool marketOrderExist)
903 	{
904 		return m_orderBook[_marketorderIdx].category > 0;
905 	}
906 
907 	/**
908 	 * Views
909 	 */
910 	function getMarketOrderValue(uint256 _marketorderIdx) public view returns (uint256)
911 	{
912 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
913 		return m_orderBook[_marketorderIdx].value;
914 	}
915 	function getMarketOrderWorkerpoolOwner(uint256 _marketorderIdx) public view returns (address)
916 	{
917 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
918 		return m_orderBook[_marketorderIdx].workerpoolOwner;
919 	}
920 	function getMarketOrderCategory(uint256 _marketorderIdx) public view returns (uint256)
921 	{
922 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
923 		return m_orderBook[_marketorderIdx].category;
924 	}
925 	function getMarketOrderTrust(uint256 _marketorderIdx) public view returns (uint256)
926 	{
927 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
928 		return m_orderBook[_marketorderIdx].trust;
929 	}
930 	function getMarketOrder(uint256 _marketorderIdx) public view returns
931 	(
932 		IexecLib.MarketOrderDirectionEnum direction,
933 		uint256 category,       // runtime selection
934 		uint256 trust,          // for PoCo
935 		uint256 value,          // value/cost/price
936 		uint256 volume,         // quantity of instances (total)
937 		uint256 remaining,      // remaining instances
938 		address workerpool,     // BID can use null for any
939 		address workerpoolOwner)
940 	{
941 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
942 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
943 		return (
944 			marketorder.direction,
945 			marketorder.category,
946 			marketorder.trust,
947 			marketorder.value,
948 			marketorder.volume,
949 			marketorder.remaining,
950 			marketorder.workerpool,
951 			marketorder.workerpoolOwner
952 		);
953 	}
954 
955 	/**
956 	 * Callback Proof managment
957 	 */
958 
959 	event WorkOrderCallbackProof(address indexed woid, address requester, address beneficiary,address indexed callbackTo, address indexed gasCallbackProvider,string stdout, string stderr , string uri);
960 
961 	//mapping(workorder => bool)
962 	 mapping(address => bool) m_callbackDone;
963 
964 	 function isCallbackDone(address _woid) public view  returns (bool callbackDone)
965 	 {
966 		 return m_callbackDone[_woid];
967 	 }
968 
969 	 function workOrderCallback(address _woid,string _stdout, string _stderr, string _uri) public
970 	 {
971 		 require(iexecHubInterface.isWoidRegistred(_woid));
972 		 require(!isCallbackDone(_woid));
973 		 m_callbackDone[_woid] = true;
974 		 require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.COMPLETED);
975 		 require(WorkOrder(_woid).m_resultCallbackProof() == keccak256(_stdout,_stderr,_uri));
976 		 address callbackTo =WorkOrder(_woid).m_callback();
977 		 require(callbackTo != address(0));
978 		 require(IexecCallbackInterface(callbackTo).workOrderCallback(
979 			 _woid,
980 			 _stdout,
981 			 _stderr,
982 			 _uri
983 		 ));
984 		 emit WorkOrderCallbackProof(_woid,WorkOrder(_woid).m_requester(),WorkOrder(_woid).m_beneficiary(),callbackTo,tx.origin,_stdout,_stderr,_uri);
985 	 }
986 
987 }
988 
989 
990 
991 pragma solidity ^0.4.21;
992 
993 
994 contract App is OwnableOZ, IexecHubAccessor
995 {
996 
997 	/**
998 	 * Members
999 	 */
1000 	string        public m_appName;
1001 	uint256       public m_appPrice;
1002 	string        public m_appParams;
1003 
1004 	/**
1005 	 * Constructor
1006 	 */
1007 	function App(
1008 		address _iexecHubAddress,
1009 		string  _appName,
1010 		uint256 _appPrice,
1011 		string  _appParams)
1012 	IexecHubAccessor(_iexecHubAddress)
1013 	public
1014 	{
1015 		// tx.origin == owner
1016 		// msg.sender == DatasetHub
1017 		require(tx.origin != msg.sender);
1018 		setImmutableOwnership(tx.origin); // owner → tx.origin
1019 
1020 		m_appName   = _appName;
1021 		m_appPrice  = _appPrice;
1022 		m_appParams = _appParams;
1023 
1024 	}
1025 
1026 
1027 
1028 }
1029 
1030 pragma solidity ^0.4.21;
1031 
1032 
1033 
1034 contract AppHub is OwnableOZ // is Owned by IexecHub
1035 {
1036 
1037 	using SafeMathOZ for uint256;
1038 
1039 	/**
1040 	 * Members
1041 	 */
1042 	mapping(address => uint256)                     m_appCountByOwner;
1043 	mapping(address => mapping(uint256 => address)) m_appByOwnerByIndex;
1044 	mapping(address => bool)                        m_appRegistered;
1045 
1046 	mapping(uint256 => address)                     m_appByIndex;
1047 	uint256 public                                  m_totalAppCount;
1048 
1049 	/**
1050 	 * Constructor
1051 	 */
1052 	function AppHub() public
1053 	{
1054 	}
1055 
1056 	/**
1057 	 * Methods
1058 	 */
1059 	function isAppRegistered(address _app) public view returns (bool)
1060 	{
1061 		return m_appRegistered[_app];
1062 	}
1063 	function getAppsCount(address _owner) public view returns (uint256)
1064 	{
1065 		return m_appCountByOwner[_owner];
1066 	}
1067 	function getApp(address _owner, uint256 _index) public view returns (address)
1068 	{
1069 		return m_appByOwnerByIndex[_owner][_index];
1070 	}
1071 	function getAppByIndex(uint256 _index) public view returns (address)
1072 	{
1073 		return m_appByIndex[_index];
1074 	}
1075 
1076 	function addApp(address _owner, address _app) internal
1077 	{
1078 		uint id = m_appCountByOwner[_owner].add(1);
1079 		m_totalAppCount=m_totalAppCount.add(1);
1080 		m_appByIndex       [m_totalAppCount] = _app;
1081 		m_appCountByOwner  [_owner]          = id;
1082 		m_appByOwnerByIndex[_owner][id]      = _app;
1083 		m_appRegistered    [_app]            = true;
1084 	}
1085 
1086 	function createApp(
1087 		string  _appName,
1088 		uint256 _appPrice,
1089 		string  _appParams)
1090 	public onlyOwner /*owner == IexecHub*/ returns (address createdApp)
1091 	{
1092 		// tx.origin == owner
1093 		// msg.sender == IexecHub
1094 		address newApp = new App(
1095 			msg.sender,
1096 			_appName,
1097 			_appPrice,
1098 			_appParams
1099 		);
1100 		addApp(tx.origin, newApp);
1101 		return newApp;
1102 	}
1103 
1104 }
1105 
1106 
1107 pragma solidity ^0.4.21;
1108 
1109 contract Dataset is OwnableOZ, IexecHubAccessor
1110 {
1111 
1112 	/**
1113 	 * Members
1114 	 */
1115 	string            public m_datasetName;
1116 	uint256           public m_datasetPrice;
1117 	string            public m_datasetParams;
1118 
1119 	/**
1120 	 * Constructor
1121 	 */
1122 	function Dataset(
1123 		address _iexecHubAddress,
1124 		string  _datasetName,
1125 		uint256 _datasetPrice,
1126 		string  _datasetParams)
1127 	IexecHubAccessor(_iexecHubAddress)
1128 	public
1129 	{
1130 		// tx.origin == owner
1131 		// msg.sender == DatasetHub
1132 		require(tx.origin != msg.sender);
1133 		setImmutableOwnership(tx.origin); // owner → tx.origin
1134 
1135 		m_datasetName   = _datasetName;
1136 		m_datasetPrice  = _datasetPrice;
1137 		m_datasetParams = _datasetParams;
1138 
1139 	}
1140 
1141 
1142 }
1143 
1144 
1145 pragma solidity ^0.4.21;
1146 
1147 
1148 contract DatasetHub is OwnableOZ // is Owned by IexecHub
1149 {
1150 	using SafeMathOZ for uint256;
1151 
1152 	/**
1153 	 * Members
1154 	 */
1155 	mapping(address => uint256)                     m_datasetCountByOwner;
1156 	mapping(address => mapping(uint256 => address)) m_datasetByOwnerByIndex;
1157 	mapping(address => bool)                        m_datasetRegistered;
1158 
1159 	mapping(uint256 => address)                     m_datasetByIndex;
1160 	uint256 public                                  m_totalDatasetCount;
1161 
1162 
1163 
1164 	/**
1165 	 * Constructor
1166 	 */
1167 	function DatasetHub() public
1168 	{
1169 	}
1170 
1171 	/**
1172 	 * Methods
1173 	 */
1174 	function isDatasetRegistred(address _dataset) public view returns (bool)
1175 	{
1176 		return m_datasetRegistered[_dataset];
1177 	}
1178 	function getDatasetsCount(address _owner) public view returns (uint256)
1179 	{
1180 		return m_datasetCountByOwner[_owner];
1181 	}
1182 	function getDataset(address _owner, uint256 _index) public view returns (address)
1183 	{
1184 		return m_datasetByOwnerByIndex[_owner][_index];
1185 	}
1186 	function getDatasetByIndex(uint256 _index) public view returns (address)
1187 	{
1188 		return m_datasetByIndex[_index];
1189 	}
1190 
1191 	function addDataset(address _owner, address _dataset) internal
1192 	{
1193 		uint id = m_datasetCountByOwner[_owner].add(1);
1194 		m_totalDatasetCount = m_totalDatasetCount.add(1);
1195 		m_datasetByIndex       [m_totalDatasetCount] = _dataset;
1196 		m_datasetCountByOwner  [_owner]              = id;
1197 		m_datasetByOwnerByIndex[_owner][id]          = _dataset;
1198 		m_datasetRegistered    [_dataset]            = true;
1199 	}
1200 
1201 	function createDataset(
1202 		string _datasetName,
1203 		uint256 _datasetPrice,
1204 		string _datasetParams)
1205 	public onlyOwner /*owner == IexecHub*/ returns (address createdDataset)
1206 	{
1207 		// tx.origin == owner
1208 		// msg.sender == IexecHub
1209 		address newDataset = new Dataset(
1210 			msg.sender,
1211 			_datasetName,
1212 			_datasetPrice,
1213 			_datasetParams
1214 		);
1215 		addDataset(tx.origin, newDataset);
1216 		return newDataset;
1217 	}
1218 }
1219 
1220 
1221 pragma solidity ^0.4.21;
1222 
1223 
1224 
1225 /**
1226  * @title IexecHub
1227  */
1228 
1229 contract IexecHub
1230 {
1231 	using SafeMathOZ for uint256;
1232 
1233 	/**
1234 	* RLC contract for token transfers.
1235 	*/
1236 	RLC public rlc;
1237 
1238 	uint256 public constant STAKE_BONUS_RATIO         = 10;
1239 	uint256 public constant STAKE_BONUS_MIN_THRESHOLD = 1000;
1240 	uint256 public constant SCORE_UNITARY_SLASH       = 50;
1241 
1242 	/**
1243 	 * Slaves contracts
1244 	 */
1245 	AppHub        public appHub;
1246 	DatasetHub    public datasetHub;
1247 	WorkerPoolHub public workerPoolHub;
1248 
1249 	/**
1250 	 * Market place
1251 	 */
1252 	Marketplace public marketplace;
1253 	modifier onlyMarketplace()
1254 	{
1255 		require(msg.sender == address(marketplace));
1256 		_;
1257 	}
1258 	/**
1259 	 * Categories
1260 	 */
1261 	mapping(uint256 => IexecLib.Category) public m_categories;
1262 	uint256                               public m_categoriesCount;
1263 	address                               public m_categoriesCreator;
1264 	modifier onlyCategoriesCreator()
1265 	{
1266 		require(msg.sender == m_categoriesCreator);
1267 		_;
1268 	}
1269 
1270 	/**
1271 	 * Escrow
1272 	 */
1273 	mapping(address => IexecLib.Account) public m_accounts;
1274 
1275 
1276 	/**
1277 	 * workOrder Registered
1278 	 */
1279 	mapping(address => bool) public m_woidRegistered;
1280 	modifier onlyRegisteredWoid(address _woid)
1281 	{
1282 		require(m_woidRegistered[_woid]);
1283 		_;
1284 	}
1285 
1286 	/**
1287 	 * Reputation for PoCo
1288 	 */
1289 	mapping(address => uint256)  public m_scores;
1290 	IexecLib.ContributionHistory public m_contributionHistory;
1291 
1292 
1293 	event WorkOrderActivated(address woid, address indexed workerPool);
1294 	event WorkOrderClaimed  (address woid, address workerPool);
1295 	event WorkOrderCompleted(address woid, address workerPool);
1296 
1297 	event CreateApp       (address indexed appOwner,        address indexed app,        string appName,     uint256 appPrice,     string appParams    );
1298 	event CreateDataset   (address indexed datasetOwner,    address indexed dataset,    string datasetName, uint256 datasetPrice, string datasetParams);
1299 	event CreateWorkerPool(address indexed workerPoolOwner, address indexed workerPool, string workerPoolDescription                                        );
1300 
1301 	event CreateCategory  (uint256 catid, string name, string description, uint256 workClockTimeRef);
1302 
1303 	event WorkerPoolSubscription  (address indexed workerPool, address worker);
1304 	event WorkerPoolUnsubscription(address indexed workerPool, address worker);
1305 	event WorkerPoolEviction      (address indexed workerPool, address worker);
1306 
1307 	event AccurateContribution(address woid, address indexed worker);
1308 	event FaultyContribution  (address woid, address indexed worker);
1309 
1310 	event Deposit (address owner, uint256 amount);
1311 	event Withdraw(address owner, uint256 amount);
1312 	event Reward  (address user,  uint256 amount);
1313 	event Seize   (address user,  uint256 amount);
1314 
1315 	/**
1316 	 * Constructor
1317 	 */
1318 	function IexecHub()
1319 	public
1320 	{
1321 		m_categoriesCreator = msg.sender;
1322 	}
1323 
1324 	function attachContracts(
1325 		address _tokenAddress,
1326 		address _marketplaceAddress,
1327 		address _workerPoolHubAddress,
1328 		address _appHubAddress,
1329 		address _datasetHubAddress)
1330 	public onlyCategoriesCreator
1331 	{
1332 		require(address(rlc) == address(0));
1333 		rlc                = RLC          (_tokenAddress        );
1334 		marketplace        = Marketplace  (_marketplaceAddress  );
1335 		workerPoolHub      = WorkerPoolHub(_workerPoolHubAddress);
1336 		appHub             = AppHub       (_appHubAddress       );
1337 		datasetHub         = DatasetHub   (_datasetHubAddress   );
1338 
1339 	}
1340 
1341 	function setCategoriesCreator(address _categoriesCreator)
1342 	public onlyCategoriesCreator
1343 	{
1344 		m_categoriesCreator = _categoriesCreator;
1345 	}
1346 	/**
1347 	 * Factory
1348 	 */
1349 
1350 	function createCategory(
1351 		string  _name,
1352 		string  _description,
1353 		uint256 _workClockTimeRef)
1354 	public onlyCategoriesCreator returns (uint256 catid)
1355 	{
1356 		m_categoriesCount                  = m_categoriesCount.add(1);
1357 		IexecLib.Category storage category = m_categories[m_categoriesCount];
1358 		category.catid                     = m_categoriesCount;
1359 		category.name                      = _name;
1360 		category.description               = _description;
1361 		category.workClockTimeRef          = _workClockTimeRef;
1362 		emit CreateCategory(m_categoriesCount, _name, _description, _workClockTimeRef);
1363 		return m_categoriesCount;
1364 	}
1365 
1366 	function createWorkerPool(
1367 		string  _description,
1368 		uint256 _subscriptionLockStakePolicy,
1369 		uint256 _subscriptionMinimumStakePolicy,
1370 		uint256 _subscriptionMinimumScorePolicy)
1371 	external returns (address createdWorkerPool)
1372 	{
1373 		address newWorkerPool = workerPoolHub.createWorkerPool(
1374 			_description,
1375 			_subscriptionLockStakePolicy,
1376 			_subscriptionMinimumStakePolicy,
1377 			_subscriptionMinimumScorePolicy,
1378 			address(marketplace)
1379 		);
1380 		emit CreateWorkerPool(tx.origin, newWorkerPool, _description);
1381 		return newWorkerPool;
1382 	}
1383 
1384 	function createApp(
1385 		string  _appName,
1386 		uint256 _appPrice,
1387 		string  _appParams)
1388 	external returns (address createdApp)
1389 	{
1390 		address newApp = appHub.createApp(
1391 			_appName,
1392 			_appPrice,
1393 			_appParams
1394 		);
1395 		emit CreateApp(tx.origin, newApp, _appName, _appPrice, _appParams);
1396 		return newApp;
1397 	}
1398 
1399 	function createDataset(
1400 		string  _datasetName,
1401 		uint256 _datasetPrice,
1402 		string  _datasetParams)
1403 	external returns (address createdDataset)
1404 	{
1405 		address newDataset = datasetHub.createDataset(
1406 			_datasetName,
1407 			_datasetPrice,
1408 			_datasetParams
1409 			);
1410 		emit CreateDataset(tx.origin, newDataset, _datasetName, _datasetPrice, _datasetParams);
1411 		return newDataset;
1412 	}
1413 
1414 	/**
1415 	 * WorkOrder Emission
1416 	 */
1417 	function buyForWorkOrder(
1418 		uint256 _marketorderIdx,
1419 		address _workerpool,
1420 		address _app,
1421 		address _dataset,
1422 		string  _params,
1423 		address _callback,
1424 		address _beneficiary)
1425 	external returns (address)
1426 	{
1427 		address requester = msg.sender;
1428 		require(marketplace.consumeMarketOrderAsk(_marketorderIdx, requester, _workerpool));
1429 
1430 		uint256 emitcost = lockWorkOrderCost(requester, _workerpool, _app, _dataset);
1431 
1432 		WorkOrder workorder = new WorkOrder(
1433 			_marketorderIdx,
1434 			requester,
1435 			_app,
1436 			_dataset,
1437 			_workerpool,
1438 			emitcost,
1439 			_params,
1440 			_callback,
1441 			_beneficiary
1442 		);
1443 
1444 		m_woidRegistered[workorder] = true;
1445 
1446 		require(WorkerPool(_workerpool).emitWorkOrder(workorder, _marketorderIdx));
1447 
1448 		emit WorkOrderActivated(workorder, _workerpool);
1449 		return workorder;
1450 	}
1451 
1452 	function isWoidRegistred(address _woid) public view returns (bool)
1453 	{
1454 		return m_woidRegistered[_woid];
1455 	}
1456 
1457 	function lockWorkOrderCost(
1458 		address _requester,
1459 		address _workerpool, // Address of a smartcontract
1460 		address _app,        // Address of a smartcontract
1461 		address _dataset)    // Address of a smartcontract
1462 	internal returns (uint256)
1463 	{
1464 		// APP
1465 		App app = App(_app);
1466 		require(appHub.isAppRegistered (_app));
1467 		// initialize usercost with dapp price
1468 		uint256 emitcost = app.m_appPrice();
1469 
1470 		// DATASET
1471 		if (_dataset != address(0)) // address(0) → no dataset
1472 		{
1473 			Dataset dataset = Dataset(_dataset);
1474 			require(datasetHub.isDatasetRegistred(_dataset));
1475 			// add optional datasetPrice for userCost
1476 			emitcost = emitcost.add(dataset.m_datasetPrice());
1477 		}
1478 
1479 		// WORKERPOOL
1480 		require(workerPoolHub.isWorkerPoolRegistered(_workerpool));
1481 
1482 		require(lock(_requester, emitcost)); // Lock funds for app + dataset payment
1483 
1484 		return emitcost;
1485 	}
1486 
1487 	/**
1488 	 * WorkOrder life cycle
1489 	 */
1490 
1491 	function claimFailedConsensus(address _woid)
1492 	public onlyRegisteredWoid(_woid) returns (bool)
1493 	{
1494 		WorkOrder  workorder  = WorkOrder(_woid);
1495 		require(workorder.m_requester() == msg.sender);
1496 		WorkerPool workerpool = WorkerPool(workorder.m_workerpool());
1497 
1498 		IexecLib.WorkOrderStatusEnum currentStatus = workorder.m_status();
1499 		require(currentStatus == IexecLib.WorkOrderStatusEnum.ACTIVE || currentStatus == IexecLib.WorkOrderStatusEnum.REVEALING);
1500 		// Unlock stakes for all workers
1501 		require(workerpool.claimFailedConsensus(_woid));
1502 		workorder.claim(); // revert on error
1503 
1504 		/* uint256 value           = marketplace.getMarketOrderValue(workorder.m_marketorderIdx()); // revert if not exist */
1505 		/* address workerpoolOwner = marketplace.getMarketOrderWorkerpoolOwner(workorder.m_marketorderIdx()); // revert if not exist */
1506 		uint256 value;
1507 		address workerpoolOwner;
1508 		(,,,value,,,,workerpoolOwner) = marketplace.getMarketOrder(workorder.m_marketorderIdx()); // Single call cost less gas
1509 		uint256 workerpoolStake = value.percentage(marketplace.ASK_STAKE_RATIO());
1510 
1511 		require(unlock (workorder.m_requester(), value.add(workorder.m_emitcost()))); // UNLOCK THE FUNDS FOR REINBURSEMENT
1512 		require(seize  (workerpoolOwner,         workerpoolStake));
1513 		// put workerpoolOwner stake seize into iexecHub address for bonus for scheduler on next well finalized Task
1514 		require(reward (this,                    workerpoolStake));
1515 		require(lock   (this,                    workerpoolStake));
1516 
1517 		emit WorkOrderClaimed(_woid, workorder.m_workerpool());
1518 		return true;
1519 	}
1520 
1521 	function finalizeWorkOrder(
1522 		address _woid,
1523 		string  _stdout,
1524 		string  _stderr,
1525 		string  _uri)
1526 	public onlyRegisteredWoid(_woid) returns (bool)
1527 	{
1528 		WorkOrder workorder = WorkOrder(_woid);
1529 		require(workorder.m_workerpool() == msg.sender);
1530 		require(workorder.m_status()     == IexecLib.WorkOrderStatusEnum.REVEALING);
1531 
1532 		// APP
1533 		App     app      = App(workorder.m_app());
1534 		uint256 appPrice = app.m_appPrice();
1535 		if (appPrice > 0)
1536 		{
1537 			require(reward(app.m_owner(), appPrice));
1538 		}
1539 
1540 		// DATASET
1541 		Dataset dataset = Dataset(workorder.m_dataset());
1542 		if (dataset != address(0))
1543 		{
1544 			uint256 datasetPrice = dataset.m_datasetPrice();
1545 			if (datasetPrice > 0)
1546 			{
1547 				require(reward(dataset.m_owner(), datasetPrice));
1548 			}
1549 		}
1550 
1551 		// WORKERPOOL → rewarding done by the caller itself
1552 
1553 		/**
1554 		 * seize stacked funds from requester.
1555 		 * reward = value: was locked at market making
1556 		 * emitcost: was locked at when emiting the workorder
1557 		 */
1558 		/* uint256 value           = marketplace.getMarketOrderValue(workorder.m_marketorderIdx()); // revert if not exist */
1559 		/* address workerpoolOwner = marketplace.getMarketOrderWorkerpoolOwner(workorder.m_marketorderIdx()); // revert if not exist */
1560 		uint256 value;
1561 		address workerpoolOwner;
1562 		(,,,value,,,,workerpoolOwner) = marketplace.getMarketOrder(workorder.m_marketorderIdx()); // Single call cost less gas
1563 		uint256 workerpoolStake       = value.percentage(marketplace.ASK_STAKE_RATIO());
1564 
1565 		require(seize (workorder.m_requester(), value.add(workorder.m_emitcost()))); // seize funds for payment (market value + emitcost)
1566 		require(unlock(workerpoolOwner,         workerpoolStake)); // unlock scheduler stake
1567 
1568 		// write results
1569 		workorder.setResult(_stdout, _stderr, _uri); // revert on error
1570 
1571 		// Rien ne se perd, rien ne se crée, tout se transfere
1572 		// distribute bonus to scheduler. jackpot bonus come from scheduler stake loose on IexecHub contract
1573 		// we reuse the varaible value for the kitty / fraction of the kitty (stack too deep)
1574 		/* (,value) = checkBalance(this); // kitty is locked on `this` wallet */
1575 		value = m_accounts[this].locked; // kitty is locked on `this` wallet
1576 		if(value > 0)
1577 		{
1578 			value = value.min(value.percentage(STAKE_BONUS_RATIO).max(STAKE_BONUS_MIN_THRESHOLD));
1579 			require(seize(this,             value));
1580 			require(reward(workerpoolOwner, value));
1581 		}
1582 
1583 		emit WorkOrderCompleted(_woid, workorder.m_workerpool());
1584 		return true;
1585 	}
1586 
1587 	/**
1588 	 * Views
1589 	 */
1590 	function getCategoryWorkClockTimeRef(uint256 _catId) public view returns (uint256 workClockTimeRef)
1591 	{
1592 		require(existingCategory(_catId));
1593 		return m_categories[_catId].workClockTimeRef;
1594 	}
1595 
1596 	function existingCategory(uint256 _catId) public view  returns (bool categoryExist)
1597 	{
1598 		return m_categories[_catId].catid > 0;
1599 	}
1600 
1601 	function getCategory(uint256 _catId) public view returns (uint256 catid, string name, string  description, uint256 workClockTimeRef)
1602 	{
1603 		require(existingCategory(_catId));
1604 		return (
1605 			m_categories[_catId].catid,
1606 			m_categories[_catId].name,
1607 			m_categories[_catId].description,
1608 			m_categories[_catId].workClockTimeRef
1609 		);
1610 	}
1611 
1612 	function getWorkerStatus(address _worker) public view returns (address workerPool, uint256 workerScore)
1613 	{
1614 		return (workerPoolHub.getWorkerAffectation(_worker), m_scores[_worker]);
1615 	}
1616 
1617 	function getWorkerScore(address _worker) public view returns (uint256 workerScore)
1618 	{
1619 		return m_scores[_worker];
1620 	}
1621 
1622 	/**
1623 	 * Worker subscription
1624 	 */
1625 	function registerToPool(address _worker) public returns (bool subscribed)
1626 	// msg.sender = workerPool
1627 	{
1628 		WorkerPool workerpool = WorkerPool(msg.sender);
1629 		// Check credentials
1630 		require(workerPoolHub.isWorkerPoolRegistered(msg.sender));
1631 		// Lock worker deposit
1632 		require(lock(_worker, workerpool.m_subscriptionLockStakePolicy()));
1633 		// Check subscription policy
1634 		require(m_accounts[_worker].stake >= workerpool.m_subscriptionMinimumStakePolicy());
1635 		require(m_scores[_worker]         >= workerpool.m_subscriptionMinimumScorePolicy());
1636 		// Update affectation
1637 		require(workerPoolHub.registerWorkerAffectation(msg.sender, _worker));
1638 		// Trigger event notice
1639 		emit WorkerPoolSubscription(msg.sender, _worker);
1640 		return true;
1641 	}
1642 
1643 	function unregisterFromPool(address _worker) public returns (bool unsubscribed)
1644 	// msg.sender = workerPool
1645 	{
1646 		require(removeWorker(msg.sender, _worker));
1647 		// Trigger event notice
1648 		emit WorkerPoolUnsubscription(msg.sender, _worker);
1649 		return true;
1650 	}
1651 
1652 	function evictWorker(address _worker) public returns (bool unsubscribed)
1653 	// msg.sender = workerpool
1654 	{
1655 		require(removeWorker(msg.sender, _worker));
1656 		// Trigger event notice
1657 		emit WorkerPoolEviction(msg.sender, _worker);
1658 		return true;
1659 	}
1660 
1661 	function removeWorker(address _workerpool, address _worker) internal returns (bool unsubscribed)
1662 	{
1663 		WorkerPool workerpool = WorkerPool(_workerpool);
1664 		// Check credentials
1665 		require(workerPoolHub.isWorkerPoolRegistered(_workerpool));
1666 		// Unlick worker stake
1667 		require(unlock(_worker, workerpool.m_subscriptionLockStakePolicy()));
1668 		// Update affectation
1669 		require(workerPoolHub.unregisterWorkerAffectation(_workerpool, _worker));
1670 		return true;
1671 	}
1672 
1673 	/**
1674 	 * Stake, reward and penalty functions
1675 	 */
1676 	/* Marketplace */
1677 	function lockForOrder(address _user, uint256 _amount) public onlyMarketplace returns (bool)
1678 	{
1679 		require(lock(_user, _amount));
1680 		return true;
1681 	}
1682 	function unlockForOrder(address _user, uint256 _amount) public  onlyMarketplace returns (bool)
1683 	{
1684 		require(unlock(_user, _amount));
1685 		return true;
1686 	}
1687 	/* Work */
1688 	function lockForWork(address _woid, address _user, uint256 _amount) public onlyRegisteredWoid(_woid) returns (bool)
1689 	{
1690 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
1691 		require(lock(_user, _amount));
1692 		return true;
1693 	}
1694 	function unlockForWork(address _woid, address _user, uint256 _amount) public onlyRegisteredWoid(_woid) returns (bool)
1695 	{
1696 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
1697 		require(unlock(_user, _amount));
1698 		return true;
1699 	}
1700 	function rewardForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public onlyRegisteredWoid(_woid) returns (bool)
1701 	{
1702 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
1703 		require(reward(_worker, _amount));
1704 		if (_reputation)
1705 		{
1706 			m_contributionHistory.success = m_contributionHistory.success.add(1);
1707 			m_scores[_worker] = m_scores[_worker].add(1);
1708 			emit AccurateContribution(_woid, _worker);
1709 		}
1710 		return true;
1711 	}
1712 	function seizeForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public onlyRegisteredWoid(_woid) returns (bool)
1713 	{
1714 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
1715 		require(seize(_worker, _amount));
1716 		if (_reputation)
1717 		{
1718 			m_contributionHistory.failed = m_contributionHistory.failed.add(1);
1719 			m_scores[_worker] = m_scores[_worker].sub(m_scores[_worker].min(SCORE_UNITARY_SLASH));
1720 			emit FaultyContribution(_woid, _worker);
1721 		}
1722 		return true;
1723 	}
1724 	/**
1725 	 * Wallet methods: public
1726 	 */
1727 	function deposit(uint256 _amount) external returns (bool)
1728 	{
1729 		require(rlc.transferFrom(msg.sender, address(this), _amount));
1730 		m_accounts[msg.sender].stake = m_accounts[msg.sender].stake.add(_amount);
1731 		emit Deposit(msg.sender, _amount);
1732 		return true;
1733 	}
1734 	function withdraw(uint256 _amount) external returns (bool)
1735 	{
1736 		m_accounts[msg.sender].stake = m_accounts[msg.sender].stake.sub(_amount);
1737 		require(rlc.transfer(msg.sender, _amount));
1738 		emit Withdraw(msg.sender, _amount);
1739 		return true;
1740 	}
1741 	function checkBalance(address _owner) public view returns (uint256 stake, uint256 locked)
1742 	{
1743 		return (m_accounts[_owner].stake, m_accounts[_owner].locked);
1744 	}
1745 	/**
1746 	 * Wallet methods: Internal
1747 	 */
1748 	function reward(address _user, uint256 _amount) internal returns (bool)
1749 	{
1750 		m_accounts[_user].stake = m_accounts[_user].stake.add(_amount);
1751 		emit Reward(_user, _amount);
1752 		return true;
1753 	}
1754 	function seize(address _user, uint256 _amount) internal returns (bool)
1755 	{
1756 		m_accounts[_user].locked = m_accounts[_user].locked.sub(_amount);
1757 		emit Seize(_user, _amount);
1758 		return true;
1759 	}
1760 	function lock(address _user, uint256 _amount) internal returns (bool)
1761 	{
1762 		m_accounts[_user].stake  = m_accounts[_user].stake.sub(_amount);
1763 		m_accounts[_user].locked = m_accounts[_user].locked.add(_amount);
1764 		return true;
1765 	}
1766 	function unlock(address _user, uint256 _amount) internal returns (bool)
1767 	{
1768 		m_accounts[_user].locked = m_accounts[_user].locked.sub(_amount);
1769 		m_accounts[_user].stake  = m_accounts[_user].stake.add(_amount);
1770 		return true;
1771 	}
1772 }
1773 
1774 
1775 pragma solidity ^0.4.21;
1776 
1777 
1778 contract WorkerPool is OwnableOZ, IexecHubAccessor, MarketplaceAccessor
1779 {
1780 	using SafeMathOZ for uint256;
1781 
1782 
1783 	/**
1784 	 * Members
1785 	 */
1786 	string                      public m_description;
1787 	uint256                     public m_stakeRatioPolicy;               // % of reward to stake
1788 	uint256                     public m_schedulerRewardRatioPolicy;     // % of reward given to scheduler
1789 	uint256                     public m_subscriptionLockStakePolicy;    // Stake locked when in workerpool - Constant set by constructor, do not update
1790 	uint256                     public m_subscriptionMinimumStakePolicy; // Minimum stake for subscribing
1791 	uint256                     public m_subscriptionMinimumScorePolicy; // Minimum score for subscribing
1792 	address[]                   public m_workers;
1793 	mapping(address => uint256) public m_workerIndex;
1794 
1795 	// mapping(woid => IexecLib.Consensus)
1796 	mapping(address => IexecLib.Consensus) public m_consensus;
1797 	// mapping(woid => worker address => Contribution);
1798 	mapping(address => mapping(address => IexecLib.Contribution)) public m_contributions;
1799 
1800 	uint256 public constant REVEAL_PERIOD_DURATION_RATIO  = 2;
1801 	uint256 public constant CONSENSUS_DURATION_RATIO      = 10;
1802 
1803 	/**
1804 	 * Address of slave/related contracts
1805 	 */
1806 	address        public  m_workerPoolHubAddress;
1807 
1808 
1809 	/**
1810 	 * Events
1811 	 */
1812 	event WorkerPoolPolicyUpdate(
1813 		uint256 oldStakeRatioPolicy,               uint256 newStakeRatioPolicy,
1814 		uint256 oldSchedulerRewardRatioPolicy,     uint256 newSchedulerRewardRatioPolicy,
1815 		uint256 oldSubscriptionMinimumStakePolicy, uint256 newSubscriptionMinimumStakePolicy,
1816 		uint256 oldSubscriptionMinimumScorePolicy, uint256 newSubscriptionMinimumScorePolicy);
1817 
1818 	event WorkOrderActive         (address indexed woid);
1819 	event WorkOrderClaimed        (address indexed woid);
1820 
1821 	event AllowWorkerToContribute (address indexed woid, address indexed worker, uint256 workerScore);
1822 	event Contribute              (address indexed woid, address indexed worker, bytes32 resultHash);
1823 	event RevealConsensus         (address indexed woid, bytes32 consensus);
1824 	event Reveal                  (address indexed woid, address indexed worker, bytes32 result);
1825 	event Reopen                  (address indexed woid);
1826   event FinalizeWork            (address indexed woid, string stdout, string stderr, string uri);
1827 
1828 
1829 
1830 	event WorkerSubscribe         (address indexed worker);
1831 	event WorkerUnsubscribe       (address indexed worker);
1832 	event WorkerEviction          (address indexed worker);
1833 
1834 	/**
1835 	 * Methods
1836 	 */
1837 	// Constructor
1838 	function WorkerPool(
1839 		address _iexecHubAddress,
1840 		string  _description,
1841 		uint256 _subscriptionLockStakePolicy,
1842 		uint256 _subscriptionMinimumStakePolicy,
1843 		uint256 _subscriptionMinimumScorePolicy,
1844 		address _marketplaceAddress)
1845 	IexecHubAccessor(_iexecHubAddress)
1846 	MarketplaceAccessor(_marketplaceAddress)
1847 	public
1848 	{
1849 		// tx.origin == owner
1850 		// msg.sender ==  WorkerPoolHub
1851 		require(tx.origin != msg.sender);
1852 		setImmutableOwnership(tx.origin); // owner → tx.origin
1853 
1854 		m_description                    = _description;
1855 		m_stakeRatioPolicy               = 30; // % of the work order price to stake
1856 		m_schedulerRewardRatioPolicy     = 1;  // % of the work reward going to scheduler vs workers reward
1857 		m_subscriptionLockStakePolicy    = _subscriptionLockStakePolicy; // only at creation. cannot be change to respect lock/unlock of worker stake
1858 		m_subscriptionMinimumStakePolicy = _subscriptionMinimumStakePolicy;
1859 		m_subscriptionMinimumScorePolicy = _subscriptionMinimumScorePolicy;
1860 		m_workerPoolHubAddress           = msg.sender;
1861 
1862 	}
1863 
1864 	function changeWorkerPoolPolicy(
1865 		uint256 _newStakeRatioPolicy,
1866 		uint256 _newSchedulerRewardRatioPolicy,
1867 		uint256 _newSubscriptionMinimumStakePolicy,
1868 		uint256 _newSubscriptionMinimumScorePolicy)
1869 	public onlyOwner
1870 	{
1871 		emit WorkerPoolPolicyUpdate(
1872 			m_stakeRatioPolicy,               _newStakeRatioPolicy,
1873 			m_schedulerRewardRatioPolicy,     _newSchedulerRewardRatioPolicy,
1874 			m_subscriptionMinimumStakePolicy, _newSubscriptionMinimumStakePolicy,
1875 			m_subscriptionMinimumScorePolicy, _newSubscriptionMinimumScorePolicy
1876 		);
1877 		require(_newSchedulerRewardRatioPolicy <= 100);
1878 		m_stakeRatioPolicy               = _newStakeRatioPolicy;
1879 		m_schedulerRewardRatioPolicy     = _newSchedulerRewardRatioPolicy;
1880 		m_subscriptionMinimumStakePolicy = _newSubscriptionMinimumStakePolicy;
1881 		m_subscriptionMinimumScorePolicy = _newSubscriptionMinimumScorePolicy;
1882 	}
1883 
1884 	/************************* worker list management **************************/
1885 	function getWorkerAddress(uint _index) public view returns (address)
1886 	{
1887 		return m_workers[_index];
1888 	}
1889 	function getWorkerIndex(address _worker) public view returns (uint)
1890 	{
1891 		uint index = m_workerIndex[_worker];
1892 		require(m_workers[index] == _worker);
1893 		return index;
1894 	}
1895 	function getWorkersCount() public view returns (uint)
1896 	{
1897 		return m_workers.length;
1898 	}
1899 
1900 	function subscribeToPool() public returns (bool)
1901 	{
1902 		// msg.sender = worker
1903 		require(iexecHubInterface.registerToPool(msg.sender));
1904 		uint index = m_workers.push(msg.sender);
1905 		m_workerIndex[msg.sender] = index.sub(1);
1906 		emit WorkerSubscribe(msg.sender);
1907 		return true;
1908 	}
1909 
1910 	function unsubscribeFromPool() public  returns (bool)
1911 	{
1912 		// msg.sender = worker
1913 		require(iexecHubInterface.unregisterFromPool(msg.sender));
1914 		require(removeWorker(msg.sender));
1915 		emit WorkerUnsubscribe(msg.sender);
1916 		return true;
1917 	}
1918 
1919 	function evictWorker(address _worker) public onlyOwner returns (bool)
1920 	{
1921 		// msg.sender = scheduler
1922 		require(iexecHubInterface.evictWorker(_worker));
1923 		require(removeWorker(_worker));
1924 		emit WorkerEviction(_worker);
1925 		return true;
1926 	}
1927 
1928 	function removeWorker(address _worker) internal returns (bool)
1929 	{
1930 		uint index = getWorkerIndex(_worker); // fails if worker not registered
1931 		address lastWorker = m_workers[m_workers.length.sub(1)];
1932 		m_workers    [index     ] = lastWorker;
1933 		m_workerIndex[lastWorker] = index;
1934 		delete m_workers[m_workers.length.sub(1)];
1935 		m_workers.length = m_workers.length.sub(1);
1936 		return true;
1937 	}
1938 
1939 	function getConsensusDetails(address _woid) public view returns (
1940 		uint256 c_poolReward,
1941 		uint256 c_stakeAmount,
1942 		bytes32 c_consensus,
1943 		uint256 c_revealDate,
1944 		uint256 c_revealCounter,
1945 		uint256 c_consensusTimeout,
1946 		uint256 c_winnerCount,
1947 		address c_workerpoolOwner)
1948 	{
1949 		IexecLib.Consensus storage consensus = m_consensus[_woid];
1950 		return (
1951 			consensus.poolReward,
1952 			consensus.stakeAmount,
1953 			consensus.consensus,
1954 			consensus.revealDate,
1955 			consensus.revealCounter,
1956 			consensus.consensusTimeout,
1957 			consensus.winnerCount,
1958 			consensus.workerpoolOwner
1959 		);
1960 	}
1961 
1962 	function getContributorsCount(address _woid) public view returns (uint256 contributorsCount)
1963 	{
1964 		return m_consensus[_woid].contributors.length;
1965 	}
1966 
1967 	function getContributor(address _woid, uint256 index) public view returns (address contributor)
1968 	{
1969 		return m_consensus[_woid].contributors[index];
1970 	}
1971 
1972 	function existingContribution(address _woid, address _worker) public view  returns (bool contributionExist)
1973 	{
1974 		return m_contributions[_woid][_worker].status != IexecLib.ContributionStatusEnum.UNSET;
1975 	}
1976 
1977 	function getContribution(address _woid, address _worker) public view returns
1978 	(
1979 		IexecLib.ContributionStatusEnum status,
1980 		bytes32 resultHash,
1981 		bytes32 resultSign,
1982 		address enclaveChallenge,
1983 		uint256 score,
1984 		uint256 weight)
1985 	{
1986 		require(existingContribution(_woid, _worker)); // no silent value returned
1987 		IexecLib.Contribution storage contribution = m_contributions[_woid][_worker];
1988 		return (
1989 			contribution.status,
1990 			contribution.resultHash,
1991 			contribution.resultSign,
1992 			contribution.enclaveChallenge,
1993 			contribution.score,
1994 			contribution.weight
1995 		);
1996 	}
1997 
1998 
1999 	/**************************** Works management *****************************/
2000 	function emitWorkOrder(address _woid, uint256 _marketorderIdx) public onlyIexecHub returns (bool)
2001 	{
2002 		uint256 catid   = marketplaceInterface.getMarketOrderCategory(_marketorderIdx);
2003 		uint256 timeout = iexecHubInterface.getCategoryWorkClockTimeRef(catid).mul(CONSENSUS_DURATION_RATIO).add(now);
2004 
2005 		IexecLib.Consensus storage consensus = m_consensus[_woid];
2006 		consensus.poolReward                 = marketplaceInterface.getMarketOrderValue(_marketorderIdx);
2007 		consensus.workerpoolOwner            = marketplaceInterface.getMarketOrderWorkerpoolOwner(_marketorderIdx);
2008 		consensus.stakeAmount                = consensus.poolReward.percentage(m_stakeRatioPolicy);
2009 		consensus.consensusTimeout            = timeout;
2010 		consensus.schedulerRewardRatioPolicy = m_schedulerRewardRatioPolicy;
2011 
2012 		emit WorkOrderActive(_woid);
2013 
2014 		return true;
2015 	}
2016 
2017 	function claimFailedConsensus(address _woid) public onlyIexecHub returns (bool)
2018 	{
2019 	  IexecLib.Consensus storage consensus = m_consensus[_woid];
2020 		require(now > consensus.consensusTimeout);
2021 		uint256 i;
2022 		address w;
2023 		for (i = 0; i < consensus.contributors.length; ++i)
2024 		{
2025 			w = consensus.contributors[i];
2026 			if (m_contributions[_woid][w].status != IexecLib.ContributionStatusEnum.AUTHORIZED)
2027 			{
2028 				require(iexecHubInterface.unlockForWork(_woid, w, consensus.stakeAmount));
2029 			}
2030 		}
2031 		emit WorkOrderClaimed(_woid);
2032 		return true;
2033 	}
2034 
2035 	function allowWorkersToContribute(address _woid, address[] _workers, address _enclaveChallenge) public onlyOwner /*onlySheduler*/ returns (bool)
2036 	{
2037 		for (uint i = 0; i < _workers.length; ++i)
2038 		{
2039 			require(allowWorkerToContribute(_woid, _workers[i], _enclaveChallenge));
2040 		}
2041 		return true;
2042 	}
2043 
2044 	function allowWorkerToContribute(address _woid, address _worker, address _enclaveChallenge) public onlyOwner /*onlySheduler*/ returns (bool)
2045 	{
2046 		require(iexecHubInterface.isWoidRegistred(_woid));
2047 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.ACTIVE);
2048 		IexecLib.Contribution storage contribution = m_contributions[_woid][_worker];
2049 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
2050 		require(now <= consensus.consensusTimeout);
2051 
2052 		address workerPool;
2053 		uint256 workerScore;
2054 		(workerPool, workerScore) = iexecHubInterface.getWorkerStatus(_worker); // workerPool, workerScore
2055 		require(workerPool == address(this));
2056 
2057 		require(contribution.status == IexecLib.ContributionStatusEnum.UNSET);
2058 		contribution.status           = IexecLib.ContributionStatusEnum.AUTHORIZED;
2059 		contribution.enclaveChallenge = _enclaveChallenge;
2060 
2061 		emit AllowWorkerToContribute(_woid, _worker, workerScore);
2062 		return true;
2063 	}
2064 
2065 	function contribute(address _woid, bytes32 _resultHash, bytes32 _resultSign, uint8 _v, bytes32 _r, bytes32 _s) public returns (uint256 workerStake)
2066 	{
2067 		require(iexecHubInterface.isWoidRegistred(_woid));
2068 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
2069 		require(now <= consensus.consensusTimeout);
2070 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.ACTIVE); // can't contribute on a claimed or completed workorder
2071 		IexecLib.Contribution storage contribution = m_contributions[_woid][msg.sender];
2072 
2073 		// msg.sender = a worker
2074 		require(_resultHash != 0x0);
2075 		require(_resultSign != 0x0);
2076 		if (contribution.enclaveChallenge != address(0))
2077 		{
2078 			require(contribution.enclaveChallenge == ecrecover(keccak256("\x19Ethereum Signed Message:\n64", _resultHash, _resultSign), _v, _r, _s));
2079 		}
2080 
2081 		require(contribution.status == IexecLib.ContributionStatusEnum.AUTHORIZED);
2082 		contribution.status     = IexecLib.ContributionStatusEnum.CONTRIBUTED;
2083 		contribution.resultHash = _resultHash;
2084 		contribution.resultSign = _resultSign;
2085 		contribution.score      = iexecHubInterface.getWorkerScore(msg.sender);
2086 		consensus.contributors.push(msg.sender);
2087 
2088 		require(iexecHubInterface.lockForWork(_woid, msg.sender, consensus.stakeAmount));
2089 		emit Contribute(_woid, msg.sender, _resultHash);
2090 		return consensus.stakeAmount;
2091 	}
2092 
2093 	function revealConsensus(address _woid, bytes32 _consensus) public onlyOwner /*onlySheduler*/ returns (bool)
2094 	{
2095 		require(iexecHubInterface.isWoidRegistred(_woid));
2096 		IexecLib.Consensus storage consensus = m_consensus[_woid];
2097 		require(now <= consensus.consensusTimeout);
2098 		require(WorkOrder(_woid).startRevealingPhase());
2099 
2100 		consensus.winnerCount = 0;
2101 		for (uint256 i = 0; i<consensus.contributors.length; ++i)
2102 		{
2103 			address w = consensus.contributors[i];
2104 			if (
2105 				m_contributions[_woid][w].resultHash == _consensus
2106 				&&
2107 				m_contributions[_woid][w].status == IexecLib.ContributionStatusEnum.CONTRIBUTED // REJECTED contribution must not be count
2108 			)
2109 			{
2110 				consensus.winnerCount = consensus.winnerCount.add(1);
2111 			}
2112 		}
2113 		require(consensus.winnerCount > 0); // you cannot revealConsensus if no worker has contributed to this hash
2114 
2115 		consensus.consensus  = _consensus;
2116 		consensus.revealDate = iexecHubInterface.getCategoryWorkClockTimeRef(marketplaceInterface.getMarketOrderCategory(WorkOrder(_woid).m_marketorderIdx())).mul(REVEAL_PERIOD_DURATION_RATIO).add(now); // is it better to store th catid ?
2117 		emit RevealConsensus(_woid, _consensus);
2118 		return true;
2119 	}
2120 
2121 	function reveal(address _woid, bytes32 _result) public returns (bool)
2122 	{
2123 		require(iexecHubInterface.isWoidRegistred(_woid));
2124 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
2125 		require(now <= consensus.consensusTimeout);
2126 		IexecLib.Contribution storage contribution = m_contributions[_woid][msg.sender];
2127 
2128 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.REVEALING     );
2129 		require(consensus.revealDate        >  now                                        );
2130 		require(contribution.status         == IexecLib.ContributionStatusEnum.CONTRIBUTED);
2131 		require(contribution.resultHash     == consensus.consensus                        );
2132 		require(contribution.resultHash     == keccak256(_result                        ) );
2133 		require(contribution.resultSign     == keccak256(_result ^ keccak256(msg.sender)) );
2134 
2135 		contribution.status     = IexecLib.ContributionStatusEnum.PROVED;
2136 		consensus.revealCounter = consensus.revealCounter.add(1);
2137 
2138 		emit Reveal(_woid, msg.sender, _result);
2139 		return true;
2140 	}
2141 
2142 	function reopen(address _woid) public onlyOwner /*onlySheduler*/ returns (bool)
2143 	{
2144 		require(iexecHubInterface.isWoidRegistred(_woid));
2145 		IexecLib.Consensus storage consensus = m_consensus[_woid];
2146 		require(now <= consensus.consensusTimeout);
2147 		require(consensus.revealDate <= now && consensus.revealCounter == 0);
2148 		require(WorkOrder(_woid).reActivate());
2149 
2150 		for (uint256 i = 0; i < consensus.contributors.length; ++i)
2151 		{
2152 			address w = consensus.contributors[i];
2153 			if (m_contributions[_woid][w].resultHash == consensus.consensus)
2154 			{
2155 				m_contributions[_woid][w].status = IexecLib.ContributionStatusEnum.REJECTED;
2156 			}
2157 		}
2158 		// Reset to status before revealConsensus. Must be after REJECTED traitement above because of consensus.consensus check
2159 		consensus.winnerCount = 0;
2160 		consensus.consensus   = 0x0;
2161 		consensus.revealDate  = 0;
2162 		emit Reopen(_woid);
2163 		return true;
2164 	}
2165 
2166 	// if sheduler never call finalized ? no incetive to do that. schedulermust be pay also at this time
2167 	function finalizeWork(address _woid, string _stdout, string _stderr, string _uri) public onlyOwner /*onlySheduler*/ returns (bool)
2168 	{
2169 		require(iexecHubInterface.isWoidRegistred(_woid));
2170 		IexecLib.Consensus storage consensus = m_consensus[_woid];
2171 		require(now <= consensus.consensusTimeout);
2172 		require((consensus.revealDate <= now && consensus.revealCounter > 0) || (consensus.revealCounter == consensus.winnerCount)); // consensus.winnerCount never 0 at this step
2173 
2174 		// add penalized to the call worker to contribution and they never contribute ?
2175 		require(distributeRewards(_woid, consensus));
2176 
2177 		require(iexecHubInterface.finalizeWorkOrder(_woid, _stdout, _stderr, _uri));
2178 		emit FinalizeWork(_woid,_stdout,_stderr,_uri);
2179 		return true;
2180 	}
2181 
2182 	function distributeRewards(address _woid, IexecLib.Consensus _consensus) internal returns (bool)
2183 	{
2184 		uint256 i;
2185 		address w;
2186 		uint256 workerBonus;
2187 		uint256 workerWeight;
2188 		uint256 totalWeight;
2189 		uint256 individualWorkerReward;
2190 		uint256 totalReward = _consensus.poolReward;
2191 		address[] memory contributors = _consensus.contributors;
2192 		for (i = 0; i<contributors.length; ++i)
2193 		{
2194 			w = contributors[i];
2195 			IexecLib.Contribution storage c = m_contributions[_woid][w];
2196 			if (c.status == IexecLib.ContributionStatusEnum.PROVED)
2197 			{
2198 				workerBonus  = (c.enclaveChallenge != address(0)) ? 3 : 1; // TODO: bonus sgx = 3 ?
2199 				workerWeight = 1 + c.score.mul(workerBonus).log();
2200 				totalWeight  = totalWeight.add(workerWeight);
2201 				c.weight     = workerWeight; // store so we don't have to recompute
2202 			}
2203 			else // ContributionStatusEnum.REJECT or ContributionStatusEnum.CONTRIBUTED (not revealed)
2204 			{
2205 				totalReward = totalReward.add(_consensus.stakeAmount);
2206 			}
2207 		}
2208 		require(totalWeight > 0);
2209 
2210 		// compute how much is going to the workers
2211 		uint256 totalWorkersReward = totalReward.percentage(uint256(100).sub(_consensus.schedulerRewardRatioPolicy));
2212 
2213 		for (i = 0; i<contributors.length; ++i)
2214 		{
2215 			w = contributors[i];
2216 			if (m_contributions[_woid][w].status == IexecLib.ContributionStatusEnum.PROVED)
2217 			{
2218 				individualWorkerReward = totalWorkersReward.mulByFraction(m_contributions[_woid][w].weight, totalWeight);
2219 				totalReward  = totalReward.sub(individualWorkerReward);
2220 				require(iexecHubInterface.unlockForWork(_woid, w, _consensus.stakeAmount));
2221 				require(iexecHubInterface.rewardForWork(_woid, w, individualWorkerReward, true));
2222 			}
2223 			else // WorkStatusEnum.POCO_REJECT or ContributionStatusEnum.CONTRIBUTED (not revealed)
2224 			{
2225 				require(iexecHubInterface.seizeForWork(_woid, w, _consensus.stakeAmount, true));
2226 				// No Reward
2227 			}
2228 		}
2229 		// totalReward now contains the scheduler share
2230 		require(iexecHubInterface.rewardForWork(_woid, _consensus.workerpoolOwner, totalReward, false));
2231 
2232 		return true;
2233 	}
2234 
2235 }
2236 
2237 
2238 
2239 pragma solidity ^0.4.21;
2240 
2241 
2242 contract WorkerPoolHub is OwnableOZ // is Owned by IexecHub
2243 {
2244 
2245 	using SafeMathOZ for uint256;
2246 
2247 	/**
2248 	 * Members
2249 	 */
2250 	// worker => workerPool
2251 	mapping(address => address)                     m_workerAffectation;
2252 	// owner => index
2253 	mapping(address => uint256)                     m_workerPoolCountByOwner;
2254 	// owner => index => workerPool
2255 	mapping(address => mapping(uint256 => address)) m_workerPoolByOwnerByIndex;
2256 	//  workerPool => owner // stored in the workerPool
2257 	/* mapping(address => address)                     m_ownerByWorkerPool; */
2258 	mapping(address => bool)                        m_workerPoolRegistered;
2259 
2260 	mapping(uint256 => address)                     m_workerPoolByIndex;
2261 	uint256 public                                  m_totalWorkerPoolCount;
2262 
2263 
2264 
2265 	/**
2266 	 * Constructor
2267 	 */
2268 	function WorkerPoolHub() public
2269 	{
2270 	}
2271 
2272 	/**
2273 	 * Methods
2274 	 */
2275 	function isWorkerPoolRegistered(address _workerPool) public view returns (bool)
2276 	{
2277 		return m_workerPoolRegistered[_workerPool];
2278 	}
2279 	function getWorkerPoolsCount(address _owner) public view returns (uint256)
2280 	{
2281 		return m_workerPoolCountByOwner[_owner];
2282 	}
2283 	function getWorkerPool(address _owner, uint256 _index) public view returns (address)
2284 	{
2285 		return m_workerPoolByOwnerByIndex[_owner][_index];
2286 	}
2287 	function getWorkerPoolByIndex(uint256 _index) public view returns (address)
2288 	{
2289 		return m_workerPoolByIndex[_index];
2290 	}
2291 	function getWorkerAffectation(address _worker) public view returns (address workerPool)
2292 	{
2293 		return m_workerAffectation[_worker];
2294 	}
2295 
2296 	function addWorkerPool(address _owner, address _workerPool) internal
2297 	{
2298 		uint id = m_workerPoolCountByOwner[_owner].add(1);
2299 		m_totalWorkerPoolCount = m_totalWorkerPoolCount.add(1);
2300 		m_workerPoolByIndex       [m_totalWorkerPoolCount] = _workerPool;
2301 		m_workerPoolCountByOwner  [_owner]                 = id;
2302 		m_workerPoolByOwnerByIndex[_owner][id]             = _workerPool;
2303 		m_workerPoolRegistered    [_workerPool]            = true;
2304 	}
2305 
2306 	function createWorkerPool(
2307 		string _description,
2308 		uint256 _subscriptionLockStakePolicy,
2309 		uint256 _subscriptionMinimumStakePolicy,
2310 		uint256 _subscriptionMinimumScorePolicy,
2311 		address _marketplaceAddress)
2312 	external onlyOwner /*owner == IexecHub*/ returns (address createdWorkerPool)
2313 	{
2314 		// tx.origin == owner
2315 		// msg.sender == IexecHub
2316 		// At creating ownership is transfered to tx.origin
2317 		address newWorkerPool = new WorkerPool(
2318 			msg.sender, // iexecHubAddress
2319 			_description,
2320 			_subscriptionLockStakePolicy,
2321 			_subscriptionMinimumStakePolicy,
2322 			_subscriptionMinimumScorePolicy,
2323 			_marketplaceAddress
2324 		);
2325 		addWorkerPool(tx.origin, newWorkerPool);
2326 		return newWorkerPool;
2327 	}
2328 
2329 	function registerWorkerAffectation(address _workerPool, address _worker) public onlyOwner /*owner == IexecHub*/ returns (bool subscribed)
2330 	{
2331 		// you must have no cuurent affectation on others worker Pool
2332 		require(m_workerAffectation[_worker] == address(0));
2333 		m_workerAffectation[_worker] = _workerPool;
2334 		return true;
2335 	}
2336 
2337 	function unregisterWorkerAffectation(address _workerPool, address _worker) public onlyOwner /*owner == IexecHub*/ returns (bool unsubscribed)
2338 	{
2339 		require(m_workerAffectation[_worker] == _workerPool);
2340 		m_workerAffectation[_worker] = address(0);
2341 		return true;
2342 	}
2343 }