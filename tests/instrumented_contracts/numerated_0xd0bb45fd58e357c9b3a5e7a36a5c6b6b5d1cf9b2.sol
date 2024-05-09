1 //v1.0.14
2 //License: Apache2.0
3 
4 
5 pragma solidity ^0.4.8;
6 
7 contract TokenSpender {
8     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
9 }
10 
11 pragma solidity ^0.4.8;
12 
13 contract ERC20 {
14   uint public totalSupply;
15   function balanceOf(address who) constant returns (uint);
16   function allowance(address owner, address spender) constant returns (uint);
17 
18   function transfer(address to, uint value) returns (bool ok);
19   function transferFrom(address from, address to, uint value) returns (bool ok);
20   function approve(address spender, uint value) returns (bool ok);
21   event Transfer(address indexed from, address indexed to, uint value);
22   event Approval(address indexed owner, address indexed spender, uint value);
23 }
24 
25 pragma solidity ^0.4.8;
26 
27 contract SafeMath {
28   function safeMul(uint a, uint b) internal returns (uint) {
29     uint c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function safeDiv(uint a, uint b) internal returns (uint) {
35     assert(b > 0);
36     uint c = a / b;
37     assert(a == b * c + a % b);
38     return c;
39   }
40 
41   function safeSub(uint a, uint b) internal returns (uint) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function safeAdd(uint a, uint b) internal returns (uint) {
47     uint c = a + b;
48     assert(c>=a && c>=b);
49     return c;
50   }
51 
52   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
53     return a >= b ? a : b;
54   }
55 
56   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
57     return a < b ? a : b;
58   }
59 
60   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
61     return a >= b ? a : b;
62   }
63 
64   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
65     return a < b ? a : b;
66   }
67 
68   function assert(bool assertion) internal {
69     if (!assertion) {
70       throw;
71     }
72   }
73 }
74 
75 pragma solidity ^0.4.21;
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  * last open zepplin version used for : add sub mul div function : https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
82 * commit : https://github.com/OpenZeppelin/zeppelin-solidity/commit/815d9e1f457f57cfbb1b4e889f2255c9a517f661
83  */
84 library SafeMathOZ
85 {
86 	function add(uint256 a, uint256 b) internal pure returns (uint256)
87 	{
88 		uint256 c = a + b;
89 		assert(c >= a);
90 		return c;
91 	}
92 
93 	function sub(uint256 a, uint256 b) internal pure returns (uint256)
94 	{
95 		assert(b <= a);
96 		return a - b;
97 	}
98 
99 	function mul(uint256 a, uint256 b) internal pure returns (uint256)
100 	{
101 		if (a == 0)
102 		{
103 			return 0;
104 		}
105 		uint256 c = a * b;
106 		assert(c / a == b);
107 		return c;
108 	}
109 
110 	function div(uint256 a, uint256 b) internal pure returns (uint256)
111 	{
112 		// assert(b > 0); // Solidity automatically throws when dividing by 0
113 		uint256 c = a / b;
114 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
115 		return c;
116 	}
117 
118 	function max(uint256 a, uint256 b) internal pure returns (uint256)
119 	{
120 		return a >= b ? a : b;
121 	}
122 
123 	function min(uint256 a, uint256 b) internal pure returns (uint256)
124 	{
125 		return a < b ? a : b;
126 	}
127 
128 	function mulByFraction(uint256 a, uint256 b, uint256 c) internal pure returns (uint256)
129 	{
130 		return div(mul(a, b), c);
131 	}
132 
133 	function percentage(uint256 a, uint256 b) internal pure returns (uint256)
134 	{
135 		return mulByFraction(a, b, 100);
136 	}
137 	// Source : https://ethereum.stackexchange.com/questions/8086/logarithm-math-operation-in-solidity
138 	function log(uint x) internal pure returns (uint y)
139 	{
140 		assembly
141 		{
142 			let arg := x
143 			x := sub(x,1)
144 			x := or(x, div(x, 0x02))
145 			x := or(x, div(x, 0x04))
146 			x := or(x, div(x, 0x10))
147 			x := or(x, div(x, 0x100))
148 			x := or(x, div(x, 0x10000))
149 			x := or(x, div(x, 0x100000000))
150 			x := or(x, div(x, 0x10000000000000000))
151 			x := or(x, div(x, 0x100000000000000000000000000000000))
152 			x := add(x, 1)
153 			let m := mload(0x40)
154 			mstore(m,           0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
155 			mstore(add(m,0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
156 			mstore(add(m,0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
157 			mstore(add(m,0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
158 			mstore(add(m,0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
159 			mstore(add(m,0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
160 			mstore(add(m,0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
161 			mstore(add(m,0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
162 			mstore(0x40, add(m, 0x100))
163 			let magic := 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
164 			let shift := 0x100000000000000000000000000000000000000000000000000000000000000
165 			let a := div(mul(x, magic), shift)
166 			y := div(mload(add(m,sub(255,a))), shift)
167 			y := add(y, mul(256, gt(arg, 0x8000000000000000000000000000000000000000000000000000000000000000)))
168 		}
169 	}
170 }
171 
172 
173 pragma solidity ^0.4.8;
174 
175 contract Ownable {
176   address public owner;
177 
178   function Ownable() {
179     owner = msg.sender;
180   }
181 
182   modifier onlyOwner() {
183     if (msg.sender == owner)
184       _;
185   }
186 
187   function transferOwnership(address newOwner) onlyOwner {
188     if (newOwner != address(0)) owner = newOwner;
189   }
190 
191 }
192 
193 pragma solidity ^0.4.21;
194 
195 /**
196  * @title Ownable
197  * @dev The Ownable contract has an owner address, and provides basic authorization control
198  * functions, this simplifies the implementation of "user permissions".
199  */
200 contract OwnableOZ
201 {
202 	address public m_owner;
203 	bool    public m_changeable;
204 
205 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
206 
207 	/**
208 	 * @dev Throws if called by any account other than the owner.
209 	 */
210 	modifier onlyOwner()
211 	{
212 		require(msg.sender == m_owner);
213 		_;
214 	}
215 
216 	/**
217 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
218 	 * account.
219 	 */
220 	function OwnableOZ() public
221 	{
222 		m_owner      = msg.sender;
223 		m_changeable = true;
224 	}
225 
226 	/**
227 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
228 	 * @param _newOwner The address to transfer ownership to.
229 	 */
230 	function setImmutableOwnership(address _newOwner) public onlyOwner
231 	{
232 		require(m_changeable);
233 		require(_newOwner != address(0));
234 		emit OwnershipTransferred(m_owner, _newOwner);
235 		m_owner      = _newOwner;
236 		m_changeable = false;
237 	}
238 
239 }
240 
241 
242 pragma solidity ^0.4.8;
243 
244 contract RLC is ERC20, SafeMath, Ownable {
245 
246     /* Public variables of the token */
247   string public name;       //fancy name
248   string public symbol;
249   uint8 public decimals;    //How many decimals to show.
250   string public version = 'v0.1';
251   uint public initialSupply;
252   uint public totalSupply;
253   bool public locked;
254   //uint public unlockBlock;
255 
256   mapping(address => uint) balances;
257   mapping (address => mapping (address => uint)) allowed;
258 
259   // lock transfer during the ICO
260   modifier onlyUnlocked() {
261     if (msg.sender != owner && locked) throw;
262     _;
263   }
264 
265   /*
266    *  The RLC Token created with the time at which the crowdsale end
267    */
268 
269   function RLC() {
270     // lock the transfer function during the crowdsale
271     locked = true;
272     //unlockBlock=  now + 45 days; // (testnet) - for mainnet put the block number
273 
274     initialSupply = 87000000000000000;
275     totalSupply = initialSupply;
276     balances[msg.sender] = initialSupply;// Give the creator all initial tokens
277     name = 'iEx.ec Network Token';        // Set the name for display purposes
278     symbol = 'RLC';                       // Set the symbol for display purposes
279     decimals = 9;                        // Amount of decimals for display purposes
280   }
281 
282   function unlock() onlyOwner {
283     locked = false;
284   }
285 
286   function burn(uint256 _value) returns (bool){
287     balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
288     totalSupply = safeSub(totalSupply, _value);
289     Transfer(msg.sender, 0x0, _value);
290     return true;
291   }
292 
293   function transfer(address _to, uint _value) onlyUnlocked returns (bool) {
294     balances[msg.sender] = safeSub(balances[msg.sender], _value);
295     balances[_to] = safeAdd(balances[_to], _value);
296     Transfer(msg.sender, _to, _value);
297     return true;
298   }
299 
300   function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool) {
301     var _allowance = allowed[_from][msg.sender];
302 
303     balances[_to] = safeAdd(balances[_to], _value);
304     balances[_from] = safeSub(balances[_from], _value);
305     allowed[_from][msg.sender] = safeSub(_allowance, _value);
306     Transfer(_from, _to, _value);
307     return true;
308   }
309 
310   function balanceOf(address _owner) constant returns (uint balance) {
311     return balances[_owner];
312   }
313 
314   function approve(address _spender, uint _value) returns (bool) {
315     allowed[msg.sender][_spender] = _value;
316     Approval(msg.sender, _spender, _value);
317     return true;
318   }
319 
320     /* Approve and then comunicate the approved contract in a single tx */
321   function approveAndCall(address _spender, uint256 _value, bytes _extraData){
322       TokenSpender spender = TokenSpender(_spender);
323       if (approve(_spender, _value)) {
324           spender.receiveApproval(msg.sender, _value, this, _extraData);
325       }
326   }
327 
328   function allowance(address _owner, address _spender) constant returns (uint remaining) {
329     return allowed[_owner][_spender];
330   }
331 
332 }
333 
334 
335 pragma solidity ^0.4.21;
336 
337 
338 contract IexecHubInterface
339 {
340 	RLC public rlc;
341 
342 	function attachContracts(
343 		address _tokenAddress,
344 		address _marketplaceAddress,
345 		address _workerPoolHubAddress,
346 		address _appHubAddress,
347 		address _datasetHubAddress)
348 		public;
349 
350 	function setCategoriesCreator(
351 		address _categoriesCreator)
352 	public;
353 
354 	function createCategory(
355 		string  _name,
356 		string  _description,
357 		uint256 _workClockTimeRef)
358 	public returns (uint256 catid);
359 
360 	function createWorkerPool(
361 		string  _description,
362 		uint256 _subscriptionLockStakePolicy,
363 		uint256 _subscriptionMinimumStakePolicy,
364 		uint256 _subscriptionMinimumScorePolicy)
365 	external returns (address createdWorkerPool);
366 
367 	function createApp(
368 		string  _appName,
369 		uint256 _appPrice,
370 		string  _appParams)
371 	external returns (address createdApp);
372 
373 	function createDataset(
374 		string  _datasetName,
375 		uint256 _datasetPrice,
376 		string  _datasetParams)
377 	external returns (address createdDataset);
378 
379 	function buyForWorkOrder(
380 		uint256 _marketorderIdx,
381 		address _workerpool,
382 		address _app,
383 		address _dataset,
384 		string  _params,
385 		address _callback,
386 		address _beneficiary)
387 	external returns (address);
388 
389 	function isWoidRegistred(
390 		address _woid)
391 	public view returns (bool);
392 
393 	function lockWorkOrderCost(
394 		address _requester,
395 		address _workerpool, // Address of a smartcontract
396 		address _app,        // Address of a smartcontract
397 		address _dataset)    // Address of a smartcontract
398 	internal returns (uint256);
399 
400 	function claimFailedConsensus(
401 		address _woid)
402 	public returns (bool);
403 
404 	function finalizeWorkOrder(
405 		address _woid,
406 		string  _stdout,
407 		string  _stderr,
408 		string  _uri)
409 	public returns (bool);
410 
411 	function getCategoryWorkClockTimeRef(
412 		uint256 _catId)
413 	public view returns (uint256 workClockTimeRef);
414 
415 	function existingCategory(
416 		uint256 _catId)
417 	public view  returns (bool categoryExist);
418 
419 	function getCategory(
420 		uint256 _catId)
421 		public view returns (uint256 catid, string name, string  description, uint256 workClockTimeRef);
422 
423 	function getWorkerStatus(
424 		address _worker)
425 	public view returns (address workerPool, uint256 workerScore);
426 
427 	function getWorkerScore(address _worker) public view returns (uint256 workerScore);
428 
429 	function registerToPool(address _worker) public returns (bool subscribed);
430 
431 	function unregisterFromPool(address _worker) public returns (bool unsubscribed);
432 
433 	function evictWorker(address _worker) public returns (bool unsubscribed);
434 
435 	function removeWorker(address _workerpool, address _worker) internal returns (bool unsubscribed);
436 
437 	function lockForOrder(address _user, uint256 _amount) public returns (bool);
438 
439 	function unlockForOrder(address _user, uint256 _amount) public returns (bool);
440 
441 	function lockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
442 
443 	function unlockForWork(address _woid, address _user, uint256 _amount) public returns (bool);
444 
445 	function rewardForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
446 
447 	function seizeForWork(address _woid, address _worker, uint256 _amount, bool _reputation) public returns (bool);
448 
449 	function deposit(uint256 _amount) external returns (bool);
450 
451 	function withdraw(uint256 _amount) external returns (bool);
452 
453 	function checkBalance(address _owner) public view returns (uint256 stake, uint256 locked);
454 
455 	function reward(address _user, uint256 _amount) internal returns (bool);
456 
457 	function seize(address _user, uint256 _amount) internal returns (bool);
458 
459 	function lock(address _user, uint256 _amount) internal returns (bool);
460 
461 	function unlock(address _user, uint256 _amount) internal returns (bool);
462 }
463 
464 
465 
466 pragma solidity ^0.4.21;
467 
468 
469 contract IexecHubAccessor
470 {
471 	IexecHubInterface internal iexecHubInterface;
472 
473 	modifier onlyIexecHub()
474 	{
475 		require(msg.sender == address(iexecHubInterface));
476 		_;
477 	}
478 
479 	function IexecHubAccessor(address _iexecHubAddress) public
480 	{
481 		require(_iexecHubAddress != address(0));
482 		iexecHubInterface = IexecHubInterface(_iexecHubAddress);
483 	}
484 
485 }
486 
487 
488 
489 pragma solidity ^0.4.21;
490 
491 
492 contract Dataset is OwnableOZ, IexecHubAccessor
493 {
494 
495 	/**
496 	 * Members
497 	 */
498 	string            public m_datasetName;
499 	uint256           public m_datasetPrice;
500 	string            public m_datasetParams;
501 
502 	/**
503 	 * Constructor
504 	 */
505 	function Dataset(
506 		address _iexecHubAddress,
507 		string  _datasetName,
508 		uint256 _datasetPrice,
509 		string  _datasetParams)
510 	IexecHubAccessor(_iexecHubAddress)
511 	public
512 	{
513 		// tx.origin == owner
514 		// msg.sender == DatasetHub
515 		require(tx.origin != msg.sender);
516 		setImmutableOwnership(tx.origin); // owner → tx.origin
517 
518 		m_datasetName   = _datasetName;
519 		m_datasetPrice  = _datasetPrice;
520 		m_datasetParams = _datasetParams;
521 
522 	}
523 
524 
525 }
526 
527 
528 pragma solidity ^0.4.21;
529 
530 
531 
532 contract DatasetHub is OwnableOZ // is Owned by IexecHub
533 {
534 	using SafeMathOZ for uint256;
535 
536 	/**
537 	 * Members
538 	 */
539 	mapping(address => uint256)                     m_datasetCountByOwner;
540 	mapping(address => mapping(uint256 => address)) m_datasetByOwnerByIndex;
541 	mapping(address => bool)                        m_datasetRegistered;
542 
543 	mapping(uint256 => address)                     m_datasetByIndex;
544 	uint256 public                                  m_totalDatasetCount;
545 
546 
547 
548 	/**
549 	 * Constructor
550 	 */
551 	function DatasetHub() public
552 	{
553 	}
554 
555 	/**
556 	 * Methods
557 	 */
558 	function isDatasetRegistred(address _dataset) public view returns (bool)
559 	{
560 		return m_datasetRegistered[_dataset];
561 	}
562 	function getDatasetsCount(address _owner) public view returns (uint256)
563 	{
564 		return m_datasetCountByOwner[_owner];
565 	}
566 	function getDataset(address _owner, uint256 _index) public view returns (address)
567 	{
568 		return m_datasetByOwnerByIndex[_owner][_index];
569 	}
570 	function getDatasetByIndex(uint256 _index) public view returns (address)
571 	{
572 		return m_datasetByIndex[_index];
573 	}
574 
575 	function addDataset(address _owner, address _dataset) internal
576 	{
577 		uint id = m_datasetCountByOwner[_owner].add(1);
578 		m_totalDatasetCount = m_totalDatasetCount.add(1);
579 		m_datasetByIndex       [m_totalDatasetCount] = _dataset;
580 		m_datasetCountByOwner  [_owner]              = id;
581 		m_datasetByOwnerByIndex[_owner][id]          = _dataset;
582 		m_datasetRegistered    [_dataset]            = true;
583 	}
584 
585 	function createDataset(
586 		string _datasetName,
587 		uint256 _datasetPrice,
588 		string _datasetParams)
589 	public onlyOwner /*owner == IexecHub*/ returns (address createdDataset)
590 	{
591 		// tx.origin == owner
592 		// msg.sender == IexecHub
593 		address newDataset = new Dataset(
594 			msg.sender,
595 			_datasetName,
596 			_datasetPrice,
597 			_datasetParams
598 		);
599 		addDataset(tx.origin, newDataset);
600 		return newDataset;
601 	}
602 }