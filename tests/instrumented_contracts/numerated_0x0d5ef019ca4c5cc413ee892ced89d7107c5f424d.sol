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
332 
333 pragma solidity ^0.4.21;
334 
335 library IexecLib
336 {
337 	/***************************************************************************/
338 	/*                              Market Order                               */
339 	/***************************************************************************/
340 	enum MarketOrderDirectionEnum
341 	{
342 		UNSET,
343 		BID,
344 		ASK,
345 		CLOSED
346 	}
347 	struct MarketOrder
348 	{
349 		MarketOrderDirectionEnum direction;
350 		uint256 category;        // runtime selection
351 		uint256 trust;           // for PoCo
352 		uint256 value;           // value/cost/price
353 		uint256 volume;          // quantity of instances (total)
354 		uint256 remaining;       // remaining instances
355 		address workerpool;      // BID can use null for any
356 		address workerpoolOwner; // fix ownership if workerpool ownership change during the workorder steps
357 	}
358 
359 	/***************************************************************************/
360 	/*                               Work Order                                */
361 	/***************************************************************************/
362 	enum WorkOrderStatusEnum
363 	{
364 		UNSET,     // Work order not yet initialized (invalid address)
365 		ACTIVE,    // Marketed → constributions are open
366 		REVEALING, // Starting consensus reveal
367 		CLAIMED,   // failed consensus
368 		COMPLETED  // Concensus achieved
369 	}
370 
371 	/***************************************************************************/
372 	/*                                Consensus                                */
373 	/*                                   ---                                   */
374 	/*                         used in WorkerPool.sol                          */
375 	/***************************************************************************/
376 	struct Consensus
377 	{
378 		uint256 poolReward;
379 		uint256 stakeAmount;
380 		bytes32 consensus;
381 		uint256 revealDate;
382 		uint256 revealCounter;
383 		uint256 consensusTimeout;
384 		uint256 winnerCount;
385 		address[] contributors;
386 		address workerpoolOwner;
387 		uint256 schedulerRewardRatioPolicy;
388 
389 	}
390 
391 	/***************************************************************************/
392 	/*                              Contribution                               */
393 	/*                                   ---                                   */
394 	/*                         used in WorkerPool.sol                          */
395 	/***************************************************************************/
396 	enum ContributionStatusEnum
397 	{
398 		UNSET,
399 		AUTHORIZED,
400 		CONTRIBUTED,
401 		PROVED,
402 		REJECTED
403 	}
404 	struct Contribution
405 	{
406 		ContributionStatusEnum status;
407 		bytes32 resultHash;
408 		bytes32 resultSign;
409 		address enclaveChallenge;
410 		uint256 score;
411 		uint256 weight;
412 	}
413 
414 	/***************************************************************************/
415 	/*                Account / ContributionHistory / Category                 */
416 	/*                                   ---                                   */
417 	/*                          used in IexecHub.sol                           */
418 	/***************************************************************************/
419 	struct Account
420 	{
421 		uint256 stake;
422 		uint256 locked;
423 	}
424 
425 	struct ContributionHistory // for credibility computation, f = failed/total
426 	{
427 		uint256 success;
428 		uint256 failed;
429 	}
430 
431 	struct Category
432 	{
433 		uint256 catid;
434 		string  name;
435 		string  description;
436 		uint256 workClockTimeRef;
437 	}
438 
439 }
440 
441 
442 pragma solidity ^0.4.21;
443 
444 contract WorkOrder
445 {
446 
447 
448 	event WorkOrderActivated();
449 	event WorkOrderReActivated();
450 	event WorkOrderRevealing();
451 	event WorkOrderClaimed  ();
452 	event WorkOrderCompleted();
453 
454 	/**
455 	 * Members
456 	 */
457 	IexecLib.WorkOrderStatusEnum public m_status;
458 
459 	uint256 public m_marketorderIdx;
460 
461 	address public m_app;
462 	address public m_dataset;
463 	address public m_workerpool;
464 	address public m_requester;
465 
466 	uint256 public m_emitcost;
467 	string  public m_params;
468 	address public m_callback;
469 	address public m_beneficiary;
470 
471 	bytes32 public m_resultCallbackProof;
472 	string  public m_stdout;
473 	string  public m_stderr;
474 	string  public m_uri;
475 
476 	address public m_iexecHubAddress;
477 
478 	modifier onlyIexecHub()
479 	{
480 		require(msg.sender == m_iexecHubAddress);
481 		_;
482 	}
483 
484 	/**
485 	 * Constructor
486 	 */
487 	function WorkOrder(
488 		uint256 _marketorderIdx,
489 		address _requester,
490 		address _app,
491 		address _dataset,
492 		address _workerpool,
493 		uint256 _emitcost,
494 		string  _params,
495 		address _callback,
496 		address _beneficiary)
497 	public
498 	{
499 		m_iexecHubAddress = msg.sender;
500 		require(_requester != address(0));
501 		m_status         = IexecLib.WorkOrderStatusEnum.ACTIVE;
502 		m_marketorderIdx = _marketorderIdx;
503 		m_app            = _app;
504 		m_dataset        = _dataset;
505 		m_workerpool     = _workerpool;
506 		m_requester      = _requester;
507 		m_emitcost       = _emitcost;
508 		m_params         = _params;
509 		m_callback       = _callback;
510 		m_beneficiary    = _beneficiary;
511 		// needed for the scheduler to authorize api token access on this m_beneficiary address in case _requester is a smart contract.
512 	}
513 
514 	function startRevealingPhase() public returns (bool)
515 	{
516 		require(m_workerpool == msg.sender);
517 		require(m_status == IexecLib.WorkOrderStatusEnum.ACTIVE);
518 		m_status = IexecLib.WorkOrderStatusEnum.REVEALING;
519 		emit WorkOrderRevealing();
520 		return true;
521 	}
522 
523 	function reActivate() public returns (bool)
524 	{
525 		require(m_workerpool == msg.sender);
526 		require(m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
527 		m_status = IexecLib.WorkOrderStatusEnum.ACTIVE;
528 		emit WorkOrderReActivated();
529 		return true;
530 	}
531 
532 
533 	function claim() public onlyIexecHub
534 	{
535 		require(m_status == IexecLib.WorkOrderStatusEnum.ACTIVE || m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
536 		m_status = IexecLib.WorkOrderStatusEnum.CLAIMED;
537 		emit WorkOrderClaimed();
538 	}
539 
540 
541 	function setResult(string _stdout, string _stderr, string _uri) public onlyIexecHub
542 	{
543 		require(m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
544 		m_status = IexecLib.WorkOrderStatusEnum.COMPLETED;
545 		m_stdout = _stdout;
546 		m_stderr = _stderr;
547 		m_uri    = _uri;
548 		m_resultCallbackProof =keccak256(_stdout,_stderr,_uri);
549 		emit WorkOrderCompleted();
550 	}
551 
552 }
553 
554 pragma solidity ^0.4.21;
555 
556 contract IexecHubInterface
557 {
558 	RLC public rlc;
559 
560 	function attachContracts(
561 		address _tokenAddress,
562 		address _marketplaceAddress,
563 		address _workerPoolHubAddress,
564 		address _appHubAddress,
565 		address _datasetHubAddress)
566 		public;
567 
568 	function setCategoriesCreator(
569 		address _categoriesCreator)
570 	public;
571 
572 	function createCategory(
573 		string  _name,
574 		string  _description,
575 		uint256 _workClockTimeRef)
576 	public returns (uint256 catid);
577 
578 	function createWorkerPool(
579 		string  _description,
580 		uint256 _subscriptionLockStakePolicy,
581 		uint256 _subscriptionMinimumStakePolicy,
582 		uint256 _subscriptionMinimumScorePolicy)
583 	external returns (address createdWorkerPool);
584 
585 	function createApp(
586 		string  _appName,
587 		uint256 _appPrice,
588 		string  _appParams)
589 	external returns (address createdApp);
590 
591 	function createDataset(
592 		string  _datasetName,
593 		uint256 _datasetPrice,
594 		string  _datasetParams)
595 	external returns (address createdDataset);
596 
597 	function buyForWorkOrder(
598 		uint256 _marketorderIdx,
599 		address _workerpool,
600 		address _app,
601 		address _dataset,
602 		string  _params,
603 		address _callback,
604 		address _beneficiary)
605 	external returns (address);
606 
607 	function isWoidRegistred(
608 		address _woid)
609 	public view returns (bool);
610 
611 	function lockWorkOrderCost(
612 		address _requester,
613 		address _workerpool, // Address of a smartcontract
614 		address _app,        // Address of a smartcontract
615 		address _dataset)    // Address of a smartcontract
616 	internal returns (uint256);
617 
618 	function claimFailedConsensus(
619 		address _woid)
620 	public returns (bool);
621 
622 	function finalizeWorkOrder(
623 		address _woid,
624 		string  _stdout,
625 		string  _stderr,
626 		string  _uri)
627 	public returns (bool);
628 
629 	function getCategoryWorkClockTimeRef(
630 		uint256 _catId)
631 	public view returns (uint256 workClockTimeRef);
632 
633 	function existingCategory(
634 		uint256 _catId)
635 	public view  returns (bool categoryExist);
636 
637 	function getCategory(
638 		uint256 _catId)
639 		public view returns (uint256 catid, string name, string  description, uint256 workClockTimeRef);
640 
641 	function getWorkerStatus(
642 		address _worker)
643 	public view returns (address workerPool, uint256 workerScore);
644 
645 	function getWorkerScore(address _worker) public view returns (uint256 workerScore);
646 
647 	function registerToPool(address _worker) public returns (bool subscribed);
648 
649 	function unregisterFromPool(address _worker) public returns (bool unsubscribed);
650 
651 	function evictWorker(address _worker) public returns (bool unsubscribed);
652 
653 	function removeWorker(address _workerpool, address _worker) internal returns (bool unsubscribed);
654 
655 	function lockForOrder(address _user, uint256 _amount) public returns (bool);
656 
657 	function unlockForOrder(address _user, uint256 _amount) public returns (bool);
658 
659 	function lockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
660 
661 	function unlockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
662 
663 	function rewardForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
664 
665 	function seizeForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
666 
667 	function deposit(uint256 _amount) external returns (bool);
668 
669 	function withdraw(uint256 _amount) external returns (bool);
670 
671 	function checkBalance(address _owner) public view returns (uint256 stake, uint256 locked);
672 
673 	function reward(address _user, uint256 _amount) internal returns (bool);
674 
675 	function seize(address _user, uint256 _amount) internal returns (bool);
676 
677 	function lock(address _user, uint256 _amount) internal returns (bool);
678 
679 	function unlock(address _user, uint256 _amount) internal returns (bool);
680 }
681 
682 
683 pragma solidity ^0.4.21;
684 
685 contract IexecHubAccessor
686 {
687 	IexecHubInterface internal iexecHubInterface;
688 
689 	modifier onlyIexecHub()
690 	{
691 		require(msg.sender == address(iexecHubInterface));
692 		_;
693 	}
694 
695 	function IexecHubAccessor(address _iexecHubAddress) public
696 	{
697 		require(_iexecHubAddress != address(0));
698 		iexecHubInterface = IexecHubInterface(_iexecHubAddress);
699 	}
700 
701 }
702 
703 pragma solidity ^0.4.21;
704 
705 contract IexecCallbackInterface
706 {
707 
708 	function workOrderCallback(
709 		address _woid,
710 		string  _stdout,
711 		string  _stderr,
712 		string  _uri) public returns (bool);
713 
714 	event WorkOrderCallback(address woid, string stdout, string stderr, string uri);
715 }
716 
717 pragma solidity ^0.4.21;
718 contract MarketplaceInterface
719 {
720 	function createMarketOrder(
721 		IexecLib.MarketOrderDirectionEnum _direction,
722 		uint256 _category,
723 		uint256 _trust,
724 		uint256 _value,
725 		address _workerpool,
726 		uint256 _volume)
727 	public returns (uint);
728 
729 	function closeMarketOrder(
730 		uint256 _marketorderIdx)
731 	public returns (bool);
732 
733 	function getMarketOrderValue(
734 		uint256 _marketorderIdx)
735 	public view returns(uint256);
736 
737 	function getMarketOrderWorkerpoolOwner(
738 		uint256 _marketorderIdx)
739 	public view returns(address);
740 
741 	function getMarketOrderCategory(
742 		uint256 _marketorderIdx)
743 	public view returns (uint256);
744 
745 	function getMarketOrderTrust(
746 		uint256 _marketorderIdx)
747 	public view returns(uint256);
748 
749 	function getMarketOrder(
750 		uint256 _marketorderIdx)
751 	public view returns(
752 		IexecLib.MarketOrderDirectionEnum direction,
753 		uint256 category,       // runtime selection
754 		uint256 trust,          // for PoCo
755 		uint256 value,          // value/cost/price
756 		uint256 volume,         // quantity of instances (total)
757 		uint256 remaining,      // remaining instances
758 		address workerpool);    // BID can use null for any
759 }
760 
761 
762 pragma solidity ^0.4.21;
763 
764 contract MarketplaceAccessor
765 {
766 	address              internal marketplaceAddress;
767 	MarketplaceInterface internal marketplaceInterface;
768 /* not used
769 	modifier onlyMarketplace()
770 	{
771 		require(msg.sender == marketplaceAddress);
772 		_;
773 	}*/
774 
775 	function MarketplaceAccessor(address _marketplaceAddress) public
776 	{
777 		require(_marketplaceAddress != address(0));
778 		marketplaceAddress   = _marketplaceAddress;
779 		marketplaceInterface = MarketplaceInterface(_marketplaceAddress);
780 	}
781 }
782 
783 pragma solidity ^0.4.21;
784 
785 contract WorkerPool is OwnableOZ, IexecHubAccessor, MarketplaceAccessor
786 {
787 	using SafeMathOZ for uint256;
788 
789 
790 	/**
791 	 * Members
792 	 */
793 	string                      public m_description;
794 	uint256                     public m_stakeRatioPolicy;               // % of reward to stake
795 	uint256                     public m_schedulerRewardRatioPolicy;     // % of reward given to scheduler
796 	uint256                     public m_subscriptionLockStakePolicy;    // Stake locked when in workerpool - Constant set by constructor, do not update
797 	uint256                     public m_subscriptionMinimumStakePolicy; // Minimum stake for subscribing
798 	uint256                     public m_subscriptionMinimumScorePolicy; // Minimum score for subscribing
799 	address[]                   public m_workers;
800 	mapping(address => uint256) public m_workerIndex;
801 
802 	// mapping(woid => IexecLib.Consensus)
803 	mapping(address => IexecLib.Consensus) public m_consensus;
804 	// mapping(woid => worker address => Contribution);
805 	mapping(address => mapping(address => IexecLib.Contribution)) public m_contributions;
806 
807 	uint256 public constant REVEAL_PERIOD_DURATION_RATIO  = 2;
808 	uint256 public constant CONSENSUS_DURATION_RATIO      = 10;
809 
810 	/**
811 	 * Address of slave/related contracts
812 	 */
813 	address        public  m_workerPoolHubAddress;
814 
815 
816 	/**
817 	 * Events
818 	 */
819 	event WorkerPoolPolicyUpdate(
820 		uint256 oldStakeRatioPolicy,               uint256 newStakeRatioPolicy,
821 		uint256 oldSchedulerRewardRatioPolicy,     uint256 newSchedulerRewardRatioPolicy,
822 		uint256 oldSubscriptionMinimumStakePolicy, uint256 newSubscriptionMinimumStakePolicy,
823 		uint256 oldSubscriptionMinimumScorePolicy, uint256 newSubscriptionMinimumScorePolicy);
824 
825 	event WorkOrderActive         (address indexed woid);
826 	event WorkOrderClaimed        (address indexed woid);
827 
828 	event AllowWorkerToContribute (address indexed woid, address indexed worker, uint256 workerScore);
829 	event Contribute              (address indexed woid, address indexed worker, bytes32 resultHash);
830 	event RevealConsensus         (address indexed woid, bytes32 consensus);
831 	event Reveal                  (address indexed woid, address indexed worker, bytes32 result);
832 	event Reopen                  (address indexed woid);
833   event FinalizeWork            (address indexed woid, string stdout, string stderr, string uri);
834 
835 
836 
837 	event WorkerSubscribe         (address indexed worker);
838 	event WorkerUnsubscribe       (address indexed worker);
839 	event WorkerEviction          (address indexed worker);
840 
841 	/**
842 	 * Methods
843 	 */
844 	// Constructor
845 	function WorkerPool(
846 		address _iexecHubAddress,
847 		string  _description,
848 		uint256 _subscriptionLockStakePolicy,
849 		uint256 _subscriptionMinimumStakePolicy,
850 		uint256 _subscriptionMinimumScorePolicy,
851 		address _marketplaceAddress)
852 	IexecHubAccessor(_iexecHubAddress)
853 	MarketplaceAccessor(_marketplaceAddress)
854 	public
855 	{
856 		// tx.origin == owner
857 		// msg.sender ==  WorkerPoolHub
858 		require(tx.origin != msg.sender);
859 		setImmutableOwnership(tx.origin); // owner → tx.origin
860 
861 		m_description                    = _description;
862 		m_stakeRatioPolicy               = 30; // % of the work order price to stake
863 		m_schedulerRewardRatioPolicy     = 1;  // % of the work reward going to scheduler vs workers reward
864 		m_subscriptionLockStakePolicy    = _subscriptionLockStakePolicy; // only at creation. cannot be change to respect lock/unlock of worker stake
865 		m_subscriptionMinimumStakePolicy = _subscriptionMinimumStakePolicy;
866 		m_subscriptionMinimumScorePolicy = _subscriptionMinimumScorePolicy;
867 		m_workerPoolHubAddress           = msg.sender;
868 
869 	}
870 
871 	function changeWorkerPoolPolicy(
872 		uint256 _newStakeRatioPolicy,
873 		uint256 _newSchedulerRewardRatioPolicy,
874 		uint256 _newSubscriptionMinimumStakePolicy,
875 		uint256 _newSubscriptionMinimumScorePolicy)
876 	public onlyOwner
877 	{
878 		emit WorkerPoolPolicyUpdate(
879 			m_stakeRatioPolicy,               _newStakeRatioPolicy,
880 			m_schedulerRewardRatioPolicy,     _newSchedulerRewardRatioPolicy,
881 			m_subscriptionMinimumStakePolicy, _newSubscriptionMinimumStakePolicy,
882 			m_subscriptionMinimumScorePolicy, _newSubscriptionMinimumScorePolicy
883 		);
884 		require(_newSchedulerRewardRatioPolicy <= 100);
885 		m_stakeRatioPolicy               = _newStakeRatioPolicy;
886 		m_schedulerRewardRatioPolicy     = _newSchedulerRewardRatioPolicy;
887 		m_subscriptionMinimumStakePolicy = _newSubscriptionMinimumStakePolicy;
888 		m_subscriptionMinimumScorePolicy = _newSubscriptionMinimumScorePolicy;
889 	}
890 
891 	/************************* worker list management **************************/
892 	function getWorkerAddress(uint _index) public view returns (address)
893 	{
894 		return m_workers[_index];
895 	}
896 	function getWorkerIndex(address _worker) public view returns (uint)
897 	{
898 		uint index = m_workerIndex[_worker];
899 		require(m_workers[index] == _worker);
900 		return index;
901 	}
902 	function getWorkersCount() public view returns (uint)
903 	{
904 		return m_workers.length;
905 	}
906 
907 	function subscribeToPool() public returns (bool)
908 	{
909 		// msg.sender = worker
910 		require(iexecHubInterface.registerToPool(msg.sender));
911 		uint index = m_workers.push(msg.sender);
912 		m_workerIndex[msg.sender] = index.sub(1);
913 		emit WorkerSubscribe(msg.sender);
914 		return true;
915 	}
916 
917 	function unsubscribeFromPool() public  returns (bool)
918 	{
919 		// msg.sender = worker
920 		require(iexecHubInterface.unregisterFromPool(msg.sender));
921 		require(removeWorker(msg.sender));
922 		emit WorkerUnsubscribe(msg.sender);
923 		return true;
924 	}
925 
926 	function evictWorker(address _worker) public onlyOwner returns (bool)
927 	{
928 		// msg.sender = scheduler
929 		require(iexecHubInterface.evictWorker(_worker));
930 		require(removeWorker(_worker));
931 		emit WorkerEviction(_worker);
932 		return true;
933 	}
934 
935 	function removeWorker(address _worker) internal returns (bool)
936 	{
937 		uint index = getWorkerIndex(_worker); // fails if worker not registered
938 		address lastWorker = m_workers[m_workers.length.sub(1)];
939 		m_workers    [index     ] = lastWorker;
940 		m_workerIndex[lastWorker] = index;
941 		delete m_workers[m_workers.length.sub(1)];
942 		m_workers.length = m_workers.length.sub(1);
943 		return true;
944 	}
945 
946 	function getConsensusDetails(address _woid) public view returns (
947 		uint256 c_poolReward,
948 		uint256 c_stakeAmount,
949 		bytes32 c_consensus,
950 		uint256 c_revealDate,
951 		uint256 c_revealCounter,
952 		uint256 c_consensusTimeout,
953 		uint256 c_winnerCount,
954 		address c_workerpoolOwner)
955 	{
956 		IexecLib.Consensus storage consensus = m_consensus[_woid];
957 		return (
958 			consensus.poolReward,
959 			consensus.stakeAmount,
960 			consensus.consensus,
961 			consensus.revealDate,
962 			consensus.revealCounter,
963 			consensus.consensusTimeout,
964 			consensus.winnerCount,
965 			consensus.workerpoolOwner
966 		);
967 	}
968 
969 	function getContributorsCount(address _woid) public view returns (uint256 contributorsCount)
970 	{
971 		return m_consensus[_woid].contributors.length;
972 	}
973 
974 	function getContributor(address _woid, uint256 index) public view returns (address contributor)
975 	{
976 		return m_consensus[_woid].contributors[index];
977 	}
978 
979 	function existingContribution(address _woid, address _worker) public view  returns (bool contributionExist)
980 	{
981 		return m_contributions[_woid][_worker].status != IexecLib.ContributionStatusEnum.UNSET;
982 	}
983 
984 	function getContribution(address _woid, address _worker) public view returns
985 	(
986 		IexecLib.ContributionStatusEnum status,
987 		bytes32 resultHash,
988 		bytes32 resultSign,
989 		address enclaveChallenge,
990 		uint256 score,
991 		uint256 weight)
992 	{
993 		require(existingContribution(_woid, _worker)); // no silent value returned
994 		IexecLib.Contribution storage contribution = m_contributions[_woid][_worker];
995 		return (
996 			contribution.status,
997 			contribution.resultHash,
998 			contribution.resultSign,
999 			contribution.enclaveChallenge,
1000 			contribution.score,
1001 			contribution.weight
1002 		);
1003 	}
1004 
1005 
1006 	/**************************** Works management *****************************/
1007 	function emitWorkOrder(address _woid, uint256 _marketorderIdx) public onlyIexecHub returns (bool)
1008 	{
1009 		uint256 catid   = marketplaceInterface.getMarketOrderCategory(_marketorderIdx);
1010 		uint256 timeout = iexecHubInterface.getCategoryWorkClockTimeRef(catid).mul(CONSENSUS_DURATION_RATIO).add(now);
1011 
1012 		IexecLib.Consensus storage consensus = m_consensus[_woid];
1013 		consensus.poolReward                 = marketplaceInterface.getMarketOrderValue(_marketorderIdx);
1014 		consensus.workerpoolOwner            = marketplaceInterface.getMarketOrderWorkerpoolOwner(_marketorderIdx);
1015 		consensus.stakeAmount                = consensus.poolReward.percentage(m_stakeRatioPolicy);
1016 		consensus.consensusTimeout            = timeout;
1017 		consensus.schedulerRewardRatioPolicy = m_schedulerRewardRatioPolicy;
1018 
1019 		emit WorkOrderActive(_woid);
1020 
1021 		return true;
1022 	}
1023 
1024 	function claimFailedConsensus(address _woid) public onlyIexecHub returns (bool)
1025 	{
1026 	  IexecLib.Consensus storage consensus = m_consensus[_woid];
1027 		require(now > consensus.consensusTimeout);
1028 		uint256 i;
1029 		address w;
1030 		for (i = 0; i < consensus.contributors.length; ++i)
1031 		{
1032 			w = consensus.contributors[i];
1033 			if (m_contributions[_woid][w].status != IexecLib.ContributionStatusEnum.AUTHORIZED)
1034 			{
1035 				require(iexecHubInterface.unlockForWork(_woid, w, consensus.stakeAmount));
1036 			}
1037 		}
1038 		emit WorkOrderClaimed(_woid);
1039 		return true;
1040 	}
1041 
1042 	function allowWorkersToContribute(address _woid, address[] _workers, address _enclaveChallenge) public onlyOwner /*onlySheduler*/ returns (bool)
1043 	{
1044 		for (uint i = 0; i < _workers.length; ++i)
1045 		{
1046 			require(allowWorkerToContribute(_woid, _workers[i], _enclaveChallenge));
1047 		}
1048 		return true;
1049 	}
1050 
1051 	function allowWorkerToContribute(address _woid, address _worker, address _enclaveChallenge) public onlyOwner /*onlySheduler*/ returns (bool)
1052 	{
1053 		require(iexecHubInterface.isWoidRegistred(_woid));
1054 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.ACTIVE);
1055 		IexecLib.Contribution storage contribution = m_contributions[_woid][_worker];
1056 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
1057 		require(now <= consensus.consensusTimeout);
1058 
1059 		address workerPool;
1060 		uint256 workerScore;
1061 		(workerPool, workerScore) = iexecHubInterface.getWorkerStatus(_worker); // workerPool, workerScore
1062 		require(workerPool == address(this));
1063 
1064 		require(contribution.status == IexecLib.ContributionStatusEnum.UNSET);
1065 		contribution.status           = IexecLib.ContributionStatusEnum.AUTHORIZED;
1066 		contribution.enclaveChallenge = _enclaveChallenge;
1067 
1068 		emit AllowWorkerToContribute(_woid, _worker, workerScore);
1069 		return true;
1070 	}
1071 
1072 	function contribute(address _woid, bytes32 _resultHash, bytes32 _resultSign, uint8 _v, bytes32 _r, bytes32 _s) public returns (uint256 workerStake)
1073 	{
1074 		require(iexecHubInterface.isWoidRegistred(_woid));
1075 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
1076 		require(now <= consensus.consensusTimeout);
1077 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.ACTIVE); // can't contribute on a claimed or completed workorder
1078 		IexecLib.Contribution storage contribution = m_contributions[_woid][msg.sender];
1079 
1080 		// msg.sender = a worker
1081 		require(_resultHash != 0x0);
1082 		require(_resultSign != 0x0);
1083 		if (contribution.enclaveChallenge != address(0))
1084 		{
1085 			require(contribution.enclaveChallenge == ecrecover(keccak256("\x19Ethereum Signed Message:\n64", _resultHash, _resultSign), _v, _r, _s));
1086 		}
1087 
1088 		require(contribution.status == IexecLib.ContributionStatusEnum.AUTHORIZED);
1089 		contribution.status     = IexecLib.ContributionStatusEnum.CONTRIBUTED;
1090 		contribution.resultHash = _resultHash;
1091 		contribution.resultSign = _resultSign;
1092 		contribution.score      = iexecHubInterface.getWorkerScore(msg.sender);
1093 		consensus.contributors.push(msg.sender);
1094 
1095 		require(iexecHubInterface.lockForWork(_woid, msg.sender, consensus.stakeAmount));
1096 		emit Contribute(_woid, msg.sender, _resultHash);
1097 		return consensus.stakeAmount;
1098 	}
1099 
1100 	function revealConsensus(address _woid, bytes32 _consensus) public onlyOwner /*onlySheduler*/ returns (bool)
1101 	{
1102 		require(iexecHubInterface.isWoidRegistred(_woid));
1103 		IexecLib.Consensus storage consensus = m_consensus[_woid];
1104 		require(now <= consensus.consensusTimeout);
1105 		require(WorkOrder(_woid).startRevealingPhase());
1106 
1107 		consensus.winnerCount = 0;
1108 		for (uint256 i = 0; i<consensus.contributors.length; ++i)
1109 		{
1110 			address w = consensus.contributors[i];
1111 			if (
1112 				m_contributions[_woid][w].resultHash == _consensus
1113 				&&
1114 				m_contributions[_woid][w].status == IexecLib.ContributionStatusEnum.CONTRIBUTED // REJECTED contribution must not be count
1115 			)
1116 			{
1117 				consensus.winnerCount = consensus.winnerCount.add(1);
1118 			}
1119 		}
1120 		require(consensus.winnerCount > 0); // you cannot revealConsensus if no worker has contributed to this hash
1121 
1122 		consensus.consensus  = _consensus;
1123 		consensus.revealDate = iexecHubInterface.getCategoryWorkClockTimeRef(marketplaceInterface.getMarketOrderCategory(WorkOrder(_woid).m_marketorderIdx())).mul(REVEAL_PERIOD_DURATION_RATIO).add(now); // is it better to store th catid ?
1124 		emit RevealConsensus(_woid, _consensus);
1125 		return true;
1126 	}
1127 
1128 	function reveal(address _woid, bytes32 _result) public returns (bool)
1129 	{
1130 		require(iexecHubInterface.isWoidRegistred(_woid));
1131 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
1132 		require(now <= consensus.consensusTimeout);
1133 		IexecLib.Contribution storage contribution = m_contributions[_woid][msg.sender];
1134 
1135 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.REVEALING     );
1136 		require(consensus.revealDate        >  now                                        );
1137 		require(contribution.status         == IexecLib.ContributionStatusEnum.CONTRIBUTED);
1138 		require(contribution.resultHash     == consensus.consensus                        );
1139 		require(contribution.resultHash     == keccak256(_result                        ) );
1140 		require(contribution.resultSign     == keccak256(_result ^ keccak256(msg.sender)) );
1141 
1142 		contribution.status     = IexecLib.ContributionStatusEnum.PROVED;
1143 		consensus.revealCounter = consensus.revealCounter.add(1);
1144 
1145 		emit Reveal(_woid, msg.sender, _result);
1146 		return true;
1147 	}
1148 
1149 	function reopen(address _woid) public onlyOwner /*onlySheduler*/ returns (bool)
1150 	{
1151 		require(iexecHubInterface.isWoidRegistred(_woid));
1152 		IexecLib.Consensus storage consensus = m_consensus[_woid];
1153 		require(now <= consensus.consensusTimeout);
1154 		require(consensus.revealDate <= now && consensus.revealCounter == 0);
1155 		require(WorkOrder(_woid).reActivate());
1156 
1157 		for (uint256 i = 0; i < consensus.contributors.length; ++i)
1158 		{
1159 			address w = consensus.contributors[i];
1160 			if (m_contributions[_woid][w].resultHash == consensus.consensus)
1161 			{
1162 				m_contributions[_woid][w].status = IexecLib.ContributionStatusEnum.REJECTED;
1163 			}
1164 		}
1165 		// Reset to status before revealConsensus. Must be after REJECTED traitement above because of consensus.consensus check
1166 		consensus.winnerCount = 0;
1167 		consensus.consensus   = 0x0;
1168 		consensus.revealDate  = 0;
1169 		emit Reopen(_woid);
1170 		return true;
1171 	}
1172 
1173 	// if sheduler never call finalized ? no incetive to do that. schedulermust be pay also at this time
1174 	function finalizeWork(address _woid, string _stdout, string _stderr, string _uri) public onlyOwner /*onlySheduler*/ returns (bool)
1175 	{
1176 		require(iexecHubInterface.isWoidRegistred(_woid));
1177 		IexecLib.Consensus storage consensus = m_consensus[_woid];
1178 		require(now <= consensus.consensusTimeout);
1179 		require((consensus.revealDate <= now && consensus.revealCounter > 0) || (consensus.revealCounter == consensus.winnerCount)); // consensus.winnerCount never 0 at this step
1180 
1181 		// add penalized to the call worker to contribution and they never contribute ?
1182 		require(distributeRewards(_woid, consensus));
1183 
1184 		require(iexecHubInterface.finalizeWorkOrder(_woid, _stdout, _stderr, _uri));
1185 		emit FinalizeWork(_woid,_stdout,_stderr,_uri);
1186 		return true;
1187 	}
1188 
1189 	function distributeRewards(address _woid, IexecLib.Consensus _consensus) internal returns (bool)
1190 	{
1191 		uint256 i;
1192 		address w;
1193 		uint256 workerBonus;
1194 		uint256 workerWeight;
1195 		uint256 totalWeight;
1196 		uint256 individualWorkerReward;
1197 		uint256 totalReward = _consensus.poolReward;
1198 		address[] memory contributors = _consensus.contributors;
1199 		for (i = 0; i<contributors.length; ++i)
1200 		{
1201 			w = contributors[i];
1202 			IexecLib.Contribution storage c = m_contributions[_woid][w];
1203 			if (c.status == IexecLib.ContributionStatusEnum.PROVED)
1204 			{
1205 				workerBonus  = (c.enclaveChallenge != address(0)) ? 3 : 1; // TODO: bonus sgx = 3 ?
1206 				workerWeight = 1 + c.score.mul(workerBonus).log();
1207 				totalWeight  = totalWeight.add(workerWeight);
1208 				c.weight     = workerWeight; // store so we don't have to recompute
1209 			}
1210 			else // ContributionStatusEnum.REJECT or ContributionStatusEnum.CONTRIBUTED (not revealed)
1211 			{
1212 				totalReward = totalReward.add(_consensus.stakeAmount);
1213 			}
1214 		}
1215 		require(totalWeight > 0);
1216 
1217 		// compute how much is going to the workers
1218 		uint256 totalWorkersReward = totalReward.percentage(uint256(100).sub(_consensus.schedulerRewardRatioPolicy));
1219 
1220 		for (i = 0; i<contributors.length; ++i)
1221 		{
1222 			w = contributors[i];
1223 			if (m_contributions[_woid][w].status == IexecLib.ContributionStatusEnum.PROVED)
1224 			{
1225 				individualWorkerReward = totalWorkersReward.mulByFraction(m_contributions[_woid][w].weight, totalWeight);
1226 				totalReward  = totalReward.sub(individualWorkerReward);
1227 				require(iexecHubInterface.unlockForWork(_woid, w, _consensus.stakeAmount));
1228 				require(iexecHubInterface.rewardForWork(_woid, w, individualWorkerReward, true));
1229 			}
1230 			else // WorkStatusEnum.POCO_REJECT or ContributionStatusEnum.CONTRIBUTED (not revealed)
1231 			{
1232 				require(iexecHubInterface.seizeForWork(_woid, w, _consensus.stakeAmount, true));
1233 				// No Reward
1234 			}
1235 		}
1236 		// totalReward now contains the scheduler share
1237 		require(iexecHubInterface.rewardForWork(_woid, _consensus.workerpoolOwner, totalReward, false));
1238 
1239 		return true;
1240 	}
1241 
1242 }
1243 
1244 
1245 pragma solidity ^0.4.21;
1246 
1247 contract Marketplace is IexecHubAccessor
1248 {
1249 	using SafeMathOZ for uint256;
1250 
1251 	/**
1252 	 * Marketplace
1253 	 */
1254 	uint                                 public m_orderCount;
1255 	mapping(uint =>IexecLib.MarketOrder) public m_orderBook;
1256 
1257 	uint256 public constant ASK_STAKE_RATIO  = 30;
1258 
1259 	/**
1260 	 * Events
1261 	 */
1262 	event MarketOrderCreated   (uint marketorderIdx);
1263 	event MarketOrderClosed    (uint marketorderIdx);
1264 	event MarketOrderAskConsume(uint marketorderIdx, address requester);
1265 
1266 	/**
1267 	 * Constructor
1268 	 */
1269 	function Marketplace(address _iexecHubAddress)
1270 	IexecHubAccessor(_iexecHubAddress)
1271 	public
1272 	{
1273 	}
1274 
1275 	/**
1276 	 * Market orders
1277 	 */
1278 	function createMarketOrder(
1279 		IexecLib.MarketOrderDirectionEnum _direction,
1280 		uint256 _category,
1281 		uint256 _trust,
1282 		uint256 _value,
1283 		address _workerpool,
1284 		uint256 _volume)
1285 	public returns (uint)
1286 	{
1287 		require(iexecHubInterface.existingCategory(_category));
1288 		require(_volume >0);
1289 		m_orderCount = m_orderCount.add(1);
1290 		IexecLib.MarketOrder storage marketorder    = m_orderBook[m_orderCount];
1291 		marketorder.direction      = _direction;
1292 		marketorder.category       = _category;
1293 		marketorder.trust          = _trust;
1294 		marketorder.value          = _value;
1295 		marketorder.volume         = _volume;
1296 		marketorder.remaining      = _volume;
1297 
1298 		if (_direction == IexecLib.MarketOrderDirectionEnum.ASK)
1299 		{
1300 			require(WorkerPool(_workerpool).m_owner() == msg.sender);
1301 
1302 			require(iexecHubInterface.lockForOrder(msg.sender, _value.percentage(ASK_STAKE_RATIO).mul(_volume))); // mul must be done after percentage to avoid rounding errors
1303 			marketorder.workerpool      = _workerpool;
1304 			marketorder.workerpoolOwner = msg.sender;
1305 		}
1306 		else
1307 		{
1308 			// no BID implementation
1309 			revert();
1310 		}
1311 		emit MarketOrderCreated(m_orderCount);
1312 		return m_orderCount;
1313 	}
1314 
1315 	function closeMarketOrder(uint256 _marketorderIdx) public returns (bool)
1316 	{
1317 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
1318 		if (marketorder.direction == IexecLib.MarketOrderDirectionEnum.ASK)
1319 		{
1320 			require(marketorder.workerpoolOwner == msg.sender);
1321 			require(iexecHubInterface.unlockForOrder(marketorder.workerpoolOwner, marketorder.value.percentage(ASK_STAKE_RATIO).mul(marketorder.remaining))); // mul must be done after percentage to avoid rounding errors
1322 		}
1323 		else
1324 		{
1325 			// no BID implementation
1326 			revert();
1327 		}
1328 		marketorder.direction = IexecLib.MarketOrderDirectionEnum.CLOSED;
1329 		emit MarketOrderClosed(_marketorderIdx);
1330 		return true;
1331 	}
1332 
1333 
1334 	/**
1335 	 * Assets consumption
1336 	 */
1337 	function consumeMarketOrderAsk(
1338 		uint256 _marketorderIdx,
1339 		address _requester,
1340 		address _workerpool)
1341 	public onlyIexecHub returns (bool)
1342 	{
1343 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
1344 		require(marketorder.direction  == IexecLib.MarketOrderDirectionEnum.ASK);
1345 		require(marketorder.remaining  >  0);
1346 		require(marketorder.workerpool == _workerpool);
1347 
1348 		marketorder.remaining = marketorder.remaining.sub(1);
1349 		if (marketorder.remaining == 0)
1350 		{
1351 			marketorder.direction = IexecLib.MarketOrderDirectionEnum.CLOSED;
1352 		}
1353 		require(iexecHubInterface.lockForOrder(_requester, marketorder.value));
1354 		emit MarketOrderAskConsume(_marketorderIdx, _requester);
1355 		return true;
1356 	}
1357 
1358 	function existingMarketOrder(uint256 _marketorderIdx) public view  returns (bool marketOrderExist)
1359 	{
1360 		return m_orderBook[_marketorderIdx].category > 0;
1361 	}
1362 
1363 	/**
1364 	 * Views
1365 	 */
1366 	function getMarketOrderValue(uint256 _marketorderIdx) public view returns (uint256)
1367 	{
1368 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
1369 		return m_orderBook[_marketorderIdx].value;
1370 	}
1371 	function getMarketOrderWorkerpoolOwner(uint256 _marketorderIdx) public view returns (address)
1372 	{
1373 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
1374 		return m_orderBook[_marketorderIdx].workerpoolOwner;
1375 	}
1376 	function getMarketOrderCategory(uint256 _marketorderIdx) public view returns (uint256)
1377 	{
1378 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
1379 		return m_orderBook[_marketorderIdx].category;
1380 	}
1381 	function getMarketOrderTrust(uint256 _marketorderIdx) public view returns (uint256)
1382 	{
1383 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
1384 		return m_orderBook[_marketorderIdx].trust;
1385 	}
1386 	function getMarketOrder(uint256 _marketorderIdx) public view returns
1387 	(
1388 		IexecLib.MarketOrderDirectionEnum direction,
1389 		uint256 category,       // runtime selection
1390 		uint256 trust,          // for PoCo
1391 		uint256 value,          // value/cost/price
1392 		uint256 volume,         // quantity of instances (total)
1393 		uint256 remaining,      // remaining instances
1394 		address workerpool,     // BID can use null for any
1395 		address workerpoolOwner)
1396 	{
1397 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
1398 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
1399 		return (
1400 			marketorder.direction,
1401 			marketorder.category,
1402 			marketorder.trust,
1403 			marketorder.value,
1404 			marketorder.volume,
1405 			marketorder.remaining,
1406 			marketorder.workerpool,
1407 			marketorder.workerpoolOwner
1408 		);
1409 	}
1410 
1411 	/**
1412 	 * Callback Proof managment
1413 	 */
1414 
1415 	event WorkOrderCallbackProof(address indexed woid, address requester, address beneficiary,address indexed callbackTo, address indexed gasCallbackProvider,string stdout, string stderr , string uri);
1416 
1417 	//mapping(workorder => bool)
1418 	 mapping(address => bool) m_callbackDone;
1419 
1420 	 function isCallbackDone(address _woid) public view  returns (bool callbackDone)
1421 	 {
1422 		 return m_callbackDone[_woid];
1423 	 }
1424 
1425 	 function workOrderCallback(address _woid,string _stdout, string _stderr, string _uri) public
1426 	 {
1427 		 require(iexecHubInterface.isWoidRegistred(_woid));
1428 		 require(!isCallbackDone(_woid));
1429 		 m_callbackDone[_woid] = true;
1430 		 require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.COMPLETED);
1431 		 require(WorkOrder(_woid).m_resultCallbackProof() == keccak256(_stdout,_stderr,_uri));
1432 		 address callbackTo =WorkOrder(_woid).m_callback();
1433 		 require(callbackTo != address(0));
1434 		 require(IexecCallbackInterface(callbackTo).workOrderCallback(
1435 			 _woid,
1436 			 _stdout,
1437 			 _stderr,
1438 			 _uri
1439 		 ));
1440 		 emit WorkOrderCallbackProof(_woid,WorkOrder(_woid).m_requester(),WorkOrder(_woid).m_beneficiary(),callbackTo,tx.origin,_stdout,_stderr,_uri);
1441 	 }
1442 
1443 }
1444 
1445 pragma solidity ^0.4.21;
1446 
1447 contract App is OwnableOZ, IexecHubAccessor
1448 {
1449 
1450 	/**
1451 	 * Members
1452 	 */
1453 	string        public m_appName;
1454 	uint256       public m_appPrice;
1455 	string        public m_appParams;
1456 
1457 	/**
1458 	 * Constructor
1459 	 */
1460 	function App(
1461 		address _iexecHubAddress,
1462 		string  _appName,
1463 		uint256 _appPrice,
1464 		string  _appParams)
1465 	IexecHubAccessor(_iexecHubAddress)
1466 	public
1467 	{
1468 		// tx.origin == owner
1469 		// msg.sender == DatasetHub
1470 		require(tx.origin != msg.sender);
1471 		setImmutableOwnership(tx.origin); // owner → tx.origin
1472 
1473 		m_appName   = _appName;
1474 		m_appPrice  = _appPrice;
1475 		m_appParams = _appParams;
1476 
1477 	}
1478 
1479 }
1480 
1481 
1482 pragma solidity ^0.4.21;
1483 
1484 contract AppHub is OwnableOZ // is Owned by IexecHub
1485 {
1486 
1487 	using SafeMathOZ for uint256;
1488 
1489 	/**
1490 	 * Members
1491 	 */
1492 	mapping(address => uint256)                     m_appCountByOwner;
1493 	mapping(address => mapping(uint256 => address)) m_appByOwnerByIndex;
1494 	mapping(address => bool)                        m_appRegistered;
1495 
1496 	mapping(uint256 => address)                     m_appByIndex;
1497 	uint256 public                                  m_totalAppCount;
1498 
1499 	/**
1500 	 * Constructor
1501 	 */
1502 	function AppHub() public
1503 	{
1504 	}
1505 
1506 	/**
1507 	 * Methods
1508 	 */
1509 	function isAppRegistered(address _app) public view returns (bool)
1510 	{
1511 		return m_appRegistered[_app];
1512 	}
1513 	function getAppsCount(address _owner) public view returns (uint256)
1514 	{
1515 		return m_appCountByOwner[_owner];
1516 	}
1517 	function getApp(address _owner, uint256 _index) public view returns (address)
1518 	{
1519 		return m_appByOwnerByIndex[_owner][_index];
1520 	}
1521 	function getAppByIndex(uint256 _index) public view returns (address)
1522 	{
1523 		return m_appByIndex[_index];
1524 	}
1525 
1526 	function addApp(address _owner, address _app) internal
1527 	{
1528 		uint id = m_appCountByOwner[_owner].add(1);
1529 		m_totalAppCount=m_totalAppCount.add(1);
1530 		m_appByIndex       [m_totalAppCount] = _app;
1531 		m_appCountByOwner  [_owner]          = id;
1532 		m_appByOwnerByIndex[_owner][id]      = _app;
1533 		m_appRegistered    [_app]            = true;
1534 	}
1535 
1536 	function createApp(
1537 		string  _appName,
1538 		uint256 _appPrice,
1539 		string  _appParams)
1540 	public onlyOwner /*owner == IexecHub*/ returns (address createdApp)
1541 	{
1542 		// tx.origin == owner
1543 		// msg.sender == IexecHub
1544 		address newApp = new App(
1545 			msg.sender,
1546 			_appName,
1547 			_appPrice,
1548 			_appParams
1549 		);
1550 		addApp(tx.origin, newApp);
1551 		return newApp;
1552 	}
1553 
1554 }
1555 
1556 
1557 pragma solidity ^0.4.21;
1558 
1559 contract Dataset is OwnableOZ, IexecHubAccessor
1560 {
1561 
1562 	/**
1563 	 * Members
1564 	 */
1565 	string            public m_datasetName;
1566 	uint256           public m_datasetPrice;
1567 	string            public m_datasetParams;
1568 
1569 	/**
1570 	 * Constructor
1571 	 */
1572 	function Dataset(
1573 		address _iexecHubAddress,
1574 		string  _datasetName,
1575 		uint256 _datasetPrice,
1576 		string  _datasetParams)
1577 	IexecHubAccessor(_iexecHubAddress)
1578 	public
1579 	{
1580 		// tx.origin == owner
1581 		// msg.sender == DatasetHub
1582 		require(tx.origin != msg.sender);
1583 		setImmutableOwnership(tx.origin); // owner → tx.origin
1584 
1585 		m_datasetName   = _datasetName;
1586 		m_datasetPrice  = _datasetPrice;
1587 		m_datasetParams = _datasetParams;
1588 
1589 	}
1590 
1591 
1592 }
1593 
1594 pragma solidity ^0.4.21;
1595 
1596 contract DatasetHub is OwnableOZ // is Owned by IexecHub
1597 {
1598 	using SafeMathOZ for uint256;
1599 
1600 	/**
1601 	 * Members
1602 	 */
1603 	mapping(address => uint256)                     m_datasetCountByOwner;
1604 	mapping(address => mapping(uint256 => address)) m_datasetByOwnerByIndex;
1605 	mapping(address => bool)                        m_datasetRegistered;
1606 
1607 	mapping(uint256 => address)                     m_datasetByIndex;
1608 	uint256 public                                  m_totalDatasetCount;
1609 
1610 
1611 
1612 	/**
1613 	 * Constructor
1614 	 */
1615 	function DatasetHub() public
1616 	{
1617 	}
1618 
1619 	/**
1620 	 * Methods
1621 	 */
1622 	function isDatasetRegistred(address _dataset) public view returns (bool)
1623 	{
1624 		return m_datasetRegistered[_dataset];
1625 	}
1626 	function getDatasetsCount(address _owner) public view returns (uint256)
1627 	{
1628 		return m_datasetCountByOwner[_owner];
1629 	}
1630 	function getDataset(address _owner, uint256 _index) public view returns (address)
1631 	{
1632 		return m_datasetByOwnerByIndex[_owner][_index];
1633 	}
1634 	function getDatasetByIndex(uint256 _index) public view returns (address)
1635 	{
1636 		return m_datasetByIndex[_index];
1637 	}
1638 
1639 	function addDataset(address _owner, address _dataset) internal
1640 	{
1641 		uint id = m_datasetCountByOwner[_owner].add(1);
1642 		m_totalDatasetCount = m_totalDatasetCount.add(1);
1643 		m_datasetByIndex       [m_totalDatasetCount] = _dataset;
1644 		m_datasetCountByOwner  [_owner]              = id;
1645 		m_datasetByOwnerByIndex[_owner][id]          = _dataset;
1646 		m_datasetRegistered    [_dataset]            = true;
1647 	}
1648 
1649 	function createDataset(
1650 		string _datasetName,
1651 		uint256 _datasetPrice,
1652 		string _datasetParams)
1653 	public onlyOwner /*owner == IexecHub*/ returns (address createdDataset)
1654 	{
1655 		// tx.origin == owner
1656 		// msg.sender == IexecHub
1657 		address newDataset = new Dataset(
1658 			msg.sender,
1659 			_datasetName,
1660 			_datasetPrice,
1661 			_datasetParams
1662 		);
1663 		addDataset(tx.origin, newDataset);
1664 		return newDataset;
1665 	}
1666 }
1667 
1668 
1669 pragma solidity ^0.4.21;
1670 
1671 contract WorkerPoolHub is OwnableOZ // is Owned by IexecHub
1672 {
1673 
1674 	using SafeMathOZ for uint256;
1675 
1676 	/**
1677 	 * Members
1678 	 */
1679 	// worker => workerPool
1680 	mapping(address => address)                     m_workerAffectation;
1681 	// owner => index
1682 	mapping(address => uint256)                     m_workerPoolCountByOwner;
1683 	// owner => index => workerPool
1684 	mapping(address => mapping(uint256 => address)) m_workerPoolByOwnerByIndex;
1685 	//  workerPool => owner // stored in the workerPool
1686 	/* mapping(address => address)                     m_ownerByWorkerPool; */
1687 	mapping(address => bool)                        m_workerPoolRegistered;
1688 
1689 	mapping(uint256 => address)                     m_workerPoolByIndex;
1690 	uint256 public                                  m_totalWorkerPoolCount;
1691 
1692 
1693 
1694 	/**
1695 	 * Constructor
1696 	 */
1697 	function WorkerPoolHub() public
1698 	{
1699 	}
1700 
1701 	/**
1702 	 * Methods
1703 	 */
1704 	function isWorkerPoolRegistered(address _workerPool) public view returns (bool)
1705 	{
1706 		return m_workerPoolRegistered[_workerPool];
1707 	}
1708 	function getWorkerPoolsCount(address _owner) public view returns (uint256)
1709 	{
1710 		return m_workerPoolCountByOwner[_owner];
1711 	}
1712 	function getWorkerPool(address _owner, uint256 _index) public view returns (address)
1713 	{
1714 		return m_workerPoolByOwnerByIndex[_owner][_index];
1715 	}
1716 	function getWorkerPoolByIndex(uint256 _index) public view returns (address)
1717 	{
1718 		return m_workerPoolByIndex[_index];
1719 	}
1720 	function getWorkerAffectation(address _worker) public view returns (address workerPool)
1721 	{
1722 		return m_workerAffectation[_worker];
1723 	}
1724 
1725 	function addWorkerPool(address _owner, address _workerPool) internal
1726 	{
1727 		uint id = m_workerPoolCountByOwner[_owner].add(1);
1728 		m_totalWorkerPoolCount = m_totalWorkerPoolCount.add(1);
1729 		m_workerPoolByIndex       [m_totalWorkerPoolCount] = _workerPool;
1730 		m_workerPoolCountByOwner  [_owner]                 = id;
1731 		m_workerPoolByOwnerByIndex[_owner][id]             = _workerPool;
1732 		m_workerPoolRegistered    [_workerPool]            = true;
1733 	}
1734 
1735 	function createWorkerPool(
1736 		string _description,
1737 		uint256 _subscriptionLockStakePolicy,
1738 		uint256 _subscriptionMinimumStakePolicy,
1739 		uint256 _subscriptionMinimumScorePolicy,
1740 		address _marketplaceAddress)
1741 	external onlyOwner /*owner == IexecHub*/ returns (address createdWorkerPool)
1742 	{
1743 		// tx.origin == owner
1744 		// msg.sender == IexecHub
1745 		// At creating ownership is transfered to tx.origin
1746 		address newWorkerPool = new WorkerPool(
1747 			msg.sender, // iexecHubAddress
1748 			_description,
1749 			_subscriptionLockStakePolicy,
1750 			_subscriptionMinimumStakePolicy,
1751 			_subscriptionMinimumScorePolicy,
1752 			_marketplaceAddress
1753 		);
1754 		addWorkerPool(tx.origin, newWorkerPool);
1755 		return newWorkerPool;
1756 	}
1757 
1758 	function registerWorkerAffectation(address _workerPool, address _worker) public onlyOwner /*owner == IexecHub*/ returns (bool subscribed)
1759 	{
1760 		// you must have no cuurent affectation on others worker Pool
1761 		require(m_workerAffectation[_worker] == address(0));
1762 		m_workerAffectation[_worker] = _workerPool;
1763 		return true;
1764 	}
1765 
1766 	function unregisterWorkerAffectation(address _workerPool, address _worker) public onlyOwner /*owner == IexecHub*/ returns (bool unsubscribed)
1767 	{
1768 		require(m_workerAffectation[_worker] == _workerPool);
1769 		m_workerAffectation[_worker] = address(0);
1770 		return true;
1771 	}
1772 }
1773 
1774 
1775 pragma solidity ^0.4.21;
1776 
1777 /**
1778  * @title IexecHub
1779  */
1780 
1781 contract IexecHub
1782 {
1783 	using SafeMathOZ for uint256;
1784 
1785 	/**
1786 	* RLC contract for token transfers.
1787 	*/
1788 	RLC public rlc;
1789 
1790 	uint256 public constant STAKE_BONUS_RATIO         = 10;
1791 	uint256 public constant STAKE_BONUS_MIN_THRESHOLD = 1000;
1792 	uint256 public constant SCORE_UNITARY_SLASH       = 50;
1793 
1794 	/**
1795 	 * Slaves contracts
1796 	 */
1797 	AppHub        public appHub;
1798 	DatasetHub    public datasetHub;
1799 	WorkerPoolHub public workerPoolHub;
1800 
1801 	/**
1802 	 * Market place
1803 	 */
1804 	Marketplace public marketplace;
1805 	modifier onlyMarketplace()
1806 	{
1807 		require(msg.sender == address(marketplace));
1808 		_;
1809 	}
1810 	/**
1811 	 * Categories
1812 	 */
1813 	mapping(uint256 => IexecLib.Category) public m_categories;
1814 	uint256                               public m_categoriesCount;
1815 	address                               public m_categoriesCreator;
1816 	modifier onlyCategoriesCreator()
1817 	{
1818 		require(msg.sender == m_categoriesCreator);
1819 		_;
1820 	}
1821 
1822 	/**
1823 	 * Escrow
1824 	 */
1825 	mapping(address => IexecLib.Account) public m_accounts;
1826 
1827 
1828 	/**
1829 	 * workOrder Registered
1830 	 */
1831 	mapping(address => bool) public m_woidRegistered;
1832 	modifier onlyRegisteredWoid(address _woid)
1833 	{
1834 		require(m_woidRegistered[_woid]);
1835 		_;
1836 	}
1837 
1838 	/**
1839 	 * Reputation for PoCo
1840 	 */
1841 	mapping(address => uint256)  public m_scores;
1842 	IexecLib.ContributionHistory public m_contributionHistory;
1843 
1844 
1845 	event WorkOrderActivated(address woid, address indexed workerPool);
1846 	event WorkOrderClaimed  (address woid, address workerPool);
1847 	event WorkOrderCompleted(address woid, address workerPool);
1848 
1849 	event CreateApp       (address indexed appOwner,        address indexed app,        string appName,     uint256 appPrice,     string appParams    );
1850 	event CreateDataset   (address indexed datasetOwner,    address indexed dataset,    string datasetName, uint256 datasetPrice, string datasetParams);
1851 	event CreateWorkerPool(address indexed workerPoolOwner, address indexed workerPool, string workerPoolDescription                                        );
1852 
1853 	event CreateCategory  (uint256 catid, string name, string description, uint256 workClockTimeRef);
1854 
1855 	event WorkerPoolSubscription  (address indexed workerPool, address worker);
1856 	event WorkerPoolUnsubscription(address indexed workerPool, address worker);
1857 	event WorkerPoolEviction      (address indexed workerPool, address worker);
1858 
1859 	event AccurateContribution(address woid, address indexed worker);
1860 	event FaultyContribution  (address woid, address indexed worker);
1861 
1862 	event Deposit (address owner, uint256 amount);
1863 	event Withdraw(address owner, uint256 amount);
1864 	event Reward  (address user,  uint256 amount);
1865 	event Seize   (address user,  uint256 amount);
1866 
1867 	/**
1868 	 * Constructor
1869 	 */
1870 	function IexecHub()
1871 	public
1872 	{
1873 		m_categoriesCreator = msg.sender;
1874 	}
1875 
1876 	function attachContracts(
1877 		address _tokenAddress,
1878 		address _marketplaceAddress,
1879 		address _workerPoolHubAddress,
1880 		address _appHubAddress,
1881 		address _datasetHubAddress)
1882 	public onlyCategoriesCreator
1883 	{
1884 		require(address(rlc) == address(0));
1885 		rlc                = RLC          (_tokenAddress        );
1886 		marketplace        = Marketplace  (_marketplaceAddress  );
1887 		workerPoolHub      = WorkerPoolHub(_workerPoolHubAddress);
1888 		appHub             = AppHub       (_appHubAddress       );
1889 		datasetHub         = DatasetHub   (_datasetHubAddress   );
1890 
1891 	}
1892 
1893 	function setCategoriesCreator(address _categoriesCreator)
1894 	public onlyCategoriesCreator
1895 	{
1896 		m_categoriesCreator = _categoriesCreator;
1897 	}
1898 	/**
1899 	 * Factory
1900 	 */
1901 
1902 	function createCategory(
1903 		string  _name,
1904 		string  _description,
1905 		uint256 _workClockTimeRef)
1906 	public onlyCategoriesCreator returns (uint256 catid)
1907 	{
1908 		m_categoriesCount                  = m_categoriesCount.add(1);
1909 		IexecLib.Category storage category = m_categories[m_categoriesCount];
1910 		category.catid                     = m_categoriesCount;
1911 		category.name                      = _name;
1912 		category.description               = _description;
1913 		category.workClockTimeRef          = _workClockTimeRef;
1914 		emit CreateCategory(m_categoriesCount, _name, _description, _workClockTimeRef);
1915 		return m_categoriesCount;
1916 	}
1917 
1918 	function createWorkerPool(
1919 		string  _description,
1920 		uint256 _subscriptionLockStakePolicy,
1921 		uint256 _subscriptionMinimumStakePolicy,
1922 		uint256 _subscriptionMinimumScorePolicy)
1923 	external returns (address createdWorkerPool)
1924 	{
1925 		address newWorkerPool = workerPoolHub.createWorkerPool(
1926 			_description,
1927 			_subscriptionLockStakePolicy,
1928 			_subscriptionMinimumStakePolicy,
1929 			_subscriptionMinimumScorePolicy,
1930 			address(marketplace)
1931 		);
1932 		emit CreateWorkerPool(tx.origin, newWorkerPool, _description);
1933 		return newWorkerPool;
1934 	}
1935 
1936 	function createApp(
1937 		string  _appName,
1938 		uint256 _appPrice,
1939 		string  _appParams)
1940 	external returns (address createdApp)
1941 	{
1942 		address newApp = appHub.createApp(
1943 			_appName,
1944 			_appPrice,
1945 			_appParams
1946 		);
1947 		emit CreateApp(tx.origin, newApp, _appName, _appPrice, _appParams);
1948 		return newApp;
1949 	}
1950 
1951 	function createDataset(
1952 		string  _datasetName,
1953 		uint256 _datasetPrice,
1954 		string  _datasetParams)
1955 	external returns (address createdDataset)
1956 	{
1957 		address newDataset = datasetHub.createDataset(
1958 			_datasetName,
1959 			_datasetPrice,
1960 			_datasetParams
1961 			);
1962 		emit CreateDataset(tx.origin, newDataset, _datasetName, _datasetPrice, _datasetParams);
1963 		return newDataset;
1964 	}
1965 
1966 	/**
1967 	 * WorkOrder Emission
1968 	 */
1969 	function buyForWorkOrder(
1970 		uint256 _marketorderIdx,
1971 		address _workerpool,
1972 		address _app,
1973 		address _dataset,
1974 		string  _params,
1975 		address _callback,
1976 		address _beneficiary)
1977 	external returns (address)
1978 	{
1979 		address requester = msg.sender;
1980 		require(marketplace.consumeMarketOrderAsk(_marketorderIdx, requester, _workerpool));
1981 
1982 		uint256 emitcost = lockWorkOrderCost(requester, _workerpool, _app, _dataset);
1983 
1984 		WorkOrder workorder = new WorkOrder(
1985 			_marketorderIdx,
1986 			requester,
1987 			_app,
1988 			_dataset,
1989 			_workerpool,
1990 			emitcost,
1991 			_params,
1992 			_callback,
1993 			_beneficiary
1994 		);
1995 
1996 		m_woidRegistered[workorder] = true;
1997 
1998 		require(WorkerPool(_workerpool).emitWorkOrder(workorder, _marketorderIdx));
1999 
2000 		emit WorkOrderActivated(workorder, _workerpool);
2001 		return workorder;
2002 	}
2003 
2004 	function isWoidRegistred(address _woid) public view returns (bool)
2005 	{
2006 		return m_woidRegistered[_woid];
2007 	}
2008 
2009 	function lockWorkOrderCost(
2010 		address _requester,
2011 		address _workerpool, // Address of a smartcontract
2012 		address _app,        // Address of a smartcontract
2013 		address _dataset)    // Address of a smartcontract
2014 	internal returns (uint256)
2015 	{
2016 		// APP
2017 		App app = App(_app);
2018 		require(appHub.isAppRegistered (_app));
2019 		// initialize usercost with dapp price
2020 		uint256 emitcost = app.m_appPrice();
2021 
2022 		// DATASET
2023 		if (_dataset != address(0)) // address(0) → no dataset
2024 		{
2025 			Dataset dataset = Dataset(_dataset);
2026 			require(datasetHub.isDatasetRegistred(_dataset));
2027 			// add optional datasetPrice for userCost
2028 			emitcost = emitcost.add(dataset.m_datasetPrice());
2029 		}
2030 
2031 		// WORKERPOOL
2032 		require(workerPoolHub.isWorkerPoolRegistered(_workerpool));
2033 
2034 		require(lock(_requester, emitcost)); // Lock funds for app + dataset payment
2035 
2036 		return emitcost;
2037 	}
2038 
2039 	/**
2040 	 * WorkOrder life cycle
2041 	 */
2042 
2043 	function claimFailedConsensus(address _woid)
2044 	public onlyRegisteredWoid(_woid) returns (bool)
2045 	{
2046 		WorkOrder  workorder  = WorkOrder(_woid);
2047 		require(workorder.m_requester() == msg.sender);
2048 		WorkerPool workerpool = WorkerPool(workorder.m_workerpool());
2049 
2050 		IexecLib.WorkOrderStatusEnum currentStatus = workorder.m_status();
2051 		require(currentStatus == IexecLib.WorkOrderStatusEnum.ACTIVE || currentStatus == IexecLib.WorkOrderStatusEnum.REVEALING);
2052 		// Unlock stakes for all workers
2053 		require(workerpool.claimFailedConsensus(_woid));
2054 		workorder.claim(); // revert on error
2055 
2056 		/* uint256 value           = marketplace.getMarketOrderValue(workorder.m_marketorderIdx()); // revert if not exist */
2057 		/* address workerpoolOwner = marketplace.getMarketOrderWorkerpoolOwner(workorder.m_marketorderIdx()); // revert if not exist */
2058 		uint256 value;
2059 		address workerpoolOwner;
2060 		(,,,value,,,,workerpoolOwner) = marketplace.getMarketOrder(workorder.m_marketorderIdx()); // Single call cost less gas
2061 		uint256 workerpoolStake = value.percentage(marketplace.ASK_STAKE_RATIO());
2062 
2063 		require(unlock (workorder.m_requester(), value.add(workorder.m_emitcost()))); // UNLOCK THE FUNDS FOR REINBURSEMENT
2064 		require(seize  (workerpoolOwner,         workerpoolStake));
2065 		// put workerpoolOwner stake seize into iexecHub address for bonus for scheduler on next well finalized Task
2066 		require(reward (this,                    workerpoolStake));
2067 		require(lock   (this,                    workerpoolStake));
2068 
2069 		emit WorkOrderClaimed(_woid, workorder.m_workerpool());
2070 		return true;
2071 	}
2072 
2073 	function finalizeWorkOrder(
2074 		address _woid,
2075 		string  _stdout,
2076 		string  _stderr,
2077 		string  _uri)
2078 	public onlyRegisteredWoid(_woid) returns (bool)
2079 	{
2080 		WorkOrder workorder = WorkOrder(_woid);
2081 		require(workorder.m_workerpool() == msg.sender);
2082 		require(workorder.m_status()     == IexecLib.WorkOrderStatusEnum.REVEALING);
2083 
2084 		// APP
2085 		App     app      = App(workorder.m_app());
2086 		uint256 appPrice = app.m_appPrice();
2087 		if (appPrice > 0)
2088 		{
2089 			require(reward(app.m_owner(), appPrice));
2090 		}
2091 
2092 		// DATASET
2093 		Dataset dataset = Dataset(workorder.m_dataset());
2094 		if (dataset != address(0))
2095 		{
2096 			uint256 datasetPrice = dataset.m_datasetPrice();
2097 			if (datasetPrice > 0)
2098 			{
2099 				require(reward(dataset.m_owner(), datasetPrice));
2100 			}
2101 		}
2102 
2103 		// WORKERPOOL → rewarding done by the caller itself
2104 
2105 		/**
2106 		 * seize stacked funds from requester.
2107 		 * reward = value: was locked at market making
2108 		 * emitcost: was locked at when emiting the workorder
2109 		 */
2110 		/* uint256 value           = marketplace.getMarketOrderValue(workorder.m_marketorderIdx()); // revert if not exist */
2111 		/* address workerpoolOwner = marketplace.getMarketOrderWorkerpoolOwner(workorder.m_marketorderIdx()); // revert if not exist */
2112 		uint256 value;
2113 		address workerpoolOwner;
2114 		(,,,value,,,,workerpoolOwner) = marketplace.getMarketOrder(workorder.m_marketorderIdx()); // Single call cost less gas
2115 		uint256 workerpoolStake       = value.percentage(marketplace.ASK_STAKE_RATIO());
2116 
2117 		require(seize (workorder.m_requester(), value.add(workorder.m_emitcost()))); // seize funds for payment (market value + emitcost)
2118 		require(unlock(workerpoolOwner,         workerpoolStake)); // unlock scheduler stake
2119 
2120 		// write results
2121 		workorder.setResult(_stdout, _stderr, _uri); // revert on error
2122 
2123 		// Rien ne se perd, rien ne se crée, tout se transfere
2124 		// distribute bonus to scheduler. jackpot bonus come from scheduler stake loose on IexecHub contract
2125 		// we reuse the varaible value for the kitty / fraction of the kitty (stack too deep)
2126 		/* (,value) = checkBalance(this); // kitty is locked on `this` wallet */
2127 		value = m_accounts[this].locked; // kitty is locked on `this` wallet
2128 		if(value > 0)
2129 		{
2130 			value = value.min(value.percentage(STAKE_BONUS_RATIO).max(STAKE_BONUS_MIN_THRESHOLD));
2131 			require(seize(this,             value));
2132 			require(reward(workerpoolOwner, value));
2133 		}
2134 
2135 		emit WorkOrderCompleted(_woid, workorder.m_workerpool());
2136 		return true;
2137 	}
2138 
2139 	/**
2140 	 * Views
2141 	 */
2142 	function getCategoryWorkClockTimeRef(uint256 _catId) public view returns (uint256 workClockTimeRef)
2143 	{
2144 		require(existingCategory(_catId));
2145 		return m_categories[_catId].workClockTimeRef;
2146 	}
2147 
2148 	function existingCategory(uint256 _catId) public view  returns (bool categoryExist)
2149 	{
2150 		return m_categories[_catId].catid > 0;
2151 	}
2152 
2153 	function getCategory(uint256 _catId) public view returns (uint256 catid, string name, string  description, uint256 workClockTimeRef)
2154 	{
2155 		require(existingCategory(_catId));
2156 		return (
2157 			m_categories[_catId].catid,
2158 			m_categories[_catId].name,
2159 			m_categories[_catId].description,
2160 			m_categories[_catId].workClockTimeRef
2161 		);
2162 	}
2163 
2164 	function getWorkerStatus(address _worker) public view returns (address workerPool, uint256 workerScore)
2165 	{
2166 		return (workerPoolHub.getWorkerAffectation(_worker), m_scores[_worker]);
2167 	}
2168 
2169 	function getWorkerScore(address _worker) public view returns (uint256 workerScore)
2170 	{
2171 		return m_scores[_worker];
2172 	}
2173 
2174 	/**
2175 	 * Worker subscription
2176 	 */
2177 	function registerToPool(address _worker) public returns (bool subscribed)
2178 	// msg.sender = workerPool
2179 	{
2180 		WorkerPool workerpool = WorkerPool(msg.sender);
2181 		// Check credentials
2182 		require(workerPoolHub.isWorkerPoolRegistered(msg.sender));
2183 		// Lock worker deposit
2184 		require(lock(_worker, workerpool.m_subscriptionLockStakePolicy()));
2185 		// Check subscription policy
2186 		require(m_accounts[_worker].stake >= workerpool.m_subscriptionMinimumStakePolicy());
2187 		require(m_scores[_worker]         >= workerpool.m_subscriptionMinimumScorePolicy());
2188 		// Update affectation
2189 		require(workerPoolHub.registerWorkerAffectation(msg.sender, _worker));
2190 		// Trigger event notice
2191 		emit WorkerPoolSubscription(msg.sender, _worker);
2192 		return true;
2193 	}
2194 
2195 	function unregisterFromPool(address _worker) public returns (bool unsubscribed)
2196 	// msg.sender = workerPool
2197 	{
2198 		require(removeWorker(msg.sender, _worker));
2199 		// Trigger event notice
2200 		emit WorkerPoolUnsubscription(msg.sender, _worker);
2201 		return true;
2202 	}
2203 
2204 	function evictWorker(address _worker) public returns (bool unsubscribed)
2205 	// msg.sender = workerpool
2206 	{
2207 		require(removeWorker(msg.sender, _worker));
2208 		// Trigger event notice
2209 		emit WorkerPoolEviction(msg.sender, _worker);
2210 		return true;
2211 	}
2212 
2213 	function removeWorker(address _workerpool, address _worker) internal returns (bool unsubscribed)
2214 	{
2215 		WorkerPool workerpool = WorkerPool(_workerpool);
2216 		// Check credentials
2217 		require(workerPoolHub.isWorkerPoolRegistered(_workerpool));
2218 		// Unlick worker stake
2219 		require(unlock(_worker, workerpool.m_subscriptionLockStakePolicy()));
2220 		// Update affectation
2221 		require(workerPoolHub.unregisterWorkerAffectation(_workerpool, _worker));
2222 		return true;
2223 	}
2224 
2225 	/**
2226 	 * Stake, reward and penalty functions
2227 	 */
2228 	/* Marketplace */
2229 	function lockForOrder(address _user, uint256 _amount) public onlyMarketplace returns (bool)
2230 	{
2231 		require(lock(_user, _amount));
2232 		return true;
2233 	}
2234 	function unlockForOrder(address _user, uint256 _amount) public  onlyMarketplace returns (bool)
2235 	{
2236 		require(unlock(_user, _amount));
2237 		return true;
2238 	}
2239 	/* Work */
2240 	function lockForWork(address _woid, address _user, uint256 _amount) public onlyRegisteredWoid(_woid) returns (bool)
2241 	{
2242 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
2243 		require(lock(_user, _amount));
2244 		return true;
2245 	}
2246 	function unlockForWork(address _woid, address _user, uint256 _amount) public onlyRegisteredWoid(_woid) returns (bool)
2247 	{
2248 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
2249 		require(unlock(_user, _amount));
2250 		return true;
2251 	}
2252 	function rewardForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public onlyRegisteredWoid(_woid) returns (bool)
2253 	{
2254 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
2255 		require(reward(_worker, _amount));
2256 		if (_reputation)
2257 		{
2258 			m_contributionHistory.success = m_contributionHistory.success.add(1);
2259 			m_scores[_worker] = m_scores[_worker].add(1);
2260 			emit AccurateContribution(_woid, _worker);
2261 		}
2262 		return true;
2263 	}
2264 	function seizeForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public onlyRegisteredWoid(_woid) returns (bool)
2265 	{
2266 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
2267 		require(seize(_worker, _amount));
2268 		if (_reputation)
2269 		{
2270 			m_contributionHistory.failed = m_contributionHistory.failed.add(1);
2271 			m_scores[_worker] = m_scores[_worker].sub(m_scores[_worker].min(SCORE_UNITARY_SLASH));
2272 			emit FaultyContribution(_woid, _worker);
2273 		}
2274 		return true;
2275 	}
2276 	/**
2277 	 * Wallet methods: public
2278 	 */
2279 	function deposit(uint256 _amount) external returns (bool)
2280 	{
2281 		require(rlc.transferFrom(msg.sender, address(this), _amount));
2282 		m_accounts[msg.sender].stake = m_accounts[msg.sender].stake.add(_amount);
2283 		emit Deposit(msg.sender, _amount);
2284 		return true;
2285 	}
2286 	function withdraw(uint256 _amount) external returns (bool)
2287 	{
2288 		m_accounts[msg.sender].stake = m_accounts[msg.sender].stake.sub(_amount);
2289 		require(rlc.transfer(msg.sender, _amount));
2290 		emit Withdraw(msg.sender, _amount);
2291 		return true;
2292 	}
2293 	function checkBalance(address _owner) public view returns (uint256 stake, uint256 locked)
2294 	{
2295 		return (m_accounts[_owner].stake, m_accounts[_owner].locked);
2296 	}
2297 	/**
2298 	 * Wallet methods: Internal
2299 	 */
2300 	function reward(address _user, uint256 _amount) internal returns (bool)
2301 	{
2302 		m_accounts[_user].stake = m_accounts[_user].stake.add(_amount);
2303 		emit Reward(_user, _amount);
2304 		return true;
2305 	}
2306 	function seize(address _user, uint256 _amount) internal returns (bool)
2307 	{
2308 		m_accounts[_user].locked = m_accounts[_user].locked.sub(_amount);
2309 		emit Seize(_user, _amount);
2310 		return true;
2311 	}
2312 	function lock(address _user, uint256 _amount) internal returns (bool)
2313 	{
2314 		m_accounts[_user].stake  = m_accounts[_user].stake.sub(_amount);
2315 		m_accounts[_user].locked = m_accounts[_user].locked.add(_amount);
2316 		return true;
2317 	}
2318 	function unlock(address _user, uint256 _amount) internal returns (bool)
2319 	{
2320 		m_accounts[_user].locked = m_accounts[_user].locked.sub(_amount);
2321 		m_accounts[_user].stake  = m_accounts[_user].stake.add(_amount);
2322 		return true;
2323 	}
2324 }