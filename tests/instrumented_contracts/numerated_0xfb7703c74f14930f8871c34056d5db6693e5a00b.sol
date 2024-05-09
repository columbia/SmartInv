1 //v1.0.14
2 //License: Apache2.0
3 pragma solidity ^0.4.21;
4 
5 library IexecLib
6 {
7 	/***************************************************************************/
8 	/*                              Market Order                               */
9 	/***************************************************************************/
10 	enum MarketOrderDirectionEnum
11 	{
12 		UNSET,
13 		BID,
14 		ASK,
15 		CLOSED
16 	}
17 	struct MarketOrder
18 	{
19 		MarketOrderDirectionEnum direction;
20 		uint256 category;        // runtime selection
21 		uint256 trust;           // for PoCo
22 		uint256 value;           // value/cost/price
23 		uint256 volume;          // quantity of instances (total)
24 		uint256 remaining;       // remaining instances
25 		address workerpool;      // BID can use null for any
26 		address workerpoolOwner; // fix ownership if workerpool ownership change during the workorder steps
27 	}
28 
29 	/***************************************************************************/
30 	/*                               Work Order                                */
31 	/***************************************************************************/
32 	enum WorkOrderStatusEnum
33 	{
34 		UNSET,     // Work order not yet initialized (invalid address)
35 		ACTIVE,    // Marketed → constributions are open
36 		REVEALING, // Starting consensus reveal
37 		CLAIMED,   // failed consensus
38 		COMPLETED  // Concensus achieved
39 	}
40 
41 	/***************************************************************************/
42 	/*                                Consensus                                */
43 	/*                                   ---                                   */
44 	/*                         used in WorkerPool.sol                          */
45 	/***************************************************************************/
46 	struct Consensus
47 	{
48 		uint256 poolReward;
49 		uint256 stakeAmount;
50 		bytes32 consensus;
51 		uint256 revealDate;
52 		uint256 revealCounter;
53 		uint256 consensusTimeout;
54 		uint256 winnerCount;
55 		address[] contributors;
56 		address workerpoolOwner;
57 		uint256 schedulerRewardRatioPolicy;
58 
59 	}
60 
61 	/***************************************************************************/
62 	/*                              Contribution                               */
63 	/*                                   ---                                   */
64 	/*                         used in WorkerPool.sol                          */
65 	/***************************************************************************/
66 	enum ContributionStatusEnum
67 	{
68 		UNSET,
69 		AUTHORIZED,
70 		CONTRIBUTED,
71 		PROVED,
72 		REJECTED
73 	}
74 	struct Contribution
75 	{
76 		ContributionStatusEnum status;
77 		bytes32 resultHash;
78 		bytes32 resultSign;
79 		address enclaveChallenge;
80 		uint256 score;
81 		uint256 weight;
82 	}
83 
84 	/***************************************************************************/
85 	/*                Account / ContributionHistory / Category                 */
86 	/*                                   ---                                   */
87 	/*                          used in IexecHub.sol                           */
88 	/***************************************************************************/
89 	struct Account
90 	{
91 		uint256 stake;
92 		uint256 locked;
93 	}
94 
95 	struct ContributionHistory // for credibility computation, f = failed/total
96 	{
97 		uint256 success;
98 		uint256 failed;
99 	}
100 
101 	struct Category
102 	{
103 		uint256 catid;
104 		string  name;
105 		string  description;
106 		uint256 workClockTimeRef;
107 	}
108 
109 }
110 
111 
112 pragma solidity ^0.4.8;
113 
114 contract TokenSpender {
115     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
116 }
117 
118 pragma solidity ^0.4.8;
119 
120 contract ERC20 {
121   uint public totalSupply;
122   function balanceOf(address who) constant returns (uint);
123   function allowance(address owner, address spender) constant returns (uint);
124 
125   function transfer(address to, uint value) returns (bool ok);
126   function transferFrom(address from, address to, uint value) returns (bool ok);
127   function approve(address spender, uint value) returns (bool ok);
128   event Transfer(address indexed from, address indexed to, uint value);
129   event Approval(address indexed owner, address indexed spender, uint value);
130 }
131 
132 pragma solidity ^0.4.21;
133 
134 
135 /**
136  * @title SafeMath
137  * @dev Math operations with safety checks that throw on error
138  * last open zepplin version used for : add sub mul div function : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
139 * commit : https://github.com/OpenZeppelin/zeppelin-solidity/commit/815d9e1f457f57cfbb1b4e889f2255c9a517f661
140  */
141 library SafeMathOZ
142 {
143 	function add(uint256 a, uint256 b) internal pure returns (uint256)
144 	{
145 		uint256 c = a + b;
146 		assert(c >= a);
147 		return c;
148 	}
149 
150 	function sub(uint256 a, uint256 b) internal pure returns (uint256)
151 	{
152 		assert(b <= a);
153 		return a - b;
154 	}
155 
156 	function mul(uint256 a, uint256 b) internal pure returns (uint256)
157 	{
158 		if (a == 0)
159 		{
160 			return 0;
161 		}
162 		uint256 c = a * b;
163 		assert(c / a == b);
164 		return c;
165 	}
166 
167 	function div(uint256 a, uint256 b) internal pure returns (uint256)
168 	{
169 		// assert(b > 0); // Solidity automatically throws when dividing by 0
170 		uint256 c = a / b;
171 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
172 		return c;
173 	}
174 
175 	function max(uint256 a, uint256 b) internal pure returns (uint256)
176 	{
177 		return a >= b ? a : b;
178 	}
179 
180 	function min(uint256 a, uint256 b) internal pure returns (uint256)
181 	{
182 		return a < b ? a : b;
183 	}
184 
185 	function mulByFraction(uint256 a, uint256 b, uint256 c) internal pure returns (uint256)
186 	{
187 		return div(mul(a, b), c);
188 	}
189 
190 	function percentage(uint256 a, uint256 b) internal pure returns (uint256)
191 	{
192 		return mulByFraction(a, b, 100);
193 	}
194 	// Source : https://ethereum.stackexchange.com/questions/8086/logarithm-math-operation-in-solidity
195 	function log(uint x) internal pure returns (uint y)
196 	{
197 		assembly
198 		{
199 			let arg := x
200 			x := sub(x,1)
201 			x := or(x, div(x, 0x02))
202 			x := or(x, div(x, 0x04))
203 			x := or(x, div(x, 0x10))
204 			x := or(x, div(x, 0x100))
205 			x := or(x, div(x, 0x10000))
206 			x := or(x, div(x, 0x100000000))
207 			x := or(x, div(x, 0x10000000000000000))
208 			x := or(x, div(x, 0x100000000000000000000000000000000))
209 			x := add(x, 1)
210 			let m := mload(0x40)
211 			mstore(m,           0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
212 			mstore(add(m,0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
213 			mstore(add(m,0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
214 			mstore(add(m,0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
215 			mstore(add(m,0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
216 			mstore(add(m,0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
217 			mstore(add(m,0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
218 			mstore(add(m,0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
219 			mstore(0x40, add(m, 0x100))
220 			let magic := 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
221 			let shift := 0x100000000000000000000000000000000000000000000000000000000000000
222 			let a := div(mul(x, magic), shift)
223 			y := div(mload(add(m,sub(255,a))), shift)
224 			y := add(y, mul(256, gt(arg, 0x8000000000000000000000000000000000000000000000000000000000000000)))
225 		}
226 	}
227 }
228 
229 
230 pragma solidity ^0.4.8;
231 
232 contract SafeMath {
233   function safeMul(uint a, uint b) internal returns (uint) {
234     uint c = a * b;
235     assert(a == 0 || c / a == b);
236     return c;
237   }
238 
239   function safeDiv(uint a, uint b) internal returns (uint) {
240     assert(b > 0);
241     uint c = a / b;
242     assert(a == b * c + a % b);
243     return c;
244   }
245 
246   function safeSub(uint a, uint b) internal returns (uint) {
247     assert(b <= a);
248     return a - b;
249   }
250 
251   function safeAdd(uint a, uint b) internal returns (uint) {
252     uint c = a + b;
253     assert(c>=a && c>=b);
254     return c;
255   }
256 
257   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
258     return a >= b ? a : b;
259   }
260 
261   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
262     return a < b ? a : b;
263   }
264 
265   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
266     return a >= b ? a : b;
267   }
268 
269   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
270     return a < b ? a : b;
271   }
272 
273   function assert(bool assertion) internal {
274     if (!assertion) {
275       throw;
276     }
277   }
278 }
279 
280 
281 pragma solidity ^0.4.21;
282 
283 /**
284  * @title Ownable
285  * @dev The Ownable contract has an owner address, and provides basic authorization control
286  * functions, this simplifies the implementation of "user permissions".
287  */
288 contract OwnableOZ
289 {
290 	address public m_owner;
291 	bool    public m_changeable;
292 
293 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294 
295 	/**
296 	 * @dev Throws if called by any account other than the owner.
297 	 */
298 	modifier onlyOwner()
299 	{
300 		require(msg.sender == m_owner);
301 		_;
302 	}
303 
304 	/**
305 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
306 	 * account.
307 	 */
308 	function OwnableOZ() public
309 	{
310 		m_owner      = msg.sender;
311 		m_changeable = true;
312 	}
313 
314 	/**
315 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
316 	 * @param _newOwner The address to transfer ownership to.
317 	 */
318 	function setImmutableOwnership(address _newOwner) public onlyOwner
319 	{
320 		require(m_changeable);
321 		require(_newOwner != address(0));
322 		emit OwnershipTransferred(m_owner, _newOwner);
323 		m_owner      = _newOwner;
324 		m_changeable = false;
325 	}
326 
327 }
328 
329 
330 pragma solidity ^0.4.8;
331 
332 contract Ownable {
333   address public owner;
334 
335   function Ownable() {
336     owner = msg.sender;
337   }
338 
339   modifier onlyOwner() {
340     if (msg.sender == owner)
341       _;
342   }
343 
344   function transferOwnership(address newOwner) onlyOwner {
345     if (newOwner != address(0)) owner = newOwner;
346   }
347 
348 }
349 
350 
351 
352 pragma solidity ^0.4.8;
353 
354 contract RLC is ERC20, SafeMath, Ownable {
355 
356     /* Public variables of the token */
357   string public name;       //fancy name
358   string public symbol;
359   uint8 public decimals;    //How many decimals to show.
360   string public version = 'v0.1';
361   uint public initialSupply;
362   uint public totalSupply;
363   bool public locked;
364   //uint public unlockBlock;
365 
366   mapping(address => uint) balances;
367   mapping (address => mapping (address => uint)) allowed;
368 
369   // lock transfer during the ICO
370   modifier onlyUnlocked() {
371     if (msg.sender != owner && locked) throw;
372     _;
373   }
374 
375   /*
376    *  The RLC Token created with the time at which the crowdsale end
377    */
378 
379   function RLC() {
380     // lock the transfer function during the crowdsale
381     locked = true;
382     //unlockBlock=  now + 45 days; // (testnet) - for mainnet put the block number
383 
384     initialSupply = 87000000000000000;
385     totalSupply = initialSupply;
386     balances[msg.sender] = initialSupply;// Give the creator all initial tokens
387     name = 'iEx.ec Network Token';        // Set the name for display purposes
388     symbol = 'RLC';                       // Set the symbol for display purposes
389     decimals = 9;                        // Amount of decimals for display purposes
390   }
391 
392   function unlock() onlyOwner {
393     locked = false;
394   }
395 
396   function burn(uint256 _value) returns (bool){
397     balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
398     totalSupply = safeSub(totalSupply, _value);
399     Transfer(msg.sender, 0x0, _value);
400     return true;
401   }
402 
403   function transfer(address _to, uint _value) onlyUnlocked returns (bool) {
404     balances[msg.sender] = safeSub(balances[msg.sender], _value);
405     balances[_to] = safeAdd(balances[_to], _value);
406     Transfer(msg.sender, _to, _value);
407     return true;
408   }
409 
410   function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool) {
411     var _allowance = allowed[_from][msg.sender];
412 
413     balances[_to] = safeAdd(balances[_to], _value);
414     balances[_from] = safeSub(balances[_from], _value);
415     allowed[_from][msg.sender] = safeSub(_allowance, _value);
416     Transfer(_from, _to, _value);
417     return true;
418   }
419 
420   function balanceOf(address _owner) constant returns (uint balance) {
421     return balances[_owner];
422   }
423 
424   function approve(address _spender, uint _value) returns (bool) {
425     allowed[msg.sender][_spender] = _value;
426     Approval(msg.sender, _spender, _value);
427     return true;
428   }
429 
430     /* Approve and then comunicate the approved contract in a single tx */
431   function approveAndCall(address _spender, uint256 _value, bytes _extraData){
432       TokenSpender spender = TokenSpender(_spender);
433       if (approve(_spender, _value)) {
434           spender.receiveApproval(msg.sender, _value, this, _extraData);
435       }
436   }
437 
438   function allowance(address _owner, address _spender) constant returns (uint remaining) {
439     return allowed[_owner][_spender];
440   }
441 
442 }
443 
444 
445 
446 pragma solidity ^0.4.21;
447 
448 contract IexecHubInterface
449 {
450 	RLC public rlc;
451 
452 	function attachContracts(
453 		address _tokenAddress,
454 		address _marketplaceAddress,
455 		address _workerPoolHubAddress,
456 		address _appHubAddress,
457 		address _datasetHubAddress)
458 		public;
459 
460 	function setCategoriesCreator(
461 		address _categoriesCreator)
462 	public;
463 
464 	function createCategory(
465 		string  _name,
466 		string  _description,
467 		uint256 _workClockTimeRef)
468 	public returns (uint256 catid);
469 
470 	function createWorkerPool(
471 		string  _description,
472 		uint256 _subscriptionLockStakePolicy,
473 		uint256 _subscriptionMinimumStakePolicy,
474 		uint256 _subscriptionMinimumScorePolicy)
475 	external returns (address createdWorkerPool);
476 
477 	function createApp(
478 		string  _appName,
479 		uint256 _appPrice,
480 		string  _appParams)
481 	external returns (address createdApp);
482 
483 	function createDataset(
484 		string  _datasetName,
485 		uint256 _datasetPrice,
486 		string  _datasetParams)
487 	external returns (address createdDataset);
488 
489 	function buyForWorkOrder(
490 		uint256 _marketorderIdx,
491 		address _workerpool,
492 		address _app,
493 		address _dataset,
494 		string  _params,
495 		address _callback,
496 		address _beneficiary)
497 	external returns (address);
498 
499 	function isWoidRegistred(
500 		address _woid)
501 	public view returns (bool);
502 
503 	function lockWorkOrderCost(
504 		address _requester,
505 		address _workerpool, // Address of a smartcontract
506 		address _app,        // Address of a smartcontract
507 		address _dataset)    // Address of a smartcontract
508 	internal returns (uint256);
509 
510 	function claimFailedConsensus(
511 		address _woid)
512 	public returns (bool);
513 
514 	function finalizeWorkOrder(
515 		address _woid,
516 		string  _stdout,
517 		string  _stderr,
518 		string  _uri)
519 	public returns (bool);
520 
521 	function getCategoryWorkClockTimeRef(
522 		uint256 _catId)
523 	public view returns (uint256 workClockTimeRef);
524 
525 	function existingCategory(
526 		uint256 _catId)
527 	public view  returns (bool categoryExist);
528 
529 	function getCategory(
530 		uint256 _catId)
531 		public view returns (uint256 catid, string name, string  description, uint256 workClockTimeRef);
532 
533 	function getWorkerStatus(
534 		address _worker)
535 	public view returns (address workerPool, uint256 workerScore);
536 
537 	function getWorkerScore(address _worker) public view returns (uint256 workerScore);
538 
539 	function registerToPool(address _worker) public returns (bool subscribed);
540 
541 	function unregisterFromPool(address _worker) public returns (bool unsubscribed);
542 
543 	function evictWorker(address _worker) public returns (bool unsubscribed);
544 
545 	function removeWorker(address _workerpool, address _worker) internal returns (bool unsubscribed);
546 
547 	function lockForOrder(address _user, uint256 _amount) public returns (bool);
548 
549 	function unlockForOrder(address _user, uint256 _amount) public returns (bool);
550 
551 	function lockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
552 
553 	function unlockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
554 
555 	function rewardForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
556 
557 	function seizeForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
558 
559 	function deposit(uint256 _amount) external returns (bool);
560 
561 	function withdraw(uint256 _amount) external returns (bool);
562 
563 	function checkBalance(address _owner) public view returns (uint256 stake, uint256 locked);
564 
565 	function reward(address _user, uint256 _amount) internal returns (bool);
566 
567 	function seize(address _user, uint256 _amount) internal returns (bool);
568 
569 	function lock(address _user, uint256 _amount) internal returns (bool);
570 
571 	function unlock(address _user, uint256 _amount) internal returns (bool);
572 }
573 
574 
575 
576 pragma solidity ^0.4.21;
577 
578 
579 contract IexecHubAccessor
580 {
581 	IexecHubInterface internal iexecHubInterface;
582 
583 	modifier onlyIexecHub()
584 	{
585 		require(msg.sender == address(iexecHubInterface));
586 		_;
587 	}
588 
589 	function IexecHubAccessor(address _iexecHubAddress) public
590 	{
591 		require(_iexecHubAddress != address(0));
592 		iexecHubInterface = IexecHubInterface(_iexecHubAddress);
593 	}
594 
595 }
596 
597 
598 pragma solidity ^0.4.21;
599 
600 contract MarketplaceInterface
601 {
602 	function createMarketOrder(
603 		IexecLib.MarketOrderDirectionEnum _direction,
604 		uint256 _category,
605 		uint256 _trust,
606 		uint256 _value,
607 		address _workerpool,
608 		uint256 _volume)
609 	public returns (uint);
610 
611 	function closeMarketOrder(
612 		uint256 _marketorderIdx)
613 	public returns (bool);
614 
615 	function getMarketOrderValue(
616 		uint256 _marketorderIdx)
617 	public view returns(uint256);
618 
619 	function getMarketOrderWorkerpoolOwner(
620 		uint256 _marketorderIdx)
621 	public view returns(address);
622 
623 	function getMarketOrderCategory(
624 		uint256 _marketorderIdx)
625 	public view returns (uint256);
626 
627 	function getMarketOrderTrust(
628 		uint256 _marketorderIdx)
629 	public view returns(uint256);
630 
631 	function getMarketOrder(
632 		uint256 _marketorderIdx)
633 	public view returns(
634 		IexecLib.MarketOrderDirectionEnum direction,
635 		uint256 category,       // runtime selection
636 		uint256 trust,          // for PoCo
637 		uint256 value,          // value/cost/price
638 		uint256 volume,         // quantity of instances (total)
639 		uint256 remaining,      // remaining instances
640 		address workerpool);    // BID can use null for any
641 }
642 
643 
644 pragma solidity ^0.4.21;
645 
646 contract MarketplaceAccessor
647 {
648 	address              internal marketplaceAddress;
649 	MarketplaceInterface internal marketplaceInterface;
650 /* not used
651 	modifier onlyMarketplace()
652 	{
653 		require(msg.sender == marketplaceAddress);
654 		_;
655 	}*/
656 
657 	function MarketplaceAccessor(address _marketplaceAddress) public
658 	{
659 		require(_marketplaceAddress != address(0));
660 		marketplaceAddress   = _marketplaceAddress;
661 		marketplaceInterface = MarketplaceInterface(_marketplaceAddress);
662 	}
663 }
664 
665 pragma solidity ^0.4.21;
666 
667 contract WorkOrder
668 {
669 
670 
671 	event WorkOrderActivated();
672 	event WorkOrderReActivated();
673 	event WorkOrderRevealing();
674 	event WorkOrderClaimed  ();
675 	event WorkOrderCompleted();
676 
677 	/**
678 	 * Members
679 	 */
680 	IexecLib.WorkOrderStatusEnum public m_status;
681 
682 	uint256 public m_marketorderIdx;
683 
684 	address public m_app;
685 	address public m_dataset;
686 	address public m_workerpool;
687 	address public m_requester;
688 
689 	uint256 public m_emitcost;
690 	string  public m_params;
691 	address public m_callback;
692 	address public m_beneficiary;
693 
694 	bytes32 public m_resultCallbackProof;
695 	string  public m_stdout;
696 	string  public m_stderr;
697 	string  public m_uri;
698 
699 	address public m_iexecHubAddress;
700 
701 	modifier onlyIexecHub()
702 	{
703 		require(msg.sender == m_iexecHubAddress);
704 		_;
705 	}
706 
707 	/**
708 	 * Constructor
709 	 */
710 	function WorkOrder(
711 		uint256 _marketorderIdx,
712 		address _requester,
713 		address _app,
714 		address _dataset,
715 		address _workerpool,
716 		uint256 _emitcost,
717 		string  _params,
718 		address _callback,
719 		address _beneficiary)
720 	public
721 	{
722 		m_iexecHubAddress = msg.sender;
723 		require(_requester != address(0));
724 		m_status         = IexecLib.WorkOrderStatusEnum.ACTIVE;
725 		m_marketorderIdx = _marketorderIdx;
726 		m_app            = _app;
727 		m_dataset        = _dataset;
728 		m_workerpool     = _workerpool;
729 		m_requester      = _requester;
730 		m_emitcost       = _emitcost;
731 		m_params         = _params;
732 		m_callback       = _callback;
733 		m_beneficiary    = _beneficiary;
734 		// needed for the scheduler to authorize api token access on this m_beneficiary address in case _requester is a smart contract.
735 	}
736 
737 	function startRevealingPhase() public returns (bool)
738 	{
739 		require(m_workerpool == msg.sender);
740 		require(m_status == IexecLib.WorkOrderStatusEnum.ACTIVE);
741 		m_status = IexecLib.WorkOrderStatusEnum.REVEALING;
742 		emit WorkOrderRevealing();
743 		return true;
744 	}
745 
746 	function reActivate() public returns (bool)
747 	{
748 		require(m_workerpool == msg.sender);
749 		require(m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
750 		m_status = IexecLib.WorkOrderStatusEnum.ACTIVE;
751 		emit WorkOrderReActivated();
752 		return true;
753 	}
754 
755 
756 	function claim() public onlyIexecHub
757 	{
758 		require(m_status == IexecLib.WorkOrderStatusEnum.ACTIVE || m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
759 		m_status = IexecLib.WorkOrderStatusEnum.CLAIMED;
760 		emit WorkOrderClaimed();
761 	}
762 
763 
764 	function setResult(string _stdout, string _stderr, string _uri) public onlyIexecHub
765 	{
766 		require(m_status == IexecLib.WorkOrderStatusEnum.REVEALING);
767 		m_status = IexecLib.WorkOrderStatusEnum.COMPLETED;
768 		m_stdout = _stdout;
769 		m_stderr = _stderr;
770 		m_uri    = _uri;
771 		m_resultCallbackProof =keccak256(_stdout,_stderr,_uri);
772 		emit WorkOrderCompleted();
773 	}
774 
775 }
776 
777 
778 pragma solidity ^0.4.21;
779 
780 
781 contract App is OwnableOZ, IexecHubAccessor
782 {
783 
784 	/**
785 	 * Members
786 	 */
787 	string        public m_appName;
788 	uint256       public m_appPrice;
789 	string        public m_appParams;
790 
791 	/**
792 	 * Constructor
793 	 */
794 	function App(
795 		address _iexecHubAddress,
796 		string  _appName,
797 		uint256 _appPrice,
798 		string  _appParams)
799 	IexecHubAccessor(_iexecHubAddress)
800 	public
801 	{
802 		// tx.origin == owner
803 		// msg.sender == DatasetHub
804 		require(tx.origin != msg.sender);
805 		setImmutableOwnership(tx.origin); // owner → tx.origin
806 
807 		m_appName   = _appName;
808 		m_appPrice  = _appPrice;
809 		m_appParams = _appParams;
810 
811 	}
812 
813 
814 
815 }
816 
817 
818 pragma solidity ^0.4.21;
819 
820 
821 contract AppHub is OwnableOZ // is Owned by IexecHub
822 {
823 
824 	using SafeMathOZ for uint256;
825 
826 	/**
827 	 * Members
828 	 */
829 	mapping(address => uint256)                     m_appCountByOwner;
830 	mapping(address => mapping(uint256 => address)) m_appByOwnerByIndex;
831 	mapping(address => bool)                        m_appRegistered;
832 
833 	mapping(uint256 => address)                     m_appByIndex;
834 	uint256 public                                  m_totalAppCount;
835 
836 	/**
837 	 * Constructor
838 	 */
839 	function AppHub() public
840 	{
841 	}
842 
843 	/**
844 	 * Methods
845 	 */
846 	function isAppRegistered(address _app) public view returns (bool)
847 	{
848 		return m_appRegistered[_app];
849 	}
850 	function getAppsCount(address _owner) public view returns (uint256)
851 	{
852 		return m_appCountByOwner[_owner];
853 	}
854 	function getApp(address _owner, uint256 _index) public view returns (address)
855 	{
856 		return m_appByOwnerByIndex[_owner][_index];
857 	}
858 	function getAppByIndex(uint256 _index) public view returns (address)
859 	{
860 		return m_appByIndex[_index];
861 	}
862 
863 	function addApp(address _owner, address _app) internal
864 	{
865 		uint id = m_appCountByOwner[_owner].add(1);
866 		m_totalAppCount=m_totalAppCount.add(1);
867 		m_appByIndex       [m_totalAppCount] = _app;
868 		m_appCountByOwner  [_owner]          = id;
869 		m_appByOwnerByIndex[_owner][id]      = _app;
870 		m_appRegistered    [_app]            = true;
871 	}
872 
873 	function createApp(
874 		string  _appName,
875 		uint256 _appPrice,
876 		string  _appParams)
877 	public onlyOwner /*owner == IexecHub*/ returns (address createdApp)
878 	{
879 		// tx.origin == owner
880 		// msg.sender == IexecHub
881 		address newApp = new App(
882 			msg.sender,
883 			_appName,
884 			_appPrice,
885 			_appParams
886 		);
887 		addApp(tx.origin, newApp);
888 		return newApp;
889 	}
890 
891 }
892 
893 pragma solidity ^0.4.21;
894 
895 
896 contract Dataset is OwnableOZ, IexecHubAccessor
897 {
898 
899 	/**
900 	 * Members
901 	 */
902 	string            public m_datasetName;
903 	uint256           public m_datasetPrice;
904 	string            public m_datasetParams;
905 
906 	/**
907 	 * Constructor
908 	 */
909 	function Dataset(
910 		address _iexecHubAddress,
911 		string  _datasetName,
912 		uint256 _datasetPrice,
913 		string  _datasetParams)
914 	IexecHubAccessor(_iexecHubAddress)
915 	public
916 	{
917 		// tx.origin == owner
918 		// msg.sender == DatasetHub
919 		require(tx.origin != msg.sender);
920 		setImmutableOwnership(tx.origin); // owner → tx.origin
921 
922 		m_datasetName   = _datasetName;
923 		m_datasetPrice  = _datasetPrice;
924 		m_datasetParams = _datasetParams;
925 
926 	}
927 
928 
929 }
930 
931 
932 pragma solidity ^0.4.21;
933 
934 
935 contract DatasetHub is OwnableOZ // is Owned by IexecHub
936 {
937 	using SafeMathOZ for uint256;
938 
939 	/**
940 	 * Members
941 	 */
942 	mapping(address => uint256)                     m_datasetCountByOwner;
943 	mapping(address => mapping(uint256 => address)) m_datasetByOwnerByIndex;
944 	mapping(address => bool)                        m_datasetRegistered;
945 
946 	mapping(uint256 => address)                     m_datasetByIndex;
947 	uint256 public                                  m_totalDatasetCount;
948 
949 
950 
951 	/**
952 	 * Constructor
953 	 */
954 	function DatasetHub() public
955 	{
956 	}
957 
958 	/**
959 	 * Methods
960 	 */
961 	function isDatasetRegistred(address _dataset) public view returns (bool)
962 	{
963 		return m_datasetRegistered[_dataset];
964 	}
965 	function getDatasetsCount(address _owner) public view returns (uint256)
966 	{
967 		return m_datasetCountByOwner[_owner];
968 	}
969 	function getDataset(address _owner, uint256 _index) public view returns (address)
970 	{
971 		return m_datasetByOwnerByIndex[_owner][_index];
972 	}
973 	function getDatasetByIndex(uint256 _index) public view returns (address)
974 	{
975 		return m_datasetByIndex[_index];
976 	}
977 
978 	function addDataset(address _owner, address _dataset) internal
979 	{
980 		uint id = m_datasetCountByOwner[_owner].add(1);
981 		m_totalDatasetCount = m_totalDatasetCount.add(1);
982 		m_datasetByIndex       [m_totalDatasetCount] = _dataset;
983 		m_datasetCountByOwner  [_owner]              = id;
984 		m_datasetByOwnerByIndex[_owner][id]          = _dataset;
985 		m_datasetRegistered    [_dataset]            = true;
986 	}
987 
988 	function createDataset(
989 		string _datasetName,
990 		uint256 _datasetPrice,
991 		string _datasetParams)
992 	public onlyOwner /*owner == IexecHub*/ returns (address createdDataset)
993 	{
994 		// tx.origin == owner
995 		// msg.sender == IexecHub
996 		address newDataset = new Dataset(
997 			msg.sender,
998 			_datasetName,
999 			_datasetPrice,
1000 			_datasetParams
1001 		);
1002 		addDataset(tx.origin, newDataset);
1003 		return newDataset;
1004 	}
1005 }
1006 
1007 
1008 pragma solidity ^0.4.21;
1009 
1010 contract WorkerPoolHub is OwnableOZ // is Owned by IexecHub
1011 {
1012 
1013 	using SafeMathOZ for uint256;
1014 
1015 	/**
1016 	 * Members
1017 	 */
1018 	// worker => workerPool
1019 	mapping(address => address)                     m_workerAffectation;
1020 	// owner => index
1021 	mapping(address => uint256)                     m_workerPoolCountByOwner;
1022 	// owner => index => workerPool
1023 	mapping(address => mapping(uint256 => address)) m_workerPoolByOwnerByIndex;
1024 	//  workerPool => owner // stored in the workerPool
1025 	/* mapping(address => address)                     m_ownerByWorkerPool; */
1026 	mapping(address => bool)                        m_workerPoolRegistered;
1027 
1028 	mapping(uint256 => address)                     m_workerPoolByIndex;
1029 	uint256 public                                  m_totalWorkerPoolCount;
1030 
1031 
1032 
1033 	/**
1034 	 * Constructor
1035 	 */
1036 	function WorkerPoolHub() public
1037 	{
1038 	}
1039 
1040 	/**
1041 	 * Methods
1042 	 */
1043 	function isWorkerPoolRegistered(address _workerPool) public view returns (bool)
1044 	{
1045 		return m_workerPoolRegistered[_workerPool];
1046 	}
1047 	function getWorkerPoolsCount(address _owner) public view returns (uint256)
1048 	{
1049 		return m_workerPoolCountByOwner[_owner];
1050 	}
1051 	function getWorkerPool(address _owner, uint256 _index) public view returns (address)
1052 	{
1053 		return m_workerPoolByOwnerByIndex[_owner][_index];
1054 	}
1055 	function getWorkerPoolByIndex(uint256 _index) public view returns (address)
1056 	{
1057 		return m_workerPoolByIndex[_index];
1058 	}
1059 	function getWorkerAffectation(address _worker) public view returns (address workerPool)
1060 	{
1061 		return m_workerAffectation[_worker];
1062 	}
1063 
1064 	function addWorkerPool(address _owner, address _workerPool) internal
1065 	{
1066 		uint id = m_workerPoolCountByOwner[_owner].add(1);
1067 		m_totalWorkerPoolCount = m_totalWorkerPoolCount.add(1);
1068 		m_workerPoolByIndex       [m_totalWorkerPoolCount] = _workerPool;
1069 		m_workerPoolCountByOwner  [_owner]                 = id;
1070 		m_workerPoolByOwnerByIndex[_owner][id]             = _workerPool;
1071 		m_workerPoolRegistered    [_workerPool]            = true;
1072 	}
1073 
1074 	function createWorkerPool(
1075 		string _description,
1076 		uint256 _subscriptionLockStakePolicy,
1077 		uint256 _subscriptionMinimumStakePolicy,
1078 		uint256 _subscriptionMinimumScorePolicy,
1079 		address _marketplaceAddress)
1080 	external onlyOwner /*owner == IexecHub*/ returns (address createdWorkerPool)
1081 	{
1082 		// tx.origin == owner
1083 		// msg.sender == IexecHub
1084 		// At creating ownership is transfered to tx.origin
1085 		address newWorkerPool = new WorkerPool(
1086 			msg.sender, // iexecHubAddress
1087 			_description,
1088 			_subscriptionLockStakePolicy,
1089 			_subscriptionMinimumStakePolicy,
1090 			_subscriptionMinimumScorePolicy,
1091 			_marketplaceAddress
1092 		);
1093 		addWorkerPool(tx.origin, newWorkerPool);
1094 		return newWorkerPool;
1095 	}
1096 
1097 	function registerWorkerAffectation(address _workerPool, address _worker) public onlyOwner /*owner == IexecHub*/ returns (bool subscribed)
1098 	{
1099 		// you must have no cuurent affectation on others worker Pool
1100 		require(m_workerAffectation[_worker] == address(0));
1101 		m_workerAffectation[_worker] = _workerPool;
1102 		return true;
1103 	}
1104 
1105 	function unregisterWorkerAffectation(address _workerPool, address _worker) public onlyOwner /*owner == IexecHub*/ returns (bool unsubscribed)
1106 	{
1107 		require(m_workerAffectation[_worker] == _workerPool);
1108 		m_workerAffectation[_worker] = address(0);
1109 		return true;
1110 	}
1111 }
1112 
1113 
1114 pragma solidity ^0.4.21;
1115 
1116 
1117 /**
1118  * @title IexecHub
1119  */
1120 
1121 contract IexecHub
1122 {
1123 	using SafeMathOZ for uint256;
1124 
1125 	/**
1126 	* RLC contract for token transfers.
1127 	*/
1128 	RLC public rlc;
1129 
1130 	uint256 public constant STAKE_BONUS_RATIO         = 10;
1131 	uint256 public constant STAKE_BONUS_MIN_THRESHOLD = 1000;
1132 	uint256 public constant SCORE_UNITARY_SLASH       = 50;
1133 
1134 	/**
1135 	 * Slaves contracts
1136 	 */
1137 	AppHub        public appHub;
1138 	DatasetHub    public datasetHub;
1139 	WorkerPoolHub public workerPoolHub;
1140 
1141 	/**
1142 	 * Market place
1143 	 */
1144 	Marketplace public marketplace;
1145 	modifier onlyMarketplace()
1146 	{
1147 		require(msg.sender == address(marketplace));
1148 		_;
1149 	}
1150 	/**
1151 	 * Categories
1152 	 */
1153 	mapping(uint256 => IexecLib.Category) public m_categories;
1154 	uint256                               public m_categoriesCount;
1155 	address                               public m_categoriesCreator;
1156 	modifier onlyCategoriesCreator()
1157 	{
1158 		require(msg.sender == m_categoriesCreator);
1159 		_;
1160 	}
1161 
1162 	/**
1163 	 * Escrow
1164 	 */
1165 	mapping(address => IexecLib.Account) public m_accounts;
1166 
1167 
1168 	/**
1169 	 * workOrder Registered
1170 	 */
1171 	mapping(address => bool) public m_woidRegistered;
1172 	modifier onlyRegisteredWoid(address _woid)
1173 	{
1174 		require(m_woidRegistered[_woid]);
1175 		_;
1176 	}
1177 
1178 	/**
1179 	 * Reputation for PoCo
1180 	 */
1181 	mapping(address => uint256)  public m_scores;
1182 	IexecLib.ContributionHistory public m_contributionHistory;
1183 
1184 
1185 	event WorkOrderActivated(address woid, address indexed workerPool);
1186 	event WorkOrderClaimed  (address woid, address workerPool);
1187 	event WorkOrderCompleted(address woid, address workerPool);
1188 
1189 	event CreateApp       (address indexed appOwner,        address indexed app,        string appName,     uint256 appPrice,     string appParams    );
1190 	event CreateDataset   (address indexed datasetOwner,    address indexed dataset,    string datasetName, uint256 datasetPrice, string datasetParams);
1191 	event CreateWorkerPool(address indexed workerPoolOwner, address indexed workerPool, string workerPoolDescription                                        );
1192 
1193 	event CreateCategory  (uint256 catid, string name, string description, uint256 workClockTimeRef);
1194 
1195 	event WorkerPoolSubscription  (address indexed workerPool, address worker);
1196 	event WorkerPoolUnsubscription(address indexed workerPool, address worker);
1197 	event WorkerPoolEviction      (address indexed workerPool, address worker);
1198 
1199 	event AccurateContribution(address woid, address indexed worker);
1200 	event FaultyContribution  (address woid, address indexed worker);
1201 
1202 	event Deposit (address owner, uint256 amount);
1203 	event Withdraw(address owner, uint256 amount);
1204 	event Reward  (address user,  uint256 amount);
1205 	event Seize   (address user,  uint256 amount);
1206 
1207 	/**
1208 	 * Constructor
1209 	 */
1210 	function IexecHub()
1211 	public
1212 	{
1213 		m_categoriesCreator = msg.sender;
1214 	}
1215 
1216 	function attachContracts(
1217 		address _tokenAddress,
1218 		address _marketplaceAddress,
1219 		address _workerPoolHubAddress,
1220 		address _appHubAddress,
1221 		address _datasetHubAddress)
1222 	public onlyCategoriesCreator
1223 	{
1224 		require(address(rlc) == address(0));
1225 		rlc                = RLC          (_tokenAddress        );
1226 		marketplace        = Marketplace  (_marketplaceAddress  );
1227 		workerPoolHub      = WorkerPoolHub(_workerPoolHubAddress);
1228 		appHub             = AppHub       (_appHubAddress       );
1229 		datasetHub         = DatasetHub   (_datasetHubAddress   );
1230 
1231 	}
1232 
1233 	function setCategoriesCreator(address _categoriesCreator)
1234 	public onlyCategoriesCreator
1235 	{
1236 		m_categoriesCreator = _categoriesCreator;
1237 	}
1238 	/**
1239 	 * Factory
1240 	 */
1241 
1242 	function createCategory(
1243 		string  _name,
1244 		string  _description,
1245 		uint256 _workClockTimeRef)
1246 	public onlyCategoriesCreator returns (uint256 catid)
1247 	{
1248 		m_categoriesCount                  = m_categoriesCount.add(1);
1249 		IexecLib.Category storage category = m_categories[m_categoriesCount];
1250 		category.catid                     = m_categoriesCount;
1251 		category.name                      = _name;
1252 		category.description               = _description;
1253 		category.workClockTimeRef          = _workClockTimeRef;
1254 		emit CreateCategory(m_categoriesCount, _name, _description, _workClockTimeRef);
1255 		return m_categoriesCount;
1256 	}
1257 
1258 	function createWorkerPool(
1259 		string  _description,
1260 		uint256 _subscriptionLockStakePolicy,
1261 		uint256 _subscriptionMinimumStakePolicy,
1262 		uint256 _subscriptionMinimumScorePolicy)
1263 	external returns (address createdWorkerPool)
1264 	{
1265 		address newWorkerPool = workerPoolHub.createWorkerPool(
1266 			_description,
1267 			_subscriptionLockStakePolicy,
1268 			_subscriptionMinimumStakePolicy,
1269 			_subscriptionMinimumScorePolicy,
1270 			address(marketplace)
1271 		);
1272 		emit CreateWorkerPool(tx.origin, newWorkerPool, _description);
1273 		return newWorkerPool;
1274 	}
1275 
1276 	function createApp(
1277 		string  _appName,
1278 		uint256 _appPrice,
1279 		string  _appParams)
1280 	external returns (address createdApp)
1281 	{
1282 		address newApp = appHub.createApp(
1283 			_appName,
1284 			_appPrice,
1285 			_appParams
1286 		);
1287 		emit CreateApp(tx.origin, newApp, _appName, _appPrice, _appParams);
1288 		return newApp;
1289 	}
1290 
1291 	function createDataset(
1292 		string  _datasetName,
1293 		uint256 _datasetPrice,
1294 		string  _datasetParams)
1295 	external returns (address createdDataset)
1296 	{
1297 		address newDataset = datasetHub.createDataset(
1298 			_datasetName,
1299 			_datasetPrice,
1300 			_datasetParams
1301 			);
1302 		emit CreateDataset(tx.origin, newDataset, _datasetName, _datasetPrice, _datasetParams);
1303 		return newDataset;
1304 	}
1305 
1306 	/**
1307 	 * WorkOrder Emission
1308 	 */
1309 	function buyForWorkOrder(
1310 		uint256 _marketorderIdx,
1311 		address _workerpool,
1312 		address _app,
1313 		address _dataset,
1314 		string  _params,
1315 		address _callback,
1316 		address _beneficiary)
1317 	external returns (address)
1318 	{
1319 		address requester = msg.sender;
1320 		require(marketplace.consumeMarketOrderAsk(_marketorderIdx, requester, _workerpool));
1321 
1322 		uint256 emitcost = lockWorkOrderCost(requester, _workerpool, _app, _dataset);
1323 
1324 		WorkOrder workorder = new WorkOrder(
1325 			_marketorderIdx,
1326 			requester,
1327 			_app,
1328 			_dataset,
1329 			_workerpool,
1330 			emitcost,
1331 			_params,
1332 			_callback,
1333 			_beneficiary
1334 		);
1335 
1336 		m_woidRegistered[workorder] = true;
1337 
1338 		require(WorkerPool(_workerpool).emitWorkOrder(workorder, _marketorderIdx));
1339 
1340 		emit WorkOrderActivated(workorder, _workerpool);
1341 		return workorder;
1342 	}
1343 
1344 	function isWoidRegistred(address _woid) public view returns (bool)
1345 	{
1346 		return m_woidRegistered[_woid];
1347 	}
1348 
1349 	function lockWorkOrderCost(
1350 		address _requester,
1351 		address _workerpool, // Address of a smartcontract
1352 		address _app,        // Address of a smartcontract
1353 		address _dataset)    // Address of a smartcontract
1354 	internal returns (uint256)
1355 	{
1356 		// APP
1357 		App app = App(_app);
1358 		require(appHub.isAppRegistered (_app));
1359 		// initialize usercost with dapp price
1360 		uint256 emitcost = app.m_appPrice();
1361 
1362 		// DATASET
1363 		if (_dataset != address(0)) // address(0) → no dataset
1364 		{
1365 			Dataset dataset = Dataset(_dataset);
1366 			require(datasetHub.isDatasetRegistred(_dataset));
1367 			// add optional datasetPrice for userCost
1368 			emitcost = emitcost.add(dataset.m_datasetPrice());
1369 		}
1370 
1371 		// WORKERPOOL
1372 		require(workerPoolHub.isWorkerPoolRegistered(_workerpool));
1373 
1374 		require(lock(_requester, emitcost)); // Lock funds for app + dataset payment
1375 
1376 		return emitcost;
1377 	}
1378 
1379 	/**
1380 	 * WorkOrder life cycle
1381 	 */
1382 
1383 	function claimFailedConsensus(address _woid)
1384 	public onlyRegisteredWoid(_woid) returns (bool)
1385 	{
1386 		WorkOrder  workorder  = WorkOrder(_woid);
1387 		require(workorder.m_requester() == msg.sender);
1388 		WorkerPool workerpool = WorkerPool(workorder.m_workerpool());
1389 
1390 		IexecLib.WorkOrderStatusEnum currentStatus = workorder.m_status();
1391 		require(currentStatus == IexecLib.WorkOrderStatusEnum.ACTIVE || currentStatus == IexecLib.WorkOrderStatusEnum.REVEALING);
1392 		// Unlock stakes for all workers
1393 		require(workerpool.claimFailedConsensus(_woid));
1394 		workorder.claim(); // revert on error
1395 
1396 		/* uint256 value           = marketplace.getMarketOrderValue(workorder.m_marketorderIdx()); // revert if not exist */
1397 		/* address workerpoolOwner = marketplace.getMarketOrderWorkerpoolOwner(workorder.m_marketorderIdx()); // revert if not exist */
1398 		uint256 value;
1399 		address workerpoolOwner;
1400 		(,,,value,,,,workerpoolOwner) = marketplace.getMarketOrder(workorder.m_marketorderIdx()); // Single call cost less gas
1401 		uint256 workerpoolStake = value.percentage(marketplace.ASK_STAKE_RATIO());
1402 
1403 		require(unlock (workorder.m_requester(), value.add(workorder.m_emitcost()))); // UNLOCK THE FUNDS FOR REINBURSEMENT
1404 		require(seize  (workerpoolOwner,         workerpoolStake));
1405 		// put workerpoolOwner stake seize into iexecHub address for bonus for scheduler on next well finalized Task
1406 		require(reward (this,                    workerpoolStake));
1407 		require(lock   (this,                    workerpoolStake));
1408 
1409 		emit WorkOrderClaimed(_woid, workorder.m_workerpool());
1410 		return true;
1411 	}
1412 
1413 	function finalizeWorkOrder(
1414 		address _woid,
1415 		string  _stdout,
1416 		string  _stderr,
1417 		string  _uri)
1418 	public onlyRegisteredWoid(_woid) returns (bool)
1419 	{
1420 		WorkOrder workorder = WorkOrder(_woid);
1421 		require(workorder.m_workerpool() == msg.sender);
1422 		require(workorder.m_status()     == IexecLib.WorkOrderStatusEnum.REVEALING);
1423 
1424 		// APP
1425 		App     app      = App(workorder.m_app());
1426 		uint256 appPrice = app.m_appPrice();
1427 		if (appPrice > 0)
1428 		{
1429 			require(reward(app.m_owner(), appPrice));
1430 		}
1431 
1432 		// DATASET
1433 		Dataset dataset = Dataset(workorder.m_dataset());
1434 		if (dataset != address(0))
1435 		{
1436 			uint256 datasetPrice = dataset.m_datasetPrice();
1437 			if (datasetPrice > 0)
1438 			{
1439 				require(reward(dataset.m_owner(), datasetPrice));
1440 			}
1441 		}
1442 
1443 		// WORKERPOOL → rewarding done by the caller itself
1444 
1445 		/**
1446 		 * seize stacked funds from requester.
1447 		 * reward = value: was locked at market making
1448 		 * emitcost: was locked at when emiting the workorder
1449 		 */
1450 		/* uint256 value           = marketplace.getMarketOrderValue(workorder.m_marketorderIdx()); // revert if not exist */
1451 		/* address workerpoolOwner = marketplace.getMarketOrderWorkerpoolOwner(workorder.m_marketorderIdx()); // revert if not exist */
1452 		uint256 value;
1453 		address workerpoolOwner;
1454 		(,,,value,,,,workerpoolOwner) = marketplace.getMarketOrder(workorder.m_marketorderIdx()); // Single call cost less gas
1455 		uint256 workerpoolStake       = value.percentage(marketplace.ASK_STAKE_RATIO());
1456 
1457 		require(seize (workorder.m_requester(), value.add(workorder.m_emitcost()))); // seize funds for payment (market value + emitcost)
1458 		require(unlock(workerpoolOwner,         workerpoolStake)); // unlock scheduler stake
1459 
1460 		// write results
1461 		workorder.setResult(_stdout, _stderr, _uri); // revert on error
1462 
1463 		// Rien ne se perd, rien ne se crée, tout se transfere
1464 		// distribute bonus to scheduler. jackpot bonus come from scheduler stake loose on IexecHub contract
1465 		// we reuse the varaible value for the kitty / fraction of the kitty (stack too deep)
1466 		/* (,value) = checkBalance(this); // kitty is locked on `this` wallet */
1467 		value = m_accounts[this].locked; // kitty is locked on `this` wallet
1468 		if(value > 0)
1469 		{
1470 			value = value.min(value.percentage(STAKE_BONUS_RATIO).max(STAKE_BONUS_MIN_THRESHOLD));
1471 			require(seize(this,             value));
1472 			require(reward(workerpoolOwner, value));
1473 		}
1474 
1475 		emit WorkOrderCompleted(_woid, workorder.m_workerpool());
1476 		return true;
1477 	}
1478 
1479 	/**
1480 	 * Views
1481 	 */
1482 	function getCategoryWorkClockTimeRef(uint256 _catId) public view returns (uint256 workClockTimeRef)
1483 	{
1484 		require(existingCategory(_catId));
1485 		return m_categories[_catId].workClockTimeRef;
1486 	}
1487 
1488 	function existingCategory(uint256 _catId) public view  returns (bool categoryExist)
1489 	{
1490 		return m_categories[_catId].catid > 0;
1491 	}
1492 
1493 	function getCategory(uint256 _catId) public view returns (uint256 catid, string name, string  description, uint256 workClockTimeRef)
1494 	{
1495 		require(existingCategory(_catId));
1496 		return (
1497 			m_categories[_catId].catid,
1498 			m_categories[_catId].name,
1499 			m_categories[_catId].description,
1500 			m_categories[_catId].workClockTimeRef
1501 		);
1502 	}
1503 
1504 	function getWorkerStatus(address _worker) public view returns (address workerPool, uint256 workerScore)
1505 	{
1506 		return (workerPoolHub.getWorkerAffectation(_worker), m_scores[_worker]);
1507 	}
1508 
1509 	function getWorkerScore(address _worker) public view returns (uint256 workerScore)
1510 	{
1511 		return m_scores[_worker];
1512 	}
1513 
1514 	/**
1515 	 * Worker subscription
1516 	 */
1517 	function registerToPool(address _worker) public returns (bool subscribed)
1518 	// msg.sender = workerPool
1519 	{
1520 		WorkerPool workerpool = WorkerPool(msg.sender);
1521 		// Check credentials
1522 		require(workerPoolHub.isWorkerPoolRegistered(msg.sender));
1523 		// Lock worker deposit
1524 		require(lock(_worker, workerpool.m_subscriptionLockStakePolicy()));
1525 		// Check subscription policy
1526 		require(m_accounts[_worker].stake >= workerpool.m_subscriptionMinimumStakePolicy());
1527 		require(m_scores[_worker]         >= workerpool.m_subscriptionMinimumScorePolicy());
1528 		// Update affectation
1529 		require(workerPoolHub.registerWorkerAffectation(msg.sender, _worker));
1530 		// Trigger event notice
1531 		emit WorkerPoolSubscription(msg.sender, _worker);
1532 		return true;
1533 	}
1534 
1535 	function unregisterFromPool(address _worker) public returns (bool unsubscribed)
1536 	// msg.sender = workerPool
1537 	{
1538 		require(removeWorker(msg.sender, _worker));
1539 		// Trigger event notice
1540 		emit WorkerPoolUnsubscription(msg.sender, _worker);
1541 		return true;
1542 	}
1543 
1544 	function evictWorker(address _worker) public returns (bool unsubscribed)
1545 	// msg.sender = workerpool
1546 	{
1547 		require(removeWorker(msg.sender, _worker));
1548 		// Trigger event notice
1549 		emit WorkerPoolEviction(msg.sender, _worker);
1550 		return true;
1551 	}
1552 
1553 	function removeWorker(address _workerpool, address _worker) internal returns (bool unsubscribed)
1554 	{
1555 		WorkerPool workerpool = WorkerPool(_workerpool);
1556 		// Check credentials
1557 		require(workerPoolHub.isWorkerPoolRegistered(_workerpool));
1558 		// Unlick worker stake
1559 		require(unlock(_worker, workerpool.m_subscriptionLockStakePolicy()));
1560 		// Update affectation
1561 		require(workerPoolHub.unregisterWorkerAffectation(_workerpool, _worker));
1562 		return true;
1563 	}
1564 
1565 	/**
1566 	 * Stake, reward and penalty functions
1567 	 */
1568 	/* Marketplace */
1569 	function lockForOrder(address _user, uint256 _amount) public onlyMarketplace returns (bool)
1570 	{
1571 		require(lock(_user, _amount));
1572 		return true;
1573 	}
1574 	function unlockForOrder(address _user, uint256 _amount) public  onlyMarketplace returns (bool)
1575 	{
1576 		require(unlock(_user, _amount));
1577 		return true;
1578 	}
1579 	/* Work */
1580 	function lockForWork(address _woid, address _user, uint256 _amount) public onlyRegisteredWoid(_woid) returns (bool)
1581 	{
1582 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
1583 		require(lock(_user, _amount));
1584 		return true;
1585 	}
1586 	function unlockForWork(address _woid, address _user, uint256 _amount) public onlyRegisteredWoid(_woid) returns (bool)
1587 	{
1588 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
1589 		require(unlock(_user, _amount));
1590 		return true;
1591 	}
1592 	function rewardForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public onlyRegisteredWoid(_woid) returns (bool)
1593 	{
1594 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
1595 		require(reward(_worker, _amount));
1596 		if (_reputation)
1597 		{
1598 			m_contributionHistory.success = m_contributionHistory.success.add(1);
1599 			m_scores[_worker] = m_scores[_worker].add(1);
1600 			emit AccurateContribution(_woid, _worker);
1601 		}
1602 		return true;
1603 	}
1604 	function seizeForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public onlyRegisteredWoid(_woid) returns (bool)
1605 	{
1606 		require(WorkOrder(_woid).m_workerpool() == msg.sender);
1607 		require(seize(_worker, _amount));
1608 		if (_reputation)
1609 		{
1610 			m_contributionHistory.failed = m_contributionHistory.failed.add(1);
1611 			m_scores[_worker] = m_scores[_worker].sub(m_scores[_worker].min(SCORE_UNITARY_SLASH));
1612 			emit FaultyContribution(_woid, _worker);
1613 		}
1614 		return true;
1615 	}
1616 	/**
1617 	 * Wallet methods: public
1618 	 */
1619 	function deposit(uint256 _amount) external returns (bool)
1620 	{
1621 		require(rlc.transferFrom(msg.sender, address(this), _amount));
1622 		m_accounts[msg.sender].stake = m_accounts[msg.sender].stake.add(_amount);
1623 		emit Deposit(msg.sender, _amount);
1624 		return true;
1625 	}
1626 	function withdraw(uint256 _amount) external returns (bool)
1627 	{
1628 		m_accounts[msg.sender].stake = m_accounts[msg.sender].stake.sub(_amount);
1629 		require(rlc.transfer(msg.sender, _amount));
1630 		emit Withdraw(msg.sender, _amount);
1631 		return true;
1632 	}
1633 	function checkBalance(address _owner) public view returns (uint256 stake, uint256 locked)
1634 	{
1635 		return (m_accounts[_owner].stake, m_accounts[_owner].locked);
1636 	}
1637 	/**
1638 	 * Wallet methods: Internal
1639 	 */
1640 	function reward(address _user, uint256 _amount) internal returns (bool)
1641 	{
1642 		m_accounts[_user].stake = m_accounts[_user].stake.add(_amount);
1643 		emit Reward(_user, _amount);
1644 		return true;
1645 	}
1646 	function seize(address _user, uint256 _amount) internal returns (bool)
1647 	{
1648 		m_accounts[_user].locked = m_accounts[_user].locked.sub(_amount);
1649 		emit Seize(_user, _amount);
1650 		return true;
1651 	}
1652 	function lock(address _user, uint256 _amount) internal returns (bool)
1653 	{
1654 		m_accounts[_user].stake  = m_accounts[_user].stake.sub(_amount);
1655 		m_accounts[_user].locked = m_accounts[_user].locked.add(_amount);
1656 		return true;
1657 	}
1658 	function unlock(address _user, uint256 _amount) internal returns (bool)
1659 	{
1660 		m_accounts[_user].locked = m_accounts[_user].locked.sub(_amount);
1661 		m_accounts[_user].stake  = m_accounts[_user].stake.add(_amount);
1662 		return true;
1663 	}
1664 }
1665 
1666 
1667 
1668 pragma solidity ^0.4.21;
1669 
1670 contract IexecCallbackInterface
1671 {
1672 
1673 	function workOrderCallback(
1674 		address _woid,
1675 		string  _stdout,
1676 		string  _stderr,
1677 		string  _uri) public returns (bool);
1678 
1679 	event WorkOrderCallback(address woid, string stdout, string stderr, string uri);
1680 }
1681 
1682 pragma solidity ^0.4.21;
1683 
1684 
1685 contract WorkerPool is OwnableOZ, IexecHubAccessor, MarketplaceAccessor
1686 {
1687 	using SafeMathOZ for uint256;
1688 
1689 
1690 	/**
1691 	 * Members
1692 	 */
1693 	string                      public m_description;
1694 	uint256                     public m_stakeRatioPolicy;               // % of reward to stake
1695 	uint256                     public m_schedulerRewardRatioPolicy;     // % of reward given to scheduler
1696 	uint256                     public m_subscriptionLockStakePolicy;    // Stake locked when in workerpool - Constant set by constructor, do not update
1697 	uint256                     public m_subscriptionMinimumStakePolicy; // Minimum stake for subscribing
1698 	uint256                     public m_subscriptionMinimumScorePolicy; // Minimum score for subscribing
1699 	address[]                   public m_workers;
1700 	mapping(address => uint256) public m_workerIndex;
1701 
1702 	// mapping(woid => IexecLib.Consensus)
1703 	mapping(address => IexecLib.Consensus) public m_consensus;
1704 	// mapping(woid => worker address => Contribution);
1705 	mapping(address => mapping(address => IexecLib.Contribution)) public m_contributions;
1706 
1707 	uint256 public constant REVEAL_PERIOD_DURATION_RATIO  = 2;
1708 	uint256 public constant CONSENSUS_DURATION_RATIO      = 10;
1709 
1710 	/**
1711 	 * Address of slave/related contracts
1712 	 */
1713 	address        public  m_workerPoolHubAddress;
1714 
1715 
1716 	/**
1717 	 * Events
1718 	 */
1719 	event WorkerPoolPolicyUpdate(
1720 		uint256 oldStakeRatioPolicy,               uint256 newStakeRatioPolicy,
1721 		uint256 oldSchedulerRewardRatioPolicy,     uint256 newSchedulerRewardRatioPolicy,
1722 		uint256 oldSubscriptionMinimumStakePolicy, uint256 newSubscriptionMinimumStakePolicy,
1723 		uint256 oldSubscriptionMinimumScorePolicy, uint256 newSubscriptionMinimumScorePolicy);
1724 
1725 	event WorkOrderActive         (address indexed woid);
1726 	event WorkOrderClaimed        (address indexed woid);
1727 
1728 	event AllowWorkerToContribute (address indexed woid, address indexed worker, uint256 workerScore);
1729 	event Contribute              (address indexed woid, address indexed worker, bytes32 resultHash);
1730 	event RevealConsensus         (address indexed woid, bytes32 consensus);
1731 	event Reveal                  (address indexed woid, address indexed worker, bytes32 result);
1732 	event Reopen                  (address indexed woid);
1733   event FinalizeWork            (address indexed woid, string stdout, string stderr, string uri);
1734 
1735 
1736 
1737 	event WorkerSubscribe         (address indexed worker);
1738 	event WorkerUnsubscribe       (address indexed worker);
1739 	event WorkerEviction          (address indexed worker);
1740 
1741 	/**
1742 	 * Methods
1743 	 */
1744 	// Constructor
1745 	function WorkerPool(
1746 		address _iexecHubAddress,
1747 		string  _description,
1748 		uint256 _subscriptionLockStakePolicy,
1749 		uint256 _subscriptionMinimumStakePolicy,
1750 		uint256 _subscriptionMinimumScorePolicy,
1751 		address _marketplaceAddress)
1752 	IexecHubAccessor(_iexecHubAddress)
1753 	MarketplaceAccessor(_marketplaceAddress)
1754 	public
1755 	{
1756 		// tx.origin == owner
1757 		// msg.sender ==  WorkerPoolHub
1758 		require(tx.origin != msg.sender);
1759 		setImmutableOwnership(tx.origin); // owner → tx.origin
1760 
1761 		m_description                    = _description;
1762 		m_stakeRatioPolicy               = 30; // % of the work order price to stake
1763 		m_schedulerRewardRatioPolicy     = 1;  // % of the work reward going to scheduler vs workers reward
1764 		m_subscriptionLockStakePolicy    = _subscriptionLockStakePolicy; // only at creation. cannot be change to respect lock/unlock of worker stake
1765 		m_subscriptionMinimumStakePolicy = _subscriptionMinimumStakePolicy;
1766 		m_subscriptionMinimumScorePolicy = _subscriptionMinimumScorePolicy;
1767 		m_workerPoolHubAddress           = msg.sender;
1768 
1769 	}
1770 
1771 	function changeWorkerPoolPolicy(
1772 		uint256 _newStakeRatioPolicy,
1773 		uint256 _newSchedulerRewardRatioPolicy,
1774 		uint256 _newSubscriptionMinimumStakePolicy,
1775 		uint256 _newSubscriptionMinimumScorePolicy)
1776 	public onlyOwner
1777 	{
1778 		emit WorkerPoolPolicyUpdate(
1779 			m_stakeRatioPolicy,               _newStakeRatioPolicy,
1780 			m_schedulerRewardRatioPolicy,     _newSchedulerRewardRatioPolicy,
1781 			m_subscriptionMinimumStakePolicy, _newSubscriptionMinimumStakePolicy,
1782 			m_subscriptionMinimumScorePolicy, _newSubscriptionMinimumScorePolicy
1783 		);
1784 		require(_newSchedulerRewardRatioPolicy <= 100);
1785 		m_stakeRatioPolicy               = _newStakeRatioPolicy;
1786 		m_schedulerRewardRatioPolicy     = _newSchedulerRewardRatioPolicy;
1787 		m_subscriptionMinimumStakePolicy = _newSubscriptionMinimumStakePolicy;
1788 		m_subscriptionMinimumScorePolicy = _newSubscriptionMinimumScorePolicy;
1789 	}
1790 
1791 	/************************* worker list management **************************/
1792 	function getWorkerAddress(uint _index) public view returns (address)
1793 	{
1794 		return m_workers[_index];
1795 	}
1796 	function getWorkerIndex(address _worker) public view returns (uint)
1797 	{
1798 		uint index = m_workerIndex[_worker];
1799 		require(m_workers[index] == _worker);
1800 		return index;
1801 	}
1802 	function getWorkersCount() public view returns (uint)
1803 	{
1804 		return m_workers.length;
1805 	}
1806 
1807 	function subscribeToPool() public returns (bool)
1808 	{
1809 		// msg.sender = worker
1810 		require(iexecHubInterface.registerToPool(msg.sender));
1811 		uint index = m_workers.push(msg.sender);
1812 		m_workerIndex[msg.sender] = index.sub(1);
1813 		emit WorkerSubscribe(msg.sender);
1814 		return true;
1815 	}
1816 
1817 	function unsubscribeFromPool() public  returns (bool)
1818 	{
1819 		// msg.sender = worker
1820 		require(iexecHubInterface.unregisterFromPool(msg.sender));
1821 		require(removeWorker(msg.sender));
1822 		emit WorkerUnsubscribe(msg.sender);
1823 		return true;
1824 	}
1825 
1826 	function evictWorker(address _worker) public onlyOwner returns (bool)
1827 	{
1828 		// msg.sender = scheduler
1829 		require(iexecHubInterface.evictWorker(_worker));
1830 		require(removeWorker(_worker));
1831 		emit WorkerEviction(_worker);
1832 		return true;
1833 	}
1834 
1835 	function removeWorker(address _worker) internal returns (bool)
1836 	{
1837 		uint index = getWorkerIndex(_worker); // fails if worker not registered
1838 		address lastWorker = m_workers[m_workers.length.sub(1)];
1839 		m_workers    [index     ] = lastWorker;
1840 		m_workerIndex[lastWorker] = index;
1841 		delete m_workers[m_workers.length.sub(1)];
1842 		m_workers.length = m_workers.length.sub(1);
1843 		return true;
1844 	}
1845 
1846 	function getConsensusDetails(address _woid) public view returns (
1847 		uint256 c_poolReward,
1848 		uint256 c_stakeAmount,
1849 		bytes32 c_consensus,
1850 		uint256 c_revealDate,
1851 		uint256 c_revealCounter,
1852 		uint256 c_consensusTimeout,
1853 		uint256 c_winnerCount,
1854 		address c_workerpoolOwner)
1855 	{
1856 		IexecLib.Consensus storage consensus = m_consensus[_woid];
1857 		return (
1858 			consensus.poolReward,
1859 			consensus.stakeAmount,
1860 			consensus.consensus,
1861 			consensus.revealDate,
1862 			consensus.revealCounter,
1863 			consensus.consensusTimeout,
1864 			consensus.winnerCount,
1865 			consensus.workerpoolOwner
1866 		);
1867 	}
1868 
1869 	function getContributorsCount(address _woid) public view returns (uint256 contributorsCount)
1870 	{
1871 		return m_consensus[_woid].contributors.length;
1872 	}
1873 
1874 	function getContributor(address _woid, uint256 index) public view returns (address contributor)
1875 	{
1876 		return m_consensus[_woid].contributors[index];
1877 	}
1878 
1879 	function existingContribution(address _woid, address _worker) public view  returns (bool contributionExist)
1880 	{
1881 		return m_contributions[_woid][_worker].status != IexecLib.ContributionStatusEnum.UNSET;
1882 	}
1883 
1884 	function getContribution(address _woid, address _worker) public view returns
1885 	(
1886 		IexecLib.ContributionStatusEnum status,
1887 		bytes32 resultHash,
1888 		bytes32 resultSign,
1889 		address enclaveChallenge,
1890 		uint256 score,
1891 		uint256 weight)
1892 	{
1893 		require(existingContribution(_woid, _worker)); // no silent value returned
1894 		IexecLib.Contribution storage contribution = m_contributions[_woid][_worker];
1895 		return (
1896 			contribution.status,
1897 			contribution.resultHash,
1898 			contribution.resultSign,
1899 			contribution.enclaveChallenge,
1900 			contribution.score,
1901 			contribution.weight
1902 		);
1903 	}
1904 
1905 
1906 	/**************************** Works management *****************************/
1907 	function emitWorkOrder(address _woid, uint256 _marketorderIdx) public onlyIexecHub returns (bool)
1908 	{
1909 		uint256 catid   = marketplaceInterface.getMarketOrderCategory(_marketorderIdx);
1910 		uint256 timeout = iexecHubInterface.getCategoryWorkClockTimeRef(catid).mul(CONSENSUS_DURATION_RATIO).add(now);
1911 
1912 		IexecLib.Consensus storage consensus = m_consensus[_woid];
1913 		consensus.poolReward                 = marketplaceInterface.getMarketOrderValue(_marketorderIdx);
1914 		consensus.workerpoolOwner            = marketplaceInterface.getMarketOrderWorkerpoolOwner(_marketorderIdx);
1915 		consensus.stakeAmount                = consensus.poolReward.percentage(m_stakeRatioPolicy);
1916 		consensus.consensusTimeout            = timeout;
1917 		consensus.schedulerRewardRatioPolicy = m_schedulerRewardRatioPolicy;
1918 
1919 		emit WorkOrderActive(_woid);
1920 
1921 		return true;
1922 	}
1923 
1924 	function claimFailedConsensus(address _woid) public onlyIexecHub returns (bool)
1925 	{
1926 	  IexecLib.Consensus storage consensus = m_consensus[_woid];
1927 		require(now > consensus.consensusTimeout);
1928 		uint256 i;
1929 		address w;
1930 		for (i = 0; i < consensus.contributors.length; ++i)
1931 		{
1932 			w = consensus.contributors[i];
1933 			if (m_contributions[_woid][w].status != IexecLib.ContributionStatusEnum.AUTHORIZED)
1934 			{
1935 				require(iexecHubInterface.unlockForWork(_woid, w, consensus.stakeAmount));
1936 			}
1937 		}
1938 		emit WorkOrderClaimed(_woid);
1939 		return true;
1940 	}
1941 
1942 	function allowWorkersToContribute(address _woid, address[] _workers, address _enclaveChallenge) public onlyOwner /*onlySheduler*/ returns (bool)
1943 	{
1944 		for (uint i = 0; i < _workers.length; ++i)
1945 		{
1946 			require(allowWorkerToContribute(_woid, _workers[i], _enclaveChallenge));
1947 		}
1948 		return true;
1949 	}
1950 
1951 	function allowWorkerToContribute(address _woid, address _worker, address _enclaveChallenge) public onlyOwner /*onlySheduler*/ returns (bool)
1952 	{
1953 		require(iexecHubInterface.isWoidRegistred(_woid));
1954 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.ACTIVE);
1955 		IexecLib.Contribution storage contribution = m_contributions[_woid][_worker];
1956 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
1957 		require(now <= consensus.consensusTimeout);
1958 
1959 		address workerPool;
1960 		uint256 workerScore;
1961 		(workerPool, workerScore) = iexecHubInterface.getWorkerStatus(_worker); // workerPool, workerScore
1962 		require(workerPool == address(this));
1963 
1964 		require(contribution.status == IexecLib.ContributionStatusEnum.UNSET);
1965 		contribution.status           = IexecLib.ContributionStatusEnum.AUTHORIZED;
1966 		contribution.enclaveChallenge = _enclaveChallenge;
1967 
1968 		emit AllowWorkerToContribute(_woid, _worker, workerScore);
1969 		return true;
1970 	}
1971 
1972 	function contribute(address _woid, bytes32 _resultHash, bytes32 _resultSign, uint8 _v, bytes32 _r, bytes32 _s) public returns (uint256 workerStake)
1973 	{
1974 		require(iexecHubInterface.isWoidRegistred(_woid));
1975 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
1976 		require(now <= consensus.consensusTimeout);
1977 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.ACTIVE); // can't contribute on a claimed or completed workorder
1978 		IexecLib.Contribution storage contribution = m_contributions[_woid][msg.sender];
1979 
1980 		// msg.sender = a worker
1981 		require(_resultHash != 0x0);
1982 		require(_resultSign != 0x0);
1983 		if (contribution.enclaveChallenge != address(0))
1984 		{
1985 			require(contribution.enclaveChallenge == ecrecover(keccak256("\x19Ethereum Signed Message:\n64", _resultHash, _resultSign), _v, _r, _s));
1986 		}
1987 
1988 		require(contribution.status == IexecLib.ContributionStatusEnum.AUTHORIZED);
1989 		contribution.status     = IexecLib.ContributionStatusEnum.CONTRIBUTED;
1990 		contribution.resultHash = _resultHash;
1991 		contribution.resultSign = _resultSign;
1992 		contribution.score      = iexecHubInterface.getWorkerScore(msg.sender);
1993 		consensus.contributors.push(msg.sender);
1994 
1995 		require(iexecHubInterface.lockForWork(_woid, msg.sender, consensus.stakeAmount));
1996 		emit Contribute(_woid, msg.sender, _resultHash);
1997 		return consensus.stakeAmount;
1998 	}
1999 
2000 	function revealConsensus(address _woid, bytes32 _consensus) public onlyOwner /*onlySheduler*/ returns (bool)
2001 	{
2002 		require(iexecHubInterface.isWoidRegistred(_woid));
2003 		IexecLib.Consensus storage consensus = m_consensus[_woid];
2004 		require(now <= consensus.consensusTimeout);
2005 		require(WorkOrder(_woid).startRevealingPhase());
2006 
2007 		consensus.winnerCount = 0;
2008 		for (uint256 i = 0; i<consensus.contributors.length; ++i)
2009 		{
2010 			address w = consensus.contributors[i];
2011 			if (
2012 				m_contributions[_woid][w].resultHash == _consensus
2013 				&&
2014 				m_contributions[_woid][w].status == IexecLib.ContributionStatusEnum.CONTRIBUTED // REJECTED contribution must not be count
2015 			)
2016 			{
2017 				consensus.winnerCount = consensus.winnerCount.add(1);
2018 			}
2019 		}
2020 		require(consensus.winnerCount > 0); // you cannot revealConsensus if no worker has contributed to this hash
2021 
2022 		consensus.consensus  = _consensus;
2023 		consensus.revealDate = iexecHubInterface.getCategoryWorkClockTimeRef(marketplaceInterface.getMarketOrderCategory(WorkOrder(_woid).m_marketorderIdx())).mul(REVEAL_PERIOD_DURATION_RATIO).add(now); // is it better to store th catid ?
2024 		emit RevealConsensus(_woid, _consensus);
2025 		return true;
2026 	}
2027 
2028 	function reveal(address _woid, bytes32 _result) public returns (bool)
2029 	{
2030 		require(iexecHubInterface.isWoidRegistred(_woid));
2031 		IexecLib.Consensus    storage consensus    = m_consensus[_woid];
2032 		require(now <= consensus.consensusTimeout);
2033 		IexecLib.Contribution storage contribution = m_contributions[_woid][msg.sender];
2034 
2035 		require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.REVEALING     );
2036 		require(consensus.revealDate        >  now                                        );
2037 		require(contribution.status         == IexecLib.ContributionStatusEnum.CONTRIBUTED);
2038 		require(contribution.resultHash     == consensus.consensus                        );
2039 		require(contribution.resultHash     == keccak256(_result                        ) );
2040 		require(contribution.resultSign     == keccak256(_result ^ keccak256(msg.sender)) );
2041 
2042 		contribution.status     = IexecLib.ContributionStatusEnum.PROVED;
2043 		consensus.revealCounter = consensus.revealCounter.add(1);
2044 
2045 		emit Reveal(_woid, msg.sender, _result);
2046 		return true;
2047 	}
2048 
2049 	function reopen(address _woid) public onlyOwner /*onlySheduler*/ returns (bool)
2050 	{
2051 		require(iexecHubInterface.isWoidRegistred(_woid));
2052 		IexecLib.Consensus storage consensus = m_consensus[_woid];
2053 		require(now <= consensus.consensusTimeout);
2054 		require(consensus.revealDate <= now && consensus.revealCounter == 0);
2055 		require(WorkOrder(_woid).reActivate());
2056 
2057 		for (uint256 i = 0; i < consensus.contributors.length; ++i)
2058 		{
2059 			address w = consensus.contributors[i];
2060 			if (m_contributions[_woid][w].resultHash == consensus.consensus)
2061 			{
2062 				m_contributions[_woid][w].status = IexecLib.ContributionStatusEnum.REJECTED;
2063 			}
2064 		}
2065 		// Reset to status before revealConsensus. Must be after REJECTED traitement above because of consensus.consensus check
2066 		consensus.winnerCount = 0;
2067 		consensus.consensus   = 0x0;
2068 		consensus.revealDate  = 0;
2069 		emit Reopen(_woid);
2070 		return true;
2071 	}
2072 
2073 	// if sheduler never call finalized ? no incetive to do that. schedulermust be pay also at this time
2074 	function finalizeWork(address _woid, string _stdout, string _stderr, string _uri) public onlyOwner /*onlySheduler*/ returns (bool)
2075 	{
2076 		require(iexecHubInterface.isWoidRegistred(_woid));
2077 		IexecLib.Consensus storage consensus = m_consensus[_woid];
2078 		require(now <= consensus.consensusTimeout);
2079 		require((consensus.revealDate <= now && consensus.revealCounter > 0) || (consensus.revealCounter == consensus.winnerCount)); // consensus.winnerCount never 0 at this step
2080 
2081 		// add penalized to the call worker to contribution and they never contribute ?
2082 		require(distributeRewards(_woid, consensus));
2083 
2084 		require(iexecHubInterface.finalizeWorkOrder(_woid, _stdout, _stderr, _uri));
2085 		emit FinalizeWork(_woid,_stdout,_stderr,_uri);
2086 		return true;
2087 	}
2088 
2089 	function distributeRewards(address _woid, IexecLib.Consensus _consensus) internal returns (bool)
2090 	{
2091 		uint256 i;
2092 		address w;
2093 		uint256 workerBonus;
2094 		uint256 workerWeight;
2095 		uint256 totalWeight;
2096 		uint256 individualWorkerReward;
2097 		uint256 totalReward = _consensus.poolReward;
2098 		address[] memory contributors = _consensus.contributors;
2099 		for (i = 0; i<contributors.length; ++i)
2100 		{
2101 			w = contributors[i];
2102 			IexecLib.Contribution storage c = m_contributions[_woid][w];
2103 			if (c.status == IexecLib.ContributionStatusEnum.PROVED)
2104 			{
2105 				workerBonus  = (c.enclaveChallenge != address(0)) ? 3 : 1; // TODO: bonus sgx = 3 ?
2106 				workerWeight = 1 + c.score.mul(workerBonus).log();
2107 				totalWeight  = totalWeight.add(workerWeight);
2108 				c.weight     = workerWeight; // store so we don't have to recompute
2109 			}
2110 			else // ContributionStatusEnum.REJECT or ContributionStatusEnum.CONTRIBUTED (not revealed)
2111 			{
2112 				totalReward = totalReward.add(_consensus.stakeAmount);
2113 			}
2114 		}
2115 		require(totalWeight > 0);
2116 
2117 		// compute how much is going to the workers
2118 		uint256 totalWorkersReward = totalReward.percentage(uint256(100).sub(_consensus.schedulerRewardRatioPolicy));
2119 
2120 		for (i = 0; i<contributors.length; ++i)
2121 		{
2122 			w = contributors[i];
2123 			if (m_contributions[_woid][w].status == IexecLib.ContributionStatusEnum.PROVED)
2124 			{
2125 				individualWorkerReward = totalWorkersReward.mulByFraction(m_contributions[_woid][w].weight, totalWeight);
2126 				totalReward  = totalReward.sub(individualWorkerReward);
2127 				require(iexecHubInterface.unlockForWork(_woid, w, _consensus.stakeAmount));
2128 				require(iexecHubInterface.rewardForWork(_woid, w, individualWorkerReward, true));
2129 			}
2130 			else // WorkStatusEnum.POCO_REJECT or ContributionStatusEnum.CONTRIBUTED (not revealed)
2131 			{
2132 				require(iexecHubInterface.seizeForWork(_woid, w, _consensus.stakeAmount, true));
2133 				// No Reward
2134 			}
2135 		}
2136 		// totalReward now contains the scheduler share
2137 		require(iexecHubInterface.rewardForWork(_woid, _consensus.workerpoolOwner, totalReward, false));
2138 
2139 		return true;
2140 	}
2141 
2142 }
2143 
2144 
2145 pragma solidity ^0.4.21;
2146 
2147 
2148 contract Marketplace is IexecHubAccessor
2149 {
2150 	using SafeMathOZ for uint256;
2151 
2152 	/**
2153 	 * Marketplace
2154 	 */
2155 	uint                                 public m_orderCount;
2156 	mapping(uint =>IexecLib.MarketOrder) public m_orderBook;
2157 
2158 	uint256 public constant ASK_STAKE_RATIO  = 30;
2159 
2160 	/**
2161 	 * Events
2162 	 */
2163 	event MarketOrderCreated   (uint marketorderIdx);
2164 	event MarketOrderClosed    (uint marketorderIdx);
2165 	event MarketOrderAskConsume(uint marketorderIdx, address requester);
2166 
2167 	/**
2168 	 * Constructor
2169 	 */
2170 	function Marketplace(address _iexecHubAddress)
2171 	IexecHubAccessor(_iexecHubAddress)
2172 	public
2173 	{
2174 	}
2175 
2176 	/**
2177 	 * Market orders
2178 	 */
2179 	function createMarketOrder(
2180 		IexecLib.MarketOrderDirectionEnum _direction,
2181 		uint256 _category,
2182 		uint256 _trust,
2183 		uint256 _value,
2184 		address _workerpool,
2185 		uint256 _volume)
2186 	public returns (uint)
2187 	{
2188 		require(iexecHubInterface.existingCategory(_category));
2189 		require(_volume >0);
2190 		m_orderCount = m_orderCount.add(1);
2191 		IexecLib.MarketOrder storage marketorder    = m_orderBook[m_orderCount];
2192 		marketorder.direction      = _direction;
2193 		marketorder.category       = _category;
2194 		marketorder.trust          = _trust;
2195 		marketorder.value          = _value;
2196 		marketorder.volume         = _volume;
2197 		marketorder.remaining      = _volume;
2198 
2199 		if (_direction == IexecLib.MarketOrderDirectionEnum.ASK)
2200 		{
2201 			require(WorkerPool(_workerpool).m_owner() == msg.sender);
2202 
2203 			require(iexecHubInterface.lockForOrder(msg.sender, _value.percentage(ASK_STAKE_RATIO).mul(_volume))); // mul must be done after percentage to avoid rounding errors
2204 			marketorder.workerpool      = _workerpool;
2205 			marketorder.workerpoolOwner = msg.sender;
2206 		}
2207 		else
2208 		{
2209 			// no BID implementation
2210 			revert();
2211 		}
2212 		emit MarketOrderCreated(m_orderCount);
2213 		return m_orderCount;
2214 	}
2215 
2216 	function closeMarketOrder(uint256 _marketorderIdx) public returns (bool)
2217 	{
2218 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
2219 		if (marketorder.direction == IexecLib.MarketOrderDirectionEnum.ASK)
2220 		{
2221 			require(marketorder.workerpoolOwner == msg.sender);
2222 			require(iexecHubInterface.unlockForOrder(marketorder.workerpoolOwner, marketorder.value.percentage(ASK_STAKE_RATIO).mul(marketorder.remaining))); // mul must be done after percentage to avoid rounding errors
2223 		}
2224 		else
2225 		{
2226 			// no BID implementation
2227 			revert();
2228 		}
2229 		marketorder.direction = IexecLib.MarketOrderDirectionEnum.CLOSED;
2230 		emit MarketOrderClosed(_marketorderIdx);
2231 		return true;
2232 	}
2233 
2234 
2235 	/**
2236 	 * Assets consumption
2237 	 */
2238 	function consumeMarketOrderAsk(
2239 		uint256 _marketorderIdx,
2240 		address _requester,
2241 		address _workerpool)
2242 	public onlyIexecHub returns (bool)
2243 	{
2244 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
2245 		require(marketorder.direction  == IexecLib.MarketOrderDirectionEnum.ASK);
2246 		require(marketorder.remaining  >  0);
2247 		require(marketorder.workerpool == _workerpool);
2248 
2249 		marketorder.remaining = marketorder.remaining.sub(1);
2250 		if (marketorder.remaining == 0)
2251 		{
2252 			marketorder.direction = IexecLib.MarketOrderDirectionEnum.CLOSED;
2253 		}
2254 		require(iexecHubInterface.lockForOrder(_requester, marketorder.value));
2255 		emit MarketOrderAskConsume(_marketorderIdx, _requester);
2256 		return true;
2257 	}
2258 
2259 	function existingMarketOrder(uint256 _marketorderIdx) public view  returns (bool marketOrderExist)
2260 	{
2261 		return m_orderBook[_marketorderIdx].category > 0;
2262 	}
2263 
2264 	/**
2265 	 * Views
2266 	 */
2267 	function getMarketOrderValue(uint256 _marketorderIdx) public view returns (uint256)
2268 	{
2269 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
2270 		return m_orderBook[_marketorderIdx].value;
2271 	}
2272 	function getMarketOrderWorkerpoolOwner(uint256 _marketorderIdx) public view returns (address)
2273 	{
2274 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
2275 		return m_orderBook[_marketorderIdx].workerpoolOwner;
2276 	}
2277 	function getMarketOrderCategory(uint256 _marketorderIdx) public view returns (uint256)
2278 	{
2279 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
2280 		return m_orderBook[_marketorderIdx].category;
2281 	}
2282 	function getMarketOrderTrust(uint256 _marketorderIdx) public view returns (uint256)
2283 	{
2284 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
2285 		return m_orderBook[_marketorderIdx].trust;
2286 	}
2287 	function getMarketOrder(uint256 _marketorderIdx) public view returns
2288 	(
2289 		IexecLib.MarketOrderDirectionEnum direction,
2290 		uint256 category,       // runtime selection
2291 		uint256 trust,          // for PoCo
2292 		uint256 value,          // value/cost/price
2293 		uint256 volume,         // quantity of instances (total)
2294 		uint256 remaining,      // remaining instances
2295 		address workerpool,     // BID can use null for any
2296 		address workerpoolOwner)
2297 	{
2298 		require(existingMarketOrder(_marketorderIdx)); // no silent value returned
2299 		IexecLib.MarketOrder storage marketorder = m_orderBook[_marketorderIdx];
2300 		return (
2301 			marketorder.direction,
2302 			marketorder.category,
2303 			marketorder.trust,
2304 			marketorder.value,
2305 			marketorder.volume,
2306 			marketorder.remaining,
2307 			marketorder.workerpool,
2308 			marketorder.workerpoolOwner
2309 		);
2310 	}
2311 
2312 	/**
2313 	 * Callback Proof managment
2314 	 */
2315 
2316 	event WorkOrderCallbackProof(address indexed woid, address requester, address beneficiary,address indexed callbackTo, address indexed gasCallbackProvider,string stdout, string stderr , string uri);
2317 
2318 	//mapping(workorder => bool)
2319 	 mapping(address => bool) m_callbackDone;
2320 
2321 	 function isCallbackDone(address _woid) public view  returns (bool callbackDone)
2322 	 {
2323 		 return m_callbackDone[_woid];
2324 	 }
2325 
2326 	 function workOrderCallback(address _woid,string _stdout, string _stderr, string _uri) public
2327 	 {
2328 		 require(iexecHubInterface.isWoidRegistred(_woid));
2329 		 require(!isCallbackDone(_woid));
2330 		 m_callbackDone[_woid] = true;
2331 		 require(WorkOrder(_woid).m_status() == IexecLib.WorkOrderStatusEnum.COMPLETED);
2332 		 require(WorkOrder(_woid).m_resultCallbackProof() == keccak256(_stdout,_stderr,_uri));
2333 		 address callbackTo =WorkOrder(_woid).m_callback();
2334 		 require(callbackTo != address(0));
2335 		 require(IexecCallbackInterface(callbackTo).workOrderCallback(
2336 			 _woid,
2337 			 _stdout,
2338 			 _stderr,
2339 			 _uri
2340 		 ));
2341 		 emit WorkOrderCallbackProof(_woid,WorkOrder(_woid).m_requester(),WorkOrder(_woid).m_beneficiary(),callbackTo,tx.origin,_stdout,_stderr,_uri);
2342 	 }
2343 
2344 }